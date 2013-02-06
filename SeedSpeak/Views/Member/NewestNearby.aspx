<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    NewestNearby
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="contentarea">
        <div class="stream-left-nav">
        <% string[] DashCount = (string[])SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.DashboardCount); %>
            <div id="navigation">
                <ul>
                    <li class="planNew"><a class="planNewWhite" href="/Member/NewSeed">Plant New</a></li>
                    <li class="common"><a href="/Member/Dashboard">My Seeds (<%=DashCount[0] %>)</a></li>
                    <li class="common"><a href="/SeedStream/ListFeeds">My Feeds/Lists (<%=DashCount[1] %>)</a></li>
                    <li class="common"><a href="/Member/People">My People (<%=DashCount[2] %>)</a></li>
                    <li class="navigation_buttom_white"><a href="/Member/NewestNearby">Newest Nearby (<%=DashCount[3] %>)</a></li>
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
                    <div id="uccontent" class="subpgtext">
                        <div class="ucwrapper">
                            <table width="100%">
                                <tr>
                                    <td class="pageheader">Newest Nearby</td>
                                </tr>
                                <tr>
                                    <td class="commontxt">View the latest Seeds near your current location.</td>
                                </tr>
                                 <tr>
                                    <td class="shade"></td>
                                </tr>
                                <tr>
                                    <td><table><tr class="commontxt">
                                            <td style="width:170px; font-size:15px">Showing seeds within</td>
                                            <td style="width:65px"> <% using (Html.BeginForm("NewestNearby", "Member", FormMethod.Post, new { id = "NewestNearbyForm", style="width:60px" }))
                                           { %>
                                           <%: Html.DropDownList("milesRadius", (SelectList)ViewData["NewestNearbyRange"])%>
                                           </td>
                                           <td style="font-size:15px">miles of current location
                                        <input id="btnNearbySubmit" type="submit" class="refreshimg" value="" />
                                        <input type="text" id="SeedsNoPerPage" name="SeedsNoPerPage" style="display:none;" />
                                        <input type="text" id="SortByExp" name="SortByExp" style="display:none;" />
                                        <%} %></td>
                                    </tr> </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    <%IList<SeedSpeak.Model.Seed> lst = (IList<SeedSpeak.Model.Seed>)ViewData["ListSeed"];
                                      if (lst.Count > 0)
                                      {
                                       %>
                                    <div id="sort">
                                        <table style="width:auto; margin-top:-2px">
                                            <tr>
                                                <td style="height:40px; vertical-align:middle">
                                                    <b>Sort:</b>
                                                </td>
                                                <td>
                                                    <a href="/Member/NewestNearby/Proximity">Proximity</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/NewestNearby/Date">Date</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/NewestNearby/Category">Category</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/NewestNearby/Likes">Likes</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/NewestNearby/Comments">Comments</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/NewestNearby/Replies">Seed Reply</a>
                                                </td>
                                            </tr>
                                        </table>
                                    </div><%} %>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    <% if (lst.Count > 0)
                                       { %>
                                        <% Html.RenderPartial("GridViewPartial", ViewData["ListSeed"]); %>
                                        <%}
                                       else
                                       {
                                           Response.Write("<div class='errpgmessage'>None of the seed found in this particular radius !</div>");
                                       }%>
                                    </td>
                                </tr>                                
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <!--content-rounded-top-->
            <div class="content-bottom">
            </div>
        </div>
        <!--content-->
    </div>
    <!--contentarea-->
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
</asp:Content>
