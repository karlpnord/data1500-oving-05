-- ### Oppgave 1: Grunnleggende Spørringer mot Én Tabell

-- 1.  Finn alle data om alle kunder. Vis kun de 20 siste fra resultatrelasjonen (tips: bruke delspørring).
SELECT * FROM Kunde ORDER BY KNr LIMIT 20;

-- 2.  Finn fornavn og etternavn til alle ansatte. Vis kun de 10 første radene fra resultatrelasjonen.
SELECT Fornavn, Etternavn FROM Ansatt LIMIT 10;

-- 3.  Finn alle unike stillinger som finnes i `Ansatt`-tabellen.
SELECT DISTINCT Stilling From Ansatt;

-- 4.  Finn varenummer, betegnelse og pris for alle varer.
SELECT VNr, Betegnelse, Pris FROM Vare;

-- 5.  Finn navn og kategori-nummer for alle kategorier, men døp om kolonnene til `Kategorinavn` og `KategoriID`.
SELECT KatNr AS KategoriID, Navn as Kategorinavn FROM Kategori;

-- 6.  Finn ut hvor mange rader vil en kryssprodukt mellom kunder og ordrer ha.
SELECT COUNT(*) FROM Kunde CROSS JOIN Ordre;


-- ### Oppgave 2: WHERE-klausulen og Betingelser

-- 1.  Finn alle varer som koster mellom 200 og 500 (inkludert).
SELECT * FROM Vare WHERE Pris >= 200 AND Pris <= 500;

-- 2.  Finn alle ansatte som er 'Lagermedarbeider' eller 'Innkjøper'.
SELECT * FROM Ansatt WHERE Stilling = 'Lagermedarbeider' OR Stilling = 'Innkjøper';

-- 3.  Finn alle kunder som bor i postnummer '3199' eller '1711' og hvis fornavn starter med 'A'.
SELECT * FROM Kunde WHERE (PostNr = '3199' OR PostNr = '1711') AND Fornavn LIKE 'A%';

-- 4.  Finn alle varer som ikke er i kategori 1 og som har mer enn 600 på lager.
SELECT * FROM Vare WHERE NOT KatNr = 1 AND Antall > 600;

-- 5.  Finn alle ordrer som ble sendt, men ikke betalt.
SELECT * FROM Ordre WHERE SendtDato IS NOT NULL AND BetaltDato IS NULL;

-- 6.  Finn alle ansatte hvis etternavn inneholder 'sen' (ikke case-sensitivt).
SELECT * FROM Ansatt WHERE Etternavn LIKE '%sen%';


-- ### Oppgave 3: Gruppering, Sortering og Aggregering

-- 1.  Finn antall kunder per postnummer.
SELECT PostNr, COUNT(*) AS AntallPerPostNr FROM Kunde GROUP BY PostNr;

-- 2.  Finn gjennomsnittlig pris for hver kategori.
SELECT KatNr, AVG(Pris) FROM Vare GROUP BY KatNr;

-- 3.  Finn den dyreste varen i hver kategori.
SELECT KatNr, MAX(Pris) FROM Vare GROUP BY KatNr;

-- 4.  List opp alle stillinger og antall ansatte i hver stilling, sortert synkende etter antall.
SELECT Stilling, COUNT(*) AS Antall FROM Ansatt 
GROUP BY Stilling ORDER BY Antall DESC;

-- 5.  Finn totalt antall varer på lager for hver kategori, men vis kun kategorier med mer enn 1000 varer totalt.
SELECT KatNr, SUM(Antall) FROM Vare 
GROUP BY KatNr HAVING SUM(Antall) > 1000;

-- 6.  Finn den eldste og yngste ansatte.
SELECT * FROM Ansatt ORDER BY Fødselsdato ASC LIMIT 1;

SELECT * FROM Ansatt ORDER BY Fødselsdato DESC LIMIT 1;


-- ### Oppgave 4: Spørringer mot Flere Tabeller og Joins

-- 1.  Finn navn på alle kunder og poststedet de bor i. Vis kun de første 20 rader fra resultatrelasjon.
SELECT K.Fornavn, K.Etternavn, P.Poststed FROM Kunde
JOIN Poststed P ON K.PostNr = P.PostNr LIMIT 20;

