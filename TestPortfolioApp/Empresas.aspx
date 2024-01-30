<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Empresas.aspx.cs" Inherits="TestPortfolioApp.Empresas" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script src="Scripts/jquery-3.4.1.min.js"></script>

    <script type="text/javascript">
    function listarEmpresas() {
        $.getJSON("https://localhost:44364/api/empresas",
            function (data) {
                $('#empresas').empty();
                $.each(data, function (key, val) {

                    var row = '<td>' + val.Id + '</td><td>' + val.Nome +
                        '</td><td>' + val.Cnpj + '</td>' +
                        '<td><input type="button" value="Editar" onclick="redirecionarEdicaoEmpresa(' + val.Id + ')"> <input type="button" value="Excluir" onclick="excluirEmpresa(' + val.Id + ')"> </td>'

                        ;
                    $('<tr/>', { html: row })
                        .appendTo($('#empresas'));
                });
            });
        }

        function PesquisarEmpresas() {
            $.getJSON("https://localhost:44364/api/empresas?filtro=" + $('#txtFiltro').val(),
                function (data) {
                    $('#empresas').empty();
                    $.each(data, function (key, val) {

                        var row = '<td>' + val.Id + '</td><td>' + val.Nome +
                            '</td><td>' + val.Cnpj + '</td>' +
                            '<td><input type="button" value="Editar" onclick="redirecionarEdicaoEmpresa(' + val.Id + ')"> <input type="button" value="Excluir" onclick="excluirEmpresa(' + val.Id + ')"> </td>'

                            ;
                        $('<tr/>', { html: row })
                            .appendTo($('#empresas'));
                    });
                });
        }

        function excluirEmpresa(id) {
            if (confirm('Deseja realmente excluir esta empresa?')) {
                $.ajax({
                    type: 'DELETE',
                    url: 'https://localhost:44364/api/empresas/' + id,
                    success: function (response) {
                        alert('Empresa excluída com sucesso.');
                        listarEmpresas();
                    },
                    error: function (error) {
                        alert('Erro ao excluir empresa.');
                    }
                });
            }
        }       
      
        function redirecionarCadastroEmpresa() {
                window.location.href = 'EmpresaCadastrar.aspx';
        }

        function redirecionarEdicaoEmpresa(id) {
            window.location.href = 'EmpresaEditar?id=' + id;
        }

        $(document).ready(function () {

            listarEmpresas();

        });
    </script>

</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Empresas</h2>
    
    <asp:Button  ID="btnCadastrarEmpresa" runat="server" Text="Cadastrar Nova Empresa" OnClientClick="redirecionarCadastroEmpresa(); return false;"  />
    <hr />
    <div>        
        <input type="text" id="txtFiltro" />
        <input type="button" value="Pesquisar" id="btnPesquisar" onclick="PesquisarEmpresas();" />
     </div>
    <hr />

    <table style="width:70%;">
    <thead>
        <tr>
            <th>Id</th>
            <th>Nome</th>
            <th>CNPJ</th>           
            <th>Ações</th>

        </tr>
    </thead>
    <tbody id="empresas">
    </tbody>
    </table>

</asp:Content>

