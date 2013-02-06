<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<SeedSpeak.Model.Validation.RegisterModel>" %>
<style>
.logincontent {
	/*border: 1px solid green;*/
	margin: auto;
	width: 575px;
	margin-left: 5px;
	background-image: url('../../Content/images/loginmainbg.png');
	background-repeat: no-repeat;
	background-position: right bottom;
	float: left;
	background-color: transparent;
	height: 494px;
	background-color: white; margin-top:-7px;
	padding:0px;
}

.loginoutter {
	border: 0px solid red;
	width: 100%;
	background-image: url('../../Content/images/clouds0.png');
	background-repeat: no-repeat;
	background-position: -1px 0;
	padding-top: 0px;
	float: left;
	padding-bottom: 0px;
	height: 494px;
	padding-left: 0px;
}
.loginInnerP p {
	border: 0px solid #000;
	padding-top: 15px; 
	width: 220px;
	margin-left: 40px;
	font-size: 14px;
	color: #464545;
}
.loginInnerP p, .loginInnerP p.single {
	font-size: 14px;
	color: #464545;
}
.loginbox p span {
	color: #a3180e;
	font-size: 12px;
}

.multicontrl {
	border: 0px solid #000;
	float: left;
	width: 100%;
	white-space: nowrap;
	text-align: right;
}
.multicontrl span {
	border: 0px solid #000;
	float: left;
	line-height: 2;
}
.logbtn {
	width: 118px;
	background-image: url('../../Content/images/sprite_logincntrl.png');
	background-repeat: no-repeat;
	background-position: -2px 2px;
	height: 38px;
	background-color: transparent;
	border: 0px solid #000;
}
.passwordbox {
	border: 0px solid #000;
	width: 96%;
	/*padding-top: 40px;*/
	color: #898989;
}
.Recbtn {
	width: 142px;
	background-image: url('../../Content/images/sprite_logincntrl.png');
	background-repeat: no-repeat;
	background-position: 0px -38px;
	height: 38px;
	background-color: transparent;
	border: 0px solid #000;
}
.FBbtn {
	width: 198px;
	position: absolute;
	right: 45px;
	top: 220px;
	height: 36px;
	background-image: url('../../Content/images/fbookbtnbg.png');
	background-repeat: no-repeat;
	background-position: 0px 0px;
	padding-left: 18px;
	padding-top: 3px;
	line-height:26px;
}

.FBbtn a {
	font-size: 12px;
	font-weight: normal;
	border: 0px solid #5f78ab;
	background: transparent;
}
.FBbtn span {
	border: 0px solid #5f78ab;
	background-color: transparent; line-height:18px;
}

.registercontent {
	border: 0px solid #000;
	width: 500px;
	padding-top: 0px;
	color: #464545;
	margin-left: 30px;
}
.registercontent div.single {
	border: 0px solid #000;
	width: 80%;
	margin-top: 10px;
	margin-left: 10px;
}

.single b {
	color: #393737;
	font-size: 14px;
	font-weight: normal;
	float:left;
}
.single small {
	color: #a8a8a8;
	font-size: 11px;
}
.registercontent p {
	float: left!important;
	font-size: 14px;
	color: #464545;
	font-weight: 500;
	margin-right: 20px;
	height: 65px;
	width: 210px;
	margin-left: 10px;
}
em {
    background-image: url('../../Content/images/sprite_logincntrl.png');
    background-position: -135px -85px;
    background-repeat: no-repeat;
    border: 0 solid #000000;
    color: #A3180E;
    font-size: 14px;
    font-style: normal;
    font-weight: 600;
    padding-left: 10px;
    padding-right: 10px;
    text-indent: 5px; width:25px!important; float:left!important;  height:15px;
}
span.field-validation-error {
	float: left;
	text-align: left;
	font-size : 11px;
	color : maroon;
}
.registercontent p.btn {
	border: 0px solid #000;
	float: left;
	padding-top: 0px;
	width: 100%!important;
	clear: both;
}
.singup {
	width: 136px;
	background-image: url('../../Content/images/sprite_logincntrl.png');
	background-repeat: no-repeat;
	background-position: -2px -78px;
	height: 34px;
	float: right;
	background-color: transparent;
	border: 0px solid #000;
	margin-top: -10px;
}
#recaptcha_response_field {
	background-color: transparent;
	background-image: none;
	height: 20px;
	border: 1px solid #ccc!important;
}

