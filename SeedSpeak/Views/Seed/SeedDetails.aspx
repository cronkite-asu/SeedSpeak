<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Register Src="~/Views/Seed/AddSeed.ascx" TagName="AddSeed" TagPrefix="uc1" %>
<%@ Register Src="~/Views/Seed/PlantSeedLocation.ascx" TagName="PlantSeed" TagPrefix="uc2" %>
<%@ Register Src="~/Views/Seed/SeedInfo.ascx" TagName="SeedInfo" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Seed Details
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/jquery.ui.core.css" rel="stylesheet" type="text/css" />
    <link href="../../Content/jquery.ui.datepicker.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../../Scripts/jquery.ui.core.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.ui.widget.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.ui.datepicker.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.cycle.all.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.cycle.lite.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.cycle.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/csspopup.js"></script>
    <script src="../../jwPlayer/jwplayer.js" type="text/javascript"></script>
    <script src="../../jwPlayer/swfobject.js" type="text/javascript"></script>
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
    </script>
    <script type="text/javascript">
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
    </script>
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
    <script type="text/javascript">
        function centerWindow() {
            $("#FlagWindow").data("tWindow").center();
        }

        function closeFlagWindow() {
            $("#FlagWindow").data("tWindow").close();
        }

        function centerCommitWindow() {
            $("#CommitmentWindow").data("tWindow").center();
        }

        function centerCommentWindow() {
            $("#CommentWindow").data("tWindow").center();
        }

        function LikeDislike(seedId, ldType) {
            var spCountLike = document.getElementById('spCountLike');
            var likeCount = parseInt(spCountLike.innerHTML);
            var hdType = document.getElementById('hdType');
            var spType = document.getElementById('spType');
            var totalCount = document.getElementById('hdTotalCount').value;

            if (hdType.value == 'Like') {
                hdType.value = 'DLike';
                spType.innerHTML = 'Unlike';
                spType.className = 'dislike';

                $.getJSON("/Seed/LikeDislikeSeed/?id=" + seedId + "&LikeDisLike=Like",
                function (data) {
                    spCountLike.innerHTML = likeCount + 1;
                });
            }
            else {
                hdType.value = 'Like';
                spType.innerHTML = 'Like';
                spType.className = 'like';

                $.getJSON("/Seed/LikeDislikeSeed/?id=" + seedId + "&LikeDisLike=DLike",
                function (data) {
                    spCountLike.innerHTML = likeCount - 1;
                });
            }
            return true;
        }

        function centerLikeWindow() {
            $("#LikeWindow").data("tWindow").center();
        }

        function centerDislikeWindow() {
            $("#DislikeWindow").data("tWindow").center();
        }

        function centerCommitmentWindow() {
            $("#CommitmentNameWindow").data("tWindow").center();
        }

        function centerMailSeedWindow() {
            $("#mailSeedWindow").data("tWindow").center();
        }

        function callReplyWindow(parent, root) {
            var w = $('#ReplySeedWindow').data('tWindow');            
            var postRootTxt = document.getElementById('RplRootSeedID');
            var postParentTxt = document.getElementById('RplParentSeedID');
            postRootTxt.value = root;
            postParentTxt.value = parent;
            w.center().open();
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#FlagForm").validate({
                errorLabelContainer: $("ul", $('div.error-container3')),
                wrapper: 'li',
                rules: {
                    FlagReason: {
                        required: true
                    }
                },
                messages: {
                    FlagReason: {
                        required: " Please specify flagging reason"
                    }
                }
            });
        });

        $(document).ready(function () {
            $("#CommentForm").validate({
                errorLabelContainer: $("ul", $('div.error-container1')),
                wrapper: 'li',
                rules: {
                    Comment: {
                        required: true
                    }
                },
                messages: {
                    Comment: {
                        required: " Please specify comment"
                    }
                }
            });
        });

        $(document).ready(function () {
            $("#CommitmentForm").validate({
                errorLabelContainer: $("ul", $('div.error-container2')),
                wrapper: 'li',
                rules: {
                    Msg: {
                        required: true
                    },
                    Deadline: {
                        required: true
                    }
                },
                messages: {
                    Msg: {
                        required: " Please specify commitment message"
                    },
                    Deadline: {
                        required: " Please specify deadline"
                    }
                }
            });
        });

        $(document).ready(function () {
            $("#mailSeedForm").validate({
                errorLabelContainer: $("ul", $('div.error-containerMail')),
                wrapper: 'li',
                rules: {
                    eMail: {
                        required: true,
                        email: true
                    },
                    seedSubject: {
                        required: true
                    },
                    seedBody: {
                        required: true
                    }
                },
                messages: {
                    eMail: {
                        required: " Please specify email",
                        email: " Please insert valid email"
                    },
                    seedSubject: {
                        required: " Please specify mail subject"
                    },
                    seedBody: {
                        required: " Please specify content for mail"
                    }
                }
            });
        });
    </script>

    <style>
   form label{
    margin: 0 0 0px 10px;
   }
	   .bluerounded img {
    border: 0 solid #000000 ;
    float: left;
    margin: 0px;
    padding: 0px ;
}
.t-grid table {
	margin: auto;
	width: 100%;
	table-layout: fixed;
	width: 98%;
	border-collapse: separate;
	empty-cells: show; 
	
}
.t-grid-header .t-header {
	display: none;
	text-align: left;
}
.t-grid .t-state-hover {
	cursor: pointer;
}
.t-grid td {
	overflow: hidden;
	text-overflow: ellipsis;
	border-top: 0px solid #d8d9d9;
	border-left: 0px solid #d1d4d7;
	
}
.t-grid .t-last {
	float: left;
	width: 100%;
	background-color: transparent;
	padding-left: 6px;
	border: 0px solid #a5b4bd;
	margin-bottom: 0px;
	margin-top: 0px;
	padding: 10px; 
   
}
.t-grid .t-last:hover {
	float: left;
	width: 100%;
	padding-left: 6px;
	border: 0px solid #a5b4bd;
	padding: 10px;
	background-color: transparent;
	margin-bottom: 0px;
	margin-top: 0px;
}
</style>


    <% SeedSpeak.Model.Seed SeedDtl = (SeedSpeak.Model.Seed)ViewData["SeedDetails"]; %>
    <%if(ViewData["isFlagged"]=="FlaggedSeed")
      { %>
  <div class="msgBG">
  Thank You! This seed has been flagged for an admin.
  </div>
  <%} %>
    <div id="left_col">
        <div class="seedtool">
            <h2>
                &nbsp;</h2>
            <div class="actiontoolBox">
                <% SeedSpeak.Model.Member memberData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject); %>                
                <% if (SeedDtl.ownerId == memberData.id)
                   {
                %>                
                <span id="editseed" onclick="javascript:EditSeed('<%=SeedDtl.id %>')">Edit Seed</span>
                <br />
                <% } string ldType = string.Empty; string spClass = string.Empty; %>
                <% if (SeedDtl.ownerId != memberData.id)
                   {
                       string rootId = SeedDtl.rootSeedID != null ? SeedDtl.rootSeedID.ToString() : SeedDtl.id.ToString();
                       %>                
                    <span id="ReplyAnchor" style="cursor:pointer;" onclick="javascript:callReplyWindow('<%=SeedDtl.id %>','<%=rootId %>');">Reply</span>
                <span id="FlagAnchor">Flag</span><br />
                <%  
                    if (SeedDtl.Ratings.Where(x => x.memberId.Equals(memberData.id)).ToList().Count > 0)
                    {
                        if (SeedDtl.Ratings.FirstOrDefault().likes == "Like")
                        {
                            ldType = "Dislike";
                            spClass = "dislike";
                        }
                        else
                        {
                            ldType = "Like";
                            spClass = "like";
                        }
                    }
                    else
                    {
                        ldType = "Like";
                        spClass = "like";
                    }
                %>
                <a onclick="javascript:return LikeDislike('<%= SeedDtl.id %>','<%= ldType %>');"><span
                    id="spType" class="<%=spClass %>">
                    <%= ldType%></span></a><br />
                <input type="hidden" id="hdType" value="<%= ldType %>" />
                <% } %>
            </div>
            <span class="btmcurve"></span>
        </div>        
    </div>
    
        <div class="seedtitle">
            <div class="seedimgbox">
                <% 
                    string seedImage = "";
                    if (SeedDtl.Media.Where(x => x.type.Equals("Image")).FirstOrDefault() != null)
                    {
                        seedImage = SeedDtl.Media.Where(x => x.type.Equals("Image")).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path.ToString();

                        seedImage = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(seedImage);
                        if (System.IO.File.Exists(seedImage))
                            seedImage = SeedDtl.Media.Where(x => x.type.Equals("Image")).FirstOrDefault().path.ToString();
                        else
                            seedImage = "../../Content/images/seedicon.png";
                    }
                    else
                        seedImage = "../../Content/images/seedicon.png";
                %>
                <img alt="Seed Image" src="<%= seedImage %>" width="50px" height="40px" />
                <h3>
                    <%= SeedDtl.title %></h3>
                <div class="sitelink">
                            <!-- AddThis Button BEGIN -->
