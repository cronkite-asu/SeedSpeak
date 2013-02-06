<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Password Recovery
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="head" runat="server">
    <style>
        .imglnk
        {
            display: none;
        }
        .title,#lnk 
        {
            display: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  
    <div class="pageheader">Password Recovery</div><br />
    <fieldset class="uploadbox">
    <div style="clear: both; width:950px; border-radius: 5px 5px 5px 5px; border: 4px solid rgb(224, 239, 253); background-color: rgb(224, 239, 253);">
    <div class="frmupload">
    <div style="margin:auto; height:75px; line-height:75px; font-size:14px; color:Red; text-align:center;">  
        <%: ViewData["Message"]%>
    </h5>  </div></div></fieldset>
</asp:Content>
