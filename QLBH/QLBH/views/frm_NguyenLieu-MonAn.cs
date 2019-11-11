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
    public partial class frm_NguyenLieu_MonAn : DevExpress.XtraEditors.XtraForm
    {
        List<Class_NguyenLieu_MonAn> Test;
        List<Class_MonAn> MonAn = new List<Class_MonAn>();
        List<Class_NguyenLieu> NL = new List<Class_NguyenLieu>();
        ConnectAndQuery query = new ConnectAndQuery();
        public frm_NguyenLieu_MonAn()
        {
            InitializeComponent();
            fill();
            add();
            this.comboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
        }
        private void add()
        {
            MonAn = new frm_MonAn().Select();
            NL = new frm_NguyenLieu().Select();
            for (int i = 0; i < MonAn.Count; i++)
            {
                comboBox1.Items.Add(MonAn[i].MaMonAn1);
            }
            for (int i = 0; i < NL.Count; i++)
            {
                comboBox2.Items.Add(NL[i].MaNguyenLieu1);
            }
        }
        private void fill()
        {
            DataTable data = query.DocBang("select * from NguyenLieu_MonAn");
            dataGridView1.DataSource = data;
        }
        private List<Class_NguyenLieu_MonAn> test1()
        {
            string sql = "SELECT * FROM NguyenLieu_MonAn";
            List<Class_NguyenLieu_MonAn> list = new List<Class_NguyenLieu_MonAn>();
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
                        string MaMonAn = reader.GetString(0);
                        string MaNguyenLieu = reader.GetString(1);
                        double SoLuong = reader.GetDouble(1);
                        Class_NguyenLieu_MonAn Test = new Class_NguyenLieu_MonAn(MaMonAn, MaNguyenLieu, SoLuong);
                        list.Add(Test);
                    }
                }
            }
            con.Close();
            return list;
        }

        private void labelControl1_Click(object sender, EventArgs e)
        {

        }

        private void Btn_Delete_Click(object sender, EventArgs e)
        {
            if (comboBox1.Text != "" && comboBox2.Text != "")
            {
                if (MessageBox.Show("Bạn có muốn xóa không ?", "Thông báo", MessageBoxButtons.YesNo,
                  MessageBoxIcon.Question) == DialogResult.Yes)
                {
                    string sql = "delete from NguyenLieu_MonAn where MaMonAn=N'" + comboBox1.Text + "' and MaNguyenLieu=N'" + comboBox2.Text + "'";
                    query.CapNhatDuLieu(sql);
                    fill();

                    comboBox1.Text = "";
                    comboBox2.Text = "";
                }
            }
            else
            {
                MessageBox.Show("Vui lòng chọn dữ liệu", "Thông báo");
            }
        }

        private void Btn_refesrh_Click(object sender, EventArgs e)
        {
            if (comboBox1.Text.Trim() != "" && comboBox2.Text.Trim() != "" && textEdit2.Text.Trim() != "")
            {
                NL = new frm_NguyenLieu().Select();
                int j = 0;
                for (int i = 0; i < NL.Count; i++)
                {
                    if (comboBox2.Text == NL[i].MaNguyenLieu1)
                    {
                        j = i;
                        break;
                    }
                }
                if (Convert.ToDouble(textEdit2.Text) <= NL[j].SoLuong1)
                {
                    string sql = "UPDATE NguyenLieu_MonAn set SoLuong = '" + Convert.ToDouble(textEdit2.Text) + "' where MaMonAn=N'" + comboBox1.Text + "' and MaNguyenLieu=N'" + comboBox2.Text + "'";
                    query.CapNhatDuLieu(sql);
                    fill();


                    comboBox1.Text = "";
                    comboBox2.Text = "";
                }
                else
                {
                    MessageBox.Show("Số lượng vượt quá giới hạn", "Thông báo");
                }
            }
            else
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin", "Thông báo");
            }
        }

        private void Btn_Add_Click(object sender, EventArgs e)
        {
            bool MA = false;
            bool nl = false;
            int j = 0;
            MonAn = new frm_MonAn().Select();
            NL = new frm_NguyenLieu().Select();
            for (int i = 0; i < MonAn.Count; i++)
            {
                if (MonAn[i].MaMonAn1.Equals(comboBox1.Text))
                {
                    MA = true;
                    break;
                }
            }

            if (MA == false)
            {
                MessageBox.Show("Chưa có mã món ăn " + comboBox1.Text, "Thông báo");
            }
            else
            {
                for (int i = 0; i < NL.Count; i++)
                {
                    if (NL[i].MaNguyenLieu1.Equals(comboBox2.Text))
                    {
                        nl = true;
                        j = i;
                        break;
                    }
                }

                if (nl == false)
                {
                    MessageBox.Show("Chưa có mã nguyên liệu " + comboBox2.Text, "Thông báo");
                }
            }



            if (MA == true && nl == true && comboBox1.Text.Trim() != "" && comboBox2.Text.Trim() != "" && textEdit2.Text.Trim() != "")
            {
                if (Convert.ToDouble(textEdit2.Text) <= NL[j].SoLuong1)
                {
                    string sql = "insert into NguyenLieu_MonAn values(N'" + comboBox1.Text + "',N'" + comboBox2.Text + "','" + Convert.ToDouble(textEdit2.Text) + "')";
                    query.CapNhatDuLieu(sql);
                    fill();


                    comboBox1.Text = "1";
                    comboBox2.Text = "1";
                }
                else
                {
                    MessageBox.Show("Số lượng vượt quá giới hạn", "Thông báo");
                }
            }
            else
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin", "Thông báo");
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
            comboBox1.Enabled = false;
            comboBox2.Enabled = false;
            comboBox1.Text = dataGridView1.CurrentRow.Cells[0].Value.ToString();
            comboBox2.Text = dataGridView1.CurrentRow.Cells[1].Value.ToString();
            textEdit2.Text = dataGridView1.CurrentRow.Cells[2].Value.ToString();
        }

        private void TextEdit2_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Char.IsDigit(e.KeyChar) && !Char.IsControl(e.KeyChar))
            {
                e.Handled = true;
            }
        }

        private void ComboBox1_Click(object sender, EventArgs e)
        {
            MonAn = new frm_MonAn().Select();
            comboBox1.Items.Clear();
            for (int i = 0; i < MonAn.Count; i++)
            {
                comboBox1.Items.Add(MonAn[i].MaMonAn1);
            }
        }

        private void ComboBox2_Click(object sender, EventArgs e)
        {
            NL = new frm_NguyenLieu().Select();
            comboBox2.Items.Clear();
            for (int i = 0; i < NL.Count; i++)
            {
                comboBox2.Items.Add(NL[i].MaNguyenLieu1);
            }
        }

        private void Btn_refresh_Click(object sender, EventArgs e)
        {
            comboBox1.Text = "";
            comboBox2.Text = "";
            textEdit2.Text = "";
        }
    }
}