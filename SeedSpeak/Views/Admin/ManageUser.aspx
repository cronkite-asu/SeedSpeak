<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Users
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
<style type="text/css">
        .employee-details ul
        {
            list-style:none;
            font-style:italic;
            margin-left:80px;
            margin-bottom: 20px;
        }
        .employee-details img
        {
            border: 1px solid #05679D;
            float:left;
        }
        
        .employee-details label
        {
            display:inline-block;
            width:90px;
            font-style:normal;
            font-weight:bold;
        }
        
        .employee-details span
        {
            display:inline-block;
            font-style:normal;
            font-weight:bold;
            color:Red;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function ConfirmChangePwd() {
            msg = "Are you sure, you want to assign new password to this user ?";
            return confirm(msg);
        }

        function ConfirmChangeStatus() {
            msg = "Are you sure, you want to change status of this user ?";
            return confirm(msg);
        }
    </script>
    <div id="fullpage_content">
        <h2>
            List of Members</h2>
        <div class="message">
            <%
                string ManageUser = "";
                if (ViewData["ManageUser"] != null)
                {
                    ManageUser = ViewData["ManageUser"].ToString();
                }%>
            <%= System.Web.HttpUtility.HtmlDecode(ManageUser)%>            
        </div>
        <div class="gridouter">
            <div class="grouping">
            </div>
            <% Html.Telerik().Grid<SeedSpeak.Model.Member>("MemberList")
           .Name("Grid")
           .Columns(columns =>
               {
                   columns.Template(mem =>
                   {
                       string imagePath = "../../Content/images/user.gif";
                       if (mem.MemberProfiles.FirstOrDefault() != null)
                       {
                           if (mem.MemberProfiles.FirstOrDefault().imagePath != null)
                           {
                               string img = mem.MemberProfiles.FirstOrDefault().imagePath.ToString();
                               img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                               if (System.IO.File.Exists(img))
                                   imagePath = mem.MemberProfiles.FirstOrDefault().imagePath.ToString();
                           }
                       }
            %>
            <img alt="<%= mem.id %>" src="<%= imagePath %>" width="50" height="50" />
            <%
                }).Title("Picture");
                   columns.Bound(mem => mem.username).Width(100).Title("User Name");
                   columns.Template(mem =>
                   {%>
            <a href="/Member/UserDetail/<%= mem.id %>">
                <%= mem.firstName + " " + mem.lastName%></a>
            <%
                }).Title("Name");
                   columns.Bound(mem => mem.status).Width(100).Title("Status");
                   columns.Bound(mem => mem.Seeds.ToList().Count).Width(100).Title("Seed Planted");
                   columns.Template(mem =>
                   { 
            %>
            <a href="/Admin/MailNewPassword/<%= mem.id %>" onclick="javascript:return ConfirmChangePwd();"
                style="margin-right: 10px;">Mail New Password</a> <b style="color: #4F8A10;">|</b>
            <% if (mem.status == SeedSpeak.Util.SystemStatements.STATUS_ACTIVE)
               { %>
            <a href="/Admin/ActiveInactiveMember/<%= mem.id %>" onclick="javascript:return ConfirmChangeStatus();"
                style="margin-left: 10px;">Deactivate</a>
            <%}
               else
               { %>
            <a href="/Admin/ActiveInactiveMember/<%= mem.id %>" onclick="javascript:return ConfirmChangeStatus();"
                style="margin-left: 10px;">Activate</a>
            <%} %>
            <% 
                }).Title("Action");
               })
               .DetailView(detailView => detailView.Template(e => { 
            %>
            <div class="employee-details">
                <%if (e.MemberProfiles.FirstOrDefault() != null)
                  { %>
                <img src="<%= Url.Content(e.MemberProfiles.FirstOrDefault().imagePath) %>" alt="<%= e.firstName + " " + e.lastName
                                            %>" />
                <ul>
                    <li>
                        <label>
                            Birth Date:</label>
                        <%=e.MemberProfiles.FirstOrDefault().dob!=null?
                        e.MemberProfiles.FirstOrDefault().dob.Value.ToString("d"):""%>
                    </li>
                    <li>
                        <label>
                            Country:</label>USA </li>
                    <li>
                        <label>
                            City:</label>
                        <%=e.MemberProfiles.FirstOrDefault().Location!=null? e.MemberProfiles.FirstOrDefault().Location.City.name:"" %>
                    </li>
                    <li>
                        <label>
                            Address:</label><%=e.MemberProfiles.FirstOrDefault().Location!=null? e.MemberProfiles.FirstOrDefault().Location.crossStreet:"" %>
                    </li>
                    <li>
                        <label>
                            Zipcode:</label><%=e.MemberProfiles.FirstOrDefault().Location!=null? e.MemberProfiles.FirstOrDefault().Location.zipcode:"" %>
                    </li>
                </ul>
                <%}
                  else
                  { %>
                  <span>
                No information found for this perticular user.</span>
                <%} %>
            </div>
            <%    
                }
                   ))
                   .RowAction(row =>
                   {
                       if (row.Index == 0)
                       {
                           row.DetailRow.Expanded = true;
                       }
                   })
           .Pageable()
            .Groupable()
           .Footer(true)
           .Render();
            %></div>
    </div>
</asp:Content>