.t-widget {
	border: 2px solid #000;
}
.t-icon.t-close {
	padding: 24px 4px 6px 40px;
	background-image: url('../../Content/images/mclose.png');
	background-position: 10px 0;
	background-repeat: no-repeat;
	float: right;
}
#MemberOptPanel.t-tabstrip li.t-state-default.t-state-active {
	font-size: 18px;
	padding-left: 13px;
	padding-top: 11px;
	text-align: left; height:39px; 
	float:left;  
	padding-right: 20px;
	background-image: url('../../Content/images/tab-w.png');
	background-position: 0px 0px;
	background-repeat: no-repeat;
	margin-top: 1px;
	margin-right: 10px;
}
#MemberOptPanel.t-tabstrip li.t-state-default {
	font-size: 18px;
	padding-left: 13px; 
	padding-top: 11px;height:39px;
	padding-right: 20px; 
	float:left; 
	text-align: left;
	background-image: url('../../Content/images/tab-g.png');
	background-position: 0px 0px;
	background-repeat: no-repeat;  
	margin-left:1px;
	margin-right:10px;
	
}
#MemberOptPanel.t-tabstrip li.t-state-active {
	font-size: 18px;
	padding-left: 8px;float:left; 
	padding-top: 11px; 
	text-align: left;height:39px;
	padding-right: 30px;
	background-image: url('../../Content/images/tab-w.png');
	background-position: 0px 0px;
	background-repeat: no-repeat;
	margin-left:1px;
	
}




#MemberOptPanel.t-tabstrip li a.t-link {
    float: left;
    margin-right: 0px !important;
    padding-right: 12px;
    text-align: left !important;
    white-space: nowrap;
}
.logincontent input[type=text], .registercontent input[type=text] {
	width: 203px;
	background-image: url('../../Content/images/login_txtbox0.png');
	background-repeat: no-repeat;
	background-position: 0px 0px;
	height: 22px;
	border-top: 0px solid #b0d2be;
	border-left: 0px solid #b0d2be;
	border-bottom: 0px solid #b0d2be;
	border-right: 0px solid #b0d2be;
	font-size: 13px;
	text-indent: 5px;
	padding-bottom: 5px;
	padding-top: 5px;
	color:Black;
}
.logincontent input[type=password], .registercontent input[type=password] {
	width: 203px;
	background-image: url('../../Content/images/login_txtbox0.png');
	background-repeat: no-repeat;
	padding-bottom: 5px;
	padding-top: 5px;
	background-position: 0px 0px;
	height: 22px;
	font-size: 13px;
	text-indent: 5px;
	border-top: 0px solid #b0d2be;
	border-left: 0px solid #b0d2be;
	border-bottom: 0px solid #b0d2be;
	border-right: 0px solid #b0d2be;
	color:Black;
}
.t-loading, .t-widget .t-loading {
	background: transparent url('../../Content/images/loading.gif') no-repeat 0 0;
}
.t-reset {
	margin: 0;
	padding: 0;
	border: 0;
	outline: 0;
	text-decoration: none;
	font-size: 100%;
	list-style: none;
}
.t-widget, .t-widget button, .t-button {
	font-size: 100%;
}
.t-widget {
	border-width: 0px;
	border-style: solid;
}
.t-link {
	cursor: pointer;
	outline: none;
	line-height: 2;
}
.t-header .t-link {
	text-decoration: none;
}
.t-state-disabled, .t-state-disabled .t-link {
	cursor: default;
	outline: none;
}
.t-icon, .t-sprite, .t-editor-button .t-tool-icon {
	display: inline-block; *;
	display: inline;
	zoom: 1;
	vertical-align: middle;
	width: 16px;
	height: 16px;
	overflow: hidden;
	font-size: 0;
	line-height: 0;
	text-indent: -9999px;
}
* html .t-icon, .t-sprite {
	text-indent: 0;
}
* + html .t-icon, .t-sprite {
	text-indent: 0;
}
.t-image {
	border: 0;
}
.t-window {
	zoom: 1;
	z-index: 10001;
	position: absolute;
	border-width: 0;
	left: 15%;
	top: 2%;
}
.t-window-titlebar {
	padding: .4em 0;
	font-size: 1.2em;
	line-height: 1.0em;
	white-space: nowrap;
	border-bottom-width: 0px;
	border-bottom-style: solid;
	-moz-border-radius-topleft: 5px;
	-moz-border-radius-topright: 5px;
	-webkit-border-top-left-radius: 5px;
	-webkit-border-top-right-radius: 5px;
	border-top-left-radius: 5px;
	border-top-right-radius: 5px;
}
.t-window-title {
	cursor: default;
	position: absolute;
	display: none;
	display: none;
	text-overflow: ellipsis;
	overflow: hidden;
	left: .5em;
	right: .5em;
}
.t-window-title .t-image {
	margin: 0 5px 0 0;
	vertical-align: middle;
}
.t-window-content {
	padding: .4em .5em;
	overflow: auto;
	-moz-border-radius-bottomleft: 4px;
	-moz-border-radius-bottomright: 4px;
	-webkit-border-bottom-left-radius: 4px;
	-webkit-border-bottom-right-radius: 4px;
	border-bottom-left-radius: 4px;
	border-bottom-right-radius: 4px;
}
.t-window-actions {
	position: absolute;
	right: .4em;
	top: 80px;
}
.t-window-action {
	text-decoration: none;
	vertical-align: bottom;
	display: inline-block;*;
	display: inline;
	zoom: 1;
	opacity: 10;
	filter: alpha(opacity=100);
}
.t-window-action .t-icon {
	margin: -7px -5px;
	vertical-align: top;
}
.t-window .t-resize-handle {
	position: absolute;
	z-index: 1;
	background-color: #fff;
	opacity: 0;
	filter: alpha(opacity=0);
	zoom: 1;
	border: 1px solid #000;
	line-height: 6px;
	font-size: 0;
}
.t-overlay {
	width: 100%;
	height: 100%;
	position: fixed;
	top: 0;
	left: 0;
	background-color: #000;
	filter: alpha(opacity=90);
	opacity: .9;
	z-index: 10000;
}
.t-window .t-overlay {
	background-color: #fff;
	opacity: 0;
	filter: alpha(opacity=0);
	position: absolute;
	width: 100%;
	height: 100%;
}
.t-window .t-widget {
	z-index: 10000;
}
/* TabStrip */
#MemberOptPanel.t-tabstrip {
	background-color: transparent;
	margin: 0;
	margin-top: 29px;
	padding: 0;
	zoom: 1;
	width:575px;
}


