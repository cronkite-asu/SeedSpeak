<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Content
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        .updatebox
        {
            margin-top: -7px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="tabgridcontent">
        <h2>
            Manage Content</h2>
        <div class="Admincontent">
            <% Html.Telerik().TabStrip()
           .Name("ManageContentTab").Items(tabstrip =>
               {
                   tabstrip.Add()
                       .Text("FAQ")
                       .Content(() =>
                       {%>
            <div class="updatebox">
                <h2>
                    FAQ
                </h2>
                <%=ViewData["Result"] %>
                <%= Html.Telerik().Grid<SeedSpeak.Model.Content>("FAQs")
                .Name("Grid")
                .DataKeys(keys => keys.Add(e => e.id))
                .DataBinding(dataBinding => dataBinding.Server()
                .Update("EditContent", "Admin"))
                          
                .Columns(columns =>
                {
                    columns.Bound(e => e.Value1).Width(250).Title("Question");
                    columns.Bound(e => e.Value2).Title("Answer");
                    columns.Command(commands =>
                    {
                        commands.Edit().ButtonType(GridButtonType.ImageAndText);
                    }).Title("Commands");
                })
                  .Editable(editing => editing.Mode(GridEditMode.InLine))
                  .Pageable()
                  .Sortable()
                %><br />
            </div>
            <%});
                   tabstrip.Add().Text("About Us")
                       .Content(() =>
                                   {%>
            <div class="updatebox">
                <div class="error-container-AboutUs">
                    <ul>
                    </ul>
                </div>
                <% Html.BeginForm("ManageContent", "Admin", FormMethod.Post, new { id = "AboutContentForm" }); %>
                <h2>
                    About Us</h2>
                <br />
                <% Html.Telerik().Editor()
           .Name("aboutText")

           .Tools(tools => tools
                                .Clear()
                                .Bold().Italic().Underline()
                                .Separator()
                                .CreateLink().Unlink()
                            )
           .Value(() =>
           { %>
                <%= ViewData["AboutUs"]!=null ? ViewData["AboutUs"].ToString() : "" %>
                <% })
               .Render();
                %>
                <br />
                <div class="btncontainer" style="width: 96%">
                    <input type="submit" value="Save" class="gbtn" /></div>
                <br />
                <% Html.EndForm(); %>
            </div>
            <%});

                   tabstrip.Add()
                       .Text("News")
                       .Content(() =>
                       {%>
            <div class="updatebox">
                <div class="error-container-News">
                    <ul>
                    </ul>
                </div>
                <% Html.BeginForm("ManageContent", "Admin", FormMethod.Post, new { id = "NewsContentForm" }); %>
                <h2>
                    News</h2>
                <br />
                <% Html.Telerik().Editor()
           .Name("newsText")

           .Tools(tools => tools
                                .Clear()
                                .Bold().Italic().Underline()
                                .Separator()
                                .CreateLink().Unlink()
                            )
           .Value(() =>
           { %>
                <%= ViewData["News"] != null ? ViewData["News"].ToString() : "" %>
                <% })
               .Render();
                %>
                <br />
                <div class="btncontainer" style="width: 96%">
                    <input type="submit" value="Save" class="gbtn" /></div>
                <br />
                <% Html.EndForm(); %>
            </div>
            <%});
                   tabstrip.Add()
                       .Text("Contact Info")
                       .Content(() =>
                       {%>
            <div class="updatebox">
                <div class="error-container-Contact">
                    <ul>
                    </ul>
                </div>
                <% Html.BeginForm("ManageContent", "Admin", FormMethod.Post, new { id = "ContactContentForm" }); %>
                <h2>
                    Contact info</h2>
                <br />
                <% Html.Telerik().Editor()
           .Name("contactText")

           .Tools(tools => tools
                                .Clear()
                                .Bold().Italic().Underline()
                                .Separator()
                                .CreateLink().Unlink()
                            )
           .Value(() =>
           { %>
                <%= ViewData["Contact"] != null ? ViewData["Contact"].ToString() : "" %>
                <% })
               .Render();
                %>
                <br />
                <div class="btncontainer" style="width: 96%">
                    <input type="submit" value="Save" class="gbtn" /></div>
                <% Html.EndForm(); %>
                <br />
            </div>
            <%});
               }).SelectedIndex(Convert.ToInt16(ViewData["index"])).Render();
            %>
        </div>
    </div>
</asp:Content>
