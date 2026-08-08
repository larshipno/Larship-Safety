# Larship Safety – Admin Panel Layout

## 1. Formål

Dette dokumentet beskriver den visuelle og funksjonelle oppbygningen av kontrollpanelet i Larship Safety Admin Prototype 1.0.

Kontrollpanelet skal være den første skjermen en administrator eller skipsledelse møter etter innlogging.

Målet er å gi et klart bilde av sikkerhetssituasjonen om bord uten at brukeren må lete etter informasjon.

---

# 2. Hovedstruktur

Skjermen skal bestå av:

```text
+----------------------------------------------------------+
| LARSHIP SAFETY                         Varsler   Profil   |
+----------------------+-----------------------------------+
|                      |                                   |
| HOVEDMENY            |       KONTROLLPANEL               |
|                      |                                   |
| Kontrollpanel        |       Skip: [Aktivt skip]        |
| Mannskap             |                                   |
| Oppgaver             |       Statuskort                  |
| Opplæring            |                                   |
| Tester               |       Besetning                   |
| Hendelser            |       Oppgaver                    |
| Observasjoner        |       Opplæring                   |
| Avvik                |       Tester                      |
| Øvelser              |       Hendelser                   |
| Dokumenter           |       Avvik                       |
| Rapporter            |                                   |
| Historikk            |       Dagens besetning            |
| Innstillinger        |                                   |
|                      |       Hurtighandlinger            |
+----------------------+-----------------------------------+