#MemberOptPanel.t-tabstrip .t-tabstrip-items {
	padding:2px 0px 4px 0px;
}
 
#MemberOptPanel.t-tabstrip .t-item,#MemberOptPanel .t-panelbar .t-tabstrip .t-item {
	list-style-type: none;
	display: inline-block; *;
	display: inline;
	zoom: 1;
	border-width: 0px;
	border-style: solid;
	 
	position: relative;
	top: 5px;
	left:2px;
}
#MemberOptPanel.t-tabstrip .t-link,#MemberOptPanel.t-panelbar .t-tabstrip .t-link {
	padding: .5em .4em 8px 7px;
	display: inline-block; *;
	display: inline;
	zoom: 1;
	border-bottom-width: 0;
	outline: 0;
}
#MemberOptPanel.t-tabstrip .t-tabstrip-items a.t-link {
	color: #0f597f!important;
}
#MemberOptPanel.t-tabstrip li.t-state-active .t-link {
	color: #4a2a13!important;
	background-image: none;
    background-position: 0 0;
    background-repeat: no-repeat;
}
#MemberOptPanel.t-tabstrip li a.t-link {
	 
	line-height: 0px;
	font-size: 18px;
 
	 border:0px solid #000;
	white-space: nowrap;
	text-align: left!important;
}
#MemberOptPanel.t-tabstrip li.t-state-active {
 
	padding-left: 12px;
	margin-right:0px;
	float: left;
}

.error {
	font-size : 12px;
	color : maroon;
	padding-left: 40px; padding-bottom: 5px;
}
.location {
	margin: auto;
	width: 208px;
	height: 182px;
	border: 1px solid #ccc;
}

form label {
    border: 0 solid #000000;
    display: block;
    float: left;
    margin: 0 0 0 0;
    width: auto;
}


#Windowlogin .t-tabstrip li.t-state-active a.t-link {
    background-image: none;
    background-position: 100% 0;
    background-repeat: no-repeat;
    color: #0F7F3D;border:0 solid red;
}
 
