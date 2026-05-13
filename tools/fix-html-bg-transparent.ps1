$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if ($text -notmatch 'html::before') { return }

  $text2 = $text -replace 'scrollbar-gutter:\s*stable;\s*\r?\n\s*background:\s*#0f1b24\s*;',
    ("scrollbar-gutter: stable;" + "`r`n        background: transparent;")

  if ($text2 -ne $text) {
    [IO.File]::WriteAllText($path, $text2, [Text.UTF8Encoding]::new($false))
    $n++
  }
}
Write-Host "html block background transparent: $n"
