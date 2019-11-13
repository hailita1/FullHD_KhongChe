--yêu cầu:
--trong sql, sửa khuyến mãi sang float trong table chi tiết hóa đơn nhập
--trong sql, sửa giảm giá sang float trong table chi tiết phiếu đặt bàn
create trigger DeleteNV on Que
for delete
as
begin
	delete from NhanVien where MaQue in (select MaQue from deleted)
end

create trigger DeletePDB1 on NhanVien
for delete
as
begin
	delete from PhieuDatBan where MaNhanVien in (select MaNhanVien from deleted)
end

create trigger DeletePDB2 on Khach
for delete
as
begin
	delete from PhieuDatBan where MaKhach in (select MaKhach from deleted)
end

--form nhân viên: mã quê là combobox, ngày sinh là datetime
create trigger DeleteHDN on NhanVien
for delete
as
begin
	delete from HoaDonNhap where MaNhanVien in (select MaNhanVien from deleted)
end
--form đặt bàn: mã khách và mã nhân viên là combobox, ngày đặt và ngày dùng là datetime, tổng tiền không cho nhập
use QLNhaHang
create trigger DeleteChiTietPDB on PhieuDatBan
for delete
as
begin
	delete from ChiTietPhieuDB where MaPhieu in (select MaPhieu from deleted)
end

create trigger TinhTongTien on ChiTietPhieuDB
for insert, update
as
begin
	declare @maphieu varchar(50), @tongtien float
	select @maphieu=MaPhieu
	from inserted
	select @tongtien=sum(ThanhTien)
	from ChiTietPhieuDB where MaPhieu=@maphieu
	update PhieuDatBan set TongTien=@tongtien where MaPhieu=@maphieu
end

create trigger UpdateTongTien on ChiTietPhieuDB
for delete
as
begin
	declare @maphieu varchar(50), @tongtien float
	select @maphieu=MaPhieu
	from deleted
	select @tongtien=sum(ThanhTien)
	from ChiTietPhieuDB where MaPhieu=@maphieu
	if(@tongtien is null)
		update PhieuDatBan set TongTien=0 where MaPhieu=@maphieu
	else
		update PhieuDatBan set TongTien=@tongtien where MaPhieu=@maphieu
end

create proc TongtienPDB @maphieu varchar(50), @tongtien float output
as
begin	
	select @tongtien=sum(ThanhTien)
	from ChiTietPhieuDB
	where MaPhieu=@maphieu
end

declare @tong float
exec TongtienPDB '001', @tong output

--form chi tiết đặt bàn: mã phiếu - mã món ăn - mã loại là combobox, số lượng chỉ cho nhập số, giảm giá chỉ cho nhập số và thêm lable %, thành tiền không cho nhập
create trigger TinhThanhTien on ChiTietPhieuDB
for insert, update
as
begin
	declare @maphieu varchar(50), @mamon varchar(50), @sl float, @giamgia float, @dongia float
	select @maphieu=MaPhieu, @mamon=MaMonAn, @sl=SoLuong, @giamgia=GiamGia
	from inserted
	select @dongia=DonGia
	from MonAn
	where MaMonAn=@mamon
	update ChiTietPhieuDB set ThanhTien=@sl*@dongia-(@giamgia/100)*@sl*@dongia where MaPhieu=@maphieu and MaMonAn=@mamon
end

create proc ThanhTien @maphieu varchar(50), @mamon varchar(50), @tien float output
as
begin
	declare @sl float, @giamgia float, @dongia float
	select @sl=SoLuong, @giamgia=GiamGia
	from ChiTietPhieuDB
	where MaPhieu=@maphieu and MaMonAn=@mamon
	select @dongia=DonGia
	from MonAn
	where MaMonAn=@mamon
	set @tien=@sl*@dongia-(@giamgia/100)*@sl*@dongia
end
declare @tien1 float
exec ThanhTien '001', '001', @tien1 output

--form món ăn: mã công dụng - mã loại là combobox, đơn giá không cho nhập
create trigger DeleteMaLoai on LoaiMon
for delete
as
begin
	delete from MonAn where MaLoai in (select MaLoai from deleted)