#Windowlogin .t-tabstrip li.t-state-default a.t-link {
    background-image:none;
    background-position: 100% 0px;
    background-repeat: no-repeat;
    color: #0F7F3D;
}
.t-tabstrip .t-content form {
   padding-top:30px!important;/*
</style>
<script type="text/javascript" language="javascript">
    function readCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    }

    $(document).ready(function () {
        var usr = readCookie('UserInfo')
        var pass = readCookie('PassInfo')

        if (usr == null) {
            $("#LogUserName").attr("value", "");
        }
        else {
            $("#LogUserName").attr("value", usr);
        }

        if (pass == null) {
            $("#LogPassword").attr("value", "");
        }
        else {
            $("#LogPassword").attr("value", pass);
        }
        $("#UserName").attr("value", "");
        $("#Password").attr("value", "");
    });

    $(function () {
        $("#btnLogin").click(function () {
            var lblerr = document.getElementById('ErrMsg');
            lblerr.innerHTML = "Please wait ..";
            var valUsername = $("#LogUserName").attr("value");
            var valPassword = $("#LogPassword").attr("value");
            if (valUsername.length < 1 || valPassword.length < 1) {
                lblerr.innerHTML = "Please enter required values";
            }
            else {
                $.getJSON("/Member/CheckMember/?userName=" + $("#LogUserName").attr("value") + "&password=" + $("#LogPassword").attr("value"),
                        function (data) {
                            if (data.toString() == "false") {
                                lblerr.innerHTML = "Invalid Username or Password";
                            }
                            else {
                                lblerr.innerHTML = "Login successful, Please wait...";
                                //document.forms[0].submit();
                                document.forms['P2LoginForm'].submit();
                            }
                        });
            }
        });

        $("#LogPassword").keypress(function (event) {
            if (event.keyCode == '13') {
                var lblerr = document.getElementById('ErrMsg');
                lblerr.innerHTML = "Please wait ..";
                var valUsername = $("#LogUserName").attr("value");
                var valPassword = $("#LogPassword").attr("value");

                if (valUsername.length < 1 || valPassword.length < 1) {
                    lblerr.innerHTML = "Please enter required values";
                }
                else {
                    $.getJSON("/Member/CheckMember/?userName=" + $("#LogUserName").attr("value") + "&password=" + $("#LogPassword").attr("value"),
                        function (data) {
                            if (data.toString() == "false") {
                                lblerr.innerHTML = "Invalid Username or Password";
                            }
                            else {
                                lblerr.innerHTML = "Login successful, Please wait...";
                                document.forms['P2LoginForm'].submit();
                            }
                        });
                }
            }
        });

        $("#btnSingnup").click(function () {
            var valUser = $("#UserName").attr("value");
            var valPassword = $("#Password").attr("value");
            var valConfPassword = $("#ConfirmPassword").attr("value");
            var valFName = $("#FirstName").attr("value");
            var valLName = $("#LastName").attr("value");
            var lblerr1 = document.getElementById('ErrMsg1');
            lblerr1.innerHTML = "Please wait ..";
            if (valUser.length < 1 || valPassword.length < 1 || valConfPassword.length < 1 || valFName.length < 1 || valLName.length < 1) {
                lblerr1.innerHTML = "Please enter required values";
            }
            else if (valPassword.length < 6) {
                lblerr1.innerHTML = "Please enter atleast 6 characters in password";
            }
            else {
                var emailReg = "^[\\w-_\.+]*[\\w-_\.]\@([\\w]+\\.)+[\\w]+[\\w]$";
                var regex = new RegExp(emailReg);
                if (!regex.test(valUser.toString())) {
                    lblerr1.innerHTML = "Please insert valid email address";
                }
                else {
                    if (valPassword.toString() != valConfPassword.toString()) {
                        lblerr1.innerHTML = "Password and Confirm Password does not match.";
                    }
                    else {
                        $.getJSON("/Member/CheckUserSignUp/?userName=" + $("#UserName").attr("value") + "&captaText=" + $("#recaptcha_response_field").attr("value") + "&checkString=" + $("#recaptcha_challenge_field").attr("value"),
                        function (data) {
                            if (data.toString() == "true") {
                                document.forms['P2SignUpForm'].submit();
                            }
                            else {
                                lblerr1.innerHTML = data.toString();
                            }
                        });
                    }
                }
            }
        });

        $("#recaptcha_response_field").keypress(function (event) {
            if (event.keyCode == '13') {
                var valUser = $("#UserName").attr("value");
                var valPassword = $("#Password").attr("value");
                var valConfPassword = $("#ConfirmPassword").attr("value");
                var valFName = $("#FirstName").attr("value");
                var valLName = $("#LastName").attr("value");
                var lblerr1 = document.getElementById('ErrMsg1');

                if (valUser.length < 1 || valPassword.length < 1 || valConfPassword.length < 1 || valFName.length < 1 || valLName.length < 1) {
                    lblerr1.innerHTML = "Please enter required values";
                }
                else {
                    if (valPassword.toString() != valConfPassword.toString()) {
                        lblerr1.innerHTML = "Password and Confirm Password does not match.";
                    }
                    else {
                        $.getJSON("/Member/CheckUserSignUp/?userName=" + $("#UserName").attr("value") + "&captaText=" + $("#recaptcha_response_field").attr("value") + "&checkString=" + $("#recaptcha_challenge_field").attr("value"),
                        function (data) {
                            if (data.toString() == "true") {
                                document.forms['P2SignUpForm'].submit();
                            }
                            else {
                                lblerr1.innerHTML = data.toString();
                            }
                        });
                    }
                }
            }
        });
    });

    function SelectLoginTab(selVal) {
        var tabstrip1 = $("#MemberOptPanel").data("tTabStrip");
        var item = $("li", tabstrip1.element)[selVal];
        tabstrip1.select(item);
    }

    function callLoginPartialWindow(selVal) {
        var w1 = $('#Windowlogin').data('tWindow');
        w1.center().open();
        SelectLoginTab(selVal);
    }
</script>
<div id="login" style="display: none">
</div>
<div id="name">
</div>
<div id="fb-root">
</div>
<script type="text/javascript">
    window.fbAsyncInit = function () {
        //Beta
        FB.init({ appId: '109562952457897', status: true, cookie: true, xfbml: true });
        //SeedSpeak
        //FB.init({ appId: '207863225896222', status: true, cookie: true, xfbml: true });

        /* All the events registered */
        FB.Event.subscribe('auth.login', function (response) {
            // do something with response 
            login();
        });
        FB.Event.subscribe('auth.logout', function (response) {
            // do something with response 
            logout();
        });

        FB.getLoginStatus(function (response) {
            if (response.session) {
                // logged in and connected user, someone you know 
                login();
            }
        });
    };
    (function () {
        var e = document.createElement('script');
        e.type = 'text/javascript';
        e.src = document.location.protocol +
                    '//connect.facebook.net/en_US/all.js';
        e.async = true;
        document.getElementById('fb-root').appendChild(e);
    } ());

    function loggout() {        
        FB.logout(function (response) {
            // user is now logged out
        });
    }

    function login() {
        FB.api('/me', function (response) {            
            document.getElementById('fbUserId').value = response.id;
            var query = FB.Data.query('select name, email, pic_square from user where uid={0}', response.id);
            query.wait(function (rows) {
                document.getElementById('fbUserName').value = rows[0].name;
                document.getElementById('fbUserEmail').value = rows[0].email;
                document.getElementById('fbUserPic').value = rows[0].pic_square;
                document.getElementById('btnFbSubmit').click();
            });
            loggout();
        });
    }
    function logout() {
        document.getElementById('login').style.display = "none";
    }
