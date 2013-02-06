<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Request Category
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#RequestCategoryForm").validate({
                errorLabelContainer: $("ul", $('div.error-container')),
                wrapper: 'li',
                rules: {
                    CategoryName: {
                        required: true
                    }
                },
                messages: {
                    CategoryName: {
                        required: " You must specify category name"
                    }
                }
            });
        });
    </script>
    <div class="frmcontent">
        <% using (Html.BeginForm("RequestCategory", "Category", FormMethod.Post, new { id = "RequestCategoryForm" }))
           {%>
        <fieldset style="width: 96%; height: 350px;">
            <em style="float: right">Required</em><div class="clear">
            </div>
            <div class="error-container">
                <ul>
                </ul>
            </div>
            <div class="clear">
            </div>
            <legend>New Category Request</legend>            
            <label>
                Category Name <em></em>
                <%: Html.TextBox("CategoryName")  %>
            </label>
            <div style="float: left; margin-top: 30px;">
                <input type="submit" value="Request Category" class="gbtnxl" />
                <input type="button" value="Cancel" class="grbtn" onclick="window.location = '/Member/Dashboard';" /></div>
        </fieldset>
        <% } %>
    </div>
</asp:Content>