end

create trigger DeleteMaCongDung on CongDung
for delete
as
begin
	delete from MonAn where MaCongDung in (select MaCongDung from deleted)
end

create trigger DeleteNguyenLieuMonAn on MonAn
for delete
as
begin
	delete from NguyenLieu_MonAn where MaMonAn in (select MaMonAn from deleted)
end

create trigger DeleteChiTietPDN on MonAn
for delete
as
begin
	delete from ChiTietPhieuDB where MaMonAn in (select MaMonAn from deleted)
end



create proc DonGia @mamon varchar(50), @dongia float output
as
begin
	select @dongia=DonGia
	from MonAn
	where MaMonAn=@mamon
end
declare @gia float
exec DonGia '001', @gia output

--form nguyên liệu món ăn: mã món ăn - mã nguyên liệu là combobox, số lượng chỉ cho nhập số
--form nguyên liệu: số lượng không cho nhập, đơn giá nhập-bán không cho nhập
create trigger DeleteNguyenLieuMonAn1 on NguyenLieu
for delete
as
begin
	delete from NguyenLieu_MonAn where MaNguyenLieu in (select MaNguyenLieu from deleted)
end

create trigger DeleteNguyenLieu on ChiTietHoaDonNhap
for delete
as
begin
	delete from NguyenLieu where MaNguyenLieu in (select MaNguyenLieu from deleted)
end

create proc SoLuong @manl varchar(50), @sl float output, @gianhap float output, @giaban float output
as
begin
	select @sl=SoLuong, @gianhap=DonGiaNhap, @giaban=DonGiaBan
	from NguyenLieu
	where MaNguyenLieu=@manl
end
declare @sl1 float, @gianhap1 float, @giaban1 float
exec SoLuong '001', @sl1 output, @gianhap1 output, @giaban1 output

--form hóa đơn: ngày nhập là datetime, mã nhân viên - mã nhà cung cấp là combobox, tổng tiền không cho nhập
create trigger DeleteChiTietHDN on HoaDonNhap
for delete
as
begin
	delete from ChiTietHoaDonNhap where MaHoaDonNhap in (select MaHoaDonNhap from deleted)
end

create trigger DeleteHDN1 on NhaCungCap
for delete
as
begin
	delete from HoaDonNhap where MaNhaCungCap in (select MaNhaCungCap from deleted)
end

create trigger TinhTongTienHDN on ChiTietHoaDonNhap
for insert, update
as
begin
	declare  @mahdn varchar(50), @tongtien float
	select @mahdn=MaHoaDonNhap
	from inserted
	select @tongtien=sum(ThanhTien)
	from ChiTietHoaDonNhap where MaHoaDonNhap=@mahdn
	update HoaDonNhap set TongTien=@tongtien where MaHoaDonNhap=@mahdn
end

create trigger UpdateTongTienHDB on ChiTietHoaDonNhap
for delete
as
begin
	declare @mahdn varchar(50), @tongtien float
	select @mahdn=MaHoaDonNhap
	from deleted
	select @tongtien=sum(ThanhTien)
	from ChiTietHoaDonNhap where MaHoaDonNhap=@mahdn
	if(@tongtien is null)
		update HoaDonNhap set TongTien=0 where MaHoaDonNhap=@mahdn
	else
		update HoaDonNhap set TongTien=@tongtien where MaHoaDonNhap=@mahdn
end

create proc TongtienHDN @mahdn varchar(50), @tongtien float output
as
begin	
	select @tongtien=sum(ThanhTien)
	from ChiTietHoaDonNhap
	where MaHoaDonNhap=@mahdn
end

declare @tong float
exec TongtienHDN '001', @tong output

