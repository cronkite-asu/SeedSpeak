<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Admin Dashboard
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        .DB
        {
            display: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <div id="fullpage_content">   <h2>
        Admin Dashboard</h2>
    <fieldset style="width: 600px; margin: auto; padding: 10px;" >
        
      
   <ul class="addashboard">   <li>  <a href="../Admin/ManageUser">Manage User</a></li>
       
          <li> <a href="../Admin/ManageSeeds">Manage Seeds</a>
      
       </li>
       
          <li> <a href="../Admin/PolishContent">Police Content</a>
        
       </li>
       
          <li> <a href="../Admin/ManageContent">Manage Content</a>
        
      </li>
       
          <li>  <a href="../Category/AddEditCategory">Manage Category</a></li></ul> 
    </fieldset></div>
</asp:Content>
