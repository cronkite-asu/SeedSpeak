<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    var ucMapEdt;
    var geocoderEdt;
    var centerChangedLastEdt;
    var reverseGeocodedLastEdt;
    var currentReverseGeocodeResponseEdt;
    var geocoderEdt = new google.maps.Geocoder();

    function geocodeEdtPosition(pos) {
        geocoderEdt.geocode({
            latLng: pos
        }, function (responses) {
            if (responses && responses.length > 0) {
                updateMarkerAddressEdt(responses[0].formatted_address);
            } else {
                updateMarkerAddressEdt('Cannot determine address at this location.');
            }
        });
    }

    function updateMarkerStatusEdt(str) {
        document.getElementById('markerStatusEdt').innerHTML = str;
    }

    function updateMarkerPositionEdt(latLng) {
        document.getElementById('infoEdt').innerHTML = [latLng.lat(), latLng.lng()].join(', ');
        document.getElementById('initCoordinatesEdt').value = [latLng.lat(), latLng.lng()].join(', ');
    }

    function updateMarkerAddressEdt(str) {
        document.getElementById('addressEdt').innerHTML = str;
        document.getElementById('initLocationEdt').value = str;
        setLocationEdtReady();
    }

    function initializeEdt(lt, lg) {
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
        ucMapEdt = new google.maps.Map(document.getElementById("map_canvas_edt"), myOptions);

        var Edtmarker = new google.maps.Marker({
            position: latlng,
            icon: new google.maps.MarkerImage("../../Content/images/seedLocPointer.png"),
            map: ucMapEdt,
            draggable: true
        });
        geocoderEdt = new google.maps.Geocoder();

        // Update current position info.
        updateMarkerPositionEdt(latlng);
        geocodeEdtPosition(latlng);

        var contentStringEdt = "<div style='font-size:11px;'>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.</div>";
        var infowindowEdt = new google.maps.InfoWindow({
            content: contentStringEdt
        });
        infowindowEdt.open(ucMapEdt, Edtmarker);

        // Add dragging event listeners.
        google.maps.event.addListener(Edtmarker, 'dragstart', function () {
            updateMarkerAddressEdt('Dragging...');
            infowindowEdt.close(ucMapEdt, Edtmarker);
        });

        google.maps.event.addListener(Edtmarker, 'drag', function () {
            updateMarkerStatusEdt('Dragging...');
            updateMarkerPositionEdt(Edtmarker.getPosition());
        });

        google.maps.event.addListener(Edtmarker, 'dragend', function () {
            updateMarkerStatusEdt('Drag ended');
            geocodeEdtPosition(Edtmarker.getPosition());
            infowindowEdt.open(ucMapEdt, Edtmarker);
        });
    }

    function Edtgeocode() {
        var addressEdt = document.getElementById("txtEdtSearchLocation").value;
        geocoderEdt.geocode(
        {
            'address': addressEdt,
            'partialmatch': true
        },
        geocodeResultEdt);
    }

    function geocodeResultEdt(results, status) {
        if (status == 'OK' && results.length > 0) {
            ucMapEdt.fitBounds(results[0].geometry.viewport);
        }
        else {
            alert("Geocode was not successful for the following reason: " + status);
        }
        //ReAssigning Lat Long on Search
        var refLatLng = ucMapEdt.getCenter().toString();
        refLatLng = refLatLng.replace('(', "");
        refLatLng = refLatLng.replace(')', "");
        var centerLatLng = refLatLng.split(',');
        initializeEdt(centerLatLng[0].toString(), centerLatLng[1].toString());
        //ReAssigning Lat Long on Search
    }
    google.maps.event.addDomListener(window, 'load', initializeEdt);