--form chi tiết HD: mã hóa đơn - mã nguyên liệu là combobox, số lượng và khuyến mãi và đơn giá chỉ cho nhập số, khuyến mãi thêm lable %, thành tiền không cho nhập
create trigger TinhThanhTienHDN on ChiTietHoaDonNhap
for insert, update
as
begin
	declare @mahdn varchar(50), @manl varchar(50), @sl float, @khuyenmai float, @dongia float
	select @mahdn=MaHoaDonNhap, @manl=MaNguyenLieu, @sl=SoLuong, @khuyenmai=KhuyenMai, @dongia=DonGia
	from inserted
	update ChiTietHoaDonNhap set ThanhTien=@sl*@dongia-(@khuyenmai/100)*@sl*@dongia where MaHoaDonNhap=@mahdn and MaNguyenLieu=@manl
end

create proc ThanhTienHD @mahdn varchar(50), @manl varchar(50), @tien float output
as
begin
	declare @sl float, @khuyenmai float, @dongia float
	select @sl=SoLuong, @khuyenmai=KhuyenMai, @dongia=DonGia
	from ChiTietHoaDonNhap
	where MaHoaDonNhap=@mahdn and MaNguyenLieu=@manl
	set @tien=@sl*@dongia-(@khuyenmai/100)*@sl*@dongia
end
declare @tien1 float
exec ThanhTienHD '001', '001', @tien1 output

--yêu cầu của cô trong file excel
use QLNhaHang
--1.tự động cập nhật số lượng trong table nguyên liệu
create trigger ThemNL on ChiTietHoaDonNhap
for insert, update
as
begin
	declare @manl varchar(50), @slnl float
	select @manl=MaNguyenLieu from inserted
	select @slnl=sum(SoLuong) from ChiTietHoaDonNhap where MaNguyenLieu=@manl
	update NguyenLieu set SoLuong=@slnl where MaNguyenLieu=@manl
end

create trigger GiamNL on ChiTietHoaDonNhap
for delete
as
begin
	declare @manl varchar(50), @slnl float
	select @manl=MaNguyenLieu from deleted
	select @slnl=sum(SoLuong) from ChiTietHoaDonNhap where MaNguyenLieu=@manl
	if(@slnl is null)
		update NguyenLieu set SoLuong=0, DonGiaNhap=0, DonGiaBan=0 where MaNguyenLieu=@manl
	else
		update NguyenLieu set SoLuong=@slnl where MaNguyenLieu=@manl
end

create trigger BotNL on NguyenLieu_MonAn
for insert, update
as
begin
	declare @manl varchar(50), @slnl float, @sl float
	select @manl=MaNguyenLieu from inserted
	select @sl=sum(SoLuong) from NguyenLieu_MonAn where MaNguyenLieu=@manl
	select @slnl=sum(SoLuong) from ChiTietHoaDonNhap where MaNguyenLieu=@manl
	if(@slnl is not null and @slnl>=@sl)
		update NguyenLieu set SoLuong=@slnl-@sl where MaNguyenLieu=@manl
	else
	begin
		raiserror('Số lượng nguyên liệu không đủ',16,1)
		rollback transaction
	end
end

create trigger TangNL on NguyenLieu_MonAn
for delete
as
begin
	declare @manl varchar(50), @sl float, @slnl float
	select @manl=MaNguyenLieu from deleted
	select @sl=sum(SoLuong) from NguyenLieu_MonAn where MaNguyenLieu=@manl
	select @slnl=sum(SoLuong) from ChiTietHoaDonNhap where MaNguyenLieu=@manl
	if(@sl is null)
		update NguyenLieu set SoLuong=@slnl where MaNguyenLieu=@manl
	else
		update NguyenLieu set SoLuong=@slnl-@sl where MaNguyenLieu=@manl
end

--2.cập nhất giá nhập trong table nguyên liệu
create trigger GiaNhapNL on ChiTietHoaDonNhap
for insert, update
as
begin
	declare @manl varchar(50), @gia float
	select @manl=MaNguyenLieu, @gia=DonGia from inserted
	update NguyenLieu set DonGiaNhap=@gia where MaNguyenLieu=@manl
	update NguyenLieu set DonGiaBan=@gia where MaNguyenLieu=@manl
end

create trigger CNGiaNhapNL on ChiTietHoaDonNhap
for delete
as
begin
	declare @manl varchar(50)
	select @manl=MaNguyenLieu from deleted
	update NguyenLieu set DonGiaNhap=0 where MaNguyenLieu=@manl
	update NguyenLieu set DonGiaBan=0 where MaNguyenLieu=@manl
