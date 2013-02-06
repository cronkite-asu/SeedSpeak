<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Seeds
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script language="javascript" type="text/javascript">
        function verifyTerminate() {
            msg = "Are you sure, you want to terminate this seed ?";
            return confirm(msg);
        }

        function verifyUnFlag() {
            msg = "Are you sure, you want to unflag this seed ?";
            return confirm(msg);
        }

        function verifyHarvest() {
            msg = "Are you sure, you want to harvest this seed ?";
            return confirm(msg);
        }
    </script>
    <div id="fullpage_content">
        <div id="tabgridcontent">
            <h2>
                Manage Seeds</h2>
            <% Html.Telerik().TabStrip()
           .Name("ManageSeedsTab").Items(tabstrip =>
               {
                   tabstrip.Add().Text("Active Seeds")
                       .Content(() =>
                                   {%>
            <div class="fullwidthcol">
                <% List<SeedSpeak.Model.Seed> objASeed = (List<SeedSpeak.Model.Seed>)ViewData["ActiveSeeds"];
                   if (objASeed.Count > 0)
                   {
                       Html.Telerik().Grid<SeedSpeak.Model.Seed>("ActiveSeeds")
                       .Name("grdMySeeds")
                       .DataKeys(keys => keys.Add(mem => mem.id))
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
                        <a href="/Member/UserDetail/<%= c.Member.id %> ">
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
                        <span class="C" title="Commitments">
                            <%=c.Commitments.ToList().Count %>
                        </span><span class="Cm" title="Comments">
                            <%=c.Comments.ToList().Count %>
                        </span>
                        <div class="actionlinks">
                            <a href="/Seed/HarvestSeed/<%= c.id.ToString() %>" onclick="javascript:return verifyHarvest();">
                                Harvest</a> <b>|</b> <a href="/Seed/TerminateSeed/<%= c.id.ToString() %>" onclick="javascript:return verifyTerminate();">
                                    Delete</a>
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
            </div>
            <div class="clear">
            </div>
            <div class="norecordbg">
                <%
});
                           })
               .Pageable(paging => paging.PageSize(5))
               .Footer(true)
               .Render();
                   }
                   else
                   {
                       Response.Write("<br clear='both'>");
                       Response.Write("<h3>No Active Seeds Found</h3>");
                   }
                %></div>
            <%});
                   tabstrip.Add()
                       .Text("Flagged Seeds")
                       .Content(() =>
                       {%>
            <div class="fullwidthcol">
                <% List<SeedSpeak.Model.Seed> objFSeed = (List<SeedSpeak.Model.Seed>)ViewData["FlagSeeds"];
                   if (objFSeed.Count > 0)
                   {
                       Html.Telerik().Grid<SeedSpeak.Model.Seed>("FlagSeeds")
                          .Name("grdFlagSeeds")
                          .DataKeys(keys => keys.Add(mem => mem.id))
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
                        <a href="/Member/UserDetail/<%= c.Member.id %> ">
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
                    <b>Flags</b>
                    <div class="clear">
                    </div>
                    <p>
                        <% 
                            foreach (SeedSpeak.Model.Flag flg in c.Flags)
                            {
                        %>
                        <small>
                            <%: Html.Label(flg.Member.firstName + " " + flg.Member.lastName)%>
                            flagged this seed on
                            <%: Html.Label(Convert.ToDateTime(flg.dateFlagged).ToString("dd-MM-yyyy"))%></small>
                        <br />
                        <%= flg.reason %>
                        <a href="/Admin/unFlagSeed/<%=flg.id%>" onclick="javascript:return verifyUnFlag();">
                            Unflag</a>
                        <%
                            }
                        %>
                        <a href="/Admin/TerminateSeed/<%=c.id%>" onclick="javascript:return verifyTerminate();">
                            Terminate</a></p>
                    <div class="clear">
                    </div>
                    <div class="userInput">
                        <span class="L" title="Liked">
                            <%=c.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count %>
                        </span>                        
                        <span class="C" title="Commitments">
                            <%=c.Commitments.ToList().Count %>
                        </span><span class="Cm" title="Comments">
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
            </div>
            <div class="clear">
            </div>
            <div class="norecordbg">
                <%
});
                              })
               .Pageable(paging => paging.PageSize(5))
               .Footer(true)
               .Render();
                   }
                   else
                   {
                       Response.Write("<br clear='both'>");
                       Response.Write("<h3>No Flagged Seeds Found</h3>");
                   }
                %></div>
            <%});
                   tabstrip.Add()
             .Text("Dying Seeds")
             .Content(() =>
             {%>
            <div class="fullwidthcol">
                <% List<SeedSpeak.Model.Seed> objDSeed = (List<SeedSpeak.Model.Seed>)ViewData["DyingSeeds"];
                   if (objDSeed.Count > 0)
                   {
                       Html.Telerik().Grid<SeedSpeak.Model.Seed>("DyingSeeds")
                          .Name("grdDyingSeeds")
                          .DataKeys(keys => keys.Add(mem => mem.id))
                          .Columns(columns =>
                              {
                                  columns.Template(c =>
                                  {
                %>
                <h3 style="float: left; text-align: left">
                    <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">
                        <%=c.title%>
                    </a>
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
                        <a href="/Member/UserDetail/<%= c.Member.id %> ">
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
                        <span class="C" title="Commitments">
                            <%=c.Commitments.ToList().Count %>
                        </span><span class="Cm" title="Comments">
                            <%=c.Comments.ToList().Count %>
                        </span>
                    </div>
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
            <div class="clear">
            </div>
            <div class="norecordbg">
                <%
});
                              })
               .Pageable(paging => paging.PageSize(5))
               .Footer(true)
               .Render();
                   }
                   else
                   {
                       Response.Write("<br clear='both'>");
                       Response.Write("<h3>No Dying Seeds Found</h3>");
                   }
                %>
            </div>
            <%});
                   tabstrip.Add()
             .Text("Terminated Seeds")
             .Content(() =>
             {%>
            <div class="fullwidthcol">
                <% List<SeedSpeak.Model.Seed> objTSeed = (List<SeedSpeak.Model.Seed>)ViewData["TerminatedSeeds"];
                   if (objTSeed.Count > 0)
                   {
                       Html.Telerik().Grid<SeedSpeak.Model.Seed>("TerminatedSeeds")
                          .Name("grdTerminatedSeeds")
                          .DataKeys(keys => keys.Add(mem => mem.id))
                          .Columns(columns =>
                              {
                                  columns.Template(c =>
                                  {
                %></div>
            <h3 style="float: left; text-align: left; padding-left: 10px;">
                <%=c.title%>
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
                    <% if (string.IsNullOrEmpty(c.Member.organisationName))
                       { %>
                    <%: c.Member.firstName + " " + c.Member.lastName%>
                    <%}
                       else
                       { %>
                    <%: c.Member.organisationName%>
                    <%} %>
                </small>
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
                    <span class="C" title="Commitments">
                        <%=c.Commitments.ToList().Count %>
                    </span><span class="Cm" title="Comments">
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
            <div class="clear">
            </div>
            <div class="norecordbg">
                <%
});
                              })
               .Pageable(paging => paging.PageSize(5))
               .Footer(true)
               .Render();
                   }
                   else
                   {
                       Response.Write("<br clear='both'>");
                       Response.Write("<h3>No Terminated Seeds Found</h3>");
                   }
                %>
            </div>
            <%});
                   tabstrip.Add()
                       .Text("Harvested Seeds")
                       .Content(() =>
                           {
            %>
            <div class="fullwidthcol">
                <% List<SeedSpeak.Model.Seed> objHSeed = (List<SeedSpeak.Model.Seed>)ViewData["HarvestedSeeds"];
                   if (objHSeed.Count > 0)
                   {
                       Html.Telerik().Grid<SeedSpeak.Model.Seed>("HarvestedSeeds")
                          .Name("grdHarvestedSeeds")
                          .DataKeys(keys => keys.Add(mem => mem.id))
                          .Columns(columns =>
                              {
                                  columns.Template(c =>
                                  {
                %>
                <h3 style="float: left; text-align: left; padding-left: 10px;">
                    <%=c.title%>
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
                        <% if (string.IsNullOrEmpty(c.Member.organisationName))
                           { %>
                        <%: c.Member.firstName + " " + c.Member.lastName%>
                        <%}
                           else
                           { %>
                        <%: c.Member.organisationName%>
                        <%} %>
                    </small>
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
                        <span class="C" title="Commitments">
                            <%=c.Commitments.ToList().Count %>
                        </span><span class="Cm" title="Comments">
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
                <div class="clear">
                </div>
                <div class="norecordbg">
                    <%
});
                              })
               .Pageable(paging => paging.PageSize(5))
               .Footer(true)
               .Render();
                   }
                   else
                   {
                       Response.Write("<br clear='both'>");
                       Response.Write("<h3>No Harvested Seeds Found</h3>");
                   }
                    %>
                    <%
                        }
            );
               }).SelectedIndex(0).Render();
                    %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
