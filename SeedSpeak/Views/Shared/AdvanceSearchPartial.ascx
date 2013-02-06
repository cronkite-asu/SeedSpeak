<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<script src="../../Scripts/jquery.autocomplete.min.js" type="text/javascript"></script>
<script type="text/javascript">
    var AdvSearchMap;
    var AdvSearchgeocoder;
    var centerChangedLast;
    var reverseGeocodedLast;
    var currentReverseGeocodeResponse;
    var AdvSearchgeocoder = new google.maps.Geocoder();

    function geocodePositionAdvSearch(pos) {
        AdvSearchgeocoder.geocode({
            latLng: pos
        }, function (responses) {
            if (responses && responses.length > 0) {
                updateMarkerAddressAdvSearch(responses[0].formatted_address);
            } else {
                updateMarkerAddressAdvSearch('Cannot determine address at this location.');
            }
        });
    }

    function updateMarkerStatusAdvSearch(str) {
        document.getElementById('markerStatusAdvSearch').innerHTML = str;
    }

    function updateMarkerPositionAdvSearch(latLng) {
        document.getElementById('infoAdvSearch').innerHTML = [latLng.lat(), latLng.lng()].join(', ');
        document.getElementById('initCoordinatesAdvSearch').value = [latLng.lat(), latLng.lng()].join(', ');
    }

    function updateMarkerAddressAdvSearch(str) {
        document.getElementById('addressAdvSearch').innerHTML = str;
        document.getElementById('initLocationAdvSearch').value = str;
    }

    function initializeAdvSearch(lt, lg) {
        if (lt != null && lg != null) {
            var latlngAdvSearch = new google.maps.LatLng(lt, lg);
        }
        else {
            var latlngAdvSearch = new google.maps.LatLng(33.283217832401455, -111.84057782734374);
        }

        var myOptions = {
            zoom: 11,
            center: latlngAdvSearch,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        AdvSearchMap = new google.maps.Map(document.getElementById("map_canvas_adv_search"), myOptions);

        var markerAdvSearch = new google.maps.Marker({
            position: latlngAdvSearch,
            icon: new google.maps.MarkerImage("../../Content/images/seedLocPointer.png"),
            map: AdvSearchMap,
            draggable: true
        });
        AdvSearchgeocoder = new google.maps.Geocoder();

        // Update current position info.
        updateMarkerPositionAdvSearch(latlngAdvSearch);
        geocodePositionAdvSearch(latlngAdvSearch);

        var contentStringAdvSearch = "<div style='font-size:11px;'>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.</div>";
        var infowindowAdvSearch = new google.maps.InfoWindow({
            content: contentStringAdvSearch
        });
        infowindowAdvSearch.open(AdvSearchMap, markerAdvSearch);

        // Add dragging event listeners.
        google.maps.event.addListener(markerAdvSearch, 'dragstart', function () {
            updateMarkerAddressAdvSearch('Dragging...');
            infowindowAdvSearch.close(AdvSearchMap, markerAdvSearch);
        });

        google.maps.event.addListener(markerAdvSearch, 'drag', function () {
            updateMarkerStatusAdvSearch('Dragging...');
            updateMarkerPositionAdvSearch(markerAdvSearch.getPosition());
        });

        google.maps.event.addListener(markerAdvSearch, 'dragend', function () {
            updateMarkerStatusAdvSearch('Drag ended');
            geocodePositionAdvSearch(markerAdvSearch.getPosition());
            infowindowAdvSearch.open(AdvSearchMap, markerAdvSearch);
        });
    }

    function geocodeAdvSearch() {
        var addressAdvSearch = document.getElementById("txtAdvSearchLocation").value;
        AdvSearchgeocoder.geocode(
        {
            'address': addressAdvSearch,
            'partialmatch': true
        },
        geocodeResultAdvSearch);
    }

    function geocodeResultAdvSearch(results, status) {
        if (status == 'OK' && results.length > 0) {
            AdvSearchMap.fitBounds(results[0].geometry.viewport);
        }
        else {
            alert("Geocode was not successful for the following reason: " + status);
        }
        //ReAssigning Lat Long on Search
        var refLatLng1 = AdvSearchMap.getCenter().toString();
        refLatLng1 = refLatLng1.replace('(', "");
        refLatLng1 = refLatLng1.replace(')', "");
        var centerLatLng1 = refLatLng1.split(',');
        initializeAdvSearch(centerLatLng1[0].toString(), centerLatLng1[1].toString());
        //ReAssigning Lat Long on Search
    }
    google.maps.event.addDomListener(window, 'load', initializeAdvSearch);

    function setLocationAdvSearch() {
        var initStrAdvSearch = document.getElementById('initLocationAdvSearch').value;
        document.getElementById('spanAdvSearchRadius').innerHTML = initStrAdvSearch;
        document.getElementById('LocationAdvSearchRadius').value = initStrAdvSearch;
        document.getElementById('CoordinatesAdvSearchRadius').value = document.getElementById('initCoordinatesAdvSearch').value;
        ExpandItemAdvSearch(0);
    }

    $(function () {
        $("#txtAdvSearchLocation").keypress(function (event) {
            if (event.keyCode == '13') {
                geocodeAdvSearch(); return false
            }
        });
    });

    function ExpandItemAdvSearch(itemIndex) {
        var panelBar = $("#AdvanceSearchPanel").data("tPanelBar");
        var item = $("> li", panelBar.element)[itemIndex];
        panelBar.expand(item);
        if (itemIndex == '1') {            
            var gcenter = AdvSearchMap.getCenter();
            google.maps.event.trigger(AdvSearchMap, 'resize');
            AdvSearchMap.setCenter(gcenter);
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
</script>
<script type="text/javascript" language="javascript">
    function BindinDivAdvSearchIncludeTerms() {
        if (document.getElementById('AutoCompleteAdvSearchIncludeTerms').value != "" && document.getElementById('AutoCompleteAdvSearchIncludeTerms').value != "Start typing to add a category, keyword, user") {
            if (document.getElementById('txtAdvSearchIncludeTerms').value == null || document.getElementById('txtAdvSearchIncludeTerms').value == "") {
                //adding value in textbox
                document.getElementById('txtAdvSearchIncludeTerms').value = document.getElementById('AutoCompleteAdvSearchIncludeTerms').value;
            }
            else {
                //adding value in textbox
                document.getElementById('txtAdvSearchIncludeTerms').value = document.getElementById('txtAdvSearchIncludeTerms').value + "," + document.getElementById('AutoCompleteAdvSearchIncludeTerms').value;
            }

            if (document.getElementById(document.getElementById('AutoCompleteAdvSearchIncludeTerms').value + 'IT') == null) {
                if (document.getElementById(document.getElementById('AutoCompleteAdvSearchIncludeTerms').value + 'ExT') != null) {
                    alert("already selected in exclude terms");
                }
                else {
                    var LDivObj = document.getElementById('parentDivAdvSearchIncludeTerms');

                    //creating div with cros button
                    var divTag = document.createElement("div");
                    divTag.id = document.getElementById('AutoCompleteAdvSearchIncludeTerms').value + 'IT';

                    divTag.onmouseover = function () { mouseOverDivAdvSearchIncludeTerms(divTag.id); };
                    divTag.onmouseout = function () { mouseOutDivAdvSearchIncludeTerms(divTag.id); };
                    var ss = "<img id='img" + document.getElementById('AutoCompleteAdvSearchIncludeTerms').value + 'IT' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";

                    divTag.innerHTML = "<span>" + document.getElementById('AutoCompleteAdvSearchIncludeTerms').value + ss + ",</span>";
                    LDivObj.appendChild(divTag);
                    var imgBTN = document.getElementById("img" + document.getElementById('AutoCompleteAdvSearchIncludeTerms').value + 'IT');
                    imgBTN.onclick = function () { deletedivAdvSearchIncludeTerms(divTag.id); };
                }
            }
            else {
                alert("already selected");
            }
            document.getElementById('AutoCompleteAdvSearchIncludeTerms').value = null;
            document.getElementById('lnk1AdvSearchIncludeTerms').innerHTML = "add another";
        }
    }

    function deletedivAdvSearchIncludeTerms(abc) {
        var child = document.getElementById(abc);
        var parent = document.getElementById('parentDivAdvSearchIncludeTerms');
        parent.removeChild(child);
        getSelecteditemsAdvSearchIncludeTerms();
    }

    function mouseOverDivAdvSearchIncludeTerms(imgId) {
        document.getElementById('img' + imgId).style.visibility = "visible";
    }

    function mouseOutDivAdvSearchIncludeTerms(imgId) {
        document.getElementById('img' + imgId).style.visibility = "hidden";
    }

    function getSelecteditemsAdvSearchIncludeTerms() {
        var divElem = document.getElementById("parentDivAdvSearchIncludeTerms");
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
            document.getElementById('lnk1AdvSearchIncludeTerms').innerHTML = "add";

        document.getElementById('txtAdvSearchIncludeTerms').value = FianlString;
    }

    $(document).ready(function () {
        //Adding autocomplete to Tag input
        $("#AutoCompleteAdvSearchIncludeTerms").autocomplete('<%: Url.Action("InExTerms", "SeedStream") %>', {
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
                $("#cityIdAdvSearchIncludeTerms").val(data[0]);
            else
                $("#cityIdAdvSearchIncludeTerms").val('-1')
        });
    });

    $(document).ready(function () {
        $("#catfeildAdvSearchIncludeTerms").hide();
    });

    $("#lnk1AdvSearchIncludeTerms").live('click', function () {
        $("#addAdvSearchIncludeTerms").hide();
        $("#catfeildAdvSearchIncludeTerms").show();
    });

    $("#lnk2AdvSearchIncludeTerms").live('click', function () {
        $("#catfeildAdvSearchIncludeTerms").hide();
        $("#addAdvSearchIncludeTerms").show();
    });
</script>
<script type="text/javascript" language="javascript">
    function BindinDivAdvSearchExcludeTerms() {
        if (document.getElementById('AutoCompleteAdvSearchExcludeTerms').value != "" && document.getElementById('AutoCompleteAdvSearchExcludeTerms').value != "Start typing to add a category, keyword, user") {
            if (document.getElementById('txtAdvSearchExcludeTerms').value == null || document.getElementById('txtAdvSearchExcludeTerms').value == "") {
                //adding value in textbox
                document.getElementById('txtAdvSearchExcludeTerms').value = document.getElementById('AutoCompleteAdvSearchExcludeTerms').value;
            }
            else {
                //adding value in textbox
                document.getElementById('txtAdvSearchExcludeTerms').value = document.getElementById('txtAdvSearchExcludeTerms').value + "," + document.getElementById('AutoCompleteAdvSearchExcludeTerms').value;
            }

            if (document.getElementById(document.getElementById('AutoCompleteAdvSearchExcludeTerms').value + 'ExT') == null) {
                if (document.getElementById(document.getElementById('AutoCompleteAdvSearchExcludeTerms').value + 'IT') != null) {
                    alert("already selected in include terms");
                }
                else {
                    var LDivObj = document.getElementById('parentDivAdvSearchExcludeTerms');

                    //creating div with cros button
                    var divTag = document.createElement("div");
                    divTag.id = document.getElementById('AutoCompleteAdvSearchExcludeTerms').value + 'ExT';

                    divTag.onmouseover = function () { mouseOverDivAdvSearchExcludeTerms(divTag.id); };
                    divTag.onmouseout = function () { mouseOutDivAdvSearchExcludeTerms(divTag.id); };
                    var ss = "<img id='img" + document.getElementById('AutoCompleteAdvSearchExcludeTerms').value + 'ExT' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";
                    divTag.innerHTML = "<span>" + document.getElementById('AutoCompleteAdvSearchExcludeTerms').value + ss + ",</span>";
                    LDivObj.appendChild(divTag);
                    var imgBTN = document.getElementById("img" + document.getElementById('AutoCompleteAdvSearchExcludeTerms').value + 'ExT');
                    imgBTN.onclick = function () { deletedivAdvSearchExcludeTerms(divTag.id); };
                }
            }
            else {
                alert("already selected");
            }
            document.getElementById('AutoCompleteAdvSearchExcludeTerms').value = null;
            document.getElementById('lnk1AdvSearchExcludeTerms').innerHTML = "add another";
        }
    }

    function deletedivAdvSearchExcludeTerms(abc) {
        var child = document.getElementById(abc);
        var parent = document.getElementById('parentDivAdvSearchExcludeTerms');
        parent.removeChild(child);
        getSelecteditemsAdvSearchExcludeTerms();
    }

    function mouseOverDivAdvSearchExcludeTerms(imgId) {
        document.getElementById('img' + imgId).style.visibility = "visible";
    }

    function mouseOutDivAdvSearchExcludeTerms(imgId) {
        document.getElementById('img' + imgId).style.visibility = "hidden";
    }

    function SearchValidateInput() {
        var errMsg = document.getElementById('spanAdvSearchRadius');
        
        var rdoCurrLocation = document.getElementById('rdoAdvCurrentLocation');
        if (rdoCurrLocation.checked == true) {
            if (document.getElementById('rdoAdvCurrentLocValue').value == "") {
                errMsg.innerHTML = "<span style='color:Red'>Please fill radius for current location</span>";
                return false;
            }
        }
        
        var rdoAdvNwLocation = document.getElementById('rdoAdvNewLocation');
        if (rdoAdvNwLocation.checked == true) {
            if (document.getElementById('rdoAnotherLocValue').value == "") {
                errMsg.innerHTML = "<span style='color:Red'>Please fill radius for another location</span>";
                return false;
            }
            var advNewlocRadius = document.getElementById('LocationAdvSearchRadius').value;
            if (advNewlocRadius == "") {
                errMsg.innerHTML = "<span style='color:Red'>Please select a location to search seeds</span>";
                return false;
            }
        }
    }

    function getSelecteditemsAdvSearchExcludeTerms() {
        var divElem = document.getElementById("parentDivAdvSearchExcludeTerms");
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
            document.getElementById('lnk1AdvSearchExcludeTerms').innerHTML = "add";

        document.getElementById('txtAdvSearchExcludeTerms').value = FianlString;
    }

    $(document).ready(function () {
        //Adding autocomplete to Tag input
        $("#AutoCompleteAdvSearchExcludeTerms").autocomplete('<%: Url.Action("InExTerms", "SeedStream") %>', {
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
                $("#cityIdAdvSearchExcludeTerms").val(data[0]);
            else
                $("#cityIdAdvSearchExcludeTerms").val('-1')
        });
    });

    $(document).ready(function () {
        $("#catfeildAdvSearchExcludeTerms").hide();
    });

    $("#lnk1AdvSearchExcludeTerms").live('click', function () {
        $("#addAdvSearchExcludeTerms").hide();
        $("#catfeildAdvSearchExcludeTerms").show();
    });

    $("#lnk2AdvSearchExcludeTerms").live('click', function () {
        $("#catfeildAdvSearchExcludeTerms").hide();
        $("#addAdvSearchExcludeTerms").show();
    });
</script>
<style type="text/css">
#divAdvanceSearch .t-arrow-up, #divAdvanceSearch .t-arrow-down {display:none!important;\9}
</style>
<div>
    <% Html.Telerik().PanelBar()
           .Name("AdvanceSearchPanel")
            .ExpandMode(PanelBarExpandMode.Single)
            .Items(parent =>
            {
                parent.Add()
                    .Text(" ")
                    .Content(() =>
                    { %>
       <%using (Html.BeginForm("AdvanceSearch", "Seed", FormMethod.Post, new { enctype = "multipart/form-data", id = "advSearchForm" }))
  { %>
    <div id="AdvanceSearch">
        <h1>
            Advanced Search</h1>
        <h2>
            Find Seeds:</h2>
        <br />
        <table width="100%">
            <tr>
                <td width="55%">
                    <table width="95%">
                        <tr>
                            <td>
                                <input type="radio" value="AllLocations" id="rdoAdvAllLocations" name="AdvLocation"
                                    checked="checked" title="From All Locations" />From
                                all locations<br />
                                <input type="radio" value="CurrentLocation" id="rdoAdvCurrentLocation" name="AdvLocation"
                                    title="Current Location" />within
                                <input type="text" name="currentLocValue" id="rdoAdvCurrentLocValue" style="width: 40px;"
                                    maxlength="2" />
                                miles of my current location<br />
                                <input type="radio" value="NewLocation" id="rdoAdvNewLocation" name="AdvLocation" title="New Location" />within
                                <input type="text" name="AnotherLocValue" id="rdoAnotherLocValue" style="width: 40px;"
                                    maxlength="2" />
                                miles of <a style=" font-weight:bold; font-style:italic; cursor:pointer" id="radiusMap" style="cursor: pointer;" onclick="ExpandItemAdvSearch(1)">
                                    another location</a><br /><br />
                                <span id="spanAdvSearchRadius"></span>
                                <%: Html.Hidden("LocationAdvSearchRadius")%>
                                <%: Html.Hidden("CoordinatesAdvSearchRadius")%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="dashline">
                                <input type="radio" value="All" id="rdoAll" name="advMedia" checked="checked" title="All" />
                                with media<br />
                                <input type="radio" value="NoMedia" id="rdoNoMedia" name="advMedia" title="No Media" />
                                without media<br />
                                <input type="radio" value="PhotosOnly" id="rdoPhotosOnly" name="advMedia" title="Photos Only" />
                                with photos only<br />
                                <input type="radio" value="VideosOnly" id="rdoVideosOnly" name="advMedia" title="Videos Only" />
                                with videos only
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="dashline">
                                <input type="checkbox" value="IncludeReplySeeds" id="IncludeReplySeeds" name="advReplySeeds" />
                                Include Reply Seeds
                            </td>
                        </tr>
                    </table>
                </td>
                <td class="Vline">
                </td>
                <td valign="top">
                    <table>
                        <tr>
                            <td>
                                <h4>
                                    That contains these terms</h4>
                                <br />
                                <div class="scrollcat">
                                    <div id="parentDivAdvSearchIncludeTerms">
                                    </div>
                                </div>
                                <br />
                                <div style="height: 20px" id="catfeildAdvSearchIncludeTerms">
                                    <input type="text" id="AutoCompleteAdvSearchIncludeTerms" name="AutoCompleteAdvSearchIncludeTerms"
                                        class="categoryadd" style="float: left" title="Start typing to add a category, keyword, user" /><input
                                            type="button" value="Add" onclick="BindinDivAdvSearchIncludeTerms();" id="lnk2AdvSearchIncludeTerms"
                                            style="margin-left: 0px; margin-top: 3px;" class="adbtn" />
                                    <input type="text" id="txtAdvSearchIncludeTerms" name="txtAdvSearchIncludeTerms"
                                        style="display: none;" />
                                    <input type="text" id="cityIdAdvSearchIncludeTerms" style="display: none;" />
                                </div>
                                <div style="clear: both">
                                </div>
                                <div id="addAdvSearchIncludeTerms" class="addloc" style="padding-top: 1px;">
                                    <a id="lnk1AdvSearchIncludeTerms" style="padding-left: 2px;">add</a></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="dashline">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4>
                                    But don't contain these terms</h4>
                                <br />
                                <div class="scrollcat">
                                    <div id="parentDivAdvSearchExcludeTerms">
                                    </div>
                                </div>
                                <br />
                                <div class="categoryadd" id="catfeildAdvSearchExcludeTerms">
                                    <input type="text" id="AutoCompleteAdvSearchExcludeTerms" name="AutoCompleteAdvSearchExcludeTerms"
                                        style="float: left; margin-top: 2px!important" title="Start typing to add a category, keyword, user" /><input
                                            type="button" value="Add" onclick="BindinDivAdvSearchExcludeTerms();" class="adbtn"
                                            id="lnk2AdvSearchExcludeTerms" style="margin-left: 0px; margin-top: 0px;" />
                                    <input type="text" id="txtAdvSearchExcludeTerms" name="txtAdvSearchExcludeTerms"
                                        style="display: none;" />
                                    <input type="text" id="cityIdAdvSearchExcludeTerms" style="display: none;" />
                                </div>
                                <div id="addAdvSearchExcludeTerms" class="addloc" style="padding-top: 1px;">
                                    <a id="lnk1AdvSearchExcludeTerms" style="padding-left: 2px;">add</a></div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <input type="submit" class="btnplnt" value="Search" onclick="javascript:return SearchValidateInput();" />
                </td>
            </tr>
        </table>
    </div>
    <% } %>
    <% })
                    .Expanded(true);
                parent.Add()
                       .Content(() =>
                       {%>
   <div id="AdvanceSearch">
    <div id="mapAdvSearch" style="margin: 0px  auto; width: 90%; border: 0px solid #000;">
        <div class="frmadd">
            <input type="text" id="txtAdvSearchLocation" class="waterMark" style="float:left;" title="Enter address to locate ..." /><input
                type="button" value="GO" onclick="javascript:geocodeAdvSearch();" class="plantgo" />
        </div>
        <div class="clear">
        </div>
        <div id="map_canvas_adv_search" style="width: 100%; height: 400px; border: 1px solid #000">
        </div>
    </div>
    <div id="infoPanelAdvSearch" style="display: none">
        <input type="hidden" id="initLocationAdvSearch" />
        <input type="hidden" id="initCoordinatesAdvSearch" />
        <b>Marker status:</b>
        <div id="markerStatusAdvSearch">
            <i>Click and drag the marker.</i></div>
        <b>Current position:</b>
        <div id="infoAdvSearch">
        </div>
        <b>Closest matching address:</b>
        <div id="addressAdvSearch">
        </div>
    </div>
    <div class="mapbtncontent" style="background-color: White; width: 94%;">
        <input type="button" id="btnNoLocation" value="Cancel" onclick="ExpandItemAdvSearch(0)"
            class="btncan" />
        <input type="button" value="Set Location" onclick="javascript:setLocationAdvSearch();"
            class="btnsetloc" />
    </div><div class="clear">
    </div>
    <%});
            })
            .Render();
    %>
</div>
