<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Seed Response
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Seed Plant Response</h2>
     <div class="message"> <b>   <%
string msg="";
if (ViewData["SeedPlant"] != null)
{
    msg = ViewData["SeedPlant"].ToString();
}%></b>
<%= System.Web.HttpUtility.HtmlDecode(msg)%>
</div>
</asp:Content>
