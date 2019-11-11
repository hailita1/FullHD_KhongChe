using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using QLBH.Model_Class;
using QLBH.Repository;
using System.Data.SqlClient;
using System.Data.Common;

namespace QLBH
{
    public partial class frm_ChiTietHD : DevExpress.XtraEditors.XtraForm
    {
        List<Class_HoaDonNhap> hoaDonNhap;
        List<Class_NguyenLieu> nguyenLieu;
        List<Class_ChiTietHoaDonNhap> chiTietHoaDonNhap;
        ConnectAndQuery query = new ConnectAndQuery();

        public frm_ChiTietHD()
        {
            InitializeComponent();
            hoaDonNhap = new frm_HoaDon().Select();
            nguyenLieu = new frm_NguyenLieu().Select();
            this.cb_mahd.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cb_manl.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
        }
        public new List<Class_ChiTietHoaDonNhap> Select()
        {
            string sql = "Select * from ChiTietHoaDonNhap";
            List<Class_ChiTietHoaDonNhap> list = new List<Class_ChiTietHoaDonNhap>();
            SqlConnection con = new SqlConnection();
            con.ConnectionString = @"Data Source=DESKTOP-MFCIF4Q\SQLEXPRESS;Initial Catalog=QLNhaHang;Integrated Security=True";
            con.Open();
            SqlCommand cmd = new SqlCommand(sql, con);
            using (DbDataReader reader = cmd.ExecuteReader())
            {
                if (reader.HasRows)
                    while (reader.Read())
                    {
                        String MaNguyenLieu = reader.GetString(0);
                        String MaHoaDonNhap = reader.GetString(1);
                        double SoLuong = (double)reader.GetValue(2);
                        double DonGia = reader.GetDouble(3);
                        double KhuyenMai = (double)reader.GetValue(4);
                        double ThanhTien = reader.GetDouble(5);
                        Class_ChiTietHoaDonNhap chiTietHoaDonNhap1 = new Class_ChiTietHoaDonNhap(MaNguyenLieu, MaHoaDonNhap, SoLuong, DonGia, KhuyenMai, ThanhTien);
                        list.Add(chiTietHoaDonNhap1);
                    }
            }
            con.Close();
            return list;
        }
        private void fill()
        {
            dataGridView1.DataSource = query.DocBang("select * from ChiTietHoaDonNhap");
        }
        private void add()
        {
            hoaDonNhap = new frm_HoaDon().Select();
            nguyenLieu = new frm_NguyenLieu().Select();
            for (int i = 0; i < hoaDonNhap.Count; i++)
            {
                cb_mahd.Items.Add(hoaDonNhap[i].MaHoaDonNhap1);
            }
            for (int i = 0; i < nguyenLieu.Count; i++)
            {
                cb_manl.Items.Add(nguyenLieu[i].MaNguyenLieu1);
            }
        }

        private void Frm_ChiTietHD_Load(object sender, EventArgs e)
        {
            fill();
            cb_mahd.Focus();
            add();
        }

        private void Btn_close_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn có muốn thoát không ?", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                this.Close();
        }

        private void Btn_refesrh_Click(object sender, EventArgs e)
        {
            hoaDonNhap = new frm_HoaDon().Select();
            nguyenLieu = new frm_NguyenLieu().Select();
            bool nl = false, hdn = false;
            for (int i = 0; i < hoaDonNhap.Count; i++)
            {
                if (hoaDonNhap[i].MaHoaDonNhap1.Equals(cb_mahd.Text))
                {
                    hdn = true;
                    break;
                }
            }
            if (hdn == false)
            {
                MessageBox.Show("Bạn chưa có mã hóa đơn này", "Thông báo");
            }

            for (int i = 0; i < nguyenLieu.Count; i++)
            {
                if (nguyenLieu[i].MaNguyenLieu1.Equals(cb_manl.Text))
                {
                    nl = true;
                    break;
                }
            }
            if (nl == false)
            {
                MessageBox.Show("Bạn chưa có mã nguyên liệu này", "Thông báo");
            }
            double x;

            chiTietHoaDonNhap = Select();

            if (Convert.ToDouble(txt_KhuyenMai.Text) < 0.0 || Convert.ToDouble(txt_KhuyenMai.Text) > 100)
            {
                MessageBox.Show("Bạn cần nhập số trong khoảng 0 đến 100", "Thông báo");
            }
            else if (cb_mahd.Text.Trim() != "" && cb_manl.Text.Trim() != "" && txt_SoLuong.Text.Trim() != "" &&
                   txt_KhuyenMai.Text.Trim() != "" && txt_DonGia.Text.Trim() != "" && nl == true && hdn == true)
            {
                String sql = "update ChiTietHoaDonNhap set SoLuong=N'" + txt_SoLuong.Text + "', DonGia=N'" + txt_DonGia.Text + "', KhuyenMai=N'" + txt_KhuyenMai.Text  + "' where MaHoaDonNhap = N'" + cb_mahd.Text + "' and MaNguyenLieu=N'" + cb_manl.Text + "'";
                query.CapNhatDuLieu(sql);
                fill();
                chiTietHoaDonNhap.Add(new Class_ChiTietHoaDonNhap(cb_mahd.Text, cb_manl.Text, Convert.ToDouble(txt_SoLuong.Text), Convert.ToDouble(txt_DonGia.Text), Convert.ToDouble(txt_KhuyenMai.Text), 0));
                cb_mahd.Text = "";
                cb_manl.Text = "";
                txt_SoLuong.Text = "";
                txt_DonGia.Text = "";
                txt_KhuyenMai.Text = "";
                txt_ThanhTien.Text = "";
                cb_mahd.Enabled = true;
                cb_manl.Enabled = true;
                cb_mahd.Focus();
            }
            else
            {
                MessageBox.Show("Bạn hãy nhập đủ thông tin", "Thông báo");
            }
        }

