# Larship Safety – Roadmap

## Formål

Dette dokumentet beskriver utviklingsrekkefølgen for Larship Safety.

Systemet skal utvikles trinnvis. Hver fase skal bygges, testes og kvalitetssikres før neste fase starter.

Målet er å få et stabilt og forståelig system, ikke flest mulig funksjoner.

---

# Prototype 1.0

## Fase 1 – Kontrollpanel

Kontrollpanelet er første prioritet.

Det skal gi skipsledelsen et raskt bilde av sikkerhetsstatus om bord.

### Kontrollpanelet skal vise

- Aktiv besetning
- Nye besetningsmedlemmer
- Oppgaver som mangler
- Opplæring som mangler
- Tester som mangler
- Åpne hendelser
- Åpne observasjoner
- Åpne avvik
- Kommende øvelser
- Varsler
- Siste aktivitet

### Mål

Brukeren skal kunne forstå sikkerhetsstatusen på skipet på noen få sekunder.

---

# Fase 2 – Mannskap

Mannskapsmodulen skal håndtere personer som er registrert på skipet.

## Funksjoner

- Mannskapsliste
- Søk
- Filtrering
- Rolle
- Aktiv/inaktiv status
- Ombordstigning
- Avmønstring
- Personprofil

## Første arbeidsflyt

```text
Mannskapsliste
      ↓
Velg person
      ↓
Personprofil
      ↓
Rolle
      ↓
Oppgaver
