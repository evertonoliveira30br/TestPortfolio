using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
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

        [Route("{id}")]
        [AcceptVerbs("Delete")]
        public bool Excluir(int id)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = @"
                    DELETE Associado_Empresa WHERE EmpresaId=@id;
                    DELETE Empresa WHERE Id=@id";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@id", id);

                try
                {
                    connection.Open();

                    command.ExecuteNonQuery();

                    return true;
                }
                catch (Exception ex)
                {
                    return false;
                }

            }
        }

        [AcceptVerbs("Post")]
        public bool Adicionar([FromBody] Empresa empresa)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = "INSERT INTO Empresa VALUES(@Nome,@Cnpj)";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@Nome", empresa.Nome);
                command.Parameters.AddWithValue("@Cnpj", empresa.Cnpj);             

                try
                {
                    connection.Open();

                    command.ExecuteNonQuery();

                    return true;
                }
                catch (Exception ex)
                {
                    throw;
                }

            }

        }

        [Route("{id}")]
        [AcceptVerbs("Get")]
        public Empresa RecuperarEmpresa(int id)
        {
            var empresas = ListarEmpresas();

            return empresas.FirstOrDefault(a => a.Id == id);
        }

        [AcceptVerbs("Put")]
        public bool Editar([FromBody] Empresa empresa)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = "UPDATE Empresa SET Nome=@Nome,Cnpj=@Cnpj WHERE Id=@Id";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@Id", empresa.Id);
                command.Parameters.AddWithValue("@Nome", empresa.Nome);
                command.Parameters.AddWithValue("@Cnpj", empresa.Cnpj);     

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

        [Route("{id}/associado/{idAssociado}")]
        [AcceptVerbs("Post")]
        public bool VincularAssociado(int id, int idAssociado)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = "INSERT INTO associado_empresa VALUES(@idAssociado,@id)";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@id", id);
                command.Parameters.AddWithValue("@idAssociado", idAssociado);


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
        public IEnumerable<Empresa> ListarEmpresasByFiltro(string filtro)
        {
            var empresas = ListarEmpresas();

            if (String.IsNullOrEmpty(filtro))
                return empresas;

            return empresas.Where(a => a.Nome.ToUpper().Contains(filtro.ToUpper()) ||
                                         a.Cnpj.Contains(filtro)
                                   );
        }

        [Route("{id}/associados")]
        [AcceptVerbs("Get")]
        public IEnumerable<Associado> ListarAssociados(int id)
        {
            List<Associado> associados = new List<Associado>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var queryString = @"SELECT A.* FROM associado_empresa AE
                                    INNER JOIN Associado A ON AE.AssociadoId = A.Id
                                    WHERE EmpresaId=@id";

                SqlCommand command = new SqlCommand(queryString, connection);
                command.CommandType = System.Data.CommandType.Text;
                command.Parameters.AddWithValue("@id", id);


                try
                {
                    connection.Open();

                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        associados.Add(new Associado
                        {
                            Id = (int)reader["Id"],
                            Cpf = reader["Cpf"].ToString(),
                            Nome = reader["Nome"].ToString()
                        });
                    }
                    reader.Close();

                    return associados;
                }
                catch (Exception)
                {
                    return null;
                }

            }

        }
    }
}