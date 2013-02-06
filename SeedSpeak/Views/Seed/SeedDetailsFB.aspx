<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Seed Details
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/jquery.ui.core.css" rel="stylesheet" type="text/css" />
    <link href="../../Content/jquery.ui.datepicker.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .sitelink a span, .sitelink iframe a, .actiontoolBox span, .innerMiddle span, .innerMiddle a, .innerright li, .innerright a
        {
            color: #8a8e8b !important;
            filter: alpha(opacity=80);
            opacity: .8;
            cursor: default;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../../Scripts/jquery.ui.core.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.ui.widget.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.ui.datepicker.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.cycle.all.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.cycle.lite.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.cycle.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.slideshow').cycle({
                fx: 'fade' // choose your transition type, ex: fade, scrollUp, shuffle, etc...
            });
        });
    </script>
    <script type="text/javascript" language="javascript">
        $(function () {
            $("#divAddComment").click(function () {
                var valUser = $("#txtComment").attr("value");
                var valGrid = $("#grdSeedComments");
                var lblerr = document.getElementById('CmtErrMsg');

                if (valUser.length < 1) {
                    lblerr.innerHTML = "Please enter comment";
                }
                else {
                    $.getJSON("/Seed/AddSeedComment/?txtComment=" + $("#txtComment").attr("value") + "&Sid=" + $("#Sid").attr("value"),
                        function (data) {
                            if (data.toString() == "true") {
                                lblerr.innerHTML = "Comment Posted Successfully";
                            }
                            else {
                                lblerr.innerHTML = data.toString();
                            }
                        });
                }
            });
        });
    </script>
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            // Creating an option object for the map  
            var options = {
                zoom: 15,
                center: new google.maps.LatLng(document.getElementById('HiddenLat').value, document.getElementById('HiddenLong').value),
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            // Initializing the map  
            var map = new google.maps.Map(document.getElementById('map_canvas'), options);

            // Creating a marker 
            var marker = new google.maps.Marker({
                position: new google.maps.LatLng(document.getElementById('HiddenLat').value, document.getElementById('HiddenLong').value),
                map: map,
                icon: '../../Content/images/seedicon0.png',
                title: "",
                html: "asdfasdfA"
            });

            var infowindow = new google.maps.InfoWindow(
                {
                    content: "asdf"
                });
        });
    </script>
    <% SeedSpeak.Model.Seed SeedDtl = (SeedSpeak.Model.Seed)ViewData["SeedDetails"]; %>
    <div id="left_col">
        <div class="seedtool">
            <h2>
                &nbsp;</h2>
            <div class="actiontoolBox">
                <span id="SpanCommit">Commit</span><br />                
                <a><span id="addFav">Add to Favorite</span></a><br />
                <span id="FlagAnchor">Flag</span><br />
                <%if (SeedDtl.Ratings.Count > 0) %>
                <%{ %>
                <% if (SeedDtl.Ratings.FirstOrDefault().likes == "Like")  %>
                <%{ %>
                <a><span id="DislikeSeed">Dislike</span></a><br />
                <%}
                   else
                   {%>
                <a><span id="LSeed">Like</span></a><br />
                <%} %>
                <%}
                  else
                  {%>
                <a><span id="LikeSeed">Like</span></a><br />
                <%} %>
                <br />
                <em>Features available after sign up</em>
            </div>
            <span class="btmcurve"></span>
        </div>
    </div>
    <div>
        <div class="seedtitle">
            <div class="seedimgbox">
                <% 
                    string seedImage = "";
                    if (SeedDtl.Media.Where(x => x.type.Equals("Image")).FirstOrDefault() != null)
                        seedImage = SeedDtl.Media.Where(x => x.type.Equals("Image")).FirstOrDefault().path.ToString();

                    if (seedImage != "")
                    {
                %>
                <img alt="Seed Image" src="<%= seedImage %>" />
                <%}
                    else
                    {  %>
                <img alt="Seed Image" src="../../Content/images/seedicon.png" />
                <%} %>
                <h3>
                    <%: Html.Label(SeedDtl.title) %></h3>                
            </div>
        </div>
        <div id="page_content">
            <div class="innerMiddle">
                <div class="roundbox">
                    <div class="clear">
                    </div>
                    <% string addrss = SeedDtl.Location.City.name + ", " + SeedDtl.Location.City.Region.code + " " + SeedDtl.Location.zipcode + ", USA"; %>
                    <b>
                        <%: Html.Label(addrss)%></b>
                    <div class="clear">
                    </div>
                    <p class="textwrap">
                        <% Response.Write(SeedDtl.description); %>
                    </p>
                    <%: Html.Hidden("HiddenLat", SeedDtl.Location.localLat.ToString())%>
                    <%: Html.Hidden("HiddenLong",SeedDtl.Location.localLong.ToString()) %>
                    <br />
                    <% if (SeedDtl.Categories.Count > 0)
                       { %>
                    <b>Categories :&nbsp;</b>
                    <% } %>
                    <% string catList = "";
                       foreach (SeedSpeak.Model.Category catData in SeedDtl.Categories)
                       {
                           catList = catList + catData.name + ", ";
                       }
                       catList = catList.TrimEnd(',', ' ');
                    %>
                    <%: Html.Label(catList) %>
                    <br />
                    <% if (SeedDtl.Tags.Count > 0 && SeedDtl.Tags != null)
                       { %>
                    <b>Tags : &nbsp;</b>
                    <%: Html.Label(SeedDtl.Tags.FirstOrDefault().name != null ? SeedDtl.Tags.FirstOrDefault().name : "")%>
                    <%} %></div>
                <br />
                <% int commitmentCount = SeedDtl.Commitments.ToList().Count;
                    if(commitmentCount>0)
                    {
                     %>
                <div>
                <% IList<SeedSpeak.Model.Commitment> lstCommitments = SeedDtl.Commitments.ToList(); %>
                <div class="bluerounded">
                <h5>Commitments</h5>
                <% Html.Telerik().Grid<SeedSpeak.Model.Commitment>(lstCommitments)
           .Name("grdSeedCommitments")
           .Columns(columns =>
               {
                   string commenterImage = "";
                   columns.Template(c =>
                   {
                       if (c.Member.MemberProfiles.FirstOrDefault() != null)
                       {
                           string img = c.Member.MemberProfiles.FirstOrDefault().imagePath;
                           img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                           if (System.IO.File.Exists(img))
                               commenterImage = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                           else
                               commenterImage = "../../Content/images/user.gif";
                       }
                       else
                           commenterImage = "../../Content/images/user.gif";
                    %>
                    <img alt="Comment By" src="<%= commenterImage %>" width="50" height="50" />
                    <div style="float: left; width: 85%">
                        <b>
                            <% if (string.IsNullOrEmpty(c.Member.organisationName))
                               { %>
                            <a href="/Member/UserDetail/<%= c.Member.id %>">
                                <%: c.Member.firstName + " " + c.Member.lastName%></a>
                            <%}
                               else
                               { %><a href="/Member/UserDetail/<%= c.Member.id %>">
                                   <%: c.Member.organisationName%></a>
                            <%} %>
                        </b>
                        <div class="clear">
                        </div>
                        <p class="textwrap">
                            <%= c.msg %>
                        </p>
                        <div class="clear">
                        </div>
                        <b style="font-size: 11px">
                            <%
                                Response.Write(c.Member.firstName + " " + c.Member.lastName + " made this commitment on " + Convert.ToDateTime(c.commitDate).ToString("dd-MM-yyyy") + " and intends to complete this commitment by " + Convert.ToDateTime(c.deadline).ToString("dd-MM-yyyy"));
                            %>
                            </b></div>
                        <%
                            });
               })
           .Footer(false)
           .Render();
                        %>
                </div>
                </div>
                <%} %>
                <div class="bluerounded">
                    <h5>
                        <% 
                            List<SeedSpeak.Model.Comment> SeedComments = (List<SeedSpeak.Model.Comment>)ViewData["SeedComments"];
                            if (SeedDtl.Comments.ToList().Count > 5)
                            {
                                using (Html.BeginForm("SeedDetails", "Seed", FormMethod.Post, new { id = "SeedDetailForm" }))
                                {
                        %>
                        <%: Html.Hidden("DetailId",SeedDtl.id) %>
                        <%}
                        }%>
                        <% if (ViewData["ContributionAuth"] == "True")
                           { %>
                        <span id="SpanAddComment" style="cursor: pointer">Add Comment</span>
                        <%} %>
                    </h5>
                    <div class="clear">
                    </div>
                    <% Html.Telerik().Grid<SeedSpeak.Model.Comment>("SeedComments")
           .Name("grdSeedComments")
           .Columns(columns =>
               {
                   string commenterImage = "";
                   columns.Template(c =>
                   {
                       if (c.Member.MemberProfiles.FirstOrDefault() != null)
                       {
                           string img = c.Member.MemberProfiles.FirstOrDefault().imagePath;
                           img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                           if (System.IO.File.Exists(img))
                               commenterImage = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                           else
                               commenterImage = "../../Content/images/user.gif";
                       }
                       else
                           commenterImage = "../../Content/images/user.gif";
                    %>
                    <img alt="Comment By" src="<%= commenterImage %>" width="50" height="50" />
                    <p class="textwrap">
                        <b>
                            <% if (string.IsNullOrEmpty(c.Member.organisationName))
                               { %>
                            <a href="/Member/UserDetail/<%= c.Member.id %>">
                                <%: c.Member.firstName + " " + c.Member.lastName%></a>
                            <%}
                               else
                               { %><a href="/Member/UserDetail/<%= c.Member.id %>">
                               <%: c.Member.organisationName%></a>
                            <%} %>
                        </b>
                        <%= c.msg %>
                    </p>
                    <div class="clear">
                    </div>
                    <b>
                        <%
DateTime dtCreate = Convert.ToDateTime(c.commentDate);
TimeSpan diff = DateTime.Now.Subtract(dtCreate);
string result = "";
if (diff.Days > 0)
    result = diff.Days + " Days ";
if (diff.Hours > 0)
    result = result + diff.Hours + " Hours ";
result = result + diff.Minutes;
Response.Write(result + " minutes ago");
                        %></b>
                    <%
                        });
               })

           .Footer(false)

           .Render();
                    %></div>
            </div>
        </div>
        <div id="right_col">
            <div class="innerright">
                <h2 class="stats">
                    &nbsp;</h2>
                <div class="clear">
                </div>
                <ul>
                    <li class="grow">Seed Status :<b>
                        <% Response.Write(SeedDtl.status); %>
                    </b></li>
                    <li class="like"><b>
                        <% if (SeedDtl.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count > 0)
                           { %>
                        <span id="spanLikeCount" style="cursor: pointer;">
                            <%=SeedDtl.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count%>
                        </span>
                        <%}
                           else
                           { %>
                        <%=SeedDtl.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count%>
                        <%} %>
                    </b>Members like this seed. </li>                    
                    <li class="commited"><b>
                        <%if (SeedDtl.Commitments.ToList().Count > 0)
                          {%>
                        <span id="spanCommitmentCount" style="cursor: pointer;">
                            <%=SeedDtl.Commitments.ToList().Count%>
                        </span>
                        <%}
                          else
                          { %>
                        <%=SeedDtl.Commitments.ToList().Count%>
                        <%} %>
                    </b>Members committed to this seed.</li>
                    <li class="comment"><b>
                        <%= SeedDtl.Comments.ToList().Count %>
                    </b>Members commented on this seed. </li>
                </ul>
                <div class="clear">
                </div>
                <h2 class="Location">
                    &nbsp;</h2>
                <div class="clear">
                </div>
                <div class="mapouter">
                    <div id="map_canvas" class="location">
                    </div>
                </div>
                <h2 class="Video">
                    &nbsp;</h2>
                <div class="clear">
                </div>
                <div class="video">
                    <% IList<SeedSpeak.Model.Medium> objV = (List<SeedSpeak.Model.Medium>)ViewData["VList"];
                       if (objV.Count > 0)
                       {
                           foreach (SeedSpeak.Model.Medium w in (List<SeedSpeak.Model.Medium>)ViewData["VList"])
                           { %>
                    <object id="MediaPlayer" width="192" height="180" classid="CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95"
                        standby="Loading Windows Media Player components..." type="application/x-oleobject">
                        <param name="FileName" value="../<%= w.path %>" />
                        <param name="ShowControls" value="true" />
                        <param name="ShowStatusBar" value="false" />
                        <param name="ShowDisplay" value="false" />
                        <param name="autostart" value="false" />
                        <embed type="application/x-mplayer2" src="../<%= w.path %>" name="MediaPlayer" width="192"
                            height="180" showcontrols="1" showstatusbar="0" showdisplay="0" autostart="0"></embed>
                    </object>
                    <% }
                   }
                   else
                   {%>
                    <img alt="No content added yet!" src="../../Content/images/novideo.png" />
                    <%}
                    %>
                </div>
                <div class="pictool" style="border-bottom: 1px #c8d4db solid;">
                    <a>Add Video</a>&nbsp;<b>.</b>&nbsp;<a>View More </a>
                </div>
                <div class="clear">
                </div>
                <h2 class="Images">
                    &nbsp;
                </h2>
                <div class="clear">
                </div>
                <div class="uploadimgs">
                    <div class="slideshow">
                        <% IList<SeedSpeak.Model.Medium> objImg = (List<SeedSpeak.Model.Medium>)ViewData["MList"];
                           if (objImg.Count > 0)
                           {
                               foreach (SeedSpeak.Model.Medium w in (List<SeedSpeak.Model.Medium>)ViewData["MList"])
                               { %>
                        <img alt="Default Image" src="../<%= w.path %>" width="200" height="180" />
                        <% }
                       }
                       else
                       {%>
                        <img alt="No content added yet!" src="../../Content/images/noimage.png" />
                        <%} %>
                    </div>
                </div>
                <div class="clear">
                </div>
                <div class="pictool">
                    <a>Add Image</a>&nbsp;<b>.</b>&nbsp;<a>View More </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
