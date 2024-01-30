using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using TestPortfolioAPI.Models;

namespace TestPortfolioAPI
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    [RoutePrefix("api/associados")]
    public class AssociadosController : ApiController
    {
        const string connectionString =
            "Data Source=SQL5063.site4now.net;Initial Catalog=db_a6fb4f_portfolio;User Id=db_a6fb4f_portfolio_admin;Password=portfolio@2024";        

       
        [Route("{id}")]
        [AcceptVerbs("Delete")]
        public IHttpActionResult ExcluirAssociado(int id)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = "DELETE Associado WHERE Id=@id";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@id", id);              

                try
                {
                    connection.Open();

                    command.ExecuteNonQuery();

                    return Ok();
                }
                catch (Exception ex)
                {
                    return BadRequest(ex.Message);
                }

            }           
        }

        
        [AcceptVerbs("Post")]
        public bool AdicionarAssociado([FromBody] Associado associado)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = "INSERT INTO Associado VALUES(@Nome,@Cpf,@DataNascimento)";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@Nome", associado.Nome);
                command.Parameters.AddWithValue("@Cpf", associado.Cpf);
                command.Parameters.AddWithValue("@DataNascimento", associado.DataNascimento);
                
                try
                {
                    connection.Open();

                    command.ExecuteNonQuery();

                    return true;
                }
                catch (Exception)
                {
                    return false;
                }
                
            }           
                       
        }

        [AcceptVerbs("Get")]
        public IEnumerable<Associado> ListarAssociados()
        {
            List<Associado> associados = new List<Associado>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = "SELECT * FROM Associado";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;               

                try
                {
                    connection.Open();

                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        associados.Add(new Associado { 
                            Id = (int)reader["Id"],
                            Cpf=reader["Cpf"].ToString(),
                            Nome=reader["Nome"].ToString(),
                            DataNascimento=(DateTime)reader["DataNascimento"]
                        });                     
                    }
                    reader.Close();

                    return associados;
                                   
                }
                catch (Exception)
                {
                    return associados;
                }

            }
        }

        [Route("{id}")]
        [AcceptVerbs("Get")]
        public Associado RecuperarAssociado(int id)
        {
            var associados = ListarAssociados();

            return associados.FirstOrDefault(a => a.Id == id);            
        }

        [AcceptVerbs("Put")]
        public bool EditarAssociado([FromBody] Associado associado)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = "UPDATE Associado SET Nome=@Nome,@Cpf=@Cpf,DataNascimento=@DataNascimento WHERE Id=@Id";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@Id", associado.Id);
                command.Parameters.AddWithValue("@Nome", associado.Nome);
                command.Parameters.AddWithValue("@Cpf", associado.Cpf);
                command.Parameters.AddWithValue("@DataNascimento", associado.DataNascimento);

                try
                {
                    connection.Open();

                    command.ExecuteNonQuery();

                    return true;
                }
                catch (Exception)
                {
                    return false;
                }

            }

        }

        [Route("{id}/empresa/{idEmpresa}")]
        [AcceptVerbs("Post")]
        public bool AssociarEmpresa(int id, int idEmpresa)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = "INSERT INTO associado_empresa VALUES(@id,@idEmpresa)";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@id",id);
                command.Parameters.AddWithValue("@idEmpresa",idEmpresa);
                

                try
                {
                    connection.Open();

                    command.ExecuteNonQuery();

                    return true;
                }
                catch (Exception)
                {
                    return false;
                }

            }

        }

        [AcceptVerbs("Get")]
        public IEnumerable<Associado> ListarAssociadosByFiltro(string filtro)
        {
            var associados = ListarAssociados();

            return associados.Where(a => a.Nome.ToUpper().Contains(filtro.ToUpper()) || 
                                         a.Cpf.Contains(filtro) || 
                                         a.DataNascimento.ToString("dd/MM/yyyy").Contains(filtro)
                                   );
        }

        [Route("{id}/empresas")]
        [AcceptVerbs("Get")]
        public IEnumerable<Empresa> ListarEmpresas(int id)
        {
            List<Empresa> empresas = new List<Empresa>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = @"SELECT E.* FROM associado_empresa AE
                                    INNER JOIN Empresa E ON AE.EmpresaId = E.Id
                                    WHERE AssociadoId=@id";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@id", id);               


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
                            Nome = reader["Nome"].ToString()                           
                        });
                    }
                    reader.Close();

                    return empresas;
                }
                catch (Exception)
                {
                    return null;
                }

            }

        }
    }
}