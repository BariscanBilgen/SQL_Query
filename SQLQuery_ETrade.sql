-----------------------------E TRADE -----------------------------------------
-- 28.000 urun
-- 100.000+ Siparis
-- 500.000+ Siparis satiri
-- 100.000+ Fatura
-- 10.000   Musteri

-- Soru 1) ordersales tablsou �zerinde hangi sehirde ne kdarlik satis yapildi biligisini getir.
select CITY, SUM(LINETOTAL) AS TOTALSALE
from SALEORDERS
Group By CITY
Order By CITY

-- Soru 2) salesorders tablosunda sehirlere gore hangi ayda ne kadarlik satis yapildi bilgisini getir.
select 
CITY,MONTH_,SUM(LINETOTAL) AS TOTALSALE
from SALEORDERS
Group By CITY,MONTH_
Order By CITY

-- Soru 3) her ilin haftanin en cok hangi gununde satis yaptigini ogrenip ona gore sehir ve gunlerde ozel kampanya yapilcak.
-- sehirlerin haftanin gunlerine gore ne kadarlik satis yaptigini getiren sorguyu yap.
select 
CITY, DAYOFWEEK_, SUM(LINETOTAL) AS TOTALSALE
from SALEORDERS
Group By CITY, DAYOFWEEK_
Order By CITY,DAYOFWEEK_

-- Soru 4) Bir onceki soruyu gunleri sutun olarak getir.
Select 
DISTINCT CITY,
(Select SUM(LINETOTAL) from SALEORDERS where CITY = s.CITY and DAYOFWEEK_='01.PZT') AS PAZARTESI,
(Select SUM(LINETOTAL) from SALEORDERS where CITY = s.CITY and DAYOFWEEK_='02.SAL') AS SALI,
(Select SUM(LINETOTAL) from SALEORDERS where CITY = s.CITY and DAYOFWEEK_='03.�AR') AS CARSAMBA,
(Select SUM(LINETOTAL) from SALEORDERS where CITY = s.CITY and DAYOFWEEK_='04.PER') AS PERSEMBE,
(Select SUM(LINETOTAL) from SALEORDERS where CITY = s.CITY and DAYOFWEEK_='05.CUM') AS CUMA,
(Select SUM(LINETOTAL) from SALEORDERS where CITY = s.CITY and DAYOFWEEK_='06.CMT') AS CUMARTESI,
(Select SUM(LINETOTAL) from SALEORDERS where CITY = s.CITY and DAYOFWEEK_='07.PAZ') AS PAZAR
from SALEORDERS s
Order By 1

-- Soru 5) her ilin en cok satan ilk 5 kategorsini sekildeki gibi getiren sorguyu yaz.
Select 
s.CITY,s1.CATEGORY1,SUM(s1.TOTALSALE)AS TOTALSALE
from SALEORDERS s
CROSS APPLY (SELECT TOP 5 CATEGORY1, SUM(LINETOTAL)AS TOTALSALE from SALEORDERS where CITY=s.CITY Group By CATEGORY1 Order By 2 DESC) s1
Group By s.CITY, s1.CATEGORY1
Order By s.CITY,SUM(s1.TOTALSALE)

-- Soru 6) her sehirde en cok satis yapan 3 kategori ve onun altinda en cok satis yapilan 3 alt kategoriyi getiren sorgu.
Select 
s.CITY,s1.CATEGORY1,s2.CATEGORY2,SUM(s1.TOTALSALE)AS TOTALSALE
from SALEORDERS s
CROSS APPLY (SELECT TOP 3 CATEGORY1, SUM(LINETOTAL)AS TOTALSALE from SALEORDERS where CITY=s.CITY Group By CATEGORY1 Order By 2 DESC) s1
CROSS APPLY (SELECT TOP 3 CATEGORY2, SUM(LINETOTAL)AS TOTALSALE from SALEORDERS where CITY=s.CITY AND CATEGORY1=s1.CATEGORY1 Group By CATEGORY2 Order By 2 DESC) s2
Group By s.CITY, s1.CATEGORY1,s2.CATEGORY2
Order By 1, 2, 4 DESC