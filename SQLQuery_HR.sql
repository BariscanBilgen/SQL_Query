-- null olaný getir yani iþine devam edenleri
select * from person where outdate is null

-- departman bazlý halen çalýþan kadýn ve erkek sayýsý
select D.DEPARTMENT
, case
		when P.GENDER='E' then 'ERKEK'
		when P.GENDER='K' then 'KADIN'
END AS GENDER
,count(P.ID) 
from person P
inner join DEPARTMENT D on D.ID = P.DEPARTMENTID
where P.OUTDATE is null
group by D.DEPARTMENT, P.GENDER
order by D.DEPARTMENT, GENDER

-- departman bazlý halen çalýþan kadýn ve erkek sayýsý cinsiyetler satýr deðil sütunda olsun
select *,
(select COUNT(*) from PERSON where DEPARTMENTID=D.ID and GENDER='E' and OUTDATE is null ) AS ErkekÇaþýlan,
(select COUNT(*) from PERSON where DEPARTMENTID=D.ID and GENDER='K' and OUTDATE is null) AS KadýnÇaþýlþan
from DEPARTMENT D
order by D.DEPARTMENT

-- þef atamasý yapýldý. maaþ belirlencek. departman içim min max ort þef maaþý getir.
select s.POSITION, 
MIN(p.SALARY) AS minsalary, 
MAX(p.SALARY) as maxsalary, 
AVG(p.SALARY) as avgsalary
from PERSON P
inner join POSITION S on S.ID=P.POSITIONID
where P.OUTDATE is null
group by s.POSITION
having s.POSITION='PLANLAMA ÞEFÝ'
order by s.POSITION

-- her bir pozisyonda mevcut çalýþan sayýsý ve ort maaþlarý
select s.POSITION, 
count(p.ýd) as PersonCount,
ROUND(AVG(p.SALARY),0) as AvgSalary
from PERSON P
inner join POSITION S on S.ID=P.POSITIONID
where P.OUTDATE is null
group by s.POSITION
order by s.POSITION

-- yýllara göre iþe alýnan pers sayýsýný kadýn erkek bazýnda listele
select DISTINCT YEAR(P.INDATE)  year_,
(select COUNT(*) from PERSON where  GENDER='E' and YEAR(INDATE)=YEAR(p.INDATE) ) AS ErkekÇaþýlan,
(select COUNT(*) from PERSON where  GENDER='K' and YEAR(INDATE)=YEAR(p.INDATE) ) AS KadýnÇaþýlan
from PERSON P
order by year_

-- personellerin çalýþma süresi
select (NAME_ +' '+ SURNAME) as person,
INDATE,OUTDATE, 
case
	when outdate is not null then 'iþten ayrýldý.'
	else 'Devam Ediyor'
end as Durum,
DATEDIFF(MONTH,INDATE,GETDATE()) as CalismaSuresi 
from PERSON


--þirketin 5.yýlýnda herkesin ad soyad ilk harfi olan aajanda bastýrýcak. hangi harf kombinasyonundan en az ne kadar
--sayýda ajanda bastýrýcak ? ve iki isimi olanlarýn ilk isminin ilk harfi alýnýcak.
select 
SUBSTRING(NAME_,1,1)+'.'+SUBSTRING(SURNAME,1,1)+'.' as ilkharfler,
COUNT(*) as CalisanAdet
from PERSON
group by SUBSTRING(NAME_,1,1),SUBSTRING(SURNAME,1,1)
order by COUNT(*) desc


-- maaþ ort 5500 TL'den fazla olan departmanlarý listele
select D.DEPARTMENT, ROUND(AVG(p.SALARY),0) as AvgSalary
from DEPARTMENT D
inner join PERSON P on P.DEPARTMENTID= D.ID
group by D.DEPARTMENT
HAVING AVG(p.SALARY)>5500

--departmanlarýn ortalama kýdemini ay olarak hesaplayacak ve þekildeki gibi çekecek.
select department,AVG(CalismaZamani) as AVG_CalismaZamani from(
select DP.department,
CASE When OUTDATE is not null then DATEDIFF(MONTH,INDATE,OUTDATE)
else DATEDIFF(MONTH,INDATE,GETDATE()) end as CalismaZamani
from  PERSON p
inner join DEPARTMENT DP on DP.ID=p.DEPARTMENTID
) T group by DEPARTMENT 
order by 1

--her personelin adýný, pozisyonunu, baðlý olduðu  birimin yöneticisinin adý ve pozsiyonunu getir.
select (p.NAME_+' '+p.SURNAME) AS PersonelAdi,
ps.POSITION AS PersonelPozisyon,
(p2.NAME_+' '+p2.SURNAME) AS YonteciAdi, 
ps2.POSITION AS YoneticiPozisyon
from PERSON p
inner join person p2 on p2.ID = p.MANAGERID
inner join POSITION PS on ps.ID=p.POSITIONID  
inner join POSITION PS2 on ps2.ID=p2.PARENTPOSITIONID 
order by ps.POSITION