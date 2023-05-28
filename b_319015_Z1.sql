/* Oskar Biwejnis 319015
*/

--usuniêcie tabel je¿eli ju¿ istniej¹
IF OBJECT_ID(N'ETATY') IS NOT NULL
	DROP TABLE ETATY
GO
IF OBJECT_ID(N'FIRMY') IS NOT NULL
	DROP TABLE FIRMY
GO

IF OBJECT_ID(N'OSOBY') IS NOT NULL
	DROP TABLE OSOBY
GO

IF OBJECT_ID(N'MIASTA') IS NOT NULL
	DROP TABLE MIASTA
GO

IF OBJECT_ID(N'WOJ') IS NOT NULL
	DROP TABLE WOJ
GO


CREATE TABLE dbo.WOJ 
(	kod_woj nchar(4)	NOT NULL CONSTRAINT PK_WOJ PRIMARY KEY
,	nazwa	nvarchar(50) NOT NULL
)
GO
CREATE TABLE dbo.MIASTA
(	id_miasta	int				not null IDENTITY CONSTRAINT PK_MIASTA PRIMARY KEY
,	nazwa		nvarchar(50)	NOT NULL
,	kod_woj		nchar(4)		NOT NULL 
	CONSTRAINT FK_MIASTA_WOJ FOREIGN KEY REFERENCES WOJ(kod_woj) 
)
GO
CREATE TABLE dbo.OSOBY
(	id_miasta	int				not null CONSTRAINT FK_OSOBY_MIASTA FOREIGN KEY
		REFERENCES MIASTA(id_miasta)
,	imie		nvarchar(50)	NOT NULL
,	nazwisko	nvarchar(50)	NOT NULL 
,	id_osoby int NOT NULL IDENTITY	CONSTRAINT PK_OSOBY PRIMARY KEY
)
GO
CREATE TABLE dbo.FIRMY
(	nazwa_skr nchar(4) not null CONSTRAINT PK_FIRMY PRIMARY KEY
,	id_miasta int  not null CONSTRAINT FK_FIRMY_MIASTA FOREIGN KEY REFERENCES MIASTA(id_miasta)
,	nazwa nvarchar(50) not null 
,	kod_pocztowy nchar(5) not null 
,	ulica nvarchar(50) not null	
)
GO
CREATE TABLE dbo.ETATY
(	id_osoby int not null CONSTRAINT FK_ETATY_OSOBY FOREIGN KEY REFERENCES dbo.OSOBY(id_osoby)
,	id_firmy nchar(4) not null CONSTRAINT FK_ETATY_FIRMY FOREIGN KEY REFERENCES FIRMY(nazwa_skr)
,	stanowisko nvarchar(70) not null
,	pensja money not null
,	od int	not null
,	do int null 
,	id_etatu int not null IDENTITY CONSTRAINT PK_ETATY PRIMARY KEY
)
GO

INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'MAZ', N'Mazowieckie')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'POM', N'Pomorskie')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'POD', N'Podlaskie')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'ZPOM', N'Zachodnio-Pomorskie')
INSERT INTO WOJ (kod_woj, nazwa) VALUES (N'WLKP', N'Wielkopolskie')

INSERT INTO MIASTA (nazwa, kod_woj) VALUES ( N'Warszawa', N'MAZ')
INSERT INTO MIASTA ( nazwa, kod_woj) VALUES ( N'Radom', N'MAZ')
INSERT INTO MIASTA ( nazwa, kod_woj) VALUES ( N'NowyDwórMazowiecki', N'MAZ')
INSERT INTO MIASTA ( nazwa, kod_woj) VALUES ( N'Pruszków', N'MAZ')
INSERT INTO MIASTA ( nazwa, kod_woj) VALUES ( N'Sopot', N'POM')
INSERT INTO MIASTA ( nazwa, kod_woj) VALUES ( N'Gdynia', N'POM')
INSERT INTO MIASTA (nazwa, kod_woj) VALUES ( N'Bia³ystok', N'POD')
INSERT INTO MIASTA (nazwa, kod_woj) VALUES ( N'Suwa³ki', N'POD')
INSERT INTO MIASTA ( nazwa, kod_woj) VALUES ( N'Augustów', N'POD')


INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES ( N'Janusz', N'Ko³êæ', 1)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Barbara', N'Ko³êæ', 1)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Czarek', N'Ko³êæ', 1)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Henryk', N'Czarnobrody', 2)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Franciszek', N'Czarnobrody', 2)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Weronika', N'Jaskra',3)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Adam', N'Jakubczyk',4)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Genowefa', N'Zilberstein',5)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Patryk', N'Warty',6)
INSERT INTO OSOBY (imie, nazwisko, id_miasta) VALUES (N'Jan', N'Niezbêdny',7)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Karolina', N'Plastelina',8)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Mieszko', N'Pierwszy',8)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Dariusz', N'Ska³a',8)
INSERT INTO OSOBY ( imie, nazwisko, id_miasta) VALUES (N'Kacper', N'Konopia',8)

