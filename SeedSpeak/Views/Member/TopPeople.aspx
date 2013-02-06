<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    People</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <script src="../../Scripts/2010.2.825/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $(".clsFollow,.clsUnFollow").click(function () {
                var cUserID = $(this).attr('id').split('_');
                var buttonID = $(this).attr('id');
                var cUser = cUserID[1];
                var cValue = $(this).attr('value');
                if (buttonID != "") {
                    $.getJSON("/Member/FollowUnfollow/?followingId=" + cUser + "&btnAction=" + cValue,
          function (data) {
              if (data.toString() != "") {
                  if (data.toString() == "Follow") {
                      $("#" + buttonID).attr("class", "clsFollow");
                  }
                  if (data.toString() == "Unfollow") {
                      $("#" + buttonID).attr("class", "clsUnFollow");
                  }
                  $("#" + buttonID).val(data.toString());                  
              }
          });
                }
            });

  $(".clsMute,.clsUnMute").click(function () {
                var cUserID = $(this).attr('id').split('_');
                var buttonID = $(this).attr('id');
                var cUser = cUserID[1];
                var cValue = $(this).attr('value');
                if (buttonID != "") {
                    $.getJSON("/Member/MuteUnMute/?muteId=" + cUser + "&btnAction=" + cValue,
          function (data) {
              if (data.toString() != "") {
                  if (data.toString() == "Mute") {
                      $("#" + buttonID).attr("class", "clsMute");
                  }
                  if (data.toString() == "Unmute") {
                      $("#" + buttonID).attr("class", "clsUnMute");
                  }
                  $("#" + buttonID).val(data.toString());
              }
          });
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">    
    <div class="fullwidth round">
        <table width="100%">
            <tr>
                <td class="pageheader">
                    People
                </td>
            </tr>
            <tr>
                <td class="commontxt">
                    Discover great ideas by following other SeedSpeak users.
                </td>
            </tr>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <td>
                    <div class="stream_searchbar">
                        <% using (Html.BeginForm("TopPeople", "Member", FormMethod.Post, new { id = "MostActiveForm" }))
                           { %>
                        <div class="searchbar1">
                            <span></span>
                            <input type="text" id="peopleSearch" name="peopleSearch" class="waterMark" title="Search all people" />
                            <input type="submit" value="" class="go1" style="float: none;" />
                        </div>
                        <%} %>
                    </div>
                </td>
            </tr>
            </table>
        <% SeedSpeak.Model.Member mData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject); %>
        <div class="tabgridcontent">
            <% Html.Telerik().TabStrip()
           .Name("TopPeopleTab").Items(tabstrip =>
               {
                   tabstrip.Add().Text("Most Active")
                       .Content(() =>
                                   {%>
            <div style="width: 100%; float: left;">
                <br />
                <%if (ViewData["NoResult"] != null)
                  { %>                
                <div class="errpgmessage">
                    <%=ViewData["NoResult"].ToString()%>
                </div>
                <br />
                <%} %>
                <div class="fullwidthcol">
                    <%    if (ViewData["MostActive"] != null)
                          {
                              IList<SeedSpeak.Model.Member> objMostActive = (List<SeedSpeak.Model.Member>)ViewData["MostActive"];
                              if (objMostActive.Count > 0)
                              {
                                  Html.Telerik().Grid<SeedSpeak.Model.Member>("MostActive")
    .Name("grdMostActive")
    .Columns(columns =>
    {
        columns.Template(c =>
        {
                    %>
                    <table border="0" style="width:100%">
                        <tr valign="top">
                            <td rowspan="2" valign="top" style="width: 10%; padding-top: 6px">
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
                                <%if (mData != null)
                                  { %>
                                <a href="/Member/UserDetail/<%=c.id.ToString() %>">
                                <img alt="Profile Image" src="<%= profilePic %>" width="68px" height="68px" style="border: 0px;" />
                                </a><%}
                                  else
                                  { %>
                                  <a  style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                <img alt="Profile Image" src="<%= profilePic %>" width="68px" height="68px" style="border: 0px;" />
                                </a>
                                <%} %>
                            </td>
                            <td valign="top">
                                <div class="rtuinbox">                                    
                                    <% string name = !string.IsNullOrEmpty(c.organisationName) ? c.organisationName.ToString() : c.firstName + " " + c.lastName;
                                    %>
                                    <%if (mData != null)
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
                                   <b> <%=c.Seeds.ToList().Count() %>
                                    seeds planted,</b>
                                    <span><%
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
                                        <a href="#">...more</a>
                                        <%}
                                                else
                                                {
                                                    subString = c.MemberProfiles.FirstOrDefault().bio.ToString();
                                                    Response.Write(subString);
                                                }
                                            }
                                        }%>
                                    </span><span>
                                        <% if (mData == null)
                                           {%>
                                        <input type="button" value="Follow" class="clsFollow" onclick="javascript:callLoginPartialWindow(0);" />
                                        <input type="button" value="Mute" class="clsMute" onclick="javascript:callLoginPartialWindow(0);" />
                                        <%}
                                           else
                                           {
                                               string btnFollow = "Follow";
                                               string btnFollowClass = "clsFollow";
                                               SeedSpeak.Model.FollowPeople follow = mData.FollowPeoples.Where(x => x.followingId.Equals(c.id)).FirstOrDefault();
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
                                           SeedSpeak.Model.MutePeople mute = mData.MutePeoples.Where(x => x.muteId.Equals(c.id)).FirstOrDefault();
                                           if (mute != null)
                                           {
                                               btnMute = "Unmute";
                                               btnMuteClass = "clsUnMute";
                                           }
                                        %>
                                        <% var MAmbuttonID = "MAMute_" + c.id.ToString(); %>
                                        <input class="<%=btnMuteClass %>" name="btnMute" type="submit" id="<%=MAmbuttonID%>" value="<%=btnMute %>" />
                                        <%
                                           }%>
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </table><span class="shades2" ></span>
                    <%
        });
    })
                                      .Pageable(paging => paging.PageSize(10))
           .Footer(true)
           .Render();
                              }
                              else
                              {
                                  Response.Write("<div class='errpgmessage'>None of the most active user found yet !</div>");
                              }
                          }  %></div>
            </div>
            <%});
                   tabstrip.Add()
                       .Text("Nearby Users")
                       .Content(() =>
                       {%>
            <br />
            <div class="fullwidthcol">
                <%    if (ViewData["NearbyUsers"] != null)
                      {
                          IList<SeedSpeak.Model.Member> objNearbyUsers = (List<SeedSpeak.Model.Member>)ViewData["NearbyUsers"];
                          if (objNearbyUsers.Count > 0)
                          {
                              Html.Telerik().Grid<SeedSpeak.Model.Member>("NearbyUsers")
.Name("grdNearbyUsers")
.Columns(columns =>
{
    columns.Template(c =>
    {
                %>
                <table border="0" style="width:100%">
                    <tr valign="top">
                        <td rowspan="2" valign="top" style="width: 10%; padding-top: 6px">
                            <% string profilePic = "../../Content/images/user-icon.jpg";
                               if (c.MemberProfiles.FirstOrDefault() != null)
                               {
                                   if (c.MemberProfiles.FirstOrDefault().imagePath != null)
                                   {
                                       profilePic = c.MemberProfiles.FirstOrDefault().imagePath;
                                   }
                               }                               
                            %>
                            <%if (mData != null)
                                  { %>
                                <a href="/Member/UserDetail/<%=c.id.ToString() %>" style="color: #0f597f; font-size: 14px;">
                                        <img alt="Profile Image" src="<%= profilePic %>" width="68px" height="68px" style="border: 0px;" /></a>
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
                                <%if (mData != null)
                                  { %>
                                <a href="/Member/UserDetail/<%=c.id.ToString() %>" class="heading">
                                        <%=name %></a>
                                <%}
                                  else
                                  { %>
                                  <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);" class="heading">
                                <%=name %>
                                </a>
                                <%} %> <br />
                              <b> <%=c.Seeds.ToList().Count() %>
                                seeds planted,</b>
                               <span> <%
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
                                    <a href="#">...more</a>
                                    <%}
                                            else
                                            {
                                                subString = c.MemberProfiles.FirstOrDefault().bio.ToString();
                                                Response.Write(subString);
                                            }
                                        }
                                    }%></span> <span>
                                       <% if (mData == null)
                                          {%>
                                       <input type="button" value="Follow" class="clsFollow" onclick="javascript:callLoginPartialWindow(0);" />
                                       <input type="button" value="Mute" class="clsMute" onclick="javascript:callLoginPartialWindow(0);" />
                                       <%}
                                          else
                                          {
                                              string btnFollow1 = "Follow";
                                              string btnFollowClass1 = "clsFollow";
                                              SeedSpeak.Model.FollowPeople follow = mData.FollowPeoples.Where(x => x.followingId.Equals(c.id)).FirstOrDefault();
                                              if (follow != null)
                                              {
                                                  btnFollow1 = "Unfollow";
                                                  btnFollowClass1 = "clsUnFollow";
                                              }
                                       %>
                                       <% var fbuttonID = "NearFollow_" + c.id.ToString(); %>
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
                                       <% var mbuttonID = "NearMute_" + c.id.ToString(); %>
                                       <input class="<%=btnMuteClass1 %>" name="btnMute" type="submit" id="<%=mbuttonID%>" value="<%=btnMute1 %>" />
                                       <%
                                          }%>
                                   </span>
                            </div>
                        </td>
                    </tr>
                </table><span class="shades2" ></span>
                <%
    });
})
           .Footer(false)
           .Render();
                          }
                          else
                          {
                              Response.Write("<div class='errpgmessage'>  Sorry, no user found nearby you ! </div>");
                          }
                      }  %></div>
            <%});
               }).SelectedIndex(0).Render();
            %></div>
    </div>
    <!--content-rounded-top-->
    </div>
    <!--contentarea-->
</asp:Content>
