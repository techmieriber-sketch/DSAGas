$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

$insert = @'

      html::after {
        content: "";
        position: fixed;
        inset: 0;
        z-index: 1;
        background: linear-gradient(
          rgba(30, 144, 255, 0.08),
          rgba(30, 144, 255, 0.08)
        );
        pointer-events: none;
      }

'@

# Indsæt html::after lige efter html::before-blokken (som i DSA Serviceassistent / Læsevejlederen).
# Group 1 må ikke sluge mellemrum foran "html {" — ellers mistes indrykning.
$rx = [regex]'(html::before\s*\{[\s\S]*?pointer-events:\s*none;\s*\})(\s*html\s*\{)'

$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $t = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if ($t -notmatch 'html::before') { return }
  if ($t -match 'html::after') { return }
  if (-not $rx.IsMatch($t)) {
    Write-Warning "Skip (pattern): $path"
    return
  }
  $t2 = $rx.Replace($t, '${1}' + $insert + '${2}', 1)
  if ($t2 -eq $t) { return }
  [IO.File]::WriteAllText($path, $t2, [Text.UTF8Encoding]::new($false))
  $n++
}

Write-Host "html::after lag tilfojet: $n filer"
