<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmpresaEditar.aspx.cs" Inherits="TestPortfolioApp.EmpresaEditar" %>

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
                Id: $("[id$=txtId]").val(),
                Nome: $("[id$=txtNome]").val(),
                Cnpj: $("[id$=txtCnpj]").val()                

            };

            if (associadoForm.Id == '' || associadoForm.Nome == '' || associadoForm.Cnpj.length < 14) {
                alert('Favor preencher todos os campos!');
                return;
            }


            $.ajax({
                type: "PUT",
                url: "https://localhost:44364/api/associados",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(empresaForm),
                success: function(d) {
                    alert('Dados da Empresa Alterado Com Sucesso');

                },
                error: function (error) {
                    alert('Erro ao alterar dados da Empresa:' + error.responseText);
                }
            });
        }

        function vincularAssociado() {

            let Id = $("[id$=txtId]").val();
            let IdAssociado = document.getElementById('ddlAssociados').value;

            if (IdAssociado == '' || IdAssociado == 'undefined') {
                alert('Nenhum Associado foi selecionado!');
                return;
            }

            $.ajax({
                type: "POST",
                url: "https://localhost:44364/api/empresas/" + Id + "/associado/" + IdAssociado,
                contentType: "application/json; charset=utf-8",
                dataType: "json",                
                success: function (d) {
                    alert('Associado vinculado com sucesso');
                    carregarAssociados();

                },
                error: function (error) {
                    alert('Erro ao vincular associado. ' + error.responseText);
                }
            });
        }

        function desvincularAssociado(idAssociado) {

            let Id = $("[id$=txtId]").val();
            

            $.ajax({
                type: "DELETE",
                url: "https://localhost:44364/api/empresas/" + Id + "/associado/" + idAssociado,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (d) {
                    alert('Associado desvinculado com sucesso');
                    carregarAssociados();

                },
                error: function (error) {
                    alert('Erro ao desvincular associado. ' + error.responseText);
                }
            });
        }

        function carregarAssociados() {

            let Id = $("[id$=txtId]").val();          

            $.getJSON("https://localhost:44364/api/empresas/" + Id + "/associados",
                function (data) {
                    $('#associados').empty();
                    $.each(data, function (key, val) {

                        var row = '<td>' + val.Cpf + '</td><td>' + val.Nome + '</td><td><input type="button" value="Desvincular" onclick="desvincularAssociado(' + val.Id + ')"></td>';
                        $('<tr/>', { html: row })
                            .appendTo($('#associados'));
                    });
                });
        }        

        $(document).ready(function () {

            carregarAssociados();
            
            $.ajax({
                type: "GET",
                url: "https://localhost:44364/api/associados",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    
                    $(data).each(function () {
                        $('#ddlAssociados').append($('<option/>', {value:this.Id}).html(this.Nome));
                    });               
                  
                },
                error: function (error) {
                   alert(error);
                }
            });

            $.ajax({
                type: "GET",
                url: "https://localhost:44364/api/empresas/" + $("[id$=txtId]").val(),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $("[id$=txtNome]").val(data.Nome);
                    $("[id$=txtCnpj]").val(data.Cnpj);                  

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
            <h2>Editar Empresa</h2>
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
                <label>CNPJ</label>
                   <br />
                <asp:TextBox ID="txtCnpj" runat="server" MaxLength="14" onkeypress="return somenteNumeros(event)" />
            </div>
            
            <br />
            <div>
                <input type="Button" onclick="salvarEmpresa();" value="Salvar" />               
            </div>
        </div> 

        <hr />

        <div>
            <h2>Associados</h2>
            <div>
                <select id="ddlAssociados"></select>     
                <input type="Button" id="btnVincularAssociado" onclick="vincularAssociado();" value="Vincular Associado" /> 
                
            </div>
            <hr />          
            <div>
                <table style="width:70%;">
                    <thead>
                        <tr>                            
                            <th>CPF</th>
                            <th>Nome Associado</th> 
                            <th>Ação</th>
                         </tr>
                    </thead>
                    <tbody id="associados">
                    </tbody>
                </table>
            </div>

        </div>

</asp:Content>
