-- ### Oppgave 1: Grunnleggende Spørringer mot Én Tabell
-- #### Del 2: Lag SQL-spørringer

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
-- #### Del 2: Lag SQL-spørringer (skriv i `besvarelse.sql`)

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