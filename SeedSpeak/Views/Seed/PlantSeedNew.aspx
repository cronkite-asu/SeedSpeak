<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Plant Seed New
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" language="javascript">
        function calculateCoordinatesIssue() {
            var txtAddress = document.getElementById("crossStreet");
            var txtCity = document.getElementById("cityName");
            var txtStateCode = document.getElementById("stateCode");
            var ddlState = document.getElementById("State");
            var txtZip = document.getElementById("zipcode");
            var txtLongLat = document.getElementById("LongLat");

            txtStateCode.value = ddlState.options[ddlState.selectedIndex].text;
            if (txtAddress.value != "" && txtCity.value != "" && ddlState.value != "") {
                var address = txtAddress.value + ', ';
                address += txtCity.value + ', ';
                address += ddlState.options[ddlState.selectedIndex].text + ', ';
                address += 'USA';

                var geocoder;
                geocoder = new GClientGeocoder();
                geocoder.getLocations(address, function (response) {
                    if (response) {
                        if (!response || response.Status.code != 200) {
                            txtLongLat.value = "";
                            txtAddress.focus();
                            $('#PlantSeedNewForm').submit();
                        }
                        else {
                            place = response.Placemark[0];
                            txtStateCode.value = ddlState.options[ddlState.selectedIndex].text;
                            address = place.address;
                            if (place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea == undefined) {
                                txtLongLat.value = "";
                                txtAddress.focus();
                                $('#PlantSeedNewForm').submit();
                            }
                            txtZip.value = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.PostalCode.PostalCodeNumber;
                            txtLongLat.value = place.Point.coordinates[1] + ',' + place.Point.coordinates[0];
                            $('#PlantSeedNewForm').submit();
                        }
                    }
                });
                return false;
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#PlantSeedNewForm").validate({
                errorLabelContainer: $("ul", $('div.error-container')),
                wrapper: 'li',
                rules: {
                    LongLat: {
                        required: true
                    },
                    crossStreet: {
                        required: true
                    },
                    cityName: {
                        required: true
                    },
                    State: {
                        required: true
                    }
                },
                messages: {
                    LongLat: {
                        required: "Address seems invalid, Please enter proper address"
                    },
                    crossStreet: {
                        required: "You must specify Street address "
                    },
                    cityName: {
                        required: "You must specify City"
                    },
                    State: {
                        required: "You must select State"
                    }
                }
            });
        });
    </script>
    <div class="frmcontent">
        <div class="frmbody" style="padding-right: 10px;">
            <% using (Html.BeginForm("PlantSeedNew", "Seed", FormMethod.Post, new { id = "PlantSeedNewForm" }))
               {%><br />
            <fieldset style="width: 94%;">
                <legend>Plant Seed</legend>
                <div class="error-container">
                    <ul>
                    </ul>
                </div>
                <div class="clear">
                </div>
                <label>
                    Cross Street:<br />
                    <%: Html.TextBox("crossStreet", "", new { maxlength = 100})%></label>
                <label>
                    City:<br />
                    <%: Html.TextBox("cityName", "", new { maxlength = 40})%></label>
                <label>
                    State:<br />
                    <%: Html.DropDownList("State", (SelectList)ViewData["RegionList"], "Select")%></label>
                <%: Html.Hidden("LongLat","0.0,0.0")%>
                <%: Html.Hidden("zipcode","")%>
                <%: Html.Hidden("stateCode","") %></fieldset>
            <div class="btncontainer">
                <input type="submit" value="Next" class="gbtn" onclick="javascript:return calculateCoordinatesIssue();" /></div>
        </div>
        <% } %>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
</asp:Content>
