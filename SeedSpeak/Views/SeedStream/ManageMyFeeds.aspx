<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    ManageMyFeeds
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">    
    <script type="text/javascript">
        $(document).ready(function () {
            $(".btndelete").click(function () {
                var confirm_box = confirm('Are you sure you want to delete this feed ?');
                if (confirm_box) {
                    var grdBlock = $(this).parent().parent().get(0).id;
                    var deleteStreamid = grdBlock.replace("grdBlock", "");
                    $.getJSON("/SeedStream/TerminateSeedStream/?id=" + deleteStreamid, function (data) {
                        if (data.toString() != "") {
                            $("#" + grdBlock).parent().parent().parent().hide("slow");
                        }
                    });
                    $("#" + grdBlock).parent().parent().parent().hide("slow");
                }
            });
        });

        function ManageStreamWindow(id) {
            $.post("/SeedStream/ManageStream1/?streamId=" + id,
        function (data) {
            if (data.toString() != "") {
                var obj = jQuery.parseJSON(data);
                if (obj.ssType == "HandList") {
                    $('input[id=isEdit]').val("Yes");
                    $('input[id=StreamId]').val(obj.id);
                    var w = $('#CreateStreamMiniWindow').data('tWindow');
                    w.center().center().open();
                    $('#gTitle').val(obj.sstitle);
                    $('#gDesc').val(obj.ssDesc);
                    $("#parentDivStreamMini").empty();
                    getSelecteditemsStreamMini();
                    if (obj.ssCategories != "" && obj.ssCategories != null) {
                        var valCatg = obj.ssCategories.split(',');
                        var ci = 0;
                        for (ci = 0; ci < valCatg.length; ci++) {
                            BindinDivStreamMini1(valCatg[ci].toString());
                        }
                    }
                }

                if (obj.ssType == "Feed") {
                    $('input[id=isEdit]').val("Yes");
                    $('input[id=StreamId]').val(obj.id);
                    var w = $('#CreateStreamFeedWindow').data('tWindow');
                    w.center().center().open();
                    $('#gFeedTitle').val(obj.sstitle);
                    $('#gFeedDesc').val(obj.ssDesc);
                    $("#parentDivStreamFeed").empty();
                    getSelecteditemsStreamFeed();
                    if (obj.ssCategories != "" && obj.ssCategories != null) {
                        var valCatg = obj.ssCategories.split(',');
                        var ci = 0;
                        for (ci = 0; ci < valCatg.length; ci++) {
                            BindinDivStreamFeed1(valCatg[ci].toString());
                        }
                    }
                }
            }
        });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="contentarea">
        <div class="stream-left-nav">
        <% string[] DashCount = (string[])SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.DashboardCount); %>
            <div id="navigation">
                <ul>
                    <li class="planNew"><a class="planNewWhite" href="/Member/NewSeed">Plant New</a> </li>
                    <li class="common"><a href="/Member/Dashboard">My Seeds (<%=DashCount[0] %>)</a> </li>
                    <li class="curr"><a href="/SeedStream/ListFeeds">My Feeds/Lists (<%=DashCount[1] %>)</a> </li>
                    <li class="common"><a href="/Member/People">My People (<%=DashCount[2] %>)</a></li>
                    <li class="navigation_buttom"><a href="/Member/NewestNearby">Newest Nearby (<%=DashCount[3] %>)</a></li>
                </ul>
            </div>
            <div style="clear: both;">
            </div>
        </div>
        <!--navigation-->
        <div id="midcontent">
            <div class="content-rounded-top">
            </div>
            <!--content-rounded-top-->
            <div class="content-mid-bg">
                <div class="containerTbs">
                    <div>
                        <table width="100%">
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td class="pageheader">
                                                Manage My Feeds
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="commontxt">
                                                Manage your existing feeds and lists.
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="middle_link" style="font-size: 15px">
                                    <%: Html.ActionLink("View my feeds", "ListFeeds", "SeedStream")%>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <% Html.Telerik().TabStrip()
           .Name("FeedsTab").Items(tabstrip =>
               {
                   tabstrip.Add().Text("Feeds")
                       .Content(() =>
                                   {%>
                                    <div>
                                    <%if (ViewData["MyFeeds"] != null)
                                      {
                                          IList<SeedSpeak.Model.ssStream> objLatestStream = (List<SeedSpeak.Model.ssStream>)ViewData["MyFeeds"];
                                          if (objLatestStream.Count > 0)
                                          { %>
                                      <table width="100%">
                                            <tr>
                                                <td>
                                                    <div id="sort">
                                                        <table style="width: auto; margin-top: -1px">
                                                            <tr>
                                                                <td style="height: 40px; vertical-align: middle">
                                                                    <b>Sort:</b>
                                                                </td>
                                                                <td>
                                                                    <a href="/SeedStream/ManageMyFeeds/Date">Date</a>
                                                                </td>
                                                                <td>
                                                                    <a href="/SeedStream/ManageMyFeeds/MostActivity">Most Activity</a>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <% 
                                               Html.Telerik().Grid<SeedSpeak.Model.ssStream>("MyFeeds")
                                              .Name("ManageMyFeeds")
                                              .Columns(columns =>
                                                  {
                                                      columns.Template(c =>
                                                      {
                                                    %>
                                                    <div class="gridcontent_stream" id="grdBlock<%=c.id.ToString()%>">
                                                        <h3>
                                                            <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">
                                                                <abbr>
                                                                    <%=c.title%></abbr></a>
                                                            <br />
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
                                                                <a href="/Member/UserDetail/<%= c.Member.id %>">
                                                                    <img alt="User Image" src="<%= imagePath %>" width="40" height="40" style="position: relative;
                                                                        top: -2px; float: left; padding: 3px; border: 0px; padding-top: 0px" /></a>
                                                                <a href="/Member/UserDetail/<%= c.Member.id %>"><span>
                                                                    <%= dispName%></span></a> <b>on
                                                                        <% DateTime dt = Convert.ToDateTime(c.createDate);
                                                                        %>
                                                                        <%: dt.ToShortDateString()%></b></small>
                                                        </h3>
                                                        <div class="rightbtn">
                                                            <a style="cursor: pointer;" title="Edit" class="btnedit" onclick="javascript:ManageStreamWindow('<%=c.id.ToString() %>');"></a><a style="cursor: pointer;"
                                                                title="Delete" class="btndelete"></a>
                                                        </div>
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
                                                                <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">...more</a>
                                                                <%}
else
{
    subString = c.description.ToString();
    Response.Write(subString);
}
                                                                %></p>
                                                        </div>
                                                    <div style="clear: both;"></div>
                                                    </div><span class="shades" ></span>
                                                    <%}).Title("Feeds");
                                                  })
                       .Pageable(paging => paging.PageSize(5))
      .Footer(true)
      .Render();%>
                                                </td>
                                            </tr>
                                        </table>
                                        <%}
                                          else
                                          {
                                              Response.Write("<div class='errpgmessage'>No feeds found</div>");
                                          }
                                      } %>
                                    </div>
                                    <%});
                   tabstrip.Add()
                       .Text("Lists")
                       .Content(() =>
                       {%>
                                    <div>
                                    <%if (ViewData["MyLists"] != null)
                                      {
                                          IList<SeedSpeak.Model.ssStream> objListFeeds = (List<SeedSpeak.Model.ssStream>)ViewData["MyLists"];
                                          if (objListFeeds.Count > 0)
                                          { %>
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <div class="sort">
                                                        <table style="width: auto; margin-top: -1px">
                                                            <tr>
                                                                <td style="height: 40px; vertical-align: middle">
                                                                    <b>Sort:</b>
                                                                </td>
                                                                <td>
                                                                    <a href="/SeedStream/ManageMyFeeds/Date1">Date</a>
                                                                </td>
                                                                <td>
                                                                    <a href="/SeedStream/ManageMyFeeds/MostActivity1">Most Activity</a>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <% 
                                   Html.Telerik().Grid<SeedSpeak.Model.ssStream>("MyLists")
                                  .Name("ManageMyLists")
                                  .Columns(columns =>
                                      {
                                          columns.Template(c =>
                                          {
                                                    %>
                                                    <div class="gridcontent_stream" id="grdBlock<%=c.id.ToString()%>">
                                                        <h3>
                                                            <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">
                                                                <abbr>
                                                                    <%=c.title%></abbr></a>
                                                            <br />
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
                                                                <a href="/Member/UserDetail/<%= c.Member.id %>">
                                                                    <img alt="User Image" src="<%= imagePath %>" width="40" height="40" style="position: relative;
                                                                        top: -2px; float: left; padding: 3px; border: 0px; padding-top: 0px" /></a>
                                                                <a href="/Member/UserDetail/<%= c.Member.id %>"><span>
                                                                    <%= dispName%></span></a> <b>on
                                                                        <% DateTime dt = Convert.ToDateTime(c.createDate);
                                                                        %>
                                                                        <%: dt.ToShortDateString()%></b></small>
                                                        </h3>
                                                        <div class="rightbtn">
                                                            <a style="cursor: pointer;" title="Edit" class="btnedit" onclick="javascript:ManageStreamWindow('<%=c.id.ToString() %>');"></a><a style="cursor: pointer;"
                                                                title="Delete" class="btndelete"></a>
                                                        </div>
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
                                                                <a href="/SeedStream/FeedDetails/<%= c.id.ToString() %>">...more</a>
                                                                <%}
else
{
    subString = c.description.ToString();
    Response.Write(subString);
}
                                                                %></p>
                                                        </div> <div style="clear: both;"></div>
                                                    </div><span class="shades" ></span>
                                                    <%}).Title("Feeds");
                                                  })
                       .Pageable(paging => paging.PageSize(5))
      .Footer(true)
      .Render(); %>
                                                </td>
                                            </tr>
                                        </table>
                                        <%}
                                          else
                                          {
                                              Response.Write("<div class='errpgmessage'>No lists found</div>");
                                          }
                                      } %>
                                    </div>
                                    <%});
               }).SelectedIndex(Convert.ToInt32(ViewData["ActiveTab"] != null ? ViewData["ActiveTab"].ToString() : "0")).Render();
                                    %>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <!--content-rounded-top-->
            <div class="content-bottom">
            </div>
        </div>
        <!--content-->
    </div>
    <div>
        <% Html.RenderPartial("StreamFeed"); %>
    </div>
    <div>
        <% Html.RenderPartial("StreamMini"); %>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
</asp:Content>