end

--3.cập nhất giá bán trong table nguyên liệu
--create trigger GiaBanNL on ChiTietHoaDonNhap
--for insert, update
--as
--begin
--	declare @manl varchar(50), @gia float
--	select @manl=MaNguyenLieu, @gia=DonGia from inserted
--	update NguyenLieu set DonGiaBan=@gia where MaNguyenLieu=@manl
--end

--create trigger CNGiaBanNL on ChiTietHoaDonNhap
--for delete
--as
--begin
--	declare @manl varchar(50), @gia float
--	select @manl=MaNguyenLieu, @gia=DonGia from inserted
--	update NguyenLieu set DonGiaBan=@gia where MaNguyenLieu=@manl
--end

--4.cập nhật giá món ăn trong table món ăn
create trigger GiaBanMonAn on NguyenLieu_MonAn
for insert
as
begin
	declare @mamon varchar(50), @manl varchar(50), @sl float, @dongiaban float, @dongia float	
	select @mamon=MaMonAn, @manl=MaNguyenLieu, @sl=SoLuong from inserted
	select @dongiaban=DonGiaBan from NguyenLieu where MaNguyenLieu=@manl
	select @dongia=DonGia from MonAn where MaMonAn=@mamon
	if(@dongia is null)
		set @dongia=0
	set @dongia=@dongia+@sl*@dongiaban
	update MonAn set DonGia=@dongia where MaMonAn=@mamon
end

create trigger GiaBanMonAn1 on NguyenLieu_MonAn
for insert, update
as
begin
	declare @mamon varchar(50), @dongia float	
	select @mamon=MaMonAn from inserted
	select @dongia=sum(DonGiaBan*NguyenLieu_MonAn.SoLuong)
	from NguyenLieu, NguyenLieu_MonAn
	where NguyenLieu.MaNguyenLieu=NguyenLieu_MonAn.MaNguyenLieu and NguyenLieu_MonAn.MaMonAn=@mamon
	update MonAn set DonGia=@dongia where MaMonAn=@mamon
end

create trigger CNGiaBanMonAn on NguyenLieu_MonAn
for delete
as
begin
	declare @mamon varchar(50), @manl varchar(50), @sl float, @dongiaban float, @dongia float	
	select @mamon=MaMonAn, @manl=MaNguyenLieu, @sl=SoLuong from deleted
	select @dongiaban=DonGiaBan from NguyenLieu where MaNguyenLieu=@manl
	select @dongia=DonGia from MonAn where MaMonAn=@mamon
	set @dongia=@dongia-@sl*@dongiaban
	if(@dongia=0)
		update MonAn set DonGia=0 where MaMonAn=@mamon
	else
		update MonAn set DonGia=@dongia where MaMonAn=@mamon
end

--8. báo cáo tổng tiền thu đc của các phiếu đặt bàn theo tháng, quý, năm
--có 1 combobox để chọn báo cáo theo tháng/quý/năm, 1 textbox (nếu chọn tháng/quý thì đc nhập năm vào textbox)
--tháng, đối vào là năm
use QLNhaHang
create function TongTienThang(@nam int) returns table
as
return(
	select MONTH(NgayDat) as Thang, SUM(TongTien) as TongTien
	from PhieuDatBan
	where YEAR(NgayDat)=@nam
	group by MONTH(NgayDat)
)
select * from TongTienThang(2015)
--quý, đối vào là năm
create function TongTienQuy(@nam int) returns table
as
return(
	select MONTH(NgayDat) as Thang, SUM(TongTien) as TongTien
	from PhieuDatBan
	where YEAR(NgayDat)=@nam
	group by MONTH(NgayDat)
)
select * from TongTienThang(2015)
--năm
create function TongTienNam() returns table
as
return(
	select year(NgayDat) as Nam, SUM(TongTien) as TongTien
	from PhieuDatBan
	group by year(NgayDat)
)
select * from TongTienNam()