</script>
<script language="javascript" type="text/javascript">
    $(document).ready(function () {
        var str = location.href.toLowerCase();
        $('#sort td a').each(function () {
            if (str.indexOf(this.href.toLowerCase()) > -1) {
                $(this).attr("class", "current"); //hightlight parent tab 
            }
        });
    });   
</script>
<% Html.Telerik().Window()
           .Name("Windowlogin")
           .Title("Login")
           .Draggable(true)
           .Resizable(resize => resize
               .Enabled(true)
               )
               .Visible(false)

               .Modal(true)
               .Buttons(b => b.Close())
               .Content(() =>
                   {                      
%>
<% Html.Telerik().TabStrip()
           .Name("MemberOptPanel")
           .Items(tabstrip =>
               {
                   tabstrip.Add()
                      .Text("Login")
                       .Content(() =>
                                   {%>
<div class="logincontent">
    <div class="loginoutter">
        <div class="loginInnerP">
            <% using (Html.BeginForm("Login", "Member", FormMethod.Post, new { enctype = "multipart/form-data", id = "P2LoginForm" }))
               {%>
            <div class="FBbtn">                
                <fb:login-button autologoutlink="true" perms="email,user_birthday,status_update,publish_stream">Login with Facebook</fb:login-button>
            </div>
            <div id="ErrMsg" class="error" style="padding-left: 40px!important">
            </div>
            <p>
                <%: Html.LabelFor(model => model.LogUserName)%>
                <em></em>
                <br />
                <%: Html.TextBoxFor(model => model.LogUserName) %>
            </p>
            <p>
                <%: Html.LabelFor(model => model.LogPassword)%>
                <em></em>
                <br />
                <%: Html.PasswordFor(model => model.LogPassword) %>
            </p>
            <p class="multicontrl">
                <span style="float: left; width: 50%; text-align: left; margin-top: -10px;">
                    <input type="checkbox" value="Remember me" name="chkRemember" />Remember me
                </span><span style="float: left; width: 94%; text-align: right">
                    <input id="btnLogin" type="button" value="" class="logbtn" />
                </span>
            </p>
            <% } %>
            <div class="clear">
            </div>
            <% using (Html.BeginForm("ForgotPassword", "Member", FormMethod.Post, new { enctype = "multipart/form-data", id = "P2ForgetPwd" }))
               {%>
            <div class="passwordbox">
                <p>
                    Forgot Password?
                    <br />
                    <%: Html.TextBoxFor(model => model.ForgotUserName)%>
                    <br />
                    <%: Html.ValidationMessageFor(model => model.ForgotUserName) %>
                </p>
                <p style="text-align: right">
                    <input type="submit" value="" class="Recbtn" /></p>
            </div>
            <% } %>
        </div>
    </div>
</div>
<%});

                   tabstrip.Add()
                       .Text("Sign Up")
                       .Content(() =>
                       {%>
<div class="logincontent">
    <div class="loginoutter">
        <div class="registercontent">
            <em style="float: right!important; margin-top: 10px; position: relative; right: 25px;
                border: 0px solid #000;">Required</em><div class="clear">
                </div>
            <% using (Html.BeginForm("SignUpUser", "Member", FormMethod.Post, new { enctype = "multipart/form-data", id = "P2SignUpForm" }))
               {%>
            <div id="ErrMsg1" class="error">
            </div>
            <p style="text-align: left">
                <%: Html.LabelFor(model => model.UserName) %><em></em>
                <%: Html.TextBoxFor(model => model.UserName) %>
                <%: Html.ValidationMessageFor(model => model.UserName) %>
            </p>
            <p>
                <%: Html.LabelFor(model => model.organisationName) %>
                <%: Html.TextBoxFor(model => model.organisationName) %>
            </p>
            <p>
                <%: Html.LabelFor(model => model.Password) %><em></em>
                <%: Html.PasswordFor(model => model.Password) %>
                <%: Html.ValidationMessageFor(model => model.Password) %></p>
            <p>
                <%: Html.LabelFor(model => model.ConfirmPassword) %><em></em>
                <%: Html.PasswordFor(model => model.ConfirmPassword) %>
                <%: Html.ValidationMessageFor(model => model.ConfirmPassword) %></p>
            <p>
                <%: Html.LabelFor(model => model.FirstName) %><em></em>
                <%: Html.TextBoxFor(model => model.FirstName, new { maxlength = 15 })%>
                <%: Html.ValidationMessageFor(model => model.FirstName) %>
            </p>
            <p>
                <%: Html.LabelFor(model => model.LastName) %><em></em>
                <%: Html.TextBoxFor(model => model.LastName, new { maxlength = 15 })%>
                <%: Html.ValidationMessageFor(model => model.LastName) %>
            </p>
            <div class="clear">
            </div>
            <div class="single">
                <b>Are you A Human ?</b><em></em><br />
                <small>To prevent site post attacks, please enter the following text.</small>
                <div class="clear">
                </div>
                <div class="captacha">
                    <%= Html.GenerateCaptcha() %></div>
            </div>
            <p class="btn">
                <input id="btnSingnup" type="button" value="" class="singup" />
            </p>
            <% } %>
        </div>
    </div>
</div>
<%});
               }).SelectedIndex(0).Render();
%>
<%})
                 .Width(600)
                 .Height(650)
                 .Render();
%>
<span style="display: none;">
    <% using (Html.BeginForm("FbLogin", "Member",
                    FormMethod.Post, new { enctype = "multipart/form-data", id = "fbLoginForm" }))
       {%>
    <input type="hidden" id="fbUserId" name="fbUserId" />
    <input type="hidden" id="fbUserName" name="fbUserName" />
    <input type="hidden" id="fbUserEmail" name="fbUserEmail" />
    <input type="hidden" id="fbUserPic" name="fbUserPic" />
    <input type="submit" id="btnFbSubmit" value="Submit Facebook" style="display: none;" />
    <%} %>
</span>