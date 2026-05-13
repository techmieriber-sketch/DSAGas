$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$snippetTemplate = @'
        /* Static full-page background (avoids compositor flicker; same approach as Laesevejlederen) */
        html::before {{
          content: "";
          position: fixed;
          inset: 0;
          z-index: 0;
          background-color: #0f1b24;
          background-image: url("{0}");
          background-size: cover;
          background-position: center center;
          background-repeat: no-repeat;
          pointer-events: none;
        }}

'@

function Escape-UrlForCss([string]$u) {
  return $u.Replace('\', '\\').Replace('"', '\"')
}

function Ensure-BodyZIndex([string]$text) {
  return [regex]::Replace($text, 'body\s*\{[^}]*\}', {
    param($m)
    $block = $m.Value
    if ($block -match '\bz-index\s*:') { return $block }
    return $block -replace '(position:\s*relative;)(\s*)', "`$1`n        z-index: 1;`$2"
  }, 1)
}

$changed = 0
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  if ($_.FullName -match '\\tools\\') { return }
  $path = $_.FullName
  $raw = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false))
  if ($raw -match 'Static full-page background' -and $raw -match 'html::before') { return }

  $text = $raw
  $url = $null

  if ($text -match 'var FILE = "([^"]+)"') { $url = $Matches[1] }

  if (-not $url -and $text -match '<img class="bg-image"[^>]*src="([^"]*)"') {
    $cand = $Matches[1].Trim()
    if ($cand) { $url = $cand }
  }

  if (-not $url -and $text -match '(?s)document\.documentElement\.style\.setProperty\(\s*"--bg-image",\s*`url\("\$\{assetPath\("([^"]+)"\)\}"\)`\s*\)') {
    $url = $Matches[1]
    $text = [regex]::Replace($text, '(?s)\s*document\.documentElement\.style\.setProperty\(\s*"--bg-image",\s*`url\("\$\{assetPath\("[^"]+"\)\}"\)`\s*\);\s*\r?\n', "`n", 1)
    $text = [regex]::Replace($text, '(?s)\s*const bgPreload = document\.getElementById\("bg-preload"\);\s*\r?\n\s*if \(bgPreload\) bgPreload\.href = assetPath\("[^"]+"\);\s*\r?\n', "`n", 1)
  }

  if (-not $url -and $text -match '<link rel="preload" href="([^"]+\.(?:png|jpe?g|webp|gif|avif))" as="image"') {
    $u = $Matches[1]
    if ($u -notmatch '^https?://') { $url = $u }
  }

  if (-not $url -and $text -match '(?s)\.bg-media\s*\{[^}]*url\(([''"]?)([^''"\)]+)\1\)') {
    $u = $Matches[2].Trim()
    if ($u -notmatch '^https?://') { $url = $u }
  }

  if (-not $url) { return }

  if ($text -match 'html::before') { return }

  $text = [regex]::Replace($text, '<link rel="preload" id="[^"]+" href="" as="image" />\s*\r?\n?', '')
  $escPath = [regex]::Escape($url)
  if ($text -notmatch "<link rel=`"preload`" href=`"$escPath`" as=`"image`"") {
    if ($text -match '<link rel="preload" id="bg-preload" href="" as="image" />') {
      $text = $text -replace '<link rel="preload" id="bg-preload" href="" as="image" />',
        "<link rel=`"preload`" href=`"$url`" as=`"image`" fetchpriority=`"high`" />"
    }
    elseif ($text -match '<meta name="viewport" content="width=device-width, initial-scale=1" />') {
      $text = $text -replace '<meta name="viewport" content="width=device-width, initial-scale=1" />',
        ('<meta name="viewport" content="width=device-width, initial-scale=1" />' + "`n    <link rel=`"preload`" href=`"$url`" as=`"image`" fetchpriority=`"high`" />")
    }
  } else {
    $text = [regex]::Replace($text, "<link rel=`"preload`" href=`"$escPath`" as=`"image`"(\s*fetchpriority=`"high`")?(\s*)/>", "<link rel=`"preload`" href=`"$url`" as=`"image`" fetchpriority=`"high`" />", 1)
  }

  $snip = $snippetTemplate -f (Escape-UrlForCss $url)
  $msnip = $snip
  $inj = [regex]::Replace($text, '(\s*)(html\s*\{\s*\r?\n\s*margin:\s*0;)', {
    param($match)
    $match.Groups[1].Value + $msnip + "`r`n" + $match.Groups[2].Value
  }, 1)
  if ($inj -eq $text) { return }
  $text = $inj
  $text = Ensure-BodyZIndex $text
  $text = [regex]::Replace($text, '[ \t]*\.bg-media\s*\{[^}]*\}\r?\n', '')
  $text = [regex]::Replace($text, '[ \t]*\.bg-image\s*\{[^}]*\}\r?\n', '')
  $text = [regex]::Replace($text, '\s*--bg-image:\s*none;\s*\r?\n', "`n", 1)
  $text = $text -replace 'background:\s*#0f1b24 var\(--bg-image\)[^;]*;', 'background: #0f1b24;'
  $text = [regex]::Replace($text, '<div class="bg-media"[^>]*>\s*(?:<img[^>]*>\s*)?</div>\s*', '')

  $text = [regex]::Replace($text, '(?s)\s*<script>\s*\(function \(\) \{[\s\S]*?var FILE = "[^"]+"[\s\S]*?\}\)\(\);\s*</script>\s*', "`n")

  if ($text -ne $raw) {
    [IO.File]::WriteAllText($path, $text, [Text.UTF8Encoding]::new($false))
    Write-Host $_.FullName.Substring($root.Length + 1)
    $changed++
  }
}
Write-Host "Total: $changed"
