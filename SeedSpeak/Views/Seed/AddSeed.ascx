<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<SeedSpeak.Model.Validation.AddSeed>" %>
<script src="../../Scripts/jquery.autocomplete.min.js" type="text/javascript"></script>
<script type="text/javascript">
    function getIds(id) {
        var txtLatLong = document.getElementById("LongLat");
        var txtAddress = document.getElementById("StreetAddress");
        var txtCity = document.getElementById("City");

        if (txtLatLong.value == '0.0,0.0') {
            txtLatLong.value = "";
            txtAddress.value = "";
            txtCity.value = "";
            txtAddress.focus();
        }

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

    function calculateCoordinatesA(id) {
        var txtAddress = document.getElementById("StreetAddress");
        var txtCity = document.getElementById("City");
        var txtPostcode = document.getElementById("ZipCode");
        var txtStateCode = document.getElementById("StateCode");
        var ddlState = document.getElementById("State");
        var txtLatLong = document.getElementById("LongLat");
        var txtSeedTitle = document.getElementById("SeedName");
        var txtDescription = document.getElementById("Description");

        if (txtSeedTitle.value != "" && txtAddress.value != "" && txtCity.value != "" && ddlState.value != "" && txtDescription.value != "") {
            // for getting ids
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
            ////////////////////////////

            var address = txtAddress.value + ', ';
            address += txtCity.value + ', ';
            address += txtPostcode.value + ', ';
            address += ddlState.options[ddlState.selectedIndex].text + ', ';
            address += 'USA';

            var geocoder;
            geocoder = new GClientGeocoder();
            geocoder.getLocations(address, function (response) {
                if (response) {
                    if (!response || response.Status.code != 200) {
                        txtLatLong.value = '0.0,0.0';
                        txtLatLong.value = "";
                        txtAddress.focus();
                        $('#AddSeedForm').submit();
                    }
                    else {
                        place = response.Placemark[0];
                        txtStateCode.value = ddlState.options[ddlState.selectedIndex].text;
                        address = place.address;
                        if (place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea == undefined) {
                            txtLatLong.value = '0.0,0.0';
                            txtLatLong.value = "";
                            txtAddress.focus();
                            $('#AddSeedForm').submit();
                        }
                        txtPostcode.value = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.PostalCode.PostalCodeNumber;
                        txtLatLong.value = place.Point.coordinates[1] + ',' + place.Point.coordinates[0];
                        $('#AddSeedForm').submit();
                    }
                }
            });
            return false;
        }
        else {
            return true;
        }
    }

    $(document).ready(function () {
        //Adding autocomplete to Tag input
        $("#Tag").autocomplete('<%: Url.Action("Tags", "Member") %>', {
            minChars: 0,
            //Don't fill the input while still selecting a value
            autoFill: false,
            //Only suggested values are valid
            mustMatch: false,
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
                $("#cityId").val(data[0]);
            else
                $("#cityId").val('-1')
        });
    });

</script>
<script type="text/javascript">
    $(document).ready(function () {
        $("#AddSeedForm").validate({
            errorLabelContainer: $("ul", $('div.error-container')),
            wrapper: 'li',
            rules: {
                SeedName: {
                    required: true
                },
                Description: {
                    required: true
                },
                StreetAddress: {
                    required: true
                },
                City: {
                    required: true
                },
                State: {
                    required: true
                },
                Country: {
                    required: true
                },
                LongLat: {
                    required: true
                }

            },
            messages: {
                SeedName: {
                    required: " Please specify Seed Name"
                },
                Description: {
                    required: " Please specify Description"
                },
                StreetAddress: {
                    required: " Please specify Address"
                },
                City: {
                    required: " Please specify a City"
                },
                State: {
                    required: " Please specify State"
                },
                Country: {
                    required: " Please specify Country"
                },
                LongLat: {
                    required: "Address seems invalid, Please enter proper address"
                }
            }
        });
    });
</script>
<script type="text/javascript">
    function toggle5(showHideDiv, switchImgTag) {
        var ele = document.getElementById(showHideDiv);
        var imageEle = document.getElementById(switchImgTag);
        if (ele.style.display == "block") {
            ele.style.display = "none";
            imageEle.innerHTML = '<img src="../../Content/images/plus.gif" />';
        }
        else {
            ele.style.display = "block";
            imageEle.innerHTML = '<img src="../../Content/images/minus.gif">';
        }
    }
</script>
<% using (Html.BeginForm("SetCategory", "Seed", FormMethod.Post, new { id = "AddSeedForm",style="width:250px;border:0px solid #000" }))
   {%>
<fieldset><div class="error-container" style="width:250px;">
           <ul>
           </ul>
       </div>
<div class="clear">
</div>  <div class="error">
<%: ViewData["SeedPlant"] %> </div>
<div class="clear">
</div>
    <label>
        Seed Name
        <%: Html.TextBoxFor(model => model.SeedName, new { maxlength = 40,style = "width:100%;"   })%>
        <ins>(Max 40 Characters)</ins>
    </label>
    <div class="clear">
    </div>
    <label>
        Street Address
        <%: Html.TextBoxFor(model => model.StreetAddress, new { maxlength = 100, style = "width:100%;" })%>
    </label>
    <div class="clear">
    </div>
    <label >
        State
         <br class="clear" />
        <%: Html.DropDownList("State", (SelectList)ViewData["RegionList"],"Select", new { style = "width:96%;" })%>
    </label>
    <div class="clear">
    </div>
    <label class="min" style="margin-right:10px;">
        City
        <%: Html.TextBoxFor(model => model.City, new { maxlength = 100, style = "width:90%;" })%>
    </label>
    
    <label class="min" >
        Zip Code
        <%: Html.TextBoxFor(model => model.ZipCode, new { maxlength =10,style = "width:90%;"})%>        
        <%: Html.Hidden("LongLat","0.0,0.0")%>
    </label>
    <div class="clear">
    </div>
    <label>
        Brief Description
        <%: Html.TextAreaFor(model => model.Description, new { maxlength =1000,style="width:100%;height:70px"})%>
    </label>
    <div class="clear">
    </div>
    <label>
        Add Keywords<br />
        <%: Html.TextBoxFor(model => model.Tag, new { maxlength = 40, style = "width:100%;" })%>
    </label>
    <%: Html.Hidden("cityId", -1) %>
    <%: Html.Hidden("StateCode") %>
    <div class="clear">
    </div>
    <div id="headerDivImg">
        <div id="titleTextImg">
            Select Category
        </div>
        <a id="imageDivLink" href="javascript:toggle5('contentDivImg', 'imageDivLink');">
            <img src="../../Content/images/plus.gif" alt="click "></a>
    </div>
    <div id="contentDivImg" style="display: none; padding-top: 10px;">
        <input type="hidden" id="categoryIds" name="categoryIds" />
        <%  if (ViewData["categoryId"] != null)
            {
                foreach (SeedSpeak.Model.Category c in ViewData["categoryId"] as List<SeedSpeak.Model.Category>)
                {%>
        <input type="checkbox" id="<%= c.id %>" name="category" value='"<%= c.id %>"' /><%= c.name%>
        <br />
        <% }
                } %>
    </div>
    <div class="clear">
    </div>
    <br />
    <br />
    <div class="btncontainer">
        <input type="submit" value="Plant Seed" onclick="javascript:return calculateCoordinatesA('<%= ViewData["ids"] %>');"
            class="gbtn" />
    </div>
</fieldset>
<% } %>
