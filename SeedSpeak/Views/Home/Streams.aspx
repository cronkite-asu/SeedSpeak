<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Streams
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">    
    <script type="text/javascript" language="javascript">
        function callNewStreamWindow() {
            var w = $('#CreateStreamFeedWindow').data('tWindow');
            w.center().open();
        }

        function callMiniStreamWindow() {
            var w = $('#CreateStreamMiniWindow').data('tWindow');
            w.center().open();
        }

        function switchStreams(id) {
            if (id == "showStream") {
                var w = $('#CreateStreamMiniWindow').data('tWindow');
                w.center().close();
                var w = $('#CreateStreamFeedWindow').data('tWindow');
                w.center().open();
            }

            if (id == "hideStream") {
                var w = $('#CreateStreamFeedWindow').data('tWindow');
                w.center().close();
                var w = $('#CreateStreamMiniWindow').data('tWindow');
                w.center().open();
            }
        }
    </script>
    <style type="text/css">        
        #gridbox td.t-last
        {
            border: 1px solid #D8D8D8;
            background-color: #fcfcfd;
        }
        #gridbox td.t-last:hover
        {
            border: 1px solid #D8D8D8;
            background-color: #edf6ef;
        }
        .streamfull .gridcontent_stream .content_container h3
        {
            color: #CC3300;
            font-size: 1.2em;
            text-align: left;
            width: 98%;
        }
        .streamfull .gridcontent_stream .content_container h3 a
        {
            padding-left: 5px;
        }
        .streamfull #gridbox .t-pager-wrapper
        {
            background: none;
        }
        .streamfull #gridbox .t-pager-wrapper .t-status-text
        {
            color: #6A686F;
        }
        .streamfull .gridcontent_stream .content_container .detail p
        {
            clear: both;
            color: #636363;
            font-size: 14px;
            margin-top: 0;
            padding: 24px 10px 6px 19px;
            position: relative;
            text-align: justify;
            width: 100%;
            word-wrap: break-word;
        }
        .streamfull .gridcontent_stream .content_container .detail
        {
            float: left;
            margin-left: 6px;
            width: 93%;
        }
        .streamfull .gridcontent_stream .content_container h3 small
        {
            color: #A4A5A2;
            display: inline;
            float: left;
            font-size: 12px;
            font-weight: normal;
            margin-top: 2px;
            padding-right: 4px;
            position: absolute;
            font-family: "Lucida Sans Unicode" , sans-serif;
        }
        .streamfull .gridcontent_stream .content_container h3 small b
        {
            color: #A4A5A2 !important;
            float: left;
            font-size: 12px;
            font-weight: normal;
            font-family: "Lucida Sans Unicode" , sans-serif;
            padding-left: 12px;
            padding-top: 10px;
        }
        .streamfull .gridcontent_stream .content_container h3 small a span
        {
            color: #0f597f !important;
            float: left;
            font-size: 12px;
            font-weight: bold;
            margin-left: 0;
            padding-left: 0;
            padding-right: 4px;
            padding-top: 10px;
        }
        .streamfull .gridcontent_stream .content_container h3 small a img
        {
            border: 0 none !important;
            float: left !important;
            padding: 0 7px 4px !important;
            position: relative !important;
            top: -2px !important;
        }
        .streamfull .gridcontent_stream .content_container h3 a abbr
        {
            color: #0f597f;
            cursor: pointer;
            float: left;
            font-size: 20px;
            font-weight: bold;
            margin: 0 0 0 9px;
            padding: 10px 0 0;
            position: relative;
            text-align: left;
            font-family: "Lucida Grande" , "Lucida Sans Unicode" , sans-serif;
            word-wrap: break-word;
        }
        .map-bdr
        {
            width: 249px;
            margin-top: 2px;
            height: 286px;
            background-image: url('../../Content/images/map-bdr-bg.png') !important;
            background-repeat: no-repeat;
            z-index: 99999px;
        }
        
        .clsFollow
        {
            width: 80px;
            background-image: url('images/Tbtnfol.png');
            background-repeat: no-repeat;
            background-position: 0px 0px;
            height: 30px;
            color: #fff;
            background-color: transparent;
            position: relative;
            border: 0px solid #000;
            font-size: 16px;
        }
        .clsMute
        {
            width: 80px;
            background-image: url('images/Tbtnmute.png');
            background-repeat: no-repeat;
            background-position: 0px 0px;
            height: 30px;
            color: #fff;
            font-size: 16px;
            background-color: transparent;
            position: relative;
            border: 0px solid #000;
        }
        .middle_link
        {
            color: #0F597F;
            margin-bottom: 5px;
        }
        .middle_link a:link
        {
            color: #0F597F;
            margin-bottom: 5px;
        }
        .middle_link a:hover { text-decoration:none;}
    </style>
    <link href="../../Content/subpages.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="streamsContent" ContentPlaceHolderID="subpageContainer" runat="server">
    <table>
        <tr>
            <td class="pageheader">
                Feeds
            </td>
        </tr>
        <tr>
            <td class="commontxt">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit cras nulla lorem ipsum consectetur
                adipiscing.
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
        </tr>
    </table>
    <div class="clear">
    </div>
    <div class="subpgtext">
        <div class="stream_searchbar">
            <%using (Html.BeginForm("Streams", "Home", FormMethod.Post, new { enctype = "multipart/form-data", id = "streamForm" }))
              {%>
            <div class="searchbar">
                <span></span>
                <input type="text" id="streamSearch" name="streamSearch" class="waterMark" title="SEARCH ALL FEEDS BY: Title, description, location, etc." />
                <input type="submit" value="" class="go1" style="float: none;" />
                <input type="button" value="" class="reset" onclick="window.location = '/Home/Streams';" />
            </div>
            <div style="padding: 0px;">
                <%} %>
                <% 
                    SeedSpeak.Model.Member mData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
                    if (mData != null)
                    { %>
                <div style="padding-top: 15px;">
                    <a style="cursor: pointer;" onclick="javascript:callNewStreamWindow();"><span class="middle_link">
                        Create a Feed</span></a> | <a style="cursor: pointer;" onclick="javascript:callMiniStreamWindow();">
                            <span class="middle_link">Create a List</span></a> | <a style="cursor: pointer;"
                                href="/SeedStream/ManageMyFeeds"><span class="middle_link">Manage My Feeds</span></a>
                </div>
                <%}
                    else
                    { %>
                <div style="padding-top: 15px;">
                    <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);"><span
                        class="middle_link">Create a Feed</span></a> | <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                            <span class="middle_link">Create a List</span></a>
                </div>
                <%} %>
            </div>
        </div>
        <div class="clear">
        </div>
        <table style="width: 100%">
            <tr>
                <td valign="top">
                    <div class="tabgridcontent">
                        <% Html.Telerik().TabStrip().Name("StreamsTab")
                               .Items(tabstrip =>
                               {
                                   tabstrip.Add().Text("Nearby")
                                       .Content(() =>
                                       {
                        %>
                        <div class="desc">Nearby feeds matching your search: <%=ViewData["SearchTerm"]%></div>
                        <div class="streamfull">
                            <% 
                                           if (ViewData["SearchStream"] != null)
                                           {
                                               IList<SeedSpeak.Model.ssStream> objssStream = (List<SeedSpeak.Model.ssStream>)ViewData["SearchStream"];
                                               if (objssStream.Count > 0)
                                               {
                                                   Html.Telerik().Grid<SeedSpeak.Model.ssStream>("SearchStream")
                                                  .Name("gridbox")
                                                  .Columns(columns =>
                                                      {
                                                          columns.Template(c =>
                                                          {
                            %>
                            <div class="gridcontent_stream">
                                <h3>
                                    <%if (mData != null)
                                      { %>
                                    <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">
                                        <abbr>
                                            <%=c.title%></abbr></a>
                                    <%}
                                      else
                                      { %>
                                    <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                        <abbr>
                                            <%=c.title%></abbr></a>
                                    <%} %><br />
                                    <small>
                                        <% string imagePath = "../../Content/images/user.gif";
                                           if (c.Member.MemberProfiles.FirstOrDefault() != null)
                                           {
                                               if (c.Member.MemberProfiles.FirstOrDefault().imagePath != null)
                                               {
                                                   string img = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                                   img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                                                   if (System.IO.File.Exists(img))
                                                       imagePath = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                               }
                                           }
                                        %>
                                        <% string dispName = string.Empty;
                                           if (string.IsNullOrEmpty(c.Member.organisationName))
                                               dispName = c.Member.firstName + " " + c.Member.lastName;
                                           else
                                               dispName = c.Member.organisationName;            
                                        %>
                                        <%if (mData != null)
                                          { %>
                                        <a href="/Member/UserDetail/<%= c.Member.id %>">
                                            <img alt="User Image" src="<%= imagePath %>" width="40" height="40" style="position: relative;
                                                top: -2px; float: left; padding: 3px; border: 0px; padding-top: 0px" /></a>
                                        <a href="/Member/UserDetail/<%= c.Member.id %>"><span>
                                            <%= dispName%></span></a>
                                        <%}
                                          else
                                          { %>
                                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                            <img alt="User Image" src="<%= imagePath %>" width="40" height="40" style="position: relative;
                                                top: -2px; float: left; padding: 3px; border: 0px; padding-top: 0px" /></a>
                                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);"><span>
                                            <%= dispName%></span></a>
                                        <%} %>
                                        <b>on
                                            <% DateTime dt = Convert.ToDateTime(c.createDate);
                                            %>
                                            <%: dt.ToShortDateString()%></b></small>
                                </h3>
                                <div class="clear">
                                </div>
                                <div class="detail">
                                    <p>
                                        <% 
                                               string subString = "";
                                               if (c.description.Length > 250)
                                               {
                                                   subString = c.description.Substring(0, 250);
                                                   Response.Write(subString); %>
                                        <%if (mData != null)
                                          {%>
                                        <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">...more</a>
                                        <%}
                                          else
                                          { %>
                                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">...more</a>
                                        <%} %>
                                        <%}
                                           else
                                           {
                                               subString = c.description.ToString();
                                               Response.Write(subString);
                                           }
                                        %></p>
                                </div>
                            </div>
                            <%}).Title("Seeds");
                                       })                                        
      .Footer(true)
      .Render();
                                }
                                else
                                {
                                    Response.Write("No streams found for your criteria");
                                }
                            }
                            %>
                        </div>
                        <% 
                                       });
                                   tabstrip.Add().Text("Latest")
                                       .Content(() =>
                                       {
                        %>
                        <div class="desc">Latest feeds matching your search: Latest Feeds</div>
                        <div class="streamfull">
                            <% 
                                           if (ViewData["LatestStreams"] != null)
                                           {
                                               IList<SeedSpeak.Model.ssStream> objLatestStream = (List<SeedSpeak.Model.ssStream>)ViewData["SearchStream"];
                                               if (objLatestStream.Count > 0)
                                               {
                                                   Html.Telerik().Grid<SeedSpeak.Model.ssStream>("LatestStreams")
                                                  .Name("gridboxLatest")
                                                  .Columns(columns =>
                                                      {
                                                          columns.Template(c =>
                                                          {
                            %>
                            <div class="gridcontent_stream">
                                <h3>
                                    <%if (mData != null)
                                      { %>
                                    <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">
                                        <abbr>
                                            <%=c.title%></abbr></a>
                                    <%}
                                      else
                                      { %>
                                    <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                        <abbr>
                                            <%=c.title%></abbr></a>
                                    <%} %><br />
                                    <small>
                                        <% string imagePath = "../../Content/images/user.gif";
                                           if (c.Member.MemberProfiles.FirstOrDefault() != null)
                                           {
                                               if (c.Member.MemberProfiles.FirstOrDefault().imagePath != null)
                                               {
                                                   string img = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                                   img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                                                   if (System.IO.File.Exists(img))
                                                       imagePath = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                               }
                                           }
                                        %>
                                        <% string dispName = string.Empty;
                                           if (string.IsNullOrEmpty(c.Member.organisationName))
                                               dispName = c.Member.firstName + " " + c.Member.lastName;
                                           else
                                               dispName = c.Member.organisationName;            
                                        %>
                                        <%if (mData != null)
                                          { %>
                                        <a href="/Member/UserDetail/<%= c.Member.id %>">
                                            <img alt="User Image" src="<%= imagePath %>" width="40" height="40" style="position: relative;
                                                top: -2px; float: left; padding: 3px; border: 0px; padding-top: 0px" /></a>
                                        <a href="/Member/UserDetail/<%= c.Member.id %>"><span>
                                            <%= dispName%></span></a>
                                        <%}
                                          else
                                          { %>
                                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                            <img alt="User Image" src="<%= imagePath %>" width="40" height="40" style="position: relative;
                                                top: -2px; float: left; padding: 3px; border: 0px; padding-top: 0px" /></a>
                                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);"><span>
                                            <%= dispName%></span></a>
                                        <%} %>
                                        <b>on
                                            <% DateTime dt = Convert.ToDateTime(c.createDate);
                                            %>
                                            <%: dt.ToShortDateString()%></b></small>
                                </h3>
                                <div class="clear">
                                </div>
                                <div class="detail">
                                    <p>
                                        <% 
                                               string subString = "";
                                               if (c.description.Length > 250)
                                               {
                                                   subString = c.description.Substring(0, 250);
                                                   Response.Write(subString); %>
                                        <%if (mData != null)
                                          {%>
                                        <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">...more</a>
                                        <%}
                                          else
                                          { %>
                                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">...more</a>
                                        <%} %>
                                        <%}
                                           else
                                           {
                                               subString = c.description.ToString();
                                               Response.Write(subString);
                                           }
                                        %></p>
                                </div>
                            </div>
                            <%}).Title("Seeds");
                                       })
      .Footer(true)
      .Render();
                                }
                                else
                                {
                                    Response.Write("No latest streams found");
                                }
                            }
                            %>
                        </div>
                        <%
                                       });
                                   tabstrip.Add().Text("Most Popular")
                                       .Content(() =>
                                       {
                        %>
                        <div class="desc">Popular feeds matching your search: Most Popular Feeds</div>
                        <div class="streamfull">
                            <% 
                                           if (ViewData["MostPopular"] != null)
                                           {
                                               IList<SeedSpeak.Model.ssStream> objLatestStream = (List<SeedSpeak.Model.ssStream>)ViewData["MostPopular"];
                                               if (objLatestStream.Count > 0)
                                               {
                                                   Html.Telerik().Grid<SeedSpeak.Model.ssStream>("MostPopular")
                                                  .Name("gridboxPopular")
                                                  .Columns(columns =>
                                                      {
                                                          columns.Template(c =>
                                                          {
                            %>
                            <div class="gridcontent_stream">
                                <h3>
                                    <%if (mData != null)
                                      { %>
                                    <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">
                                        <abbr>
                                            <%=c.title%></abbr></a>
                                    <%}
                                      else
                                      { %>
                                    <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                        <abbr>
                                            <%=c.title%></abbr></a>
                                    <%} %><br />
                                    <small>
                                        <% string imagePath = "../../Content/images/user.gif";
                                           if (c.Member.MemberProfiles.FirstOrDefault() != null)
                                           {
                                               if (c.Member.MemberProfiles.FirstOrDefault().imagePath != null)
                                               {
                                                   string img = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                                   img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                                                   if (System.IO.File.Exists(img))
                                                       imagePath = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                               }
                                           }
                                        %>
                                        <% string dispName = string.Empty;
                                           if (string.IsNullOrEmpty(c.Member.organisationName))
                                               dispName = c.Member.firstName + " " + c.Member.lastName;
                                           else
                                               dispName = c.Member.organisationName;            
                                        %>
                                        <%if (mData != null)
                                          { %>
                                        <a href="/Member/UserDetail/<%= c.Member.id %>">
                                            <img alt="User Image" src="<%= imagePath %>" width="40" height="40" style="position: relative;
                                                top: -2px; float: left; padding: 3px; border: 0px; padding-top: 0px" /></a>
                                        <a href="/Member/UserDetail/<%= c.Member.id %>"><span>
                                            <%= dispName%></span></a>
                                        <%}
                                          else
                                          { %>
                                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                            <img alt="User Image" src="<%= imagePath %>" width="40" height="40" style="position: relative;
                                                top: -2px; float: left; padding: 3px; border: 0px; padding-top: 0px" /></a>
                                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);"><span>
                                            <%= dispName%></span></a>
                                        <%} %>
                                        <b>on
                                            <% DateTime dt = Convert.ToDateTime(c.createDate);
                                            %>
                                            <%: dt.ToShortDateString()%></b></small>
                                </h3>
                                <div class="clear">
                                </div>
                                <div class="detail">
                                    <p>
                                        <% 
                                               string subString = "";
                                               if (c.description.Length > 250)
                                               {
                                                   subString = c.description.Substring(0, 250);
                                                   Response.Write(subString); %>
                                        <%if (mData != null)
                                          {%>
                                        <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">...more</a>
                                        <%}
                                          else
                                          { %>
                                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">...more</a>
                                        <%} %>
                                        <%}
                                           else
                                           {
                                               subString = c.description.ToString();
                                               Response.Write(subString);
                                           }
                                        %></p>
                                </div>
                            </div>
                            <%}).Title("Seeds");
                                       })
      .Footer(true)
      .Render();
                                }
                                else
                                {
                                    Response.Write("No latest streams found");
                                }
                            }
                            %>
                        </div>
                        <%
                                       });
                               }).SelectedIndex(0).Render();
                        %>
                    </div>
                </td>                
            </tr>
        </table>
    </div>
    <div>
        <% if (mData != null)
           { %>
        <% Html.RenderPartial("StreamFeed"); %>
        <% Html.RenderPartial("StreamMini"); %>
        <%} %>
    </div>
</asp:Content>
