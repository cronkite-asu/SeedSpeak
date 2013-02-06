<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

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
</style>
<script type="text/javascript" language="javascript">

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

    function EditSeed(id) {
        $.getJSON("/Seed/EditSeedById/?id=" + id,
        function (data) {
            if (data.toString() != "") {
                var valEdit = data.split('#');
                var esw = $('#EditMySeedWindow').data('tWindow');
                esw.center().open();
                $('#txtEdtSeedTitle').val(valEdit[0].toString());
                $('#txtEdtDesc').val(valEdit[1].toString());
                $('#EdtSeedID').val(id);
                
                initializeEdt(valEdit[2].toString(), valEdit[3].toString());
            }
        });
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

    $(document).ready(function () {
        $(".clsFollow,.clsUnFollow").click(function () {
            var cUserID = $(this).attr('id').split('_');
            var buttonID = $(this).attr('id');
            var cUser = cUserID[1];
            var cValue = $(this).attr('value');
            if (buttonID != "") {
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
            }
        });

        $(".clsMute,.clsUnMute").click(function () {
            var cUserID = $(this).attr('id').split('_');
            var buttonID = $(this).attr('id');
            var cUser = cUserID[1];
            var cValue = $(this).attr('value');
            if (buttonID != "") {
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
            }
        });

        $(".btndelete").click(function () {
            var confirm_box = confirm('Are you sure you want to delete this seed ?');
            
            if (confirm_box) {
                var grdBlock = $(this).parent().parent().parent().parent().get(0).id;
                
                var deleteSeedid = grdBlock.replace("grdBlock", "");
                
                $.getJSON("/Seed/TerminateMySeed/?id=" + deleteSeedid, function (data) {
                    if (data.toString() != "") {
                        $("#" + grdBlock).parent().parent().parent().hide("slow");
                    }
                });
            }
        });
    });
</script>
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
            //                $('#' + popID).fadeIn().css({ 'width': Number(popWidth) }).prepend('<a href="#" class="close"><img src="../../Content/images/mclose.png" class="btn_close" title="Close Window" alt="Close" /></a>');
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
<script type="text/javascript" src="../../Scripts/csspopup.js"></script>