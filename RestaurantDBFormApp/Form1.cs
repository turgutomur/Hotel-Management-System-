using System;
using System.Collections.Generic;
using System.Data;
using System.Windows.Forms;
using Npgsql;

namespace RestaurantDBFormApp
{
    public partial class CustomerForm : Form
    {
        // Database connection string (update with your own details)
        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=hamza2002;Database=ResDB";

        public CustomerForm()
        {
            InitializeComponent();
            LoadCustomers();

        }

        // Load all customers into the DataGridView when the form loads
        private void CustomerForm_Load(object sender, EventArgs e)
        {
            LoadCustomers();
        }

        // Function to load customers into DataGridView
        private void LoadCustomers()
        {
            using (var conn = new NpgsqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT CustomerID, Name, PhoneNumber, Email FROM Customer";
                using (var cmd = new NpgsqlCommand(query, conn))
                {
                    NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    customerDataGridView.DataSource = dt;
                }
            }
        }

        // Insert new customer
        private void insertButton_Click(object sender, EventArgs e)
        {
            using (var connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Call the insert_customer function
                    using (var cmd = new NpgsqlCommand("SELECT insert_customer(@name, @phone, @email)", connection))
                    {
                        cmd.Parameters.AddWithValue("name", nameTextBox.Text);
                        cmd.Parameters.AddWithValue("phone", phoneTextBox.Text);
                        cmd.Parameters.AddWithValue("email", emailTextBox.Text);
                        cmd.ExecuteNonQuery();
                    }

                    LoadCustomerList();  // Refresh the customer list
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: " + ex.Message);
                }
            }
        }
        // Update an existing customer
        private void updateButton_Click(object sender, EventArgs e)
        {
            if (customerDataGridView.SelectedRows.Count > 0)
            {
                var selectedRow = customerDataGridView.SelectedRows[0];
                int customerId = Convert.ToInt32(selectedRow.Cells["CustomerID"].Value);

                using (var connection = new NpgsqlConnection(connectionString))
                {
                    try
                    {
                        connection.Open();
                        // Call the update_customer function
                        using (var cmd = new NpgsqlCommand("SELECT update_customer(@customerId, @name, @phone, @email)", connection))
                        {
                            cmd.Parameters.AddWithValue("customerId", customerId);
                            cmd.Parameters.AddWithValue("name", nameTextBox.Text);
                            cmd.Parameters.AddWithValue("phone", phoneTextBox.Text);
                            cmd.Parameters.AddWithValue("email", emailTextBox.Text);
                            cmd.ExecuteNonQuery();
                        }

                        LoadCustomerList();  // Refresh the customer list
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Error: " + ex.Message);
                    }
                }
            }
            else
            {
                MessageBox.Show("Please select a customer to update.");
            }
        }

        // Delete a customer
        private void deleteButton_Click(object sender, EventArgs e)
        {
            if (customerDataGridView.SelectedRows.Count > 0)
            {
                var selectedRow = customerDataGridView.SelectedRows[0];
                int customerId = Convert.ToInt32(selectedRow.Cells["CustomerID"].Value);

                var confirmResult = MessageBox.Show("Are you sure you want to delete this customer?",
                                                     "Confirm Delete",
                                                     MessageBoxButtons.YesNo);

                if (confirmResult == DialogResult.Yes)
                {
                    using (var connection = new NpgsqlConnection(connectionString))
                    {
                        try
                        {
                            connection.Open();
                            // Call the delete_customer function
                            using (var cmd = new NpgsqlCommand("SELECT delete_customer(@customerId)", connection))
                            {
                                cmd.Parameters.AddWithValue("customerId", customerId);
                                cmd.ExecuteNonQuery();
                            }

                            LoadCustomerList();  // Refresh the customer list
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show("Error: " + ex.Message);
                        }
                    }
                }
            }
            else
            {
                MessageBox.Show("Please select a customer to delete.");
            }
        }


        // Search customers
        private void searchButton_Click(object sender, EventArgs e)
        {
            string searchTerm = searchTextBox.Text;

            using (var connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    // Call the search_customers function
                    using (var cmd = new NpgsqlCommand("SELECT * FROM search_customers(@searchTerm)", connection))
                    {
                        cmd.Parameters.AddWithValue("searchTerm", searchTerm);

                        using (var reader = cmd.ExecuteReader())
                        {
                            var customerList = new List<Customer>();

                            while (reader.Read())
                            {
                                var customer = new Customer
                                {
                                    CustomerID = reader.GetInt32(0),
                                    Name = reader.GetString(1),
                                    PhoneNumber = reader.GetString(2),
                                    Email = reader.GetString(3)
                                };
                                customerList.Add(customer);
                            }

                            // Display search results in DataGridView
                            customerDataGridView.DataSource = customerList;
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: " + ex.Message);
                }
            }
        }
        private void LoadCustomerList(string searchTerm = "")
        {
            try
            {
                string query = "SELECT * FROM search_customers(@searchTerm)";
                using (var connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    using (var cmd = new NpgsqlCommand(query, connection))
                    {
                        cmd.Parameters.AddWithValue("@searchTerm", searchTerm);

                        using (var reader = cmd.ExecuteReader())
                        {
                            var dataTable = new DataTable();
                            dataTable.Load(reader);
                            customerDataGridView.DataSource = dataTable;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
        public class Customer
        {
            public int CustomerID { get; set; }
            public string Name { get; set; }
            public string PhoneNumber { get; set; }
            public string Email { get; set; }
        }

        private void searchTextBox_TextChanged(object sender, EventArgs e)
        {
            searchButton_Click( sender, e);
        }
    }
}