--9.báo cáo thông tin đầy đủ của các món ăn
create view BaoCaoMonAn
as
select TenMonAn, TenCongDung, TenLoai, CachLam, DonGia
from MonAn, CongDung, LoaiMon
where MonAn.MaCongDung=CongDung.MaCongDung and MonAn.MaLoai=LoaiMon.MaLoai

select * from BaoCaoMonAn
--10.báo cáo tình hình nhập, xuất của từng nguyên vật liệu trong tháng hiện tại
--tình hình nhập
create view BaoCaoNhapNL
as
select ChiTietHoaDonNhap.MaNguyenLieu, TenNguyenLieu, ChiTietHoaDonNhap.SoLuong, DonGia, ThanhTien
from HoaDonNhap, ChiTietHoaDonNhap, NguyenLieu
where HoaDonNhap.MaHoaDonNhap=ChiTietHoaDonNhap.MaHoaDonNhap and ChiTietHoaDonNhap.MaNguyenLieu=NguyenLieu.MaNguyenLieu and MONTH(NgayNhap)=MONTH(GETDATE()) and YEAR(NgayNhap)=YEAR(GETDATE())

select * from BaoCaoNhapNL

--tình hình xuất
create view BaoCaoXuatNL
as
select NguyenLieu_MonAn.MaNguyenLieu, TenNguyenLieu, NguyenLieu_MonAn.SoLuong, DonGiaBan
from NguyenLieu_MonAn, NguyenLieu, PhieuDatBan, ChiTietPhieuDB, MonAn
where NguyenLieu.MaNguyenLieu=NguyenLieu_MonAn.MaNguyenLieu and PhieuDatBan.MaPhieu=ChiTietPhieuDB.MaPhieu and ChiTietPhieuDB.MaMonAn=MonAn.MaMonAn and MonAn.MaMonAn=NguyenLieu_MonAn.MaMonAn and MONTH(NgayDat)=MONTH(GETDATE()) and YEAR(NgayDat)=YEAR(GETDATE())

select * from BaoCaoXuatNL

--11. báo cáo thông tin đầy đủ của các phiếu đặt bàn
create view BaoCaoPDB
as
select MaPhieu, TenKhach, TenNhanVien, NgayDat, NgayDung, TongTien
from PhieuDatBan, Khach, NhanVien
where PhieuDatBan.MaKhach=Khach.MaKhach and PhieuDatBan.MaNhanVien=NhanVien.MaNhanVien

select * from BaoCaoPDB

---------------------
create proc [dbo].[RpThang] @thang int, @nam int
as
begin
	select @thang as thang, @nam as Nam , sum((SoLuong*MonAn.DonGia) - GiamGia) as ThanhTien
	from PhieuDatBan, ChiTietPhieuDB, MonAn
	where PhieuDatBan.MaPhieu = ChiTietPhieuDB.MaPhieu and ChiTietPhieuDB.MaMonAn = MonAn.MaMonAn and MONTH(NgayDat) = @thang and YEAR(NgayDat) = @nam
	group by MONTH(NgayDat)
end

---------------------
create proc [dbo].[RpQuy] @quy nvarchar(50),@thang_1st int, @thang_2nd int,@thang_3rd int, @nam int
	as
	begin
		select  @quy as Quy ,@nam as Nam , sum(PhieuDatBan.TongTien) as TongTien
		from PhieuDatBan
		where (MONTH(NgayDat) =@thang_1st or MONTH(NgayDat) =@thang_2nd or MONTH(NgayDat) =@thang_3rd)  and YEAR(NgayDat) = @nam
		group by year(NgayDat)
	end

---------------------------
create proc [dbo].[RpNam] @nam int
	as
	begin
	select @nam as Nam, sum(TongTien) as ThanhTien
	from PhieuDatBan
	where YEAR(NgayDat) = @nam
	end

------------------------------
create proc [dbo].[RpPDB]
	@mapdb nvarchar(50)
	as
	begin
		select * from PhieuDatBan where MaPhieu = @mapdb
	end

----------------------
create proc [dbo].[RpMonAn]
	@mama nvarchar(50)
	as
	begin
		select * from MonAn where MaMonAn = @mama
	end