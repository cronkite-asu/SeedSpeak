<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    WatchDemo
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/subpages.css" rel="stylesheet" type="text/css" />
  
</asp:Content>
<asp:Content ID="aboutContent" ContentPlaceHolderID="subpageContainer" runat="server">
     
   
    <div class="breadcrum">
        <a href="/Member/Dashboard">Home</a><b>&nbsp;</b><a href="/Home/WatchDemo">WatchDemo</a></div>
    <div class="clear">
    </div>
    <div class="subpgtext">
        <strong>Watch Demo</strong>
        <br />
        <br />  <div class="clear">
    </div>
   <h3 style="margin:auto">    Demo coming soon !</h3> 
    </div>
</asp:Content>
