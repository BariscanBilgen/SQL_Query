-- null olan� getir yani i�ine devam edenleri
select * from person where outdate is null

-- departman bazl� halen �al��an kad�n ve erkek say�s�
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

-- departman bazl� halen �al��an kad�n ve erkek say�s� cinsiyetler sat�r de�il s�tunda olsun
select *,
(select COUNT(*) from PERSON where DEPARTMENTID=D.ID and GENDER='E' and OUTDATE is null ) AS Erkek�a��lan,
(select COUNT(*) from PERSON where DEPARTMENTID=D.ID and GENDER='K' and OUTDATE is null) AS Kad�n�a��l�an
from DEPARTMENT D
order by D.DEPARTMENT

-- �ef atamas� yap�ld�. maa� belirlencek. departman i�im min max ort �ef maa�� getir.
select s.POSITION, 
MIN(p.SALARY) AS minsalary, 
MAX(p.SALARY) as maxsalary, 
AVG(p.SALARY) as avgsalary
from PERSON P
inner join POSITION S on S.ID=P.POSITIONID
where P.OUTDATE is null
group by s.POSITION
having s.POSITION='PLANLAMA �EF�'
order by s.POSITION

-- her bir pozisyonda mevcut �al��an say�s� ve ort maa�lar�
select s.POSITION, 
count(p.�d) as PersonCount,
ROUND(AVG(p.SALARY),0) as AvgSalary
from PERSON P
inner join POSITION S on S.ID=P.POSITIONID
where P.OUTDATE is null
group by s.POSITION
order by s.POSITION

-- y�llara g�re i�e al�nan pers say�s�n� kad�n erkek baz�nda listele
select DISTINCT YEAR(P.INDATE)  year_,
(select COUNT(*) from PERSON where  GENDER='E' and YEAR(INDATE)=YEAR(p.INDATE) ) AS Erkek�a��lan,
(select COUNT(*) from PERSON where  GENDER='K' and YEAR(INDATE)=YEAR(p.INDATE) ) AS Kad�n�a��lan
from PERSON P
order by year_

-- personellerin �al��ma s�resi
select (NAME_ +' '+ SURNAME) as person,
INDATE,OUTDATE, 
case
	when outdate is not null then 'i�ten ayr�ld�.'
	else 'Devam Ediyor'
end as Durum,
DATEDIFF(MONTH,INDATE,GETDATE()) as CalismaSuresi 
from PERSON


--�irketin 5.y�l�nda herkesin ad soyad ilk harfi olan aajanda bast�r�cak. hangi harf kombinasyonundan en az ne kadar
--say�da ajanda bast�r�cak ? ve iki isimi olanlar�n ilk isminin ilk harfi al�n�cak.
select 
SUBSTRING(NAME_,1,1)+'.'+SUBSTRING(SURNAME,1,1)+'.' as ilkharfler,
COUNT(*) as CalisanAdet
from PERSON
group by SUBSTRING(NAME_,1,1),SUBSTRING(SURNAME,1,1)
order by COUNT(*) desc


-- maa� ort 5500 TL'den fazla olan departmanlar� listele
select D.DEPARTMENT, ROUND(AVG(p.SALARY),0) as AvgSalary
from DEPARTMENT D
inner join PERSON P on P.DEPARTMENTID= D.ID
group by D.DEPARTMENT
HAVING AVG(p.SALARY)>5500

--departmanlar�n ortalama k�demini ay olarak hesaplayacak ve �ekildeki gibi �ekecek.
select department,AVG(CalismaZamani) as AVG_CalismaZamani from(
select DP.department,
CASE When OUTDATE is not null then DATEDIFF(MONTH,INDATE,OUTDATE)
else DATEDIFF(MONTH,INDATE,GETDATE()) end as CalismaZamani
from  PERSON p
inner join DEPARTMENT DP on DP.ID=p.DEPARTMENTID
) T group by DEPARTMENT 
order by 1

--her personelin ad�n�, pozisyonunu, ba�l� oldu�u  birimin y�neticisinin ad� ve pozsiyonunu getir.
select (p.NAME_+' '+p.SURNAME) AS PersonelAdi,
ps.POSITION AS PersonelPozisyon,
(p2.NAME_+' '+p2.SURNAME) AS YonteciAdi, 
ps2.POSITION AS YoneticiPozisyon
from PERSON p
inner join person p2 on p2.ID = p.MANAGERID
inner join POSITION PS on ps.ID=p.POSITIONID  
inner join POSITION PS2 on ps2.ID=p2.PARENTPOSITIONID 
order by ps.POSITION