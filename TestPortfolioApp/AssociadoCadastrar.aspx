﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AssociadoCadastrar.aspx.cs" Inherits="TestPortfolioApp.DetalheAssociado" %>
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
        
        function salvarAssociado() {

            let associadoForm = {
                Nome: $("[id$=txtNome]").val(),
                Cpf: $("[id$=txtCpf]").val(),
                DataNascimento: $("#txtDataNascimento").val()

            };

            if (associadoForm.Nome == '' || associadoForm.Cpf.length < 11 || associadoForm.DataNascimento.length < 10) {
                alert('Favor preencher todos os campos!');
                return;
            }


            $.ajax({
                type: "POST",
                url: "https://localhost:44364/api/associados",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(associadoForm),
                success: function (d) {
                    alert('Associado cadastrado com sucesso');

                },
                error: function (error) {
                    alert('CPF:' + associadoForm.Cpf + ' ja existe na base.');
                }
            });
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

      
        <div>
            <h2>Cadastrar Novo Associado</h2>
            <div>
                <label>Nome:</label>
                <br />
                <asp:TextBox ID="txtNome" runat="server" />
            </div>
            <div>
                <label>CPF:</label>
                <br />
                <asp:TextBox ID="txtCpf" runat="server" MaxLength="11" onkeypress="return somenteNumeros(event)" />
            </div>
            <div>
                <label>Data de Nascimento:</label>
                <br />
                <input type="date" id="txtDataNascimento" />                
            </div>
            <br />
            <div>
                <input type="Button" onclick="salvarAssociado();" value="Salvar" /> 
            </div>
        </div>    

</asp:Content>