<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    How It Works
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/subpages.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
    <div class="breadcrum">
        <a href="/Member/Default">Home</a><b>&nbsp;</b><a href="/Home/HowItWorks">How It Works</a></div>
    <div class="clear">
    </div>
    <div class="subpgtext">
        <strong>How It Works</strong>
        <br />
        <br />
        <div class="clear">
        </div>
        <h3 style="margin: auto">
            coming soon !</h3>
    </div>
</asp:Content>
