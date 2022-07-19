--soru 1) ID ile beraber veri eklemek
select * from CITIES
delete from CITIES where ID=6
set IDENTITY_INSERT CITIES ON
insert into CITIES (ID,CITY) VALUES (6, ‘ANKARA’)

--soru 2)kim hangi operatörü kullanýyor / kaç kiþi kullanýyor 
select CUSTOMERNAME, TELNR1, TELNR2,
TELNR1_XOPERATORCOUNT+TELNR2_XOPERATORCOUNT as XOPERATORCOUNT,
TELNR1_YOPERATORCOUNT+TELNR2_YOPERATORCOUNT as YOPERATORCOUNT,
TELNR1_ZOPERATORCOUNT+TELNR2_ZOPERATORCOUNT as ZOPERATORCOUNT
from(
select
--TELNR1 için
case
when TELNR1 like '(50%' or TELNR1 like '(55%' then 1
else 0
END as TELNR1_XOPERATORCOUNT,
case
when TELNR1 like '(54%' then 1
else 0
END as TELNR1_YOPERATORCOUNT,
case
when TELNR1 like '(53%' then 1
else 0
END as TELNR1_ZOPERATORCOUNT,
--TELNR2 için
case
when TELNR2 like '(50%' or TELNR2 like '(55%' then 1
else 0
END as TELNR2_XOPERATORCOUNT,
case
when TELNR2 like '(54%' then 1
else 0
END as TELNR2_YOPERATORCOUNT,
case
when TELNR2 like '(53%' then 1
else 0
END as TELNR2_ZOPERATORCOUNT,
--TELNR1,TELNR2,
from CUSTOMERS
) T

--soru 3) Her ilde en çok müþteriye sahip ilçeleri m. sayýsýna göre çoktan aza sýrala
select ct.CITY,d.DISTRICT,COUNT(c.ID) as customercount
from CUSTOMERS c
inner join CITIES ct on ct.ID=c.CITYID
inner join DISTRICTS d on d.ID=c.DISTRICTID
group by ct.CITY, d.DISTRICT
order by ct.CITY, COUNT(c.ID) desc

--soru 4)Ýstenilen dil ile veri getirmek ve doðumgünü getirmek 
set language Norwegian
select
customername,DATENAME(DW, BIRTHDATE) as DogumGünü,BIRTHDATE,
* from CUSTOMERS