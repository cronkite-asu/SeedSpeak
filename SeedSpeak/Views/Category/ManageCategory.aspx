<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Category
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div id="fullpage_content">   <h2>
        Manage Category</h2>
       <% using (Html.BeginForm("ManageCategory", "Category", FormMethod.Post, new { id = "ManageCategory" }))
            {%>
    <p>
        <label for="ChildCategory">
            Child Category <em>*</em></label>
        <%= Html.ListBox("Category", (IEnumerable<SelectListItem>)ViewData["CategoryList"],ListSelectionMode.Single)%>
    </p>
    <p>
        <input id="btnSubmit" type="submit" value="submit" /></p>

        <%} %></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
