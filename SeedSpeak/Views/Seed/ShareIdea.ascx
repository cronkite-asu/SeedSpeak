<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<style type="text/css">
    div#map
    {
        position: relative;
    }
</style>
<script src="../../Scripts/MicrosoftMvcAjax.js" type="text/javascript"></script>
<script src="../../Scripts/jqwatermark.js" type="text/javascript"></script>
<script src="../../Scripts/jquery.autocomplete.min.js" type="text/javascript"></script>
<script src="../../Scripts/jquery.MultiFile.js" type="text/javascript"></script>
<link href="../../Content/uc-style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    var ucMap;
    var geocoder;
    var centerChangedLast;
    var reverseGeocodedLast;
    var currentReverseGeocodeResponse;
    var geocoder = new google.maps.Geocoder();

    function geocodePosition(pos) {
        geocoder.geocode({
            latLng: pos
        }, function (responses) {
            if (responses && responses.length > 0) {
                updateMarkerAddress(responses[0].formatted_address);
            } else {
                updateMarkerAddress('Cannot determine address at this location.');
            }
        });
    }

    function updateMarkerStatus(str) {
        document.getElementById('markerStatus').innerHTML = str;
    }

    function updateMarkerPosition(latLng) {
        document.getElementById('info').innerHTML = [latLng.lat(), latLng.lng()].join(', ');
        document.getElementById('initCoordinates').value = [latLng.lat(), latLng.lng()].join(', ');
    }

    function updateMarkerAddress(str) {
        document.getElementById('address').innerHTML = str;
        document.getElementById('initLocation').value = str;
    }

    function initialize(lt, lg) {
        if (lt != null && lg != null) {
            var latlng = new google.maps.LatLng(lt, lg);
        }
        else {
            var latlng = new google.maps.LatLng(38.548153200759934, -107.22653749999995);
        }

        var addressTxt = document.getElementById("txtSearchLocation").value;
        if (addressTxt == 'Phoenix' || addressTxt == 'phoenix') {
            var latlng = new google.maps.LatLng(33.45837710574955, -112.12403729995599);
        }

        var myOptions = {
            zoom: 9,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        ucMap = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

        var marker = new google.maps.Marker({
            position: latlng,
            icon: new google.maps.MarkerImage("../../Content/images/seedLocPointer.png"),
            map: ucMap,
            draggable: true
        });
        geocoder = new google.maps.Geocoder();

        // Update current position info.
        updateMarkerPosition(latlng);
        geocodePosition(latlng);

        var contentString = "<div style='font-size:11px;'>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.</div>";
        var infowindow = new google.maps.InfoWindow({
            content: contentString
        });
        infowindow.open(ucMap, marker);

        // Add dragging event listeners.
        google.maps.event.addListener(marker, 'dragstart', function () {
            updateMarkerAddress('Dragging...');
            infowindow.close(ucMap, marker);
        });

        google.maps.event.addListener(marker, 'drag', function () {
            updateMarkerStatus('Dragging...');
            updateMarkerPosition(marker.getPosition());
        });

        google.maps.event.addListener(marker, 'dragend', function () {
            updateMarkerStatus('Drag ended');
            geocodePosition(marker.getPosition());
            infowindow.open(ucMap, marker);
        });
    }

    function geocode() {
        var address = document.getElementById("txtSearchLocation").value;
        geocoder.geocode(
        {
            'address': address,
            'partialmatch': true
        },
        geocodeResult);
    }

    function geocodeResult(results, status) {
        if (status == 'OK' && results.length > 0) {
            ucMap.fitBounds(results[0].geometry.viewport);
        }
        else {
            alert("Geocode was not successful for the following reason: " + status);
        }
        //ReAssigning Lat Long on Search
        var refLatLng = ucMap.getCenter().toString();
        refLatLng = refLatLng.replace('(', "");
        refLatLng = refLatLng.replace(')', "");
        var centerLatLng = refLatLng.split(',');
        initialize(centerLatLng[0].toString(), centerLatLng[1].toString());
        //ReAssigning Lat Long on Search
    }
    google.maps.event.addDomListener(window, 'load', initialize);
</script>
<script type="text/javascript">
    function ExpandItem(itemIndex) {
        var panelBar = $("#ShareIdeaPanel").data("tPanelBar");
        var item = $("> li", panelBar.element)[itemIndex];
        panelBar.expand(item);

        if (itemIndex == '1') {
            var gcenter = ucMap.getCenter();
            google.maps.event.trigger(ucMap, 'resize');
            ucMap.setCenter(gcenter);
            //initialize();
        }
    }

    function callProgressWindow() {
        var pgrs = $('#progressWindow').data('tWindow');
        $('.t-window-titlebar').hide();
        pgrs.center().open();
    }

    function validateInput() {
        var title = document.getElementById('txtSeedTitle').value;
        var desc = document.getElementById('txtDesc').value;
        var seedLoc = document.getElementById('seedLocation').value;
        var msg = document.getElementById('result');
        if (title == "" || title == "Give your idea or suggestion a title...") {
            msg.innerHTML = "Title can not be left blank";
            return false;
        }
        if (desc == "" || desc == "Describe your idea or suggestion here...") {
            msg.innerHTML = "Description can not be left blank";
            return false;
        }
        if (seedLoc == "") {
            msg.innerHTML = "You can not plant seed without pointing any location";
            return false;
        }
        callProgressWindow();
    }

    function setLocation() {
        document.getElementById('seedCoordinates').value = document.getElementById('initCoordinates').value;
        var initStr = document.getElementById('initLocation').value;
        var splitStr = initStr.split(',');
        var finalStr;
        for (i = 0; i < splitStr.length; i++) {
            if (i == 0)
                finalStr = splitStr[i].toString();
            else
                finalStr = finalStr + ",<br/>" + splitStr[i].toString();
        }
        document.getElementById('spanLocation').innerHTML = finalStr;
        document.getElementById('seedLocation').value = initStr;
        document.getElementById('setLocationAnchor').innerHTML = "Change";
        ExpandItem(0);
    }
</script>
<script type="text/javascript" language="javascript">
    function BindinDiv() {
        var catgDDL = document.getElementById('CategoryAutoComplete');
        if (catgDDL.options[catgDDL.selectedIndex].text != "" && catgDDL.options[catgDDL.selectedIndex].text != "Start typing here") {
            if (document.getElementById('txtCategory').value == null || document.getElementById('txtCategory').value == "") {
                //adding value in textbox
                document.getElementById('txtCategory').value = catgDDL.options[catgDDL.selectedIndex].text;
            }
            else {
                //adding value in textbox
                document.getElementById('txtCategory').value = document.getElementById('txtCategory').value + "," + catgDDL.options[catgDDL.selectedIndex].text;
            }

            if (document.getElementById(catgDDL.options[catgDDL.selectedIndex].text + 'plnt') == null) {
                var LDivObj = document.getElementById('parentDiv');

                //creating div with cros button
                var divTag = document.createElement("div");
                divTag.id = catgDDL.options[catgDDL.selectedIndex].text + 'plnt';

                divTag.onmouseover = function () { mouseOverDiv(divTag.id); };
                divTag.onmouseout = function () { mouseOutDiv(divTag.id); };
                var ss = "<img id='img" + catgDDL.options[catgDDL.selectedIndex].text + 'plnt' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";

                divTag.innerHTML = "<span>" + catgDDL.options[catgDDL.selectedIndex].text + ss + ",</span>";
                LDivObj.appendChild(divTag);
                var imgBTN = document.getElementById("img" + catgDDL.options[catgDDL.selectedIndex].text + 'plnt');
                imgBTN.onclick = function () { deletediv(divTag.id); };
            }
            else {
                alert("already selected");
            }
        }
    }

    function deletediv(abc) {
        var child = document.getElementById(abc);
        var parent = document.getElementById('parentDiv');
        parent.removeChild(child);
        getSelecteditems();
    }

    function mouseOverDiv(imgId) {
        document.getElementById('img' + imgId).style.visibility = "visible";
    }

    function mouseOutDiv(imgId) {
        document.getElementById('img' + imgId).style.visibility = "hidden";
    }

    function getSelecteditems() {
        var divElem = document.getElementById("parentDiv");
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
        document.getElementById('txtCategory').value = FianlString;
    }

    $(function () {
        $("#txtSearchLocation").keypress(function (event) {
            if (event.keyCode == '13') {
                geocode(); return false
            }
        });
    });
</script>
<script type="text/javascript" language="javascript">
    $(document).ready(function () {

        $("#catfeild").hide();
    });

    $("#lnk1").live('click', function () {
        $("#addcat").hide();
        $("#catfeild").show();
    });

    $("#lnk2").live('click', function () {
        $("#catfeild").hide();
        $("#addcat").show();
    });
</script>
<% Html.Telerik().PanelBar()
           .Name("ShareIdeaPanel")
            .ExpandMode(PanelBarExpandMode.Single)
            .Items(parent =>
            {
                parent.Add()
                    .Text(" ")
                    .Content(() =>
                    { %>
<%using (Html.BeginForm("ShareIdea1", "Seed", FormMethod.Post, new { enctype = "multipart/form-data", id = "sharedForm", style = "float:left" }))
  { %>
<table border="0" width="680px">
    <tr>
        <td colspan="3" style="height: 8px">
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <div id="updating" style="display: none">
            </div>
            <span id="result" style="color: Red; padding-left: 40px">
                <%if (ViewData["PlantErrMsg"] != null)
                  {
                %>
                <%=ViewData["PlantErrMsg"].ToString()%>
                <% 
                  } %>
            </span>
        </td>
    </tr>
    <tr>
        <td width="321" style="width: 300px;">
            <table width="87%" border="0" align="right" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <input type="text" id="txtSeedTitle" name="txtSeedTitle" maxlength="40" class="waterMark"
                            title="Give your idea or suggestion a title..." />
                    </td>
                </tr>
                <tr>
                    <td>
                        <textarea id="txtDesc" name="txtDesc" cols="40" rows="20" class="waterMark" title="Describe your idea or suggestion here..."></textarea>
                    </td>
                </tr>
            </table>
        </td>
        <td width="44" rowspan="2" class="divider" style="width: 50px">
        </td>
        <td width="301" rowspan="2" align="center" valign="top" style="width: 254px">
            <table border="0" class="plantdetailbox" cellpadding="0" cellspacing="0" width="80%">
                <tr>
                    <th style="padding-top: 10px;">
                        Media
                    </th>
                </tr>
                <tr>
                    <td valign="top">
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="padding-bottom: 0px;">
                        <div class="fileinputs" style="cursor: pointer">
                            <input type="file" class="multi" id="mediaFiles" name="mediaFiles" maxlength="5"
                                size="1" style="cursor: pointer" accept="jpg|png|gif|mp4|swf|mpg|flv|mov" />
                            <div class="fakefile">
                                <a style="cursor: pointer">add</a></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th style="border-top: 1px dashed #000; padding-top: 10px;">
                        Category
                    </th>
                </tr>
                <tr>
                    <td valign="top">
                        <div class="scrollcat">
                            <div id="parentDiv">
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <div class="categoryadd" id="catfeild">
                            <%
                  SeedSpeak.BLL.CategoryAction objCategory = new SeedSpeak.BLL.CategoryAction();
                  IList<SeedSpeak.Model.Category> lstCategory = objCategory.GetAllCategories();
                  SelectList lstCats = new SelectList(lstCategory, "id", "name");
                            %>
                            <div style="width: 175px; float: left;">
                                <%: Html.DropDownList("CategoryAutoComplete", lstCats)%></div>
                            <input type="button" value="Add" onclick="BindinDiv();" class="btnaddcat" id="lnk2" />
                            <input type="text" id="txtCategory" name="txtCategory" style="display: none;" />
                            <input type="text" id="cityId" style="display: none;" />
                        </div>
                        <div id="addcat">
                            <a id="lnk1">add</a></div>
                    </td>
                </tr>
                <tr>
                    <th style="border-top: 1px dashed #000; padding-top: 10px;">
                        Location
                    </th>
                </tr>
                <tr>
                    <td align="left">
                        <div>
                            <span id="spanLocation"></span>
                            <%: Html.Hidden("seedLocation") %>
                            <%: Html.Hidden("seedCoordinates") %>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="left">
                        <div class="addloc">
                            <a id="setLocationAnchor" onclick="ExpandItem(1)">add</a></div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="center" style="width: 300px;">
            &nbsp;
        </td>
    </tr>
    <tr>
        <td>
            &nbsp;
        </td>
        <td>
            &nbsp;
        </td>
        <td align="right" style="padding-top: 40px">
            <input type="button" value="Discard" class="btndis" onclick="window.location = '../../Member/Default';" />
            <input type="submit" value="Plant" class="btnplnt" onclick="javascript:return validateInput();" />
        </td>
    </tr>
</table>
<% } %>
<% })
                    .Expanded(true);
                parent.Add()

                       .Content(() =>
                       {%>
<div id="map" style="margin: 6px  auto; width: 90%; border: 0px solid #000;">
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
    <div class="locfrm" style="height: 100px">
        <div class="steps">
            <span>Step 1:</span> Define Your Location</div>
        <input type="text" id="txtSearchLocation" class="waterMark" title="Enter address where you want to plant..." /><input
            type="button" value="GO" onclick="javascript:geocode();" class="plantgo" />
        <span style="color: #7F7F7F; font-size: 17px; float: left; margin: 3px 6px 0 0;">OR</span>
        <input type="button" class="btnucl" style="margin-bottom: 0px" value="Use Current Location"
            onclick="javascript:initialize('<%=latSearch %>','<%=lngSearch %>');" /><br />
        <div class="steps">
            <span>Step 2:</span> Drag the SeedSpeak Icon to a Place Nearby</div>
    </div>
    <div class="clear">
    </div>
    <div id="map_canvas" style="width: 100%; height: 370px; border: 1px solid #000">
    </div>
</div>
<div id="infoPanel" style="display: none">
    <input type="hidden" id="initLocation" />
    <input type="hidden" id="initCoordinates" />
    <b>Marker status:</b>
    <div id="markerStatus">
        <i>Click and drag the marker.</i></div>
    <b>Current position:</b>
    <div id="info">
    </div>
    <b>Closest matching address:</b>
    <div id="address">
    </div>
</div>
<div class="steps" style="float: left; margin: 15px 0 0 25px">
    <span>Step 3:</span> Set Location</div>
<div class="mapbtncontent">
    <input type="button" value="Cancel" onclick="ExpandItem(0)" style="margin-top: 5px"
        class="btngoback" /><input type="button" value="Set Location" onclick="javascript:setLocation();"
            style="margin-top: 5px" class="btnsetloc" />
</div>
<%});
            })
            .Render();
%>
<div class="clear">
</div>
<div>
    <% Html.Telerik().Window()
           .Name("progressWindow")
           .Modal(true)
           .Visible(false)
           .Content(() =>
           {%>
    <div style="background-color: Silver; padding: 25px">
        <img src="../../Content/images/ajaxloader.gif" alt="Please wait..." />
        <br />
        <span style="color: Red; margin: auto"><small>Please wait while we process your request</small></span>
    </div>
    <%})
           .Width(350)
           .Height(120)
           .Render();
    %>
</div>
