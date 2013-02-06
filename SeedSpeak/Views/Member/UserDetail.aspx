<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    User Details
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .imglnk
        {
            display: none;
        }
        .title
        {
            display: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">    
    <% string facebookLogin = (string)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.FacebookConnect);
       SeedSpeak.Model.Member mbrData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject); %>
    <% SeedSpeak.Model.Member memberData = (SeedSpeak.Model.Member)ViewData["MemberInfo"]; %>
    <% string imagePath = "";
       if (memberData.MemberProfiles.FirstOrDefault() != null)
       {
           if (memberData.MemberProfiles.FirstOrDefault().imagePath != null)
           {
               string img = memberData.MemberProfiles.FirstOrDefault().imagePath.ToString();
               if (img.Contains("profile.ak.fbcdn.net"))
               {
                   imagePath = img;
               }
               else
               {
                   img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                   if (System.IO.File.Exists(img))
                       imagePath = memberData.MemberProfiles.FirstOrDefault().imagePath.ToString();
                   else
                       imagePath = "../../Content/images/profile.jpg";
               }
           }
           else
               imagePath = "../../Content/images/profile.jpg";
       }
       else
       {
           imagePath = "../../Content/images/profile.jpg";
       }

       string[] contentCounts = (string[])ViewData["Counts"];       
    %>
    <div id="Profile">
        <div style="width: 685px; float: left; padding: 0px 20px 15px 15px">
            <table width="100%">
                <tr>
                    <td>
                        <div class="pageheader" style="margin-left: 10px">
                            <% if (string.IsNullOrEmpty(memberData.organisationName))
                               { %>
                            <%: memberData.firstName + " " + memberData.lastName%>
                            <%}
                               else
                               { %>
                            <%: memberData.organisationName%>
                            <%} %></div>
                        <div style="float: left">
                            <% if (Convert.ToString(ViewData["ProfileView"]) == "Self")
                               { %>
                            <a href="/Member/Profile" class="editprofile">Edit Profile</a>
                            <%} %>
                        </div>
                    </td>
                    <td style="text-align: right;">
                        <% if (Convert.ToString(ViewData["ProfileView"]) == "Other")
                           {
                               string btnFollow1 = "Follow";
                               string btnFollowClass1 = "clsFollow";
                               SeedSpeak.Model.FollowPeople follow = mbrData.FollowPeoples.Where(x => x.followingId.Equals(memberData.id)).FirstOrDefault();
                               if (follow != null)
                               {
                                   btnFollow1 = "Unfollow";
                                   btnFollowClass1 = "clsUnFollow";
                               }
                               var fbuttonID = "BblefFollow_" + memberData.id.ToString();
                                %>
                        <input class="<%=btnFollowClass1 %>" type="button" value="<%=btnFollow1 %>" id="<%=fbuttonID %>" />
                        <% string btnMute1 = "Mute";
                                               string btnMuteClass1 = "clsMute";
                                               SeedSpeak.Model.MutePeople mute = mbrData.MutePeoples.Where(x => x.muteId.Equals(memberData.id)).FirstOrDefault();
                                               if (mute != null)
                                               {
                                                   btnMute1 = "Unmute";
                                                   btnMuteClass1 = "clsUnMute";
                                               }
                       var mbuttonID = "BblemFollow_" + memberData.id.ToString();
                                                %>
                        <input class="<%=btnMuteClass1 %>" name="btnMute" type="button" id="<%=mbuttonID %>" value="<%=btnMute1 %>" />
                        <%} %>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        <% if (Convert.ToString(ViewData["ProfileView"]) == "Self")
                           { %>
                        <%--<a href="#" class="manage">Manage</a>--%>
                        <%} %>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <% Html.Telerik().TabStrip()
           .Name("ProfileTabs").Items(tabstrip =>
               {
                   tabstrip.Add().Text("Planted Seeds (" + contentCounts[0].ToString() + ")")
                       .Content(() =>
                                   {%>
                        <div>                            
                            <%SeedSpeak.Util.SessionStore.SetSessionValue(SeedSpeak.Util.SessionStore.GridViewName, "PlantedSeeds"); %>
                            <% Html.RenderPartial("GridViewPartialVisitorScripts"); %>
                            <% Html.RenderPartial("GridViewPartialVisitor", ViewData["ListSeed"]); %>
                        </div>
                        <%});
                   tabstrip.Add()
                       .Text("Likes (" + contentCounts[1].ToString() + ")")
                       .Content(() =>
                       {%>
                       <div>
                       <% SeedSpeak.Util.SessionStore.SetSessionValue(SeedSpeak.Util.SessionStore.GridViewName, "Likes");
                           ViewData["ListSeed"] = ViewData["FavSeeds"]; 
                           Html.RenderPartial("GridViewPartialVisitor", ViewData["ListSeed"]); %>
                       </div>
                        <%});
                   tabstrip.Add()
                        .Text("People (" + contentCounts[2].ToString() + ")")
                        .Content(() =>
                        {%>
                        <div>
                            <br />
                            <% Html.Telerik().TabStrip()
           .Name("PeopleProfileTabs").Items(tabs =>
               {
                   tabs.Add().Text("Following (" + contentCounts[5].ToString() + ")")
                       .Content(() =>
                                   {%>
                            <div class="fullwidthcol">
                                <%    if (ViewData["Following"] != null)
                                      {
                                          IList<SeedSpeak.Model.Member> objFollowing = (List<SeedSpeak.Model.Member>)ViewData["Following"];
                                          if (objFollowing.Count > 0)
                                          {
                                              Html.Telerik().Grid<SeedSpeak.Model.Member>("Following")
                .Name("Following")
                .Columns(columns =>
                {
                    columns.Template(c =>
                    {
                                %>
                                <table border="0" style="width: 100%">
                                    <tr valign="top">
                                        <td rowspan="2" valign="top" style="width: 12%; padding-top: 6px">
                                            <% 
                        string profilePic = "../../Content/images/user-icon.jpg";
                        if (c.MemberProfiles.FirstOrDefault() != null)
                        {
                            if (c.MemberProfiles.FirstOrDefault().imagePath != null)
                            {
                                profilePic = c.MemberProfiles.FirstOrDefault().imagePath;
                            }
                        }
                                            %>
                                            <%if (memberData != null)
                                              { %>
                                            <a href="/Member/UserDetail/<%=c.id.ToString() %>">
                                                <img alt="Profile Image" src="<%= profilePic %>" width="68px" height="68px" style="border: 0px;" />
                                            </a>
                                            <%}
                                              else
                                              { %>
                                            <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                                <img alt="Profile Image" src="<%= profilePic %>" width="68px" height="68px" style="border: 0px;" />
                                            </a>
                                            <%} %>
                                        </td>
                                        <td valign="top">
                                            <div class="rtuinbox">                                                
                                                <% string name = !string.IsNullOrEmpty(c.organisationName) ? c.organisationName.ToString() : c.firstName + " " + c.lastName;
                                                %>
                                                <%if (memberData != null)
                                                  { %>
                                                <a href="/Member/UserDetail/<%=c.id.ToString() %>" class="heading">
                                                    <%=name %></a>
                                                <%}
                                                  else
                                                  { %>
                                                <a onclick="javascript:callLoginPartialWindow(0);" class="heading">
                                                    <%=name %>
                                                </a>
                                                <%} %><br />
                                                <b>
                                                    <%=c.Seeds.ToList().Count() %>
                                                    seeds planted,</b> <span>
                                                        <%
                        if (c.MemberProfiles.FirstOrDefault() != null)
                        {
                            if (c.MemberProfiles.FirstOrDefault().Location != null)
                            {%>
                                                        <%=c.MemberProfiles.FirstOrDefault().Location.City.name%>,
                                                        <%=c.MemberProfiles.FirstOrDefault().Location.City.Region.code%>
                                                        <%}
                        } %></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                        <td valign="top">
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
                                                    <a href="/Member/UserDetail/<%=c.id.ToString() %>">...more</a>
                                                    <%}
                                else
                                {
                                    subString = c.MemberProfiles.FirstOrDefault().bio.ToString();
                                    Response.Write(subString);
                                }
                            }
                        }%>
                                                </span><span>
                                                    <% if (mbrData == null)
                                                       {%>
                                                    <input type="button" value="Follow" class="clsFollow" onclick="javascript:callLoginPartialWindow(0);" />
                                                    <input type="button" value="Mute" class="clsMute" onclick="javascript:callLoginPartialWindow(0);" />
                                                    <%}
                                                       else
                                                       {
                                                           string btnFollow = "Follow";
                                                           string btnFollowClass = "clsFollow";
                                                           SeedSpeak.Model.FollowPeople follow = memberData.FollowPeoples.Where(x => x.followingId.Equals(c.id)).FirstOrDefault();
                                                           if (follow != null)
                                                           {
                                                               btnFollow = "Unfollow";
                                                               btnFollowClass = "clsUnFollow";
                                                           }
                                                    %>
                                                    <% var MAfbuttonID = "MAFollow_" + c.id.ToString(); %>
                                                    <input class="<%=btnFollowClass %>" type="button" value="<%=btnFollow %>" id="<%=MAfbuttonID%>" />
                                                    <% string btnMute = "Mute";
                                                       string btnMuteClass = "clsMute";
                                                       SeedSpeak.Model.MutePeople mute = memberData.MutePeoples.Where(x => x.muteId.Equals(c.id)).FirstOrDefault();
                                                       if (mute != null)
                                                       {
                                                           btnMute = "Unmute";
                                                           btnMuteClass = "clsUnMute";
                                                       }
                                                    %>
                                                    <% var MAmbuttonID = "MAMute_" + c.id.ToString(); %>
                                                    <input class="<%=btnMuteClass %>" name="btnMute" type="submit" id="<%=MAmbuttonID%>"
                                                        value="<%=btnMute %>" />
                                                    <%
                                                       }%>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                </table><div style="clear: both;"></div>
                            <span class="shades" ></span>
                                <%
                    });
                })
                                      .Pageable(paging => paging.PageSize(10))
           .Footer(true)
           .Render();
                                          }
                                          else
                                          {
                                              Response.Write("<div class='errpgmessage'>You are not following any one yet !</div>");
                                          }
                                      }  %></div>
                            <%});
                   tabs.Add()
                       .Text("Followers (" + contentCounts[2].ToString() + ")")
                       .Content(() =>
                       {%>
                            <div class="fullwidthcol">
                                <%    if (ViewData["Followers"] != null)
                                      {
                                          IList<SeedSpeak.Model.Member> objFollowers = (List<SeedSpeak.Model.Member>)ViewData["Followers"];
                                          if (objFollowers.Count > 0)
                                          {
                                              Html.Telerik().Grid<SeedSpeak.Model.Member>("Followers")
                .Name("Followers")
                .Columns(columns =>
                {
                    columns.Template(c =>
                    {
                                %>
                                <table border="0" style="width: 100%">
                                    <tr valign="top">
                                        <td rowspan="2" valign="top" style="width: 12%; padding-top: 6px">
                                            <% 
                        string profilePic = "../../Content/images/user-icon.jpg";
                        if (c.MemberProfiles.FirstOrDefault() != null)
                        {
                            if (c.MemberProfiles.FirstOrDefault().imagePath != null)
                            {
                                profilePic = c.MemberProfiles.FirstOrDefault().imagePath;
                            }
                        }
                                            %>
                                            <%if (memberData != null)
                                              { %>
                                            <a href="/Member/UserDetail/<%=c.id.ToString() %>">
                                                <img alt="Profile Image" src="<%= profilePic %>" width="68px" height="68px" style="border: 0px;" />
                                            </a>
                                            <%}
                                              else
                                              { %>
                                            <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                                <img alt="Profile Image" src="<%= profilePic %>" width="68px" height="68px" style="border: 0px;" />
                                            </a>
                                            <%} %>
                                        </td>
                                        <td valign="top">
                                            <div class="rtuinbox">                                                
                                                <% string name = !string.IsNullOrEmpty(c.organisationName) ? c.organisationName.ToString() : c.firstName + " " + c.lastName;
                                                %>
                                                <%if (memberData != null)
                                                  { %>
                                                <a href="/Member/UserDetail/<%=c.id.ToString() %>" class="heading">
                                                    <%=name %></a>
                                                <%}
                                                  else
                                                  { %>
                                                <a onclick="javascript:callLoginPartialWindow(0);" class="heading">
                                                    <%=name %>
                                                </a>
                                                <%} %><br />
                                                <b>
                                                    <%=c.Seeds.ToList().Count() %>
                                                    seeds planted,</b> <span>
                                                        <%
                        if (c.MemberProfiles.FirstOrDefault() != null)
                        {
                            if (c.MemberProfiles.FirstOrDefault().Location != null)
                            {%>
                                                        <%=c.MemberProfiles.FirstOrDefault().Location.City.name%>,
                                                        <%=c.MemberProfiles.FirstOrDefault().Location.City.Region.code%>
                                                        <%}
                        } %></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                        <td valign="top">
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
                                                    <a href="/Member/UserDetail/<%=c.id.ToString() %>">...more</a>
                                                    <%}
                                else
                                {
                                    subString = c.MemberProfiles.FirstOrDefault().bio.ToString();
                                    Response.Write(subString);
                                }
                            }
                        }%>
                                                </span><span>
                                                    <% if (mbrData == null)
                                                       {%>
                                                    <input type="button" value="Follow" class="clsFollow" onclick="javascript:callLoginPartialWindow(0);" />
                                                    <input type="button" value="Mute" class="clsMute" onclick="javascript:callLoginPartialWindow(0);" />
                                                    <%}
                                                       else
                                                       {
                                                           string btnFollow = "Follow";
                                                           string btnFollowClass = "clsFollow";
                                                           SeedSpeak.Model.FollowPeople follow = memberData.FollowPeoples.Where(x => x.followingId.Equals(c.id)).FirstOrDefault();
                                                           if (follow != null)
                                                           {
                                                               btnFollow = "Unfollow";
                                                               btnFollowClass = "clsUnFollow";
                                                           }
                                                    %>
                                                    <% var MAfbuttonID = "MAFollow_" + c.id.ToString(); %>
                                                    <input class="<%=btnFollowClass %>" type="button" value="<%=btnFollow %>" id="Button1" />
                                                    <% string btnMute = "Mute";
                                                       string btnMuteClass = "clsMute";
                                                       SeedSpeak.Model.MutePeople mute = memberData.MutePeoples.Where(x => x.muteId.Equals(c.id)).FirstOrDefault();
                                                       if (mute != null)
                                                       {
                                                           btnMute = "Unmute";
                                                           btnMuteClass = "clsUnMute";
                                                       }
                                                    %>
                                                    <% var MAmbuttonID = "MAMute_" + c.id.ToString(); %>
                                                    <input class="<%=btnMuteClass %>" name="btnMute" type="submit" id="Submit1" value="<%=btnMute %>" />
                                                    <%
                                                       }%>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                </table><div style="clear: both;"></div>
                            <span class="shades" ></span>
                                <%
                    });
                })
                                      .Pageable(paging => paging.PageSize(10))
           .Footer(true)
           .Render();
                                          }
                                          else
                                          {
                                              Response.Write("<div class='errpgmessage'>No one is following you yet !</div>");
                                          }
                                      }  %></div>
                            <%});
                   tabs.Add()
                        .Text("Latest Activity (" + contentCounts[6].ToString() + ")")
                        .Content(() =>
                        {%>
                            <div>
                            <% SeedSpeak.Util.SessionStore.SetSessionValue(SeedSpeak.Util.SessionStore.GridViewName, "LatestActivity");
                                ViewData["ListSeed"] = ViewData["LatestActivity"]; 
                           Html.RenderPartial("GridViewPartialVisitor", ViewData["ListSeed"]); %>
                            </div>
                            <%});
               }).SelectedIndex(Convert.ToInt32(ViewData["ChildTabSelectedIndex"])).Render();
                            %>
                        </div>
                        <%});
                   tabstrip.Add()
             .Text("Feeds (" + contentCounts[3].ToString() + ")")
             .Content(() =>
             {%>
                        <div class="streamfull">
                            <% 
                 if (ViewData["UserFeeds"] != null)
                 {
                     IList<SeedSpeak.Model.ssStream> objssStream = (List<SeedSpeak.Model.ssStream>)ViewData["UserFeeds"];
                     if (objssStream.Count > 0)
                     {
                         Html.Telerik().Grid<SeedSpeak.Model.ssStream>("UserFeeds")
                        .Name("gridboxFeeds")
                        .Columns(columns =>
                            {
                                columns.Template(c =>
                                {
                            %>
                            <div class="gridcontent_stream">
                                <h3>
                                    <%if (mbrData != null)
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
                                    <small><% string imagePathFeeds = "../../Content/images/user.gif";
                                           if (c.Member.MemberProfiles.FirstOrDefault() != null)
                                           {
                                               if (c.Member.MemberProfiles.FirstOrDefault().imagePath != null)
                                               {
                                                   string img = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                                   img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                                                   if (System.IO.File.Exists(img))
                                                       imagePathFeeds = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                               }
                                           }
                                        %>
                                        <% string dispName = string.Empty;
                                           if (string.IsNullOrEmpty(c.Member.organisationName))
                                               dispName = c.Member.firstName + " " + c.Member.lastName;
                                           else
                                               dispName = c.Member.organisationName;
                                        %>
                                        <%if (memberData != null)
                                          { %>
                                        <a href="/Member/UserDetail/<%= c.Member.id %>">
                                            <img alt="User Image" src="<%= imagePathFeeds %>" width="40" height="40" style="position: relative;
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
                                        <%if (mbrData != null)
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
                            <div style="clear: both;">
                            </div><span class="shades" ></span>
                            <%}).Title("Seeds");
                            })
                                                       .Pageable(paging => paging.PageSize(5))
      .Footer(true)
      .Render();
                     }
                     else
                     {
                         Response.Write("<div class='errpgmessage'>User is not having any active feed.</div>");
                     }
                 }
                            %>
                        </div>
                        <%});
                   tabstrip.Add()
                        .Text("Lists (" + contentCounts[4].ToString() + ")")
                        .Content(() =>
                        {%>
                        <div class="streamfull">
                            <% 
                            if (ViewData["UserLists"] != null)
                            {
                                IList<SeedSpeak.Model.ssStream> objssStream = (List<SeedSpeak.Model.ssStream>)ViewData["UserLists"];
                                if (objssStream.Count > 0)
                                {
                                    Html.Telerik().Grid<SeedSpeak.Model.ssStream>("UserLists")
                                   .Name("gridboxLists")
                                   .Columns(columns =>
                                       {
                                           columns.Template(c =>
                                           {
                            %>
                            <div class="gridcontent_stream">
                                <h3>
                                    <%if (mbrData != null)
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
                                        <% string imagePathList = "../../Content/images/user.gif";
                                           if (c.Member.MemberProfiles.FirstOrDefault() != null)
                                           {
                                               if (c.Member.MemberProfiles.FirstOrDefault().imagePath != null)
                                               {
                                                   string img = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                                   img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                                                   if (System.IO.File.Exists(img))
                                                       imagePathList = c.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                                               }
                                           }
                                        %>
                                        <% string dispName = string.Empty;
                                           if (string.IsNullOrEmpty(c.Member.organisationName))
                                               dispName = c.Member.firstName + " " + c.Member.lastName;
                                           else
                                               dispName = c.Member.organisationName;
                                        %>
                                        <%if (memberData != null)
                                          { %>
                                        <a href="/Member/UserDetail/<%= c.Member.id %>">
                                            <img alt="User Image" src="<%= imagePathList %>" width="40" height="40" style="position: relative;
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
                                        <%if (mbrData != null)
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
                            <div style="clear: both;">
                            </div><span class="shades" ></span>
                            <%}).Title("Seeds");
                                       })
                                                       .Pageable(paging => paging.PageSize(5))
      .Footer(true)
      .Render();
                                }
                                else
                                {
                                    Response.Write("<div class='errpgmessage'>User is not having any active list.</div>");
                                }
                            }
                            %>
                        </div>
                        <%});
               }).SelectedIndex(Convert.ToInt32(ViewData["ParentTabSelectedIndex"])).Render();
                        %>
                    </td>
                </tr>
            </table>
        </div>
        <div style="width: 265px; float: left">
            <table width="100%">
                <tr>
                    <td height="35px" class="sub_links">
                        <span class="sub_links">
                            <%=contentCounts[0].ToString() %>
                            Seeds |
                            <%=contentCounts[1].ToString() %>
                            Likes |
                            <%=contentCounts[3].ToString() %>
                            Feeds |
                            <%=contentCounts[2].ToString() %>
                            Followers</span>
                    </td>
                </tr>
                <tr>
                    <td height="13px">
                    </td>
                </tr>
                <tr>
                    <td>
                        <div>
                            <img src="<%= imagePath %>" class="profile_img" alt="Profile Image" width="100" height="100" />
                            <span><span class="profile_name">
                                <% if (string.IsNullOrEmpty(memberData.organisationName))
                                   { %>
                                <%: memberData.firstName + " " + memberData.lastName%>
                                <%}
                                   else
                                   { %>
                                <%: memberData.organisationName%>
                                <%} %></span> <span class="profile_city">
                                    <% string bioDesc = string.Empty;
                                        if (memberData.MemberProfiles.FirstOrDefault() != null)
                                        {
                                            if (memberData.MemberProfiles.FirstOrDefault().Location != null)
                                            {
                                                Response.Write(memberData.MemberProfiles.FirstOrDefault().Location.City.name + ", " + memberData.MemberProfiles.FirstOrDefault().Location.City.Region.code);

                                            }
                                            if (!string.IsNullOrEmpty(memberData.MemberProfiles.FirstOrDefault().bio))
                                            {
                                                bioDesc = memberData.MemberProfiles.FirstOrDefault().bio;
                                            }
                                        }
                                    %>
                                </span><span class="profile_link">
                                <% string userURL = string.Empty;
                                    if (memberData.MemberProfiles.FirstOrDefault() != null)
                                   {
                                       if (!string.IsNullOrEmpty(memberData.MemberProfiles.FirstOrDefault().setURL))
                                       {
                                           userURL = memberData.MemberProfiles.FirstOrDefault().setURL;
                                       } 
                                   }
                                    %>
                                    <%=userURL %></span>
                                <br />
                                <span class="profile_detail">
                                    <%=bioDesc%>
                                </span></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
            </table>
        </div>
    </div>    
</asp:Content>
