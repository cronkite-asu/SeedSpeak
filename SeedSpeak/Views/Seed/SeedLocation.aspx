<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    SeedLocation
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
<style type="text/css" media="screen">        
        #spacer
        {
            width: 10px;
        }
        #mapWrapperCanvas
        {
            width: 100%;
            height: 650px;
        }
        #mapCanvas
        {
            border: 1px solid #979797;
            height: 600px;
            width: 100%;
        }
        #resultsCanvas
        {
            position: relative;
            top: 15px;
            left: 0px;
            height: 348px;
            width: 280px;
        }
        #mapSearch
        { 
            position: relative;
            top: 0px;
            left: 0px;
        }
        .mapcanvastable td
        {
            padding: 0px; 
        }
        .mapcanvastable
        {
            border-width: 0px;
            border-spacing: 0px;
            border-collapse: collapse;
            border: none;
            padding: 0px; 
        }
        
        /* canvas view css over-rides */
        #mapCanvas .gels
        {
            width: 280px;
            background-color: #ddeeff;
        }
        #mapCanvas .gels-form
        {
            background-color: #ddeeff; padding-bottom:10px;
        }
        
        #mapWrapperCanvas .gels-controls
        {
            position: absolute;padding-top:10px;
            bottom: -2px;
            left: 0px;
        }
        #mapWrapperCanvas .gels-app, #mapWrapperCanvas .gels-extresults-active
        {
            border: none;
        }
        #mapWrapperCanvas .gels-list-item
        {
            margin-bottom: 2px;
        }
        #mapWrapperCanvas .gels-list-wrapper
        {
            padding-left: 0px;
        }
     
    </style>    
        <script src="http://www.google.com/jsapi?key=<%= System.Configuration.ConfigurationManager.AppSettings["GoogleKey"].ToString()%>" type="text/javascript"></script>
    <script type="text/javascript">
        google.load("maps", "2");
        google.load("elements", "1", {
            packages: ["localsearch"]
        });

        function updateMarkerPosition(latLng) {
            document.getElementById('InfoLatLong').value = [latLng.lat(), latLng.lng()].join(', ');
        }

        function updateMarkerAddress(str) {
            document.getElementById('seedLocation').value = str;
        }

        function initialize() {
            var initLat = document.getElementById('LocLat').value;
            var initLong = document.getElementById('LocLong').value;
            var mapCanvas = document.getElementById("mapCanvas");
            var resultsCanvas = document.getElementById("resultsCanvas");

            var map2 = new google.maps.Map2(mapCanvas);
            
            map2.addControl(new google.maps.MenuMapTypeControl());

            
            var customUI = map2.getDefaultUI();
            customUI.controls.scalecontrol = false;
            map2.setUI(customUI);
            map2.addControl(new GLargeMapControl3D());

            map2.setCenter(new google.maps.LatLng(initLat, initLong), 14);

            // Set where the results will appear
            options = new Object();
            options.resultList = resultsCanvas;
            options.resultFormat = "multi-line1";
            var lsc2 = new google.elements.LocalSearch(options);
            map2.addControl(lsc2, new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(-282, -2)));

            var lat = map2.getCenter().lat();
            var lng = map2.getCenter().lng();

            var center = new GLatLng(lat, lng);

            var baseIcon = new GIcon(G_DEFAULT_ICON);
            baseIcon.iconSize = new GSize(24, 24);
            var letteredIcon = new GIcon(baseIcon);
            letteredIcon.image = "../../Content/images/imgseed.png";

            // Set up our GMarkerOptions object
            markerOptions = { icon: letteredIcon, draggable: true };
            var marker = new GMarker(center, markerOptions);

            // Update current position info.
            updateMarkerPosition(center);            

            marker.openInfoWindowHtml("<small>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.</small>");

            GEvent.addListener(marker, "dragstart", function () {
                map2.closeInfoWindow();
                updateMarkerAddress('Retrieving Address...');
            });

            GEvent.addListener(marker, "dragend", function () {                
                updateMarkerPosition(marker.getPoint());

                //Determine Address                
                var geocoder = new GClientGeocoder();
                var address = new GLatLng(marker.getPoint().lat(), marker.getPoint().lng());
                geocoder.getLocations(address, function (point) {
                    if (point) {
                        document.getElementById('seedLocation').value = point.Placemark[0].address;
                        marker.openInfoWindowHtml('<small>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.<br/><hr/><b>' + point.Placemark[0].address + '</b></small>');
                    } else {
                        document.getElementById('seedLocation').value = "Can not determine address at this location";
                    }
                });
                //End Address
            });

            //moveend, dblclick
            GEvent.addListener(map2, "moveend", function () {
                map2.removeOverlay(marker);
                center = new GLatLng(map2.getCenter().lat(), map2.getCenter().lng());
                marker = new GMarker(center, markerOptions);
                map2.addOverlay(marker);

                updateMarkerPosition(center);

                var geocoder = new GClientGeocoder();
                var address = new GLatLng(map2.getCenter().lat(), map2.getCenter().lng());
                geocoder.getLocations(address, function (point) {
                    if (point) {
                        document.getElementById('seedLocation').value = point.Placemark[0].address;
                        marker.openInfoWindowHtml('<small>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.<br/><hr/><b>' + point.Placemark[0].address + '</b></small>');
                    } else {
                        document.getElementById('seedLocation').value = "Can not determine address at this location";
                    }
                });

                /////////////////////
                GEvent.addListener(marker, "dragstart", function () {
                    map2.closeInfoWindow();
                    updateMarkerAddress('Retrieving Address...');
                });

                GEvent.addListener(marker, "dragend", function () {
                    updateMarkerPosition(marker.getPoint());

                    var geocoder = new GClientGeocoder();
                    var address = new GLatLng(marker.getPoint().lat(), marker.getPoint().lng());
                    geocoder.getLocations(address, function (point) {
                        if (point) {
                            document.getElementById('seedLocation').value = point.Placemark[0].address;
                            marker.openInfoWindowHtml('<small>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.<br/><hr/><b>' + point.Placemark[0].address + '</b></small>');
                        } else {
                            document.getElementById('seedLocation').value = "Can not determine address at this location";
                        }
                    });
                });                
                /////////////////////////
            }); 

            map2.addOverlay(marker);

            var geocoder = new GClientGeocoder();
            var address = new GLatLng(lat, lng);
            geocoder.getLocations(address, function (point) {
                if (point) {
                    document.getElementById('seedLocation').value = point.Placemark[0].address;
                } else {
                    document.getElementById('seedLocation').value = "Can not determine address at this location";
                }
            });
        }
        google.setOnLoadCallback(initialize);
    </script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% using (Html.BeginForm("SeedLocation", "Seed", FormMethod.Post, new { id = "seedLocationForm" }))
       {%>
    <div id="mapWrapperCanvas">
        <table class="mapcanvastable" style="width: 100%;">
            <tr>
                <td style="width: 280px" align="left">
                    <div id="mapSearch">
                    </div>
                    <div id="resultsCanvas">
                    </div>
                </td>
                <td>
                    <div id="mapCanvas">
                    </div>
                </td>
            </tr>
        <tr><td colspan="2" align="right" >
        <table border="0" >
            <tr style="display:none;">
                <td>
                    Latitude Longitude :<br />
                    <%: Html.TextBox("InfoLatLong", "", new { style = "width:300px;height:25px;" })%>
                </td>
                <td>
                    Address :
                    <br />
                    <%: Html.TextBox("seedLocation", "", new { style = "width:300px;height:25px;" })%>
                </td>
            </tr>
            <tr>
                <td >
                    <input type="button" value="Go Back" class="gbtntrans" onclick="window.location = '/Member/Dashboard/';"  />
                    <input type="submit" value="Plant Seed" class="gbtntrans" />
                </td>
            </tr>
        </table></td></tr> </table>
    </div>
    <% } %>
    <%: Html.Hidden("LocLat", ViewData["LocationLat"])%>
    <%: Html.Hidden("LocLong", ViewData["LocationLong"])%>
 
</asp:Content>
