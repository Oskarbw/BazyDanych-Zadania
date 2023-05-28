/*
Z5 imie, nazwisko nrInd, grupa

Z5.1 - Pokazaæ firmy wraz ze œredni¹ aktualna
pensj¹ w nich
U¿ywaj¹c UNION, rozwa¿yæ opcjê ALL
jak nie ma etatów to 0 pokazujemy

Z5.2 - to samo co w Z5.1
Ale z wykorzystaniem LEFT OUTER

Z5.3 Napisaæ procedurê pokazuj¹c¹ œredni¹ pensjê w
firmach z miasta - parametr procedure @id_miasta
*/



--Z5.1
SELECT f.nazwa_skr AS [ID firmy], AVG(e.pensja) AS [œrednia pensja] FROM ETATY e join FIRMY f on (e.id_firmy=f.nazwa_skr) WHERE e.do is NULL GROUP BY f.nazwa_skr 
UNION ALL
SELECT  f.nazwa_skr AS [ID firmy], CONVERT(money, null) AS [œrednia pensja] FROM FIRMY f WHERE NOT EXISTS (SELECT * FROM ETATY eW WHERE f.nazwa_skr=eW.id_firmy AND eW.do is not null)
/*
ID firmy œrednia pensja
-------- ---------------------
DRUT     5666,6666
GRUZ     2250,00
JKS      2300,00
JKSP     5300,00
KOLB     2883,3333
KONO     17500,00
GOK      NULL
KOLO     NULL

(8 row(s) affected)
*/

--Z5.2
SELECT fZ.nazwa_skr AS [ID firmy], X.[œrednia pensja] FROM FIRMY fZ left outer join (SELECT f.nazwa_skr AS [ID firmy], AVG(e.pensja) AS [œrednia pensja] FROM ETATY e join FIRMY f on (e.id_firmy=f.nazwa_skr) WHERE e.do is NULL GROUP BY f.nazwa_skr) X on fZ.nazwa_skr=X.[ID firmy] 
/*
ID firmy œrednia pensja
-------- ---------------------
DRUT     5666,6666
GOK      NULL
GRUZ     2250,00
JKS      2300,00
JKSP     5300,00
KOLB     2883,3333
KOLO     NULL
KONO     17500,00

(8 row(s) affected)
*/


--Z5.3
CREATE PROCEDURE dbo.P1 (@id_miasta int)
AS
	SELECT m.nazwa AS [Nazwa miasta], X.sr_pensja AS [Œrednia pensja w danym mieœcie] 
	FROM (SELECT f.id_miasta, AVG(e.pensja) AS sr_pensja 
	FROM ETATY e join FIRMY f ON (e.id_firmy = f.nazwa_skr) 
	WHERE f.id_miasta = @id_miasta
	GROUP BY f.id_miasta) X 
	join MIASTA m ON (m.id_miasta = X.id_miasta)
GO

EXEC P1 @id_miasta = 1
/*
Nazwa miasta                                       Œrednia pensja w danym mieœcie
-------------------------------------------------- ------------------------------
Warszawa                                           4380,00

(1 row(s) affected)
*/

EXEC P1 @id_miasta = 2
/*
Nazwa miasta                                       Œrednia pensja w danym mieœcie
-------------------------------------------------- ------------------------------
Radom                                              4000,00

(1 row(s) affected)
*/