</script>
<script type="text/javascript">
    function ExpandItemEdt(itemIndex) {
        var panelBarEdt = $("#EditSeedPanel").data("tPanelBar");
        var item = $("> li", panelBarEdt.element)[itemIndex];
        panelBarEdt.expand(item);

        if (itemIndex == '1') {
            //google.maps.event.trigger(ucMapEdt, 'resize');
            var gcenter = ucMapEdt.getCenter();
            google.maps.event.trigger(ucMapEdt, 'resize');
            ucMapEdt.setCenter(gcenter);
            //initialize();
        }
    }

    function callProgressWindowEdt() {
        var pgrs = $('#progressWindowEdt').data('tWindow');
        $('.t-window-titlebar').hide();
        pgrs.center().open();
    }

    function validateInputEdt() {
        var title = document.getElementById('txtEdtSeedTitle').value;
        var desc = document.getElementById('txtEdtDesc').value;
        var seedLoc = document.getElementById('seedLocationEdt').value;
        var msg = document.getElementById('resultEdt');
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
        callProgressWindowEdt();
    }

    function setLocationEdt() {
        document.getElementById('seedCoordinatesEdt').value = document.getElementById('initCoordinatesEdt').value;
        var initStr = document.getElementById('initLocationEdt').value;
        var splitStr = initStr.split(',');
        var finalStr;
        for (i = 0; i < splitStr.length; i++) {
            if (i == 0)
                finalStr = splitStr[i].toString();
            else
                finalStr = finalStr + ",<br/>" + splitStr[i].toString();
        }
        document.getElementById('spanLocationEdt').innerHTML = finalStr;
        document.getElementById('seedLocationEdt').value = initStr;
        document.getElementById('setLocationAnchorEdt').innerHTML = "Change";
        ExpandItemEdt(0);
    }
    function setLocationEdtReady() {
        document.getElementById('seedCoordinatesEdt').value = document.getElementById('initCoordinatesEdt').value;
        var initStr = document.getElementById('initLocationEdt').value;
        var splitStr = initStr.split(',');
        var finalStr;
        for (i = 0; i < splitStr.length; i++) {
            if (i == 0)
                finalStr = splitStr[i].toString();
            else
                finalStr = finalStr + ",<br/>" + splitStr[i].toString();
        }
        document.getElementById('spanLocationEdt').innerHTML = finalStr;
        document.getElementById('seedLocationEdt').value = initStr;
        document.getElementById('setLocationAnchorEdt').innerHTML = "Change";
    }
</script>
<script type="text/javascript" language="javascript">
    function BindinDivEdt() {
        var catgDDLEdt = document.getElementById('CategoryAutoCompleteEdt');
        if (catgDDLEdt.options[catgDDLEdt.selectedIndex].text != "" && catgDDLEdt.options[catgDDLEdt.selectedIndex].text != "Start typing here") {
            if (document.getElementById('txtCategoryEdt').value == null || document.getElementById('txtCategoryEdt').value == "") {
                //adding value in textbox
                document.getElementById('txtCategoryEdt').value = catgDDLEdt.options[catgDDLEdt.selectedIndex].text;
            }
            else {
                //adding value in textbox
                document.getElementById('txtCategoryEdt').value = document.getElementById('txtCategoryEdt').value + "," + catgDDLEdt.options[catgDDLEdt.selectedIndex].text;
            }

            if (document.getElementById(catgDDLEdt.options[catgDDLEdt.selectedIndex].text + 'edt') == null) {
                var LDivObj = document.getElementById('parentDivEdt');

                //creating div with cros button
                var divTag = document.createElement("div");
                divTag.id = catgDDLEdt.options[catgDDLEdt.selectedIndex].text + 'edt';

                divTag.onmouseover = function () { mouseOverDivEdt(divTag.id); };
                divTag.onmouseout = function () { mouseOutDivEdt(divTag.id); };
                var ss = "<img id='img" + catgDDLEdt.options[catgDDLEdt.selectedIndex].text + 'edt' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";

                divTag.innerHTML = "<span>" + catgDDLEdt.options[catgDDLEdt.selectedIndex].text + ss + ",</span>";
                LDivObj.appendChild(divTag);
                var imgBTN = document.getElementById("img" + catgDDLEdt.options[catgDDLEdt.selectedIndex].text + 'edt');
                imgBTN.onclick = function () { deletedivEdt(divTag.id); };
            }
            else {
                alert("already selected");
            }
        }
    }

    function BindinDivEdt1(cats) {
        var catgDDLEdt = cats;
        if (catgDDLEdt != "" && catgDDLEdt != "Start typing here") {
            if (document.getElementById('txtCategoryEdt').value == null || document.getElementById('txtCategoryEdt').value == "") {
                //adding value in textbox
                document.getElementById('txtCategoryEdt').value = catgDDLEdt;
            }
            else {
                //adding value in textbox
                document.getElementById('txtCategoryEdt').value = document.getElementById('txtCategoryEdt').value + "," + catgDDLEdt;
            }

            if (document.getElementById(catgDDLEdt + 'edt') == null) {
                var LDivObj = document.getElementById('parentDivEdt');

                //creating div with cros button
                var divTag = document.createElement("div");
                divTag.id = catgDDLEdt + 'edt';

                divTag.onmouseover = function () { mouseOverDivEdt(divTag.id); };
                divTag.onmouseout = function () { mouseOutDivEdt(divTag.id); };
                var ss = "<img id='img" + catgDDLEdt + 'edt' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";

                divTag.innerHTML = "<span>" + catgDDLEdt + ss + ",</span>";
                LDivObj.appendChild(divTag);
                var imgBTN = document.getElementById("img" + catgDDLEdt + 'edt');
                imgBTN.onclick = function () { deletedivEdt(divTag.id); };
            }
            else {
                alert("already selected");
            }
        }
    }

    function deletedivEdt(abc) {
        var child = document.getElementById(abc);
        var parent = document.getElementById('parentDivEdt');
        parent.removeChild(child);
        getSelecteditemsEdt();
    }

    function mouseOverDivEdt(imgId) {
        document.getElementById('img' + imgId).style.visibility = "visible";
    }

    function mouseOutDivEdt(imgId) {
        document.getElementById('img' + imgId).style.visibility = "hidden";
    }

    function getSelecteditemsEdt() {
        var divElem = document.getElementById("parentDivEdt");
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
        document.getElementById('txtCategoryEdt').value = FianlString;
    }

    function EditSeed(id) {
        $.post("/Seed/EditSeedById1/?id=" + id,
            function (data) {
                if (data.toString() != "") {
                    var obj = jQuery.parseJSON(data);
                    var esw = $('#EditMySeedWindow').data('tWindow');
                    esw.center().open();
                    $('#txtEdtSeedTitle').val(obj.seedTitle);
                    $('#txtEdtDesc').val(obj.seedDesc);
                    $('#EdtSeedID').val(id);
                    initializeEdt(obj.seedLat, obj.seedLng);
                    $("#parentDivEdt").empty();
                    getSelecteditemsEdt();
                    if (obj.seedCatg != "" && obj.seedCatg != null) {
                        var valCatg = obj.seedCatg.split(',');
                        var ci = 0;
                        for (ci = 0; ci < valCatg.length; ci++) {
                            BindinDivEdt1(valCatg[ci].toString());
                        }
                    }
                }
            });
    }

    $(function () {
        $("#txtEdtSearchLocation").keypress(function (event) {
            if (event.keyCode == '13') {
                Edtgeocode(); return false
            }
        });
    });
