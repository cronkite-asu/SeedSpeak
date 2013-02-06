<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<SeedSpeak.Model.Validation.RegisterModel>" %>

<%@ Register Src="~/Views/Seed/ShareIdea.ascx" TagName="ShareIdea" TagPrefix="SeedSpeakUC" %>
<%@ Register Src="~/Views/Seed/ReplySeed.ascx" TagName="ReplySeed" TagPrefix="SeedSpeakUC" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://opengraphprotocol.org/schema/"
xmlns:fb="http://www.facebook.com/2008/fbml">
<head id="Head1" runat="server">
    <title>SeedSpeak</title>
    <script src="../../Scripts/2010.2.825/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/2010.2.825/jquery.validate.min.js" type="text/javascript"></script>    
    <script src="../../Scripts/MicrosoftAjax.js" type="text/javascript"></script>
    <link href="../../Fonts/stylesheet.css" rel="stylesheet" type="text/css" charset="utf-8" />
    <script src="../../Scripts/jquery.watermarkinput.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.autogrowtextarea.js" type="text/javascript"></script>
    <script src="../../jwPlayer/jwplayer.js" type="text/javascript"></script>
    <script src="../../jwPlayer/swfobject.js" type="text/javascript"></script>
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script src="../../Scripts/infobox.js" type="text/javascript"></script>
    <script src="../../Scripts/MicrosoftMvcAjax.js" type="text/javascript"></script>
    <script src="../../Scripts/jqwatermark.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.autocomplete.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.MultiFile.js" type="text/javascript"></script>    
    <script type="text/javascript" src="../../Scripts/csspopup.js"></script>
  
    <link href="../../Content/HomeP2.css" rel="stylesheet" type="text/css" />
    <link href="../../Content/Common.css" rel="stylesheet" type="text/css" />    
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
    <script type="text/javascript" language="javascript">
        jQuery(function ($) {
            $("#addr").Watermark("Set Your location, neighborhoods, city");
            $("#Criteria").Watermark("Search by user, category, keywords");            
            $("#searchhdtext").Watermark("Search by user, category, keywords");
        });
    </script>
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

        function Select(selVal) {
            var tabstrip = $("#MemberOptPanel").data("tTabStrip");
            var item = $("li", tabstrip.element)[selVal];
            tabstrip.select(item);
        }

        function callLoginWindow() {
            var w = $('#Windowlogin').data('tWindow');
            w.center().open();
            Select(0);
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

        function ClearCountTxtComment(txtCmtClr, cmtCtrDivId) {
            $('#gridbox').find('textarea#' + txtCmtClr).val("");

            var ctrObj = $("#" + cmtCtrDivId + " a");
            var numCmt = ctrObj.html();
            numCmt = parseInt(numCmt) + 1;
            ctrObj.html(numCmt);
        }

        function fnLikeSuccess(likedId) {
            var btnVal = $("#" + likedId).val();
            if (btnVal == "Like") {
                $("#" + likedId).val("Dislike");
                $("#" + likedId).attr("class", "clsBtnDislike");
            }
            else {
                $("#" + likedId).val("Like");
                $("#" + likedId).attr("class", "clsBtnLike");
            }
        }

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
    </script>
    <script type="text/javascript" language="javascript">
        jQuery(function ($) {
            $("#ForgotUserName").Watermark("Enter your email address");
        });

        var hidingTimer;
        function HideSeed(hideSeedId) {
            var confirm_box = confirm('Are you sure you want to hide this seed ?');
            if (confirm_box) {
                var Seedid = hideSeedId.replace("HideSeed", "");
                $.getJSON("/Seed/HideUnhide/?seedId=" + Seedid + "&btnAction=Hide", function (data) {
                    if (data.toString() == "true") {
                        $("#" + hideSeedId).parent().parent().parent().parent().hide("slow");
                        var divClick = "javascript:ShowHiddenSeed('" + hideSeedId + "')";
                        $("#" + hideSeedId).parent().parent().parent().parent().parent().append("<span class='autoDivHide'>This seed is hidden from your feed. <a href=" + divClick + ">Undo</a></span>");
                        var masterDiv = $("#" + hideSeedId).parent().parent().parent().parent().parent().parent().get(0).id;
                        hidingTimer = setTimeout(function () { $("#" + masterDiv).hide("slow"); }, 5000);
                    }
                });
            }
        }

        function ShowHiddenSeed(hideSeedId) {
            clearTimeout(hidingTimer);
            var Seedid = hideSeedId.replace("HideSeed", "");
            $.getJSON("/Seed/HideUnhide/?seedId=" + Seedid + "&btnAction=Unhide", function (data) {                
                if (data.toString() == "true") {
            $("#" + hideSeedId).parent().parent().parent().parent().show("slow");
            $('.autoDivHide').remove();
                }
            });
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#txtDesc").autoGrow();
        });

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
    </script>
    <script type="text/javascript">
        function load() {
            var c = 0;
            var location = document.getElementById('HiddenMarkers').value.split(',');

            var startLat = document.getElementById('defaultLat').value;
            var startLng = document.getElementById('defaultLng').value;
            if (startLat != "" && startLng != "") {
                var centerLoc = new google.maps.LatLng(document.getElementById('defaultLat').value, document.getElementById('defaultLng').value);
            }
            else {
                var centerLoc = new google.maps.LatLng(location[c], location[c + 1]);
            }

            var myMapOptions = {
                zoom: 10,
                center: centerLoc,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                scrollwheel: false,
                navigationControl: false,
                mapTypeControl: false,
                scaleControl: false,
                streetViewControl: false,
                zoomControl: true,
                zoomControlOptions: {
                    style: google.maps.ZoomControlStyle.SMALL,
                    position: google.maps.ControlPosition.LEFT_CENTER
                }
            };
            var theMap = new google.maps.Map(document.getElementById("map"), myMapOptions);
            var iconMarker = new google.maps.MarkerImage('../../Content/images/mapSeedIcon.png',
            new google.maps.Size(54, 48),
            new google.maps.Point(0, 0),
            new google.maps.Point(14, 18),
            new google.maps.Size(54, 48)
            );
            
            var newMarkers = [];
            for (var i = 0; i < location.length; i++) {
                marker = new google.maps.Marker({
                    map: theMap,
                    icon: iconMarker,
                    position: new google.maps.LatLng(location[i], location[i + 1]),
                    visible: true
                })

                newMarkers.push(marker);

                //define the text and style for all infoboxes
                var boxText = document.createElement("div");
                boxText.style.cssText = "border: solid 6px #444; margin-top: 35px; margin-left:30px; color:black; font-family:'Verdana'; background: url(../../Content/images/dd.jpg) #232929 repeat-x left top; line-height:18px; font-size:13px; padding: 10px 15px; border-radius:6px; -webkit-border-radius:10px; -moz-border-radius:10px;";
                
                boxText.innerHTML = "<a href='" + location[i + 2] + "'><span style='color:#015289; font-size:15px;'>" + location[i + 3] + "</span></a><br>" + location[i + 4];

                //define the options for all infoboxes
                var myOptions = {
                    content: boxText,
                    disableAutoPan: false,
                    maxWidth: 0,
                    pixelOffset: new google.maps.Size(-140, 0),
                    zIndex: null,
                    boxStyle: {
                        background: "url('../../Content/images/tipbox.gif') no-repeat 13px 28px",
                        opacity: 0.99,
                        width: "270px"
                    },
                    closeBoxMargin: "43px 8px 2px 10px",
                    closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif",
                    infoBoxClearance: new google.maps.Size(1, 1),
                    isHidden: false,
                    pane: "floatPane",
                    enableEventPropagation: false
                };

                newMarkers[i].infobox = new InfoBox(myOptions);

                google.maps.event.addListener(marker, 'click', (function (marker, i) {
                    return function () {
                        for (h = 0; h < newMarkers.length; h++) {
                            newMarkers[h].infobox.close();
                        }
                        newMarkers[i].infobox.open(theMap, this);
                        theMap.panTo(new google.maps.LatLng(location[i], location[i + 1]));
                    }
                })(marker, i));
            }
        }

        $(function () {
            $("#addr").keypress(function (event) {
                if (event.keyCode == '13') {
                    return DefaultSearchProcess();
                }
            });
        });

        function DefaultSearchProcess() {            
            if (document.getElementById('addr').value != "Set Your location, neighborhoods, city") {
                var geocoder = new google.maps.Geocoder();
                var address = $("#addr").val();
                var loc = address.replace("Your Location : ", "");                
                geocoder.geocode({ 'address': loc }, function (results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {                        
                        var latitude = results[0].geometry.location.lat();
                        var longitude = results[0].geometry.location.lng();
                        $("#postLat").val(latitude);
                        $("#postLng").val(longitude);
                        var newlats = new google.maps.LatLng(latitude, longitude);
                        geocoder.geocode({ 'latLng': newlats }, function (results, status) {
                            if (status == google.maps.GeocoderStatus.OK) {                                
                                var currAddress = results[0].formatted_address;
                                var splitCurrAddress = currAddress.split(',');
                                var stateZip = "";
                                if (splitCurrAddress.length > 4) {
                                    stateZip = trim(splitCurrAddress[3]);
                                }
                                else {
                                    stateZip = trim(splitCurrAddress[2]);
                                }                                
                                var finalZip = stateZip.split(' ');
                                $("#postZip").val(trim(finalZip[1].toString()));
                                document.forms['GMapForm'].submit();
                            }
                        });
                    }
                });
            }
            return false
        }

        $(function () {
            var preValue = document.getElementById('addr').value;
            $("#addr").blur(function (event) {
                var postValue = document.getElementById('addr').value;
                if (document.getElementById('addr').value != "Set Your location, neighborhoods, city") {
                    if (preValue != postValue) {
                        var geocoder = new google.maps.Geocoder();
                        var address = $("#addr").val();
                        var loc = address.replace("Your Location", "");
                        geocoder.geocode({ 'address': loc }, function (results, status) {
                            if (status == google.maps.GeocoderStatus.OK) {
                                var latitude = results[0].geometry.location.lat();
                                var longitude = results[0].geometry.location.lng();
                                $("#postLat").val(latitude);
                                $("#postLng").val(longitude);
                                
                                var newlats = new google.maps.LatLng(latitude, longitude);
                                
                                geocoder.geocode({ 'latLng': newlats }, function (results, status) {
                                    if (status == google.maps.GeocoderStatus.OK) {                                        
                                        var currAddress = results[0].formatted_address;
                                        var splitCurrAddress = currAddress.split(',');
                                        var stateZip = "";                                        
                                        if (splitCurrAddress.length > 4) {
                                            stateZip = trim(splitCurrAddress[3]);
                                        }
                                        else {
                                            stateZip = trim(splitCurrAddress[2]);
                                        }
                                        var finalZip = stateZip.split(' ');                                        
                                        $("#postZip").val(trim(finalZip[1].toString()));
                                        document.forms['GMapForm'].submit();
                                    }
                                });
                            }
                        });
                    }
                }
                return false
            });
        });

        function LTrim(value) {
            var re = /\s*((\S+\s*)*)/;
            return value.replace(re, "$1");
        }

        // Removes ending whitespaces
        function RTrim(value) {
            var re = /((\s*\S+)*)\s*/;
            return value.replace(re, "$1");
        }

        // Removes leading and ending whitespaces
        function trim(value) {
            return LTrim(RTrim(value));
        }
    </script>
    <script language="javascript" type="text/javascript">
        function showonlyone(thechosenone) {
            var newboxes = document.getElementsByTagName("div");
            var type = thechosenone.substring(0, 8);
            for (var x = 0; x < newboxes.length; x++) {
                name = newboxes[x].getAttribute("name");
                if (name == 'newboxes') {
                    if (newboxes[x].id == thechosenone) {
                        if (newboxes[x].style.display == 'none') {
                            newboxes[x].style.display = 'block';
                            if (type == 'replyBox') {
                                $("#" + thechosenone).html("Loading content, please wait....");
                                $("#" + thechosenone).load('<%= Url.Action("GetReplyPartial", "Seed") %>');
                            }
                        }
                        else {
                            newboxes[x].style.display = 'none';
                            if (type == 'replyBox') {
                                if (newboxes[x].id.indexOf("replyBox") != -1) {
                                    $("#" + newboxes[x].id).html("Unloading content, please wait....");
                                    $("#" + newboxes[x].id).html("");
                                }
                            }
                        }
                    }
                    else {
                        newboxes[x].style.display = 'none';
                        if (type == 'replyBox') {
                            if (newboxes[x].id.indexOf("replyBox") != -1) {
                                $("#" + newboxes[x].id).html("Unloading content, please wait....");
                                $("#" + newboxes[x].id).html("");
                            }
                        }
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

        function Paging(navigate) {
            if (navigate == "Next") {
                $("#btnNext").click();
            }
            if (navigate == "Prev") {
                $("#btnPrevious").click();
            }
        }
    </script>
    <%--
image pop up--%>
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
    <%--video--%>
    <%--for multi select list box--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $('select#sel0').simpleMultiSelect();

            $('input#nada0').click(function () {
                $('select#sel0').smsNone();
            });
            $('input#todos0').click(function () {
                $('select#sel0').smsAll();
            });

            $('select#sel1').simpleMultiSelect({
                classesOnly: true,
                pseudoSelect: 'custom-select-box',
                selected: 'custom-select',
                unselected: 'custom-unselect',
                disabled: 'custom-disabled',
                optgroup: 'custom-optgroup',
                optgroupLabel: 'custom-optgroup-label'
            });

            $('input#nada1').click(function () {
                $('select#sel1').smsNone();
            });

            $('input#todos1').click(function () {
                $('select#sel1').smsAll();
            });

        });
    </script>
    <%--for multi select list box--%>
    <script type="text/javascript">
        function expcom(sHDiv, switchImgTag) {
            var ele = document.getElementById(sHDiv);
            var imageEle = document.getElementById(switchImgTag);
            if (ele.style.display == "block") {
                ele.style.display = "none";
                imageEle.innerHTML = '<img src="../../Content/images/plusPbox.png" style="float:left;">';
            }
            else {
                ele.style.display = "block";
                imageEle.innerHTML = '<img src="../../Content/images/minusPbox.png" style="float:left;">';
            }
        }

        $(document).ready(function () {
            $(".clsFollow,.clsUnFollow").click(function () {
                var cUserID = $(this).attr('id').split('_');
                var buttonID = $(this).attr('id');
                var cUser = cUserID[1];
                var cValue = $(this).attr('value');
                $.getJSON("/Member/FollowUnfollow/?followingId=" + cUser + "&btnAction=" + cValue,
          function (data) {
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
                $.getJSON("/Member/MuteUnMute/?muteId=" + cUser + "&btnAction=" + cValue,
          function (data) {
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

            $(".clsbtnFollow,.clsbtnUnFollow").click(function () {
                var cUserID = $(this).attr('id').split('_');
                var buttonID = $(this).attr('id');
                if (buttonID != "") {
                    var cUser = cUserID[1];
                    var cValue = $(this).attr('value');
                    $.getJSON("/Member/FollowUnfollow/?followingId=" + cUser + "&btnAction=" + cValue,
          function (data) {
              if (data.toString() != "") {
                  if (data.toString() == "Follow") {
                      $("#" + buttonID).attr("class", "clsbtnFollow");
                  }
                  if (data.toString() == "Unfollow") {
                      $("#" + buttonID).attr("class", "clsbtnUnFollow");
                  }
                  $("#" + buttonID).val(data.toString());
              }
          });
                }
            });

            $(".btndelete").click(function () {
                var confirm_box = confirm('Are you sure you want to delete this seed ?');
                if (confirm_box) {
                    var grdBlock = $(this).parent().parent().parent().parent().get(0).id;
                    var deleteSeedid = grdBlock.replace("grdBlock", "");
                    $.getJSON("/Seed/TerminateMySeed/?id=" + deleteSeedid, function (data) {
                        if (data.toString() != "") {
                            $("#" + grdBlock).hide("slow");
                        }
                    });
                }
            });
        });

        $(document).ready(function () {
            $("#lnkCategories").hide();

            $("#browseSection").click(function () {
                $("#Criteria").hide("slow");
                $("#lnkCategories").show("slow");
                $("#lnkAdvanced").hide("slow");
                $("#searchSection").attr("class", "btnsearch");
                $("#browseSection").attr("class", "btnbrowse-hlt");
                $("#divAdvanceSearch").hide("slow");
                $("#divEditCategory").show("slow");
                fleXenv.initByClass("sms-pseudo-select");
            });

            $("#searchSection").click(function () {
                $("#Criteria").show("slow");
                $("#lnkAdvanced").show("slow");
                $("#lnkCategories").hide("slow");
                $("#searchSection").attr("class", "btnsearch-hlt");
                $("#browseSection").attr("class", "btnbrowse");
                $("#divEditCategory").hide("slow");
            });

            $("#lnkAdvanced").click(function () {
                $("#divAdvanceSearch").toggle("slow");
            });

            $("#lnkCategories").click(function () {
                $("#divEditCategory").toggle("slow");
            });
        });

        $(document).ready(function () {
            var aloc = $("#addr").val();
            $("#catInLocation").html(aloc.replace("Your Location : ", ""));
            $("#seedInLocation").html(aloc.replace("Your Location : ", ""));
        });
    </script>
</head>
<body onload="load();" style="background-color: Transparent">
<span style="display:none;">
<% using (Html.BeginForm("FbLogin", "Member",
                    FormMethod.Post, new { enctype = "multipart/form-data", id = "fbLoginForm" }))
                           {%>
<input type="hidden" id="fbUserId" name="fbUserId" />
<input type="hidden" id="fbUserName" name="fbUserName" />
<input type="hidden" id="fbUserEmail" name="fbUserEmail" />
<input type="hidden" id="fbUserPic" name="fbUserPic" />
<input type="submit" id="btnFbSubmit" value="Submit Facebook" style="display:none;" />
<%} %>
</span>
<div id="login" style ="display:none"></div> 
        <div id="name"></div> 
    <%   int imr = 0; %>
    <script type="text/javascript" language="javascript">
        function Select(selVal) {
            var tabstrip = $("#MemberOptPanel").data("tTabStrip");
            var item = $("li", tabstrip.element)[selVal];
            tabstrip.select(item);
        }
    </script>    
    <div id="fb-root"></div>
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
    <div class="outerwrap">
        <div id="wrapper2">
            <%--Script to enable client side validation--%>            
            <script src="../../Scripts/MicrosoftMvcValidation.js" type="text/javascript"></script>
            <% Html.EnableClientValidation(); %>
            <div id="header" style="height: 105px">
                <div id="menucontainer">
                    <a href="../../Member/Default" class="logo"><span>Logo</span></a>
                    <div id="topNav">
                        <a class="discover" href="/Member/Default"></a><a class="streams" href="/Home/Feeds">
                        </a><a class="people" href="/Member/TopPeople"></a><a class="about" href="/Home/About">
                        </a>
                    </div>
                    <%
                        SeedSpeak.Model.Member mData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
                    %>
                    <% Html.RenderPartial("AuthenticationPartial"); %>
                </div>
                <div class="clear">
                </div>
            </div>
            <div class="clear">
            </div>
            <div id="Main">
                <div class="container">
                    <div class="brownHeader">
                        <% using (Html.BeginForm("Default", "Member",
                    FormMethod.Post, new { enctype = "multipart/form-data", id = "GMapForm" }))
                           {%>
                        <div class="mapsearch">
                            <div class="srchL">
                            <input type="hidden" id="postLat" name="postLat" />
                            <input type="hidden" id="postLng" name="postLng" />
                            <input type="hidden" id="postZip" name="postZip" />
                            </div>
                            <div class="srchmid">
                                <div class="sb">
                                    <input type="button" id="browseSection" class="btnbrowse" value="" />
                                    <input type="button" id="searchSection" class="btnsearch-hlt" value="" />
                                </div>
                                <%: Html.TextBox("addr", ViewData["userLocation"] != null ? ViewData["userLocation"].ToString() : "", new { style = "width:235px; padding-right:10px;" })%>
                                <%: Html.TextBox("Criteria" )  %>
                                <input type="button" value="" class="go" id="btnSearchGo" name="btnSearchGo" onclick="javascript:return DefaultSearchProcess();" />
                                <div class="divi">
                                    <a id="lnkAdvanced" href="#" style="color: #b8d8e9; font-size: 12px; padding: 0 10px 0 0;
                                        margin-left: 15px">Advanced</a><a id="lnkCategories" href="#" style="color: #b8d8e9;
                                            font-size: 12px; padding: 0 10px; display: none;">Edit Categories</a>
                                </div>
                            </div>
                            <div class="srchR">
                            </div>
                            <div style="clear: both">
                            </div>
                            <div id="divEditCategory" style="display: none;">
                                <div style="margin-left: 25px; color: White; font-size: 13px; line-height: 15px;
                                    padding-top: 10px">
                                    Categories in <span id="catInLocation"></span><br />
                                    <span style="color: #dde2e6; font-size: 12px; font-style: italic">click to select multiple</span>
                                </div>
                                <input id="searchCriteriaTxt" name="searchCriteriaTxt" type="text" value='<%=Session["SelectedCategory"] %>'
                                    style="visibility: hidden; display: none" />
                                <div class="catM">
                                    <select name="sel0" id="sel0" multiple="multiple" style="border: 0px; width: 160px;">
                                        <%
SeedSpeak.Data.Repository.Repository objRepo = new SeedSpeak.Data.Repository.Repository();
IList<SeedSpeak.Model.Category> catList = (IList<SeedSpeak.Model.Category>)ViewData["SeedCategories"];
if (catList == null || catList.Count == 0)
{
    catList = objRepo.List<SeedSpeak.Model.Category>(x => x.status.Equals(SeedSpeak.Util.SystemStatements.CATEGORY_ACTIVE)).ToList();
}                              
                               
                               string[] selectedCat = null;
                               bool isMatch = false;

                               if (Session["SelectedCategory"] != null)
                               {
                                   selectedCat = Session["SelectedCategory"].ToString().Split(',');
                               }
                               for (int i = -1; i < catList.Count; i++)
                               {
                                   if (Session["SelectedCategory"] != null)
                                   {
                                       for (int j = 0; j < selectedCat.Length; j++)
                                       {
                                           if (i != -1)
                                           {
                                               if (catList.ElementAt(i).id.ToString() == selectedCat[j].ToString())
                                               {
                                                   isMatch = true;
                                                   break;
                                               }
                                           }
                                       }
                                       if (isMatch == true)
                                       {
                                           if (i == -1)
                                           {
                                        %>
                                        <option value="all" id="option1" selected="selected" class="selopt">-- ALL --</option>
                                        <% }
                                           else
                                           {
                                        %>
                                        <option value='<%=catList.ElementAt(i).id.ToString() %>' id="option1" selected="selected"
                                            class="selopt">
                                            <%=catList.ElementAt(i).name.ToString()%></option>
                                        <% }
                                       }
                                       else
                                       {
                                           if (i == -1)
                                           {%>
                                        <option value="all" id="option1" class="selopt">-- ALL --</option>
                                        <%}
                                           else
                                           {
                                        %>
                                        <option value='<%=catList.ElementAt(i).id.ToString() %>' id="option3" class="selopt">
                                            <%=catList.ElementAt(i).name.ToString()%></option>
                                        <%
                                           }
                                       }%>
                                        <%}
                                   else
                                   {
                                       if (i == -1)
                                       {
                                           if (selectedCat == null)
                                           {%>
                                        <option value="all" id="option4" selected="selected" class="selopt">-- ALL --</option>
                                        <%}
                                           else
                                           {%>
                                        <option value="all" id="option5" class="selopt">-- ALL --</option>
                                        <%}
                                        %>
                                        <%}
                                       else
                                       {
                                        %>
                                        <option value='<%=catList.ElementAt(i).id.ToString() %>' id="option2" class="selopt">
                                            <%=catList.ElementAt(i).name.ToString()%></option>
                                        <%
                                       }
                                   }
                                   isMatch = false;
                               }%>
                                    </select>
                                </div>
                            </div>
                        </div>                        
                        <div class="map-bdr">
                        </div>
                        <div id="map" style="width: 970px; height: 354px">
                        </div>
                        <div class="Mpagerbtn">
                            <input type="submit" id="btnPrevious" value="." name="btnPrevious" class="Mpre" style='<%: ViewData["PrevVisibility"] %>' />
                            <input type="submit" id="btnNext" value=".." name="btnNext" class="Mnext" style='<%: ViewData["NxtVisibility"] %>' />
                        </div>
                        <div class="clear">
                        </div>
                        <%} %>
                        <div id="divAdvanceSearch" style="display: none;">
                            <div class="top">
                            </div>
                            <div class="middle">
                                <% Html.RenderPartial("AdvanceSearchPartial"); %>
                            </div>
                            <div class="bottom">
                            </div>
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                    <div class="mapbtmL">
                    <%if (mData == null)
                      { %>
                    <a href="javascript:callLoginWindow();" class="loginlnk">
                    Please login to plant your seed</a><%} %>
                        <div class="brownouter">
                            <div class="bcl">
                            </div>
                            <div class="bcm">
                                <%if (mData == null)
                                  { %>
                                <a onclick="javascript:callLoginWindow();" style="cursor: pointer;"><span style="float: left;">
                                    &nbsp;</span>
                                    <img src="../../Content/images/plusPbox.png" style="float: left;"></a>
                                <%}
                                  else
                                  {
                                      if (mData.Role.name == SeedSpeak.Util.SystemStatements.ROLE_END_USER)
                                      {%>                                
                                <a href="javascript:expcom('uccontent', 'imageDivLink');">
                                <span style="float: left;">&nbsp;</span></a>
                                <a id="imageDivLink" href="javascript:expcom('uccontent', 'imageDivLink');">
                                    <img alt="" src="../../Content/images/plusPbox.png" style="float: left;" /></a>
                                <%}
                                      else
                                      {%>
                                <a href="javascript:expcom('uccontent', 'imageDivLink');">
                                <span style="float: left;">PLANT YOUR IDEA NOW </span></a>
                                <a id="imageDivLink" href="javascript:expcom('uccontent', 'imageDivLink');">
                                    <img alt="" src="../../Content/images/plusPbox.png" style="float: left;" /></a>
                                <%
                                      }
                                  } %>
                            </div>
                            <div class="bcr">
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        <%if (mData != null)
                          {%>
                        <div id="uccontent" style="display: none;" class="subpgtext">
                            <div>
                                <SeedSpeakUC:ShareIdea ID="idShareIdea" runat="server" />
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        <%} %>
                        <div class="errormssg">
                            <% if (ViewData["CitySearchMsg"] != null)
                               {
                                   string msg = ViewData["CitySearchMsg"].ToString();
                            %>
                            <%= System.Web.HttpUtility.HtmlDecode(msg)%>
                            <%} %>
                        </div>
                        <span id="seedmessg">
                        Showing Seeds in<span id="seedInLocation"></span>
                         <% if (ViewData["Criteria"] != null){if (ViewData["Criteria"].ToString() != "Search by user, category, keywords")
                         { if(!string.IsNullOrEmpty(ViewData["Criteria"].ToString()))
                         {
                                %>
                         matching your search '<%=ViewData["Criteria"]%>'
                         <%}}} %>.
                            <%if (mData != null)
                              {%>
                            <a onclick="javascript:callStreamWindow();" style="cursor: pointer;">Make a feed</a>
                            from these results<%}
                              else
                              { %>
                            <a onclick="javascript:callLoginWindow();" style="cursor: pointer;">Make a feed</a>
                            from these results
                            <%} %>
                        </span>
                        <% 
                            if (ViewData["SeedList"] != null)
                            {
                                IList<SeedSpeak.Model.Seed> objSeed1 = (List<SeedSpeak.Model.Seed>)ViewData["SeedList"];
                                if (objSeed1.Count > 0)
                                {%>
                        <div id="sort">
                            <table width="100%" border="0">
                                <tr>
                                    <td>
                                        <b>Sort:</b>
                                    </td>
                                    <td>
                                        <a href="/Member/SortingDefault/Proximity">Proximity</a>
                                    </td>
                                    <td>
                                        <a href="/Member/SortingDefault/Date">Date</a>
                                    </td>
                                    <td>
                                        <a href="/Member/SortingDefault/Category">Category</a>
                                    </td>
                                    <td>
                                        <a href="/Member/SortingDefault/Likes">Likes</a>
                                    </td>
                                    <td>
                                        <a href="/Member/SortingDefault/Comments">Comments</a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <%}
                            }%>
                        <div class="clear">
                        </div>
                        <div class="fullwidthcol">
                            <% 
                                if (ViewData["SeedList"] != null)
                                {
                                    IList<SeedSpeak.Model.Seed> objSeed = (List<SeedSpeak.Model.Seed>)ViewData["SeedList"];
                                    if (objSeed.Count > 0)
                                    {
                                        Html.Telerik().Grid<SeedSpeak.Model.Seed>("SeedList")
                                       .Name("gridbox")
                                       .Columns(columns =>
                                           {
                                               columns.Template(c =>
                                               {
                            %>
                            <div class="gridcontent" id="grdBlock<%=c.id.ToString()%>">
                                <h3>
                                    <%if (mData != null)
                                      { %>
                                    <a href="/Seed/SeedDetails/<%= c.id.ToString() %>">
                                        <abbr>
                                            <%=c.title%></abbr></a>
                                    <%}
                                      else
                                      { %>
                                    <a style="cursor: pointer;" onclick="javascript:callLoginWindow();">
                                        <abbr>
                                            <%=c.title%>
                                        </abbr>
                                    </a>
                                    <%} %></h3>
                                <%if (mData != null)
                                  {
                                      if (mData.id == c.ownerId)
                                      {
                                %>
                                <div class="rightbtn">
                                    <a style="cursor:pointer;" onclick="javascript:EditSeed('<%=c.id.ToString()%>');" class="btnedit" title="Edit"></a>
                                    <a style="cursor:pointer;" class="btndelete" title="Delete"></a>
                                </div>
                                <%}
                                  }%>
                                <br />
                                <div class="rtuinbox">
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
                                                    <td colspan="2" align="center" style="padding-top: 10px">
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
                                                <a href="/Member/UserDetail/<%= c.Member.id %>">
                                        <img alt="User Image" src="<%= imagePath %>" width="40" height="40" /></a> 
                                        <a href="/Member/UserDetail/<%= c.Member.id %>"><span>
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
                                        <%: dt.ToShortDateString() %>,
                                        <%=catList %>, </b><span style="color: #0F597F; font-size: 12px;
                                            font-weight: bold; height: 30px; padding-top: 10px;">
                                            <%=c.Location.City.name %></span><b>,
                                                <%=c.seedDistance %>
                                                miles</b></div>
                                <div class="clear">
                                </div>
                                <%if (c.parentSeedID != null)
                                  {
                                      SeedSpeak.BLL.SeedAction seedAction = new SeedSpeak.BLL.SeedAction();
                                      string seedName = seedAction.GetSeedNameBySeedId(c.parentSeedID.ToString());
                                       %>
                                       <span id="InReply">
                                In reply to "<%=seedName %>"</span>
                                <%} %>
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
                                        <a style="cursor: pointer;" onclick="javascript:callLoginWindow();">...more</a>
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
                                               imr++;
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
                                    <%if (mData != null)
                                      { %>
                                        <div>
                                            <a class="hide" id="HideSeed<%=c.id.ToString()%>" style="cursor:pointer;" onclick="javascript:HideSeed(this.id);">Hide</a>
                                        </div>
                                        <div>
                                            <a class="flag" href="javascript:callFlagSeedWindow('<%=c.id.ToString() %>');">Flag</a>
                                        </div>
                                        <%} %>
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
                                            <a style="cursor: pointer;" onclick="callLoginWindow();">Add to List</a>
                                            <%} %>
                                        </div>
                                        <% string divId0 = "LikeBox" + c.id.ToString(); %>
                                        <div class="L" title="Liked">
                                            <a id="myHeader1" href="javascript:showonlyone('<%=divId0 %>');">
                                                <%=c.Ratings.Where(x => x.likes.Equals(SeedSpeak.Util.SystemStatements.SEEDS_LIKE)).ToList().Count%></a>
                                        </div>                                        
                                        <% string divId = "commentBox" + c.id.ToString(); %>
                                        <div class="Cm" title="Comments" id="CmtCount<%=c.id %>">
                                            <a id="myHeader3" href="javascript:showonlyone('<%=divId %>');">
                                                <%=c.Comments.ToList().Count%></a>
                                        </div>
                                        <% string divId2 = "replyBox" + c.id.ToString(); %>
                                        <div class="Rm" title="Reply Seed">
                                            <%: Html.Hidden("thisParentSeedID"+divId2, c.id.ToString())%>
                                            <%: Html.Hidden("thisRootSeedID"+divId2, c.rootSeedID!=null?c.rootSeedID.ToString():c.id.ToString())%>
                                            <% string replyCount = Convert.ToString(c.Seed1.ToList().Count());
                                               if (mData != null)
                                               { %>
                                            <a id="myHeader4" style="cursor: pointer;" onclick="javascript:callReplySeedWindow('thisParentSeedID<%=divId2%>', 'thisRootSeedID<%=divId2%>');">
                                                <%=replyCount%></a>
                                            <%}
                                               else
                                               { %>
                                            <a id="myHeader4" style="cursor: pointer;" onclick="javascript:callLoginWindow();">
                                                <%=replyCount%></a>
                                            <%} %>
                                        </div>
                                    </div>
                                </div>
                                <div class="clear">
                                </div>
                                <div name="newboxes" id="<%=divId0 %>" style="display: none;" class="newbox">
                                <div id="Likes<%=divId0 %>" style="width:500px; float:left">
                                <%ViewData["LikeData"] = c.id.ToString();%>
                                        <% Html.RenderPartial("LikePartial", ViewData["LikeData"]); %>
                                    </div>
                                    <%if (mData != null)
                                      {
                                          string btnLikeId = "btnLike" + divId0;
                                          %>
                                    
                                    <%using (Ajax.BeginForm("LikeSeedPartial", "Member", new AjaxOptions { UpdateTargetId = "Likes" + divId0, LoadingElementId = "updatingLikes" + divId0, OnSuccess = "function(){fnLikeSuccess('" + btnLikeId + "');}" }))
                                      {%>
                                    <div id="updatingLikes<%=divId0 %>" style="display: none">
                                        Please wait .......</div>
                                    <div id="Div1">
                                    <%: Html.Hidden("SLikedid", c.id.ToString())%>
                                    <% string classLike = "clsBtnLike";
                                          string valueLike = "Like";
                                        if (c.Ratings.FirstOrDefault() != null)
                                      {
                                          if (c.Ratings.FirstOrDefault().memberId == mData.id)
                                          {
                                              classLike = "clsBtnDislike";
                                              valueLike = "Dislike";
                                          }
                                      }
                                       %>
                                    <div style="float:right"><input id="btnLike<%=divId0 %>" name="partialLike" type="submit" value="<%=valueLike %>" class="<%=classLike %>" style="font-size:0px;" /></div>
                                    </div>
                                    <%
                                        }
                                      } %>                                    
                                    <% using (Html.BeginForm("AddComment", "Seed",
                    FormMethod.Post, new { enctype = "multipart/form-data", id = "FrmSample" }))
                                       {%>
                                    <%: Html.Hidden("version","SeedSpeak Phase 2")%>
                                    <%} %>
                                </div>
                                <div name="newboxes" id="<%=divId %>" style="display: none;" class="newbox">
                                    <div id="SeedComments<%=divId %>">
                                        <% ViewData["commentId"] = c.id.ToString(); %>
                                        <% Html.RenderPartial("CommentPartial"); %>
                                    </div>
                                    <%if (mData != null)
                                      { 
                                          string cmtClr = "Text" + c.id.ToString();
                                          string cmtCtr = "CmtCount" + c.id.ToString();
                                          %>
                                    <div class="clear">
                                    </div>                                    
                                      <%using (Ajax.BeginForm("AddCommentAtHomePage", "Member", new AjaxOptions { UpdateTargetId = "SeedComments" + divId, LoadingElementId = "updatingComments" + divId, OnSuccess = "function(){ClearCountTxtComment('" + cmtClr + "','"+cmtCtr+"');}" }))
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
                                <div name="newboxes" id="<%=divId2 %>" style="display: none;" class="newbox">
                                    
                                    
                                    </div> <div style="clear: both;">
                            </div><span class="shades_front"></span>
                            <%
                                               }).Title("Seeds");
                                           })
                       .Pageable(paging => paging.PageSize(10))
      .Footer(false)
      .Render();
                                    }
                                }
                            %>
                        </div>
                    </div>
                    <div class="mapbtmR">
                        <p>
                            <span style="font-size: 21px; line-height: 25px;">Plant an idea to improve</span><br />
                            <span style="font-size: 26px; line-height: 30px; font-weight: bold">your community or join a project!</span><br />
                            A Seed is a message to your community. You can <b>share an idea for community improvement,</b>
                            crowdsource your project, and more! All you need to do is give your Seed a location,
                            category and description so it reaches the people who can help out.</p>
                        <div class="clear">
                        </div>
                        <%
                            if (mData == null)
                            { %>
                        <input type="button" onclick="javascript:callLoginWindow();" class="logsignbtn" />
                        <div class="clear">
                        </div>
                        <%} %>
                        <input type="button" class="mobilebtn" /><br />
                        <br />
                        <div>
                            <b style="color: #688189; font-size: 16px; font-weight: bold; font: AvenirLTStd85Heavy;
                                padding-left: 7px">FOLLOW PEOPLE</b>
                            <% Html.Telerik().TabStrip()
           .Name("FollowPeopleTab").Items(tabstrip =>
               {
                   tabstrip.Add().Text("Top Planters")
                       .Content(() =>
                                   {%>
                            <div>
                                <% Html.Telerik().Grid<SeedSpeak.Model.TopSeedPlanter>("TopPlanters")
           .Name("Grid")
           .Columns(columns =>
               {
                   columns.Template(mem =>
                   {
                       string imagePath = "../../Content/images/user.gif";

                       if (mem.ImagePath != null)
                       {
                           string img = mem.ImagePath.ToString();
                           img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                           if (System.IO.File.Exists(img))
                               imagePath = mem.ImagePath.ToString();
                       }
                                %>
                                <%if (mData != null)
                                  { %>
                                <a href="/Member/UserDetail/<%= mem.id.ToString() %>">
                                    <img alt="<%= mem.id %>" src="<%= imagePath %>" width="40" height="40" /></a>
                                <%}
                                  else
                                  { %>                                
                                    <a href="/Member/UserDetail/<%= mem.id.ToString() %>">
                                    <img alt="<%= mem.id %>" src="<%= imagePath %>" width="40" height="40" /></a>
                                <%} %>
                                <%
                   }).Width(50);
                   columns.Template(mem =>
                   {%>
                                <%if (mData != null)
                                  { %>
                                <a href="/Member/UserDetail/<%= mem.id.ToString() %>">
                                    <%= !string.IsNullOrEmpty(mem.organisationName)? mem.organisationName : mem.MemberName%></a>
                                <%}
                                  else
                                  { %>                                
                                    <a href="/Member/UserDetail/<%= mem.id.ToString() %>">
                                    <%= !string.IsNullOrEmpty(mem.organisationName)? mem.organisationName : mem.MemberName%></a>
                                <%} %>
                                <br />
                                <small>
                                    <%= mem.SeedCount %>
                                    seeds</small>
                                <%
                   }).Width(115);
                   columns.Template(mem =>
                   { 
                                %>
                                <span>
                                    <% if (mData == null)
                                       {%>                                    
                                    <input type="button" value="Follow" class="clsbtnFollow" onclick="javascript:callLoginWindow();" />
                                    <%}
                                       else
                                       {
                                           string TPbtnFollow = "Follow";
                                           string TPbtnFollowClass = "clsbtnFollow";
                                           SeedSpeak.Model.FollowPeople followTP = mData.FollowPeoples.Where(x => x.followingId.Equals(mem.id)).FirstOrDefault();
                                           if (followTP != null)
                                           {
                                               TPbtnFollow = "Unfollow";
                                               TPbtnFollowClass = "clsbtnUnFollow";
                                           }
                                    %>
                                    <% var DfTPbuttonID = "DfTPFollow_" + mem.id.ToString(); %>
                                    <input class="<%=TPbtnFollowClass %>" type="button" value="<%=TPbtnFollow %>" id="<%=DfTPbuttonID %>" />
                                    <%
                                       }%>
                                </span>
                                <% 
                   });
               })
           .Footer(false)
           .Render();
                                %>
                            </div>
                            <%});
                   tabstrip.Add()
                       .Text("Most Followed")
                       .Content(() =>
                       {%>
                            <div>
                                <% Html.Telerik().Grid<SeedSpeak.Model.Member>("MostFollowed")
           .Name("MFGrid")
           .Columns(columns =>
               {
                   columns.Template(mem =>
                   {
                       string imagePath = "../../Content/images/user.gif";
                       if (mem.MemberProfiles.FirstOrDefault() != null)
                       {
                           if (mem.MemberProfiles.FirstOrDefault().imagePath != null)
                           {
                               string img = mem.MemberProfiles.FirstOrDefault().imagePath.ToString();
                               img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                               if (System.IO.File.Exists(img))
                                   imagePath = mem.MemberProfiles.FirstOrDefault().imagePath.ToString();
                           }
                       }
                                %>
                                <%if (mData != null)
                                  { %>
                                <a href="/Member/UserDetail/<%= mem.id.ToString() %>">
                                    <img alt="<%= mem.id %>" src="<%= imagePath %>" width="40" height="40" /></a>
                                <%}
                                  else
                                  { %>                                
                                    <a href="/Member/UserDetail/<%= mem.id.ToString() %>">
                                    <img alt="<%= mem.id %>" src="<%= imagePath %>" width="40" height="40" /></a>
                                <%} %>
                                <%
                   }).Width(50);
                   columns.Template(mem =>
                   {%>
                                <%if (mData != null)
                                  { %>
                                <a href="/Member/UserDetail/<%= mem.id.ToString() %>">
                                    <%=!string.IsNullOrEmpty(mem.organisationName)?mem.organisationName: mem.firstName+" " + mem.lastName %></a>
                                <%}
                                  else
                                  { %>                                
                                    <a href="/Member/UserDetail/<%= mem.id.ToString() %>">
                                    <%=!string.IsNullOrEmpty(mem.organisationName)?mem.organisationName: mem.firstName+" " + mem.lastName %></a>
                                <%} %>
                                <br />
                                <small>
                                    <%= mem.FollowPeoples1.Count() %>
                                    followers</small>
                                <%
                   }).Width(115);
                   columns.Template(mem =>
                   { 
                                %>
                                <span>
                                    <% if (mData == null)
                                       {%>                                    
                                    <input type="button" value="Follow" class="clsbtnFollow" onclick="javascript:callLoginWindow();" />
                                    <%}
                                       else
                                       {
                                           string MFbtnFollow = "Follow";
                                           string MFbtnFollowClass = "clsbtnFollow";
                                           SeedSpeak.Model.FollowPeople follow = mData.FollowPeoples.Where(x => x.followingId.Equals(mem.id)).FirstOrDefault();
                                           if (follow != null)
                                           {
                                               MFbtnFollow = "Unfollow";
                                               MFbtnFollowClass = "clsbtnUnFollow";
                                           }
                                    %>
                                    <% var DfbuttonID = "DfFollow_" + mem.id.ToString(); %>
                                    <input class="<%=MFbtnFollowClass %>" type="button" value="<%=MFbtnFollow %>" id="<%=DfbuttonID%>" />
                                    <%
                                       }%>
                                </span>
                                <% 
                   });
               })
           .Footer(false)
           .Render();
                                %>
                            </div>
                            <%});
               }).SelectedIndex(0).Render();
                            %>
                        </div>
                        <div style="padding-left: 5px;">
                            <input type="button" value="MORE" class="btnmore" onclick="window.location = '/Member/TopPeople';" />
                        </div>
                    </div>
                    <%: Html.Hidden("HiddenMarkers", ViewData["MarkerList"])%>
                    <%: Html.Hidden("defaultLat", ViewData["LocLat"])%>
                    <%: Html.Hidden("defaultLng", ViewData["LocLng"])%>
                    <div class="clear">
                    </div>
                </div>
                <div class="clear">
                </div>
                <div class="contenbtm">
                    <input type="button" class="Mnext1" onclick="javascript: Paging('Next');" style='<%: ViewData["NxtVisibility"] %>' />
                    <input type="button" class="Mpre1" onclick="javascript: Paging('Prev');" style='<%: ViewData["PrevVisibility"] %>' />
                </div>
                <div class="clear">
                </div>
                <div class="clear">
                </div>
            </div>
            <div id="footer">
                <div class="footerinner">
                    <a href="/Member/Default">Home</a><a href="/Home/About">About</a><a href="/Home/FAQ">FAQ</a><a
                        href="/Home/Team">Team</a><a href="/Home/HowItWorks">How it Works</a><a href="/Home/Contact">Contact</a>
                    <p class="copyright">
                        SeedSpeak © 2010 | privacy policy - terms & conditions
                    </p>
                </div>
            </div>
        </div>
    </div>
    <div id="sidebar">
        <p class="socialicon">
            <a class="facebook" target="_blank" href="http://www.facebook.com/pages/SeedSpeak/166517526701102"
                title="Facebook"><span>facebook</span></a> <a class="twitter" target="_blank" href="http://twitter.com/SeedSpeaker"
                    title="Twitter"><span>twitter</span></a> <a class="flicker" href="#" title="Flicker">
                        <span>flicker</span></a> <a class="linked" href="#" title="Linked"><span>linked</span></a>
            <a class="rss" href="#" title="RSS Feeds"><span>RSS Feeds</span></a>
        </p>
    </div>
    <%if (mData != null)
      { %>
    <div>
        <% Html.RenderPartial("StreamHomeMini"); %>
        <% Html.RenderPartial("AddtoStreamPartial"); %>
        <% Html.RenderPartial("FlagSeedPartial"); %>
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
    <%} %>
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
            <div class="loginInner">
                <% using (Html.BeginForm("Login", "Member", FormMethod.Post, new { enctype = "multipart/form-data", id = "P2LoginForm" }))
                   {%>
                <div class="FBbtn">                    
         <fb:login-button autologoutlink="true" perms="email,user_birthday,status_update,publish_stream">Login with Facebook</fb:login-button>
                </div>
                <div id="ErrMsg" class="error">
                </div>
                <div class="clear">
                </div>
                <p>
                    <%: Html.LabelFor(model => model.LogUserName)%><em></em>
                    <br />
                    <%: Html.TextBoxFor(model => model.LogUserName) %>
                </p>
                <p>
                    <%: Html.LabelFor(model => model.LogPassword)%>
                    <em></em>
                    <br />
                    <%: Html.PasswordFor(model => model.LogPassword) %>
                </p>
                <div class="clear">
                </div>
                <p class="multicontrl">
                    <span style="float: left; width: 50%; text-align: left;">
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
                <em style="float: right; margin-top: 10px; position: relative; right: -10px; border: 0px solid #000;">
                    Required</em><div class="clear">
                    </div>
                <% using (Html.BeginForm("SignUpUser", "Member", FormMethod.Post, new { enctype = "multipart/form-data", id = "P2SignUpForm" }))
                   {%>
                <div id="ErrMsg1" class="error">
                </div>
                <div class="clear">
                </div>
                <p>
                    <%: Html.LabelFor(model => model.UserName) %><em></em><br />
                    <%: Html.TextBoxFor(model => model.UserName) %>
                    <%: Html.ValidationMessageFor(model => model.UserName) %>
                </p>
                <p>
                    <%: Html.LabelFor(model => model.organisationName) %>
                    <%: Html.TextBoxFor(model => model.organisationName) %>
                </p>
                <p>
                    <%: Html.LabelFor(model => model.Password) %><em></em><br />
                    <%: Html.PasswordFor(model => model.Password) %>
                    <%: Html.ValidationMessageFor(model => model.Password) %></p>
                <p>
                    <%: Html.LabelFor(model => model.ConfirmPassword) %><em></em><br />
                    <%: Html.PasswordFor(model => model.ConfirmPassword) %>
                    <%: Html.ValidationMessageFor(model => model.ConfirmPassword) %></p>
                <p>
                    <%: Html.LabelFor(model => model.FirstName) %><em></em><br />
                    <%: Html.TextBoxFor(model => model.FirstName, new { maxlength = 15 })%>
                    <%: Html.ValidationMessageFor(model => model.FirstName) %>
                </p>
                <p>
                    <%: Html.LabelFor(model => model.LastName) %><em></em><br />
                    <%: Html.TextBoxFor(model => model.LastName, new { maxlength = 15 })%>
                    <%: Html.ValidationMessageFor(model => model.LastName) %>
                </p>
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
    <% Html.Telerik().ScriptRegistrar().jQuery(false)
.DefaultGroup(group => group
.Add("jquery.simpleMultiSelect.js")
.Compress(true))
.Render(); %>
    <script src="../../Scripts/jquery.curvycorners.min.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(function () {
            $('.c').corner();
            $('a.current').corner({
                tl: { radius: 6 },
                tr: { radius: 6 },
                bl: { radius: 6 },
                br: { radius: 6 }
            });
        });

        $(function () {
            $('.c').corner();
            $('.incategorybox').corner({
                tl: { radius: 2 },
                tr: { radius: 2 },
                bl: { radius: 2 },
                br: { radius: 2 }
            });
        });

        $(function () {
            $('.c').corner();
            $('.gridcontent').corner({
                tl: { radius: 4 },
                tr: { radius: 4 },
                bl: { radius: 4 },
                br: { radius: 4 }
            });
        });

        $(function () {
            $('.c').corner();
            $('.roundbox').corner({
                tl: { radius: 10 },
                tr: { radius: 10 },
                bl: { radius: 10 },
                br: { radius: 10 }
            });
        });
        $(function () {
            $('.c').corner();
            $('.bluerounded').corner({
                tl: { radius: 10 },
                tr: { radius: 10 },
                bl: { radius: 10 },
                br: { radius: 10 }
            });
        });

        $(function () {
            $('.c').corner();
            $('#sort').corner({
                tl: { radius: 6 },
                tr: { radius: 6 },
                bl: { radius: 4 },
                br: { radius: 4 }
            });
        });
    </script>
</body>
</html>
