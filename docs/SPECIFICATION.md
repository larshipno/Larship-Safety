# Larship Safety – Specification 1.0

## 1. Formål
Larship Safety er en opplærings- og sikkerhetsapp for ansatte om bord på skip. Systemet skal brukes når mannskap kommer om bord for å gjennomføre nødvendige opplæringsoppgaver, sikkerhetskontroller, tester og prosedyrer.

Appen er et støtteverktøy for opplæring og sikkerhetsoppfølging. Den skal ikke brukes som erstatning for skipets faktiske beredskapsorganisasjon, øvelser eller håndtering av reelle nødsituasjoner.

## 2. Fartøy
- Hvert fartøy identifiseres unikt med IMO-nummer.
- Fartøy kan skifte navn uten at IMO-nummeret endres.
- Brukerens sikkerhetshistorikk skal være knyttet til fartøy/ansettelsesforhold og skal ikke automatisk følge med ved overgang til et annet fartøy.

## 3. Roller og tilgang
### Kaptein
- Full administrativ tilgang.
- Kan administrere mannskap, fartøy, tester, prosedyrer, oppgaver, avvik og rapporter.

### Overstyrmann / Sikkerhetsoffiser
- Samme systemtilgang som Kaptein.
- Har ansvar for sikkerhetsoppfølging og kan kontrollere tester og sikkerhetsstatus.

### Ansatt / mannskap
- Egen personlig innlogging.
- Ser egne oppgaver, tester, sikkerhetskontroller og relevante prosedyrer.
- Kan gjennomføre tildelte tester og registrere nødvendige kontroller.
- Skal ikke kunne endre regelverk, sikkerhetskrav, systemoppsett eller andre brukeres data.

## 4. Innlogging
Alle ansatte skal kunne logge inn på egen konto fra telefon eller nettbrett.

Systemet skal støtte:
- personlig brukerprofil
- sikker autentisering
- automatisk utlogging etter inaktivitet
- passord/PIN og senere eventuell biometri
- rollebasert tilgang

Kaptein og Overstyrmann bruker samme type app og kan overføre administrativ bruk mellom seg ved vaktskifte. Vanlige ansatte bruker sin egen konto.

## 5. Dashboard
Etter innlogging skal brukeren få et dashboard tilpasset rollen.

### Ansatt
- Mine oppgaver
- Mine tester
- Mine kontroller
- Mine prosedyrer
- Frister
- Meldinger/status

### Kaptein / Overstyrmann
- Sikkerhetsstatus for fartøyet
- Mannskapets fremdrift
- Åpne avvik
- Oppgaver
- Tester og resultater
- Rapporter

## 6. Tester
- Spørsmål trekkes tilfeldig fra testbiblioteket.
- Beståttgrense skal kunne konfigureres, eksempel 80 %.
- Antall forsøk skal kunne konfigureres, eksempel 3.
- Tidsbegrensning skal kunne konfigureres, eksempel 3 minutter.
- Kaptein og Overstyrmann kan justere vanskelighetsgrad.
- Systemet registrerer resultat og status.
- Påminnelse kan sendes før test utløper, eksempel 2 dager før, én gang.
- Både den ansatte og sikkerhetsoffiser skal kunne varsles etter gjeldende oppsett.

## 7. Prosedyrebibliotek
Prosedyrebiblioteket skal inneholde godkjente prosedyrer og regelverksbasert opplæringsmateriale.

Regelverk og sentrale sikkerhetskrav skal ikke kunne redigeres av vanlige brukere.

## 8. Sikkerhetskontroller og sjekklister
Systemet skal støtte digitale sjekklister og kontroller som kan tildeles ansatte.

Eksempel:
- kontroll av rømningsveier
- kontroll av sikkerhetsutstyr
- registrering av synlige skader eller korrosjon
- dokumentasjon med bilde der dette er relevant
- automatisk opprettelse av vedlikeholdsoppgave når en kontroll avdekker et avvik
- GPS og tidsstempel kan lagres når funksjonen er aktivert og personvernreglene tillater det

## 9. Avvik og oppgaver
Et avvik skal kunne registreres med:
- beskrivelse
- dato og klokkeslett
- fartøy
- område
- registrert av
- bilde/dokumentasjon der relevant
- status
- ansvarlig person
- frist

Et avvik skal kunne føre til en oppgave med ansvarlig person og frist.

## 10. Rapportering
Kaptein og Overstyrmann skal kunne se status og generere rapporter over:
- gjennomførte kontroller
- tester
- manglende opplæring
- åpne avvik
- oppgaver
- sikkerhetsstatus

## 11. Personvern
- Historikk skal kunne slettes i samsvar med systemets personvernregler.
- Når en person bytter fartøy, skal historikk fra tidligere fartøy ikke automatisk bli en del av det nye fartøyets aktive oppfølging.
- Tilgang til personopplysninger skal begrenses etter rolle.
- Systemet skal ha tydelig kontroll på hvem som kan lese, opprette, endre og slette data.

## 12. Regelverk
Systemet skal bygges med SOLAS, IMO og andre relevante maritime krav som overordnet referanseramme. Regelverksinnhold skal behandles som kontrollert innhold og skal ikke kunne endres av vanlige brukere.

## 13. Synkronisering og sikkerhetskopiering
- Automatisk synkronisering.
- Automatisk sikkerhetskopiering.
- Ingen krav om manuell synkronisering for vanlig bruker.

## 14. Språk og grensesnitt
- Norsk språk.
- Norske datoer, eksempel 04.08.2026.
- Norsk klokkeformat, eksempel 06.00–24.00.
- Støtte for god lesbarhet, stor skrift og høy kontrast.
- Mobil og nettbrett skal være hovedplattformene.

## 15. AI og fremtidig MCP-støtte
Arkitekturen skal være forberedt for sikker integrasjon med AI-verktøy og Model Context Protocol (MCP).

AI skal ikke kunne endre regelverket eller omgå rolle- og sikkerhetskontroller. Eventuelle skrivehandlinger skal være eksplisitt definert, rollebegrenset, loggbare og kunne kreve brukerbekreftelse.

## 16. Grunnprinsipp
Larship Safety skal bygges modulært. Sikkerhetskritiske regler skal være sentraliserte, sporbare og vanskeligere å endre enn vanlig applikasjonsinnhold.

Denne spesifikasjonen er grunnlaget for videre utvikling av Larship Safety 1.0.