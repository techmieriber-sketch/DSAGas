# Hvis du får 404 på Forside (GitHub Pages)

## 1. Rigtig fil i repo-roden

I **ForsideDSAGas** skal **`index.html` i roden** være den **fulde** forside med:

- `href="Baggrundsbillede.png"` og `src="Baggrundsbillede.png"` (**ikke** `../Baggrundsbillede.png`)

Brug filen **`index.html` i roden af DSA Gastronom-projektet** — **ikke** `Forside/index.html` (den er til lokal visning fra undermappen og bruger `../` til billedet).

## 2. Indstillinger på GitHub

**Settings → Pages → Build and deployment**

- **Branch:** fx `main` (den du uploader til)
- **Folder:** `/ (root)` — medmindre du bevidst bruger `/docs`

Hvis mappen er sat til **docs** men dine filer ligger i roden, får du 404.

## 3. `.nojekyll` i repo-roden

Læg en **tom fil** ved navn `.nojekyll` i roden af ForsideDSAGas (kopier fra `Forside/.nojekyll` her). Så kører GitHub ikke Jekyll på dit statiske site.

## 4. URL

Projektside: `https://techmieriber-sketch.github.io/ForsideDSAGas/`  
(Vent et minut efter push — første build kan være langsom.)

## 5. Tjek at filen findes i repo

På GitHub: **Code** → skal vise `index.html` og `Baggrundsbillede.png` i **samme** rodmappe.

**Vigtigt:** Commit `Baggrundsbillede.png` sammen med `index.html` (`git add Baggrundsbillede.png`). Filen ligger i roden af DSA Gastronom-projektet efter synk — uden den fil på GitHub vises kun den mørkeblå fallback-baggrund.
