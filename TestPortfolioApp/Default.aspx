<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TestPortfolioApp._Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-3.4.1.min.js"></script>

    <script type="text/javascript">
    function listarAssociados() {
        $.getJSON("https://localhost:44364/api/associados",
            function (data) {
                $('#associados').empty();                
                $.each(data, function (key, val) {
                   
                    var row = '<td>' + val.Id + '</td><td>' + val.Nome +
                        '</td><td>' + val.Cpf + '</td><td>' + val.DataNascimento + '</td>' +
                        '<td><input type="button" value="Editar" onclick="msg()"> <input type="button" value="Excluir" onclick="excluirAssociado(1)"> </td>'

                        ;
                    $('<tr/>', { html: row })  
                        .appendTo($('#associados'));
                });
            });
        }

        function excluirAssociado(id) {
            if (confirm('Deseja realmente excluir este associado?')) {
                $.ajax({
                    type: 'DELETE',
                    url: 'https://localhost:44364/api/associados/' + id,
                    success: function (response) {
                        alert('Associado excluído com sucesso.');
                        // Lógica adicional após exclusão
                    },
                    error: function (error) {
                        alert('Erro ao excluir associado.');
                    }
                });
            }
        }
      
        function redirecionarCadastroAssociado() {
                window.location.href = 'AssociadoCadastrar.aspx';
        }    

        $(document).ready(function () {

            listarAssociados();           

        });
    </script>

</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Associados</h2>
   <asp:Button  ID="btnCadastrarAssociado" runat="server" Text="Cadastrar Novo Associado" OnClientClick="redirecionarCadastroAssociado(); return false;"  />
    <table style="width:70%;">
    <thead>
        <tr>
            <th>Id</th>
            <th>Nome</th>
            <th>CPF</th>
            <th>Data Nascimento</th>
            <th>Ações</th>

        </tr>
    </thead>
    <tbody id="associados">
    </tbody>
    </table>

</asp:Content>
