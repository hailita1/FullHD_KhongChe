using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLBH.Model_Class
{
    class Class_ChiTietPhieuDB
    {
        private string MaPhieu;
        private string MaMonAn;
        private string MaLoai;
        private double SoLuong;
        private double GiamGia;
        private double ThanhTien;
        public Class_ChiTietPhieuDB()
        {

        }
        public Class_ChiTietPhieuDB(string MaPhieu, string MaMonAn, string MaLoai, double SoLuong, double GiamGia, double ThanhTien)
        {
            this.MaPhieu = MaPhieu;
            this.MaMonAn = MaMonAn;
            this.MaLoai = MaLoai;
            this.SoLuong = SoLuong;
            this.GiamGia = GiamGia;
            this.ThanhTien = ThanhTien;

        }

        public string MaPhieu1 { get => MaPhieu; set => MaPhieu = value; }
        public string MaMonAn1 { get => MaMonAn; set => MaMonAn = value; }
        public string MaLoai1 { get => MaLoai; set => MaLoai = value; }
        public double SoLuong1 { get => SoLuong; set => SoLuong = value; }
        public double GiamGia1 { get => GiamGia; set => GiamGia = value; }
        public double ThanhTien1 { get => ThanhTien; set => ThanhTien = value; }
    }
}
