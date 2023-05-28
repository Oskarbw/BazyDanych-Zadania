/* Oskar Biwejnis 319015 GR 2	
**
** 3 regu�y tworzenia TRIGGERA
** R1 - Trigger nie mo�e aktualizowa� CALEJ tabeli a co najwy�ej elementy zmienione
** R2 - Trigger mo�e wywo�a� sam siebie - uzysamy nieso�czon� rekurencj� == stack overflow
** R3 - Zawsze zakladamy, �e wstawiono / zmodyfikowano / skasowano wiecej jak 1 rekord
**
** Z1: do tabeli FIRMY doda� kolumne NIP i NIP_BK (oba nvarchar(20) NULL) 
** Napisa� trigger, kt�ry b�dzie przepisywa� zawarto�� pola NIP do pola NIP_BK
** Trigger na INSERT, UPDATE (w polu NIP_BK przepisujemy NIP z pomini�ciem - oraz SPACJI)
** UWAGA !! Trigger b�dzie robi� UPDATE na polu NIP_BK
** To grozi REKURENCJ� i przepelnieniem stosu
** Dlatego trzeba b�dzie sprawdza� UPDATE(NIP) i sprawdza� czy we 
** wstawionych rekordach by�y spacje/kreski i tylko takowe poprawia�
**
** Z2: Napisa� procedur� szukaj�c� firm z paramertrami
** @nazwa_wzor nvarchar(20) = NULL
** @nazwa_skr_wzor nvarchar(20) = NULL
** @pokaz_zarobki bit = 0
** Procedura ma mie� zmienn� @sql nvarchar(1000), kt�r� buduje dynamicznie
** @pokaz_zarobki = 0 => (nazwa_skr, nazwa, nazwa_miasta)
** @pokaz_zarobki = 1 => (nazwa_skr, nazwa, srednia_z_akt_etatow)
** Mozliwe wywo�ania: EXEC sz_f @nazwa_wzor = N'%Polit%'
** powinno zbudowa� zmienn� tekstow� 
** @sql = N'SELECT f.*, m.nazwa AS nazwa_miasta FROM firmy o join miasta m "
**   + N' ON (m.id_miasta=f.id_miasta)  WHERE f.nazwa LIKE N''%POLIT%'' '
** uruchomienie zapytania to EXEC sp_sqlExec @sql
** rekomenduj� aby najpierw procedura zwraca�a zapytanie SELECT @sql
** a dopiero jak b�d� poprawne uruachamia�a je
*/


--Z6.1
--ALTER TABLE FIRMY ADD NIP nvarchar(20) NULL, NIP_BK nvarchar(20) NULL
 
SELECT * from FIRMY

GO
CREATE TRIGGER dbo.TR_NIP ON FIRMY for INSERT, UPDATE
AS

	IF UPDATE(NIP) 
	BEGIN
		UPDATE firmy SET NIP_BK = REPLACE(REPLACE(NIP,N' ', N''), N'-',N'')
		WHERE nazwa_skr IN 
		(	SELECT i.nazwa_skr 
				FROM inserted i 
				WHERE i.NIP LIKE N'%-%' OR i.NIP LIKE N'% %') 
	
		UPDATE firmy SET NIP_BK = NIP
		WHERE nazwa_skr IN 
		(	SELECT i.nazwa_skr 
				FROM inserted i 
				WHERE i.NIP NOT LIKE N'%-%' AND i.NIP NOT LIKE N'% %') 
	END

GO

SELECT * FROM FIRMY
/*PRZED:
nazwa_skr id_miasta   nazwa                                              kod_pocztowy ulica                                              NIP                  NIP_BK
--------- ----------- -------------------------------------------------- ------------ -------------------------------------------------- -------------------- --------------------
DRUT      1           Drutex                                             02645        Czere�niowa                                        NULL                 NULL
GOK       7           Wynajem Gokart�w                                   11678        Rajdowa                                            NULL                 NULL
GRUZ      2           Us�ugi Gruzowe                                     04123        Betonowa                                           NULL                 NULL
JKS       1           JakubczykSynowie                                   02579        Konwaliowa                                         NULL                 NULL
JKSP      1           JanuszKo���Spedycja                                02578        Wi�niowa                                           NULL                 NULL
KOLB      4           Zak�ad Produkcyjny Kolba                           06432        Krajowa                                            NULL                 NULL
KOLO      5           Sedesy KOLO                                        09905        Wa��sy                                             NULL                 NULL
KONO      8           Szewc Konopia                                      42069        Indyjska                                           NULL                 NULL

(8 row(s) affected)
*/


