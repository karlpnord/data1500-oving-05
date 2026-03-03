# Besvarelse: SQL-Analyse

## Oppgave 1: Grunnleggende Spørringer
1.  `SELECT * FROM Vare;`
2.  `SELECT VNr, Betegnelse FROM Vare;`
3.  `SELECT DISTINCT KatNr FROM Vare;`
4.  `SELECT Fornavn, Etternavn, Stilling AS Jobbtittel FROM Ansatt;`

1.  **Forklaring:** Velger alt fra tabellen Vare.

2.  **Forklaring:** Velger ut attributtene VNr og Betegnelse fra tabellen Vare.

3.  **Forklaring:** Velger ut KatNr attributtet fra tabellen Vare. Duplikate verdier blir fjernet pga DISTINCT.

4.  **Forklaring:** Velger ut Fornavn, Etternavn og Stilling omdøpt til JobbTittel fra tabellen Ansatt.

## Oppgave 2: WHERE-klausulen
1.  `SELECT * FROM Vare WHERE Pris > 500;`
2.  `SELECT * FROM Ansatt WHERE Stilling = 'Salgssjef' AND Årslønn > 600000;`
3.  `SELECT Fornavn, Etternavn FROM Kunde WHERE PostNr = '0001' OR PostNr = '0002';`
4.  `SELECT Betegnelse FROM Vare WHERE NOT KatNr = 1;`

1.  **Forklaring:** Velger all data fra tabellen Vare, men bare de varene som har Pris > 500.

2.  **Forklaring:** Velger all data fra tabellen Ansatt, men viser bare de ansatte som har stilling 'Salgssjef' og Årslønn > 600000.

3.  **Forklaring:** Velger Fornavn og Etternavn fra tabellen Kunde, men viser bare info om de kundene som har PostNr 0001 eller 0002.

4.  **Forklaring:** Velger attributtet Betegnelse fra tabellen Vare, men viser bare betegnelsen på de varene som ikke har KatNr = 1.

## Oppgave 3: Gruppering og Sortering
1.  `SELECT * FROM Vare ORDER BY Pris DESC;`
2.  `SELECT KatNr, COUNT(*) FROM Vare GROUP BY KatNr;`
3.  `SELECT Stilling, AVG(Årslønn) FROM Ansatt GROUP BY Stilling;`
4.  `SELECT KatNr, SUM(Antall) FROM Vare GROUP BY KatNr HAVING SUM(Antall) > 500;`

1.  **Forklaring:** Velger ut alle varer og sorterer etter pris (høyest pris til lavest pris).

2.  **Forklaring:** Velger ut varer og grupperer de etter KatNr og teller antall varer per KatNr.

3.  **Forklaring:** Velger ut Ansatt tabellen og grupperer etter Stilling. Dermed regner vi ut gjennomsnitt årslønn per Stilling.

4.  **Forklaring:** Velger ut Vare tabell og teller antall varer per KatNr. Så grupperer vi etter KatNr og viser bare de kategoriene som totalt har mer enn 500 antall varer.

## Oppgave 4: Spørringer mot Flere Tabeller
1.  `SELECT V.Betegnelse, K.Navn FROM Vare V JOIN Kategori K ON V.KatNr = K.KatNr;`
2.  `SELECT O.OrdreNr, K.Fornavn, K.Etternavn FROM Ordre O LEFT JOIN Kunde K ON O.KNr = K.KNr;`
3.  `SELECT A1.Fornavn, A2.Fornavn FROM Ansatt A1, Ansatt A2 WHERE A1.PostNr = A2.PostNr AND A1.AnsNr < A2.AnsNr;`
4.  `SELECT V.Betegnelse FROM Vare V WHERE V.VNr NOT IN (SELECT VNr FROM Ordrelinje);`

1.  **Forklaring:** Vi kobler hver Vare til riktig Kategori ved hjelp av FK Vare.KatNr som referer til Kategori.KatNr og viser Vare Betegnelse og Kategori.

2.  **Forklaring:** Vi kobler Ordre og Kunder med FK O.KNr. LEFT JOIN gjør at alle ordre vises i resultatet selv om de eventuelt ikke har en tilhørende kunde (Hvis det ikke hadde vært en tilhørende kunde til ordren ville det stått NULL). Og vi selekterer ut fornavn, etternavn i tillegg til resultattabellen.

3.  **Forklaring:** Vi kobler Ansatt tabellen med seg selv (SELF JOIN), for å finne ansatte som har samme postnummer. Vi sjekker også at en ansatt ikke blir sammenlignet med seg selv og at hvert par som har likt postnummer bare vises en gang.

4.  **Forklaring:** Vi har tabellen Vare og sjekker om VNr (vareid) finnes i tabellen Ordrelinje. Så kort forklart spørringen viser varer som ikke har blitt bestilt.

