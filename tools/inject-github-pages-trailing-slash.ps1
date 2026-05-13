$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

$snippet = @"

    <script>
      /* GitHub Pages: /repo eller /repo/broed uden trailing slash giver forkert basis-URL for relative links */
      (function () {
        if (location.protocol !== "http:" && location.protocol !== "https:") return;
        var p = location.pathname;
        if (p.endsWith("/")) return;
        var last = p.slice(p.lastIndexOf("/") + 1);
        if (!last || last.indexOf(".") !== -1) return;
        location.replace(p + "/" + location.search + location.hash);
      })();
    </script>
"@

$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if ($text -match 'trailing slash giver forkert basis-URL') { return }

  $needles = @(
    '<meta name="viewport" content="width=device-width, initial-scale=1" />',
    '<meta name="viewport" content="width=device-width,initial-scale=1" />'
  )
  $text2 = $null
  foreach ($needle in $needles) {
    if ($text -like "*${needle}*" -and $text -notmatch 'trailing slash giver forkert basis-URL') {
      $text2 = $text.Replace($needle, $needle + $snippet)
      break
    }
  }
  if ($null -eq $text2) { return }
  if ($text2 -eq $text) { return }
  [IO.File]::WriteAllText($path, $text2, [Text.UTF8Encoding]::new($false))
  $n++
}
Write-Host "Injected redirect script: $n files"
