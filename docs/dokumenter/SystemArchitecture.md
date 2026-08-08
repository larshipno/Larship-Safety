# Larship Safety – Systemarkitektur

## 1. Formål

Larship Safety skal være et modulært sikkerhetssystem for skip.

Systemet skal gi mannskapet en enkel arbeidsflate og skipsledelsen et kontrollpanel med samlet oversikt.

Arkitekturen skal være bygget slik at nye moduler kan legges til uten å måtte bygge om eksisterende funksjoner.

---

## 2. Hovedprinsipp

Systemet består av fem hovedområder:

1. Mannskap
2. Oppgaver
3. Sikkerhet
4. Dokumentasjon
5. Administrasjon

Disse områdene skal være koblet sammen gjennom en felles datamodell.

---

## 3. Overordnet system

```text
                         LARSHIP SAFETY
                               |
             +-----------------+-----------------+
             |                 |                 |
        ADMINISTRASJON      MANNSKAP          AI-HJELP
             |                 |                 |
             +-----------------+-----------------+
                               |
                         FELLES DATA
                               |
       +-----------+-----------+-----------+-----------+
       |           |           |           |           |
     Personer    Roller     Oppgaver    Sikkerhet  Dokumenter
       |           |           |           |           |
       +-----------+-----------+-----------+-----------+
                               |
                         HISTORIKK / LOGG
