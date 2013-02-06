<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Seeds
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script language="javascript" type="text/javascript">
        function verifyHarvest() {
            msg = "Are you sure, you want to harvest this seed ?";
            return confirm(msg);
        }

        function verifyTerminate() {
            msg = "Are you sure, you want to terminate this seed ?";
            return confirm(msg);
        }
    </script>
    <div id="fullpage_content">
        <div id="tabgridcontent">            
                <br />
            <% Html.Telerik().TabStrip()
           .Name("ManageSeedsTab").Items(tabstrip =>
               {
                   tabstrip.Add().Text("Seeds I Planted")
                       .Content(() =>
                                   {%>
            <div class="fullwidthcol">
                <% List<SeedSpeak.Model.Seed> objSeed = (List<SeedSpeak.Model.Seed>)ViewData["ListSeed"];
                   if (objSeed.Count > 0)
                   {
                       Html.Telerik().Grid<SeedSpeak.Model.Seed>("ListSeed")
                       .Name("grdMySeeds")
                       .Columns(columns =>
                           {
                               columns.Template(c =>
                               {
                %>
                <h3 style="float: left; text-align: left">
                    <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">
                        <%=c.title%></a>
                </h3>
                <div class="clear">
                </div>
                <div class="imgcontainer">
                    <small>
                        <%
DateTime dtCreate = Convert.ToDateTime(c.createDate);
TimeSpan diff = DateTime.Now.Subtract(dtCreate);
Response.Write("Planted " + diff.Days.ToString() + " days ago");
                        %></small>
                    <div class="clear">
                    </div>
                    <% string seedImage = "";
                       if (c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).FirstOrDefault() != null)
                       {
                           string img = c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path.ToString();
                           img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                           if (System.IO.File.Exists(img))
                               seedImage = c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path.ToString();
                           else
                               seedImage = "../../Content/images/seedicon.png";
                       }
                       else
                       {
                           seedImage = "../../Content/images/seedicon.png";
                       }
                    %>
                    <img alt="Seed Image" src="<%= seedImage %>" />
                </div>
                <div class="detail">
                    <% string addrss = c.Location.City.name + ", " + c.Location.City.Region.code + " " + c.Location.zipcode + ", USA"; %>
                    <b>
                        <%: Html.Label(addrss)%></b>
                    <div class="clear">
                    </div>
                    <p>
                        <% 
string subString = "";
if (c.description.Length > 250)
{
    subString = c.description.Substring(0, 250);

    Response.Write(subString); %>&nbsp;&nbsp;<a href="/Seed/SeedDetails/<%= c.id.ToString() %>">...more</a>
                        <%}
else
{
    subString = c.description.ToString();
    Response.Write(subString);
}
                        %>
                    </p>
                    <div class="clear">
                    </div>
                    <b>Comments</b>
                    <div class="clear">
                    </div>
                    <p>
                        <% if (c.Comments.Count > 0)
                           {
                               string comm = c.Comments.OrderByDescending(x => x.commentDate).FirstOrDefault().msg;
                               string commString = "";
                               if (comm.Length > 250)
                               {
                                   commString = comm.Substring(0, 250);
                                   Response.Write(commString);%>
                        &nbsp;&nbsp;<a href="/Seed/SeedDetails/<%= c.id.ToString() %>">...more</a>
                        <%}
                           else
                           {
                               commString = comm.ToString();
                               Response.Write(commString);
                           }
                        %><br />
                        <abbr>
                            <%: Html.Label(Convert.ToDateTime(c.Comments.OrderByDescending(x => x.commentDate).FirstOrDefault().commentDate).ToString("dd-MM-yyyy"))%></abbr>
                        <%
                            }
                           else
                           {
                               Response.Write(" <h5>No Activity Yet. Be the first to start growing this!</h5>");
                           }
                        %>
                    </p>
                    <div class="clear">
                    </div>
                    <div class="userInput">
                        <span class="L" title="Liked">
                            <%=c.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count %>
                        </span>                        
                        <span class="Cm" title="Comments">
                        <%=c.Comments.ToList().Count %>
                        </span>
                        <div class="actionlinks">
                            <a href="/Seed/TerminateSeed/<%= c.id.ToString() %>" onclick="javascript:return verifyTerminate();">Delete</a>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="urec">
                        <% if (c.Categories.Count > 0)
                           { %>
                        <b>Categories :&nbsp;</b>
                        <% } %>
                        <% string catList = "";
                           foreach (SeedSpeak.Model.Category catData in c.Categories)
                           {
                               catList = catList + catData.name + ", ";
                           }
                           catList = catList.TrimEnd(',', ' ');
                        %>
                        <%: Html.Label(catList) %>
                        <br />
                        <% if (c.Tags.Count > 0 && c.Tags != null)
                           { %>
                        <b>Keywords : &nbsp;</b>
                        <%: Html.Label(c.Tags.FirstOrDefault().name != null ? c.Tags.FirstOrDefault().name : "")%>
                        <%} %>
                    </div>
                </div>
                <%
});
                       })
               .Pageable(paging => paging.PageSize(5))
               .Footer(true)
               .Render();
               }
               else
               {
                   Response.Write("<h5>No Matching Seeds Found</h5>");
               }
                %>
            </div>
            <%});
                   tabstrip.Add()
                       .Text("My Growing Seeds")
                       .Content(() =>
                       {%>
            <div class="fullwidthcol">
                <% List<SeedSpeak.Model.Seed> objSeed1 = (List<SeedSpeak.Model.Seed>)ViewData["GrowingSeeds"];
                   if (objSeed1.Count > 0)
                   {
                       Html.Telerik().Grid<SeedSpeak.Model.Seed>("GrowingSeeds")
        .Name("grdGrowingSeeds")
        .Columns(columns =>
           {
               columns.Template(c =>
               {
                %>
                <h3 style="float: left; text-align: left">
                    <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">
                        <%=c.title%></a>
                </h3>
                <div class="clear">
                </div>
                <div class="imgcontainer">
                    <small>
                        <%
DateTime dtCreate = Convert.ToDateTime(c.createDate);
TimeSpan diff = DateTime.Now.Subtract(dtCreate);
Response.Write("Planted " + diff.Days.ToString() + " days ago");
                        %></small>
                    <div class="clear">
                    </div>
                    <% string seedImage = "";
                       if (c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).FirstOrDefault() != null)
                       {
                           string img = c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path.ToString();
                           img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                           if (System.IO.File.Exists(img))
                               seedImage = c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path.ToString();
                           else
                               seedImage = "../../Content/images/seedicon.png";
                       }
                       else
                       {
                           seedImage = "../../Content/images/seedicon.png";
                       }
                    %>
                    <img alt="Seed Image" src="<%= seedImage %>" />
                </div>
                <div class="detail">
                    <% string addrss = c.Location.City.name + ", " + c.Location.City.Region.code + " " + c.Location.zipcode + ", USA"; %>
                    <b>
                        <%: Html.Label(addrss)%></b>
                    <p>
                        <% 
string subString = "";
if (c.description.Length > 250)
{
    subString = c.description.Substring(0, 250);
    Response.Write(subString); %>&nbsp;&nbsp;<a href="/Seed/SeedDetails/<%= c.id.ToString() %>">...more</a>
                        <%}
else
{
    subString = c.description.ToString();
    Response.Write(subString);
}
                        %>
                    </p>
                    <div class="clear">
                    </div>
                    <b>Comments</b>
                    <div class="clear">
                    </div>
                    <p>
                        <% if (c.Comments.Count > 0)
                           {
                               string comm = c.Comments.OrderByDescending(x => x.commentDate).FirstOrDefault().msg;
                               string commString = "";
                               if (comm.Length > 250)
                               {
                                   commString = comm.Substring(0, 250);
                                   Response.Write(commString);%>
                        &nbsp;&nbsp;<a href="/Seed/SeedDetails/<%= c.id.ToString() %>">...more</a>
                        <%}
                           else
                           {
                               commString = comm.ToString();
                               Response.Write(commString);
                           }
                        %>
                        <abbr>
                            <%: Html.Label(Convert.ToDateTime(c.Comments.OrderByDescending(x => x.commentDate).FirstOrDefault().commentDate).ToString("dd-MM-yyyy"))%></abbr>
                        <%
                            }
                           else
                           {
                               Response.Write("<h5>No Activity Yet. Be the first to start growing this!</h5>");
                           }
                        %>
                    </p>
                    <div class="clear">
                    </div>
                    <div class="userInput">
                        <span class="L" title="Liked">
                            <%=c.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count %>
                        </span>                        
                        <span class="Cm" title="Comments">
                            <%=c.Comments.ToList().Count %>
                        </span>
                    </div>
                    <div class="urec">
                        <% if (c.Categories.Count > 0)
                           { %>
                        <b>Categories :&nbsp;</b>
                        <% } %>
                        <% string catList = "";
                           foreach (SeedSpeak.Model.Category catData in c.Categories)
                           {
                               catList = catList + catData.name + ", ";
                           }
                           catList = catList.TrimEnd(',', ' ');
                        %>
                        <%: Html.Label(catList) %>
                        <br />
                        <% if (c.Tags.Count > 0 && c.Tags != null)
                           { %>
                        <b>Keywords : &nbsp;</b>
                        <%: Html.Label(c.Tags.FirstOrDefault().name != null ? c.Tags.FirstOrDefault().name : "")%>
                        <%} %>
                    </div>
                </div>
                <%
});
       })
.Pageable(paging => paging.PageSize(5))
.Footer(true)
.Render();
               }
               else
               {
                   Response.Write("<h5>No Matching Growing Seeds Found</h5>");
               }
                %>
            </div>
            <%});
                   tabstrip.Add()
                       .Text("Seeds I Like")
                       .Content(() =>
                       {%>
            <div class="fullwidthcol">
                <% List<SeedSpeak.Model.Seed> objSeed2 = (List<SeedSpeak.Model.Seed>)ViewData["FavoriteSeeds"];
                   if (objSeed2.Count > 0)
                   {
                       Html.Telerik().Grid<SeedSpeak.Model.Seed>("FavoriteSeeds")
        .Name("grdFavoriteSeeds")
        .Columns(columns =>
           {
               columns.Template(c =>
               {
                %>
                <h3 style="float: left; text-align: left">
                    <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">
                        <%=c.title%></a>
                </h3>
                <div class="clear">
                </div>
                <div class="imgcontainer">
                    <small>
                        <%
DateTime dtCreate = Convert.ToDateTime(c.createDate);
TimeSpan diff = DateTime.Now.Subtract(dtCreate);
Response.Write("Planted " + diff.Days.ToString() + " days ago");
                        %>
                        <br />
                        <a href="/Member/UserDetail/<%= c.Member.id %>">
                            <% if (string.IsNullOrEmpty(c.Member.organisationName))
                               { %>
                            <%: c.Member.firstName + " " + c.Member.lastName%>
                            <%}
                               else
                               { %>
                            <%: c.Member.organisationName%>
                            <%} %></a> </small>
                    <div class="clear">
                    </div>
                    <% string seedImage = "";
                       if (c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).FirstOrDefault() != null)
                       {
                           string img = c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path.ToString();
                           img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                           if (System.IO.File.Exists(img))
                               seedImage = c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path.ToString();
                           else
                               seedImage = "../../Content/images/seedicon.png";
                       }
                       else
                       {
                           seedImage = "../../Content/images/seedicon.png";
                       }
                    %>
                    <img alt="Seed Image" src="<%= seedImage %>" />
                </div>
                <div class="detail">
                    <% string addrss = c.Location.City.name + ", " + c.Location.City.Region.code + " " + c.Location.zipcode + ", USA"; %>
                    <b>
                        <%: Html.Label(addrss)%></b>
                    <p>
                        <% 
string subString = "";
if (c.description.Length > 250)
{
    subString = c.description.Substring(0, 250);

    Response.Write(subString); %>&nbsp;&nbsp;<a href="/Seed/SeedDetails/<%= c.id.ToString() %>">...more</a>
                        <%}
else
{
    subString = c.description.ToString();
    Response.Write(subString);
}
                        %>
                    </p>
                    <div class="clear">
                    </div>
                    <b>Comments</b>
                    <div class="clear">
                    </div>
                    <p>
                        <% if (c.Comments.Count > 0)
                           {
                               string comm = c.Comments.OrderByDescending(x => x.commentDate).FirstOrDefault().msg;
                               string commString = "";
                               if (comm.Length > 250)
                               {
                                   commString = comm.Substring(0, 250);
                                   Response.Write(commString);%>
                        &nbsp;&nbsp;<a href="/Seed/SeedDetails/<%= c.id.ToString() %>">...more</a>
                        <%}
                           else
                           {
                               commString = comm.ToString();
                               Response.Write(commString);
                           }
                        %>
                        <abbr>
                            <%: Html.Label(Convert.ToDateTime(c.Comments.OrderByDescending(x => x.commentDate).FirstOrDefault().commentDate).ToString("dd-MM-yyyy"))%></abbr>
                        <%
                            }
                           else
                           {
                               Response.Write("<h5>No Activity Yet. Be the first to start growing this!</h5>");
                           }
                        %>
                    </p>
                    <div class="clear">
                    </div>
                    <div class="userInput">
                        <span class="L" title="Liked">
                            <%=c.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count %>
                        </span>                        
                        <span class="Cm" title="Comments">
                            <%= c.Comments.ToList().Count %>
                        </span>
                    </div>
                    <div class="urec">
                        <% if (c.Categories.Count > 0)
                           { %>
                        <b>Categories :&nbsp;</b>
                        <% } %>
                        <% string catList = "";
                           foreach (SeedSpeak.Model.Category catData in c.Categories)
                           {
                               catList = catList + catData.name + ", ";
                           }
                           catList = catList.TrimEnd(',', ' ');
                        %>
                        <%: Html.Label(catList) %>
                        <br />
                        <% if (c.Tags.Count > 0 && c.Tags != null)
                           { %>
                        <b>Keywords : &nbsp;</b>
                        <%: Html.Label(c.Tags.FirstOrDefault().name != null ? c.Tags.FirstOrDefault().name : "")%>
                        <%} %>
                    </div>
                </div>
                <%
});
       })
.Pageable(paging => paging.PageSize(5))
.Footer(true)
.Render();
               }
               else
               {
                   Response.Write("<h5> No Matching Favorite Seeds Found</h5>");
               }
                %>
            </div>
            <%});  
               }).SelectedIndex(0).Render();
            %></div>
    </div>
</asp:Content>
