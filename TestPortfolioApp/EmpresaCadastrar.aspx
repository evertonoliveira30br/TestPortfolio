<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmpresaCadastrar.aspx.cs" Inherits="TestPortfolioApp.EmpresaCadastrar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script src="Scripts/jquery-3.4.1.min.js"></script>

    <script type="text/javascript">

        function somenteNumeros(e) {
            var charCode = e.charCode ? e.charCode : e.keyCode;
            
            if (charCode != 8 && charCode != 9) {
                
                if (charCode < 48 || charCode > 57) {
                    return false;
                }
            }
        }
        
        function salvarEmpresa() {

            let empresaForm = {
                Nome: $("[id$=txtNome]").val(),
                Cnpj: $("[id$=txtCnpj]").val()               
            };

            if (associadoForm.Nome == '' || associadoForm.Cnpj.length < 14) {
                alert('Favor preencher todos os campos!');
                return;
            }

            $.ajax({
                type: "POST",
                url: "https://localhost:44364/api/empresas",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(empresaForm),
                success: function (d) {
                    alert('Empresa cadastrado com sucesso');

                },
                error: function (error) {
                    alert('CNPJ:' + associadoForm.Cpf + ' ja existe na base.');
                }
            });
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

      
        <div>
            <h2>Cadastrar Nova Empresa</h2>
            <div>
                <label>Nome Empresa</label>
                <br />
                <asp:TextBox ID="txtNome" runat="server" />
            </div>
            <div>
                <label>CNPJ</label>
                <br />
                <asp:TextBox ID="txtCnpj" runat="server" MaxLength="14" onkeypress="return somenteNumeros(event)" />
            </div>
            
            <br />
            <div>
                <input type="Button" onclick="salvarEmpresa();" value="Salvar" /> 
            </div>
        </div>    

</asp:Content>
