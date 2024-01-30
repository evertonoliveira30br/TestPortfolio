using System;

namespace TestPortfolioApp
{
    public partial class AssociadoEditar : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           var id = Request.QueryString["id"];
            txtId.Text = id;
        }
    }
}