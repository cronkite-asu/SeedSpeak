<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    PlantError
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="errpgmessage" style="display: none">
        <b>Error occured while seed plant</b>
        <div class="clear">
        </div>
        <span>
            <% if (ViewData["PlantError"] != null)
               { %>
            <%=ViewData["PlantError"].ToString()%>
            <%} %></span>
    </div>
    <% string viewDataMsg = ViewData["PlantError"].ToString();
       string[] errMsg = viewDataMsg.Split('#');
       string titleError = errMsg[0].ToString();
       string descError = errMsg[1].ToString();
    %>
    <div style="width: 300px; float: left; margin: 75px 0 0 150px">
        <img src="../../content/images/notfound.png" /></div>
    <div style="width: 350px; float: left; margin: 110px 0 0 75px">
        <h1 style="font-size: 25px; margin: 0 10px 35px 0">
            <%--Error heading goes to here--%>
            <%=titleError %>
        </h1>
        <p style="line-height: 20px; margin-bottom: 5px; color:Red;">
            <%--Reference site about Lorem Ipsum, giving information on its origins, as well as
            a random Lipsum generator.--%>
            <%=descError %>
        </p>
        <p style="padding-left: 70px;">
            <img src="../../content/images/exclamation.jpg" /></p>
        <p style="clear: both">
        </p>
        <p style="margin-top: 10px;">
            Click to go back to the <a style="text-decoration: underline" href="/Member/Default">
                Home Page</a></p>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
</asp:Content>
