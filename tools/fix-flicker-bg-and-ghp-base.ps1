$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

$rxGhpScript = [regex]@'
(?s)<script>\s*/\* GitHub Pages: /repo eller /repo/broed uden trailing slash giver forkert basis-URL for relative links \*/\s*\(function \(\) \{\s*if \(location\.protocol[^\}]*?location\.replace\([^;]+;\s*\}\)\(\);\s*</script>
'@.Trim()

$newGhpScript = @'
    <script>
      /* GitHub Pages: mapper uden trailing slash - <base> + replaceState retter relative URL'er uden ekstra page load (mindre flicker). */
      (function () {
        if (location.protocol !== "http:" && location.protocol !== "https:") return;
        var p = location.pathname;
        if (p.endsWith("/")) return;
        var last = p.slice(p.lastIndexOf("/") + 1);
        if (!last || last.indexOf(".") !== -1) return;
        var withSlash = p + "/";
        var b = document.createElement("base");
        b.href = location.origin + withSlash;
        document.head.insertBefore(b, document.head.firstChild);
        history.replaceState(null, "", withSlash + location.search + location.hash);
      })();
    </script>
'@

$rxBodyZ = New-Object System.Text.RegularExpressions.Regex(
  '(body\s*\{\s*[^}]*?position:\s*relative;\s*)z-index:\s*1;',
  [System.Text.RegularExpressions.RegexOptions]::Singleline
)

$n = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if ($text -notmatch 'body::before') { return }

  $t = $rxGhpScript.Replace($text, $newGhpScript, 1)
  $t = $t.Replace('body::before', 'html::before')
  $t = [regex]::Replace($t, 'z-index:\s*-1', 'z-index: 0', 1)
  $t = $rxBodyZ.Replace($t, '${1}z-index: 2;', 1)

  if ($t -ne $text) {
    [IO.File]::WriteAllText($path, $t, [Text.UTF8Encoding]::new($false))
    $n++
  }
}
Write-Host "Patched: $n html files"
