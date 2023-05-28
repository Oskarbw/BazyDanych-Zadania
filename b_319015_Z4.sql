/*
Z4 Oskar Biwejnis 319015 GR 2
Z4.1 - poazaæ osoby z województwa o kodzie X, które nigdy
nie pracowa³y / nie pracuja tez obecnie w firmie z woj o tym samym kodzie
(lub innym - jakie dane lepsze)

czyli jezeli jaikolwiek etat spe³niaj¹cy warunek powy¿ej to osoby nie pokazujemy

Czyli jak Osoba MS mieszka w woj o kodzie X a pracuje w firmie z woj X
a drugi etat w firmie z woj Y
to takiej osoby NIE POKOZUJEMY !!!
A nie, ¿e poka¿emy jeden etat a drugi nie

Z4.2 - pkoazaæ liczbê mieszkañców w województwach
ale tylko w tych maj¹cych wiecej jak jednego mieszkañca

Z4,3 - pokazaæ sredni¹ pensjê w miastach
ale tylko tych posiadaj¹cych wiêcej ja jednego mieszkañca

1 wariant -> etaty -> osoby -> miasta (srednia z osób mieszkaj¹cych)
2 wariant -> (srednia z firm w miastach) a liczba mieszkañców

*/



--Z4.1
/* Zapytanie wewnêtrzne:*/
SELECT e.id_etatu, o.id_osoby, wO.kod_woj AS [wojewodztwo osoby], wF.kod_woj AS [wojewodztwo firmy] FROM ETATY e join OSOBY o ON (e.id_osoby=o.id_osoby) join MIASTA mO ON ( o.id_miasta = mO.id_miasta) join WOJ wO ON(mO.kod_woj=wO.kod_woj)
join FIRMY f ON (e.id_firmy=f.nazwa_skr) join MIASTA mF ON (mF.id_miasta=f.id_miasta) join WOJ wF ON (wF.kod_woj=mF.kod_woj)  WHERE wO.kod_woj=wF.kod_woj
 /*
 id_etatu    id_osoby    wojewodztwo osoby wojewodztwo firmy
----------- ----------- ----------------- -----------------
1           1           MAZ               MAZ 
2           2           MAZ               MAZ 
3           3           MAZ               MAZ 
4           4           MAZ               MAZ 
5           5           MAZ               MAZ 
7           7           MAZ               MAZ 
12          12          POD               POD 
13          13          POD               POD 
15          1           MAZ               MAZ 
16          2           MAZ               MAZ 
17          3           MAZ               MAZ 
18          4           MAZ               MAZ 
19          5           MAZ               MAZ 
20          6           MAZ               MAZ 

(14 row(s) affected)

*/

/*zapytanie w³aœciwe:*/
SELECT o.id_osoby, o.imie, o.nazwisko 
	FROM OSOBY o
	WHERE	
	NOT EXISTS 
	(SELECT e.id_etatu, o.id_osoby, wO.kod_woj AS [wojewodztwo osoby], wF.kod_woj AS [wojewodztwo firmy] 
	FROM ETATY e join OSOBY oO ON (e.id_osoby=oO.id_osoby) join MIASTA mO ON ( oO.id_miasta = mO.id_miasta) join WOJ wO ON(mO.kod_woj=wO.kod_woj)
join FIRMY f ON (e.id_firmy=f.nazwa_skr) join MIASTA mF ON (mF.id_miasta=f.id_miasta) join WOJ wF ON (wF.kod_woj=mF.kod_woj) WHERE wO.kod_woj=wF.kod_woj AND oO.id_osoby=o.id_osoby)
/* Pokazuje wszystkie osoby które nie pojawi³y siê w zapytaniu wewnêtrznym:
id_osoby    imie                                               nazwisko
----------- -------------------------------------------------- --------------------------------------------------
8           Genowefa                                           Zilberstein
9           Patryk                                             Warty
10          Jan                                                Niezbêdny
11          Karolina                                           Plastelina
14          Kacper                                             Konopia

(5 row(s) affected)

*/



--Z4.2
/* zapytanie wewnêtrzne:*/
SELECT w.kod_woj, COUNT(o.id_osoby) 
FROM OSOBY o join MIASTA m ON ( o.id_miasta=m.id_miasta) join WOJ w ON (m.kod_woj=w.kod_woj) 
GROUP BY w.kod_woj  
/*
kod_woj 
------- -----------
MAZ     7
POD     5
POM     2

(3 row(s) affected)
*/

/*Zapytanie zawieraj¹ce warunek HAVING: liczba_miesz WIÊCEJ NI¯ 3*/
SELECT w.kod_woj, COUNT(o.id_osoby) AS [liczba_miesz] 
FROM OSOBY o join MIASTA m ON ( o.id_miasta=m.id_miasta) join WOJ w ON (m.kod_woj=w.kod_woj) 
GROUP BY w.kod_woj HAVING COUNT(o.id_osoby)>3
/*
kod_woj liczba_miesz
------- ------------
MAZ     7
POD     5

(2 row(s) affected)

*/



--Z4.3 - pokazaæ sredni¹ pensjê w miastach
ale tylko tych posiadaj¹cych wiêcej ja jednego mieszkañca

-- Zapytanie wewnêtrzne licz¹ce œredni¹ dla poszczególnych miast:
SELECT m.id_miasta, AVG(e.pensja) FROM ETATY e join FIRMY f ON (e.id_firmy=f.nazwa_skr) join MIASTA m ON (m.id_miasta=f.id_miasta) GROUP BY m.id_miasta
/*
id_miasta   
----------- ---------------------
1           4380,00
2           4000,00
4           2537,50
8           13833,3333

(4 row(s) affected)
*/

--Zapytanie po³¹czone z zapytaniem licz¹cym liczbê mieszkañców:
SELECT X.id_mias AS [id miasta], X.srednia, Xx.ilosc_miesz AS [ilosc mieszkancow w danym miescie] FROM (SELECT m.id_miasta AS id_mias, AVG(e.pensja) AS srednia FROM ETATY e join FIRMY f ON (e.id_firmy=f.nazwa_skr) join MIASTA m ON (m.id_miasta=f.id_miasta) GROUP BY m.id_miasta) X
join (SELECT m.id_miasta AS id_m, COUNT(o.id_osoby) [ilosc_miesz]
FROM OSOBY o join MIASTA m ON ( o.id_miasta=m.id_miasta) 
GROUP BY m.id_miasta HAVING COUNT(o.id_osoby)>1 ) Xx ON (X.id_mias=Xx.id_m) 
/*
id miasta   srednia               ilosc mieszkancow w danym miescie
----------- --------------------- ---------------------------------
1           4380,00               3
2           4000,00               2
8           13833,3333            4

(3 row(s) affected)

*/