<div class="addthis_toolbox addthis_default_style ">
<a class="addthis_counter addthis_pill_style"></a>
</div>
<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4f4f3ae72952993d"></script>
<!-- AddThis Button END -->

                </div>
            </div>
        </div>
        <div id="page_content">
            <div class="innerMiddle">
                <div class="roundbox">
                
                    <% string addrss = SeedDtl.Location.City.name + ", " + SeedDtl.Location.City.Region.code + " " + SeedDtl.Location.zipcode + ", USA"; %>
                    <h4>
                        <%: Html.Label(addrss)%></h4>
                    <div class="clear">
                    </div>
                    <p class="textwrap">
                        <% Response.Write(SeedDtl.description); %>
                    </p>
                    <%: Html.Hidden("HiddenLat", SeedDtl.Location.localLat.ToString())%>
                    <%: Html.Hidden("HiddenLong",SeedDtl.Location.localLong.ToString()) %>
                    <br />
                    <div class="urec">
                        <% if (SeedDtl.Categories.Count > 0)
                           { %>
                        <span class="gray">Categories:&nbsp;</span>
                        
                        <% string catList = "";
                           foreach (SeedSpeak.Model.Category catData in SeedDtl.Categories)
                           {
                               catList = catList + catData.name + ", ";
                           }
                           catList = catList.TrimEnd(',', ' ');
                        %>
                        <%: Html.Label(catList)%>
                        <% }
                           else
                           { %>
                           <span class="gray">Categories :&nbsp;</span>Uncategorized
                           <%} %>
                        <br />
                        <% if (SeedDtl.Tags.Count > 0 && SeedDtl.Tags != null)
                           { %>
                         <span class="gray">Keywords: &nbsp;</span>
                        <%: Html.Label(SeedDtl.Tags.FirstOrDefault().name != null ? SeedDtl.Tags.FirstOrDefault().name : "")%>
                        <%} %></div>
                </div>
                <br />
                <div>
                    <% IList<SeedSpeak.Model.Rating> rate1 = SeedDtl.Ratings.Where(x => x.likes.Equals(SeedSpeak.Util.SystemStatements.SEEDS_LIKE)).ToList();
                       if (rate1.Count > 0)
                       {
                    %>
                    <div class="bluerounded">
                       <div style="padding:10px"> <% int lkeCount = 0;
                           foreach (SeedSpeak.Model.Rating objRate1 in rate1)
                           {
                               string likeRatedBy1 = objRate1.Member.organisationName != null ? objRate1.Member.organisationName.ToString() : (objRate1.Member.firstName + " " + objRate1.Member.lastName).ToString();
                               if (lkeCount != 0)
                                   Response.Write(", ");
                               lkeCount++;
                        %>
                        <a href="/Member/UserDetail/<%= objRate1.Member.id %>">
                            <%= likeRatedBy1%>
                        </a>
                        <% } %>Likes this seed</div>
                    </div>
                    <%} %>
                </div>
                <% if (ViewData["ContributionAuth"] == "True")
                   { %>
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
                        <span id="spanDetails" onclick="javascript:document.forms['SeedDetailForm'].submit();"
                            style="cursor: pointer; float:left">View All Comments (<%=SeedDtl.Comments.ToList().Count %>)</span><%}
                            }%>
                        <% if (ViewData["ContributionAuth"] == "True")
                           { %>
                        <span id="SpanAddComment" style="cursor: pointer; float:right">Add Comment</span>
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
                    
                 
                 <div class="projectbg">
                        <div class="projectthumnail">  <img alt="Comment By" src="<%= commenterImage %>" width="50" height="50" /></div>
                            <div class="projecttxtblank">
                                <div class="projecttxt"><span class="projectboldtxt"><% if (string.IsNullOrEmpty(c.Member.organisationName))
                               { %>
                            <a href="/Member/UserDetail/<%= c.Member.id %>">
                                <%: c.Member.firstName + " " + c.Member.lastName%></a>
                            <%}
                               else
                               { %><a href="/Member/UserDetail/<%= c.Member.id %>">
                                   <%: c.Member.organisationName%></a>
                            <%} %></span>  <%= c.msg %></div>
                                 <div class="projectdate">  <%
DateTime dtCreate = Convert.ToDateTime(c.commentDate);
TimeSpan diff = DateTime.Now.Subtract(dtCreate);
string result = "";
if (diff.Days > 0)
    result = diff.Days + " Days ";
if (diff.Hours > 0)
    result = result + diff.Hours + " Hours ";
result = result + diff.Minutes;
Response.Write(result + " minutes ago");
                            %></div>
                            </div>
                  
                                
                   
                      
                        <%
                            });
               })
           .Footer(false)
           .Render();
                        %>

                         </div>


                </div>
                <%} %></div>
        
        
        
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
                    <li class="like"><b><span>
                        <% int totalCount = SeedDtl.Ratings.ToList().Count;
                           int likeCount = SeedDtl.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count;
                        %>
                        <u>
                        <span id="spCountLike" style="cursor: pointer;">
                            <%=likeCount%></span></u></span></b> Members like this seed. </li>                    
                    <li class="comment"><b>
                    <% var commentQuery = from comDir in SeedDtl.Comments
                                          select new { comDir.Member.id }; %>
                        <%= commentQuery.Distinct().ToList().Count %>
                    </b>Members commented on this seed. </li>
                </ul>
                <input type="hidden" id="hdTotalCount" value="<%=totalCount %>" />
                <div class="clear"></div>
                <h2 class="Location">&nbsp;</h2>
                <div class="mapouter">
                    <div id="map_canvas" class="location" style="width:192px;"></div> 
                    
                </div>
                <div class="bdr">&nbsp;</div>
                <div class="clear"></div>
                
                <h2 class="Video">&nbsp;</h2>
                <div class="clear"></div>
                <div class="video">
                    <% IList<SeedSpeak.Model.Medium> objV = (List<SeedSpeak.Model.Medium>)ViewData["VList"];
                       if (objV.Count > 0)
                       {
                           foreach (SeedSpeak.Model.Medium w in (List<SeedSpeak.Model.Medium>)ViewData["VList"])
                           { %>
                    
                    <a href="#?w=735" rel="popupVideo" class="poplight" onclick="PlayerSetupFunction('<%= w.path %>','mediaspace')">
                                            <img alt="<%= w.title %>" src="../../Content/images/video-img.png" />
                                            </a>
                                        <div id="popupVideo" class="popup_block">
                                            <div id="mediaspace">
                                                Loading jw player....</div>
                                        </div>
                    <% }
                       }
                       else
                       {
                    %>
                    <img alt="No content added yet!" src="../../Content/images/novideo.png" 
                         />
                    <%}
                    %> <div class="clear">
                </div> 
                </div><div class="clear"></div>
                <div class="pictool">
                <% if (SeedDtl.ownerId == memberData.id)
                   {
                %>
                    <a href="/Seed/UploadVedioMedia/<%= SeedDtl.id %>">Add Video</a>&nbsp;<b>.</b><%} %>&nbsp;<a
                        href="/Seed/UploadVedioMedia/<%= SeedDtl.id %>">View More </a>
                </div>
                 <div class="bdr">&nbsp;</div>
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
                        <img alt="Default Image" src="../<%= w.path %>" width="190px" height="160px" />
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
                <% if (SeedDtl.ownerId == memberData.id)
                   {
                %>
                    <a href="/Seed/UploadMedia/<%= SeedDtl.id %>">Add Image</a>&nbsp;<b>.</b><%} %>&nbsp;<a
                        href="/Seed/UploadMedia/<%= SeedDtl.id %>">View More </a>
                </div>
            </div>
        </div>
    </div><div style="clear:both"></div>
    <div class="flagwindow">
        <% Html.Telerik().Window()
           .Name("FlagWindow")
           .Title("Reason to Flag")
           .ClientEvents(
              events =>
                events.OnLoad("centerWindow"))
           .Draggable(true)
           .Modal(true)
           .Buttons(b => b.Close())
           .Visible(false)
           .Content(() =>
           {%>
       <div style="margin:auto; width:90%">
            <% Html.BeginForm("FlagSeed", "Seed", FormMethod.Post, new { id = "FlagForm" }); %>
            <div class="error-container"></div>
            <h2>What's wrong with this seed?</h2>
            <input type="checkbox" id="chkSpam" name="chkSpam" value="Spam" /> Spam<br />
            <input type="checkbox" id="chkWrgCat" name="chkWrgCat" value="Wrong Category" /> Wrong Category<br />
            <input type="checkbox" id="chkProhibited" name="chkProhibited" value="Prohibited" /> Prohibited<br />
            <input type="checkbox" id="chkOther" name="chkOther" value="Other" /> Other (please describe)<ins style="float:right; margin-right:25px;">(Max 500 Characters)</ins><br />
            <%: Html.TextArea("FlagReason", new { style = "height:88px; width:92%; margin-bottom:15px", maxlength = 499 })%>
            <%: Html.Hidden("id", SeedDtl.id)%>
            <div style="float:right; margin-right:25px;"><input type="button" value="Cancel" class="cancelbtnGray" style="float:left" onclick="javascript:closeFlagWindow();" />
            <input type="submit" value="Submit Flag" class="editbtn" style="margin-left:5px;" /></div>
            
            
            <% Html.EndForm(); %>
       </div>
        <%})
           .Width(450)
           .Height(310)
           .Render();
        %>
    </div>
    <div>
        <% Html.Telerik().Window()
           .Name("CommentWindow")
           .Title("Comment")
           .ClientEvents(
              events =>
                events.OnLoad("centerCommentWindow"))
           .Draggable(true)
           .Modal(true)
           .Buttons(b => b.Close())
           .Visible(false)
           .Content(() =>
           {%>
        <div style="margin:auto; width:90%; margin-top:30px">
            <% Html.BeginForm("AddComment", "Seed", FormMethod.Post, new { id = "CommentForm" }); %>
            <div class="error-container1"></div>
    <label style="float: left; margin-top: 4px; "><h2>Add Comment</h2>
            <%: Html.TextArea("Comment", new { style = "margin-bottom:15px", maxlength = 499 })%>
            </label><br />
            <input type="submit" value="Add Comment" class="gbtn" /><ins>(Max 500 Characters)</ins>
             <%: Html.Hidden("Sid",SeedDtl.id) %>
            <% Html.EndForm(); %>
        </div>
        <%})
           .Width(450)
           .Height(250)
           .Render();
        %>
    </div>
    <div>
        <% Html.Telerik().Window()
           .Name("CommitmentWindow")
           .Title("Commitment")
           .ClientEvents(
              events =>
                events.OnLoad("centerCommitWindow"))
           .Draggable(true)
           .Modal(true)
           .Buttons(b => b.Close())
           .Visible(false)
           .Content(() =>
           {%>
        <div class="commitwindow">
            <% Html.BeginForm("AddCommitment", "Seed", FormMethod.Post, new { id = "CommitmentForm" }); %>
            <label style="float: left; margin-top: 4px; white-space:nowrap ">
                <%--When will you honor your commitment?--%>
                The date that you plan on completing<br /> your commitment
                </label>
                <div class="calenderbox">    <%= Html.Telerik().DatePicker()
                .Name("Deadline")
                .MinDate(DateTime.Today.ToShortDateString())
                .MaxDate(DateTime.Today.AddYears(1).ToShortDateString())
                .Value(DateTime.Today.ToShortDateString()) %>
            </div>
            <br />
            <div class="error-container2">
            </div>
          <label style="float: left; ">   Describe your commitment<br />
            <%: Html.Hidden("Sid",SeedDtl.id) %>
            <%: Html.TextArea("Msg", new { maxlength = 499 })  %><br />
            <ins>(Max 500 Characters)</ins></label><br />
            <div class="clear">
            </div>
      
            <input type="submit" value="Commit" class="gbtn" /> 
            <% Html.EndForm(); %>
        </div>
        <%})
           .Width(350)
           .Height(300)
           .Render();
        %>
    </div>
    <div>
        <% Html.Telerik().Window()
           .Name("LikeWindow")
           .Title("Likes")
           .ClientEvents(
              events =>
                events.OnLoad("centerLikeWindow"))
           .Modal(true)
           .Buttons(b => b.Close())
               .Visible(false)
           .Content(() =>
           {%>
        <div style="width:90%; margin:auto">
            <h2>Following members liked this seed</h2>
            <br />
            <% IList<SeedSpeak.Model.Rating> rate = SeedDtl.Ratings.Where(x => x.likes.Equals(SeedSpeak.Util.SystemStatements.SEEDS_LIKE)).ToList();
               if (rate.Count > 0)
               {
                   foreach (SeedSpeak.Model.Rating objRate in rate)
                   {
            %>
            <a class="tony"  href="/Member/UserDetail/<%= objRate.Member.id %>">
                <% string likeRatedBy = objRate.Member.organisationName != null ? objRate.Member.organisationName.ToString() : (objRate.Member.firstName + " " + objRate.Member.lastName).ToString(); %>
                <%= likeRatedBy%>
            </a>
            <br />
            <%}
               }
               else
               { %>
               <span style="color:Red;">No member likes this seed yet !</span>
               <%} %>
        </div>
        <%})
           .Width(450)
           .Height(220)
           .Render();
        %>
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
        <% Html.RenderPartial("~/Views/Seed/ReplySeed.ascx"); %>
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
<div>
    <%  Html.Telerik().Window()
            .Name("EditMySeedWindow")
            .Title("Edit Seed")
            .Content(() =>
            {%>
    <div class="roundT">
    </div>
    <div class="rndM">
        <% Html.RenderPartial("~/Views/Seed/EditSeed.ascx"); %>
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
    <div>
        <% Html.Telerik().Window()
           .Name("CommitmentNameWindow")
           .Title("Commitments")
           .ClientEvents(
              events =>
                events.OnLoad("centerCommitmentWindow"))
           .Modal(true)
           .Buttons(b => b.Close())
               .Visible(false)
           .Content(() =>
           {%>
        <div>
            Following members committed to this seed
            <br />
            <% var commit = (from c in SeedDtl.Commitments
                             select new
                             {
                                 id = c.Member.id,
                                 name = c.Member.firstName + " " + c.Member.lastName,
                                 org = c.Member.organisationName
                             }).Distinct();
               if (commit.ToList().Count > 0)
               {
                   foreach (var objCommit in commit)
                   {
            %>
            <a href="/Member/UserDetail/<%= objCommit.id %>">
                <% string committedBy = objCommit.org != null ? objCommit.org.ToString() : objCommit.name; %>
                <%= committedBy%>
            </a>
            <br />
            <%}
               }
               else
               { %>
               <span style="color:Red;">No member committed to this seed yet !</span>
               <%} %>
        </div>
        <%})
           .Width(350)
           .Height(300)
           .Render();
        %>
    </div>
    <div>
        <% Html.Telerik().Window()
           .Name("mailSeedWindow")
           .Title("Mail")
           .ClientEvents(
              events =>
                events.OnLoad("centerMailSeedWindow"))
           .Modal(true)
           .Buttons(b => b.Close())
           .Visible(false)
           .Content(() =>
           {%>
        <div style="margin:auto; width:90%">
            <% Html.BeginForm("mailSeedInformation", "Seed", FormMethod.Post, new { id = "mailSeedForm" }); %>
            <div class="error-containerMail">
            </div>
            <div style="width:75px; float:left; color:#636363; font-weight:bold; height:18px; padding-top:13px">To :</div> 
            <%: Html.TextBox("eMail")%><br />
            <div style="width:75px; float:left; color:#636363; font-weight:bold; height:18px; padding-top:13px">Subject :</div>
            <%: Html.TextBox("seedSubject",SeedDtl.title) %><br /><br />
            <div style="color:#636363; font-weight:bold;">Content :</div>
            <%: Html.TextArea("seedBody", ("http://" + Request.ServerVariables["SERVER_NAME"] + Request.ServerVariables["URL"]).ToString())%><br />
            <%: Html.Hidden("mSeedid",SeedDtl.id) %>
            <input type="submit" value="Send Mail" class="gbtn" />
            <% Html.EndForm(); %>
        </div>
        <%})
           .Width(450)
           .Height(220)
           .Render();
        %>
    </div>
    <% Html.Telerik().ScriptRegistrar()
           .OnDocumentReady(() =>
           {%>
    var lovelyWindow = $('#FlagWindow'); var undoButton = $('#FlagAnchor'); undoButton
    .bind('click', function(e) { lovelyWindow.data('tWindow').open(); }) .toggle(!lovelyWindow.is(':visible'));
    lovelyWindow.bind('close', function() { undoButton.show(); }); var lovelyWindow1
    = $('#CommitmentWindow'); var undoButton1 = $('#SpanCommit'); undoButton1 .bind('click',
    function(e) { lovelyWindow1.data('tWindow').open(); }) .toggle(!lovelyWindow1.is(':visible'));
    lovelyWindow1.bind('close', function() { undoButton1.show(); }); var lovelyWindow2
    = $('#CommentWindow'); var undoButton2 = $('#SpanAddComment'); undoButton2 .bind('click',
    function(e) { lovelyWindow2.data('tWindow').open(); }) .toggle(!lovelyWindow2.is(':visible'));
    lovelyWindow2.bind('close', function() { undoButton2.show(); }); var likeWindow1
    = $('#LikeWindow'); var likeButton= $('#spCountLike'); likeButton .bind('click',
    function(e) { likeWindow1.data('tWindow').open(); }) .toggle(!likeWindow1.is(':visible'));
    likeWindow1.bind('close', function() { likeButton.show(); });    
    var commitWindow1 = $('#CommitmentNameWindow'); var commitButton= $('#spanCommitmentCount');
    commitButton .bind('click', function(e) { commitWindow1.data('tWindow').open();
    }) .toggle(!commitWindow1.is(':visible')); commitWindow1.bind('close', function()
    { commitButton.show(); }); var mailWindow = $('#mailSeedWindow'); var mailButton=
    $('#spanMailWindow'); mailButton .bind('click', function(e) { mailWindow.data('tWindow').open();
    }) .toggle(!mailWindow.is(':visible')); mailWindow.bind('close', function() { mailButton.show();
    });
    <%}); %>
</asp:Content>
