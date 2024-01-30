using System;
using System.Web;
using System.Web.Http;

namespace TestPortfolioAPI
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Código que é executado na inicialização do aplicativo
            GlobalConfiguration.Configure(WebApiConfig.Register);
        }
    }
}