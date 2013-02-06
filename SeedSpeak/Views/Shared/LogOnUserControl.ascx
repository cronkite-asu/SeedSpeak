<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<script type="text/javascript" language="JavaScript">
    function ReverseDisplay(d, type) {
        if (document.getElementById(d).style.display == "none") {
            document.getElementById(d).style.display = "block";

            var dv = document.getElementById(d);

            //call method using json
            if (type == "comments") {
                $.getJSON("/Member/CheckUnreadComments/?ids=" + $("#hdCommentsId").attr("value"),
                function (data) {
                    var lnk = document.getElementById('lnkComments');
                    lnk.innerHTML = 0;
                    document.getElementById('notecommitment').style.display = "none";
                    document.getElementById('noteflag').style.display = "none";
                    document.getElementById('noteLike').style.display = "none";
                });
            }
            else if (type == "commitment") {
                $.getJSON("/Member/CheckUnreadCommitment/?ids=" + $("#hdCommitmentId").attr("value"),
                function (data) {
                    var lnk = document.getElementById('lnkcommitments');
                    lnk.innerHTML = 0;
                    document.getElementById('noteComment').style.display = "none";
                    document.getElementById('noteflag').style.display = "none";
                    document.getElementById('noteLike').style.display = "none";
                });
            }
            else if (type == "like") {
                $.getJSON("/Member/CheckUnreadLikes/?ids=" + $("#hdLikeId").attr("value"),
                function (data) {
                    var lnk = document.getElementById('lnkLikes');
                    lnk.innerHTML = 0;
                    document.getElementById('notecommitment').style.display = "none";
                    document.getElementById('noteComment').style.display = "none";
                    document.getElementById('noteflag').style.display = "none";
                });
            }
            else {
                $.getJSON("/Member/CheckUnreadFlags/?ids=" + $("#hdFlagId").attr("value"),
                function (data) {
                    var lnk = document.getElementById('lnkFlag');
                    lnk.innerHTML = 0;
                    document.getElementById('notecommitment').style.display = "none";
                    document.getElementById('noteComment').style.display = "none";
                    document.getElementById('noteLike').style.display = "none";
                });
            }
            //End Calling
        }
        else {
            document.getElementById(d).style.display = "none";
        }
    }
</script>
<script language="javascript">
    function showonlyone(thechosenone) {
        var newboxes = document.getElementsByTagName("div");
        for (var x = 0; x < newboxes.length; x++) {
            name = newboxes[x].getAttribute("name");
            if (name == 'newboxes') {
                if (newboxes[x].id == thechosenone) {
                    newboxes[x].style.display = 'block';
                }
                else {
                    newboxes[x].style.display = 'none';
                }
            }
        }
    }
</script>
 


