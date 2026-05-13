$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $t = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if (-not $t.Contains('trailing slash -  <base')) { return }
  $t2 = $t.Replace('trailing slash -  <base', 'trailing slash - <base')
  [IO.File]::WriteAllText($path, $t2, [Text.UTF8Encoding]::new($false))
  $n++
}
Write-Host "Spac fix: $n"
