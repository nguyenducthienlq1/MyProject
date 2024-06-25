create database QUANLILUONG
use QUANLILUONG
create table PHONGBAN(
	MaPB varchar(5) not null,
	TenPB nvarchar(50),
	primary key(MaPB),
)
create table NHANVIEN(
	MaNV varchar(5) not null,
	HoTen nvarchar(50),
	NgaySinh date,
	MaPB varchar(5) not null,
	MucLuong float,
	primary key(MaNV),
	foreign key(MaPB) references PHONGBAN(MaPB)
)
create table TAMUNG(
	SoPhieu varchar(5) not null,
	Ngay date,
	MaNV varchar(5) not null,
	SoTien float,
	primary key(SoPhieu),
	foreign key (MaNV) references NHANVIEN(MaNV)
)
create table CHAMCONG(
	MaNV varchar(5) not null,
	NgayGhiSo date not null,
	SoNgayCong int,
	primary key(MaNV,NgayGhiSo),
	foreign key(MaNV) references NHANVIEN(MaNV)
)
insert into PHONGBAN(MaPB,TenPB)
values	('P01',N'Hành chính'),
		('P02',N'Kinh Doanh'),
		('P03',N'Kĩ thuật'),
		('P04',N'Kế toán')
set dateformat dmy 
select * from PHONGBAN
insert into NHANVIEN (MaNV,HoTen,NgaySinh,MaPB,MucLuong)
values	('NV1',N'Nguyễn Lê Quang','04/05/1989','P02',8000000),
		('NV2',N'Trần Thu Hồng','01/05/1990','P04',7500000),
		('NV3',N'Hoàng Vũ Trần','04/05/1989','P03',9000000),
		('NV4',N'Ngô Việt Hùng','03/05/1990','P01',8000000),
		('NV5',N'Vũ Thanh Giang','01/05/1987','P02',5000000),
		('NV6',N'Trần Cao Cường','23/05/1986','P03',6000000),
		('NV7',N'Cao Thanh Sang','21/06/1985','P02',5000000)
select * from NHANVIEN	
insert into CHAMCONG(MaNV,NgayGhiSo,SoNgayCong)
values	('NV1','31/01/2019',24),
		('NV1','28/02/2019',25),
		('NV2','31/01/2019',20),
		('NV2','28/02/2019',22),
		('NV3','31/01/2019',26),
		('NV3','28/02/2019',5),
		('NV4','31/01/2019',20),
		('NV4','28/02/2019',25),
		('NV5','28/02/2019',18),
		('NV6','31/01/2019',24),
		('NV7','28/02/2019',4)
insert into TAMUNG(SoPhieu,Ngay,MaNV,SoTien)
values	('P01','05/01/2018','NV3',2000000),
		('P02','08/01/2018','NV4',1500000),
		('P03','10/02/2018','NV1',1200000),
		('P04','12/02/2018','NV3',1000000)
--a. 
select n1.MaNV,n1.HoTen,n1.NgaySinh,n1.MaPB
from NHANVIEN n1, NHANVIEN n2
where n1.NgaySinh = n2.NgaySinh and n1.MaNV <> n2.MaNV
--b
select top 1 p.MaPB,p.TenPB,count(n.MaNV) as N'S? nhân viên'
from PHONGBAN p join NHANVIEN n on p.MaPB = n.MaPB
group by p.MaPB,p.TenPB
order by count(n.MaNV) desc
--c
select n.MaNV,n.HoTen,n.NgaySinh,n.MaPB
from NHANVIEN n
where n.MaNV not in(
					select c.MaNV
					from CHAMCONG c		
					where c.NgayGhiSo like '%2019-01%'	
)
--d
select *
from NHANVIEN
where MaNV not in (
				select MaNV
				from TAMUNG
)
--e
select p.MaPB,p.TenPB,count(n.MaNV) as N'S? nhân viên'
from PHONGBAN p join NHANVIEN n on p.MaPB = n.MaPB
group by p.MaPB,p.TenPB