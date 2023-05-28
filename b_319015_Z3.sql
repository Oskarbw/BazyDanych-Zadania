/*Z3, Oskar Biwejnis, GR 2, 319015

Z3.1 - policzy� liczb� os�b w ka�dym mie�cie (zapytanie z grupowaniem)
Najlepiej wynik zapami�ta� w tabeli tymczasowej

Z3.2 - korzystaj�c z wyniku Z3,1 - pokaza�, kt�re miasto ma najwi�ksz� liczb� mieszka�c�w
(zapytanie z fa - analogiczne do zada� z Z2)

Z3.3 Pokaza� liczb� firm w ka�dym z wojew�dztw (czyli grupowanie po kod_woj)

Z3.4 Poaza� wojew�dztwa w kt�rych nie ma �adnej firmy

(suma z3.3 i z3.4 powinna da� nam pe�n� list� wojew�dztw - woj gdzie sa firmy i gdzie ich nie ma to razem powinny byc wszystkie

*/

--Z3.1
DROP TABLE #TT
SELECT COUNT(o.id_osoby) AS ilosc_mieszkancow , m.nazwa INTO #TT  FROM OSOBY o join MIASTA m  ON (o.id_miasta= m.id_miasta) GROUP BY m.nazwa
/*Wynik zapytania:
 (8 row(s) affected)
 */

SELECT * FROM #TT
/* Wynik zapytania:
ilosc_mieszkancow nazwa
----------------- --------------------------------------------------
1                 Bia�ystok
1                 Gdynia
1                 NowyDw�rMazowiecki
1                 Pruszk�w
2                 Radom
1                 Sopot
4                 Suwa�ki
3                 Warszawa

(8 row(s) affected)
*/




--Z3.2
SELECT MAX(t.ilosc_mieszkancow) AS max_mieszkancow  FROM #TT t
/*
max_mieszkancow
---------------
4

(1 row(s) affected)
*/

SELECT t2.ilosc_mieszkancow AS [Liczba mieszkancow], 
t2.nazwa AS [Nazwa miasta] 
FROM #TT t2 
join (SELECT MAX(t.ilosc_mieszkancow) AS max_mieszkancow  FROM #TT t) X 
ON (X.max_mieszkancow = t2.ilosc_mieszkancow)
/*
Liczba mieszkancow Nazwa miasta
------------------ --------------------------------------------------
4                  Suwa�ki

(1 row(s) affected)

*/



--Z3.3
SELECT COUNT(f.nazwa_skr) AS [Ilo�� firm] , w.nazwa  FROM FIRMY f join MIASTA m ON (f.id_miasta = m.id_miasta) join WOJ w ON (m.kod_woj = w.kod_woj) GROUP BY w.nazwa
/*
Ilo�� firm  nazwa
----------- --------------------------------------------------
5           Mazowieckie
2           Podlaskie
1           Pomorskie

(3 row(s) affected)
*/

--Z3.4
SELECT *
	FROM WOJ w 
	WHERE	
	NOT EXISTS 
	(SELECT 1 FROM MIASTA m WHERE m.kod_woj = w.kod_woj)
/* Wynik zapytania pokazuje wojew�dztwa w kt�rych nie ma miast:

kod_woj nazwa
------- --------------------------------------------------
WLKP    Wielkopolskie
ZPOM    Zachodnio-Pomorskie

(2 row(s) affected)
*/

SELECT * FROM WOJ w
/* Wszystkich wojew�dztw jest 5:
kod_woj nazwa
------- --------------------------------------------------
MAZ     Mazowieckie
POD     Podlaskie
POM     Pomorskie
WLKP    Wielkopolskie
ZPOM    Zachodnio-Pomorskie

(5 row(s) affected)

Wi�c wyniki z Z3.3 i Z3.4 sumuj� si� do pe�nej listy wojew�dztw

*/