UPDATE FIRMY SET NIP = N'1847-14 980 89' WHERE nazwa_skr = N'DRUT'
SELECT * FROM FIRMY
/* PO:

(1 row(s) affected)

(0 row(s) affected)

(1 row(s) affected)
nazwa_skr id_miasta   nazwa                                              kod_pocztowy ulica                                              NIP                  NIP_BK
--------- ----------- -------------------------------------------------- ------------ -------------------------------------------------- -------------------- --------------------
DRUT      1           Drutex                                             02645        Czere�niowa                                        1847-14 980 89       18471498089
GOK       7           Wynajem Gokart�w                                   11678        Rajdowa                                            NULL                 NULL
GRUZ      2           Us�ugi Gruzowe                                     04123        Betonowa                                           NULL                 NULL
JKS       1           JakubczykSynowie                                   02579        Konwaliowa                                         NULL                 NULL
JKSP      1           JanuszKo���Spedycja                                02578        Wi�niowa                                           NULL                 NULL
KOLB      4           Zak�ad Produkcyjny Kolba                           06432        Krajowa                                            NULL                 NULL
KOLO      5           Sedesy KOLO                                        09905        Wa��sy                                             NULL                 NULL
KONO      8           Szewc Konopia                                      42069        Indyjska                                           NULL                 NULL

(8 row(s) affected)
*/ 

UPDATE FIRMY SET NIP = N'46189843' WHERE nazwa_skr = N'KOLB'
SELECT * FROM FIRMY
/*

(0 row(s) affected)

(1 row(s) affected)

(1 row(s) affected)
nazwa_skr id_miasta   nazwa                                              kod_pocztowy ulica                                              NIP                  NIP_BK
--------- ----------- -------------------------------------------------- ------------ -------------------------------------------------- -------------------- --------------------
DRUT      1           Drutex                                             02645        Czere�niowa                                        1847-14 980 89       18471498089
GOK       7           Wynajem Gokart�w                                   11678        Rajdowa                                            NULL                 NULL
GRUZ      2           Us�ugi Gruzowe                                     04123        Betonowa                                           NULL                 NULL
JKS       1           JakubczykSynowie                                   02579        Konwaliowa                                         NULL                 NULL
JKSP      1           JanuszKo���Spedycja                                02578        Wi�niowa                                           NULL                 NULL
KOLB      4           Zak�ad Produkcyjny Kolba                           06432        Krajowa                                            46189843             46189843
KOLO      5           Sedesy KOLO                                        09905        Wa��sy                                             NULL                 NULL
KONO      8           Szewc Konopia                                      42069        Indyjska                                           NULL                 NULL

(8 row(s) affected)
*/



--Z6.2

EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'ZAD6'

