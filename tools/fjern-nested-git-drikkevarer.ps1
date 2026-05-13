# Dobbeltklik denne fil hvis GitHub Desktop viser drikkevarer som submodule / [+].
# Den sletter KUN skjulte .git i drikkevarer - ikke billeder eller html.

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$drik = Join-Path $root "drikkevarer"
$gitPath = Join-Path $drik ".git"

if (-not (Test-Path $gitPath)) {
  Write-Host "OK: Ingen drikkevarer\.git - intet at fjerne."
  exit 0
}

Remove-Item -LiteralPath $gitPath -Recurse -Force
Write-Host "Fjernet drikkevarer\.git. Luk og abn GitHub Desktop."