INSERT INTO FIRMY (nazwa_skr, nazwa,id_miasta,kod_pocztowy,ulica) VALUES (N'DRUT',N'Drutex', 1, N'02645', N'Czereœniowa')
INSERT INTO FIRMY (nazwa_skr, nazwa,id_miasta,kod_pocztowy,ulica) VALUES (N'JKSP',N'JanuszKo³êæSpedycja', 1, N'02578', N'Wiœniowa')
INSERT INTO FIRMY (nazwa_skr, nazwa,id_miasta,kod_pocztowy,ulica) VALUES (N'JKS',N'JakubczykSynowie', 1, N'02579', N'Konwaliowa')
INSERT INTO FIRMY (nazwa_skr, nazwa,id_miasta,kod_pocztowy,ulica) VALUES (N'GRUZ',N'Us³ugi Gruzowe', 2, N'04123', N'Betonowa')
INSERT INTO FIRMY (nazwa_skr, nazwa,id_miasta,kod_pocztowy,ulica) VALUES (N'KOLB',N'Zak³ad Produkcyjny Kolba', 4, N'06432', N'Krajowa')
INSERT INTO FIRMY (nazwa_skr, nazwa,id_miasta,kod_pocztowy,ulica) VALUES (N'KONO',N'Szewc Konopia', 8, N'42069', N'Indyjska')
INSERT INTO FIRMY (nazwa_skr, nazwa,id_miasta,kod_pocztowy,ulica) VALUES (N'KOLO',N'Sedesy KOLO', 5, N'09905', N'Wa³êsy')
INSERT INTO FIRMY (nazwa_skr, nazwa,id_miasta,kod_pocztowy,ulica) VALUES (N'GOK',N'Wynajem Gokartów', 7, N'11678', N'Rajdowa')

INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'DRUT',1, N'Spawacz',2500,2000,2002)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'JKSP',2, N'Magazynier',3000,2003,2005)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'JKS',3, N'Ekspedient',4300,2007,2009)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'GRUZ',4, N'Starszy ³adunkowy',7500,2009,2010)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'KOLB',5, N'M³odszy pracownik',1500,2003,2004)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'KONO',6, N'Junior',6500,2006,2006)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'DRUT',7, N'Monter',4600,2008,2009)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'JKSP',8, N'Kierowca',4800,2001,2006)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'JKS',9, N'Podawacz kluczy francuskich',2300,2002,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'GRUZ',10, N'M³odszy ³adunkowy',2000,2011,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'KOLB',11, N'Spawacz',2900,2016,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'KONO',12, N'Dyrektor',22000,2019,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'KONO',13, N'Kierownik',13000,2020,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'DRUT',14, N'Mened¿er dzia³u marketingu',6800,2014,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'JKSP',1, N'Mechanik',5300,2020,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'KOLB',2, N'Informatyk',4550,2019,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'KOLB',3, N'Fabrykant',1200,2012,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'DRUT',4, N'Przedstawiciel handlowy',1900,2018,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'DRUT',5, N'Monter',8300,2013,null)
INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'GRUZ',6, N'Operator koparki',2500,2021,null)


/* wynik dzia³ania
(1 row(s) affected)

(1 row(s) affected)

(1 row(s) affected)

(1 row(s) affected)
.
.
.
(1 row(s) affected)
*/



