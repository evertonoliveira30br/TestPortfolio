<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AssociadoEditar.aspx.cs" Inherits="TestPortfolioApp.AssociadoEditar" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    
    <script src="Scripts/jquery-3.4.1.min.js"></script>  

    <script type="text/javascript">

        function salvarAssociado() {            

            let associadoForm = {
                Id: $("[id$=txtId]").val(),
                Nome: $("[id$=txtNome]").val(),
                Cpf: $("[id$=txtCpf]").val(),
                DataNascimento: $("[id$=txtDataNascimento").val()

            };

            $.ajax({
                type: "PUT",
                url: "https://localhost:44364/api/associados",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(associadoForm),
                success: function(d) {
                    alert('Dados do Associado Alterado Com Sucesso');

                },
                error: function (error) {
                    alert('Erro ao alterar dados do Associado:' + error.responseText);
                }
            });
        }

        function vincularEmpresa() {

            let Id = $("[id$=txtId]").val();
            let IdEmpresa = document.getElementById('ddlEmpresas').value;            

            $.ajax({
                type: "POST",
                url: "https://localhost:44364/api/associados/" + Id + "/empresa/" + IdEmpresa,
                contentType: "application/json; charset=utf-8",
                dataType: "json",                
                success: function (d) {
                    alert('Empresa vinculada com sucesso');

                },
                error: function (error) {
                    alert('Erro ao vincular empresa. ' + error.responseText);
                }
            });
        }

        $(document).ready(function () {
                      

            $.ajax({
                type: "GET",
                url: "https://localhost:44364/api/empresas",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    
                    $(data).each(function () {
                        $('#ddlEmpresas').append($('<option/>', {value:this.Id}).html(this.Nome));
                    });               
                  
                },
                error: function (error) {
                   alert(error);
                }
            });

            $.ajax({
                type: "GET",
                url: "https://localhost:44364/api/associados/" + $("[id$=txtId]").val(),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $("[id$=txtNome]").val(data.Nome);
                    $("[id$=txtCpf]").val(data.Cpf);
                    $("[id$=txtDataNascimento]").val(data.DataNascimento);

                },
                error: function (error) {
                    alert('Erro');
                }
            });         

            


        });
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
        <div>
            <h2>Editar Associado</h2>
            <div>
                <label for="txtId">Id:</label>               
               <asp:TextBox ReadOnly="true" ID="txtId" runat="server" />
            </div>
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
                <input type="Button" onclick="salvarAssociado();" value="Salvar" />               
            </div>
        </div> 

        <hr />

        <div>
            <h2>Empresas</h2>
            <div>
                <select id="ddlEmpresas"></select>     
                <input type="Button" id="btnAssociarEmpresa" onclick="vincularEmpresa();" value="Associar Empresa" /> 
                
            </div>
        </div>

</asp:Content>
