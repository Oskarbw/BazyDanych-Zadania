/*
Z2, Oskar Biwejnis GR 2, 319015

    1 Pokaza� dane podstawowe osoby, w jakim mie�cie mieszka i w jakim to jest wojew�dztwie

    2 Pokaza� wszystkie osoby o nazwisku na liter� M i ostatniej literze nazwiska i lub a
    (je�eli nie macie takowych to wybierzcie takie warunki - inn� liter� pocz�tkow� i inne 2 ko�cowe)
    kt�re maj� pensje pomi�dzy 3000 a 5000 (te� mo�ecie zmieni� je�eli macie g�ownie inne zakresy)
    mieszkajace w innym mie�cie ni� znajduje si� firma, w kt�rej maj� etat
    (wystarcz� dane z tabel etaty, firmy, osoby , miasta)

    3 Pokaza� kto ma najd�u�sze nazwisko w bazie
    (najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z tak� d�ugo�ci� nazwiska)

    4 Policzy� liczb� os�b w mie�cie o nazwie (tu daj� Wam wyb�r - w kt�rym mie�cie macie najwi�cej)

*/


--Z1.
SELECT o.id_osoby, o.imie, o.nazwisko, m.nazwa AS N'miasto zamieszkania' , w.nazwa AS N'wojew�dztwo'
 FROM OSOBY o join MIASTA m ON(o.id_miasta=m.id_miasta) join WOJ w ON(m.kod_woj=w.kod_woj)
 /* Zapytanie przedstawia imi� i nazwisko osoby, miasto zamieszkania oraz wojew�dztwo w kt�rym si� to miasto znajduje

 id_osoby    imie                                               nazwisko                                           miasto zamieszkania                                wojew�dztwo
----------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
1           Janusz                                             Ko���                                              Warszawa                                           Mazowieckie
2           Barbara                                            Ko���                                              Warszawa                                           Mazowieckie
3           Czarek                                             Ko���                                              Warszawa                                           Mazowieckie
4           Henryk                                             Czarnobrody                                        Radom                                              Mazowieckie
5           Franciszek                                         Czarnobrody                                        Radom                                              Mazowieckie
6           Weronika                                           Jaskra                                             NowyDw�rMazowiecki                                 Mazowieckie
7           Adam                                               Jakubczyk                                          Pruszk�w                                           Mazowieckie
8           Genowefa                                           Zilberstein                                        Sopot                                              Pomorskie
9           Patryk                                             Warty                                              Gdynia                                             Pomorskie
10          Jan                                                Niezb�dny                                          Bia�ystok                                          Podlaskie
11          Karolina                                           Plastelina                                         Suwa�ki                                            Podlaskie
12          Mieszko                                            Pierwszy                                           Suwa�ki                                            Podlaskie
13          Dariusz                                            Ska�a                                              Suwa�ki                                            Podlaskie
14          Kacper                                             Konopia                                            Suwa�ki                                            Podlaskie

(14 row(s) affected)

Wynik zapytania spe�nia oczekiwania poniewa� zosta�y podane odpowiednie warunki ��cz�ce: (o.id_miasta=m.id_miasta), (m.kod_woj=w.kod_woj)
*/

--Z2
SELECT o.id_osoby AS [ID osoby],
LEFT(o.imie,10) AS imie, 
LEFT(o.nazwisko,10) AS nazwisko, 
LEFT(mM.nazwa, 10) AS [Miasto zamieszkania], 
LEFT(m.nazwa,10) AS [Miasto pracy],
LEFT(f.nazwa_skr, 5) AS [ID firmy],
LEFT(f.nazwa, 30) AS [Pe�na nazwa firmy], 
e.pensja FROM OSOBY o 
join ETATY e ON (o.id_osoby = e.id_osoby)  
join FIRMY f ON (e.id_firmy = f.nazwa_skr) 
join MIASTA m ON (f.id_miasta = m.id_miasta)
join MIASTA mM ON (o.id_miasta = mM.id_miasta) 
WHERE (e.do IS NULL) 
AND(e.pensja>3000) 
AND (e.pensja<5000) 
AND (f.id_miasta != o.id_miasta)
AND ((o.nazwisko LIKE N'K%�') OR (o.nazwisko LIKE N'K%�'))
/* Wynik powy�szego zapytania, jest jedna taka osoba:
ID osoby    imie       nazwisko   Miasto zamieszkania Miasto pracy ID firmy Pe�na nazwa firmy              pensja
----------- ---------- ---------- ------------------- ------------ -------- ------------------------------ ---------------------
2           Barbara    Ko���      Warszawa            Pruszk�w     KOLB     Zak�ad Produkcyjny Kolba       4550,00

(1 row(s) affected)
*/




--Z3.
SELECT MAX(LEN(o.nazwisko)) AS N'D�ugo�� nazwiska' FROM OSOBY o
/* Zapytanie pokazuje d�ugo�� najd�u�szego nazwiska osoby w bazie

-----------
11

(1 row(s) affected)

*/

SELECT o.id_osoby, o.imie, o.nazwisko, X.dn AS N'd�ugo�� nazwiska' 
FROM OSOBY o join (SELECT MAX(LEN(o.nazwisko)) AS dn FROM OSOBY o) X ON (X.dn=LEN(o.nazwisko))
/* Zapytanie pokazuje osoy z najd�u�szymi nazwiskami (po 11 znak�w)
id_osoby    imie                                               nazwisko                                           d�ugo�� nazwiska
----------- -------------------------------------------------- -------------------------------------------------- ----------------
4           Henryk                                             Czarnobrody                                        11
5           Franciszek                                         Czarnobrody                                        11
8           Genowefa                                           Zilberstein                                        11

(3 row(s) affected)

*/


--Z4.
DECLARE @nm nvarchar(20)
SET @nm = N'Suwa�ki'

SELECT COUNT(o.id_osoby) AS [Liczba mieszka�c�w], @nm AS [Nazwa miasta] FROM OSOBY o join MIASTA m ON (o.id_miasta = m.id_miasta) WHERE m.nazwa = @nm

/*
Liczba mieszka�c�w Nazwa miasta
------------------ --------------------
4                  Suwa�ki

(1 row(s) affected)
*/