        private void Btn_Delete_Click(object sender, EventArgs e)
        {
            if (txt_DonGia.Text == "" || txt_KhuyenMai.Text == "" || txt_SoLuong.Text == "" || txt_ThanhTien.Text == "" || cb_mahd.Text == "" || cb_manl.Text == "")
            {
                MessageBox.Show("Bạn cần chọn một hóa đơn muốn xóa !!!", "Thông báo");
            }

            else if (MessageBox.Show("Bạn có muốn xóa không ?", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                string sql = "delete from ChiTietHoaDonNhap where MaHoaDonNhap=N'" + cb_mahd.Text + "' and MaNguyenLieu=N'" + cb_manl.Text + "'";
                query.CapNhatDuLieu(sql);
                fill();
                cb_mahd.Enabled = true;
                cb_mahd.Text = "";
                cb_manl.Text = "";
                txt_SoLuong.Text = " ";
                txt_DonGia.Text = "";
                txt_KhuyenMai.Text = " ";
                txt_ThanhTien.Text = "";
            }
        }

        private void DataGridView1_DoubleClick(object sender, EventArgs e)
        {
            cb_mahd.Text = dataGridView1.CurrentRow.Cells[0].Value.ToString();
            cb_manl.Text = dataGridView1.CurrentRow.Cells[1].Value.ToString();
            txt_SoLuong.Text = dataGridView1.CurrentRow.Cells[2].Value.ToString();
            txt_DonGia.Text = dataGridView1.CurrentRow.Cells[3].Value.ToString();
            txt_KhuyenMai.Text = dataGridView1.CurrentRow.Cells[4].Value.ToString();
            txt_ThanhTien.Text = dataGridView1.CurrentRow.Cells[5].Value.ToString();
        }

        private void Btn_Add_Click_1(object sender, EventArgs e)
        {

            chiTietHoaDonNhap = Select();
            //hoaDonNhap = new frm_HoaDon().Select();
            nguyenLieu = new frm_NguyenLieu().Select();
            //bool nl = false, hdn = false;
            bool check = false;
            for (int i = 0; i < chiTietHoaDonNhap.Count; i++)
            {
                if (chiTietHoaDonNhap[i].MaHoaDonNhap1.Equals(cb_mahd.Text) && chiTietHoaDonNhap[i].MaNguyenLieu1.Equals(cb_manl.Text))
                {
                    check = true;

                    break;
                }
            }

            if (check == false)
            {
                if (Convert.ToDouble(txt_KhuyenMai.Text) < 0.0 || Convert.ToDouble(txt_KhuyenMai.Text) > 100)
                {
                    MessageBox.Show("Bạn cần nhập số trong khoảng 0 đến 100", "Thông báo");
                }
                else if (txt_SoLuong.Text.Trim() != "" && txt_KhuyenMai.Text.Trim() != "" && txt_DonGia.Text.Trim() != "")
                {

                    string sql = "insert into ChiTietHoaDonNhap values(N'" + cb_manl.Text + "',N'" + cb_mahd.Text + "',N'" + txt_SoLuong.Text + "',N'" + txt_DonGia.Text + "',N'" + txt_KhuyenMai.Text + "',N'" + 0 + "')";
                    query.CapNhatDuLieu(sql);
                    fill();
                    cb_manl.Text = "";
                    cb_mahd.Text = "";
                    txt_SoLuong.Text = "";
                    txt_DonGia.Text = "";
                    txt_KhuyenMai.Text = "";
                    txt_ThanhTien.Text = "";
                    cb_mahd.Focus();

                }
                else
                {
                    MessageBox.Show("Vui lòng nhập đầy đủ thông tin", "Thông báo");
                }
            }
            else
            {
                MessageBox.Show("Đã có dữ liệu", "Thông báo");
            }

        }

        private void Cb_mahd_Click(object sender, EventArgs e)
        {
            hoaDonNhap = new frm_HoaDon().Select();
            cb_mahd.Items.Clear();
            for (int i = 0; i < hoaDonNhap.Count; i++)
            {
                cb_mahd.Items.Add(hoaDonNhap[i].MaHoaDonNhap1);
            }
        }

        private void Cb_manl_Click(object sender, EventArgs e)
        {
            nguyenLieu = new frm_NguyenLieu().Select();
            cb_manl.Items.Clear();
            for (int i = 0; i < nguyenLieu.Count; i++)
            {
                cb_manl.Items.Add(nguyenLieu[i].MaNguyenLieu1);
            }
        }

        private void Txt_KhuyenMai_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && (e.KeyChar != '.'))
            {
                e.Handled = true;
            }
        }
    }
}