<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    People
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .errormssg
        {
            text-align: center;
            color: #800000;
            float: left;
            margin: auto;
            line-height: 2;
            width: 654px;
            margin-left: 10px;
            margin-top: 10px;
            margin-bottom: 4px;
            font-size: 13px;
            border: 0px solid #FF9999;
            background-color: #FFCCCC;
        }
        .t-tabstrip .t-content form{ padding:0}
    </style>    
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
                    <li class="curr"><a href="/Member/People">My People (<%=DashCount[2] %>)</a></li>
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
                    <table width="100%">
                        <tr>
                            <td class="pageheader">
                                My People
                            </td>
                        </tr>
                        <tr>
                            <td class="commontxt">
                                View the latest Seeds from users you are following.
                            </td>
                        </tr>
                        <tr>
                            <td class="shade">
                            </td>
                        </tr>
                        <tr>
                        </tr>
                    </table>
                    <% IList<SeedSpeak.Model.Member> members = (IList<SeedSpeak.Model.Member>)ViewData["Followers"];
                       IList<SeedSpeak.Model.Member> members1 = (IList<SeedSpeak.Model.Member>)ViewData["Following"];
                       IList<SeedSpeak.Model.Seed> seeds = (IList<SeedSpeak.Model.Seed>)ViewData["LatestActivity"];
                       var countQuery = from cntOwner in seeds
                                        select new { cntOwner.Member.id };
                       int seedCount = countQuery.Distinct().ToList().Count();
                       int followingCount = members1.Count();
                       int followersCount = members.Count(); %>
                    <% Html.Telerik().TabStrip()
           .Name("PeopleTab").Items(tabstrip =>
               {
                   tabstrip.Add().Text("Latest Activity")
                       .Content(() =>
                                   {%><div style="clear: both;">
                                   </div>
                    <% if (followingCount > 0)
                       { %>
                    <div id="sort">
                        <table>
                            <tr>
                                <td>
                                    <b>Sort:</b>
                                </td>
                                <td>
                                    <a href="/Member/People/Proximity">Proximity</a>
                                </td>
                                <td>
                                    <a href="/Member/People/Date">Date</a>
                                </td>
                                <td>
                                    <a href="/Member/People/Category">Category</a>
                                </td>
                                <td>
                                    <a href="/Member/People/Likes">Likes</a>
                                </td>
                                <td>
                                    <a href="/Member/People/Comments">Comments</a>
                                </td>
                                <td>
                                    <a href="/Member/People/SeedReply">Seed Replies</a>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <%}
                       else
                       {
                           Response.Write("<div class='errpgmessage'>You need to follow someone to get updates !</div>");
                       } %>
                    <div class="clear">
                    </div>
                    <div>
                        <% ViewData["ListSeed"] = ViewData["LatestActivity"]; %>
                        <% Html.RenderPartial("GridViewPartial", ViewData["ListSeed"]); %>
                    </div>
                    <%});
                   tabstrip.Add().Text("Following" + " (" + followingCount + ")")
                       .Content(() => { 
                           %>
                           <div class="clear">
                    </div>
                    <% if (followingCount > 0)
                       { %>
                    <div class="fullwidthcol">
                        <% Html.Telerik().Grid<SeedSpeak.Model.Member>("Following")
           .Name("grdFollowing")
           .Columns(columns =>
               {
                   columns.Template(c =>
                   {
                        %>
                        <table border="0" width="100%;">
                            <tr valign="top">
                                <td rowspan="2" valign="top" style="width: 10%;">
                                    <% string profilePic = "../../Content/images/user-icon.jpg";
                                       if (c.MemberProfiles.FirstOrDefault() != null)
                                       {
                                           if (c.MemberProfiles.FirstOrDefault().imagePath != null)
                                           {
                                               profilePic = c.MemberProfiles.FirstOrDefault().imagePath;
                                           }
                                       }
                                    %><a href="/Member/UserDetail/<%=c.id.ToString() %>">
                                    <img alt="Profile Image" src="<%= profilePic %>" width="68px" height="68px" style="border: 0px;" /></a>
                                </td>
                                <td style="width: 80%;" valign="top">
                                    <div class="rtuinbox">
                                        <% string name = string.Empty;
                                           if (!string.IsNullOrEmpty(c.organisationName))
                                           {
                                               name = c.organisationName.ToString();
                                           }
                                           else
                                           {
                                               name = c.firstName + " " + c.lastName;
                                           }
                                        %>
                                        <a href="/Member/UserDetail/<%=c.id.ToString() %>" class="heading">
                                            <%=name%></a><br />
                                       <b><%=c.Seeds.ToList().Count() %>
                                        seeds planted,</b> 
                                       <span><%
                       if (c.MemberProfiles.FirstOrDefault() != null)
                       {
                           if (c.MemberProfiles.FirstOrDefault().Location != null)
                           { %>
                                        <%=c.MemberProfiles.FirstOrDefault().Location.City.name%>,
                                        <%=c.MemberProfiles.FirstOrDefault().Location.City.Region.code%>
                                        <%}
                               }%></span>
                                    </div>
                                </td>
                            </tr>
                            <tr valign="top">
                                <td style="width: 80%;" valign="top">
                                    <div class="detail">
                                        <span class="text">
                                            <% 
                                string subString = "";
                                if (c.MemberProfiles.FirstOrDefault() != null)
                                {
                                    if (c.MemberProfiles.FirstOrDefault().bio != null)
                                    {
                                        if (c.MemberProfiles.FirstOrDefault().bio.Length > 250)
                                        {
                                            subString = c.MemberProfiles.FirstOrDefault().bio.Substring(0, 250);
                                            Response.Write(subString); %>
                                            <a href="/Member/UserDetail/<%= c.id.ToString() %>">...more</a>
                                            <%}
                                       else
                                       {
                                           subString = c.MemberProfiles.FirstOrDefault().bio.ToString();
                                           Response.Write(subString);
                                       }
                                   }
                               }%>
                                        </span><span>
                                            <% SeedSpeak.Model.Member mData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
                                               string btnFollow1 = "Follow";
                                               string btnFollowClass1 = "clsFollow";
                                               SeedSpeak.Model.FollowPeople follow = mData.FollowPeoples.Where(x => x.followingId.Equals(c.id)).FirstOrDefault();
                                               if (follow != null)
                                               {
                                                   btnFollow1 = "Unfollow";
                                                   btnFollowClass1 = "clsUnFollow";
                                               }
                                            %>
                                            <% 
                       var fbuttonID = "BblefFollow_" + c.id.ToString();
                                                %>
                                            <input class="<%=btnFollowClass1 %>" type="button" value="<%=btnFollow1 %>" id="<%=fbuttonID %>" />
                                            <% string btnMute1 = "Mute";
                                               string btnMuteClass1 = "clsMute";
                                               SeedSpeak.Model.MutePeople mute = mData.MutePeoples.Where(x => x.muteId.Equals(c.id)).FirstOrDefault();
                                               if (mute != null)
                                               {
                                                   btnMute1 = "Unmute";
                                                   btnMuteClass1 = "clsUnMute";
                                               }
                                            %>
                                            <% 
                       var mbuttonID = "BblemFollow_" + c.id.ToString();
                                                %>
                                            <input class="<%=btnMuteClass1 %>" name="btnMute" type="submit" id="<%=mbuttonID %>" value="<%=btnMute1 %>" />
                                        </span>
                                    </div>
                                </td>
                            </tr>
                        </table> <div style="clear: both;">
                            </div><span class="shades" ></span>
                        <%
                   });
               })
           .Pageable(paging => paging.PageSize(5))
           .Footer(true)
           .Render();
                        %></div>
                    <%}
                       else
                       {
                           Response.Write("<div class='errpgmessage'>You are not following anyone yet !</div>");
                       } %>
                           <%
                       });
                   tabstrip.Add()
                       .Text("Followers" + " (" + followersCount + ")")
                       .Content(() =>
                       {%>
                    <div class="clear">
                    </div>
                    <% if (followersCount > 0)
                       { %>
                    <div class="fullwidthcol">
                        <% Html.Telerik().Grid<SeedSpeak.Model.Member>("Followers")
           .Name("grdFollowers")
           .Columns(columns =>
               {
                   columns.Template(c =>
                   {
                        %>
                        <table border="0" width="100%;">
                            <tr valign="top">
                                <td rowspan="2" valign="top" style="width: 10%;">
                                    <% 
                       string profilePic = "../../Content/images/user-icon.jpg";
                       if (c.MemberProfiles.FirstOrDefault() != null)
                       {
                           if (c.MemberProfiles.FirstOrDefault().imagePath != null)
                           {
                               profilePic = c.MemberProfiles.FirstOrDefault().imagePath;
                           }
                       }
                                    %><a href="/Member/UserDetail/<%=c.id.ToString() %>">
                                    <img alt="Profile Image" src="<%= profilePic %>" width="68px" height="68px" style="border: 0px;" /></a>
                                </td>
                                <td style="width: 80%;" valign="top">
                                    <div class="rtuinbox">
                                        <% string name = string.Empty;
                                           if (!string.IsNullOrEmpty(c.organisationName))
                                           {
                                               name = c.organisationName.ToString();
                                           }
                                           else
                                           {
                                               name = c.firstName + " " + c.lastName;
                                           }
                                        %>
                                        <a href="/Member/UserDetail/<%=c.id.ToString() %>" class="heading">
                                            <%=name%></a><br />
                                       <b><%=c.Seeds.ToList().Count() %>
                                        seeds planted,</b> 
                                       <span><%
                       if (c.MemberProfiles.FirstOrDefault() != null)
                       {
                           if (c.MemberProfiles.FirstOrDefault().Location != null)
                           { %>
                                        <%=c.MemberProfiles.FirstOrDefault().Location.City.name%>,
                                        <%=c.MemberProfiles.FirstOrDefault().Location.City.Region.code%>
                                        <%}
                               }%></span>
                                    </div>
                                </td>
                            </tr>
                            <tr valign="top">
                                <td style="width: 80%;" valign="top">
                                    <div class="detail">
                                        <span class="text">
                                            <% 
                                string subString = "";
                                if (c.MemberProfiles.FirstOrDefault() != null)
                                {
                                    if (c.MemberProfiles.FirstOrDefault().bio != null)
                                    {
                                        if (c.MemberProfiles.FirstOrDefault().bio.Length > 250)
                                        {
                                            subString = c.MemberProfiles.FirstOrDefault().bio.Substring(0, 250);
                                            Response.Write(subString); %>
                                            <a href="/Member/UserDetail/<%= c.id.ToString() %>">...more</a>
                                            <%}
                                       else
                                       {
                                           subString = c.MemberProfiles.FirstOrDefault().bio.ToString();
                                           Response.Write(subString);
                                       }
                                   }
                               }%>
                                        </span><span>
                                            <% SeedSpeak.Model.Member mData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
                                               string btnFollow1 = "Follow";
                                               string btnFollowClass1 = "clsFollow";
                                               SeedSpeak.Model.FollowPeople follow = mData.FollowPeoples.Where(x => x.followingId.Equals(c.id)).FirstOrDefault();
                                               if (follow != null)
                                               {
                                                   btnFollow1 = "Unfollow";
                                                   btnFollowClass1 = "clsUnFollow";
                                               }
                                            %>
                                            <% 
                       var fbuttonID = "BblefFollow_" + c.id.ToString();
                                                %>
                                            <input class="<%=btnFollowClass1 %>" type="button" value="<%=btnFollow1 %>" id="<%=fbuttonID%>" />
                                            <% string btnMute1 = "Mute";
                                               string btnMuteClass1 = "clsMute";
                                               SeedSpeak.Model.MutePeople mute = mData.MutePeoples.Where(x => x.muteId.Equals(c.id)).FirstOrDefault();
                                               if (mute != null)
                                               {
                                                   btnMute1 = "Unmute";
                                                   btnMuteClass1 = "clsUnMute";
                                               }
                                            %>
                                            <% 
                       var mbuttonID = "BblemFollow_" + c.id.ToString();
                                               %>
                                            <input class="<%=btnMuteClass1 %>" name="btnMute" type="submit" id="<%=mbuttonID%>" value="<%=btnMute1 %>" />
                                        </span>
                                    </div>
                                </td>
                            </tr>
                        </table> <div style="clear: both;">
                            </div><span class="shades" ></span>
                        <%
                   });
               })
           .Pageable(paging => paging.PageSize(5))
           .Footer(true)
           .Render();
                        %></div>
                    <%}
                       else
                       {
                           Response.Write("<div class='errpgmessage'>no user is following you yet !</div>");
                       } %>
                    <%});
               }).SelectedIndex(0).Render();
                    %>
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
