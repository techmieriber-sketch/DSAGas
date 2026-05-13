$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

# Flyt fuldskærms-foto fra html::before til body::before (z-index: -1), og genskab html-fallbackfarve.
# Det undgår at baggrunden forsvinder når både html og body er transparent.

$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if ($text -notmatch 'html::before') { return }

  $t = $text -replace 'html::before', 'body::before'
  $t = [regex]::Replace($t, '(body::before\s*\{[\s\S]*?z-index:\s*)0(\s*;)', '${1}-1${2}', 1)

  $t = [regex]::Replace($t,
    '(scrollbar-gutter:\s*stable;\s*\r?\n\s*background:\s*)transparent(\s*;)',
    '${1}#0f1b24${2}',
    1)

  if ($t -ne $text) {
    [IO.File]::WriteAllText($path, $t, [Text.UTF8Encoding]::new($false))
    $n++
  }
}
Write-Host "Patched: $n"
