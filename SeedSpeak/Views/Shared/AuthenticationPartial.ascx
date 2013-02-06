<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<script type="text/javascript">
    function SelectTab(TabVal) {
        var tabstrip = $("#MemberOptPanel").data("tTabStrip");
        var item = $("li", tabstrip.element)[TabVal];
        tabstrip.select(item);
    }

    function callLoginSignUpWindow(TabValue) {
        var loginWindow = $('#Windowlogin').data('tWindow');
        loginWindow.center().open();
        $("#LogUserName").focus();
        SelectTab(TabValue);
    }

    $(document).ready(function () {
        $("#notificationDetails").hide();
        $("#notifyCount").click(function () {
            $("#notifyCount").toggleClass('notifications notifications-hlt')
            $("#notificationDetails").toggle();

            $.getJSON("/Member/CheckUnreadNotifications/?id=" + $("#notifyIds").attr("value"),
                function (data) {
                    var lnk = document.getElementById('notifyCount');
                    lnk.innerHTML = '(0)';
                });
        });
    });
</script>
<%
    SeedSpeak.Model.Member mData1 = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
    if (mData1 != null)
    {
        int notificationCounts = 0;
        string idAction = string.Empty;
        SeedSpeak.BLL.CommitmentAction objCommit = new SeedSpeak.BLL.CommitmentAction();
        IList<SeedSpeak.Model.usp_GetCommentNotification_Result> lstComments = objCommit.GetCommentNotifications(mData1.id.ToString());

        IList<SeedSpeak.Model.usp_GetFlagNotification_Result> lstFlags = objCommit.GetFlagNotifications(mData1.id.ToString());

        IList<SeedSpeak.Model.usp_GetLikeNotification_Result> lstLikes = objCommit.GetLikeNotifications(mData1.id.ToString());

        notificationCounts += lstComments.Count();
        notificationCounts += lstFlags.Count();
        notificationCounts += lstLikes.Count(); 
%>
<div id="dashboard">
    <div class="photo">
        <% string profilePic ="../../Content/images/user.gif";
               if(mData1.MemberProfiles.FirstOrDefault()!=null)
               {
                   if(mData1.MemberProfiles.FirstOrDefault().imagePath!=null)
                   {
                       profilePic = mData1.MemberProfiles.FirstOrDefault().imagePath;
                   }
               }
               string profileOwner = mData1.firstName + " " + mData1.lastName;
        %>
        <a href="/Member/UserDetail/<%= mData1.id %>" title="<%=profileOwner %>">
        <img src="<%= profilePic %>" alt="Profile Image" height="26" width="26" /></a>
    </div>
    <div class="notifications">
        <a href="#" id="notifyCount">(<%=notificationCounts%>)</a></div>
    <div id="nav">
        <ul>
            <li>
                <%if (mData1.Role.name == SeedSpeak.Util.SystemStatements.ROLE_END_USER)
                  { %>
                <a href="/Member/Dashboard">Dashboard</a>
                <%}
                  else
                  { %>
                <a href="/Admin/AdminDashboard">Dashboard</a>
                <%} %>
            </li>
            <li><a href="/Member/Profile">Settings</a></li>
            <li class="last"><a href="/Member/Logout">Logout</a></li></ul>
    </div>
</div>
<div id="notificationDetails" style="display:none;">
    <div class="top">
    </div>
    
    <div class="middle">
        <%
        if (notificationCounts > 0)
        {
            int limitCount = 0;
            for (int i = 0; i < lstComments.Count(); i++)
            {
                if (limitCount < 5)
                {
                    idAction = lstComments[i].id.ToString() + ",Comment";
        %>
        <a href="/Seed/SeedDetails/<%=lstComments[i].SeedID%>" class="morelink">
            <%=lstComments[i].MemberName%><span class="links_text"> Commented on your seed</span></a>
        
        <%} limitCount++;
            }
            for (int j = 0; j < lstFlags.Count(); j++)
            {
                if (limitCount < 5)
                {
                    if (!string.IsNullOrEmpty(idAction))
                        idAction += ",";
                    idAction += lstFlags[j].id.ToString() + ",Flag";
        %>
        <a href="/Seed/SeedDetails/<%=lstFlags[j].SeedID%>" class="morelink">
            <%=lstFlags[j].MemberName%><span class="links_text"> Flagged your seed</span></a>
        <% } limitCount++;
            }
            for (int k = 0; k < lstLikes.Count(); k++)
            {
                if (limitCount < 5)
                {
                    if (!string.IsNullOrEmpty(idAction))
                        idAction += ",";
                    idAction += lstLikes[k].id.ToString() + ",Rating";
        %>
        <a href="/Seed/SeedDetails/<%=lstLikes[k].SeedID%>" class="morelink">
            <%=lstLikes[k].MemberName%><span class="links_text"> Likes your seed</span></a>
        <% } limitCount++;
            }
        }
        else
        { %>
        
        <span style="color:Red ;font-size: 11px;font-weight: normal;line-height: normal;text-decoration: none;text-align:center;">Currently there is no notification for you !</span>
        <%} %>
        <br />
        <div class="clear">
        </div>
    </div>
    <div class="bottom">
        <% if (notificationCounts > 5)
           { %>
        <a class="full" href="#">View All Notifications</a>
        <%} %>
    </div>
    <input type="hidden" id="notifyIds" value='<%=idAction %>' />
</div>
<% }
    else
    { %>
<ul id="smenu">
    <li><a onclick="javascript:callLoginSignUpWindow(0);"><span>Login</span></a></li>
    <li><a onclick="javascript:callLoginSignUpWindow(1);"><span>Sign Up</span></a></li>
</ul>
<%} %>