SELECT * FROM WOJ
/*
kod_woj nazwa
------- --------------------------------------------------
MAZ     Mazowieckie
POD     Podlaskie
POM     Pomorskie
WLKP    Wielkopolskie
ZPOM    Zachodnio-Pomorskie

(5 row(s) affected)
*/
SELECT * FROM MIASTA
/*
id_miasta   nazwa                                              kod_woj
----------- -------------------------------------------------- -------
1           Warszawa                                           MAZ 
2           Radom                                              MAZ 
3           NowyDwórMazowiecki                                 MAZ 
4           Pruszków                                           MAZ 
5           Sopot                                              POM 
6           Gdynia                                             POM 
7           Bia³ystok                                          POD 
8           Suwa³ki                                            POD 
9           Augustów                                           POD 

(9 row(s) affected)
*/
SELECT * FROM FIRMY
/*
nazwa_skr id_miasta   nazwa                                              kod_pocztowy ulica
--------- ----------- -------------------------------------------------- ------------ --------------------------------------------------
DRUT      1           Drutex                                             02645        Czereœniowa
GOK       7           Wynajem Gokartów                                   11678        Rajdowa
GRUZ      2           Us³ugi Gruzowe                                     04123        Betonowa
JKS       1           JakubczykSynowie                                   02579        Konwaliowa
JKSP      1           JanuszKo³êæSpedycja                                02578        Wiœniowa
KOLB      4           Zak³ad Produkcyjny Kolba                           06432        Krajowa
KOLO      5           Sedesy KOLO                                        09905        Wa³êsy
KONO      8           Szewc Konopia                                      42069        Indyjska

(8 row(s) affected)
*/
SELECT * FROM OSOBY
/*
id_miasta   imie                                               nazwisko                                           id_osoby
----------- -------------------------------------------------- -------------------------------------------------- -----------
1           Janusz                                             Ko³êæ                                              1
1           Barbara                                            Ko³êæ                                              2
1           Czarek                                             Ko³êæ                                              3
2           Henryk                                             Czarnobrody                                        4
2           Franciszek                                         Czarnobrody                                        5
3           Weronika                                           Jaskra                                             6
4           Adam                                               Jakubczyk                                          7
5           Genowefa                                           Zilberstein                                        8
6           Patryk                                             Warty                                              9
7           Jan                                                Niezbêdny                                          10
8           Karolina                                           Plastelina                                         11
8           Mieszko                                            Pierwszy                                           12
8           Dariusz                                            Ska³a                                              13
8           Kacper                                             Konopia                                            14

(14 row(s) affected)
*/
SELECT * FROM ETATY
/*
id_osoby    id_firmy stanowisko                                                             pensja                od          do          id_etatu
----------- -------- ---------------------------------------------------------------------- --------------------- ----------- ----------- -----------
1           DRUT     Spawacz                                                                2500,00               2000        2002        1
2           JKSP     Magazynier                                                             3000,00               2003        2005        2
3           JKS      Ekspedient                                                             4300,00               2007        2009        3
4           GRUZ     Starszy ³adunkowy                                                      7500,00               2009        2010        4
5           KOLB     M³odszy pracownik                                                      1500,00               2003        2004        5
6           KONO     Junior                                                                 6500,00               2006        2006        6
7           DRUT     Monter                                                                 4600,00               2008        2009        7
8           JKSP     Kierowca                                                               4800,00               2001        2006        8
9           JKS      Podawacz kluczy francuskich                                            2300,00               2002        NULL        9
10          GRUZ     M³odszy ³adunkowy                                                      2000,00               2011        NULL        10
11          KOLB     Spawacz                                                                2900,00               2016        NULL        11
12          KONO     Dyrektor                                                               22000,00              2019        NULL        12
13          KONO     Kierownik                                                              13000,00              2020        NULL        13
14          DRUT     Mened¿er dzia³u marketingu                                             6800,00               2014        NULL        14
1           JKSP     Mechanik                                                               5300,00               2020        NULL        15
2           KOLB     Informatyk                                                             4550,00               2019        NULL        16
3           KOLB     Fabrykant                                                              1200,00               2012        NULL        17
4           DRUT     Przedstawiciel handlowy                                                1900,00               2018        NULL        18
5           DRUT     Monter                                                                 8300,00               2013        NULL        19
6           GRUZ     Operator koparki                                                       2500,00               2021        NULL        20

(20 row(s) affected)
*/


INSERT INTO ETATY (id_firmy,id_osoby,stanowisko,pensja,od,do) VALUES (N'JKS',29, N'Górnik',2800,2001,2002)
/*
Msg 547, Level 16, State 0, Line 1
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_ETATY_OSOBY". The conflict occurred in database "b_319015", table "dbo.OSOBY", column 'id_osoby'.
The statement has been terminated.
*/

DELETE FROM MIASTA WHERE  id_miasta = 1
/*
Msg 547, Level 16, State 0, Line 1
The DELETE statement conflicted with the REFERENCE constraint "FK_OSOBY_MIASTA". The conflict occurred in database "b_319015", table "dbo.OSOBY", column 'id_miasta'.
The statement has been terminated.
*/
DELETE FROM MIASTA WHERE  id_miasta = 9
-- (1 row(s) affected)


DROP TABLE OSOBY
/*
Msg 3726, Level 16, State 1, Line 1
Could not drop object 'OSOBY' because it is referenced by a FOREIGN KEY constraint.
*/

DROP TABLE ETATY
DROP TABLE OSOBY
-- Command(s) completed successfully.
