<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<SeedSpeak.Model.Validation.AddSeed>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Plant New Seed
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">

        function calculateCoordinates() {

            var txtAddress = document.getElementById("StreetAddress");
            var txtCity = document.getElementById("City");
            var txtPostcode = document.getElementById("ZipCode");
            var txtCountry = document.getElementById("Country");

            var txtLatLong = document.getElementById("LongLat");

            var address = txtAddress.value + ', ';
            address += txtCity.value + ', ';
            address += txtPostcode.value + ', ';
            address += txtCountry.value;

            var geocoder;
            geocoder = new GClientGeocoder();
            geocoder.getLatLng(address, function (latlng) {
                if (latlng) {
                    txtLatLong.value = latlng.lat() + ',' + latlng.lng();
                }
                else {
                    txtLatLong.value = '';
                }
            });
        }

        $(document).ready(function () {
            $("#ZipCode").change(function () {
                calculateCoordinates();
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
                    ZipCode: {
                        required: true,
                        digits: true
                    },
                    Country: {
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
                    ZipCode: {
                        required: " Please specify Zipcode",
                        digits: " Please insert digits in Zipcode"
                    },
                    Country: {
                        required: " Please specify Country"
                    }
                }
            });
        });
    </script> <script type="text/javascript">
                  $(function () {
                      //find all form with class jqtransform and apply the plugin
                      $("form.jqtransform").jqTransform();
                  });
    </script>
 
      <div class="frmcontent">
    <% using (Html.BeginForm("AddSeed", "Seed", FormMethod.Post, new { id = "AddSeedForm",@class="jqtransform" }))
       {%><div class="error-container">
        <ul>
        </ul>
    </div> <div class="clear"></div> 
    <%: Html.ValidationSummary(true) %> <div class="clear"></div> 
     <fieldset  >
        <legend>AddSeed</legend>
        <label >
            Seed Name
            <%: Html.TextBoxFor(model => model.SeedName, new { maxlength=200 })%>
        </label> <div class="clear"></div> 
        <label class="wide">
            Brief Description
            <%: Html.TextAreaFor(model => model.Description, new { maxlength =1000})%>
        </label> <div class="clear"></div> 
       <label class="wide">
            Street Address
            <%: Html.TextAreaFor(model => model.StreetAddress, new { maxlength =100})%>
        </label> <div class="clear"></div> 
        <label class="wide">
            City
            <%: Html.TextBoxFor(model => model.City, new { maxlength =100})%>
        </label>
        <label class="small">
            Zip Code
            <%: Html.TextBoxFor(model => model.ZipCode, new { maxlength =10})%>
            <%: Html.HiddenFor(model => model.LongLat)  %>
        </label> <div class="clear"></div> 
        <label class="medium">
            Country
            <%: Html.TextBoxFor(model => model.Country, new { maxlength =50})%>
        </label> <div class="clear"></div> 
        
        <label class="medium">
            Tag
            <%: Html.TextBoxFor(model => model.Tag, new { maxlength =50})%>
        </label> 
     <div class="clear"></div> 
            <div class="btncontainer">
            <input type="submit" value="Plant Seed" class="gbtn"/>
         <input type="button" value="Cancel" class="grbtn"  onclick="window.location = '/Member/Dashboard';" /></div>
     </fieldset>
    <% } %> </div>
</asp:Content>
