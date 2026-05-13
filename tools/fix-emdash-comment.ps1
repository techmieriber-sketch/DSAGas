$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$bad = [char]0x00E2 + [char]0x20AC + [char]0x2122  # common mojibake for em dash? wrong
# Replace Unicode em dash or broken triplet in comment
$patterns = @(
  [string]([char]0x2014)  # real em dash
  "â€""
)
$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $t = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  $orig = $t
  foreach ($p in $patterns) {
    $t = $t.Replace("mapper uden trailing slash $p ", "mapper uden trailing slash - ")
  }
  if ($t -ne $orig) {
    [IO.File]::WriteAllText($path, $t, [Text.UTF8Encoding]::new($false))
    $n++
  }
}
Write-Host "Fixed comment in $n files"
