<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Discover Seed
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script src="../../Scripts/jquery.ui.core.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.ui.widget.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.ui.tabs.js" type="text/javascript"></script>
    <link href="../../Content/jquery.ui.core.css" rel="stylesheet" type="text/css" />
    <link href="../../Content/jquery.ui.tabs.css" rel="stylesheet" type="text/css" />
    <style>
        .fullwidthcol
        {
            margin: auto;
            width: 926px;
            margin-top: -4px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            var i = 0;
            var locations = document.getElementById('HiddenLocation').value.split(',');
            // Creating an option object for the map
            var options = {
                zoom:6,
                center: new google.maps.LatLng(locations[i], locations[i + 1]),
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            // Initializing the map
            var map = new google.maps.Map(document.getElementById('map_canvas'), options);
            
            while (i < locations.length) {
                // Creating a marker
                var seedName = locations[i + 2];
                
                var marker = new google.maps.Marker({
                    position: new google.maps.LatLng(locations[i], locations[i + 1]),
                    map: map,
                    icon: '../Content/images/small-seeds-icon.png',
                    title: seedName,
                    html: locations[i + 2]
                });
                var infowindow = new google.maps.InfoWindow(
                {
                    content: "Seed Content"
                });
                infowindow.setContent(this.html);
                infowindow.open(map, this);
                //});
                i += 3;
            }
        });
    </script>
    <script type="text/javascript">
        $(function () {
            $("#tabs").tabs();
        });
    </script>
    <script type="text/javascript">
        $('#tabs').bind('tabsshow', function (event, ui) {
            if (ui.panel.id == "map-tab") {
                resizeMap();
            }
        });
    </script>
    <div id="tabs">
        <% if (ViewData["ListSeed"] != null)
           { %>
        <div class="fillter">
            Sort By: <a href="/Seed/SortByCategory/">Category</a> <b>|</b> <a href="/Seed/SortByZipcode/">
                Zipcode</a> <b>|</b> <a href="/Seed/SortByKeyword/">Title</a>
        </div>
        <% } %>
        <ul>
            <li><a href="#tabs-1">Search Result</a></li>
            <li><a href="#tabs-2">View Map</a></li>
        </ul>
        <div id="tabs-1">
            <% string facebookLogin = (string)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.FacebookConnect); %>
            <div class="fullwidthcol">
                <h5 style="margin: auto; text-align: center;">
                    <%: ViewData["SearchMsg"]  %>
                </h5>
                <% if (ViewData["ListSeed"] != null)
                   { %>
                <div class="clear">
                </div>
                <% Html.Telerik().Grid<SeedSpeak.Model.Seed>("ListSeed")
           .Name("grdMySeeds")
           .Columns(columns =>
               {
                   columns.Template(c =>
                   {
                %>
                <h3 style="float: left; text-align: left">
                    <% if (!string.IsNullOrEmpty(facebookLogin))
                       { %>
                    <a href="/Seed/SeedDetailsFB/<%= c.id.ToString() %>">
                        <%=c.title%>
                    </a>
                    <%}
                       else
                       { %>
                    <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">
                        <%=c.title%>
                    </a>
                    <%} %>
                </h3>
                <div class="clear">
                </div>
                <div class="imgcontainer">
                    <small><a href="/Member/UserDetail/<%= c.Member.id %> ">
                        <% if (string.IsNullOrEmpty(c.Member.organisationName))
                           { %>
                        <%: c.Member.firstName + " " + c.Member.lastName%>
                        <%}
                           else
                           { %>
                        <%: c.Member.organisationName%>
                        <%} %>
                    </a></small>
                    <div class="clear">
                    </div>
                    <small>
                        <%
DateTime dtCreate = Convert.ToDateTime(c.createDate);
TimeSpan diff = DateTime.Now.Subtract(dtCreate);
Response.Write("Planted " + diff.Days.ToString() + " days ago");
                        %></small>
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
                    <div class="clear">
                    </div>
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
                %></div>
            <% } %>
        </div>
        <div id="tabs-2">
            <div class="mapcontainer" >
                <%: Html.Hidden("HiddenLocation", ViewData["LatLongCollection"])%>
        <div id="map_canvas" style="width: 700px; height: 650px; margin:20px auto auto auto; border: 1px solid #ccc"> 
                </div>
            </div>
        </div>
    </div>
</asp:Content>
