<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    PlantSeed
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server"> 
<style type="text/css">
        #mapCanvas
        {
            width: 600px;
            height: 600px;
            float: left;
        }
        #infoPanel
        {width: 300px;
            float: left;
            margin-left: 10px;
        }
        #infoPanel div
        {
            margin-bottom: 5px;
        }
    </style> 
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript">
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
            document.getElementById('markerStatus').value = str;
        }

        function updateMarkerPosition(latLng) {
            document.getElementById('info').value = [latLng.lat(), latLng.lng()].join(', ');
        }

        function updateMarkerAddress(str) {
            document.getElementById('address').value = str;
        }

        function initialize() {
            var initLat = document.getElementById('LocLat').value;
            var initLong = document.getElementById('LocLong').value;
            //var latLng = new google.maps.LatLng(33.7013505, -112.0999968);
            var latLng = new google.maps.LatLng(initLat, initLong);
            var map = new google.maps.Map(document.getElementById('mapCanvas'), {
                zoom: 15,
                center: latLng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });
            var marker = new google.maps.Marker({
                position: latLng,
                title: 'Location Pointer',
                map: map,
                draggable: true
            });

            // Update current position info.
            updateMarkerPosition(latLng);
            geocodePosition(latLng);

            // Add dragging event listeners.
            google.maps.event.addListener(marker, 'dragstart', function () {
                updateMarkerAddress('Retrieving Address...');
            });

            google.maps.event.addListener(marker, 'drag', function () {
                updateMarkerStatus('Dragging...');
                updateMarkerPosition(marker.getPosition());
            });

            google.maps.event.addListener(marker, 'dragend', function () {
                updateMarkerStatus('Drag ended');
                geocodePosition(marker.getPosition());
            });

            var infowindow = new google.maps.InfoWindow(
                {
                    content: "Drag the SeedSpeak icon<br/> to a place nearby.<br/> Or, use the search panel<br/> to plant the seed elsewhere."
                });
            infowindow.open(map, marker);
        }

        // Onload handler to fire off the app.
        google.maps.event.addDomListener(window, 'load', initialize);

        function getIds(id) {
            var temp = new Array();
            temp = id.split(',');
            var cId = document.getElementById('categoryIds');
            cId.value == "";
            var i = 0;
            for (i = 0; i < temp.length; i++) {
                var chk = document.getElementById(temp[i]);
                if (chk != null) {
                    if (chk.checked) {
                        if (i == 0) {
                            cId.value = temp[i];
                        }
                        else {
                            cId.value = cId.value + ',' + temp[i];
                        }
                    }
                }
            }
            return true;
        }
</script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#PlantSeedForm").validate({
                errorLabelContainer: $("ul", $('div.error-container')),
                wrapper: 'li',
                rules: {
                    seedTitle: {
                        required: true
                    },
                    description: {
                        required: true
                    },
                    address: {
                        required: true
                    }
                },
                messages: {
                    seedTitle: {
                        required: " Please specify Seed Name"
                    },
                    description: {
                        required: " Please specify Description"
                    },
                    address: {
                        required: " Please specify Address"
                    }
                }
            });
        });
    </script>
   
              <br />
           <div  class="frmcontent"> <div class="frmbody" style="margin:auto"  >  <fieldset style="width: 100%"><legend> Plant Seed</legend>  
    <table width="98%"  style="margin:auto" border="0">
        <tr>
            <td>
                <div class="error-container" >
                    <ul>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td style="height: 100%;">
                <% using (Html.BeginForm("PlantSeed", "Seed", FormMethod.Post, new { id = "PlantSeedForm" }))
                   {%>
                <div id="mapCanvas">
                </div>
                <div id="infoPanel">
                    <b>Seed Name:</b><br />
                    <%: Html.TextBox("seedTitle", "", new { maxlength = 40, style = "width:300px;height:25px;" })%>
                    <br />
                    <br />
                    <b>Brief Description:</b><br />
                    <%: Html.TextArea("description", "", new { maxlength = 1000, style = "width:300px;height:50px;" })%>
                    <br />
                    <br />
                    <div style="display:none;">
                        <b>Marker Status:</b>
                        <br />
                        <%: Html.TextBox("markerStatus", "Click and drag the marker", new { style = "width:300px;height:25px;" })%>
                        <br />
                        <br />
                        <b>Current Position:</b>
                        <br />
                        <%: Html.TextBox("info", "", new { style = "width:300px;height:25px;" })%>
                        <br />
                        <br />
                    </div>
                    <b>Closest Matching Address:</b>
                    <br />
                    <%: Html.TextBox("address", "", new { ReadOnly = true, style = "width:300px;height:25px;" })%><br />
                    <em>(Click & drag marker on map to get new location)</em>
                    <br />
                    <br />
                    <b>Add Keyword:</b><br />
                    <%: Html.TextBox("keyword", "", new { maxlength = 40, style = "width:300px;height:25px;" })%>
                    <br />
                    <br />
                    <input type="hidden" id="categoryIds" name="categoryIds" />
                    <b>Select Category:</b><br />
                    <%  if (ViewData["categoryId"] != null)
                        {
                            foreach (SeedSpeak.Model.Category c in ViewData["categoryId"] as List<SeedSpeak.Model.Category>)
                            {%>
                    <input type="checkbox" id="<%= c.id %>" name="category" value='"<%= c.id %>"' /><%= c.name%>
                    <br />
                    <% }
                        } %>
                    <input type="submit" value="Plant Seed" onclick="javascript:return getIds('<%= ViewData["ids"] %>');"
                        class="gbtn" />
                </div>
                <% } %>
                <%: Html.Hidden("LocLat", ViewData["LocationLat"])%>
                <%: Html.Hidden("LocLong", ViewData["LocationLong"])%>
            </td>
        </tr>
    </table></fieldset></div>
                </div> 
</asp:Content>
