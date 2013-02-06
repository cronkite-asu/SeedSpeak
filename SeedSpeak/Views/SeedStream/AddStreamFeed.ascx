<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<style type="text/css">
    div#map
    {
        position: relative;
    }
    #progressWindow
    {
        background-color: Silver;
    }
</style>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script src="../../Scripts/MicrosoftMvcAjax.js" type="text/javascript"></script>
<script src="../../Scripts/jqwatermark.js" type="text/javascript"></script>
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
            //google.maps.event.trigger(ucMap, 'resize');
            var gcenter = ucMap.getCenter();
            google.maps.event.trigger(ucMap, 'resize');
            ucMap.setCenter(gcenter);
        }
    }

    function callProgressWindow() {
        var pgrs = $('#progressWindow').data('tWindow');
        $('.t-window-titlebar').hide();
        pgrs.center().open();
    }

    function validateGardenInput() {
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

    $(function () {
        $("#txtSearchLocation").keypress(function (event) {
            if (event.keyCode == '13') {
                geocode(); return false
            }
        });
    });
</script>
<% Html.Telerik().PanelBar()
           .Name("AddGardenFeed")
            .ExpandMode(PanelBarExpandMode.Single)
            .Items(parent =>
            {
                parent.Add()
                    .Text(" ")
                    .Content(() =>
                    { %>
<%using (Html.BeginForm("AddGarden", "Garden", FormMethod.Post, new { enctype = "multipart/form-data", id = "gardenFeedForm" }))
  { %>
<table class="plantboxfrm" border="0" width="98%">
    <%--In Media and Category Side : class="plantdetailbox"--%>
    <tr>
        <td>
            <div id="updating" style="display: none">                
            </div>
            <span id="result" style="color: Red"></span>
        </td>
    </tr>
    <tr>
        <td>
            Create a new Garden
        </td>
    </tr>
    <tr>
        <td>
            <input type="text" id="gTitle" name="gTitle" maxlength="40" class="waterMark" title="Give your Garden a name" />
        </td>
    </tr>
    <tr>
        <td align="center">
            <textarea id="gDesc" name="gDesc" cols="40" rows="20" class="waterMark" title="Provide a description for your Garden"></textarea>
        </td>
    </tr>
    <tr>
        <th style="border-top: 1px dashed #000; padding-top: 10px;">
            LOCATION
        </th>
    </tr>
    <tr>
        <td>
            <div>
                <span id="spanLocation"></span>
                <%: Html.Hidden("seedLocation") %>
                <%: Html.Hidden("seedCoordinates") %>
            </div>
        </td>
    </tr>
    <tr>
        <td>
            <div class="addloc">
                <a id="setLocationAnchor" onclick="ExpandItem(1)">add</a></div>
        </td>
    </tr>
    <tr>
        <td>
            Is this Garden<br />
            <input type="radio" value="true" id="rdoPublic" name="gIsPublic" checked="checked"
                title="Public" />
            Public
            <input type="radio" value="false" id="rdoPrivate" name="gIsPublic" title="Private" />
            Private
            <%: Html.Hidden("gardenType",SeedSpeak.Util.SystemStatements.GARDEN_FEED) %>
        </td>
    </tr>
    <tr>
        <td align="right">
            <input type="submit" value="Create" class="btnplnt" onclick="javascript:return validateGardenInput();" />
            <input type="button" value="Cancel" class="btndis" onclick="window.location = '../../Member/Default';" />
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
    <div class="frmadd">
        <input type="text" id="txtGardenLocation" class="waterMark" title="Search location for your Garden" /><input
            type="button" value="GO" onclick="javascript:geocode();" class="plantgo" />
    </div>
    <div class="clear">
    </div>
    <div id="map_garden_canvas" style="width: 100%; height: 400px; border: 1px solid #000">
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
<div class="mapbtncontent">
    <input type="button" value="Cancel" onclick="ExpandItem(0)" class="btncan" /><input
        type="button" value="Set Location" onclick="javascript:setLocation();" class="btnsetloc" />
</div>
<%});
            })
            .Render();
%>
<div class="clear">
</div>
<div class="plantboxbtm">
</div>
