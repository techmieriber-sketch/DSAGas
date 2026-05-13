$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$re = [regex]'(min-height:\s*100vh;\s*\r?\n\s*background:\s*)#0f1b24(\s*;\s*\r?\n\s*font-family:\s*system-ui,\s*-apple-system,\s*"Segoe UI",\s*Arial,\s*sans-serif;)'
$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if ($text -notmatch 'html::before') { return }
  $text2 = $re.Replace($text, '${1}transparent${2}', 1)
  if ($text2 -ne $text) {
    [IO.File]::WriteAllText($path, $text2, [Text.UTF8Encoding]::new($false))
    $n++
  }
}
Write-Host "Updated: $n"
