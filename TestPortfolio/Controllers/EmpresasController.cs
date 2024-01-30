using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Cors;
using TestPortfolioAPI.Models;

namespace TestPortfolioAPI.Controllers
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    [RoutePrefix("api/empresas")]
    public class EmpresasController : ApiController
    {
        const string connectionString =
            "Data Source=SQL5063.site4now.net;Initial Catalog=db_a6fb4f_portfolio;User Id=db_a6fb4f_portfolio_admin;Password=portfolio@2024";


        [AcceptVerbs("Get")]
        public IEnumerable<Empresa> ListarEmpresas()
        {
            List<Empresa> empresas = new List<Empresa>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = "SELECT * FROM Empresa";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;

                try
                {
                    connection.Open();

                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        empresas.Add(new Empresa
                        {
                            Id = (int)reader["Id"],
                            Cnpj = reader["Cnpj"].ToString(),
                            Nome = reader["Nome"].ToString(),
                           
                        });
                    }
                    reader.Close();

                    return empresas;

                }
                catch (Exception)
                {
                    return empresas;
                }

            }
        }
    }
}