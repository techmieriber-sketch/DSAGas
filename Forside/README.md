# Dansk som andetsprog for gastronomer

Et interaktivt læringsportal til undervisning i dansk som andetsprog med fokus på gastronomi og køkkenfaglig terminologi.

## Indhold

Portalen indeholder undervisningsmateriale inddelt i følgende kategorier:

- **Brødbagning** – brødproduktion, surdej, teknikker
- **Drikkevarer** – drikkevarer, cocktails, kaffe
- **Fisk** – fisk, skaldyr og tilberedning
- **Frugter** – frugter og brug i madlavning
- **Grøntsager** – grøntsager og tilberedning
- **Hygiejne** – madhygiejne og fødevaresikkerhed
- **Kød** – kødtyper og tilberedte kødprodukter
- **Krydderier og krydderurter** – krydderier og urter
- **Køkkenting** – køkkenudstyr og grej
- **Mejeriprodukter** – mælk, ost, smør m.m.
- **Middagsretter** – klassiske danske retter
- **Søde sager** – kager, desserter, chokolade
- **Tørvarer** – tørvarer og opbevaring
- **Æg** – æg og æggeretter
- **Udtale** – udtaletræning

## Aktiviteter

Hver kategori tilbyder typisk:

- **Tekster** – læsning med lydoptagelser
- **Ordkort** – ord med billeder og definitioner
- **Kryds og tværs** – krydsord
- **Multiple choice-quiz** – spørgsmål med flere svarmuligheder
- **Vendespil** – memory-spil med termer
- **Videoer** – YouTube-links til demonstrationer

## Brug

Projektet er statisk HTML og kan bruges direkte:

1. Åbn `index.html` i en webbrowser, eller
2. Host filerne på en webserver (fx GitHub Pages)

### GitHub Pages (ForsideDSAGas)

I roden af **Forside**-repoet skal `index.html` være den **fulde** forside (samme indhold som `index.html` i roden af dette samlede projekt). **Læg ikke** den lille viderestillingsside med `url=../index.html` i roden — så forsvinder forsiden på nettet, fordi `../` peger uden for sitet.

### AppWriter

Indholdet kan læses op med [AppWriter](https://it-info.aarhustech.dk/da/software/generelt/appwriter). Log ind via Unilogin og MitID.

## Teknologi

- Ren HTML, CSS og JavaScript
- Ingen build-tools eller eksterne afhængigheder
- Lydfiler (MP3) og billeder (PNG, JPG) inkluderet

## Projektstruktur

```
├── index.html              # Forside
├── udtale/                # Udtaletræning
├── assets/                # Baggrundsbilleder
├── broed/                 # Brødbagning (HTML + billeder/lyd)
├── drikkevarer/           # Drikkevarer
├── fisk/                  # Fisk
├── frugter/               # Frugter
├── groentsager/           # Grøntsager
├── hygiejne/              # Hygiejne
├── koed/                  # Kød
├── kokkenting/            # Køkkenting
├── krydderier-krydderurter/
├── mejeriprodukter/
├── middagsretter/
├── soede-sager/
├── torvarer/
├── aeg/                   # Æg (HTML + billeder/lyd)
└── [Fisk]/, [Drikkevarer]/, osv.  # Billeder og lyd pr. kategori
```

## Licens

Materialet er udviklet til undervisningsbrug. Kontakt projektansvarlig for rettigheder.
