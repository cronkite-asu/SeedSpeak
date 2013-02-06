<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    About Us
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/subpages.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="aboutContent" ContentPlaceHolderID="subpageContainer" runat="server">

    <div class="breadcrum">
        <a href="/Member/Dashboard">Home</a><b>&nbsp;</b><a href="/Home/About">About Us</a></div>
    <div class="clear">
    </div>
    <div class="subpgtext">
        <%= System.Web.HttpUtility.HtmlDecode(ViewData["AboutContent"].ToString()) %>
    </div>
</asp:Content>
