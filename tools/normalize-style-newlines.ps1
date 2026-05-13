$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $raw = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  $text = [regex]::Replace($raw, "(?s)<style>(.*?)</style>", {
    param($m)
    $inner = $m.Groups[1].Value
    while ($inner -match "(\r?\n){3,}") {
      $inner = [regex]::Replace($inner, "(\r?\n){3,}", "`r`n`r`n")
    }
    $inner = [regex]::Replace($inner, "(\r?\n){2}(\s+[a-z\*])", "`r`n`${2}")
    return "<style>" + $inner + "</style>"
  })
  if ($text -ne $raw) {
    [IO.File]::WriteAllText($path, $text, [Text.UTF8Encoding]::new($false))
    $n++
  }
}
Write-Host "Normalized: $n"
