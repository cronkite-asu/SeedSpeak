<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<script src="../../Scripts/jquery.autocomplete.min.js" type="text/javascript"></script>
<script type="text/javascript">
    var streamFeedMap;
    var streamFeedgeocoder;
    var centerChangedLast;
    var reverseGeocodedLast;
    var currentReverseGeocodeResponse;
    var streamFeedgeocoder = new google.maps.Geocoder();

    function geocodePositionFeed(pos) {
        streamFeedgeocoder.geocode({
            latLng: pos
        }, function (responses) {
            if (responses && responses.length > 0) {
                updateMarkerAddressStreamFeed(responses[0].formatted_address);
            } else {
                updateMarkerAddressStreamFeed('Cannot determine address at this location.');
            }
        });
    }

    function updateMarkerStatusStreamFeed(str) {
        document.getElementById('markerStatusStreamFeed').innerHTML = str;
    }

    function updateMarkerPositionStreamFeed(latLng) {
        document.getElementById('infoStreamFeed').innerHTML = [latLng.lat(), latLng.lng()].join(', ');
        document.getElementById('initCoordinatesStreamFeed').value = [latLng.lat(), latLng.lng()].join(', ');
    }

    function updateMarkerAddressStreamFeed(str) {
        document.getElementById('addressStreamFeed').innerHTML = str;
        document.getElementById('initLocationStreamFeed').value = str;
    }

    function initializeStreamFeed(lt, lg) {
        if (lt != null && lg != null) {
            var latlngFeed = new google.maps.LatLng(lt, lg);
        }
        else {
            var latlngFeed = new google.maps.LatLng(33.283217832401455, -111.84057782734374);
        }

        var myOptions = {
            zoom: 11,
            center: latlngFeed,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        streamFeedMap = new google.maps.Map(document.getElementById("map_canvas_stream_feed"), myOptions);

        var markerFeed = new google.maps.Marker({
            position: latlngFeed,
            icon: new google.maps.MarkerImage("../../Content/images/seedLocPointer.png"),
            map: streamFeedMap,
            draggable: true
        });
        streamFeedgeocoder = new google.maps.Geocoder();

        // Update current position info.
        updateMarkerPositionStreamFeed(latlngFeed);
        geocodePositionFeed(latlngFeed);

        var contentStringFeed = "<div style='font-size:11px;'>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.</div>";
        var infowindowFeed = new google.maps.InfoWindow({
            content: contentStringFeed
        });
        infowindowFeed.open(streamFeedMap, markerFeed);

        // Add dragging event listeners.
        google.maps.event.addListener(markerFeed, 'dragstart', function () {
            updateMarkerAddressStreamFeed('Dragging...');
            infowindowFeed.close(streamFeedMap, markerFeed);
        });

        google.maps.event.addListener(markerFeed, 'drag', function () {
            updateMarkerStatusStreamFeed('Dragging...');
            updateMarkerPositionStreamFeed(markerFeed.getPosition());
        });

        google.maps.event.addListener(markerFeed, 'dragend', function () {
            updateMarkerStatusStreamFeed('Drag ended');
            geocodePositionFeed(markerFeed.getPosition());
            infowindowFeed.open(streamFeedMap, markerFeed);
        });
    }

    function geocodeFeed() {
        var addressFeed = document.getElementById("txtFeedStreamLocation").value;
        streamgeocoder.geocode(
        {
            'address': addressFeed,
            'partialmatch': true
        },
        geocodeResultFeed);
    }

    function geocodeResultFeed(results, status) {
        if (status == 'OK' && results.length > 0) {
            streamFeedMap.fitBounds(results[0].geometry.viewport);
        }
        else {
            alert("Geocode was not successful for the following reason: " + status);
        }
        //ReAssigning Lat Long on Search
        var refLatLng1 = streamFeedMap.getCenter().toString();
        refLatLng1 = refLatLng1.replace('(', "");
        refLatLng1 = refLatLng1.replace(')', "");
        var centerLatLng1 = refLatLng1.split(',');
        initializeStreamFeed(centerLatLng1[0].toString(), centerLatLng1[1].toString());
        //ReAssigning Lat Long on Search
    }
    google.maps.event.addDomListener(window, 'load', initializeStreamFeed);

    function setLocationFeed() {
        var initStrFeed = document.getElementById('initLocationStreamFeed').value;
        var splitStrFeed = initStrFeed.split(',');
        var finalStrFeed;
        for (i = 0; i < splitStrFeed.length; i++) {
            if (i == 0)
                finalStrFeed = splitStrFeed[i].toString();
            else
                finalStrFeed = finalStrFeed + ",<br/>" + splitStrFeed[i].toString();
        }

        var mapSwitch = document.getElementById('mapSwitcher');
        if (mapSwitch.value == 'Stream') {
            document.getElementById('seedCoordinatesStreamFeed').value = document.getElementById('initCoordinatesStreamFeed').value;
            document.getElementById('spanLocationStreamFeed').innerHTML = finalStrFeed;
            document.getElementById('seedLocationStreamFeed').value = initStrFeed;
            document.getElementById('setLocationAnchorFeed').innerHTML = "change associated location";
        }
        if (mapSwitch.value == 'Radius') {
            document.getElementById('spanRadius').innerHTML = finalStrFeed;
            document.getElementById('LocationRadius').value = initStrFeed;
            document.getElementById('CoordinatesRadius').value = document.getElementById('initCoordinatesStreamFeed').value;
        }
        ExpandItemFeed(0, 'a');
    }

    $(function () {
        $("#txtFeedStreamLocation").keypress(function (event) {
            if (event.keyCode == '13') {
                geocodeFeed(); return false
            }
        });
    });

    function ExpandItemFeed(itemIndex, clickId) {
        var mapSwitchValue = document.getElementById('mapSwitcher');
        if (clickId == 'setLocationAnchorFeed') {
            mapSwitchValue.value = "Stream";
        }
        if (clickId == 'radiusMap') {
            mapSwitchValue.value = "Radius";
        }
        var panelBar = $("#StreamFeedPanel").data("tPanelBar");
        var item = $("> li", panelBar.element)[itemIndex];
        panelBar.expand(item);
        if (itemIndex == '1') {
            var gcenter = streamFeedMap.getCenter();
            google.maps.event.trigger(streamFeedMap, 'resize');
            streamFeedMap.setCenter(gcenter);
        }
    }

    function streamFeedvalidateInput() {
        var title1 = document.getElementById('gFeedTitle').value;
        var desc1 = document.getElementById('gFeedDesc').value;
        var seedLoc1 = document.getElementById('seedLocationStreamFeed').value;
        var msg1 = document.getElementById('resultFeed');
        if (title1 == "" || title1 == "Give your feed a title") {
            msg1.innerHTML = "Title can not be left blank";
            return false;
        }        

        var rdoPfLocation = document.getElementById('rdoProfileLocation');
        if (rdoPfLocation.checked == true) {
            if (document.getElementById('rdoProfileLocValue').value == "") {
                msg1.innerHTML = "Please fill radius for profile location";
                return false;
            }
        }

        var rdoNwLocation = document.getElementById('rdoNewLocation');
        if (rdoNwLocation.checked == true) {
            if (document.getElementById('rdoNewLocValue').value == "") {
                msg1.innerHTML = "Please fill radius for new location";
                return false;
            }
            var newlocRadius = document.getElementById('LocationRadius').value;
            if (newlocRadius == "") {
                msg1.innerHTML = "Please select new location for radius search";
                return false;
            }
        }
    }

    function initRadiusValue(ctrlId) {
        if (ctrlId == "rdoProfileLocation") {
            document.getElementById('rdoProfileLocValue').value = "1";
            document.getElementById('rdoNewLocValue').value = null;
        }

        if (ctrlId == "rdoNewLocation") {
            document.getElementById('rdoNewLocValue').value = "1";
            document.getElementById('rdoProfileLocValue').value = null;
        }

        if (ctrlId == "rdoLocationAll") {
            document.getElementById('rdoNewLocValue').value = null;
            document.getElementById('rdoProfileLocValue').value = null;
        }
    }

    function CloseFeed() {
        var wF = $('#CreateStreamFeedWindow').data('tWindow');
        wF.center().close();
    }
</script>
<script type="text/javascript" language="javascript">
    function BindinDivStreamFeed() {
        var catgDDLf = document.getElementById('CategoryAutoCompleteStreamFeed');
        if (catgDDLf.options[catgDDLf.selectedIndex].text != "" && catgDDLf.options[catgDDLf.selectedIndex].text != "Start typing here") {
            if (document.getElementById('txtCategoryStreamFeed').value == null || document.getElementById('txtCategoryStreamFeed').value == "") {
                //adding value in textbox
                document.getElementById('txtCategoryStreamFeed').value = catgDDLf.options[catgDDLf.selectedIndex].text;
            }
            else {
                //adding value in textbox
                document.getElementById('txtCategoryStreamFeed').value = document.getElementById('txtCategoryStreamFeed').value + "," + catgDDLf.options[catgDDLf.selectedIndex].text;
            }

            if (document.getElementById(catgDDLf.options[catgDDLf.selectedIndex].text + 'StreamFeed') == null) {
                var LDivObj = document.getElementById('parentDivStreamFeed');

                //creating div with cros button
                var divTag = document.createElement("div");
                divTag.id = catgDDLf.options[catgDDLf.selectedIndex].text + 'StreamFeed';

                divTag.onmouseover = function () { mouseOverDivStreamFeed(divTag.id); };
                divTag.onmouseout = function () { mouseOutDivStreamFeed(divTag.id); };
                var ss = "<img id='img" + catgDDLf.options[catgDDLf.selectedIndex].text + 'StreamFeed' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";

                divTag.innerHTML = "<span>" + catgDDLf.options[catgDDLf.selectedIndex].text + ss + ",</span>";
                LDivObj.appendChild(divTag);
                var imgBTN = document.getElementById("img" + catgDDLf.options[catgDDLf.selectedIndex].text + 'StreamFeed');
                imgBTN.onclick = function () { deletedivStreamFeed(divTag.id); };
            }
            else {
                alert("already selected");
            }
            document.getElementById('lnk1StreamFeed').innerHTML = "add more category";
        }
    }

    function BindinDivStreamFeed1(cats) {
        var catgDDLf = cats;
        if (catgDDLf != "" && catgDDLf != "Start typing here") {
            if (document.getElementById('txtCategoryStreamFeed').value == null || document.getElementById('txtCategoryStreamFeed').value == "") {
                //adding value in textbox
                document.getElementById('txtCategoryStreamFeed').value = catgDDLf;
            }
            else {
                //adding value in textbox
                document.getElementById('txtCategoryStreamFeed').value = document.getElementById('txtCategoryStreamFeed').value + "," + catgDDLf;
            }

            if (document.getElementById(catgDDLf + 'StreamFeed') == null) {
                var LDivObj = document.getElementById('parentDivStreamFeed');

                //creating div with cros button
                var divTag = document.createElement("div");
                divTag.id = catgDDLf + 'StreamFeed';

                divTag.onmouseover = function () { mouseOverDivStreamFeed(divTag.id); };
                divTag.onmouseout = function () { mouseOutDivStreamFeed(divTag.id); };
                var ss = "<img id='img" + catgDDLf + 'StreamFeed' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";

                divTag.innerHTML = "<span>" + catgDDLf + ss + ",</span>";
                LDivObj.appendChild(divTag);
                var imgBTN = document.getElementById("img" + catgDDLf + 'StreamFeed');
                imgBTN.onclick = function () { deletedivStreamFeed(divTag.id); };
            }
            else {
                alert("already selected");
            }
            document.getElementById('lnk1StreamFeed').innerHTML = "add more category";
        }
    }

    function deletedivStreamFeed(abc) {
        var child = document.getElementById(abc);
        var parent = document.getElementById('parentDivStreamFeed');
        parent.removeChild(child);
        getSelecteditemsStreamFeed();
    }

    function mouseOverDivStreamFeed(imgId) {
        document.getElementById('img' + imgId).style.visibility = "visible";
    }

    function mouseOutDivStreamFeed(imgId) {
        document.getElementById('img' + imgId).style.visibility = "hidden";
    }

    function getSelecteditemsStreamFeed() {
        var divElem = document.getElementById("parentDivStreamFeed");
        var innerdiv = divElem.getElementsByTagName("span");
        var stringMy = null;
        for (var i = 0; i < innerdiv.length; i++) {
            if (i == 0) {
                stringMy = innerdiv.item(i).innerHTML;
            }
            else {
                stringMy = stringMy + "<" + innerdiv.item(i).innerHTML;
            }
        }

        var FianlString = null;
        if (stringMy != null) {
            var string2 = stringMy.split('<');
            for (var i = 0; i < string2.length; i++) {
                if (i == 0) {
                    FianlString = string2[i];
                }
                else {
                    FianlString = FianlString + "," + string2[i];
                }
                i++;
            }
        }
        if (stringMy == null)
            document.getElementById('lnk1StreamFeed').innerHTML = "add a category";

        document.getElementById('txtCategoryStreamFeed').value = FianlString;
    }

    $(document).ready(function () {
        $("#catfeildStreamFeed").hide();
    });

    $("#lnk1StreamFeed").live('click', function () {
        $("#addcatStreamFeed").hide();
        $("#catfeildStreamFeed").show();
    });

    $("#lnk2StreamFeed").live('click', function () {
        $("#catfeildStreamFeed").hide();
        $("#addcatStreamFeed").show();
    });
</script>
<script type="text/javascript" language="javascript">
    function BindinDivIncludeTerms() {
        if (document.getElementById('AutoCompleteIncludeTerms').value != "" && document.getElementById('AutoCompleteIncludeTerms').value != "Start typing to add a category, keyword, user") {
            if (document.getElementById('txtIncludeTerms').value == null || document.getElementById('txtIncludeTerms').value == "") {
                //adding value in textbox
                document.getElementById('txtIncludeTerms').value = document.getElementById('AutoCompleteIncludeTerms').value;
            }
            else {
                //adding value in textbox
                document.getElementById('txtIncludeTerms').value = document.getElementById('txtIncludeTerms').value + "," + document.getElementById('AutoCompleteIncludeTerms').value;
            }

            if (document.getElementById(document.getElementById('AutoCompleteIncludeTerms').value + 'IT') == null) {
                if (document.getElementById(document.getElementById('AutoCompleteIncludeTerms').value + 'ExT') != null) {
                    alert("already selected in exclude terms");
                }
                else {
                    var LDivObj = document.getElementById('parentDivIncludeTerms');

                    //creating div with cros button
                    var divTag = document.createElement("div");
                    divTag.id = document.getElementById('AutoCompleteIncludeTerms').value + 'IT';

                    divTag.onmouseover = function () { mouseOverDivIncludeTerms(divTag.id); };
                    divTag.onmouseout = function () { mouseOutDivIncludeTerms(divTag.id); };
                    var ss = "<img id='img" + document.getElementById('AutoCompleteIncludeTerms').value + 'IT' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";

                    divTag.innerHTML = "<span>" + document.getElementById('AutoCompleteIncludeTerms').value + ss + ",</span>";
                    LDivObj.appendChild(divTag);
                    var imgBTN = document.getElementById("img" + document.getElementById('AutoCompleteIncludeTerms').value + 'IT');
                    imgBTN.onclick = function () { deletedivIncludeTerms(divTag.id); };
                }
            }
            else {
                alert("already selected");
            }
            document.getElementById('AutoCompleteIncludeTerms').value = null;
            document.getElementById('lnk1IncludeTerms').innerHTML = "add another";
        }
    }

    function deletedivIncludeTerms(abc) {
        var child = document.getElementById(abc);
        var parent = document.getElementById('parentDivIncludeTerms');
        parent.removeChild(child);
        getSelecteditemsIncludeTerms();
    }

    function mouseOverDivIncludeTerms(imgId) {
        document.getElementById('img' + imgId).style.visibility = "visible";
    }

    function mouseOutDivIncludeTerms(imgId) {
        document.getElementById('img' + imgId).style.visibility = "hidden";
    }

    function getSelecteditemsIncludeTerms() {
        var divElem = document.getElementById("parentDivIncludeTerms");
        var innerdiv = divElem.getElementsByTagName("span");
        var stringMy = null;
        for (var i = 0; i < innerdiv.length; i++) {
            if (i == 0) {
                stringMy = innerdiv.item(i).innerHTML;
            }
            else {
                stringMy = stringMy + "<" + innerdiv.item(i).innerHTML;
            }
        }

        var FianlString = null;
        if (stringMy != null) {
            var string2 = stringMy.split('<');
            for (var i = 0; i < string2.length; i++) {
                if (i == 0) {
                    FianlString = string2[i];
                }
                else {
                    FianlString = FianlString + "," + string2[i];
                }
                i++;
            }
        }
        if (stringMy == null)
            document.getElementById('lnk1IncludeTerms').innerHTML = "add";

        document.getElementById('txtIncludeTerms').value = FianlString;
    }

    $(document).ready(function () {
        //Adding autocomplete to Tag input
        $("#AutoCompleteIncludeTerms").autocomplete('<%: Url.Action("InExTerms", "SeedStream") %>', {
            minChars: 3,
            //Don't fill the input while still selecting a value
            autoFill: false,
            //Only suggested values are valid
            mustMatch: true,
            //The comparison doesn't looks inside
            matchContains: false,
            //The number of query results to store in cache
            cacheLength: 12,

            //Callback which will format items for autocomplete list
            formatItem: function (data, index, max) {
                //Display only descriptions in list
                return data[1];
            },
            //Callback which will format items for matching
            formatMatch: function (data, index, max) {
                //Match only descriptions
                return data[1];
            },
            //Callback which will format result
            formatResult: function (data, index, max) {
                //Display only description as result
                return data[1];
            }
            //Callback which will be called when user chooses value
        }).result(function (event, data, formatted) {
            //Set territory id as hidden input value
            if (data)
                $("#cityIdIncludeTerms").val(data[0]);
            else
                $("#cityIdIncludeTerms").val('-1')
        });
    });

    $(document).ready(function () {
        $("#catfeildIncludeTerms").hide();
    });

    $("#lnk1IncludeTerms").live('click', function () {
        $("#addIncludeTerms").hide();
        $("#catfeildIncludeTerms").show();
    });

    $("#lnk2IncludeTerms").live('click', function () {
        $("#catfeildIncludeTerms").hide();
        $("#addIncludeTerms").show();
    });
</script>
<script type="text/javascript" language="javascript">
    function BindinDivExcludeTerms() {
        if (document.getElementById('AutoCompleteExcludeTerms').value != "" && document.getElementById('AutoCompleteExcludeTerms').value != "Start typing to add a category, keyword, user") {
            if (document.getElementById('txtExcludeTerms').value == null || document.getElementById('txtExcludeTerms').value == "") {
                //adding value in textbox
                document.getElementById('txtExcludeTerms').value = document.getElementById('AutoCompleteExcludeTerms').value;
            }
            else {
                //adding value in textbox
                document.getElementById('txtExcludeTerms').value = document.getElementById('txtExcludeTerms').value + "," + document.getElementById('AutoCompleteExcludeTerms').value;
            }

            if (document.getElementById(document.getElementById('AutoCompleteExcludeTerms').value + 'ExT') == null) {
                if (document.getElementById(document.getElementById('AutoCompleteExcludeTerms').value + 'IT') != null) {
                    alert("already selected in include terms");
                }
                else {
                    var LDivObj = document.getElementById('parentDivExcludeTerms');

                    //creating div with cros button
                    var divTag = document.createElement("div");
                    divTag.id = document.getElementById('AutoCompleteExcludeTerms').value + 'ExT';

                    divTag.onmouseover = function () { mouseOverDivExcludeTerms(divTag.id); };
                    divTag.onmouseout = function () { mouseOutDivExcludeTerms(divTag.id); };
                    var ss = "<img id='img" + document.getElementById('AutoCompleteExcludeTerms').value + 'ExT' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";
                    divTag.innerHTML = "<span>" + document.getElementById('AutoCompleteExcludeTerms').value + ss + ",</span>";
                    LDivObj.appendChild(divTag);
                    var imgBTN = document.getElementById("img" + document.getElementById('AutoCompleteExcludeTerms').value + 'ExT');
                    imgBTN.onclick = function () { deletedivExcludeTerms(divTag.id); };
                }
            }
            else {
                alert("already selected");
            }
            document.getElementById('AutoCompleteExcludeTerms').value = null;
            document.getElementById('lnk1ExcludeTerms').innerHTML = "add another";
        }
    }

    function deletedivExcludeTerms(abc) {
        var child = document.getElementById(abc);
        var parent = document.getElementById('parentDivExcludeTerms');
        parent.removeChild(child);
        getSelecteditemsExcludeTerms();
    }

    function mouseOverDivExcludeTerms(imgId) {
        document.getElementById('img' + imgId).style.visibility = "visible";
    }

    function mouseOutDivExcludeTerms(imgId) {
        document.getElementById('img' + imgId).style.visibility = "hidden";
    }

    function getSelecteditemsExcludeTerms() {
        var divElem = document.getElementById("parentDivExcludeTerms");
        var innerdiv = divElem.getElementsByTagName("span");
        var stringMy = null;
        for (var i = 0; i < innerdiv.length; i++) {
            if (i == 0) {
                stringMy = innerdiv.item(i).innerHTML;
            }
            else {
                stringMy = stringMy + "<" + innerdiv.item(i).innerHTML;
            }
        }

        var FianlString = null;
        if (stringMy != null) {
            var string2 = stringMy.split('<');
            for (var i = 0; i < string2.length; i++) {
                if (i == 0) {
                    FianlString = string2[i];
                }
                else {
                    FianlString = FianlString + "," + string2[i];
                }
                i++;
            }
        }
        if (stringMy == null)
            document.getElementById('lnk1ExcludeTerms').innerHTML = "add";

        document.getElementById('txtExcludeTerms').value = FianlString;
    }

    $(document).ready(function () {
        //Adding autocomplete to Tag input
        $("#AutoCompleteExcludeTerms").autocomplete('<%: Url.Action("InExTerms", "SeedStream") %>', {
            minChars: 3,
            //Don't fill the input while still selecting a value
            autoFill: false,
            //Only suggested values are valid
            mustMatch: true,
            //The comparison doesn't looks inside
            matchContains: false,
            //The number of query results to store in cache
            cacheLength: 12,

            //Callback which will format items for autocomplete list
            formatItem: function (data, index, max) {
                //Display only descriptions in list
                return data[1];
            },
            //Callback which will format items for matching
            formatMatch: function (data, index, max) {
                //Match only descriptions
                return data[1];
            },
            //Callback which will format result
            formatResult: function (data, index, max) {
                //Display only description as result
                return data[1];
            }
            //Callback which will be called when user chooses value
        }).result(function (event, data, formatted) {
            //Set territory id as hidden input value
            if (data)
                $("#cityIdExcludeTerms").val(data[0]);
            else
                $("#cityIdExcludeTerms").val('-1')
        });
    });

    $(document).ready(function () {
        $("#catfeildExcludeTerms").hide();
    });

    $("#lnk1ExcludeTerms").live('click', function () {
        $("#addExcludeTerms").hide();
        $("#catfeildExcludeTerms").show();
    });

    $("#lnk2ExcludeTerms").live('click', function () {
        $("#catfeildExcludeTerms").hide();
        $("#addExcludeTerms").show();
    });
</script>
<style>
   
</style>
<div>
    <%  Html.Telerik().Window()
            .Name("CreateStreamFeedWindow")
            .Title("Create Stream")
            .Content(() =>
            {%>
    <div class="big_window_wp">
        <div class="big_window_top">
        </div>
        <div class="big_window_mid">
            <div class="stream_window">
                <% Html.Telerik().PanelBar()
           .Name("StreamFeedPanel")
            .ExpandMode(PanelBarExpandMode.Single)
            .Items(parent =>
            {
                parent.Add()
                    .Text(" ")
                    .Content(() =>
                    { %>                
                <%using (Html.BeginForm("AddStreamFeed", "SeedStream", FormMethod.Post, new { enctype = "multipart/form-data", id = "FeedForm" }))
                  {
                %>
                <table width="96%" border="0" cellpadding="0" cellspacing="0" style="margin: auto">
                    <tr>
                        <td valign="top" class="mid-saprater" style="width: 37%; padding-left: 10px; padding-top: 5px;">
                            <table align="left" class="plantboxfrm" border="0" width="90%">
                                <tr>
                                    <td class="heading" style="padding-left:0px!important">Create a Feed</td>
                                </tr>
                <tr>
                    <td style="color: #6E6E6E; font-size: 14px">
                        Create a custom feed and see the latest ideas as they are planted.
                    </td>
                </tr>
                <tr>
                    <th>Settings</th>
                </tr>
                <tr>
                    <td colspan="3">
                        <div id="updatingFeed" style="display: none">
                            <img src="../../Content/images/ajaxloader.gif" alt="Please wait..." />
                            <br />
                            <span style="color: Red;"><small>Please wait while we process your request</small></span>
                        </div>
                        <span id="resultFeed" style="color: Red">
                            <%if (ViewData["PlantErrMsg"] != null)
                              {
                            %>
                            <%=ViewData["PlantErrMsg"].ToString()%>
                            <% 
                                              } %>
                                              <input type="hidden" id="isEdit" name="isEdit" />
                                              <input type="hidden" id="StreamId" name="StreamId" />
                        </span>
                    </td>
                </tr>
                <tr>
                    <td class="give-your-title">
                        <input type="text" id="gFeedTitle" name="gFeedTitle" class="waterMark" style="width: 300px!important"
                            title="Give your feed a title" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <textarea id="gFeedDesc" name="gFeedDesc" class="waterMark" title="Give your feed a description (Optional)"
                            rows="3" cols="30"></textarea>
                    </td>
                </tr>
                <tr>
                    <th>Location</th>
                </tr>
                <tr>
                    <td>
                        <div>
                            <span id="spanLocationStreamFeed"></span>
                            <%: Html.Hidden("seedLocationStreamFeed") %>
                            <%: Html.Hidden("seedCoordinatesStreamFeed") %>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="addloc">
                            <a id="setLocationAnchorFeed" onclick="ExpandItemFeed(1, this.id)">associate this feed
                                with a location</a></div>
                    </td>
                </tr>
               
                <tr>
                    <th style="border-top: 1px dashed #000; padding-top: 10px;">Category</th>
                </tr>
                <tr>
                    <td valign="top">
                        <div class="scrollcat">
                            <div id="parentDivStreamFeed">
                            </div>
                        </div>
                    </td>
                </tr>
                 <tr>
                    <td valign="top">
                        <div class="categoryadd" id="catfeildStreamFeed">                            
                                <%
                                           SeedSpeak.BLL.CategoryAction objCategory = new SeedSpeak.BLL.CategoryAction();
                                           IList<SeedSpeak.Model.Category> lstCategory = objCategory.GetAllCategories();
                                           SelectList lstCats = new SelectList(lstCategory, "id", "name");
       %>
       <div style="width:200px;float:left;">
                                    <%: Html.DropDownList("CategoryAutoCompleteStreamFeed", lstCats)%></div>
                            <input type="button" value="Add" onclick="BindinDivStreamFeed();" class="btnaddcat"
                                id="lnk2StreamFeed" />
                            <input type="text" id="txtCategoryStreamFeed" name="txtCategoryStreamFeed" style="display: none;" />
                            <input type="text" id="cityIdStreamFeed" style="display: none;" />
                        </div>
                        <div id="addcatStreamFeed" class="addloc">
                            <a id="lnk1StreamFeed">add a category</a></div>
                    </td>
                </tr>
               
                <tr>
                    <td style="border-top: 1px dashed #000; padding-top: 10px; padding-left: 20px;">
                        <input type="radio" value="true" id="rdoPublic" name="gIsPublic" checked="checked"
                            title="Public" />
                        Public<br />
                        <input type="radio" value="false" id="rdoPrivate" name="gIsPublic" title="Private" />
                        Private
                    </td>
                </tr>
                <tr>
                    <td align="right">
                    </td>
                </tr>
                </table> </td>
                <td style="width: 5px;">
                </td>
                <td valign="top" style="padding-left: 10px;">
                    <table class="plantdetailbox" width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <th colspan="2" style="color: #471D0B; padding-top: 45px;" >
                                This feed will show Seeds
                            </th>
                        </tr>
                        <tr>
                            <td class="all-location" valign="top">
                                <input type="radio" value="AllLocations" id="rdoLocationAll" name="feedLocation"
                                    checked="checked" title="From All Locations" onclick="javascript:initRadiusValue(this.id);" />
                                From all locations<br />
                                <input type="radio" value="ProfileLocation" id="rdoProfileLocation" name="feedLocation"
                                    title="Profile Location" onclick="javascript:initRadiusValue(this.id);" />
                                within
                                <input type="text" name="profileLocValue" id="rdoProfileLocValue" style="width: 40px"
                                    maxlength="2" />
                                miles of my profile location<br />
                                <input type="radio" value="NewLocation" id="rdoNewLocation" name="feedLocation" title="New Location"
                                    onclick="javascript:initRadiusValue(this.id);" />
                                within
                                <input type="text" name="NewLocValue" id="rdoNewLocValue" style="width: 40px" maxlength="2" />
                                miles of a <a id="radiusMap" style="cursor: pointer;" onclick="ExpandItemFeed(1, this.id)">
                                    new location</a><br /><br />
                                <span id="spanRadius"></span>
                                <%: Html.Hidden("LocationRadius") %>
                                <%: Html.Hidden("CoordinatesRadius") %>
                            </td>
                            <td class="all-location-right scrollcat-sap" valign="top">
                                <input type="radio" value="All" id="rdoAll" name="gIsMedia" checked="checked" title="All" />
                                with all media<br />
                                <input type="radio" value="NoMedia" id="rdoNoMedia" name="gIsMedia" title="No Media" />
                                without media<br />
                                <input type="radio" value="PhotosOnly" id="rdoPhotosOnly" name="gIsMedia" title="Photos Only" />
                                with photos only<br />
                                <input type="radio" value="VideosOnly" id="rdoVideosOnly" name="gIsMedia" title="Videos Only" />
                                with videos only
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-bottom: 7px; padding-left: 0px; padding-top: 0px;">
                                ----------------------------------------------------------------
                            </td>
                        </tr>
                        <tr>
                            <th colspan="2" style="padding-bottom: 0px;">
                                And will include the following terms
                            </th>
                        </tr>
                        <tr>
                            <td valign="top">                                
                                <div class="categoryadd" id="catfeildIncludeTerms">
                                    <input type="text" id="AutoCompleteIncludeTerms" name="AutoCompleteIncludeTerms"
                                        style="float: left" class="waterMark" title="Start typing to add a category, keyword, user" />
                                    <input type="button" value="Add" onclick="BindinDivIncludeTerms();" class="btnaddcat"
                                        id="lnk2IncludeTerms" style="margin-left: 0px; margin-top: 0px;" />
                                    <input type="text" id="txtIncludeTerms" name="txtIncludeTerms" style="display: none;" />
                                    <input type="text" id="cityIdIncludeTerms" style="display: none;" />
                                </div>
                                <div id="addIncludeTerms" class="addloc" style="padding-top: 1px;">
                                    <a id="lnk1IncludeTerms" style="padding-left: 2px;">add</a></div>
                            </td>
                            <td class="scrollcat-sap" valign="top">
                                <div class="scrollcat">
                                    <div id="parentDivIncludeTerms">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-bottom: 0px; padding-left: 0px; padding-top: 0px;">
                                ----------------------------------------------------------------
                            </td>
                        </tr>
                        <tr>
                            <th colspan="2">
                                And exclude the following terms
                            </th>
                        </tr>
                        <tr>
                            <td valign="top">                                
                                <div class="categoryadd" id="catfeildExcludeTerms">
                                    <input type="text" id="AutoCompleteExcludeTerms" name="AutoCompleteExcludeTerms"
                                        style="float: left" class="waterMark" title="Start typing to add a category, keyword, user" />
                                    <input type="button" value="Add" onclick="BindinDivExcludeTerms();" class="btnaddcat"
                                        id="lnk2ExcludeTerms" style="margin-left: 0px; margin-top: 0px;" />
                                    <input type="text" id="txtExcludeTerms" name="txtExcludeTerms" style="display: none;" />
                                    <input type="text" id="cityIdExcludeTerms" style="display: none;" />
                                </div>
                                <div id="addExcludeTerms" class="addloc" style="padding-top: 1px;">
                                    <a id="lnk1ExcludeTerms" style="padding-left: 2px;">add</a></div>
                            </td>
                            <td class="scrollcat-sap" valign="top">
                                <div class="scrollcat">
                                    <div id="parentDivExcludeTerms">
                                    </div>
                                </div>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" valign="top" align="right">
                                <div style="width: 92%">
                                    <input type="submit" class="btncreate" value="Create" onclick="javascript:return streamFeedvalidateInput();" />
                                    <input type="button" value="Cancel" class="btncancel" onclick="javascript:CloseFeed();" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
                </tr> </table>
                <% } %>
                <% })
                    .Expanded(true);
                parent.Add()

                       .Content(() =>
                       {%>
                <div id="mapStreamFeed" style="margin: 6px  auto; width: 90%; border: 0px solid #000;">
                    <%: Html.Hidden("mapSwitcher") %>
                    <% string strIpAddress = System.Web.HttpContext.Current.Request.UserHostAddress;
   if (strIpAddress == "127.0.0.1")
   {
       strIpAddress = "61.246.241.162";
   }
  SeedSpeak.Util.CommonMethods objCmnMethods = new SeedSpeak.Util.CommonMethods();
  string ipLocation = objCmnMethods.IP2AddressAPI(strIpAddress);
  string latSearch = string.Empty;
  string lngSearch = string.Empty;
  string[] currentAddress;
  if (!string.IsNullOrEmpty(ipLocation))
  {
      //IPaddressAPI
      currentAddress = ipLocation.Split(',');
      latSearch = currentAddress[8].Replace("\"", "").ToString();
      lngSearch = currentAddress[9].Replace("\"", "").ToString();
  }
  else
  {
      //MaxMind
      ipLocation = objCmnMethods.IP2AddressMaxMind();
      currentAddress = ipLocation.Split('\'');
      latSearch = currentAddress[11].ToString();
      lngSearch = currentAddress[13].ToString();
  }%>
                    <div class="frmadd">
                        <input type="text" id="txtFeedStreamLocation" class="waterMark" title="Enter address to locate stream..." /><input
                            type="button" value="GO" onclick="javascript:geocodeFeed();" class="btnfind" />
                            <input type="button" class="btnucl" value="Use Current Location" onclick="javascript:initializeStreamFeed('<%=latSearch %>','<%=lngSearch %>');" />
                    </div>
                    <div class="clear">
                    </div>
                    <div id="map_canvas_stream_feed" style="width: 100%; height: 400px; border: 1px solid #000">
                    </div>
                </div>
                <div id="infoPanelStreamFeed" style="display: none">
                    <input type="hidden" id="initLocationStreamFeed" />
                    <input type="hidden" id="initCoordinatesStreamFeed" />
                    <b>Marker status:</b>
                    <div id="markerStatusStreamFeed">
                        <i>Click and drag the marker.</i></div>
                    <b>Current position:</b>
                    <div id="infoStreamFeed">
                    </div>
                    <b>Closest matching address:</b>
                    <div id="addressStreamFeed">
                    </div>
                </div>
                <div class="mapbtncontent" style="background-color: White; width: 94%;">
                   
                    <input type="button" value="Set Location" onclick="javascript:setLocationFeed();"
                        class="btnsetloc" />
                         <input type="button" id="btnNoLocation" value="Cancel" onclick="ExpandItemFeed(0, this.id)"
                        class="btncan" />
                        
                </div>
                <%});
            })
            .Render();
                %>
            </div>
        </div>
        <div class="big_window_bottom">
        </div>
    </div>
    <%})
            .Width(700)
            .Height(700)
            .Modal(true)
            .Visible(false)
            .Render();
    %>
</div>