GO
ALTER PROCEDURE ZAD6 (@nazwa_wzor nvarchar(20) = NULL, @nazwa_skr_wzor nvarchar(20) = NULL, @pokaz_zarobki bit = 0, @sql nvarchar(1000)= null)
AS	
	IF @pokaz_zarobki=0
		BEGIN
		IF @nazwa_wzor IS NOT NULL
			BEGIN
			SET @sql = N'SELECT f.nazwa_skr, f.nazwa, m.nazwa FROM FIRMY f join MIASTA m ON (f.id_miasta=m.id_miasta) WHERE f.nazwa LIKE N''' + @nazwa_wzor + N''''
			SELECT @sql
			EXEC sp_sqlexec @sql
			END
		ELSE 
			BEGIN
			IF @nazwa_skr_wzor IS NOT NULL
				BEGIN
				SET @sql = N'SELECT f.nazwa_skr, f.nazwa, m.nazwa FROM FIRMY f join MIASTA m ON (f.id_miasta=m.id_miasta) WHERE f.nazwa_skr LIKE N''' + @nazwa_skr_wzor + N''''
				SELECT @sql
				EXEC sp_sqlexec @sql
				END
			ELSE
				SELECT N'Nie podano argument�w';
			END;
		END;
	ELSE
		BEGIN
		IF @nazwa_wzor IS NOT NULL
			BEGIN
			SET @sql = N'SELECT f.nazwa_skr, f.nazwa, X.srednia FROM FIRMY f left outer join (SELECT avg(e.pensja) AS srednia, f.nazwa AS nazwaf
			FROM ETATY e join FIRMY f ON (e.id_firmy=f.nazwa_skr)
			WHERE e.do IS NULL GROUP BY f.nazwa ) X ON (X.nazwaf=f.nazwa) WHERE f.nazwa LIKE N''' + @nazwa_wzor + N'''' 
			SELECT @sql
			EXEC sp_sqlexec @sql
			END
		ELSE 
			BEGIN
			IF @nazwa_skr_wzor IS NOT NULL
				BEGIN
				SET @sql = N'SELECT f.nazwa_skr, f.nazwa, X.srednia FROM FIRMY f left outer join (SELECT avg(e.pensja) AS srednia, f.nazwa AS nazwaf
				FROM ETATY e join FIRMY f ON (e.id_firmy=f.nazwa_skr)
				WHERE e.do IS NULL GROUP BY f.nazwa ) X ON (X.nazwaf=f.nazwa) WHERE f.nazwa_skr LIKE N''' + @nazwa_skr_wzor + N'''' 
				SELECT @sql
				EXEC sp_sqlexec @sql
				END
			ELSE
				SELECT N'Nie podano argument�w';
			END;
		END;
GO


EXEC ZAD6 @nazwa_wzor = N'%j%'
/*

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT f.nazwa_skr, f.nazwa, m.nazwa FROM FIRMY f join MIASTA m ON (f.id_miasta=m.id_miasta) WHERE f.nazwa LIKE N'%j%'

(1 row(s) affected)

nazwa_skr nazwa                                              nazwa
--------- -------------------------------------------------- --------------------------------------------------
GOK       Wynajem Gokart�w                                   Bia�ystok
JKS       JakubczykSynowie                                   Warszawa
JKSP      JanuszKo���Spedycja                                Warszawa
KOLB      Zak�ad Produkcyjny Kolba                           Pruszk�w

(4 row(s) affected)

*/


EXEC ZAD6 @nazwa_wzor = N'%j%', @pokaz_zarobki = 1
/*

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT f.nazwa_skr, f.nazwa, X.srednia FROM FIRMY f left outer join (SELECT avg(e.pensja) AS srednia, f.nazwa AS nazwaf
			FROM ETATY e join FIRMY f ON (e.id_firmy=f.nazwa_skr)
			WHERE e.do IS NULL GROUP BY f.nazwa ) X ON (X.nazwaf=f.nazwa) WHERE f.nazw

(1 row(s) affected)

nazwa_skr nazwa                                              srednia
--------- -------------------------------------------------- ---------------------
GOK       Wynajem Gokart�w                                   NULL
JKS       JakubczykSynowie                                   2300,00
JKSP      JanuszKo���Spedycja                                5300,00
KOLB      Zak�ad Produkcyjny Kolba                           2883,3333

(4 row(s) affected)
*/

EXEC ZAD6 @nazwa_skr_wzor = N'%o%'
/*

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT f.nazwa_skr, f.nazwa, m.nazwa FROM FIRMY f join MIASTA m ON (f.id_miasta=m.id_miasta) WHERE f.nazwa_skr LIKE N'%o%'

(1 row(s) affected)

nazwa_skr nazwa                                              nazwa
--------- -------------------------------------------------- --------------------------------------------------
GOK       Wynajem Gokart�w                                   Bia�ystok
KOLB      Zak�ad Produkcyjny Kolba                           Pruszk�w
KOLO      Sedesy KOLO                                        Sopot
KONO      Szewc Konopia                                      Suwa�ki

(4 row(s) affected)
*/

EXEC ZAD6 @nazwa_skr_wzor = N'%o%', @pokaz_zarobki = 1
/*

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT f.nazwa_skr, f.nazwa, X.srednia FROM FIRMY f left outer join (SELECT avg(e.pensja) AS srednia, f.nazwa AS nazwaf
				FROM ETATY e join FIRMY f ON (e.id_firmy=f.nazwa_skr)
				WHERE e.do IS NULL GROUP BY f.nazwa ) X ON (X.nazwaf=f.nazwa) WHERE f.na

(1 row(s) affected)

nazwa_skr nazwa                                              srednia
--------- -------------------------------------------------- ---------------------
GOK       Wynajem Gokart�w                                   NULL
KOLB      Zak�ad Produkcyjny Kolba                           2883,3333
KOLO      Sedesy KOLO                                        NULL
KONO      Szewc Konopia                                      17500,00

(4 row(s) affected)
*/