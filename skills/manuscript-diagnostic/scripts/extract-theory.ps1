param(
    [Parameter(Mandatory = $true)][string]$InputDocx,
    [Parameter(Mandatory = $true)][string]$OutputMarkdown
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$resolvedInput = (Resolve-Path -LiteralPath $InputDocx).Path
$archive = [System.IO.Compression.ZipFile]::OpenRead($resolvedInput)
try {
    $entry = $archive.GetEntry('word/document.xml')
    if (-not $entry) { throw 'The DOCX has no word/document.xml.' }
    $stream = $entry.Open()
    $reader = [System.IO.StreamReader]::new($stream)
    try { $xml = [xml]$reader.ReadToEnd() }
    finally { $reader.Dispose(); $stream.Dispose() }
}
finally { $archive.Dispose() }

$ns = [System.Xml.XmlNamespaceManager]::new($xml.NameTable)
$ns.AddNamespace('w', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')
$wordNs = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
$body = $xml.SelectSingleNode('//w:body', $ns)
if (-not $body) { throw 'The DOCX has no body.' }

function Get-ParagraphText([System.Xml.XmlNode]$Paragraph) {
    $pieces = [System.Collections.Generic.List[string]]::new()
    foreach ($node in $Paragraph.SelectNodes('.//w:t | .//w:tab | .//w:br', $ns)) {
        switch ($node.LocalName) {
            't' { $pieces.Add($node.InnerText) }
            'tab' { $pieces.Add("`t") }
            'br' { $pieces.Add('  ') }
        }
    }
    return ($pieces -join '')
}

$lines = [System.Collections.Generic.List[string]]::new()
foreach ($child in $body.ChildNodes) {
    if ($child.LocalName -eq 'p') {
        $value = Get-ParagraphText $child
        if (-not $value.Trim()) { continue }
        $styleNode = $child.SelectSingleNode('./w:pPr/w:pStyle', $ns)
        $style = if ($styleNode) { $styleNode.GetAttribute('val', $wordNs) } else { '' }
        $prefix = switch ($style) {
            'Title' { '# ' }
            'Heading1' { '## ' }
            'Heading2' { '### ' }
            'ListBullet' { '- ' }
            default { '' }
        }
        $lines.Add($prefix + $value.Trim())
        $lines.Add('')
    }
    elseif ($child.LocalName -eq 'tbl') {
        $rows = [System.Collections.Generic.List[object]]::new()
        foreach ($row in $child.SelectNodes('./w:tr', $ns)) {
            $cells = [System.Collections.Generic.List[string]]::new()
            foreach ($cell in $row.SelectNodes('./w:tc', $ns)) {
                $parts = foreach ($paragraph in $cell.SelectNodes('.//w:p', $ns)) {
                    $part = Get-ParagraphText $paragraph
                    if ($part.Trim()) { $part.Trim() }
                }
                $cells.Add((($parts -join '<br>') -replace '\|', '\|'))
            }
            $rows.Add($cells.ToArray())
        }
        if ($rows.Count -gt 0) {
            $width = ($rows | ForEach-Object { $_.Count } | Measure-Object -Maximum).Maximum
            foreach ($rowIndex in 0..($rows.Count - 1)) {
                $cells = @($rows[$rowIndex])
                while ($cells.Count -lt $width) { $cells += '' }
                $lines.Add('| ' + ($cells -join ' | ') + ' |')
                if ($rowIndex -eq 0) { $lines.Add('| ' + ((@('---') * $width) -join ' | ') + ' |') }
            }
            $lines.Add('')
        }
    }
}

$outputDir = Split-Path -Parent $OutputMarkdown
if (-not (Test-Path -LiteralPath $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }
$content = (($lines -join "`n").TrimEnd() + "`n")
[System.IO.File]::WriteAllText($OutputMarkdown, $content, [System.Text.UTF8Encoding]::new($false))
Write-Output "Extracted $($content.Length) characters from $resolvedInput"
