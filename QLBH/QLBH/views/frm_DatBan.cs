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
    public partial class frm_DatBan : DevExpress.XtraEditors.XtraForm
    {
        List<Class_PhieuDatBan> Test;
        List<Class_Khach> Khach;
        List<Class_NhanVien> NV;
        ConnectAndQuery query = new ConnectAndQuery();
        public frm_DatBan()
        {
            InitializeComponent();
            fill();
            //add();
            this.comboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
        }
        private void add()
        {
            Khach = new frm_KhachHang().Select();
            NV = new frm_HoSoNhanVien().Select();
            for (int i = 0; i < Khach.Count; i++)
            {
                comboBox1.Items.Add(Khach[i].MaKhach1);
            }
            for (int i = 0; i < NV.Count; i++)
            {
                comboBox2.Items.Add(NV[i].MaNhanVien1);
            }
        }

        public new List<Class_PhieuDatBan> Select()
        {
            string sql = "SELECT * FROM PhieuDatban";
            List<Class_PhieuDatBan> list = new List<Class_PhieuDatBan>();
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
                        string MaNhanVien = reader.GetString(1);
                        string MaKhach = reader.GetString(2);
                        DateTime NgayDat = reader.GetDateTime(3);
                        DateTime NgayDung = reader.GetDateTime(4);
                        double TongTien;
                        var Tg = reader.GetValue(5);
                        if (Tg == DBNull.Value)
                        {
                            TongTien = 0;
                        }
                        else
                        {
                            TongTien = Convert.ToDouble(Tg);
                        }
                        Class_PhieuDatBan Test = new Class_PhieuDatBan(MaPhieu, MaKhach, MaNhanVien, NgayDat, NgayDung, TongTien);
                        list.Add(Test);
                    }
                }
            }
            con.Close();
            return list;
        }
        private void fill()
        {
            DataTable data = query.DocBang("select * from dbo.PhieuDatBan");
            dataGridView1.DataSource = data;
        }

        private void DataGridView1_DoubleClick(object sender, EventArgs e)
        {
            txt_LoaiBenh.Text = dataGridView1.CurrentRow.Cells[0].Value.ToString();
            comboBox1.Text = dataGridView1.CurrentRow.Cells[1].Value.ToString();
            comboBox2.Text = dataGridView1.CurrentRow.Cells[2].Value.ToString();
            //dateTimePicker1.Text = Convert.ToDateTime(dataGridView1.CurrentRow.Cells[3].Value);
            dateTimePicker1.Value = Convert.ToDateTime(dataGridView1.SelectedRows[0].Cells[3].Value);
            dateTimePicker2.Value = Convert.ToDateTime(dataGridView1.SelectedRows[0].Cells[4].Value);
            //dateTimePicker2.Text = dataGridView1.CurrentRow.Cells[4].Value.ToString();
            textEdit4.Text = dataGridView1.CurrentRow.Cells[5].Value.ToString();
            txt_LoaiBenh.Enabled = false;
        }
        private void Frm_DatBan_Load(object sender, EventArgs e)
        {
            add();
        }

        private void Btn_Add_Click(object sender, EventArgs e)
        {
            Test = Select();
            bool check = false;

            bool k = false, nv = false;
            NV = new frm_HoSoNhanVien().Select();

            for (int i = 0; i < Khach.Count; i++)
            {
                if (Khach[i].MaKhach1.Equals(comboBox1.Text))
                {
                    k = true;
                    break;
                }
            }
            if (k == false)
            {
                MessageBox.Show("Chưa có mã Khách này!", "Thông báo");
            }
            else
            {
                for (int i = 0; i < NV.Count; i++)
                {
                    if (NV[i].MaNhanVien1.Equals(comboBox2.Text))
                    {
                        nv = true;
                        break;
                    }
                }
                if (nv == false)
                {
                    MessageBox.Show("Chưa có mã nhân viên này!", "Thông báo");
                }
            }




            for (int i = 0; i < Test.Count; i++)
            {
                if (Test[i].MaPhieu1.Equals(txt_LoaiBenh.Text))
                {
                    check = true;
                    MessageBox.Show("Đã có mã phiếu này, vui lòng nhập lại", "Thông báo");
                    break;
                }

            }

            if (check == false && k == true && nv == true)
            {
                if (comboBox2.Text.Trim() != "" && txt_LoaiBenh.Text.Trim() != "" && comboBox1.Text.Trim() != "" && dateTimePicker1.Text.Trim() != "" && dateTimePicker2.Text.Trim() != "")
                {
                    string sql = "insert into PhieuDatBan values(" + "N'" + txt_LoaiBenh.Text + "',N'" + comboBox1.Text + "',N'" + comboBox2.Text + "',N'" + Convert.ToDateTime(dateTimePicker1.Text) + "','" + Convert.ToDateTime(dateTimePicker2.Text) + "','" + 0 + "')";
                    query.CapNhatDuLieu(sql);
                    fill();

                    //Select.Add(new Class_PhieuDatBan(txt_LoaiBenh.Text, comboBox1.Text, comboBox2.Text, Convert.ToDateTime(textEdit2.Text), Convert.ToDateTime(textEdit3.Text), Convert.Todouble(textEdit4.Text)));
                    comboBox2.Text = "";
                    txt_LoaiBenh.Text = "";
                    comboBox1.Text = "";
                    textEdit4.Text = "";
                    comboBox2.Enabled = true;
                }
                else
                {
                    MessageBox.Show("Vui lòng nhập đầy đủ thông tin", "Thông báo");
                }
            }

        }

        private void Btn_refesrh_Click(object sender, EventArgs e)
        {
            Test = Select();
            if ( comboBox2.Text.Trim() != "" && txt_LoaiBenh.Text.Trim() != "" && comboBox1.Text.Trim() != "" && dateTimePicker1.Text.Trim() != "" && dateTimePicker2.Text.Trim() != "")
            {
                string sql = "update PhieuDatBan set MaKhach=N'" + comboBox1.Text + "', MaNhanVien=N'" + comboBox2.Text + "', NgayDat=N'" + Convert.ToDateTime(dateTimePicker1.Text) + "', NgayDung=N'" + Convert.ToDateTime(dateTimePicker2.Text) +  "' where MaPhieu = N'" + txt_LoaiBenh.Text + "'";
                query.CapNhatDuLieu(sql);
                fill();

                //Select.Add(new Class_PhieuDatBan(txt_LoaiBenh.Text, comboBox1.Text, comboBox2.Text, Convert.ToDateTime(textEdit2.Text), Convert.ToDateTime(textEdit3.Text), Convert.Todouble(textEdit4.Text)));
                comboBox2.Text = "";
                txt_LoaiBenh.Text = "";
                comboBox1.Text = "";
                textEdit4.Text = "";
                comboBox2.Enabled = true;
            }
            else
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin", "Thông báo");
            }
        }

        private void Btn_Delete_Click(object sender, EventArgs e)
        {
            Test = Select();
            bool check = false;
            for (int i = 0; i < Test.Count; i++)
            {
                if (txt_LoaiBenh.Text.Trim() == Test[i].MaPhieu1)
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
                    string sql = "delete from PhieuDatBan where MaPhieu=N'" + txt_LoaiBenh.Text + "'";
                    query.CapNhatDuLieu(sql);
                    fill();
                    comboBox2.Text = "";
                    txt_LoaiBenh.Text = "";
                    comboBox1.Text = "";
                    textEdit4.Text = "";
                    comboBox2.Enabled = true;
                }
            }
            else
            {
                MessageBox.Show("Vui lòng chọn dữ liệu", "message");
            }
        }

        private void Btn_close_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn có muốn thoát không ?", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                this.Close();
            }
        }

        private void ComboBox1_Click(object sender, EventArgs e)
        {
            Khach = new frm_KhachHang().Select();
            comboBox1.Items.Clear();
            for (int i = 0; i < Khach.Count; i++)
            {
                comboBox1.Items.Add(Khach[i].MaKhach1);
            }
        }

        private void ComboBox2_Click(object sender, EventArgs e)
        {
            NV = new frm_HoSoNhanVien().Select();
            comboBox2.Items.Clear();
            for (int i = 0; i < NV.Count; i++)
            {
                comboBox2.Items.Add(NV[i].MaNhanVien1);
            }
        }

        private void Btn_refresh_Click(object sender, EventArgs e)
        {
            comboBox2.Text = "";
            txt_LoaiBenh.Text = "";
            comboBox1.Text = "";
            textEdit4.Text = "";
            txt_LoaiBenh.Enabled = true;
        }
    }
}
