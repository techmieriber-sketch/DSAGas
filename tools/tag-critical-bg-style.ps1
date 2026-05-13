$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $t = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if ($t -notmatch 'html::after') { return }
  if ($t -match 'id="critical-bg-cover"') { return }
  $t2 = [regex]::Replace($t, '<style>', '<style id="critical-bg-cover">', 1)
  if ($t2 -eq $t) { return }
  [IO.File]::WriteAllText($path, $t2, [Text.UTF8Encoding]::new($false))
  $n++
}
Write-Host "critical-bg-cover id: $n filer"
