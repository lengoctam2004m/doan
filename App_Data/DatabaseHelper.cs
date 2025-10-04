using System;
using System.Configuration;
using System.Data.SqlClient;

namespace TechStore.App_Data
{
    public class DatabaseHelper
    {
        public static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        }

        public static bool TestConnection()
        {
            try
            {
                using (var connection = new SqlConnection(GetConnectionString()))
                {
                    connection.Open();
                    return true;
                }
            }
            catch (Exception ex)
            {
                // Log error if needed
                Console.WriteLine($"Database connection error: {ex.Message}");
                return false;
            }
        }

        public static void CreateDatabaseIfNotExists()
        {
            try
            {
                using (var connection = new SqlConnection(GetConnectionString()))
                {
                    connection.Open();
                    
                    // Create database if not exists
                    var createDbCommand = new SqlCommand(
                        "IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TechStoreDB') " +
                        "BEGIN CREATE DATABASE TechStoreDB END", connection);
                    createDbCommand.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error creating database: {ex.Message}");
            }
        }
    }
}
