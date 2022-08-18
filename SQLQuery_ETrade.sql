-----------------------------E TRADE -----------------------------------------
-- 28.000 urun
-- 100.000+ Siparis
-- 500.000+ Siparis satiri
-- 100.000+ Fatura
-- 10.000   Musteri

-- Soru 1) ordersales tablsou üzerinde hangi sehirde ne kdarlik satis yapildi biligisini getir.
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
(Select SUM(LINETOTAL) from SALEORDERS where CITY = s.CITY and DAYOFWEEK_='03.ÇAR') AS CARSAMBA,
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

-- iliskisel DB sorgulama
set language turkish

select od.ıd, u.USERNAME_, u.NAMESURNAME, u.TELNR1, u.TELNR2, 
coun.COUNTRY, cit.CITY, tw.TOWN, ad.ADDRESSTEXT,
o.ID as ORDERID, 
itm.ITEMCODE, itm.ITEMNAME, itm.BRAND, itm.CATEGORY1, itm.CATEGORY2, itm.CATEGORY3, itm.CATEGORY4, 
od.AMOUNT, od.UNITPRICE, od.LINETOTAL, convert(date, o.date_) AS orderdate, convert(time, o.DATE_) AS ordertime, 
YEAR(o.DATE_), DATENAME(MONTH,o.DATE_) AS month_, DATENAME(DW, o.DATE_) AS dayofweek_
from ORDERS o
inner join USERS u on u.ıd = o.USERID
inner join ADDRESS ad on ad.ID = o.ADDRESSID
inner join COUNTRIES coun on coun.ID = ad.COUNTRYID
inner join CITIES cit on cit.ID = ad.CITYID
inner join TOWNS tw on tw.ID  = cit.ID
inner join ORDERDETAILS od on od.ID = o.ID
inner join ITEMS itm on itm.ID = od.ITEMID

select * from SALEORDERS -- baz alinan tablo

-- Soru 7) tablolari join ile birlestirerek salesorders tablosunu doldur
-- once salesordes tablosu delete edildi sonra select into deyimi ile alanlar eklendi
set language turkish

select od.ıd, u.USERNAME_, u.NAMESURNAME, u.TELNR1, u.TELNR2, 
coun.COUNTRY, cit.CITY, tw.TOWN, ad.ADDRESSTEXT,
o.ID as ORDERID, 
itm.ITEMCODE, itm.ITEMNAME, itm.BRAND, itm.CATEGORY1, itm.CATEGORY2, itm.CATEGORY3, itm.CATEGORY4, 
od.AMOUNT, od.UNITPRICE, od.LINETOTAL, convert(date, o.date_) AS orderdate, convert(time, o.DATE_) AS ordertime, 
YEAR(o.DATE_) AS year_, DATENAME(MONTH,o.DATE_) AS month_, DATENAME(DW, o.DATE_) AS dayofweek_
INTO SALESORDERS
from ORDERS o
inner join USERS u on u.ıd = o.USERID
inner join ADDRESS ad on ad.ID = o.ADDRESSID
inner join COUNTRIES coun on coun.ID = ad.COUNTRYID
inner join CITIES cit on cit.ID = ad.CITYID
inner join TOWNS tw on tw.ID  = cit.ID
inner join ORDERDETAILS od on od.ID = o.ID
inner join ITEMS itm on itm.ID = od.ITEMID

select * from SALESORDERS -- konrtol ettim veriler geldi.

-- Soru 8) iliskisel tablolari kullanarak hangi sehirde ne kadarlik satis yapildi bilgisini getir.
select ct.CITY, sum(o.TOTALPRICE) AS totalprice
from ORDERS o 
inner join ADDRESS adrs on adrs.ID = o.ADDRESSID
inner join CITIES ct on ct.ID = adrs.CITYID
group by ct.CITY
order by 1
	-- 2. cozum alt sorgu
select *,
(select SUM(TOTALPRICE) as totalprice from ORDERS where ADDRESSID IN 
	(
	select ıd from ADDRESS where CITYID=ct.ID
	)
)
from CITIES ct

-- Soru 9) her markanin ana katagoriye gore en cok satan category1 alanini sekildeki gibi getir.
select ı.BRAND, ı.CATEGORY1, SUM(o.LINETOTAL) AS TotalPrice
from ITEMS ı
inner join ORDERDETAILS o on o.ITEMID = ı.ID
group by ı.BRAND, ı.CATEGORY1
order by BRAND, TotalPrice DESC

-- Soru 10) Her kategorinin icersinde en cok satan markayi getir.
select ı.CATEGORY1,ı.BRAND, SUM(o.LINETOTAL) AS TotalPrice
from ITEMS ı
inner join ORDERDETAILS o on o.ITEMID = ı.ID
group by  ı.CATEGORY1,BRAND
order by  TotalPrice DESC, ı.CATEGORY1
