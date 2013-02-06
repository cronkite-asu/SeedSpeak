<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script src="../../Scripts/jquery.autocomplete.min.js" type="text/javascript"></script>
<script type="text/javascript">
    var streamMiniMap;
    var streamgeocoder;
    var centerChangedLast;
    var reverseGeocodedLast;
    var currentReverseGeocodeResponse;
    var streamgeocoder = new google.maps.Geocoder();

    function geocodePositionMini(pos) {
        streamgeocoder.geocode({
            latLng: pos
        }, function (responses) {
            if (responses && responses.length > 0) {
                updateMarkerAddressStreamMini(responses[0].formatted_address);
            } else {
                updateMarkerAddressStreamMini('Cannot determine address at this location.');
            }
        });
    }

    function updateMarkerStatusStreamMini(str) {
        document.getElementById('markerStatusStreamMini').innerHTML = str;
    }

    function updateMarkerPositionStreamMini(latLng) {
        document.getElementById('infoStreamMini').innerHTML = [latLng.lat(), latLng.lng()].join(', ');
        document.getElementById('initCoordinatesStreamMini').value = [latLng.lat(), latLng.lng()].join(', ');
    }

    function updateMarkerAddressStreamMini(str) {
        document.getElementById('addressStreamMini').innerHTML = str;
        document.getElementById('initLocationStreamMini').value = str;
    }

    function initializeStreamMini(lt, lg) {
        if (lt != null && lg != null) {
            var latlngMini = new google.maps.LatLng(lt, lg);
        }
        else {
            var latlngMini = new google.maps.LatLng(33.283217832401455, -111.84057782734374);
        }

        var myOptions = {
            zoom: 10,
            center: latlngMini,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        streamMiniMap = new google.maps.Map(document.getElementById("map_canvas_stream_mini"), myOptions);

        var markerMini = new google.maps.Marker({
            position: latlngMini,
            icon: new google.maps.MarkerImage("../../Content/images/seedLocPointer.png"),
            map: streamMiniMap,
            draggable: true
        });
        streamgeocoder = new google.maps.Geocoder();

        // Update current position info.
        updateMarkerPositionStreamMini(latlngMini);
        geocodePositionMini(latlngMini);

        var contentStringMini = "<div style='font-size:11px;'>Drag the SeedSpeak icon to a<br/> place nearby. Or, use the search <br/>panel to plant the seed elsewhere.</div>";
        var infowindowMini = new google.maps.InfoWindow({
            content: contentStringMini
        });
        infowindowMini.open(streamMiniMap, markerMini);

        // Add dragging event listeners.
        google.maps.event.addListener(markerMini, 'dragstart', function () {
            updateMarkerAddressStreamMini('Dragging...');
            infowindowMini.close(streamMiniMap, markerMini);
        });

        google.maps.event.addListener(markerMini, 'drag', function () {
            updateMarkerStatusStreamMini('Dragging...');
            updateMarkerPositionStreamMini(markerMini.getPosition());
        });

        google.maps.event.addListener(markerMini, 'dragend', function () {
            updateMarkerStatusStreamMini('Drag ended');
            geocodePositionMini(markerMini.getPosition());
            infowindowMini.open(streamMiniMap, markerMini);
        });
    }

    function geocodeMini() {
        var addressMini = document.getElementById("txtMiniStreamLocation").value;
        streamgeocoder.geocode(
        {
            'address': addressMini,
            'partialmatch': true
        },
        geocodeResultMini);
    }

    function geocodeResultMini(results, status) {
        if (status == 'OK' && results.length > 0) {
            streamMiniMap.fitBounds(results[0].geometry.viewport);
        }
        else {
            alert("Geocode was not successful for the following reason: " + status);
        }
        //ReAssigning Lat Long on Search
        var refLatLng1 = streamMiniMap.getCenter().toString();
        refLatLng1 = refLatLng1.replace('(', "");
        refLatLng1 = refLatLng1.replace(')', "");
        var centerLatLng1 = refLatLng1.split(',');
        initializeStreamMini(centerLatLng1[0].toString(), centerLatLng1[1].toString());
        //ReAssigning Lat Long on Search
    }
    google.maps.event.addDomListener(window, 'load', initializeStreamMini);

    function setLocationMini() {
        document.getElementById('seedCoordinatesStreamMini').value = document.getElementById('initCoordinatesStreamMini').value;
        var initStrMini = document.getElementById('initLocationStreamMini').value;
        var splitStrMini = initStrMini.split(',');
        var finalStrMini;
        for (i = 0; i < splitStrMini.length; i++) {
            if (i == 0)
                finalStrMini = splitStrMini[i].toString();
            else
                finalStrMini = finalStrMini + ",<br/>" + splitStrMini[i].toString();
        }
        document.getElementById('spanLocationStreamMini').innerHTML = finalStrMini;
        document.getElementById('seedLocationStreamMini').value = initStrMini;
        document.getElementById('setLocationAnchorMini').innerHTML = "change associated location";
        ExpandItemMini(0);
    }

    $(function () {
        $("#txtMiniStreamLocation").keypress(function (event) {
            if (event.keyCode == '13') {
                geocodeMini(); return false
            }
        });
    });

    function ExpandItemMini(itemIndex) {
        var panelBar = $("#StreamMiniPanel").data("tPanelBar");
        var item = $("> li", panelBar.element)[itemIndex];
        panelBar.expand(item);
        if (itemIndex == '1') {
            //google.maps.event.trigger(streamMiniMap, 'resize');
            var gcenter = streamMiniMap.getCenter();
            google.maps.event.trigger(streamMiniMap, 'resize');
            streamMiniMap.setCenter(gcenter);
        }
    }

    function streamMinivalidateInput() {
        var title1 = document.getElementById('gTitle').value;
        var desc1 = document.getElementById('gDesc').value;
        var seedLoc1 = document.getElementById('seedLocationStreamMini').value;
        var msg1 = document.getElementById('resultMini');
        if (title1 == "" || title1 == "Give your feed a title") {
            msg1.innerHTML = "Title can not be left blank";
            return false;
        }
    }

    function closeOnSuccess() {
        var resultCheck = document.getElementById('resultMini').innerHTML;
        if (resultCheck == "Feed created successfully.") {
            var wC = $('#CreateStreamMiniWindow').data('tWindow');
            wC.center().close();
        }
    }

    function CloseFeedList() {
        var wC = $('#CreateStreamMiniWindow').data('tWindow');
        wC.center().close();
    }
</script>

<script type="text/javascript" language="javascript">
    function BindinDivStreamMini() {
        if (document.getElementById('CategoryAutoCompleteStreamMini').value != "" && document.getElementById('CategoryAutoCompleteStreamMini').value != "Start typing here") {
            if (document.getElementById('txtCategoryStreamMini').value == null || document.getElementById('txtCategoryStreamMini').value == "") {
                //adding value in textbox
                document.getElementById('txtCategoryStreamMini').value = document.getElementById('CategoryAutoCompleteStreamMini').value;
            }
            else {
                //adding value in textbox
                document.getElementById('txtCategoryStreamMini').value = document.getElementById('txtCategoryStreamMini').value + "," + document.getElementById('CategoryAutoCompleteStreamMini').value;
            }

            if (document.getElementById(document.getElementById('CategoryAutoCompleteStreamMini').value + 'StreamMini') == null) {
                var LDivObj = document.getElementById('parentDivStreamMini');

                //creating div with cros button
                var divTag = document.createElement("div");
                divTag.id = document.getElementById('CategoryAutoCompleteStreamMini').value + 'StreamMini';

                divTag.onmouseover = function () { mouseOverDivStreamMini(divTag.id); };
                divTag.onmouseout = function () { mouseOutDivStreamMini(divTag.id); };
                var ss = "<img id='img" + document.getElementById('CategoryAutoCompleteStreamMini').value + 'StreamMini' + "' title='Delete this Category' alt='' src='../../Content/images/delupimg1.png' style='height: 18px; width: 18px;visibility:hidden;float:right'/>";

                divTag.innerHTML = "<span>" + document.getElementById('CategoryAutoCompleteStreamMini').value + ss + ",</span>";
                LDivObj.appendChild(divTag);
                var imgBTN = document.getElementById("img" + document.getElementById('CategoryAutoCompleteStreamMini').value + 'StreamMini');
                imgBTN.onclick = function () { deletedivStreamMini(divTag.id); };
            }
            else {
                alert("already selected");
            }
            document.getElementById('CategoryAutoCompleteStreamMini').value = null;
            document.getElementById('lnk1StreamMini').innerHTML = "add more category";
        }
    }

    function deletedivStreamMini(abc) {
        var child = document.getElementById(abc);
        var parent = document.getElementById('parentDivStreamMini');
        parent.removeChild(child);
        getSelecteditemsStreamMini();
    }

    function mouseOverDivStreamMini(imgId) {
        document.getElementById('img' + imgId).style.visibility = "visible";
    }

    function mouseOutDivStreamMini(imgId) {
        document.getElementById('img' + imgId).style.visibility = "hidden";
    }

    function getSelecteditemsStreamMini() {
        var divElem = document.getElementById("parentDivStreamMini");
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
            document.getElementById('lnk1StreamMini').innerHTML = "add a category";

        document.getElementById('txtCategoryStreamMini').value = FianlString;
    }

    $(document).ready(function () {
        //Adding autocomplete to Tag input
        $("#CategoryAutoCompleteStreamMini").autocomplete('<%: Url.Action("Category", "Member") %>', {
            minChars: 0,
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
                $("#cityIdStreamMini").val(data[0]);
            else
                $("#cityIdStreamMini").val('-1')
        });
    });

    $(document).ready(function () {
        $("#catfeildStreamMini").hide();
    });

    $("#lnk1StreamMini").live('click', function () {
        $("#addcatStreamMini").hide();
        $("#catfeildStreamMini").show();
    });

    $("#lnk2StreamMini").live('click', function () {
        $("#catfeildStreamMini").hide();
        $("#addcatStreamMini").show();
    });
</script>
<div>
    <%  Html.Telerik().Window()
            .Name("CreateStreamMiniWindow")
            .Title("Create Stream")
            .Content(() =>
            {%>
    <div class="small_window_wp">
        <div class="small_window_top">
        </div>
        <div class="small_window_mid">
            <% Html.Telerik().PanelBar()
           .Name("StreamMiniPanel")
            .ExpandMode(PanelBarExpandMode.Single)
            .Items(parent =>
            {
                parent.Add()
                    .Text(" ")
                    .Content(() =>
                    { %>
              <%using (Html.BeginForm("AddStream", "SeedStream", FormMethod.Post, new { enctype = "multipart/form-data", id = "ListForm" }))
                {%>
            <table class="plantboxfrm" border="1" width="35%" cellpadding="0" cellspacing="0"
                style="margin-left: 15px;">
                <tr>
                    <td style="height:10px"></td>
                </tr>
                <tr>
                    <td class="heading">Create a Feed</td>
                </tr>
                <%
                  string viewUrl = ((WebFormView)ViewContext.View).ViewPath;
                  string viewFileName = viewUrl.Substring(viewUrl.LastIndexOf('/'));
                  string viewFileNameWithoutExtension = System.IO.Path.GetFileNameWithoutExtension(viewFileName);
                  if (viewFileNameWithoutExtension != "Default")
                  {
                %>                
                <%} %>
                <tr>
                    <th>Settings</th>
                </tr>
                <tr>
                    <td style="padding-left:25px" colspan="3">
                        <div id="updatingMini" style="display: none">
                            <img src="../../Content/images/ajaxloader.gif" alt="Please wait..." />
                            <br />
                            <span style="color: Red;"><small>Please wait while we process your request</small></span>
                        </div>
                        <span id="resultMini" style="color: Red">
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
                    <td>
                        <input type="text" id="gTitle" name="gTitle" class="waterMark" title="Give your feed a title" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <textarea id="gDesc" name="gDesc" class="waterMark" title="Give your feed a description (Optional)"
                            rows="3" cols="30"></textarea>
                    </td>
                </tr>
                <tr>
                    <th>Location</th>
                </tr>
                <tr>
                    <td>
                        <div style="padding-left:25px">
                            <span id="spanLocationStreamMini"></span>
                            <%: Html.Hidden("seedLocationStreamMini") %>
                            <%: Html.Hidden("seedCoordinatesStreamMini") %>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left:25px">
                        <div  class="addloc">
                            <a id="setLocationAnchorMini" onclick="ExpandItemMini(1)">
                                <div>
                                    associate this feed with a location</div>
                            </a>
                        </div>
                    </td>
                </tr>
                <tr><td style="height:8px"></td></tr>
                <tr>
                    <th style="border-top: 1px dashed #000; padding-top: 10px;">Category</th>
                </tr>
                <tr>
                    <td valign="top">
                        <div class="scrollcat">
                            <div id="parentDivStreamMini">
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <div class="categoryadd" id="catfeildStreamMini">
                            <input type="text" id="CategoryAutoCompleteStreamMini" name="CategoryAutoCompleteStreamMini"
                                style="width: 150px; float: left; margin-left: 20px" class="waterMark" title="Start typing here" />
                            <input type="button" value="Add" onclick="BindinDivStreamMini();" class="btnaddcat"
                                id="lnk2StreamMini" />
                            <input type="text" id="txtCategoryStreamMini" name="txtCategoryStreamMini" style="display: none;" />
                            <input type="text" id="cityIdStreamMini" style="display: none;" />
                        </div>
                        <div  style="padding-left:25px!important" id="addcatStreamMini" class="addloc">
                            <a id="lnk1StreamMini">
                                <div>
                                    add a category</div>
                            </a>
                        </div>
                    </td>
                </tr>
                <tr><td style="height:8px"></td></tr>
                <tr>
                    <td style="border-top: 1px dashed #000; padding-top: 10px; padding-left: 19px;">
                        <input type="radio" value="true" id="rdoPublic" name="gIsPublic" checked="checked"
                            title="Public" />
                        Public<br />
                        <input type="radio" value="false" id="rdoPrivate" name="gIsPublic" title="Private" />
                        Private
                        <%if (viewFileNameWithoutExtension == "Default")
                          { %>
                        <%: Html.Hidden("streamType", SeedSpeak.Util.SystemStatements.STREAM_FEED)%>
                        <%}
                          else if (viewFileNameWithoutExtension == "ListFeeds")
                          { %>
                        <%: Html.Hidden("streamType", SeedSpeak.Util.SystemStatements.STREAM_HANDPICKED)%>
                        <%}
                          else
                          { %>
                        <%: Html.Hidden("streamType", SeedSpeak.Util.SystemStatements.STREAM_HANDPICKED)%>
                        <%} %>
                    </td>
                </tr>
                
                <tr>
                    <td align="right" style="margin-left: 25px;">
                        <input type="submit" value="Create" class="btncreate" onclick="javascript:return streamMinivalidateInput();" />
                        <input type="button" class="btncancel " value="Cancel" onclick="javascript:CloseFeedList();" />
                    </td>
                </tr>
            </table>
            <% } %>
            <% })
                    .Expanded(true);
                parent.Add()

                       .Content(() =>
                       {%>
            <div id="mapStreamMini" style="margin-top: 9px; width: 387px; border: 0px solid #000;">
                <div class="frmadd">
                    <input type="text" id="txtMiniStreamLocation" class="waterMark" title="Enter an address or location..." /><input
                        type="button" value="GO" onclick="javascript:geocodeMini();" class="btnfind" />
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
  <div style="text-align:right; width:240px; height:35px; margin-top:15px; float:right"><input type="button" class="btnucl" value="Use Current Location" onclick="javascript:initializeStreamMini('<%=latSearch %>','<%=lngSearch %>');" /></div>
                </div>
                <div class="clear">
                </div>
                <div id="map_canvas_stream_mini" style="width: 335px; margin-left: 25px; margin-top: 8px;
                    height: 400px; border: 1px solid #000">
                </div>
            </div>
            <div id="infoPanelStreamMini" style="display: none">
                <input type="hidden" id="initLocationStreamMini" />
                <input type="hidden" id="initCoordinatesStreamMini" />
                <b>Marker status:</b>
                <div id="markerStatusStreamMini">
                    <i>Click and drag the marker.</i></div>
                <b>Current position:</b>
                <div id="infoStreamMini">
                </div>
                <b>Closest matching address:</b>
                <div id="addressStreamMini">
                </div>
            </div>
            <div class="mapbtncontent" style="margin-right: 21px; width: 375px;">
                <input type="button" value="Set Location" onclick="javascript:setLocationMini();" class="btnsetloc" />
                <input type="button" value="Cancel" onclick="ExpandItemMini(0)" class="btngoback" />
            </div>
            
            <%});
            })
            .Render();
            %>
        </div>
    <div class="small_window_bottom">
    </div>
</div>
<%})
            .Width(400)
            .Height(700)
            .Modal(true)
            .Visible(false)
            .Render();
%>
</div> 