-- 2.  Finn navn på alle varer og navnet på kategorien de tilhører. Vis kun de første 20 rader fra resultatrelasjon.
SELECT V.Betegnelse, K.Navn FROM Vare V 
JOIN Kategori K ON V.KatNr = K.KatNr LIMIT 20;

-- 3.  Finn alle ordrer med kundenavn og ordredato. Vis kun de første 20 rader fra resultatrelasjon. 
SELECT O.OrdreDato, K.Fornavn, K.Etternavn FROM Ordre O
JOIN Kunde K ON O.KNr = K.KNr LIMIT 20;

-- 4.  Finn alle varer som aldri har blitt solgt (dvs. ikke finnes i `Ordrelinje`).
SELECT OL.OrdreNr, V.VNr, V.Betegnelse FROM Ordrelinje OL
RIGHT JOIN Vare V ON OL.VNr = V.VNr WHERE OL.OrdreNr IS NULL;

-- 5.  Finn totalt antall solgte enheter for hver vare (bruk `Ordrelinje`).
SELECT V.Betegnelse, SUM(OL.Antall) AS AntallSolgteEnheter FROM Ordrelinje OL
JOIN Vare V ON OL.VNr = V.VNr
GROUP BY V.VNr, V.Betegnelse
ORDER BY AntallSolgteEnheter DESC;

-- 6.  Finn navnet på alle ansatte som bor i Bø i Telemark.
SELECT A.Fornavn, A.Etternavn, P.Poststed FROM Ansatt A
JOIN Poststed P ON A.PostNr = P.PostNr
WHERE P.Poststed = 'BØ I TELEMARK';


-- ### Oppgave 5: NULL-verdier og Aggregeringsfunksjoner

-- 1.  Finn antall ansatte som **ikke** har fått bonus.
SELECT COUNT(*) FROM Ansatt WHERE Bonus IS NULL;

-- 2.  Beregn gjennomsnittlig bonus for alle ansatte, men behandle de som ikke har fått bonus som om de har 0 i bonus.
SELECT AVG(COALESCE(Bonus, 0)) AS GjennomsnittsBonus FROM Ansatt;

-- 3.  List opp alle kunder som **ikke** har registrert et telefonnummer.
SELECT Fornavn, Etternavn FROM Kunde WHERE Telefon IS NULL;

-- 4.  Finn den totale lønnskostnaden (Årslønn + Bonus) for alle ansatte. Pass på at ansatte uten bonus også blir med i den totale summen.
SELECT SUM(Årslønn + COALESCE(Bonus, 0)) AS TotalLønnskostnad FROM Ansatt;

-- 5.  List opp alle stillinger og antall ansatte i hver stilling som har en bonus registrert.
SELECT Stilling, COUNT(Bonus) AS AntallMedBonus FROM Ansatt
GROUP BY Stilling HAVING COUNT(Bonus) IS NOT NULL;

-- 6.  Finn den laveste bonusen som er gitt ut (ignorer de som ikke har fått bonus).
SELECT MIN(Bonus) FROM Ansatt;


-- ### Oppgave 6: Tre-verdi Logikk (TRUE, FALSE, UNKNOWN)

-- Skriv SQL-spørringer for å hente ut følgende informasjon.

-- 1.  Finn alle ordrer som **verken** er bekreftet betalt eller bekreftet ikke-betalt (dvs. de hvor logikken er `UNKNOWN`).
SELECT * FROM Ordre WHERE ErBetalt IS UNKNOWN;
-- 2.  List opp alle ansatte som har en bonus som er enten `NULL` eller mindre enn 6000.
SELECT * FROM Ansatt WHERE Bonus IS NULL OR Bonus < 6000;

-- 3.  Finn antall kunder som **ikke** har telefonnummer `41234567` (pass på å inkludere de med `NULL` telefonnummer i tellingen).
SELECT COUNT(*) AS Antall FROM Kunde WHERE Telefon != '41234567' OR Telefon IS NULL;

-- 4.  List opp alle ordrer som er betalt (`ErBetalt = TRUE`), men hvor `SendtDato` er `NULL`.
SELECT * FROM Ordre WHERE ErBetalt = True AND SendtDato IS NULL;