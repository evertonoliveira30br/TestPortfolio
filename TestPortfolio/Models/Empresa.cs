using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TestPortfolioAPI.Models
{
    public class Empresa
    {
        public int Id { get; set; }
        public string Nome { get; set; }
        public string Cnpj { get; set; }       
    }
}