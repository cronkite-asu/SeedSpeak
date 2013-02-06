<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<script type="text/javascript">
    var ucMapRpl;
    var geocoderRpl;
    var centerChangedLastRpl;
    var reverseGeocodedLastRpl;
    var currentReverseGeocodeResponseRpl;
    var geocoderRpl = new google.maps.Geocoder();

    function geocodeRplPosition(pos) {
        geocoderRpl.geocode({
            latLng: pos
        }, function (responses) {
            if (responses && responses.length > 0) {
                updateMarkerAddressRpl(responses[0].formatted_address);
            } else {
                updateMarkerAddressRpl('Cannot determine address at this location.');
            }
        });
    }

    function updateMarkerStatusRpl(str) {
        document.getElementById('markerStatusRpl').innerHTML = str;
    }

    function updateMarkerPositionRpl(latLng) {
        document.getElementById('infoRpl').innerHTML = [latLng.lat(), latLng.lng()].join(', ');
        document.getElementById('initCoordinatesRpl').value = [latLng.lat(), latLng.lng()].join(', ');
    }

    function updateMarkerAddressRpl(str) {
        document.getElementById('addressRpl').innerHTML = str;
        document.getElementById('initLocationRpl').value = str;
    }

    function initializeRpl(lt, lg) {
        if (lt != null && lg != null) {
            var latlng = new google.maps.LatLng(lt, lg);
        }
        else {
            var latlng = new google.maps.LatLng(38.548153200759934, -107.22653749999995);
        }

        var myOptions = {
            zoom: 9,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        ucMapRpl = new google.maps.Map(document.getElementById("map_canvas_rpl"), myOptions);

        var rplmarker = new google.maps.Marker({
            position: latlng,
            icon: new google.maps.MarkerImage("../../Content/images/seedLocPointer.png"),
            map: ucMapRpl,
            draggable: true
        });
        geocoderRpl = new google.maps.Geocoder();

        // Update current position info.
        updateMarkerPositionRpl(latlng);
        geocodeRplPosition(latlng);

        var contentStringRpl = "<div style='font-size:11px;'>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.</div>";
        var infowindowRpl = new google.maps.InfoWindow({
            content: contentStringRpl
        });
        infowindowRpl.open(ucMapRpl, rplmarker);

        // Add dragging event listeners.
        google.maps.event.addListener(rplmarker, 'dragstart', function () {
            updateMarkerAddressRpl('Dragging...');
            infowindowRpl.close(ucMapRpl, rplmarker);
        });

        google.maps.event.addListener(rplmarker, 'drag', function () {
            updateMarkerStatusRpl('Dragging...');
            updateMarkerPositionRpl(rplmarker.getPosition());
        });

        google.maps.event.addListener(rplmarker, 'dragend', function () {
            updateMarkerStatusRpl('Drag ended');
            geocodeRplPosition(rplmarker.getPosition());
            infowindowRpl.open(ucMapRpl, rplmarker);
        });
    }

    function Rplgeocode() {
        var addressRpl = document.getElementById("txtRplSearchLocation").value;
        geocoderRpl.geocode(
        {
            'address': addressRpl,
            'partialmatch': true
        },
        geocodeResultRpl);
    }

    function geocodeResultRpl(results, status) {
        if (status == 'OK' && results.length > 0) {
            ucMapRpl.fitBounds(results[0].geometry.viewport);
        }
        else {
            alert("Geocode was not successful for the following reason: " + status);
        }
        //ReAssigning Lat Long on Search
        var refLatLng = ucMapRpl.getCenter().toString();
        refLatLng = refLatLng.replace('(', "");
        refLatLng = refLatLng.replace(')', "");
        var centerLatLng = refLatLng.split(',');
        initializeRpl(centerLatLng[0].toString(), centerLatLng[1].toString());
        //ReAssigning Lat Long on Search
    }
    google.maps.event.addDomListener(window, 'load', initializeRpl);
</script>
<script type="text/javascript">
    function ExpandItemRpl(itemIndex) {
        var panelBarRpl = $("#ReplySeedPanel").data("tPanelBar");
        var item = $("> li", panelBarRpl.element)[itemIndex];
        panelBarRpl.expand(item);

        if (itemIndex == '1') {
            //google.maps.event.trigger(ucMapRpl, 'resize');
            var gcenter = ucMapRpl.getCenter();
            google.maps.event.trigger(ucMapRpl, 'resize');
            ucMapRpl.setCenter(gcenter);
            //initialize();
        }
    }

    function callProgressWindowRpl() {
        var pgrs = $('#progressWindowRpl').data('tWindow');
        $('.t-window-titlebar').hide();
        pgrs.center().open();
    }

    function validateInputRpl() {
        var title = document.getElementById('txtRplSeedTitle').value;
        var desc = document.getElementById('txtRplDesc').value;
        var seedLoc = document.getElementById('seedLocationRpl').value;
        var msg = document.getElementById('resultRpl');
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
        callProgressWindowRpl();
    }

    function setLocationRpl() {
        document.getElementById('seedCoordinatesRpl').value = document.getElementById('initCoordinatesRpl').value;
        var initStr = document.getElementById('initLocationRpl').value;
        var splitStr = initStr.split(',');
        var finalStr;
        for (i = 0; i < splitStr.length; i++) {
            if (i == 0)
                finalStr = splitStr[i].toString();
            else
                finalStr = finalStr + ",<br/>" + splitStr[i].toString();
        }
        document.getElementById('spanLocationRpl').innerHTML = finalStr;
        document.getElementById('seedLocationRpl').value = initStr;
        document.getElementById('setLocationAnchorRpl').innerHTML = "Change";
        ExpandItemRpl(0);
    }
</script>
<script type="text/javascript" language="javascript">
    function BindinDivRpl() {
        var catgDDLRpl = document.getElementById('CategoryAutoCompleteRpl');
        if (catgDDLRpl.options[catgDDLRpl.selectedIndex].text != "" && catgDDLRpl.options[catgDDLRpl.selectedIndex].text != "Start typing here") {
            if (document.getElementById('txtCategoryRpl').value == null || document.getElementById('txtCategoryRpl').value == "") {
                //adding value in textbox
                document.getElementById('txtCategoryRpl').value = catgDDLRpl.options[catgDDLRpl.selectedIndex].text;
            }
            else {
                //adding value in textbox
                document.getElementById('txtCategoryRpl').value = document.getElementById('txtCategoryRpl').value + "," + catgDDLRpl.options[catgDDLRpl.selectedIndex].text;
            }

            if (document.getElementById(catgDDLRpl.options[catgDDLRpl.selectedIndex].text + 'rpl') == null) {
                var LDivObj = document.getElementById('parentDivRpl');

                //creating div with cros button
                var divTag = document.createElement("div");
                divTag.id = catgDDLRpl.options[catgDDLRpl.selectedIndex].text + 'rpl';

                divTag.onmouseover = function () { mouseOverDivRpl(divTag.id); };
                divTag.onmouseout = function () { mouseOutDivRpl(divTag.id); };
                var ss = "<img id='img" + document.getElementById('CategoryAutoCompleteRpl').value + 'rpl' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";

                divTag.innerHTML = "<span>" + catgDDLRpl.options[catgDDLRpl.selectedIndex].text + ss + ",</span>";
                LDivObj.appendChild(divTag);
                var imgBTN = document.getElementById("img" + catgDDLRpl.options[catgDDLRpl.selectedIndex].text + 'rpl');
                imgBTN.onclick = function () { deletedivRpl(divTag.id); };
            }
            else {
                alert("already selected");
            }
        }
    }

    function deletedivRpl(abc) {
        var child = document.getElementById(abc);
        var parent = document.getElementById('parentDivRpl');
        parent.removeChild(child);
        getSelecteditemsRpl();
    }

    function mouseOverDivRpl(imgId) {
        document.getElementById('img' + imgId).style.visibility = "visible";
    }

    function mouseOutDivRpl(imgId) {
        document.getElementById('img' + imgId).style.visibility = "hidden";
    }

    function getSelecteditemsRpl() {
        var divElem = document.getElementById("parentDivRpl");
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
        document.getElementById('txtCategoryRpl').value = FianlString;
    }

    $(function () {
        $("#txtRplSearchLocation").keypress(function (event) {
            if (event.keyCode == '13') {
                Rplgeocode(); return false
            }
        });
    });
</script>
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        $("#catfeildRpl").hide();
    });

    $("#lnk1Rpl").live('click', function () {
        $("#addcatRpl").hide();
        $("#catfeildRpl").show();
    });

    $("#lnk2Rpl").live('click', function () {
        $("#catfeildRpl").hide();
        $("#addcatRpl").show();
    });
