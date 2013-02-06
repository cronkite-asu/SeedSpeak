<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    FeedDetails
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   <div id="fullbg"><span class="pageheader"><%: ViewData["FeedName"]%> </span> 
    <span class="seedDetail">Seeds # <%:ViewData["FeedSeedsCount"]%></span><br />
    <span class="commontxt"><%=ViewData["FeedDesc"]%></span><br />
    <% Html.RenderPartial("GridViewPartial", ViewData["ListSeed"]); %>
    </div> 
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
</asp:Content>
