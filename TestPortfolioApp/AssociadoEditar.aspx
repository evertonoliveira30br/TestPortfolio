<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AssociadoEditar.aspx.cs" Inherits="TestPortfolioApp.AssociadoEditar" %>
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
                Id: $("[id$=txtId]").val(),
                Nome: $("[id$=txtNome]").val(),
                Cpf: $("[id$=txtCpf]").val(),
                DataNascimento: $("#txtDataNascimento").val()

            };

            if (associadoForm.Id == '' || associadoForm.Nome == '' || associadoForm.Cpf.length < 11 || associadoForm.DataNascimento.length < 10)
            {
                alert('Favor preencher todos os campos!');
                return;
            }
                

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

            if (IdEmpresa == '' || IdEmpresa == 'undefined') {
                alert('Nenhuma Empresa foi selecionada!');
                return;
            }

            $.ajax({
                type: "POST",
                url: "https://localhost:44364/api/associados/" + Id + "/empresa/" + IdEmpresa,
                contentType: "application/json; charset=utf-8",
                dataType: "json",                
                success: function (d) {
                    alert('Empresa vinculada com sucesso');
                    carregarEmpresas();

                },
                error: function (error) {
                    alert('Erro ao vincular empresa. ' + error.responseText);
                }
            });
        }


        function desvincularEmpresa(idEmpresa) {

            let Id = $("[id$=txtId]").val();           

            $.ajax({
                type: "DELETE",
                url: "https://localhost:44364/api/associados/" + Id + "/empresa/" + idEmpresa,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (d) {
                    alert('Empresa desvinculada com sucesso');
                    carregarEmpresas();

                },
                error: function (error) {
                    alert('Erro ao desvincular empresa. ' + error.responseText);
                }
            });
        }

        function carregarEmpresas() {

            let Id = $("[id$=txtId]").val();          

            $.getJSON("https://localhost:44364/api/associados/" + Id + "/empresas",
                function (data) {
                    $('#empresas').empty();
                    $.each(data, function (key, val) {

                        var row = '<td>' + val.Cnpj + '</td><td>' + val.Nome + '</td><td><input type="button" value="Desvincular" onclick="desvincularEmpresa(' + val.Id + ')">' + '</td>';
                        $('<tr/>', { html: row })
                            .appendTo($('#empresas'));
                    });
                });
        }        

        $(document).ready(function () {

            carregarEmpresas();
            
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
                    let nascimento = data.DataFormatada;
                    $("#txtDataNascimento").val(nascimento);

                },
                error: function (error) {
                    alert('Erro:' + error);
                }
            });         

            


        });
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
        <div>
            <h2>Editar Associado</h2>
            <div>
                <label>Id</label> 
                <br />
               <asp:TextBox ReadOnly="true" ID="txtId" runat="server" />
            </div>
            <div>
                <label>Nome</label>
                   <br />
                <asp:TextBox ID="txtNome" runat="server" />
            </div>
            <div>
                <label>CPF</label>
                   <br />
                <asp:TextBox ID="txtCpf" runat="server" MaxLength="11" onkeypress="return somenteNumeros(event)" />
            </div>
            <div>
                <label>Data de Nascimento</label>
                   <br />
                <input type="date" id="txtDataNascimento" />             
            </div>
            <br />
            <div>
                <input type="Button" onclick="salvarAssociado();" value="Salvar" />               
            </div>
        </div> 

        <hr />

        <div>
            <h2>Empresas</h2>
            <div>
                <select id="ddlEmpresas"></select>     
                <input type="Button" id="btnAssociarEmpresa" onclick="vincularEmpresa();" value="Vincular Empresa" /> 
                
            </div>
            <hr />          
            <div>
                <table style="width:70%;">
                    <thead>
                        <tr>                            
                            <th>CNPJ</th>
                            <th>Nome Empresa</th>  
                            <th>Ação</th>
                         </tr>
                    </thead>
                    <tbody id="empresas">
                    </tbody>
                </table>
            </div>

        </div>

</asp:Content>
