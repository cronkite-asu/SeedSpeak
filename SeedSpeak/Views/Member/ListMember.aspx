<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    ListMember
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div id="fullpage_content">   <div class="gridTB">
        <h2>
            List of Members</h2>
        <div class="gridcontainer">
            <div class="grouping">
            </div>
            <% Html.Telerik().Grid<SeedSpeak.Model.Member>("MemberList")
           .Name("Grid")
           .Columns(columns =>
               {
                   columns.Template(mem =>
                   {
                       if (mem.MemberProfiles.FirstOrDefault() != null)
                       {
            %>
            <img alt="<%= mem.id %>" src="<%= mem.MemberProfiles.FirstOrDefault().imagePath != null ? mem.MemberProfiles.FirstOrDefault().imagePath : "../../Content/images/user.gif" %>"
                width="50" height="50" />
            <% }
                       else
                       { 
            %>
            <img src="../../Content/images/user.gif" alt="" width="50" height="50" />
            <%
                }
                   }).Title("Picture");
                   columns.Bound(mem => mem.username).Width(100).Title("User Name");
                   columns.Template(mem =>
                   {
                       Response.Write(mem.firstName + " " + mem.lastName);
                   }).Title("Name");
                   columns.Bound(mem => mem.status).Width(100).Title("Status");
                   columns.Bound(mem => mem.Seeds.ToList().Count).Width(100).Title("Seed Planted");
                   columns.Template(mem =>
                   { 
            %>
            <a href="">Mail New Password</a><br />
            <% if (mem.status == SeedSpeak.Util.SystemStatements.STATUS_ACTIVE)
               { %>
            <a href="">Inactivate</a>
            <%}
               else
               { %>
            <a href="">Activate</a>
            <%} %>
            <% 
                }).Title("Action");
               })
           .Pageable()
           .Footer(true)
           .Render();
            %></div>
    </div></div>
</asp:Content>