<% 
    if (SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject) != null)
    {
        SeedSpeak.Model.Member memberData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
        string imagePath = "";
        if (memberData.MemberProfiles.FirstOrDefault() != null)
        {
            if (memberData.MemberProfiles.FirstOrDefault().imagePath != null)
            {
                string img = memberData.MemberProfiles.FirstOrDefault().imagePath.ToString();
                img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                if (System.IO.File.Exists(img))
                    imagePath = memberData.MemberProfiles.FirstOrDefault().imagePath.ToString();
                else
                    imagePath = "../../Content/images/user.gif";
            }
            else
                imagePath = "../../Content/images/user.gif";
        }
        else
        {
            imagePath = "../../Content/images/user.gif";
        }
%>
<div class="Upic">
    <% if (memberData.Role.name == SeedSpeak.Util.SystemStatements.ROLE_END_USER)
       { %>
    <a href="/Member/Dashboard" class="imglnk">
        <img src="<%= imagePath %>" alt="Profile Image" /></a> <a href="/Member/Dashboard"><span
            class="title">
            <% if (string.IsNullOrEmpty(memberData.organisationName))
               { %>
            <%: memberData.firstName + " " + memberData.lastName%>
            <%}
               else
               { %>
            <%: memberData.organisationName%>
            <%} %>
        </span></a>
    <%}
       else
       {%>
    <a href="/Admin/AdminDashboard" class="imglnk">
        <img src="<%= imagePath %>" alt="Profile Image" /></a> <a href="/Admin/AdminDashboard">
            <span class="title">
                <% if (string.IsNullOrEmpty(memberData.organisationName))
                   { %>
                <%: memberData.firstName + " " + memberData.lastName%>
                <%}
                   else
                   { %>
                <%: memberData.organisationName%>
                <%} %>
            </span></a>
    <%} if (memberData.Role.name == SeedSpeak.Util.SystemStatements.ROLE_END_USER)
       { %>
    <div class="notification">
        <div class="bbouter">
            <div class="notibox">
                <% 
                    string commitmentIds = string.Empty;
                    string commentIds = string.Empty;
                    string flagIds = string.Empty;
                    string likeIds = string.Empty;
                    if (ViewData["CommitmentNotification"] != null)
                    {
                        IList<SeedSpeak.Model.usp_GetCommitmentNotification_Result> lstCommitmentNotifications = (IList<SeedSpeak.Model.usp_GetCommitmentNotification_Result>)ViewData["CommitmentNotification"];
                        if (lstCommitmentNotifications.Count > 0)
                        {
                            for (int i = 0; i <= lstCommitmentNotifications.Count - 1; i++)
                            {
                                if (!string.IsNullOrEmpty(commitmentIds))
                                    commitmentIds = commitmentIds + ";" + lstCommitmentNotifications[i].id.ToString();
                                else
                                    commitmentIds = commitmentIds + lstCommitmentNotifications[i].id.ToString();
                            }
                        }%>
                <input type="hidden" id="hdCommitmentId" value='<%=commitmentIds %>' />
                <a id="lnkcommitments" href="javascript:ReverseDisplay('notecommitment','commitment')"
                    class="ncmit">
                    <%= lstCommitmentNotifications != null ? lstCommitmentNotifications.Count.ToString() : "0"%></a>
                <%
                    }
                    IList<SeedSpeak.Model.usp_GetCommitmentNotification_Result> lstCommitmentNotifications1 = (IList<SeedSpeak.Model.usp_GetCommitmentNotification_Result>)ViewData["CommitmentNotificationLimit"];
                    IList<SeedSpeak.Model.usp_GetCommitmentNotification_Result> lstCommitmentNotifications2 = (IList<SeedSpeak.Model.usp_GetCommitmentNotification_Result>)ViewData["CommitmentNotification"];
                %>
            </div>
            <div id="notecommitment" style="display: none;" class="bubblebox">
                <span class="arrow"></span>
     <div class="poptxt"> 
            <div class="bubtxt" id="p1">
                    <% string commitments = string.Empty;
                       if (lstCommitmentNotifications1 != null)
                       {
                           if (lstCommitmentNotifications1.Count > 0)
                           {
                               try
                               {
                                   for (int i = 0; i <= lstCommitmentNotifications1.Count - 1; i++)
                                   {
                                       if (!string.IsNullOrEmpty(commitments))

                                           commitments = commitments + "<a href=/Member/UserDetail/" + lstCommitmentNotifications1[i].MemberID + ">" + lstCommitmentNotifications1[i].MemberName.ToString() + "</a> made a commitment to your <a href=/Seed/SeedDetails/" + lstCommitmentNotifications1[i].SeedID + ">seed</a>.<br clear='both'>";
                                       else

                                           commitments = "<a href=/Member/UserDetail/" + lstCommitmentNotifications1[i].MemberID + ">" + lstCommitmentNotifications1[i].MemberName.ToString() + "</a> made a commitment to your <a href=/Seed/SeedDetails/" + lstCommitmentNotifications1[i].SeedID + ">seed</a>.<br clear='both'>";
                                   }
                               }
                               catch { };
                    %>
                    <p><%= commitments%></p>
                    <div class="clear"></div>
                    <% if (lstCommitmentNotifications2.Count > 5)
                       { %> 
                    
   
   
             <span style="float:right ;padding-right:10px;"><a id="lnk1" href="javascript:showonlyone('noteCommitmentFull');" >View All</a></span>
                    <% }
                           }
                           else
                           {
                               Response.Write("<h5>No commitments found.</h5> ");
                           }
                       }
                    %>
                </div>
           
            <div id="noteCommitmentFull"   name="newboxes"  style="display:none" >
                <% string notecommitments = string.Empty;
                       if (lstCommitmentNotifications2 != null)
                       {
                           if (lstCommitmentNotifications2.Count > 0)
                           {
                               try
                               {
                                   for (int i = 0; i <= lstCommitmentNotifications2.Count - 1; i++)
                                   {
                                       if (!string.IsNullOrEmpty(notecommitments))

                                           notecommitments = notecommitments + "<a href=/Member/UserDetail/" + lstCommitmentNotifications2[i].MemberID + ">" + lstCommitmentNotifications2[i].MemberName.ToString() + "</a> made a commitment to your <a href=/Seed/SeedDetails/" + lstCommitmentNotifications2[i].SeedID + ">seed</a>.<br clear='both'>";
                                       else

                                           notecommitments = "<a href=/Member/UserDetail/" + lstCommitmentNotifications2[i].MemberID + ">" + lstCommitmentNotifications2[i].MemberName.ToString() + "</a> made a commitment to your <a href=/Seed/SeedDetails/" + lstCommitmentNotifications2[i].SeedID + ">seed</a>.<br clear='both'>";
                                   }
                               }
                               catch { };
                    %>
                    <p><%= notecommitments%></p>
                               
                    <% }
                       }
                    %> 
            </div></div>  
        </div> </div>
        <div class="bbouter" id="p1">
            <div class="notibox">
                <%
                    if (ViewData["CommentNotification"] != null)
                    {
                        IList<SeedSpeak.Model.usp_GetCommentNotification_Result> lstCommentNotifications = (IList<SeedSpeak.Model.usp_GetCommentNotification_Result>)ViewData["CommentNotification"];
                        if (lstCommentNotifications != null)
                        {
                            if (lstCommentNotifications.Count > 0)
                            {
                                for (int i = 0; i <= lstCommentNotifications.Count - 1; i++)
                                {
                                    if (!string.IsNullOrEmpty(commentIds))
                                        commentIds = commentIds + ";" + lstCommentNotifications[i].id.ToString();
                                    else
                                        commentIds = commentIds + lstCommentNotifications[i].id.ToString();
                                }
                            }
                        } %>
                <span>
                    <input type="hidden" id="hdCommentsId" value='<%=commentIds %>' />
                    <a id="lnkComments" href="javascript:ReverseDisplay('noteComment','comments')" class="nc">
                        <%= lstCommentNotifications != null ? lstCommentNotifications.Count.ToString() : "0"%>
                    </a>
                    <%}
                    IList<SeedSpeak.Model.usp_GetCommentNotification_Result> lstCommentNotifications1 = (IList<SeedSpeak.Model.usp_GetCommentNotification_Result>)ViewData["CommentNotificationLimit"];
                    IList<SeedSpeak.Model.usp_GetCommentNotification_Result> lstCommentNotifications2 = (IList<SeedSpeak.Model.usp_GetCommentNotification_Result>)ViewData["CommentNotification"];
                    %></span>
            </div>
            <div id="noteComment" style="display: none;" class="bubblebox">
                <span class="arrow"></span>
           <div class="poptxt">   
                  <div class="bubtxt">
                    <% string comments = string.Empty;
                       if (lstCommentNotifications1 != null)
                       {
                           if (lstCommentNotifications1.Count > 0)
                           {
                               try
                               {
                                   for (int i = 0; i <= lstCommentNotifications1.Count - 1; i++)
                                   {
                                       if (!string.IsNullOrEmpty(comments))

                                           comments = comments + "<a href=/Member/UserDetail/" + lstCommentNotifications1[i].MemberID + ">" + lstCommentNotifications1[i].MemberName.ToString() + "</a> posted a comment on your <a href=/Seed/SeedDetails/" + lstCommentNotifications1[i].SeedID + ">seed</a>.<br clear='both'>";
                                       else

                                           comments = "<a href=/Member/UserDetail/" + lstCommentNotifications1[i].MemberID + ">" + lstCommentNotifications1[i].MemberName.ToString() + "</a> posted a comment on your <a href=/Seed/SeedDetails/" + lstCommentNotifications1[i].SeedID + ">seed</a>.<br clear='both'>";

                                   }
                               }
                               catch { };
                    %>
                    <p><%= comments%></p>
                               <div class="clear"></div>
                               <% if (lstCommentNotifications2.Count > 5)
                                  { %>
              <span style="float:right ;padding-right:10px;"><a id="lnk2" href="javascript:showonlyone('noteCommentFull');" >View All</a></span>
                    <% }
                           }
                           else
                           {
                               Response.Write("<h5>No comments found.</h5>");
                           }
                       }%>
                </div>
        
            <div id="noteCommentFull" style="display:none" name="newboxes" class="vallbox">
                      <% string notecomments = string.Empty;
                       if (lstCommentNotifications2 != null)
                       {
                           if (lstCommentNotifications2.Count > 0)
                           {
                               try
                               {
                                   for (int i = 0; i <= lstCommentNotifications2.Count - 1; i++)
                                   {
                                       if (!string.IsNullOrEmpty(notecomments))

                                           notecomments = notecomments + "<a href=/Member/UserDetail/" + lstCommentNotifications2[i].MemberID + ">" + lstCommentNotifications2[i].MemberName.ToString() + "</a> posted a comment on your <a href=/Seed/SeedDetails/" + lstCommentNotifications2[i].SeedID + ">seed</a>.<br clear='both'>";
                                       else

                                           notecomments = "<a href=/Member/UserDetail/" + lstCommentNotifications2[i].MemberID + ">" + lstCommentNotifications2[i].MemberName.ToString() + "</a> posted a comment on your <a href=/Seed/SeedDetails/" + lstCommentNotifications2[i].SeedID + ">seed</a>.<br clear='both'>";

                                   }
                               }
                               catch { };
                    %>
                    <p><%= notecomments%></p>
                    <% }                           
                       }%>
               
            </div></div>
        </div>    </div>
        <div class="bbouter">
            <div class="notibox">
                <% 
                    if (ViewData["FlagNotification"] != null)
                    {
                        IList<SeedSpeak.Model.usp_GetFlagNotification_Result> lstFlagNotifications = (IList<SeedSpeak.Model.usp_GetFlagNotification_Result>)ViewData["FlagNotification"];
                        if (lstFlagNotifications != null)
                        {
                            if (lstFlagNotifications.Count > 0)
                            {
                                for (int i = 0; i <= lstFlagNotifications.Count - 1; i++)
                                {
                                    if (!string.IsNullOrEmpty(flagIds))
                                        flagIds = flagIds + ";" + lstFlagNotifications[i].id.ToString();
                                    else
                                        flagIds = flagIds + lstFlagNotifications[i].id.ToString();
                                }
                            }
                        }
                %>
                <span>
                    <input type="hidden" id="hdFlagId" value='<%=flagIds %>' />
                    <a id="lnkFlag" href="javascript:ReverseDisplay('noteflag','flag')" class="nf">
                        <%= lstFlagNotifications != null ? lstFlagNotifications.Count.ToString() : "0"%>
                    </a>
                    <%
                        } 
          IList<SeedSpeak.Model.usp_GetFlagNotification_Result> lstFlagNotifications1 = (IList<SeedSpeak.Model.usp_GetFlagNotification_Result>)ViewData["FlagNotificationLimit"];
          IList<SeedSpeak.Model.usp_GetFlagNotification_Result> lstFlagNotifications2 = (IList<SeedSpeak.Model.usp_GetFlagNotification_Result>)ViewData["FlagNotification"];
                    %></span></div>
            <div id="noteflag" style="display: none;" class="bubblebox">
                <span class="arrow"></span>
         <div class="poptxt">         
            <div class="bubtxt">
                    <% string flags = string.Empty;
                       if (lstFlagNotifications1 != null)
                       {
                           if (lstFlagNotifications1.Count > 0)
                           {
                               try
                               {
                                   for (int i = 0; i <= lstFlagNotifications1.Count - 1; i++)
                                   {
                                       if (!string.IsNullOrEmpty(flags))

                                           flags = flags + "<a href=/Member/UserDetail/" + lstFlagNotifications1[i].MemberID + ">" + lstFlagNotifications1[i].MemberName.ToString() + "</a> has flagged your <a href=/Seed/SeedDetails/" + lstFlagNotifications1[i].SeedID + ">seed</a>.<br clear='both'>";
                                       else

                                           flags = "<a href=/Member/UserDetail/" + lstFlagNotifications1[i].MemberID + ">" + lstFlagNotifications1[i].MemberName.ToString() + "</a> has flagged your <a href=/Seed/SeedDetails/" + lstFlagNotifications1[i].SeedID + ">seed</a>.<br clear='both'>";
                                   }
                               }
                               catch { };
                    %>
                    <p><%= flags%></p>
                               <div class="clear"></div>
                               <% if (lstFlagNotifications2.Count > 5)
                                  { %>
                    <span style="float:right ;padding-right:10px;"><a id="lnk3" href="javascript:showonlyone('noteflagFull');" >View All</a></span>
                    <% }
                           }
                           else
                           {
                               Response.Write("<h5>No flags found.</h5>");
                           }
                       }%>
                </div>
        
            <div id="noteflagFull"  style="display: none;" name="newboxes" class="vallbox">
              
                    <% string noteflags = string.Empty;
                       if (lstFlagNotifications2 != null)
                       {
                           if (lstFlagNotifications2.Count > 0)
                           {
                               try
                               {
                                   for (int i = 0; i <= lstFlagNotifications2.Count - 1; i++)
                                   {
                                       if (!string.IsNullOrEmpty(noteflags))

                                           noteflags = noteflags + "<a href=/Member/UserDetail/" + lstFlagNotifications2[i].MemberID + ">" + lstFlagNotifications2[i].MemberName.ToString() + "</a> has flagged your <a href=/Seed/SeedDetails/" + lstFlagNotifications2[i].SeedID + ">seed</a>.<br clear='both'>";
                                       else

                                           noteflags = "<a href=/Member/UserDetail/" + lstFlagNotifications2[i].MemberID + ">" + lstFlagNotifications2[i].MemberName.ToString() + "</a> has flagged your <a href=/Seed/SeedDetails/" + lstFlagNotifications2[i].SeedID + ">seed</a>.<br clear='both'>";
                                   }
                               }
                               catch { };
                    %>
                    <p><%= noteflags%></p>
                    <% }
                       }%>
                 
            </div></div>
        </div>    </div>
        <div class="bbouter">
            <div class="notibox">
                <% 
                    if (ViewData["LikeNotification"] != null)
                    {
                        IList<SeedSpeak.Model.usp_GetLikeNotification_Result> lstLikeNotifications = (IList<SeedSpeak.Model.usp_GetLikeNotification_Result>)ViewData["LikeNotification"];
                        if (lstLikeNotifications != null)
                        {
                            if (lstLikeNotifications.Count > 0)
                            {
                                for (int i = 0; i <= lstLikeNotifications.Count - 1; i++)
                                {
                                    if (!string.IsNullOrEmpty(likeIds))
                                        likeIds = likeIds + ";" + lstLikeNotifications[i].id.ToString();
                                    else
                                        likeIds = likeIds + lstLikeNotifications[i].id.ToString();
                                }
                            }
                        }
                %>
                <span>
                    <input type="hidden" id="hdLikeId" value='<%=likeIds %>' />
                    <a id="lnkLikes" href="javascript:ReverseDisplay('noteLike','like')" class="nl">
                        <%= lstLikeNotifications != null ? lstLikeNotifications.Count.ToString() : "0"%>
                    </a>
                    <%
                        } 
          IList<SeedSpeak.Model.usp_GetLikeNotification_Result> lstLikeNotifications1 = (IList<SeedSpeak.Model.usp_GetLikeNotification_Result>)ViewData["LikeNotificationLimit"];
          IList<SeedSpeak.Model.usp_GetLikeNotification_Result> lstLikeNotifications2 = (IList<SeedSpeak.Model.usp_GetLikeNotification_Result>)ViewData["LikeNotification"];
                    %></span>
            </div>
            <div id="noteLike" style="display: none;" class="bubblebox">
                <span class="arrow"></span>
          <div class="poptxt">          
           <div class="bubtxt">
                    <% string likes = string.Empty;
                       if (lstLikeNotifications1 != null)
                       {
                           if (lstLikeNotifications1.Count > 0)
                           {
                               try
                               {
                                   for (int i = 0; i <= lstLikeNotifications1.Count - 1; i++)
                                   {
                                       if (!string.IsNullOrEmpty(likes))
                                           likes = likes + " <a href=/Member/UserDetail/" + lstLikeNotifications1[i].MemberID + ">" + lstLikeNotifications1[i].MemberName.ToString() + "</a> liked your <a href=/Seed/SeedDetails/" + lstLikeNotifications1[i].SeedID + ">seed</a>.<br clear='both'>";
                                       else
                                           likes = "<a href=/Member/UserDetail/" + lstLikeNotifications1[i].MemberID + ">" + lstLikeNotifications1[i].MemberName.ToString() + "</a> liked your <a href=/Seed/SeedDetails/" + lstLikeNotifications1[i].SeedID + ">seed</a>.<br clear='both'>";
                                   }
                               }
                               catch { };
                    %>
                    <p><%= likes%></p>
                               <div class="clear"></div>
                               <% if (lstLikeNotifications2.Count > 5)
                                  { %>
                      <span style="float:right ;padding-right:10px;"><a id="lnk4" href="javascript:showonlyone('noteLikeFull');" >View All</a></span>
                    <% }
                           }
                           else
                           {
                               Response.Write("<h5>No likes found.</h5>");
                           }
                       }%>
                </div>
          
            <div id="noteLikeFull"   style="display: none;" name="newboxes" class="vallbox"> 
                    <% string notelikes = string.Empty;
                       if (lstLikeNotifications2 != null)
                       {
                           if (lstLikeNotifications2.Count > 0)
                           {
                               try
                               {
                                   for (int i = 0; i <= lstLikeNotifications2.Count - 1; i++)
                                   {
                                       if (!string.IsNullOrEmpty(notelikes))
                                           notelikes = notelikes + " <a href=/Member/UserDetail/" + lstLikeNotifications2[i].MemberID + ">" + lstLikeNotifications2[i].MemberName.ToString() + "</a> liked your <a href=/Seed/SeedDetails/" + lstLikeNotifications1[i].SeedID + ">seed</a>.<br clear='both'>";
                                       else
                                           notelikes = "<a href=/Member/UserDetail/" + lstLikeNotifications2[i].MemberID + ">" + lstLikeNotifications2[i].MemberName.ToString() + "</a> liked your <a href=/Seed/SeedDetails/" + lstLikeNotifications2[i].SeedID + ">seed</a>.<br clear='both'>";
                                   }
                               }
                               catch { };
                    %>
                    <p><%= notelikes%></p>
                    <% }
                       }%>
                </div></div>
          
        </div>  </div>
    </div>
    <ul id="lnk">
        <li><a href="/Member/Dashboard">Dashboard</a></li>
        <li><a href="/Member/Profile">Settings</a> </li>
    </ul>
    <%
        
        }
        else
        {
    %>
    <ul id="lnk">
        <li><a href="/Admin/AdminDashboard" class="DB">Dashboard</a></li>
    </ul>
    <% } %>
    <%
        }
    else
    { %>
    <ul class="lnk">
        <%        string cookieName = "fbs_" + ConfigurationManager.AppSettings["AppID"];
                  string retString = null;
                  HttpCookie c = HttpContext.Current.Request.Cookies[cookieName];
                  if (HttpContext.Current.Request.Cookies[cookieName] != null)
                  {   %>
        <li><a href="/Member/FacebookLogout">Facebook Logout</a> </li>
        <%}
                  else
                  {%>
        <%} %>
    </ul>
    <%} %></div>
