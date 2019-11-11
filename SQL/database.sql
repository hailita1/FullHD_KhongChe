USE [QLNhaHang]
GO
/****** Object:  Table [dbo].[PhieuDatBan]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuDatBan](
	[MaPhieu] [varchar](50) NOT NULL,
	[MaKhach] [varchar](50) NULL,
	[MaNhanVien] [varchar](50) NULL,
	[NgayDat] [date] NULL,
	[NgayDung] [date] NULL,
	[TongTien] [float] NULL,
 CONSTRAINT [PK_PhieuDatBan] PRIMARY KEY CLUSTERED 
(
	[MaPhieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[TongTienQuy]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[TongTienQuy](@nam int) returns table
as
return(
	select MONTH(NgayDat) as Thang, SUM(TongTien) as TongTien
	from PhieuDatBan
	where YEAR(NgayDat)=@nam
	group by MONTH(NgayDat)
)
GO
/****** Object:  UserDefinedFunction [dbo].[TongTienNam]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[TongTienNam]() returns table
as
return(
	select year(NgayDat) as Nam, SUM(TongTien) as TongTien
	from PhieuDatBan
	group by year(NgayDat)
)
GO
/****** Object:  Table [dbo].[MonAn]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonAn](
	[MaMonAn] [varchar](50) NOT NULL,
	[TenMonAn] [nvarchar](50) NULL,
	[MaCongDung] [varchar](50) NULL,
	[MaLoai] [varchar](50) NULL,
	[CachLam] [nvarchar](200) NULL,
	[YeuCau] [nvarchar](200) NULL,
	[DonGia] [float] NULL,
 CONSTRAINT [PK_MonAn] PRIMARY KEY CLUSTERED 
(
	[MaMonAn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoaiMon]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiMon](
	[MaLoai] [varchar](50) NOT NULL,
	[TenLoai] [nvarchar](50) NULL,
 CONSTRAINT [PK_LoaiMon] PRIMARY KEY CLUSTERED 
(
	[MaLoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CongDung]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CongDung](
	[MaCongDung] [varchar](50) NOT NULL,
	[TenCongDung] [nvarchar](100) NULL,
 CONSTRAINT [PK_CongDung] PRIMARY KEY CLUSTERED 
(
	[MaCongDung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BaoCaoMonAn]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[BaoCaoMonAn]
as
select TenMonAn, TenCongDung, TenLoai, CachLam, DonGia
from MonAn, CongDung, LoaiMon
where MonAn.MaCongDung=CongDung.MaCongDung and MonAn.MaLoai=LoaiMon.MaLoai
GO
/****** Object:  Table [dbo].[NguyenLieu]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NguyenLieu](
	[MaNguyenLieu] [varchar](50) NOT NULL,
	[TenNguyenLieu] [nvarchar](50) NULL,
	[DonViTinh] [nvarchar](50) NULL,
	[SoLuong] [float] NULL,
	[DonGiaNhap] [float] NULL,
	[DonGiaBan] [float] NULL,
	[CongDung] [varchar](50) NULL,
	[YeuCau] [nvarchar](200) NULL,
	[ChongChiDinh] [nvarchar](200) NULL,
 CONSTRAINT [PK_NguyenLieu] PRIMARY KEY CLUSTERED 
(
	[MaNguyenLieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietHoaDonNhap]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietHoaDonNhap](
	[MaNguyenLieu] [varchar](50) NOT NULL,
	[MaHoaDonNhap] [varchar](50) NOT NULL,
	[SoLuong] [float] NULL,
	[DonGia] [float] NULL,
	[KhuyenMai] [float] NULL,
	[ThanhTien] [float] NULL,
 CONSTRAINT [PK_ChiTietHoaDonNhap] PRIMARY KEY CLUSTERED 
(
	[MaNguyenLieu] ASC,
	[MaHoaDonNhap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HoaDonNhap]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDonNhap](
	[MaHoaDonNhap] [varchar](50) NOT NULL,
	[NgayNhap] [date] NULL,
	[MaNhanVien] [varchar](50) NULL,
	[MaNhaCungCap] [varchar](50) NULL,
	[TongTien] [float] NULL,
 CONSTRAINT [PK_HoaDonNhap] PRIMARY KEY CLUSTERED 
(
	[MaHoaDonNhap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BaoCaoNhapNL]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[BaoCaoNhapNL]
as
select ChiTietHoaDonNhap.MaNguyenLieu, TenNguyenLieu, ChiTietHoaDonNhap.SoLuong, DonGia, ThanhTien
from HoaDonNhap, ChiTietHoaDonNhap, NguyenLieu
where HoaDonNhap.MaHoaDonNhap=ChiTietHoaDonNhap.MaHoaDonNhap and ChiTietHoaDonNhap.MaNguyenLieu=NguyenLieu.MaNguyenLieu and MONTH(NgayNhap)=MONTH(GETDATE()) and YEAR(NgayNhap)=YEAR(GETDATE())
GO
/****** Object:  Table [dbo].[ChiTietPhieuDB]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietPhieuDB](
	[MaPhieu] [varchar](50) NOT NULL,
	[MaMonAn] [varchar](50) NOT NULL,
	[MaLoai] [varchar](50) NULL,
	[SoLuong] [float] NULL,
	[GiamGia] [float] NULL,
	[ThanhTien] [float] NULL,
 CONSTRAINT [PK_ChiTietPhieuDB] PRIMARY KEY CLUSTERED 
(
	[MaPhieu] ASC,
	[MaMonAn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NguyenLieu_MonAn]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NguyenLieu_MonAn](
	[MaMonAn] [varchar](50) NOT NULL,
	[MaNguyenLieu] [varchar](50) NOT NULL,
	[SoLuong] [float] NULL,
 CONSTRAINT [PK_NguyenLieu_MonAn] PRIMARY KEY CLUSTERED 
(
	[MaMonAn] ASC,
	[MaNguyenLieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BaoCaoXuatNL]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[BaoCaoXuatNL]
as
select NguyenLieu_MonAn.MaNguyenLieu, TenNguyenLieu, NguyenLieu_MonAn.SoLuong, DonGiaBan
from NguyenLieu_MonAn, NguyenLieu, PhieuDatBan, ChiTietPhieuDB, MonAn
where NguyenLieu.MaNguyenLieu=NguyenLieu_MonAn.MaNguyenLieu and PhieuDatBan.MaPhieu=ChiTietPhieuDB.MaPhieu and ChiTietPhieuDB.MaMonAn=MonAn.MaMonAn and MonAn.MaMonAn=NguyenLieu_MonAn.MaMonAn and MONTH(NgayDat)=MONTH(GETDATE()) and YEAR(NgayDat)=YEAR(GETDATE())
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNhanVien] [varchar](50) NOT NULL,
	[TenNhanVien] [nvarchar](50) NULL,
	[GioiTinh] [nvarchar](5) NULL,
	[NgaySinh] [date] NULL,
	[DiaChi] [nvarchar](200) NULL,
	[MaQue] [varchar](50) NOT NULL,
	[DienThoai] [nchar](10) NULL,
 CONSTRAINT [PK_NhanVien] PRIMARY KEY CLUSTERED 
(
	[MaNhanVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Khach]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Khach](
	[MaKhach] [varchar](50) NOT NULL,
	[TenKhach] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](200) NULL,
	[DienThoai] [nchar](10) NULL,
 CONSTRAINT [PK_Khach] PRIMARY KEY CLUSTERED 
(
	[MaKhach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BaoCaoPDB]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[BaoCaoPDB]
as
select MaPhieu, TenKhach, TenNhanVien, NgayDat, NgayDung, TongTien
from PhieuDatBan, Khach, NhanVien
where PhieuDatBan.MaKhach=Khach.MaKhach and PhieuDatBan.MaNhanVien=NhanVien.MaNhanVien
GO
/****** Object:  UserDefinedFunction [dbo].[TongTienThang]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[TongTienThang](@nam int) returns table
as
return(
	select MONTH(NgayDat) as Thang, SUM(TongTien) as TongTien
	from PhieuDatBan
	where YEAR(NgayDat)=@nam
	group by MONTH(NgayDat)
)
GO
/****** Object:  Table [dbo].[NhaCungCap]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhaCungCap](
	[MaNhaCungCap] [varchar](50) NOT NULL,
	[TenNhaCungCap] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](200) NULL,
	[DienThoai] [nchar](10) NULL,
 CONSTRAINT [PK_NhaCungCap] PRIMARY KEY CLUSTERED 
(
	[MaNhaCungCap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Que]    Script Date: 11/11/2019 6:31:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Que](
	[MaQue] [varchar](50) NOT NULL,
	[TenQue] [nvarchar](50) NULL,
 CONSTRAINT [PK_Que] PRIMARY KEY CLUSTERED 
(
	[MaQue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[ChiTietHoaDonNhap] ([MaNguyenLieu], [MaHoaDonNhap], [SoLuong], [DonGia], [KhuyenMai], [ThanhTien]) VALUES (N'MNL01', N'HD01', 100, 200000, 2, 19600000)
INSERT [dbo].[ChiTietPhieuDB] ([MaPhieu], [MaMonAn], [MaLoai], [SoLuong], [GiamGia], [ThanhTien]) VALUES (N'PDB01', N'MMA01', N'ML01', 20, 5, NULL)
INSERT [dbo].[CongDung] ([MaCongDung], [TenCongDung]) VALUES (N'MCD01', N'Làm Đẹp Da')
INSERT [dbo].[CongDung] ([MaCongDung], [TenCongDung]) VALUES (N'MCD02', N'Sáng Mắt')
INSERT [dbo].[CongDung] ([MaCongDung], [TenCongDung]) VALUES (N'MCD03', N'Bổ Thận Tráng Dương')
INSERT [dbo].[HoaDonNhap] ([MaHoaDonNhap], [NgayNhap], [MaNhanVien], [MaNhaCungCap], [TongTien]) VALUES (N'HD01', CAST(N'2019-11-11' AS Date), N'MNV01', N'MNCC01', 19600000)
INSERT [dbo].[Khach] ([MaKhach], [TenKhach], [DiaChi], [DienThoai]) VALUES (N'KH01', N'Chủ Tịch Đạt', N'Đại Gia Nghệ An', N'0386123369')
INSERT [dbo].[LoaiMon] ([MaLoai], [TenLoai]) VALUES (N'ML01', N'Nướng')
INSERT [dbo].[LoaiMon] ([MaLoai], [TenLoai]) VALUES (N'ML02', N'Lẩu')
INSERT [dbo].[LoaiMon] ([MaLoai], [TenLoai]) VALUES (N'ML03', N'Hải Sản')
INSERT [dbo].[MonAn] ([MaMonAn], [TenMonAn], [MaCongDung], [MaLoai], [CachLam], [YeuCau], [DonGia]) VALUES (N'MMA01', N'Thịt chó', N'MCD01', N'ML02', N'Lên gg search', N'Sạch Sẽ', NULL)
INSERT [dbo].[NguyenLieu] ([MaNguyenLieu], [TenNguyenLieu], [DonViTinh], [SoLuong], [DonGiaNhap], [DonGiaBan], [CongDung], [YeuCau], [ChongChiDinh]) VALUES (N'MNL01', N'Thịt Gà', N'$$$', 100, 200000, 200000, N'Cung c?p nang lu?ng', N'ngon bổ rẻ', N'phụ nữ có thai và đang cho con bú')
INSERT [dbo].[NhaCungCap] ([MaNhaCungCap], [TenNhaCungCap], [DiaChi], [DienThoai]) VALUES (N'MNCC01', N'Công Ty của Chủ Tịch Đạt', N'Đại Gia Nghệ An', N'0386123369')
INSERT [dbo].[NhanVien] ([MaNhanVien], [TenNhanVien], [GioiTinh], [NgaySinh], [DiaChi], [MaQue], [DienThoai]) VALUES (N'MNV01', N'Nguyễn Tiến Đạt', N'Nam', CAST(N'1999-09-04' AS Date), N'Đấu trường chân lý', N'MQ01', N'0386123369')
INSERT [dbo].[NhanVien] ([MaNhanVien], [TenNhanVien], [GioiTinh], [NgaySinh], [DiaChi], [MaQue], [DienThoai]) VALUES (N'MNV02', N'Trần Thanh Hải', N'Nam', CAST(N'1999-02-05' AS Date), N'Thái Nguyên', N'MQ02', N'0124532456')
INSERT [dbo].[NhanVien] ([MaNhanVien], [TenNhanVien], [GioiTinh], [NgaySinh], [DiaChi], [MaQue], [DienThoai]) VALUES (N'MNV03', N'Nguyễn Văn Nam', N'Nam', CAST(N'1999-02-05' AS Date), N'Hà Nội', N'MQ03', N'0215124123')
INSERT [dbo].[PhieuDatBan] ([MaPhieu], [MaKhach], [MaNhanVien], [NgayDat], [NgayDung], [TongTien]) VALUES (N'PDB01', N'KH01', N'MNV01', CAST(N'2019-11-11' AS Date), CAST(N'2019-11-11' AS Date), NULL)
INSERT [dbo].[Que] ([MaQue], [TenQue]) VALUES (N'MQ01', N'Nghệ An')
INSERT [dbo].[Que] ([MaQue], [TenQue]) VALUES (N'MQ02', N'Thái Nguyên')
INSERT [dbo].[Que] ([MaQue], [TenQue]) VALUES (N'MQ03', N'Hà Nội')
INSERT [dbo].[Que] ([MaQue], [TenQue]) VALUES (N'MQ04', N'Hung Yên')
INSERT [dbo].[Que] ([MaQue], [TenQue]) VALUES (N'MQ05', N'Ba Vì')
ALTER TABLE [dbo].[ChiTietHoaDonNhap]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHoaDonNhap_HoaDonNhap] FOREIGN KEY([MaHoaDonNhap])
REFERENCES [dbo].[HoaDonNhap] ([MaHoaDonNhap])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ChiTietHoaDonNhap] CHECK CONSTRAINT [FK_ChiTietHoaDonNhap_HoaDonNhap]
GO
ALTER TABLE [dbo].[ChiTietHoaDonNhap]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHoaDonNhap_NguyenLieu] FOREIGN KEY([MaNguyenLieu])
REFERENCES [dbo].[NguyenLieu] ([MaNguyenLieu])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ChiTietHoaDonNhap] CHECK CONSTRAINT [FK_ChiTietHoaDonNhap_NguyenLieu]
GO
ALTER TABLE [dbo].[ChiTietPhieuDB]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietPhieuDB_LoaiMon] FOREIGN KEY([MaLoai])
REFERENCES [dbo].[LoaiMon] ([MaLoai])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ChiTietPhieuDB] CHECK CONSTRAINT [FK_ChiTietPhieuDB_LoaiMon]
GO
ALTER TABLE [dbo].[ChiTietPhieuDB]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietPhieuDB_MonAn] FOREIGN KEY([MaMonAn])
REFERENCES [dbo].[MonAn] ([MaMonAn])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ChiTietPhieuDB] CHECK CONSTRAINT [FK_ChiTietPhieuDB_MonAn]
GO
ALTER TABLE [dbo].[ChiTietPhieuDB]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietPhieuDB_PhieuDatBan] FOREIGN KEY([MaPhieu])
REFERENCES [dbo].[PhieuDatBan] ([MaPhieu])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ChiTietPhieuDB] CHECK CONSTRAINT [FK_ChiTietPhieuDB_PhieuDatBan]
GO
ALTER TABLE [dbo].[HoaDonNhap]  WITH CHECK ADD  CONSTRAINT [FK_HoaDonNhap_NhaCungCap] FOREIGN KEY([MaNhaCungCap])
REFERENCES [dbo].[NhaCungCap] ([MaNhaCungCap])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HoaDonNhap] CHECK CONSTRAINT [FK_HoaDonNhap_NhaCungCap]
GO
ALTER TABLE [dbo].[MonAn]  WITH CHECK ADD  CONSTRAINT [FK_MonAn_CongDung] FOREIGN KEY([MaCongDung])
REFERENCES [dbo].[CongDung] ([MaCongDung])
GO
ALTER TABLE [dbo].[MonAn] CHECK CONSTRAINT [FK_MonAn_CongDung]
GO
ALTER TABLE [dbo].[NguyenLieu_MonAn]  WITH CHECK ADD  CONSTRAINT [FK_NguyenLieu_MonAn_MonAn] FOREIGN KEY([MaMonAn])
REFERENCES [dbo].[MonAn] ([MaMonAn])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NguyenLieu_MonAn] CHECK CONSTRAINT [FK_NguyenLieu_MonAn_MonAn]
GO
ALTER TABLE [dbo].[NguyenLieu_MonAn]  WITH CHECK ADD  CONSTRAINT [FK_NguyenLieu_MonAn_NguyenLieu] FOREIGN KEY([MaNguyenLieu])
REFERENCES [dbo].[NguyenLieu] ([MaNguyenLieu])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NguyenLieu_MonAn] CHECK CONSTRAINT [FK_NguyenLieu_MonAn_NguyenLieu]
GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [FK_NhanVien_Que] FOREIGN KEY([MaQue])
REFERENCES [dbo].[Que] ([MaQue])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NhanVien] CHECK CONSTRAINT [FK_NhanVien_Que]
GO
ALTER TABLE [dbo].[PhieuDatBan]  WITH CHECK ADD  CONSTRAINT [FK_PhieuDatBan_Khach] FOREIGN KEY([MaKhach])
REFERENCES [dbo].[Khach] ([MaKhach])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PhieuDatBan] CHECK CONSTRAINT [FK_PhieuDatBan_Khach]
GO
ALTER TABLE [dbo].[PhieuDatBan]  WITH CHECK ADD  CONSTRAINT [FK_PhieuDatBan_NhanVien] FOREIGN KEY([MaNhanVien])
REFERENCES [dbo].[NhanVien] ([MaNhanVien])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PhieuDatBan] CHECK CONSTRAINT [FK_PhieuDatBan_NhanVien]
GO
/****** Object:  StoredProcedure [dbo].[DonGia]    Script Date: 11/11/2019 6:31:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--form món ăn: mã công dụng - mã loại là combobox, đơn giá không cho nhập
CREATE proc [dbo].[DonGia] @mamon varchar(50), @dongia float output
as
begin
	select @dongia=DonGia
	from MonAn
	where MaMonAn=@mamon
end
GO
/****** Object:  StoredProcedure [dbo].[SoLuong]    Script Date: 11/11/2019 6:31:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SoLuong] @manl varchar(50), @sl float output, @gianhap float output, @giaban float output
as
begin
	select @sl=SoLuong, @gianhap=DonGiaNhap, @giaban=DonGiaBan
	from NguyenLieu
	where MaNguyenLieu=@manl
end
GO
/****** Object:  StoredProcedure [dbo].[ThanhTien]    Script Date: 11/11/2019 6:31:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ThanhTien] @maphieu varchar(50), @mamon varchar(50), @tien float output
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
GO
/****** Object:  StoredProcedure [dbo].[ThanhTienHD]    Script Date: 11/11/2019 6:31:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[ThanhTienHD] @mahdn varchar(50), @manl varchar(50), @tien float output
as
begin
	declare @sl float, @khuyenmai float, @dongia float
	select @sl=SoLuong, @khuyenmai=KhuyenMai, @dongia=DonGia
	from ChiTietHoaDonNhap
	where MaHoaDonNhap=@mahdn and MaNguyenLieu=@manl
	set @tien=@sl*@dongia-(@khuyenmai/100)*@sl*@dongia
end
GO
/****** Object:  StoredProcedure [dbo].[TongtienHDN]    Script Date: 11/11/2019 6:31:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[TongtienHDN] @mahdn varchar(50), @tongtien float output
as
begin	
	select @tongtien=sum(ThanhTien)
	from ChiTietHoaDonNhap
	where MaHoaDonNhap=@mahdn
end
GO
/****** Object:  StoredProcedure [dbo].[TongtienPDB]    Script Date: 11/11/2019 6:31:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[TongtienPDB] @maphieu varchar(50), @tongtien float output
as
begin	
	select @tongtien=sum(ThanhTien)
	from ChiTietPhieuDB
	where MaPhieu=@maphieu
end
GO
