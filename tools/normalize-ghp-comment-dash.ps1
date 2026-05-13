$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$rx = [regex]::new('(/\* GitHub Pages: mapper uden trailing slash).{1,12}?(\s*<base>)')
$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $t = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  $t2 = $rx.Replace($t, '${1} - ${2}', 1)
  if ($t2 -ne $t) {
    [IO.File]::WriteAllText($path, $t2, [Text.UTF8Encoding]::new($false))
    $n++
  }
}
Write-Host "Fixed dash in $n files"