</script>
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        $("#catfeildEdt").hide();
    });

    $("#lnk1Edt").live('click', function () {
        $("#addcatEdt").hide();
        $("#catfeildEdt").show();
    });

    $("#lnk2Edt").live('click', function () {
        $("#catfeildEdt").hide();
        $("#addcatEdt").show();
    });
</script>
<style type="text/css">
    #txtEdtSeedTitle
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
    
    #txtEdtDesc
    {
        width: 300px;
        height: 149px !important;
        background-image: url("../../Content/images/gfeedec_input.png") !important;
        background-repeat: no-repeat !important;
        border: 0px;
        margin-left: 22px;
        padding-top: 5px !important;
        line-height: 18px !important;
    }
    #EditMySeedWindow .t-window-content
    {
        display: block;
        height: 605px!important;
        overflow: auto;
        width: 950px !important;
    }

    input[type="text"]
    {
        width: 200px;
        float: left;
    }
</style>
<% Html.Telerik().PanelBar()
           .Name("EditSeedPanel")
            .ExpandMode(PanelBarExpandMode.Single)
            .Items(parent =>
            {
                parent.Add()
                    .Text(" ")
                    .Content(() =>
                    { %>
<%using (Html.BeginForm("EditSeedInfo", "Seed", FormMethod.Post, new { enctype = "multipart/form-data", id = "editSeedForm" }))
  { %>
<table class="plantboxfrm" border="0" style="width: 97%">
    <tr>
        <td colspan="3" class="heading">
            Edit Seed
        </td>
    </tr>
    <tr>
        <td colspan="3" valign="top">
            <span id="resultEdt" style="color: Red">
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
        <td valign="top" style="width: 200px;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><input type="text" id="txtEdtSeedTitle" name="txtEdtSeedTitle" class="waterMark watermarkOn"
                maxlength="40" /></td>
          </tr>
          <tr>
            <td><textarea id="txtEdtDesc" name="txtEdtDesc" class="waterMark watermarkOn" rows="4"
                cols="30"></textarea></td>
          </tr>
        </table></td>
        <td style="width: 60px" rowspan="2" align="center" class="divider">
        </td>
        <td valign="top" align="left">            
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <table width="100%" border="0" class="plantdetailbox" cellspacing="0" cellpadding="0">
                            <tr>
                                <th style="width: 150px; vertical-align: top">
                                    Location
                                </th>
                                <td>
                                    <div class="addloc">
                                        <a id="setLocationAnchorEdt" onclick="ExpandItemEdt(1)">add</a></div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div>
                                        <span id="spanLocationEdt"></span>
                                        <%: Html.Hidden("seedLocationEdt")%>
                                        <%: Html.Hidden("seedCoordinatesEdt")%>
                                        <%: Html.Hidden("EdtSeedID")%>
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
                    	<td colspan="2" style="border-top: 1px solid #CCC;"></td>
                    </tr>
                    <tr>
                    	<td colspan="2">&nbsp;</td>
                    </tr>
                            <tr>
                                <td style="border-right: solid 1px #CCC; vertical-align: top; width: 45%">
                                    <table border="0" class="plantdetailbox" cellpadding="0" cellspacing="0" width="100%">
                                        <tr align="left">
                                            <th>
                                                Media
                                            </th>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" style="padding-bottom: 0px; padding-left: 0px;">
                                                <div class="fileinputs" style="cursor: pointer">
                                                    <input type="file" class="multi" id="mediaFilesEdt" name="mediaFilesEdt" maxlength="5"
                                                        size="1" style="cursor: pointer" accept="jpg|png|gif|mp4|swf|mpg|flv|mov" />
                                                    <div class="fakefile">
                                                        <a style="cursor: pointer">add</a></div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="vertical-align:top">
                                    <table border="0" class="plantdetailbox" cellpadding="0" cellspacing="0" width="95%">
                                        <tr>
                                            <th align="left" style="padding-left: 20px;">
                                                Category
                                            </th>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <div class="scrollcat">
                                                    <div id="parentDivEdt">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" style="padding-left: 20px;">
                                                <div class="categoryadd" id="catfeildEdt">
                                                        <%
                                           SeedSpeak.BLL.CategoryAction objCategory = new SeedSpeak.BLL.CategoryAction();
                                           IList<SeedSpeak.Model.Category> lstCategory = objCategory.GetAllCategories();
                                           SelectList lstCatsEdt = new SelectList(lstCategory, "id", "name");
       %>
       <div style="width:175px;float:left;">
       <%: Html.DropDownList("CategoryAutoCompleteEdt", lstCatsEdt)%></div>
                                                    <input type="button" value="Add" onclick="BindinDivEdt();" class="btnaddcat" id="lnk2Edt" />
                                                    <input type="text" id="txtCategoryEdt" name="txtCategoryEdt" style="display: none;" />
                                                    <input type="text" id="cityIdEdt" style="display: none;" />
                                                </div>
                                                <div id="addcatEdt" class="addloc">
                                                    <a id="lnk1Edt">add</a></div>
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
        <td></td>
        <td style="float:right; padding-top:15px;" align="right">
            <input type="button" value="Discard" class="btndis" onclick="window.location = '../../Member/Default';" />
            <input type="submit" value="Plant" class="editbtn" onclick="javascript:return validateInputEdt();" />
        </td>
    </tr>
    </table>
<% } %>
<% })
                    .Expanded(true);
                parent.Add()

                       .Content(() =>
                       {%>
<div id="mapEdt" style="margin: 6px  auto; width: 90%; border: 0px solid #000;">
    <div class="frmadd">
        <input type="text" id="txtEdtSearchLocation" class="waterMark" title="Enter address where you want to plant..." /><input
            type="button" value="GO" onclick="javascript:Edtgeocode();" class="plantgo" />
    </div>
    <div class="clear">
    </div>
    <div id="map_canvas_edt" style="width: 100%; height: 400px; border: 1px solid #000">
    </div>
</div>
<div id="infoPanelEdt" style="display: none">
    <input type="hidden" id="initLocationEdt" />
    <input type="hidden" id="initCoordinatesEdt" />
    <b>Marker status:</b>
    <div id="markerStatusEdt">
        <i>Click and drag the marker.</i></div>
    <b>Current position:</b>
    <div id="infoEdt">
    </div>
    <b>Closest matching address:</b>
    <div id="addressEdt">
    </div>
</div>
<div class="mapbtncontent">
    <input type="button" value="Cancel" onclick="ExpandItemEdt(0)" class="btncan" /><input
        type="button" value="Set Location" onclick="javascript:setLocationEdt();" class="btnsetloc" />
</div>
<%});
            })
            .Render();
%>
<div class="clear">
</div>
<div>
    <% Html.Telerik().Window()
           .Name("progressWindowEdt")
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
           .Width(300)
           .Height(100)
           .Render();
    %>
</div>
