$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $raw = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  $text = $raw

  if ($text -match '(?s)html\s*\{\s*\n\s*/\*[^\n]*\*/\s*\n\s*html::before\s*\{') {
    $text = [regex]::Replace($text,
      '(?s)(\s*)html\s*\{\s*\n\s*/\*[^\n]*\*/\s*\n\s*html::before\s*\{\s*content:\s*"";\s*position:\s*fixed;\s*inset:\s*0;\s*z-index:\s*0;\s*background-color:\s*#0f1b24;\s*background-image:\s*url\("([^"]+)"\);\s*background-size:\s*cover;\s*background-position:\s*center\s*center;\s*background-repeat:\s*no-repeat;\s*pointer-events:\s*none;\s*\}\s*\n\s*(margin:\s*0;)',
      {
        param($m)
        $ind = $m.Groups[1].Value
        $u = $m.Groups[2].Value
        $margin = $m.Groups[3].Value
        return ($ind + "html::before {" + "`r`n" +
          $ind + "  content: """";`r`n" +
          $ind + "  position: fixed;`r`n" +
          $ind + "  inset: 0;`r`n" +
          $ind + "  z-index: 0;`r`n" +
          $ind + "  background-color: #0f1b24;`r`n" +
          $ind + "  background-image: url(`"$u`");`r`n" +
          $ind + "  background-size: cover;`r`n" +
          $ind + "  background-position: center center;`r`n" +
          $ind + "  background-repeat: no-repeat;`r`n" +
          $ind + "  pointer-events: none;`r`n" +
          $ind + "}`r`n`r`n" +
          $ind + "html {`r`n" +
          $ind + "  " + $margin + "`r`n")
      },
      1)
  }

  $text = $text -replace "`r`n\.page-shell \{", "`r`n      .page-shell {"
  $text = $text -replace "`n\.page-shell \{", "`n      .page-shell {"

  $text = [regex]::Replace($text,
    '/\* Baggrund via html::before.*?\*/',
    '/* Static full-page background (avoids compositor flicker; same approach as Laesevejlederen) */')

  if ($text -ne $raw) {
    [IO.File]::WriteAllText($path, $text, [Text.UTF8Encoding]::new($false))
    $n++
  }
}
Write-Host "Patched: $n files"
