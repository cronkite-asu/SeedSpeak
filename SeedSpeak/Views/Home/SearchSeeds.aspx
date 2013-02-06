<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Register Src="~/Views/Seed/ReplySeed.ascx" TagName="ReplySeed" TagPrefix="SeedSpeakUC" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    SearchSeeds
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function PlayerSetupFunction(pathVideo, pathDiv) {
            jwplayer(pathDiv).setup({
                flashplayer: '../../jwPlayer/player.swf',
                file: pathVideo,
                controlbar: 'over',
                fullscreen: 'true',
                stretching: 'fill',
                image: '../../jwPlayer/SeedSpeakBanner.jpg',
                skin: '../../jwPlayer/whotube.zip',
                height: 350//,
                //width: 730
            });
        }

        function callStreamWindow() {            
            var w = $('#CreateStreamMiniWindow').data('tWindow');
            w.center().open();
        }

        function callReplySeedWindow(parent, root) {
            var w = $('#ReplySeedWindow').data('tWindow');
            var getRootTxt = document.getElementById(root);
            var getParentTxt = document.getElementById(parent);
            var postRootTxt = document.getElementById('RplRootSeedID');
            var postParentTxt = document.getElementById('RplParentSeedID');
            postRootTxt.value = getRootTxt.value;
            postParentTxt.value = getParentTxt.value;
            w.center().open();
        }

        function ClearTxtComment() {
            $('#gridbox').find('textarea').val("");
        }

        $(function () {
            $('.bubbleInfo').each(function () {
                var distance = 10;
                var time = 250;
                var hideDelay = 500;

                var hideDelayTimer = null;

                var beingShown = false;
                var shown = false;
                var trigger = $('.trigger', this);
                var info = $('.popup', this).css('opacity', 0);


                $([trigger.get(0), info.get(0)]).mouseover(function () {
                    if (hideDelayTimer) clearTimeout(hideDelayTimer);
                    if (beingShown || shown) {
                        // don't trigger the animation again
                        return;
                    } else {
                        // reset position of info box
                        beingShown = true;

                        info.css({
                            top: -90,
                            left: -33,
                            display: 'block'
                        }).animate({
                            top: '-=' + distance + 'px',
                            opacity: 1
                        }, time, 'swing', function () {
                            beingShown = false;
                            shown = true;
                        });
                    }

                    return false;
                }).mouseout(function () {
                    if (hideDelayTimer) clearTimeout(hideDelayTimer);
                    hideDelayTimer = setTimeout(function () {
                        hideDelayTimer = null;
                        info.animate({
                            top: '-=' + distance + 'px',
                            opacity: 0
                        }, time, 'swing', function () {
                            shown = false;
                            info.css('display', 'none');
                        });

                    }, hideDelay);

                    return false;
                });
            });
        });

        function showonlyone(thechosenone) {
            var newboxes = document.getElementsByTagName("div");
            for (var x = 0; x < newboxes.length; x++) {
                name = newboxes[x].getAttribute("name");
                if (name == 'newboxes') {
                    if (newboxes[x].id == thechosenone) {
                        if (newboxes[x].style.display == 'none') {
                            newboxes[x].style.display = 'block';
                        }
                        else {
                            newboxes[x].style.display = 'none';
                        }
                    }
                    else {
                        newboxes[x].style.display = 'none';
                    }
                }
            }
        }

        function commentTXT(clientId, divId) {
            if (document.getElementById(clientId).value == "" || document.getElementById(clientId).value == null) {
                document.getElementById(divId).innerHTML = "<span>Please enter some comment, it can't be left blank.</span>";
                return false;
            }
            else {
                return true;
            }
        }

        function ClearErrMsg(divId) {
            document.getElementById(divId).innerHTML = "";
        }

        $(document).ready(function () {
            //When you click on a link with class of poplight and the href starts with a # 
            $('a.poplight[href^=#]').click(function () {
                var popID = $(this).attr('rel'); //Get Popup Name
                var popURL = $(this).attr('href'); //Get Popup href to define size

                //Pull Query & Variables from href URL
                var query = popURL.split('?');
                var dim = query[1].split('&');
                var popWidth = dim[0].split('=')[1]; //Gets the first query string value

                //Fade in the Popup and add close button
                //$('#' + popID).fadeIn().css({ 'width': Number(popWidth) }).prepend('<a href="#" class="close"><img src="../../Content/images/mclose.png" class="btn_close" title="Close Window" alt="Close" /></a>');

                $('#' + popID).fadeIn().css({ 'width': 'auto' }).prepend('<a href="#" class="close"><img src="../../Content/images/mclose.png" class="btn_close" title="Close Window" alt="Close" /></a>');

                //Define margin for center alignment (vertical + horizontal) - we add 80 to the height/width to accomodate for the padding + border width defined in the css
                var popMargTop = ($('#' + popID).height() + 80) / 2;
                var popMargLeft = ($('#' + popID).width() + 80) / 2;

                //Apply Margin to Popup
                $('#' + popID).css({
                    'margin-top': -popMargTop,
                    'margin-left': -popMargLeft
                });

                //Fade in Background
                $('body').append('<div id="fade"></div>'); //Add the fade layer to bottom of the body tag.
                $('#fade').css({ 'filter': 'alpha(opacity=80)' }).fadeIn(); //Fade in the fade layer 

                return false;
            });


            //Close Popups and Fade Layer
            $('a.close, #fade').live('click', function () { //When clicking on the close or fade layer...
                $('#fade , .popup_block').fadeOut(function () {
                    $('#fade, a.close').remove();
                }); //fade them both out
                return false;
            });
        });

        $(document).ready(function () {
            $(".clsFollow,.clsUnFollow").click(function () {
                var cUserID = $(this).attr('id').split('_');
                var buttonID = $(this).attr('id');
                var cUser = cUserID[1];
                var cValue = $(this).attr('value');
                $.getJSON("/Member/FollowUnfollow/?followingId=" + cUser + "&btnAction=" + cValue, function (data) {
                    if (data.toString() != "") {
                        if (data.toString() == "Follow") {
                            $('[id^="' + buttonID + '"]').attr("class", "clsFollow");
                        }

                        if (data.toString() == "Unfollow") {
                            $('[id^="' + buttonID + '"]').attr("class", "clsUnFollow");
                        }
                        $('[id^="' + buttonID + '"]').val(data.toString());
                    }
                });
            });

            $(".clsMute,.clsUnMute").click(function () {
                var cUserID = $(this).attr('id').split('_');
                var buttonID = $(this).attr('id');
                var cUser = cUserID[1];
                var cValue = $(this).attr('value');
                $.getJSON("/Member/MuteUnMute/?muteId=" + cUser + "&btnAction=" + cValue, function (data) {
                    if (data.toString() != "") {
                        if (data.toString() == "Mute") {
                            $('[id^="' + buttonID + '"]').attr("class", "clsMute");
                        }
                        if (data.toString() == "Unmute") {
                            $('[id^="' + buttonID + '"]').attr("class", "clsUnMute");
                        }
                        $('[id^="' + buttonID + '"]').val(data.toString());
                    }
                });
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="vdocontent">
        <div class="vdocontent-top">
        </div>
        <div class="vdocontent-bottom">
            <span class="pageheader">Discover</span>
            <%
                SeedSpeak.Model.Member mData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
            %>
            <div class="fullwidthcol">
                <% 
                    if (ViewData["SearchSeeds"] != null)
                    {
                        IList<SeedSpeak.Model.Seed> objSeed = (List<SeedSpeak.Model.Seed>)ViewData["SearchSeeds"];
                        if (objSeed.Count > 0)
                        {
                            Html.Telerik().Grid<SeedSpeak.Model.Seed>("SearchSeeds")
                           .Name("gridSearchSeeds")
                           .Columns(columns =>
                               {
                                   columns.Template(c =>
                                   {
                %>
                <div class="gridcontent">
                    <h3>
                        <%if (mData != null)
                          { %>
                        <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">
                            <abbr>
                                <%=c.title%></abbr></a>
                        <%}
                          else
                          { %>
                        <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                            <abbr>
                                <%=c.title%>
                            </abbr>
                        </a>
                        <%} %>
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
                            <% if (mData != null)
                               { %>
                            <a href="/Member/UserDetail/<%= c.Member.id %>">
                                <img alt="User Image" src="<%= imagePath %>" width="40" height="40" /></a>
                            <div class="bubbleInfo">
                                <a href="/Member/UserDetail/<%= c.Member.id %>"><span class="trigger">
                                    <%= dispName%></span> </a>
                                <div id="dpop" class="popup">
                                    <table border="0" width="150px" style="margin: auto">
                                        <tr>
                                            <td colspan="2" align="center" style="padding-top: 5px">
                                                <a href="/Member/UserDetail/<%= c.Member.id %>">Visit Profile ></a>
                                            </td>
                                        </tr>
                                        <% if (c.Member.id != mData.id)
                                           { %>
                                        <tr>
                                            <td align="right">
                                                <% string btnBbleFollow = "Follow";
                                                   string btnFollowClass = "clsFollow";
                                                   SeedSpeak.Model.FollowPeople Bblefollow = mData.FollowPeoples.Where(x => x.followingId.Equals(c.Member.id)).FirstOrDefault();
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
                                                   SeedSpeak.Model.MutePeople Bblemute = mData.MutePeoples.Where(x => x.muteId.Equals(c.Member.id)).FirstOrDefault();
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
                            </div>
                            <%}
                               else
                               { %>
                            <a style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                <img alt="User Image" src="<%= imagePath %>" width="40" height="40" /></a> <a style="cursor: pointer;"
                                    onclick="javascript:callLoginPartialWindow(0);"><span>
                                        <%= dispName%></span></a>
                            <%}
                               string catList = "";
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
                               }
                                      
                            %><b>&nbsp;on
                                <% DateTime dt = Convert.ToDateTime(c.createDate);
                                %>
                                <%: dt.ToShortDateString()%>,
                                <%=catList%>,&nbsp;</b><span style="color: #0F597F !important; float: left; font-size: 12px;
                                    font-weight: bold; height: 30px; padding-top: 10px;">
                                    <%=c.Location.City.name%></span><b>,
                                        <%=c.seedDistance%>
                                        miles</b></small>
                    </h3>
                    <%if (mData != null)
                      {
                          if (mData.id == c.ownerId)
                          {
                    %>
                    <div class="rightbtn">
                        
                    </div>
                    <%}
              }%>
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
                              { %>
                            <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">...more</a>
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
                    <div class="clear">
                    </div>
                    <div class="uimgbox">
                        <% IList<SeedSpeak.Model.Medium> lstMedia = c.Media.Take(3).OrderByDescending(x => x.dateUploaded).ToList();
                           if (lstMedia.Count > 0)
                           {

                               foreach (SeedSpeak.Model.Medium m in lstMedia)
                               {
                                   if (m.type == SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)
                                   {
                        %>
                        <a href="#?w=735" rel="popupImage<%=m.id%>" class="poplight">
                            <img alt="<%= m.title %>" src="<%= m.path %>" width="53" height="53" /></a>
                        <div id="popupImage<%=m.id%>" class="popup_block">
                            <img alt="<%= m.title %>" src="<%= m.path %>" width="400" height="350" />
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
                                <% if (mData != null)
                                   { %>
                                <a style="cursor: pointer;" onclick="callAddtoStreamPartialWindow('<%=c.id.ToString()%>')">
                                    Add to List</a>
                                <%}
                                   else
                                   { %>
                                <a style="cursor: pointer;" onclick="callLoginPartialWindow(0);">Add to List</a>
                                <%} %>
                            </div>
                            <% string divId0 = "LikeBox" + c.id.ToString(); %>
                            <div class="L" title="Liked">
                                <a id="myHeader1" href="javascript:showonlyone('<%=divId0 %>');">
                                    <%=c.Ratings.Where(x => x.likes.Equals(SeedSpeak.Util.SystemStatements.SEEDS_LIKE)).ToList().Count%></a>
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
                                   string replyCount = objSeedAction.GetReplySeedCount(c.id.ToString());
                                   if (mData != null)
                                   { %>
                                <a id="myHeader4" style="cursor: pointer;" onclick="javascript:callReplySeedWindow('thisParentSeedID<%=divId2%>', 'thisRootSeedID<%=divId2%>');">
                                    <%=replyCount%></a>
                                <%}
                           else
                           { %>
                                <a id="myHeader4" style="cursor: pointer;" onclick="javascript:callLoginPartialWindow(0);">
                                    <%=replyCount%></a>
                                <%} %>
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
                        <% if (mData != null)
                           { %>
                        <a style="cursor: pointer; color: #296b8c; padding-bottom: 0px; font-weight: bold"
                            href="/Member/UserDetail/<%= rate.Member.id %>">
                            <%= likeRatedBy%>
                        </a>
                        <%}
                           else
                           { %>
                        <a style="cursor: pointer; color: #296b8c; padding-bottom: 0px; font-weight: bold"
                            onclick="javascript:callLoginPartialWindow(0);">
                            <%= likeRatedBy%>
                        </a>
                        <%} %>
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
                        <%if (mData != null)
                          { %>
                        <div class="clear">
                        </div>
                        <%using (Ajax.BeginForm("AddCommentAtHomePage", "Member", new AjaxOptions { UpdateTargetId = "SeedComments" + divId, LoadingElementId = "updatingComments" + divId, OnSuccess = "ClearTxtComment" }))
                          {%>
                        <div id="updatingComments<%=divId %>" style="display: none">
                            Please wait .......</div>
                        <div class="error-container-comment">
                        </div>
                        <%: Html.Hidden("SCid", c.id.ToString())%>
                        <textarea id="Text<%=c.id %>" name="commentValue" rows="2" cols="2" class="curvetextarea"
                            onclick="javascript:ClearErrMsg('ErrMsg<%=c.id %>');"></textarea>
                        <br />
                        <input type="submit" value="" class="post" onclick="javascript:return commentTXT('Text<%=c.id %>','ErrMsg<%=c.id %>');" />
                        <div id="ErrMsg<%=c.id %>" class="errormssg" style="width: 98%; margin-left: 10px;
                            margin-top: 6px;">
                        </div>
                        <%}
                  } %>
                    </div>
                </div>
                <div style="clear: both;">
                </div>
                <span class="shades" ></span>
                <%
                           }).Title("Seeds");
                       })
                       .Pageable(paging => paging.PageSize(10))
      .Footer(true)
      .Render();
                }
                else
                {
                    Response.Write("<div class='errpgmessage'>No result found for your search query</div>");
                }
            }
            else
            {
                Response.Write("<div class='errpgmessage'>No result found for your search query</div>");
            }
                %>
            </div>
        </div>
    </div>
    <%if (mData != null)
      { %>
    <div>
        <% Html.RenderPartial("AddtoStreamPartial"); %>
    </div>
    <div>
        <%  Html.Telerik().Window()
            .Name("ReplySeedWindow")
            .Title("Reply Seed")
            .Content(() =>
            {%>
        <div class="roundT">
        </div>
        <div class="rndM">
            <SeedSpeakUC:ReplySeed ID="reply2Seed" runat="server" />
        </div>
        <div class="roundB">
        </div>
        <%})
            .Width(950)
            .Height(600)
            .Modal(true)
            .Visible(false)
            .Render();
        %>
    </div>
    <%} %>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
</asp:Content>
