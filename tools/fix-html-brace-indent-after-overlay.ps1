$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$bad = @"
        pointer-events: none;
      }
html {
"@
$good = @"
        pointer-events: none;
      }
      html {
"@
$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $t = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if (-not $t.Contains($bad)) { return }
  $t2 = $t.Replace($bad, $good)
  [IO.File]::WriteAllText($path, $t2, [Text.UTF8Encoding]::new($false))
  $n++
}
Write-Host "Rettet html-indrykning: $n filer"