## Oppgave 5: NULL-verdier og Aggregeringsfunksjoner

Forklar hva følgende SQL-spørringer gjør, og hvorfor resultatene blir som de blir. Vær spesielt oppmerksom på hvordan `NULL` påvirker resultatet.

1.  **Spørring:**
    ```sql
    SELECT COUNT(*), COUNT(Bonus) FROM Ansatt;
    ```
    **Forklaring:**
    *   Første teller antall ansatte (rader) og den andre teller antall ansatte som har fått bonus. Resultatet viser at det er 12 ansatte, det kan vi lett sjekke med select * from ansatt; Og den sier at det er 5 ansatte som får bonus. Leser vi tabellen ser vi at det er ført opp en sum hos 5 av de ansatte. For resten er det er det blankt, dvs NULL, fordi COUNT ignorerer NULL-verdier.

2.  **Spørring:**
    ```sql
    SELECT AVG(Bonus) FROM Ansatt;
    ```
    **Forklaring:**
    *   Denne spørringen regner ut gjennomsnittlig Bonus for tabellen Ansatt. Resultatet av spørringen blir 8000 fordi 40000 / 5 = 8000. De 7 ansatte som ikke har bonus blir ikke registert fordi AVG ignorerer NULL-verdier. Teoretisk så blir da ikke AVG regnet riktig siden vi bare ignorerer de 7 ansatte som egentlig har 0 i bonus.

3.  **Spørring:**
    ```sql
    SELECT Fornavn, Etternavn, COALESCE(Bonus, 0) AS JustertBonus FROM Ansatt;
    ```
    **Forklaring:**
    *   I denne spørringen blir problemet fra den forrige spørringen fikset. Coalesce gjør at der Bonus er NULL blir det istedenfor satt inn 0. Det ser vi i resultattabellen og alle ansatte har en gydlig verdi i justerbonus kolonnen.

4.  **Spørring:**
    ```sql
    SELECT Stilling, SUM(Årslønn + Bonus) FROM Ansatt GROUP BY Stilling;
    ```
    **Forklaring:**
    *   Med denne spørringen så sier vi at vi skal gruppere de forskjellige stillingene og summere lønnen og bonusen til de ansatte i disse stillingene. Resultattabellen viser at fire av stillingene er tomme (NULL). Dette er fordi at SUM ignorerer NULL og i SUM(Årslønn + Bonus) så er det tilfeller hvor Bonus er NULL og utregningen blir ignorert av SQL.

## Oppgave 6: Tre-verdi Logikk (TRUE, FALSE, UNKNOWN)

SQLs logikk er ikke bare `TRUE` eller `FALSE`. Når `NULL` er involvert, får vi en tredje tilstand: `UNKNOWN`. Denne oppgaven utforsker hvordan dette påvirker `WHERE`-klausuler.

### Del 1: Forklar SQL-spørringene

Forklar resultatet av følgende SQL-spørringer. Hvorfor returnerer de det de gjør?

1.  **Spørring:**
    ```sql
    SELECT COUNT(*) FROM Ordre WHERE ErBetalt = TRUE;
    ```
    **Forklaring:**
    *   Vi teller antall ordrer som er betalt. Resultatet sier oss at det er 1973, og totalt har vi 2192. For nå så vet vi ikke noe om de ca 200 orderene som ikke er betalt men vi antar at det er riktig.

2.  **Spørring:**
    ```sql
    SELECT COUNT(*) FROM Ordre WHERE ErBetalt = FALSE;
    ```
    **Forklaring:**
    *   Denne spørringen gjør det motsatte av den forrige altså den teller antall betalinger som ikke er gjennomført. Resultatet sier 0, noe som ikke gir mening siden vi har ca. 200 ordrer som ikke er betalt for. Hvis vi skriver inn spørringen select * from ordre; kan vi se at i erbetalt kolonnen så er det noen tuppler som ikke har en verdi, altså verdien er NULL.

3.  **Spørring:**
    ```sql
    SELECT COUNT(*) FROM Ordre WHERE ErBetalt = TRUE OR ErBetalt = FALSE;
    ```
    **Forklaring:**
    *   Denne spørringen kombinerer de to forrige og i teorien så skal antallet vi får bli det samme som antallet av alle ordrene, men det blir det ikke. Vi får 1973 selv om det totalt er 2192 rader.

4.  **Spørring:**
    ```sql
    SELECT COUNT(*) FROM Ordre WHERE ErBetalt IS UNKNOWN;
    ```
    **Forklaring:**
    *   Denne spørringen teller antall ordrer der ErBetalt hverken er True eller False. Vi burde får 2192 - 1973 = 219 og det gjør vi. Grunnen til at dette skjer er fordi disse ordrene har fått verdien NULL i ErBetalt. Dermed har vi en Tre-verdi logikk.