</script>
<style>
    #txtRplSeedTitle
    {
        width: 307px;
        border: 0px;
        height: 31px;
        background-image: url("../../Content/images/stream-title-input.png") !important;
        background-repeat: no-repeat;
        border: 0px;
        background-position: 0 0 !important;
        margin-left: 22px;
    }
    
    #txtRplDesc
    {
        width: 307px;
        height: 151px !important;
        background-image: url("../../Content/images/gfeedec_input.png") !important;
        background-repeat: no-repeat !important;
        border: 0px;
        margin-left: 22px;
        padding-top: 5px !important;
    }
</style>
<% Html.Telerik().PanelBar()
           .Name("ReplySeedPanel")
            .ExpandMode(PanelBarExpandMode.Single)
            .Items(parent =>
            {
                parent.Add()
                    .Text(" ")
                    .Content(() =>
                    { %>
<%using (Html.BeginForm("ReplySeed", "Seed", FormMethod.Post, new { enctype = "multipart/form-data", id = "replySeedForm" }))
  { %>
<table class="plantboxfrm" width="900px" border="0">
    <tr>
        <td colspan="3" class="heading">
            Reply Seed
        </td>
    </tr>
    <tr>
        <td colspan="3" valign="top">
            <span id="resultRpl" style="color: Red">
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
        <td valign="top" style="width: 200px;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <input type="text" id="txtRplSeedTitle" name="txtRplSeedTitle" maxlength="40" class="waterMark"
                            title="Give your idea or suggestion a title..." />
                    </td>
                </tr>
                <tr>
                    <td>
                        <textarea id="txtRplDesc" name="txtRplDesc" rows="4" cols="30" class="waterMark"
                            title="Describe your idea or suggestion here..."></textarea>
                    </td>
                </tr>
            </table>
        </td>
        <td style="width: 60px" rowspan="2" align="center" class="divider">
        </td>
        <td valign="top" align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <table width="100%" class="plantdetailbox" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <th style="width: 150px; vertical-align: top">
                                    Location
                                </th>
                                <td>
                                    <div class="addloc">
                                        <a id="setLocationAnchorRpl" onclick="ExpandItemRpl(1)">add</a></div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div>
                                        <span id="spanLocationRpl"></span>
                                        <%: Html.Hidden("seedLocationRpl") %>
                                        <%: Html.Hidden("seedCoordinatesRpl") %>
                                        <%: Html.Hidden("RplRootSeedID") %>
                                        <%: Html.Hidden("RplParentSeedID") %>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="2" style="border-top: 1px solid #CCC;">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" style="border-right: solid 1px #CCC; vertical-align: top; width: 47%">
                                    <table border="0" class="plantdetailbox" cellpadding="0" cellspacing="0" width="100%">
                                        <tr align="left">
                                            <th style="padding-left: 0px; text-align: left;">
                                                Media
                                            </th>
                                        </tr>
                                        <tr>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" style="padding-bottom: 0px; padding-left: 0px;">
                                                <div class="fileinputs" style="cursor: pointer">
                                                    <input type="file" class="multi" id="mediaFilesRpl" name="mediaFilesRpl" maxlength="5"
                                                        size="1" style="cursor: pointer" accept="jpg|png|gif|mp4|swf|mpg|flv|mov" />
                                                    <div class="fakefile">
                                                        <a style="cursor: pointer">add another</a></div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td valign="top">
                                    <table border="0" class="plantdetailbox" cellpadding="0" cellspacing="0" width="95%">
                                        <tr>
                                            <th align="left" style="padding-left: 20px;">
                                                Category
                                            </th>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <div class="scrollcat">
                                                    <div id="parentDivRpl">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" style="padding-left: 25px;">
                                                <div class="categoryadd" id="catfeildRpl">
                                                    <%
SeedSpeak.BLL.CategoryAction objCategory = new SeedSpeak.BLL.CategoryAction();
IList<SeedSpeak.Model.Category> lstCategory = objCategory.GetAllCategories();
SelectList lstCatsRpl = new SelectList(lstCategory, "id", "name");
                                                    %>
                                                    <div style="width: 175px; float: left;">
                                                        <%: Html.DropDownList("CategoryAutoCompleteRpl", lstCatsRpl)%></div>
                                                    <input type="button" value="Add" onclick="BindinDivRpl();" class="btnaddcat" id="lnk2Rpl" />
                                                    <input type="text" id="txtCategoryRpl" name="txtCategoryRpl" style="display: none;" />
                                                    <input type="text" id="cityIdRpl" style="display: none;" />
                                                </div>
                                                <div id="addcatRpl" class="addloc">
                                                    <a id="lnk1Rpl">add another</a></div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
        </td>
        <td style="float: right; padding-top: 15px;">
            <input type="button" value="Discard" class="btndis" onclick="window.location = '../../Member/Default';" />
            <input type="submit" value="Plant" class="replybtn" onclick="javascript:return validateInputRpl();" />
        </td>
    </tr>
</table>
<% } %>
<% })
                    .Expanded(true);
                parent.Add()

                       .Content(() =>
                       {%>
<div id="mapRpl" style="margin: 6px  auto; width: 90%; border: 0px solid #000;">
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
        <div class="steps" style="margin-left: 0px">
            <span>Step 1:</span> Define Your Location</div>
        <input type="text" id="txtRplSearchLocation" class="waterMark" title="Enter address where you want to plant..." /><input
            type="button" value="GO" onclick="javascript:Rplgeocode();" class="plantgo" />
        <span style="color: #7F7F7F; font-size: 17px; float: left; margin: 3px 2px 0 4px;">OR</span>
        <input type="button" class="btnucl" value="Use Current Location" onclick="javascript:initializeRpl('<%=latSearch %>','<%=lngSearch %>');" /><br />
        <div class="steps" style="margin-left: 0px">
            <span>Step 2:</span> Drag the SeedSpeak Icon to a Place Nearby
        </div>
    </div>
    <div class="clear">
    </div>
    <div id="map_canvas_rpl" style="width: 100%; height: 330px; border: 1px solid #000">
    </div>
</div>
<div id="infoPanelRpl" style="display: none">
    <input type="hidden" id="initLocationRpl" />
    <input type="hidden" id="initCoordinatesRpl" />
    <b>Marker status:</b>
    <div id="markerStatusRpl">
        <i>Click and drag the marker.</i></div>
    <b>Current position:</b>
    <div id="infoRpl">
    </div>
    <b>Closest matching address:</b>
    <div id="addressRpl">
    </div>
</div>
<div class="steps" style="float: left; margin: 15px 0 0 45px">
    <span style="margin-left: 0px">Step 3:</span> Set Location
</div>
<div class="mapbtncontent">
    <input type="button" value="Cancel" onclick="ExpandItemRpl(0)" class="btncan" /><input
        type="button" value="Set Location" onclick="javascript:setLocationRpl();" class="btnsetloc" />
</div>
<%});
            })
            .Render();
%>
<div class="clear">
</div>
<div>
    <% Html.Telerik().Window()
           .Name("progressWindowRpl")
           .Modal(true)
           .Visible(false)
           .Content(() =>
           {%>
    <div style="padding-top: 40px; text-align: center">
        <img src="../../Content/images/ajaxloader.gif" alt="Please wait..." />
        <br />
        <span style="color: Red;"><small>Please wait while we process your request</small></span>
    </div>
    <%})
           .Width(350)
           .Height(100)
           .Render();
    %>
</div>
