# Forside → GitHub Pages (ForsideDSAGas)

## Det skal altid være sådan her

| Fil på GitHub (repo-rod) | Kilde i dette projekt |
|--------------------------|------------------------|
| `index.html` | **`index.html` i projektets rod** — samme **bgUrl()-script** som fx `torvarer/index.html` (sætter korrekt absolut URL til `Baggrundsbillede.png` på GitHub Pages) |
| `Baggrundsbillede.png` | Samme fil i **projektets rod** (ved siden af `index.html`) |
| `.nojekyll` | Tom fil i **projektets rod** |

**GitHub:** Settings → Pages → den branch du bruger → mappe **`/ (root)`** (medmindre du bevidst bruger `/docs`).

## Det må aldrig ske

- **Ikke** læg `Forside/index.html` ind som rod-`index.html` på GitHub. Den er til lokal åbning fra undermappen og bruger `../Baggrundsbillede.png`, hvilket **ødelægger baggrunden** på `github.io/…/ForsideDSAGas/`.

## Ved ændringer af forsiden

1. Rediger **`index.html` i projektets rod** (eller kopier derefter til GitHub-rod).
2. Tjek at `preload` og `<img src="...">` peger på **`Baggrundsbillede.png`** — **aldrig** `../Baggrundsbillede.png` i rod-`index.html` på GitHub (så henter browseren billedet fra `github.io/…` uden for repoet → tomt).

## Hvis baggrunden mangler online

Åbn din live `index.html` (Raw på GitHub) og søg efter `../Baggrund`. Findes det, er filen den forkerte kopi — **erstat hele** `index.html` i ForsideDSAGas med **`index.html` fra dette projekts rod** og push igen.
