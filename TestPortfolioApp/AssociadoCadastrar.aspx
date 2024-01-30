<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AssociadoCadastrar.aspx.cs" Inherits="TestPortfolioApp.DetalheAssociado" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

      
        <div>
            <h2>Cadastrar Novo Associado</h2>
            <div>
                <label for="txtNome">Nome:</label>
                <asp:TextBox ID="txtNome" runat="server" />
            </div>
            <div>
                <label for="txtCpf">CPF:</label>
                <asp:TextBox ID="txtCpf" runat="server" />
            </div>
            <div>
                <label for="txtDataNascimento">Data de Nascimento:</label>
                <asp:TextBox ID="txtDataNascimento" runat="server" />
            </div>
            <div>
                <asp:Button ID="btnCadastrar" runat="server" Text="Salvar"  />
            </div>
        </div>    

</asp:Content>