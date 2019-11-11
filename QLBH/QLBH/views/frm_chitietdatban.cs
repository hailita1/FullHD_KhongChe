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
using System.Data.SqlClient;
using QLBH.Repository;
using System.Data.Common;

namespace QLBH
{
    public partial class frm_chitietdatban : DevExpress.XtraEditors.XtraForm
    {
        private void Btn_refesrh_Click(object sender, EventArgs e)
        {
            Test = test1();
            bool check = false;

            MonAn = new frm_MonAn().Select();
            LM = new frm_LoaiMonAn().Select();
            bool lm = false, MA = false;

            for (int i = 0; i < LM.Count; i++)
            {
                if (LM[i].MaLoai1.Equals(cbb_MaLoai.Text))
                {
                    lm = true;
                    break;
                }
            }
            if (lm == false)
            {
                MessageBox.Show("Chưa có mã loại món ăn này!", "Thông báo");
            }
            else
            {
                for (int i = 0; i < MonAn.Count; i++)
                {
                    if (MonAn[i].MaMonAn1.Equals(cbb_MaMonAn.Text))
                    {
                        MA = true;
                        break;
                    }
                }
                if (MA == false)
                {
                    MessageBox.Show("Chưa có mã món ăn này!", "Thông báo");
                }
            }


            double x;
            if (check == false && !double.TryParse(textEdit3.Text, out x))
            {
                check = true;
                MessageBox.Show("Nhập sai dữ liệu giảm giá, vui lòng nhập lại !!!", "Thông báo");
            }
            double y;
            if (check == false && !double.TryParse(textEdit2.Text, out y))
            {
                check = true;
                MessageBox.Show("Nhập sai dữ liệu số lượng, vui lòng nhập lại !!!", "Thông báo");
            }
            if (Convert.ToDouble(textEdit3.Text) < 0.0 || Convert.ToDouble(textEdit3.Text) > 100)
            {
                MessageBox.Show("Bạn cần nhập số trong khoảng 0 đến 100", "Thông báo");
            }
            else if (check == false && lm == true && MA == true)
            {
                if (cbb_MaMonAn.Text.Trim() != "" && comboBox1.Text.Trim() != "" && cbb_MaLoai.Text.Trim() != "" && textEdit2.Text.Trim() != "" && textEdit3.Text.Trim() != "")
                {
                    string sql = "UPDATE ChiTietPhieuDB set MaLoai=N'" + cbb_MaLoai.Text + "',SoLuong='" + Convert.ToDouble(textEdit2.Text) + "',GiamGia='" + Convert.ToDouble(textEdit3.Text) + "' where MaPhieu=N'" + comboBox1.Text + "' and MaMonAn = N'"+cbb_MaMonAn.Text+"'";
                    query.CapNhatDuLieu(sql);
                    fill();

                    //Test1.Add(new Class_PhieuDatBan(comboBox1.Text, txt_STT.Text, textEdit1.Text, Convert.ToDateTime(textEdit2.Text), Convert.ToDateTime(textEdit3.Text), Convert.Todouble(textEdit4.Text)));
                    cbb_MaMonAn.Text = "";
                    comboBox1.Text = "";
                    cbb_MaLoai.Text = "";
                    textEdit4.Text = "";
                    textEdit3.Text = "";
                    textEdit2.Text = "";
                    cbb_MaMonAn.Enabled = true;
                }
                else
                {
                    MessageBox.Show("Vui lòng nhập đầy đủ thông tin", "Thông báo");
                }
            }

        }
        List<Class_ChiTietPhieuDB> Test;
        List<Class_MonAn> MonAn;
        List<Class_LoaiMon> LM;
        List<Class_PhieuDatBan> DB;
        ConnectAndQuery query = new ConnectAndQuery();
        public frm_chitietdatban()
        {
            InitializeComponent();
            LM = new frm_LoaiMonAn().Select();
            fill();

            this.cbb_MaLoai.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbb_MaMonAn.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
        }
        private List<Class_ChiTietPhieuDB> test1()
        {
            string sql = "SELECT * FROM ChiTietPhieuDB";
            List<Class_ChiTietPhieuDB> list = new List<Class_ChiTietPhieuDB>();
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
                        string MaPhieu = reader.GetString(0);
                        string MaMonAn = reader.GetString(1);
                        string MaLoai = reader.GetString(2);
                        double SoLuong = reader.GetDouble(3);
                        double GiamGia = reader.GetDouble(4);
                        double ThanhTien;
                        var Tg = reader.GetValue(5);
                        if (Tg == DBNull.Value)
                        {
                            ThanhTien = 0;
                        }
                        else
                        {
                            ThanhTien = Convert.ToDouble(Tg);
                        }
                        Class_ChiTietPhieuDB Test = new Class_ChiTietPhieuDB(MaPhieu, MaMonAn, MaLoai, SoLuong, GiamGia, ThanhTien);
                        list.Add(Test);
                    }
                }
            }
            con.Close();
            return list;
        }
        private void fill()
        {
            DataTable data = query.DocBang("select * from ChiTietPhieuDB");
            dataGridView1.DataSource = data;
        }

        private void Btn_Add_Click(object sender, EventArgs e)
        {
            if(Convert.ToDouble(textEdit3.Text) < 0.0 || Convert.ToDouble(textEdit3.Text) > 100)
            {
                MessageBox.Show("Bạn cần nhập số trong khoảng 0 đến 100", "Thông báo");
            }
            else if (cbb_MaLoai.Text.Trim() != "" && comboBox1.Text.Trim() != "" && cbb_MaMonAn.Text.Trim() != "" && textEdit2.Text.Trim() != "" && textEdit3.Text.Trim() != "")
            {
                Test = test1();
                bool check = true;
                for (int i = 0; i < Test.Count; i++)
                {
                    if (comboBox1.Text == Test[i].MaPhieu1 && cbb_MaMonAn.Text == Test[i].MaMonAn1)
                    {
                        check = false;
                        break;
                    }
                }
                if (check == true)
                {
                    string sql = "insert into ChiTietPhieuDB values(N'" + comboBox1.Text + "',N'" + cbb_MaMonAn.Text + "',N'" + cbb_MaLoai.Text + "','" + Convert.ToDouble(textEdit2.Text) + "','" + Convert.ToDouble(textEdit3.Text) + "','" + 0 + "')";
                    query.CapNhatDuLieu(sql);
                    fill();
                }
                else
                {
                    MessageBox.Show("Dữ liệu đã tồn tại", "Thông báo");
                }
            }
            else
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin", "Thông báo");
            }
            cbb_MaMonAn.Text = "";
            comboBox1.Text = "";
            cbb_MaLoai.Text = "";
            textEdit4.Text = "";
            textEdit3.Text = "";
            textEdit2.Text = "";
            cbb_MaMonAn.Enabled = true;
            comboBox1.Enabled = true;
        }

        private void Btn_Delete_Click(object sender, EventArgs e)
        {
            if (comboBox1.Text != "" && cbb_MaMonAn.Text != "")
            {
                if (MessageBox.Show("Bạn có muốn xóa không ?", "Thông báo", MessageBoxButtons.YesNo,
                   MessageBoxIcon.Question) == DialogResult.Yes)
                {
                    string sql = "delete from ChiTietPhieuDB where MaPhieu=N'" + comboBox1.Text + "'" + " and MaMonAn=N'" + cbb_MaMonAn.Text + "'";
                    query.CapNhatDuLieu(sql);
                    fill();
                    cbb_MaMonAn.Text = "";
                    comboBox1.Text = "";
                    cbb_MaLoai.Text = "";
                    textEdit4.Text = "";
                    textEdit3.Text = "";
                    textEdit2.Text = "";
                    cbb_MaMonAn.Enabled = true; //sao đoạn này lại=true
                }
            }
            else
            {
                MessageBox.Show("Vui lòng chọn dữ liệu", "Thông báo");
            }
        }

        private void Btn_close_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn có muốn thoát không ?", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                this.Close();
            }
        }

        private void DataGridView1_DoubleClick(object sender, EventArgs e)
        {
            //comboBox1.Enabled = false;
            //cbb_MaLoai.Enabled = false;
            //cbb_MaMonAn.Enabled = false;
            comboBox1.Text = dataGridView1.CurrentRow.Cells[0].Value.ToString();
            cbb_MaMonAn.Text = dataGridView1.CurrentRow.Cells[1].Value.ToString();
            cbb_MaLoai.Text = dataGridView1.CurrentRow.Cells[2].Value.ToString();
            textEdit2.Text = dataGridView1.CurrentRow.Cells[3].Value.ToString();
            textEdit3.Text = dataGridView1.CurrentRow.Cells[4].Value.ToString();
            textEdit4.Text = dataGridView1.CurrentRow.Cells[5].Value.ToString();

        }

        private void add()
        {
            MonAn = new frm_MonAn().Select();
            LM = new frm_LoaiMonAn().Select();
            DB = new frm_DatBan().Select();
            for (int i = 0; i < DB.Count; i++)
            {
                comboBox1.Items.Add(DB[i].MaPhieu1);
            }
            for (int i = 0; i < LM.Count; i++)
            {
                cbb_MaLoai.Items.Add(LM[i].MaLoai1);
            }
            for (int i = 0; i < MonAn.Count; i++)
            {
                cbb_MaMonAn.Items.Add(MonAn[i].MaMonAn1);
            }

        }

        private void Cbb_MaLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            MonAn = new frm_MonAn().Select();
            LM = new frm_LoaiMonAn().Select();
            cbb_MaMonAn.Items.Clear();
            for (int i = 0; i < MonAn.Count; i++)
            {
                if (MonAn[i].MaLoai1.Equals(cbb_MaLoai.Text))
                {
                    cbb_MaMonAn.Items.Add(MonAn[i].MaMonAn1);
                }
            }
            for (int i = 0; i < LM.Count; i++)
            {
                if (LM[i].MaLoai1.Equals(cbb_MaLoai.Text))
                {
                    cbb_MaLoai.Items.Add(LM[i].MaLoai1);
                }
            }

        }

        private void TextEdit3_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && (e.KeyChar != '.'))
            {
                e.Handled = true;
            }
        }

        private void TextEdit2_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Char.IsDigit(e.KeyChar) && !Char.IsControl(e.KeyChar))
            {
                e.Handled = true;
            }
        }

        private void Frm_chitietdatban_Load(object sender, EventArgs e)
        {

            add();
            comboBox1.Focus();
        }

        private void ComboBox1_Click(object sender, EventArgs e)
        {
            DB = new frm_DatBan().Select();
            comboBox1.Items.Clear();
            for (int i = 0; i < DB.Count; i++)
            {
                comboBox1.Items.Add(DB[i].MaPhieu1);
            }
        }

        private void Cbb_MaLoai_Click(object sender, EventArgs e)
        {
            LM = new frm_LoaiMonAn().Select();
            cbb_MaLoai.Items.Clear();
            for (int i = 0; i < LM.Count; i++)
            {
                cbb_MaLoai.Items.Add(LM[i].MaLoai1);
            }
        }

        private void Cbb_MaMonAn_Click(object sender, EventArgs e)
        {
            MonAn = new frm_MonAn().Select();
            cbb_MaMonAn.Items.Clear();
            for (int i = 0; i < MonAn.Count; i++)
            {
                cbb_MaMonAn.Items.Add(MonAn[i].MaMonAn1);
            }
        }

        private void Btn_refresh_Click(object sender, EventArgs e)
        {
            fill();
            cbb_MaLoai.Text = "";
            cbb_MaMonAn.Text = "";
            comboBox1.Text = "";
            textEdit2.Text = "";
            textEdit3.Text = "";
            textEdit4.Text = "";
        }
    }
}