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
    public partial class frm_NCC : DevExpress.XtraEditors.XtraForm
    {
        List<Class_NhaCungCap> nhacc = new List<Class_NhaCungCap>();
        ConnectAndQuery query = new ConnectAndQuery();
        public frm_NCC()
        {
            InitializeComponent();
        }
        private void fill()
        {
            dataGridView1.DataSource = query.DocBang("Select * from NhaCungCap");
        }
        private void frm_NCC_Load(object sender, EventArgs e)
        {
            fill();
        }

        public new List<Class_NhaCungCap> Select()
        {
            string sql = "SELECT * FROM NhaCungCap";
            List<Class_NhaCungCap> list = new List<Class_NhaCungCap>();
            SqlConnection con = new SqlConnection();
            con.ConnectionString = @"Data Source=DESKTOP-MFCIF4Q\SQLEXPRESS;Initial Catalog=QLNhaHang;Integrated Security=True";
            con.Open();
            SqlCommand cmd = new SqlCommand(sql, con);
            using (DbDataReader reader = cmd.ExecuteReader())
            {
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        string MaNhaCungCap = reader.GetString(0);
                        string TenNhaCungCap = reader.GetString(1);
                        string DiaChi = reader.GetString(2);
                        string DienThoai = reader.GetString(3);
                        Class_NhaCungCap ncc = new Class_NhaCungCap(MaNhaCungCap, TenNhaCungCap, DiaChi, DienThoai);
                        list.Add(ncc);
                    }
                }
            }
            con.Close();
            return list;
        }

        private void Btn_Add_Click(object sender, EventArgs e)
        {
            nhacc = Select();
            bool check = false;
            for (int i = 0; i < nhacc.Count; i++)
            {
                if (nhacc[i].MaNhaCungCap1.Equals(txt_mancc.Text) || nhacc[i].TenNhaCungCap1.Equals(txt_tenncc.Text))
                {
                    check = true;
                    MessageBox.Show("Đã có mã hoặc tên nhà cung cấp này", "Thông báo");
                    break;
                }
            }

            if (check == false)
            {

                if (txt_mancc.Text.Trim() != "" || txt_tenncc.Text.Trim() != "" || txt_diachincc.Text.Trim() != "" || txt_dienthoaincc.Text.Trim() != "")
                {

                    string sql = "insert into NhaCungCap values(N'" + txt_mancc.Text + "',N'" + txt_tenncc.Text + "',N'" + txt_diachincc.Text + "','" + txt_dienthoaincc.Text + "')";
                    query.CapNhatDuLieu(sql);
                    fill();
                    nhacc.Add(new Class_NhaCungCap(txt_mancc.Text, txt_tenncc.Text, txt_diachincc.Text, txt_dienthoaincc.Text));
                    txt_mancc.Text = "";
                    txt_tenncc.Text = "";
                    txt_diachincc.Text = "";
                    txt_dienthoaincc.Text = "";

                    
                }
                else
                {
                    MessageBox.Show("Vui lòng nhập đầy đủ thông tin", "Thông báo");
                }
            }
        }



        private void Btn_refesrh_Click(object sender, EventArgs e)
        {
            nhacc = Select();

            if (txt_mancc.Text.Trim() != "" || txt_tenncc.Text.Trim() != "" || txt_diachincc.Text.Trim() != "" || txt_dienthoaincc.Text.Trim() != "")
            {

                string sql = "update NhaCungCap set TenNhaCungCap=N'" + txt_tenncc.Text + "',DiaChi=N'" + txt_diachincc.Text + "',DienThoai='" + txt_dienthoaincc.Text + "' where MaNhaCungCap=N'" + txt_mancc.Text + "'";
                query.CapNhatDuLieu(sql);
                fill();
                nhacc.Add(new Class_NhaCungCap(txt_mancc.Text, txt_tenncc.Text, txt_diachincc.Text, txt_dienthoaincc.Text));
                txt_mancc.Text = "";
                txt_tenncc.Text = "";
                txt_diachincc.Text = "";
                txt_dienthoaincc.Text = "";
                txt_mancc.Enabled = true;
            }
            else
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin", "Thông báo");
            }


        }

        private void Btn_Delete_Click(object sender, EventArgs e)
        {
            nhacc = Select();
            bool check = false;
            for (int i = 0; i < nhacc.Count; i++)
            {
                if (txt_mancc.Text.Trim() == nhacc[i].MaNhaCungCap1)
                {
                    check = true;
                    break;
                }
            }
            if (check==true)
            {
                if (MessageBox.Show("Bạn có muốn xóa không ?", "Thông báo", MessageBoxButtons.YesNo,
                  MessageBoxIcon.Question) == DialogResult.Yes)
                {

                    string sql = "delete from NhaCungCap where MaNhaCungCap=N'" + txt_mancc.Text + "'";
                    query.CapNhatDuLieu(sql);
                    fill();
                    txt_mancc.Text = "";
                    txt_tenncc.Text = "";
                    txt_diachincc.Text = "";
                    txt_dienthoaincc.Text = "";

                    txt_mancc.Enabled = true;
                }
            }
            else
            {
                MessageBox.Show("Vui lòng chọn dữ liệu", "Thông báo");
            }
        }

        private void DataGridView1_DoubleClick(object sender, EventArgs e)
        {
            txt_mancc.Text = dataGridView1.CurrentRow.Cells[0].Value.ToString();
            txt_tenncc.Text = dataGridView1.CurrentRow.Cells[1].Value.ToString();
            txt_diachincc.Text = dataGridView1.CurrentRow.Cells[2].Value.ToString();
            txt_dienthoaincc.Text = dataGridView1.CurrentRow.Cells[3].Value.ToString();
            txt_mancc.Enabled = false;
        }

        private void Btn_close_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn có muốn thoát không ?", "Thông báo", MessageBoxButtons.YesNo,
              MessageBoxIcon.Question) == DialogResult.Yes)
            {
                this.Close();
            }
        }

        private void Btn_refresh_Click(object sender, EventArgs e)
        {
            txt_diachincc.Text = "";
            txt_dienthoaincc.Text = "";
            txt_mancc.Text = "";
            txt_mancc.Enabled = true;
            txt_tenncc.Text = "";
        }
    }
}