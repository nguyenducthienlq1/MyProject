Create database DVSCMT
use DVSCMT
Create table KHACHHANG (
	MaKH varchar(5) not null,
	TenKH nvarchar (20),
	NgaySinh date,
	DiaChi nvarchar (10),
	primary key (MaKH)
)
Create table DICHVU (
	MaDV varchar (10) not null,
	TenDV nvarchar (20),
	DVT nvarchar (5),
	DonGia int,
	primary key (MaDV)
)
Create table PHATSINH (
	SoPhieu varchar (5) not null,
	NgayLap date,
	MaKH varchar (5) not null,
	primary key (SoPhieu),
	foreign key (MaKH) references KHACHHANG(MaKH)
	)
Create table PHATSINHCHITIET (
	SoPhieu varchar (5) not null,
	MaDV varchar (10) not null,
	SoLuong int,
	primary key (SoPhieu, MaDV),
	foreign key (SoPhieu) references PHATSINH(SoPhieu),
	foreign key (MaDV) references DICHVU(MaDV)
)
Create table PHIEUTHU (
	SoPT varchar (5) not null,
	MaKH varchar (5) not null,
	Ngay date,
	SoTien int,
	primary key (SoPT),
	foreign key (MaKH) references KHACHHANG(MaKH)
)
Set Dateformat DMY
Insert into KHACHHANG (MaKH, TenKH, NgaySinh, Diachi) 
			values ('HNV', N'Nguyễn Văn Hoàng', '01/05/1992', N'TP.HCM'),
				   ('HTM', N'Trần Mộng Hoàng', '12/03/1989', N'Lâm Đồng'),
				   ('HVH', N'Vũ Hoàng Hải', '02/05/1982', N'Long An'),
				   ('TNT', N'Nguyễn Thị Thanh', '12/03/1989', N'Trà Vinh'),
				   ('TVTA', N'Vũ Thị Ánh Tuyết', '03/03/1987', N'Cà Mau')
Insert into DICHVU (MaDV, TenDV, DVT, DonGia) 
			values ('BanPhim', N'Sửa bàn phím', N'Cái', 20000),
				   ('Chuot', N'Sửa chuột', N'Con', 15000),
				   ('CPU', N'Sửa CPU', N'Cái', 200000),
				   ('Main', N'Sửa main', N'Cái', 180000),
				   ('Nguon', N'Sửa nguồn', N'Cái', 150000),
				   ('Win', N'Cài lại win', N'Lần', 200000)
Insert into PHATSINH (SoPhieu, NgayLap, MaKH)
			values ('SC01', '01/02/2018', 'HNV'),
				   ('SC02', '01/03/2018', 'HVH'),
				   ('SC03', '05/03/2018', 'TNT'),
				   ('SC04', '06/04/2018', 'TVTA'),
				   ('SC05', '06/04/2018', 'HNV'),
				   ('SC06', '20/05/2018', 'TNT'),
				   ('SC07', '06/08/2018', 'HVH')
Insert into PHATSINHCHITIET (SoPhieu, MaDV, SoLuong)
			values ('SC01', 'CPU', 1),
			       ('SC01', 'Win', 5),
				   ('SC02', 'CPU', 1),
				   ('SC03', 'Main', 1),
				   ('SC04', 'BanPhim', 126),
				   ('SC04', 'Chuot', 32),
				   ('SC04', 'CPU', 1),
				   ('SC05', 'BanPhim', 125),
				   ('SC05', 'CPU', 1),
				   ('SC05', 'Nguon', 86),
				   ('SC06', 'BanPhim', 149),
				   ('SC06', 'Chuot', 48),
				   ('SC06', 'Main', 1),
				   ('SC07', 'BanPhim', 94),
				   ('SC07', 'Chuot', 17),
				   ('SC07', 'CPU', 1),
				   ('SC07', 'Win', 1)
Insert into PHIEUTHU (SoPT, MaKH, Ngay, SoTien)
			values ('P001', 'HNV', '03/03/2018', 2975000),
				   ('P002', 'TNT', '11/05/2018', 2485000),
				   ('P003', 'HNV', '01/06/2018', 2500000),
				   ('P004', 'TVTA', '07/08/2018', 3110000),
				   ('P005', 'TNT', '23/06/2018', 3265000),
				   ('P006', 'HNV', '02/10/2018', 2235000)
select * from KHACHHANG
select * from DICHVU
select * from PHATSINH
select * from PHATSINHCHITIET
select * from PHIEUTHU
--a Tạo query liệt kê khách hàng phát sinh tổng phí dịch vụ sửa chữa nhỏ nhất
Select top 1 K.MaKH, K.TenKH, K.NgaySinh, K.DiaChi, sum (PH.SoLuong * D.DonGia) as N'Tổng Phí DV'
from KHACHHANG K join PHATSINH P on K.MaKH = P.MaKH
				 join PHATSINHCHITIET PH on P.SoPhieu = PH.SoPhieu
				 join DICHVU D on PH.MaDV = D.MaDV
group by K.MaKH, K.TenKH, K.NgaySinh, K.DiaChi
order by sum (PH.SoLuong * D.DonGia) asc 

--b Tạo query tìm các khách hàng có phát sinh phí dịch vụ sửa chữa nhưng chưa thanh toán
select MaKH, TenKH, NgaySinh, DiaChi
from KHACHHANG 
where MaKH in(
select MaKH
from PHATSINH 
where MaKH not in ( 
	select MaKH 
	from PHIEUTHU 
			)
)
--c Tạo query tìm các khách hàng sửa chữa cả 2 dịch vụ 'Chuot', 'CPU'
select *
from KHACHHANG
where MaKH in (
select MaKH
from PHATSINH 
where SoPhieu in(
select SoPhieu
from PHATSINHCHITIET
where MaDV like 'Chuot' and SoPhieu in (
select SoPhieu
from PHATSINHCHITIET 
where MaDV like 'CPU'
  )
 )
)
--d tạo query hiển thị thông tin của các phiếu sử dụng nhiều dịch vụ nhất
select *
from PHATSINH
where SoPhieu = (
	select top 1 PH.SoPhieu 
	from PHATSINHCHITIET PH join PHATSINH P on PH.SoPhieu = P.SoPhieu
	group by PH.SoPhieu
	order by sum(PH.SoLuong) desc 
	)
--e Tạo query cho biết thông tin đầy đủ của khách hàng chưa từng có sửa chữa gì
select *
from KHACHHANG 
where MaKH not in (
	select MaKH
	from PHATSINH )