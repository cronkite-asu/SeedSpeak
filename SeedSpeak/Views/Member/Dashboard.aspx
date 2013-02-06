<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Dashboard
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .middle_link
        {
            color: #0F597F;
            font-size: 13px;
            margin-bottom: 5px;
        }
        .middle_link a:link, a:visited
        {
            color: #0F597F;
            font-size: 13px;
            margin-bottom: 5px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">    
    <% string[] DashCount = (string[])SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.DashboardCount); %>
    <div id="contentarea">
        <div class="stream-left-nav">
            <div id="navigation">
                <ul>
                    <li class="planNew"><a class="planNewWhite" href="/Member/NewSeed">Plant New</a> </li>
                    <li class="curr"><a href="/Member/Dashboard">My Seeds (<%=DashCount[0] %>)</a> </li>
                    <li class="common"><a href="/SeedStream/ListFeeds">My Feeds/Lists (<%=DashCount[1] %>)</a> </li>
                    <li class="common"><a href="/Member/People">My People (<%=DashCount[2] %>)</a></li>
                    <li class="navigation_buttom"><a href="/Member/NewestNearby">Newest Nearby (<%=DashCount[3] %>)</a></li>
                </ul>
            </div>
        </div>
        <!--navigation-->
        <div id="midcontent">
            <div class="content-rounded-top">
            </div>
            <!--content-rounded-top-->
            <div class="content-mid-bg">                
                <div class="clear">
                </div>
                <div class="containerTbs">
                    <table width="100%">
                        <tr>
                            <td>
                                <table width="100%">
                                    <tr>
                                        <td class="pageheader">
                                            My Seeds
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="commontxt">
                                            Keep track of your own Seeds and other ideas you're helping grow.
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="shade">
                                        </td>
                                    </tr>
                                    <tr>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>                                
                                <%
                                    string PlntCount = ViewData["PlantedSeedCount"].ToString();
                                    string CmtRplCount = ViewData["CommentsAndReplyCount"].ToString();
                                    string FavCount = ViewData["FavSeedsCount"].ToString();
                                %>
                                <% Html.Telerik().TabStrip()
           .Name("DashboardTab").Items(tabstrip =>
               {
                   tabstrip.Add().Text("My Planted Seeds" + " (" + PlntCount + ")")
                       .Content(() =>
                                   {%>
                                <div>
                                <%if (Convert.ToInt32(PlntCount) > 0)
                                  { %>
                                    <div id="sort">
                                        <table style="width: auto; margin-top: -5px">
                                            <tr>
                                                <td style="height: 40px; vertical-align: middle">
                                                    <b>Sort:</b>
                                                </td>
                                                <td>
                                                    <a href="/Member/Dashboard/Proximity">Proximity</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/Dashboard/Date">Date</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/Dashboard/Category">Category</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/Dashboard/Likes">Likes</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/Dashboard/Comments">Comments</a>
                                                </td>
                                                <td>
                                                    <a href="/Member/Dashboard/SeedReply">Seed Replies</a>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <% ViewData["ListSeed"] = ViewData["MyPlantedSeeds"];
                                       Html.RenderPartial("GridViewPartial", ViewData["ListSeed"]); %>
                                       <%}
                                  else
                                  {
                                      Response.Write("<div class='errpgmessage'>You did not planted any seed yet !</div>");
                                  } %>
                                </div>
                                <%});
                   tabstrip.Add()
                       .Text("My Comments and Replies" + " (" + CmtRplCount + ")")
                       .Content(() =>
                       {%>
                                <div class="fullwidthcol">
    <%  SeedSpeak.Model.Member mbrData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);

        if (ViewData["MyCommentsAndReply"] != null)
        {
            IList<SeedSpeak.Model.Seed> objSeed = (List<SeedSpeak.Model.Seed>)ViewData["MyCommentsAndReply"];
            if (objSeed.Count > 0)
            {
                Html.Telerik().Grid<SeedSpeak.Model.Seed>(objSeed)
               .Name("gridCmtReply")
               .Columns(columns =>
                   {
                       columns.Template(c =>
                       {
    %>
    <div class="gridcontent" id="grdBlock<%=c.id.ToString()%>">
        <h3>
            <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">
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
                
                    <div class="bubbleInfo">
                                            <a href="/Member/UserDetail/<%= c.Member.id %>"><span class="trigger">
                                                <%= dispName%></span> </a>
                                            <div id="dpop" class="popup">
                                                <table border="0" width="150px" style="margin: auto">
                                                    <tr>
                                                        <td style="height:20px" colspan="2" align="center">
                                                            <a href="/Member/UserDetail/<%= c.Member.id %>">Visit Profile ></a>
                                                        </td>
                                                    </tr>
                                                    <% if (c.Member.id != mbrData.id)
                                                       { %>
                                                    <tr>
                                                        <td align="right">
                                                            <% string btnBbleFollow = "Follow";
                                                               string btnFollowClass = "clsFollow";
                                                               SeedSpeak.Model.FollowPeople Bblefollow = mbrData.FollowPeoples.Where(x => x.followingId.Equals(c.Member.id)).FirstOrDefault();
                                                               if (Bblefollow != null)
                                                               {
                                                                   btnBbleFollow = "Unfollow";
                                                                   btnFollowClass = "clsUnFollow";
                                                               }
                                                               var BblefbuttonID = "BblefFollow_" + c.Member.id.ToString(); %>
                                                            <input class="<%=btnFollowClass %>" type="button" value="<%=btnBbleFollow %>" id="<%=BblefbuttonID%>" />
                                                        </td>
                                                        <td align="left">
                                                            <% string btnBbleMute = "Mute";
                                                               string btnMuteClass = "clsMute";
                                                               SeedSpeak.Model.MutePeople Bblemute = mbrData.MutePeoples.Where(x => x.muteId.Equals(c.Member.id)).FirstOrDefault();
                                                               if (Bblemute != null)
                                                               {
                                                                   btnBbleMute = "Unmute";
                                                                   btnMuteClass = "clsUnMute";
                                                               }
                                                               var BblembuttonID = "BblemFollow_" + c.Member.id.ToString(); %>
                                                            <input class="<%=btnMuteClass %>" type="button" value="<%=btnBbleMute %>" id="<%=BblembuttonID %>" />
                                                        </td>
                                                    </tr>
                                                    <%}
                                                       else
                                                       { %>
                                                    <tr>
                                                        <td align="center" colspan="2" style="color: Red; font-size: x-small;">
                                                            You can't follow
                                                            <br />
                                                            or mute yourself.
                                                        </td>
                                                    </tr>
                                                    <%} %>
                                                </table>
                                            </div>
                                        </div><%string catList = "";
                                                if (c.Categories.Count > 0)
                                                {
                                                    foreach (SeedSpeak.Model.Category catData in c.Categories)
                                                    {
                                                        catList = catList + catData.name + ", ";
                                                    }
                                                    catList = catList.TrimEnd(',', ' ');
                                                }
                                                else
                                                {
                                                    catList = "Uncategorized";
                                                } %>
                    <b>on
                        <% DateTime dt = Convert.ToDateTime(c.createDate);
                        %>
                        <%: dt.ToShortDateString()%>, <%=catList%>, &nbsp;</b>
                        <span style="color: #0F597F !important; float: left;
                                            font-size: 12px; font-weight: bold; height: 30px; padding-top: 10px;">
                                            <%=c.Location.City.name%></span></small>
        </h3>
        <%if (c.Member.id == mbrData.id)
          {%>
        <div class="rightbtn">
                <a style="cursor:pointer;" onclick="javascript:EditSeed('<%=c.id.ToString()%>');" title="Edit" class="btnedit"></a><a style="cursor:pointer;" title="Delete" class="btndelete"></a>
            </div>
            <%} %>
        <div class="clear">
        </div>
        <%if (c.parentSeedID != null)
          {
              SeedSpeak.BLL.SeedAction seedAction = new SeedSpeak.BLL.SeedAction();
              string seedName = seedAction.GetSeedNameBySeedId(c.parentSeedID.ToString());
                                       %>
                                       <span id="InReply">
                                In reply to "<%=seedName%>"</span>
                                <%} %>
        <div class="detail">
            <p>
                <% 
          string subString = "";
          if (c.description.Length > 250)
          {
              subString = c.description.Substring(0, 250);
              Response.Write(subString); %>
                <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">...more</a>
                <%}
          else
          {
              subString = c.description.ToString();
              Response.Write(subString);
          }
                %></p>
        </div>
        <div class="clear">
        </div>
        <div class="uimgbox">
            <% IList<SeedSpeak.Model.Medium> lstMedia = c.Media.Take(3).OrderByDescending(x => x.dateUploaded).ToList();
               if (lstMedia.Count > 0)
               {
                   foreach (SeedSpeak.Model.Medium m in lstMedia)
                   {
                       if (m.type == "Image")
                       {
            %>
            <a href="#?w=735" rel="popupImage<%=m.id%>" class="poplight">
                <img alt="<%= m.title %>" src="<%= m.path %>" width="53" height="53" /></a>
            <div id="popupImage<%=m.id%>" class="popup_block">
                <img alt="<%= m.title %>" src="<%= m.path %>" width="400" height="350" class="popimg_big" />
            </div>
            <%}
                       else
                       { %>
            <a href="#?w=735" rel="popupVideo<%=m.id%>" class="poplight" onclick="PlayerSetupFunction('<%= m.path %>','mediaspace<%= m.id %>')">
                <img alt="<%= m.title %>" src="../../Content/images/vediimg.jpg" width="53" height="53;border:0px;" /></a>
            <div id="popupVideo<%=m.id%>" class="popup_block">
                <div id="mediaspace<%=m.id%>">
                    Loading jw player....</div>
            </div>
            <%}
                   }
               }%>
        </div>
        <div class="clear">
        </div>
        <div class="userInput">
            <div class="uleft" style="margin-top: 10px">
                <div>
                    <a class="hide" href="#">Hide </a>
                </div>
                <div>
                    <a class="flag" href="#">Flag </a>
                </div>
            </div>
            <div class="uright">
                <div class="Al" title="Add to List" style="width: 105px">
                    <a style="cursor:pointer;" onclick="callAddtoStreamPartialWindow('<%=c.id.ToString()%>')">Add to List</a></div>
                <% string divId0 = "LikeBox" + c.id.ToString(); %>
                <div class="L" title="Liked">
                    <a id="myHeader1" href="javascript:showonlyone('<%=divId0 %>');">
                        <%=c.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count%></a>
                </div>
                <% string divId = "commentBox" + c.id.ToString(); %>
                <div class="Cm" title="Comments">
                    <a id="myHeader3" href="javascript:showonlyone('<%=divId %>');">
                        <%=c.Comments.ToList().Count%></a>
                </div>
                <% string divId2 = "replyBox" + c.id.ToString(); %>
                <div class="Rm" title="Reply Seed">
                    <%: Html.Hidden("thisParentSeedID" + divId2, c.id.ToString())%>
                    <%: Html.Hidden("thisRootSeedID" + divId2, c.rootSeedID != null ? c.rootSeedID.ToString() : c.id.ToString())%>
                    <% SeedSpeak.BLL.SeedAction objSeedAction = new SeedSpeak.BLL.SeedAction();
                       string replyCount = objSeedAction.GetReplySeedCount(c.id.ToString()); %>
                    <a id="myHeader4" style="cursor: pointer;" onclick="javascript:callReplySeedWindow('thisParentSeedID<%=divId2%>', 'thisRootSeedID<%=divId2%>');">
                        <%=replyCount%></a>
                </div>
            </div>
        </div>
        <div class="clear">
        </div>
        <div name="newboxes" id="<%=divId0 %>" style="display: none;" class="newbox">
            <%
if (c.Ratings.Count > 0)
{
    IList<SeedSpeak.Model.Rating> objRate = c.Ratings.Where(x => x.likes.Equals(SeedSpeak.Util.SystemStatements.SEEDS_LIKE)).ToList();
    if (objRate.Count > 0)
    {
            %>
            <% int lkeCount = 0;
               foreach (SeedSpeak.Model.Rating rate in objRate)
               {
                   string likeRatedBy = rate.Member.organisationName != null ? rate.Member.organisationName.ToString() : (rate.Member.firstName + " " + rate.Member.lastName).ToString();
                   if (lkeCount != 0)
                       Response.Write(", ");
                   lkeCount++;
            %>
            <a style="cursor: pointer; color: #296b8c; padding-bottom: 0px; font-weight: bold"
                href="/Member/UserDetail/<%= rate.Member.id %>">
                <%= likeRatedBy%>
            </a>
            <% } %>Likes this seed
            <%}
}
else
{
    Response.Write("<h5>No Likes Yet. Be the first to like this seed !</h5>");
}
            %>
            <% using (Html.BeginForm("AddComment", "Seed",
                    FormMethod.Post, new { enctype = "multipart/form-data", id = "FrmSample" }))
               {%>
            <%: Html.Hidden("version", "SeedSpeak Phase 2")%>
            <%} %>
        </div>
        
        <div name="newboxes" id="<%=divId %>" style="display: none;" class="newbox">
            
            <div id="SeedComments<%=divId %>">
                <% ViewData["commentId"] = c.id.ToString(); %>
                <% Html.RenderPartial("CommentPartial"); %>
            </div>
            <div class="clear">
            </div>
            <%using (Ajax.BeginForm("AddCommentAtHomePage", "Member", new AjaxOptions { UpdateTargetId = "SeedComments" + divId, LoadingElementId = "updatingComments" + divId, OnSuccess = "ClearTxtComment" }))
              {%>
            <div id="updatingComments<%=divId %>" style="display: none">
                Please wait .......</div>
            <%: Html.Hidden("SCid", c.id.ToString())%>
            <textarea id="Text<%=c.id %>" name="commentValue" rows="2" cols="2" class="curvetextarea"
                onclick="javascript:ClearErrMsg('ErrMsg<%=c.id %>');"></textarea>
            <br />
            <input type="submit" value="" class="post" onclick="javascript:return commentTXT('Text<%=c.id %>','ErrMsg<%=c.id %>');" />
            <div id="ErrMsg<%=c.id %>" class="errormssg" style="width: 98%; margin-left: 10px;
                margin-top: 6px;">
            </div>
            <%} %>
        </div>
    <div style="clear: both;"></div>
                            </div><span class="shades" ></span>
    <%}).Title("Seeds");
                   })
                                   .Pageable(paging => paging.PageSize(5))
      .Footer(true)
      .Render();
            }
            else
            {
                Response.Write("<div class='errpgmessage'>You did not commented or replied to any seed yet !</div>");
            }
        }
        else
        {
            Response.Write("<div class='errpgmessage'>You did not commented or replied to any seed yet !</div>");
        }
    %>
</div>
                                <%});
                   tabstrip.Add()
                       .Text("Seeds I Like" + " (" + FavCount + ")")
                       .Content(() =>
                           {
                                %>
                                <div class="fullwidthcol">
    <%  SeedSpeak.Model.Member mbrData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);

        if (ViewData["MyFavSeeds"] != null)
        {
            IList<SeedSpeak.Model.Seed> objSeed = (List<SeedSpeak.Model.Seed>)ViewData["MyFavSeeds"];
            if (objSeed.Count > 0)
            {
                Html.Telerik().Grid<SeedSpeak.Model.Seed>(objSeed)
               .Name("gridFavs")
               .Columns(columns =>
                   {
                       columns.Template(c =>
                       {
    %>
    <div class="gridcontent" id="grdBlock<%=c.id.ToString()%>">
        <h3>
            <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">
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
                
                    <div class="bubbleInfo">
                                            <a href="/Member/UserDetail/<%= c.Member.id %>"><span class="trigger">
                                                <%= dispName%></span> </a>
                                            <div id="dpop" class="popup">
                                                <table border="0" width="150px" style="margin: auto">
                                                    <tr>
                                                        <td colspan="2" align="center">
                                                            <a href="/Member/UserDetail/<%= c.Member.id %>">Visit Profile ></a>
                                                        </td>
                                                    </tr>
                                                    <% if (c.Member.id != mbrData.id)
                                                       { %>
                                                    <tr>
                                                        <td align="right">
                                                            <% string btnBbleFollow = "Follow";
                                                               string btnFollowClass = "clsFollow";
                                                               SeedSpeak.Model.FollowPeople Bblefollow = mbrData.FollowPeoples.Where(x => x.followingId.Equals(c.Member.id)).FirstOrDefault();
                                                               if (Bblefollow != null)
                                                               {
                                                                   btnBbleFollow = "Unfollow";
                                                                   btnFollowClass = "clsUnFollow";
                                                               }
                                                               var BblefbuttonID = "BblefFollow_" + c.Member.id.ToString(); %>
                                                            <input class="<%=btnFollowClass %>" type="button" value="<%=btnBbleFollow %>" id="<%=BblefbuttonID%>" />
                                                        </td>
                                                        <td align="left">
                                                            <% string btnBbleMute = "Mute";
                                                               string btnMuteClass = "clsMute";
                                                               SeedSpeak.Model.MutePeople Bblemute = mbrData.MutePeoples.Where(x => x.muteId.Equals(c.Member.id)).FirstOrDefault();
                                                               if (Bblemute != null)
                                                               {
                                                                   btnBbleMute = "Unmute";
                                                                   btnMuteClass = "clsUnMute";
                                                               }
                                                               var BblembuttonID = "BblemFollow_" + c.Member.id.ToString(); %>
                                                            <input class="<%=btnMuteClass %>" type="button" value="<%=btnBbleMute %>" id="<%=BblembuttonID %>" />
                                                        </td>
                                                    </tr>
                                                    <%}
                                                       else
                                                       { %>
                                                    <tr>
                                                        <td align="center" colspan="2" style="color: Red; font-size: x-small;">
                                                            You can't follow
                                                            <br />
                                                            or mute yourself.
                                                        </td>
                                                    </tr>
                                                    <%} %>
                                                </table>
                                            </div>
                                        </div><%string catList = "";
                                                if (c.Categories.Count > 0)
                                                {
                                                    foreach (SeedSpeak.Model.Category catData in c.Categories)
                                                    {
                                                        catList = catList + catData.name + ", ";
                                                    }
                                                    catList = catList.TrimEnd(',', ' ');
                                                }
                                                else
                                                {
                                                    catList = "Uncategorized";
                                                } %>
                    <b>on
                        <% DateTime dt = Convert.ToDateTime(c.createDate);
                        %>
                        <%: dt.ToShortDateString()%>, <%=catList%>, &nbsp;</b>
                        <span style="color: #0F597F !important; float: left;
                                            font-size: 12px; font-weight: bold; height: 30px; padding-top: 10px;">
                                            <%=c.Location.City.name%></span></small>
        </h3>
        <%if (c.Member.id == mbrData.id)
          {%>
        <div class="rightbtn">
                <a style="cursor:pointer;" onclick="javascript:EditSeed('<%=c.id.ToString()%>');" title="Edit" class="btnedit"></a><a style="cursor:pointer;" title="Delete" class="btndelete"></a>
            </div>
            <%} %>
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
                <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">...more</a>
                <%}
          else
          {
              subString = c.description.ToString();
              Response.Write(subString);
          }
                %></p>
        </div>
        <div class="clear">
        </div>
        <div class="uimgbox">
            <% IList<SeedSpeak.Model.Medium> lstMedia = c.Media.Take(3).OrderByDescending(x => x.dateUploaded).ToList();
               if (lstMedia.Count > 0)
               {
                   foreach (SeedSpeak.Model.Medium m in lstMedia)
                   {
                       if (m.type == "Image")
                       {
            %>
            <a href="#?w=735" rel="popupImage<%=m.id%>" class="poplight">
                <img alt="<%= m.title %>" src="<%= m.path %>" width="53" height="53" /></a>
            <div id="popupImage<%=m.id%>" class="popup_block">
                <img alt="<%= m.title %>" src="<%= m.path %>" width="400" height="350" class="popimg_big" />
            </div>
            <%}
                       else
                       { %>
            <a href="#?w=735" rel="popupVideo<%=m.id%>" class="poplight" onclick="PlayerSetupFunction('<%= m.path %>','mediaspace<%= m.id %>')">
                <img alt="<%= m.title %>" src="../../Content/images/vediimg.jpg" width="53" height="53;border:0px;" /></a>
            <div id="popupVideo<%=m.id%>" class="popup_block">
                <div id="mediaspace<%=m.id%>">
                    Loading jw player....</div>
            </div>
            <%}
                   }
               }%>
        </div>
        <div class="clear">
        </div>
        <div class="userInput">
            <div class="uleft" style="margin-top: 10px">
                <div>
                    <a class="hide" href="#">Hide </a>
                </div>
                <div>
                    <a class="flag" href="#">Flag </a>
                </div>
            </div>
            <div class="uright">
                <div class="Al" title="Add to List" style="width: 105px">
                    <a style="cursor:pointer;" onclick="callAddtoStreamPartialWindow('<%=c.id.ToString()%>')">Add to List</a></div>
                <% string divId0 = "LikeBox" + c.id.ToString(); %>
                <div class="L" title="Liked">
                    <a id="myHeader1" href="javascript:showonlyone('<%=divId0 %>');">
                        <%=c.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count%></a>
                </div>
                <% string divId = "commentBox" + c.id.ToString(); %>
                <div class="Cm" title="Comments">
                    <a id="myHeader3" href="javascript:showonlyone('<%=divId %>');">
                        <%=c.Comments.ToList().Count%></a>
                </div>
                <% string divId2 = "replyBox" + c.id.ToString(); %>
                <div class="Rm" title="Reply Seed">
                    <%: Html.Hidden("thisParentSeedID" + divId2, c.id.ToString())%>
                    <%: Html.Hidden("thisRootSeedID" + divId2, c.rootSeedID != null ? c.rootSeedID.ToString() : c.id.ToString())%>
                    <% SeedSpeak.BLL.SeedAction objSeedAction = new SeedSpeak.BLL.SeedAction();
                       string replyCount = objSeedAction.GetReplySeedCount(c.id.ToString()); %>
                    <a id="myHeader4" style="cursor: pointer;" onclick="javascript:callReplySeedWindow('thisParentSeedID<%=divId2%>', 'thisRootSeedID<%=divId2%>');">
                        <%=replyCount%></a>
                </div>
            </div>
        </div>
        <div class="clear">
        </div>
        <div name="newboxes" id="<%=divId0 %>" style="display: none;" class="newbox">
            <%
if (c.Ratings.Count > 0)
{
    IList<SeedSpeak.Model.Rating> objRate = c.Ratings.Where(x => x.likes.Equals(SeedSpeak.Util.SystemStatements.SEEDS_LIKE)).ToList();
    if (objRate.Count > 0)
    {
            %>
            <% int lkeCount = 0;
               foreach (SeedSpeak.Model.Rating rate in objRate)
               {
                   string likeRatedBy = rate.Member.organisationName != null ? rate.Member.organisationName.ToString() : (rate.Member.firstName + " " + rate.Member.lastName).ToString();
                   if (lkeCount != 0)
                       Response.Write(", ");
                   lkeCount++;
            %>
            <a style="cursor: pointer; color: #296b8c; padding-bottom: 0px; font-weight: bold"
                href="/Member/UserDetail/<%= rate.Member.id %>">
                <%= likeRatedBy%>
            </a>
            <% } %>Likes this seed
            <%}
}
else
{
    Response.Write("<h5>No Likes Yet. Be the first to like this seed !</h5>");
}
            %>
            <% using (Html.BeginForm("AddComment", "Seed",
                    FormMethod.Post, new { enctype = "multipart/form-data", id = "FrmSample" }))
               {%>
            <%: Html.Hidden("version", "SeedSpeak Phase 2")%>
            <%} %>
        </div>
        
        <div name="newboxes" id="<%=divId %>" style="display: none;" class="newbox">
            
            <div id="SeedComments<%=divId %>">
                <% ViewData["commentId"] = c.id.ToString(); %>
                <% Html.RenderPartial("CommentPartial"); %>
            </div>
            <div class="clear">
            </div>
            <%using (Ajax.BeginForm("AddCommentAtHomePage", "Member", new AjaxOptions { UpdateTargetId = "SeedComments" + divId, LoadingElementId = "updatingComments" + divId, OnSuccess = "ClearTxtComment" }))
              {%>
            <div id="updatingComments<%=divId %>" style="display: none">
                Please wait .......</div>
            <%: Html.Hidden("SCid", c.id.ToString())%>
            <textarea id="Text<%=c.id %>" name="commentValue" rows="2" cols="2" class="curvetextarea"
                onclick="javascript:ClearErrMsg('ErrMsg<%=c.id %>');"></textarea>
            <br />
            <input type="submit" value="" class="post" onclick="javascript:return commentTXT('Text<%=c.id %>','ErrMsg<%=c.id %>');" />
            <div id="ErrMsg<%=c.id %>" class="errormssg" style="width: 98%; margin-left: 10px;
                margin-top: 6px;">
            </div>
            <%} %>
        </div>
    </div><span class="shades" ></span>
    <%}).Title("Seeds");
                   })
                                   .Pageable(paging => paging.PageSize(5))
      .Footer(true)
      .Render();
            }
            else
            {
                Response.Write("<div class='errpgmessage'>You did not liked any seed yet !</div>");
            }
        }
        else
        {
            Response.Write("<div class='errpgmessage'>You did not liked any seed yet !</div>");
        }
    %>
</div>
                                <%
                           });
               }).SelectedIndex(Convert.ToInt32(ViewData["SelectedIndex"].ToString())).Render();
                                %>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!--content-rounded-top-->
            <div class="content-bottom">
            </div>
        </div>
        <!--content-->
    </div>
</asp:Content>
