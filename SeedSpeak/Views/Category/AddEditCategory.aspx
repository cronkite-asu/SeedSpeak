<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Category
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div id="fullpage_content">     <div class="gridouter"> <h2>
        Manage Category </h2>
             
        <%: ViewData["Action"] %>  <br />
        <%: ViewData["Result"] %>
        
        <%= Html.Telerik().Grid<SeedSpeak.Model.Category>("ListCategory")
        .Name("Grid")
        .DataKeys(keys => keys.Add(c => c.id))
        .ToolBar(commands => commands.Insert().ButtonType(GridButtonType.ImageAndText))
        .DataBinding(dataBinding => dataBinding.Server()
            .Insert("InsertCategory", "Category")
            .Update("EditCategory", "Category"))
        .Columns(columns =>
        {
            columns.Bound(p => p.name).Width(210);
            columns.Command(commands =>
            {
                commands.Edit().ButtonType(GridButtonType.ImageAndText);
            }).Width(180).Title("Commands");
        })
        .Editable(editing => editing.Mode(GridEditMode.InLine))
                    .Pageable()
                           
        .Sortable()
%></div> </div>
</asp:Content>
