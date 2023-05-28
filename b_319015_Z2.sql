/*
Z2, Oskar Biwejnis GR 2, 319015

    1 Pokazaæ dane podstawowe osoby, w jakim mieœcie mieszka i w jakim to jest województwie

    2 Pokazaæ wszystkie osoby o nazwisku na literê M i ostatniej literze nazwiska i lub a
    (je¿eli nie macie takowych to wybierzcie takie warunki - inn¹ literê pocz¹tkow¹ i inne 2 koñcowe)
    które maj¹ pensje pomiêdzy 3000 a 5000 (te¿ mo¿ecie zmieniæ je¿eli macie g³ownie inne zakresy)
    mieszkajace w innym mieœcie ni¿ znajduje siê firma, w której maj¹ etat
    (wystarcz¹ dane z tabel etaty, firmy, osoby , miasta)

    3 Pokazaæ kto ma najd³u¿sze nazwisko w bazie
    (najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z tak¹ d³ugoœci¹ nazwiska)

    4 Policzyæ liczbê osób w mieœcie o nazwie (tu dajê Wam wybór - w którym mieœcie macie najwiêcej)

*/


--Z1.
SELECT o.id_osoby, o.imie, o.nazwisko, m.nazwa AS N'miasto zamieszkania' , w.nazwa AS N'województwo'
 FROM OSOBY o join MIASTA m ON(o.id_miasta=m.id_miasta) join WOJ w ON(m.kod_woj=w.kod_woj)
 /* Zapytanie przedstawia imiê i nazwisko osoby, miasto zamieszkania oraz województwo w którym siê to miasto znajduje

 id_osoby    imie                                               nazwisko                                           miasto zamieszkania                                województwo
----------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
1           Janusz                                             Ko³êæ                                              Warszawa                                           Mazowieckie
2           Barbara                                            Ko³êæ                                              Warszawa                                           Mazowieckie
3           Czarek                                             Ko³êæ                                              Warszawa                                           Mazowieckie
4           Henryk                                             Czarnobrody                                        Radom                                              Mazowieckie
5           Franciszek                                         Czarnobrody                                        Radom                                              Mazowieckie
6           Weronika                                           Jaskra                                             NowyDwórMazowiecki                                 Mazowieckie
7           Adam                                               Jakubczyk                                          Pruszków                                           Mazowieckie
8           Genowefa                                           Zilberstein                                        Sopot                                              Pomorskie
9           Patryk                                             Warty                                              Gdynia                                             Pomorskie
10          Jan                                                Niezbêdny                                          Bia³ystok                                          Podlaskie
11          Karolina                                           Plastelina                                         Suwa³ki                                            Podlaskie
12          Mieszko                                            Pierwszy                                           Suwa³ki                                            Podlaskie
13          Dariusz                                            Ska³a                                              Suwa³ki                                            Podlaskie
14          Kacper                                             Konopia                                            Suwa³ki                                            Podlaskie

(14 row(s) affected)

Wynik zapytania spe³nia oczekiwania poniewa¿ zosta³y podane odpowiednie warunki ³¹cz¹ce: (o.id_miasta=m.id_miasta), (m.kod_woj=w.kod_woj)
*/

--Z2
SELECT o.id_osoby AS [ID osoby],
LEFT(o.imie,10) AS imie, 
LEFT(o.nazwisko,10) AS nazwisko, 
LEFT(mM.nazwa, 10) AS [Miasto zamieszkania], 
LEFT(m.nazwa,10) AS [Miasto pracy],
LEFT(f.nazwa_skr, 5) AS [ID firmy],
LEFT(f.nazwa, 30) AS [Pe³na nazwa firmy], 
e.pensja FROM OSOBY o 
join ETATY e ON (o.id_osoby = e.id_osoby)  
join FIRMY f ON (e.id_firmy = f.nazwa_skr) 
join MIASTA m ON (f.id_miasta = m.id_miasta)
join MIASTA mM ON (o.id_miasta = mM.id_miasta) 
WHERE (e.do IS NULL) 
AND(e.pensja>3000) 
AND (e.pensja<5000) 
AND (f.id_miasta != o.id_miasta)
AND ((o.nazwisko LIKE N'K%æ') OR (o.nazwisko LIKE N'K%œ'))
/* Wynik powy¿szego zapytania, jest jedna taka osoba:
ID osoby    imie       nazwisko   Miasto zamieszkania Miasto pracy ID firmy Pe³na nazwa firmy              pensja
----------- ---------- ---------- ------------------- ------------ -------- ------------------------------ ---------------------
2           Barbara    Ko³êæ      Warszawa            Pruszków     KOLB     Zak³ad Produkcyjny Kolba       4550,00

(1 row(s) affected)
*/




--Z3.
SELECT MAX(LEN(o.nazwisko)) AS N'D³ugoœæ nazwiska' FROM OSOBY o
/* Zapytanie pokazuje d³ugoœæ najd³u¿szego nazwiska osoby w bazie

-----------
11

(1 row(s) affected)

*/

SELECT o.id_osoby, o.imie, o.nazwisko, X.dn AS N'd³ugoœæ nazwiska' 
FROM OSOBY o join (SELECT MAX(LEN(o.nazwisko)) AS dn FROM OSOBY o) X ON (X.dn=LEN(o.nazwisko))
/* Zapytanie pokazuje osoy z najd³u¿szymi nazwiskami (po 11 znaków)
id_osoby    imie                                               nazwisko                                           d³ugoœæ nazwiska
----------- -------------------------------------------------- -------------------------------------------------- ----------------
4           Henryk                                             Czarnobrody                                        11
5           Franciszek                                         Czarnobrody                                        11
8           Genowefa                                           Zilberstein                                        11

(3 row(s) affected)

*/


--Z4.
DECLARE @nm nvarchar(20)
SET @nm = N'Suwa³ki'

SELECT COUNT(o.id_osoby) AS [Liczba mieszkañców], @nm AS [Nazwa miasta] FROM OSOBY o join MIASTA m ON (o.id_miasta = m.id_miasta) WHERE m.nazwa = @nm

/*
Liczba mieszkañców Nazwa miasta
------------------ --------------------
4                  Suwa³ki

(1 row(s) affected)
*/