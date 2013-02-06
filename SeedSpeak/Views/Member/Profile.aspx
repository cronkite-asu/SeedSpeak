<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<SeedSpeak.Model.Validation.ProfileModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Profile
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        #ProfileTab .t-tabstrip-items
        {
            border-bottom: 1px solid #B6AFAA;
    height: 41px;
   
    margin-top: 10px;
        }
        .t-tabstrip .t-item
        {
            position: relative;
            top: 6px;
        }

        em {
    background-position: -135px -85px !important;
}
#tabfrmcontent FIELDSET {
    border: 1px solid #D5DEE2;
    color: #464545;
    float: left;
    font-size: 14px;
    margin: auto;
    padding-left: 5px;
    width: 955px;
    margin:10px 0 10px -5px;
}
.green
	        {
	            color: Green;
	        }
	        .red
	        {
	            color: Red;
	        }
	        .black
	        {
	            color: Black;
	        }
	        
div.selector select { -webkit-appearance: none; }
    </style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../../Scripts/jquery.ui.core.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.ui.widget.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.ui.datepicker.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $("#datepicker").datepicker({
                showOn: "button",
                buttonImage: "../../Content/images/calendar.gif",
                buttonImageOnly: true
            });
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#UpdateLoginForm").validate({
                errorLabelContainer: $("ul", $('div.error-container2')),
                wrapper: 'li',
                rules: {
                    NewEmail: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    NewEmail: {
                        required: " Please specify email",
                        email: " Please insert valid email"
                    }
                }
            });
        });

        $(document).ready(function () {
            $("#PersonalForm").validate({
                errorLabelContainer: $("ul", $('div.error-container')),
                wrapper: 'li',
                rules: {
                    ZipCode: {
                        required: true,
                        digits: true,
                        minlength: 5,
                        maxlength: 5
                    },
                    Dob: {
                        required: true
                    },
                    id: {
                        required: true
                    },
                    City: {
                        required: true
                    },
                    userFName: {
                        required: true
                    },
                    userLName: {
                        required: true
                    },
                    CheckSetURL: {
                        required: true
                    }
                },
                messages: {
                    ZipCode: {
                        required: " Please specify Zipcode",
                        digits: " Please insert digits in Zipcode",
                        minlength: " Please insert Zipcode of 5 digits",
                        maxlength: " Please insert Zipcode of 5 digits"
                    },
                    Dob: {
                        required: " Please specify Date of Birth"
                    },
                    id: {
                        required: " Please specify Region"
                    },
                    City: {
                        required: " Please specify City"
                    },
                    userFName: {
                        required: " Please specify First Name"
                    },
                    userLName: {
                        required: " Please specify Last Name"
                    },
                    CheckSetURL: {
                        required: " Please set other URL"
                    }
                }
            });
        });

        $(document).ready(function () {
            $("#ExternalForm").validate({
                errorLabelContainer: $("ul", $('div.error-container1')),
                wrapper: 'li',
                rules: {
                    Username: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    Username: {
                        required: " Please specify email",
                        email: " Please insert valid email"
                    }
                }
            });
        });

        $(document).ready(function () {
            $("#OldPassword").attr("value", "");
            $("#ChangePwdForm").validate({
                errorLabelContainer: $("ul", $('div.error-container3')),
                wrapper: 'li',
                rules: {
                    OldPassword: {
                        required: true
                    },
                    NewPassword: {
                        required: true,
                        minlength: 6
                    },
                    ConfirmPassword: {
                        required: true,
                        equalTo: "#NewPassword"
                    }
                },
                messages: {
                    OldPassword: {
                        required: " You must specify Old Password"
                    },
                    NewPassword: {
                        required: " You must specify New Password",
                        minlength: " New Password length should be greater than 5 characters"
                    },
                    ConfirmPassword: {
                        required: " You must specify Confirm Password",
                        equalTo: " Please insert same password as above"
                    }
                }
            });
        });

        $(document).ready(function () {
            $("#UpdateOrgForm").validate({
                errorLabelContainer: $("ul", $('div.error-containerOrg')),
                wrapper: 'li',
                rules: {
                    newOrg: {
                        required: true
                    }
                },
                messages: {
                    newOrg: {
                        required: " Please specify new Organization"
                    }
                }
            });
        });

        $(document).ready(function () {
            $("#setURL").focusout(function () {
                var name = $("#setURL").val(); //Value entered in the text box
                var status = $("#divStatus"); //DIV object to display the status message
                if (name != '') {
                    status.html("Checking....").attr("class", "black"); //While our Thread works, we will show some message to indicate the progress
                    //jQuery AJAX Post request
                    $.post("/Member/CheckURL", { urlString: name },
	            function (data) {
	                if (data.toString() == "true") {
	                    status.html(name + " is available !").attr("class", "green");
	                    $("#CheckSetURL").val("available");
	                } else {
	                    status.html(name + " is not available !").attr("class", "red");
	                    $("#CheckSetURL").val("");
	                }
	            });
                }
                else {
                    status.html("");
                }
            });
        });
    </script>
    <script type="text/javascript">

        var ddlRegion;
        var ddlCities;

        function pageLoad() {

            ddlRegion = $get("id");
            ddlCities = $get("City");
            $addHandler(ddlRegion, "change", bindOptions);
            bindOptions();
        }

        function bindOptions() {

            ddlCities.options.length = 0;
            var makeId = ddlRegion.value;
            //  alert(ddlRegion.value);
            if (makeId) {
                var url = "/Member/Models/" + makeId;
                getContent(url, bindOptionResults);
            }
        }

        function bindOptionResults(data) {
            var cityId = '<%= ViewData["CityId"].ToString() %>';
            var newOption;
            var selIndex = 0;

            for (var k = 0; k < data.length; k++) {
                newOption = new Option(data[k].Text, data[k].Value);
                if (data[k].Value == cityId) {
                    selIndex = k;
                }
                ddlCities.options.add(newOption);
            }

            ddlCities.options.selectedIndex = selIndex;
        }

        /**** should be in library ***/
        function getContent(url, callback) {
            var request = new Sys.Net.WebRequest();
            request.set_url(url);
            request.set_httpVerb("GET");
            var del = Function.createCallback(getContentResults, callback);
            request.add_completed(del);
            request.invoke();
        }

        function getContentResults(executor, eventArgs, callback) {
            if (executor.get_responseAvailable()) {
                //  alert("IFgetContentResults");
                callback(eval("(" + executor.get_responseData() + ")"));
            }
            else {
                if (executor.get_timedOut())
                    alert("Timed Out");
                else if (executor.get_aborted())
                    alert("Aborted");
            }
        }

        function Select(selVal) {
            var tabstrip = $("#ProfileTab").data("tTabStrip");
            var item = $("li", tabstrip.element)[selVal];
            tabstrip.select(item);
        }
    </script>
    <script language="javascript" type="text/javascript">
        //Trim the input text
        function Trim(input) {
            var lre = /^\s*/;
            var rre = /\s*$/;
            input = input.replace(lre, "");
            input = input.replace(rre, "");
            return input;
        }

        // filter the files before Uploading for text file only  
        function CheckForFile() {
            var file = document.getElementById('upProfileImage');
            var fileName = file.value;
            //Checking for file browsed or not 
            if (Trim(fileName) == '') {
                alert("Please select a file to upload!!!");
                file.focus();
                return false;
            }

            //Setting the extension array for diff. type of text files
            var extArray = new Array(".jpg", ".png", ".gif");

            //getting the file name
            while (fileName.indexOf("\\") != -1)
                fileName = fileName.slice(fileName.indexOf("\\") + 1);

            //Getting the file extension                     
            var ext = fileName.slice(fileName.indexOf(".")).toLowerCase();

            //matching extension with our given extensions.
            for (var i = 0; i < extArray.length; i++) {
                if (extArray[i] == ext) {
                    if (document.getElementById("w").value == "" || document.getElementById("w").value == "0"
        || document.getElementById("h").value == "" || document.getElementById("h").value == "0") {
                        alert("No area to crop was selected");
                        return false;
                    }
                    return true;
                }
            }
            alert("Please only upload files that end in types:  "
           + (extArray.join("  ")) + "\nPlease select a new "
           + "file to upload and submit again.");
            file.focus();
            return false;
        }
    </script>
    <script type="text/javascript">
        function calculateCoordinatesP() {
            var txtState = document.getElementById("id");
            var txtCity = document.getElementById("City");
            var txtPostcode = document.getElementById("ZipCode");
            var txtLatitude = document.getElementById("Latitude");
            var txtLongitude = document.getElementById("Longitude");

            var address = txtCity.options[txtCity.selectedIndex].text + ', ';
            address += txtState.options[txtState.selectedIndex].text + ', ';
            address += txtPostcode.value + ', ';
            address += 'USA';

            var geocoder;
            geocoder = new GClientGeocoder();
            geocoder.getLocations(address, function (response) {
                if (response) {
                    if (!response || response.Status.code != 200) {
                        txtLatitude.value = '0.0';
                        txtLongitude.value = '0.0';
                    }
                    else {
                        place = response.Placemark[0];                        
                        txtLatitude.value = place.Point.coordinates[1];
                        txtLongitude.value = place.Point.coordinates[0];
                    }
                }
            });
        }

        function calculateCoordinatesZip() {
            var txtState = document.getElementById("id");
            var txtCity = document.getElementById("City");
            var txtPostcode = document.getElementById("ZipCode");
            var txtLatitude = document.getElementById("Latitude");
            var txtLongitude = document.getElementById("Longitude");

            var address = txtCity.options[txtCity.selectedIndex].text + ', ';
            address += txtState.options[txtState.selectedIndex].text + ', ';
            address += txtPostcode.value + ', ';
            address += 'USA';

            var geocoder;
            geocoder = new GClientGeocoder();
            geocoder.getLocations(address, function (response) {
                if (response) {
                    if (!response || response.Status.code != 200) {
                        txtLatitude.value = '0.0';
                        txtLongitude.value = '0.0';
                    }
                    else {
                        place = response.Placemark[0];                        
                        txtLatitude.value = place.Point.coordinates[1];
                        txtLongitude.value = place.Point.coordinates[0];
                        txtPostcode.value = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.PostalCode.PostalCodeNumber;
                    }
                }
            });
        }

        function calculateCoordinatesProfile() {
            var txtState = document.getElementById("id");
            var txtCity = document.getElementById("City");
            var txtPostcode = document.getElementById("ZipCode");
            var txtLatitude = document.getElementById("Latitude");
            var txtLongitude = document.getElementById("Longitude");            

            if (txtState.value == '') {
                alert('Please select state');
                return false;
            }

            var address = txtCity.options[txtCity.selectedIndex].text + ', ';
            address += txtState.options[txtState.selectedIndex].text + ', ';
            address += txtPostcode.value + ', ';
            address += 'USA';

            var geocoder;
            geocoder = new GClientGeocoder();
            geocoder.getLocations(address, function (response) {
                if (response) {
                    if (!response || response.Status.code != 200) {
                        txtLatitude.value = '0.0';
                        txtLongitude.value = '0.0';
                    }
                    else {
                        place = response.Placemark[0];                        
                        txtLatitude.value = place.Point.coordinates[1];
                        txtLongitude.value = place.Point.coordinates[0];
                        txtPostcode.value = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.PostalCode.PostalCodeNumber;
                        return true;
                    }
                }
            });
        }

        $(document).ready(function () {
            $("#City").change(function () {
                calculateCoordinatesZip();
            });
        });

        $(document).ready(function () {
            $("#ZipCode").change(function () {
                calculateCoordinatesP();
            });
        });

        $(function () {
            $('#setURL').keyup(function () {
                var setURLValue = $('#setURL').val();
                var spanURL = document.getElementById('setURLSpan');
                spanURL.innerHTML = setURLValue;
            });

            $('#setURL').focusout(function () {
                var setURLValue = $('#setURL').val();
                var spanURL = document.getElementById('setURLSpan');
                spanURL.innerHTML = setURLValue;
            });

            window.onload = (function () {
                var setURLValue = document.getElementById('setURL').value;
                var spanURL = document.getElementById('setURLSpan');
                spanURL.innerHTML = setURLValue;
            });
        });

    </script>
    <%--following js and css used from cropping functionality--%>
    <script src="../../jcrop/jquery.Jcrop.js" type="text/javascript"></script>
    <link href="../../jcrop/jcrop.css" rel="stylesheet" type="text/css" />
    <script src="../../jcrop/crop.js" type="text/javascript"></script>
     <%--jquery.form.js used for ajax submit--%>
    <script src="../../jcrop/jquery.form.js" type="text/javascript"></script>
    <script type="text/javascript">
        function ChangeImage(fileId, imageId) {
            $("#ProfileImageForm").ajaxSubmit({ success: function (responseText) {
                var d = new Date();
                $(imageId)[0].src = "/Member/ImageLoad?a=" + d.getTime();
                var eImg = document.getElementById('imgThumbnail');
                eImg.style.visibility = "visible";
                Init();
            }
            });        
        }

        function Init() {
            jQuery(function () {
                jQuery('#imgThumbnail').Jcrop({
                    onSelect: showCoords,
                    onChange: showCoords,
                    // minSize: [0, 0],
                    // maxSize: [0, 0],
                    minSize: [200, 200],
                    maxSize: [400, 400],
                    bgOpacity: .4
                    //,aspectRatio: 1
                });
            });
        }
    </script>
    
    <table>
        <tr>
            <td class="pageheader">
                Settings
            </td>
        </tr>
        <tr>
            <td class="commontxt">
                Adjust your profile information, change your password, and manage your external accounts.
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        </table>
 <div id="tabfrmcontent"><div style="float:right"><a href="/Member/UserDetail/<%=ViewData["LoggedInMember"].ToString()%>" class="block_link">View my profile</a></div>
        <% Html.Telerik().TabStrip()
           .Name("ProfileTab").Items(tabstrip =>
               {
                   tabstrip.Add()
                       .Text("Personal")
                       .Content(() =>
                       {%>
        <div>
            <% using (Html.BeginForm("Profile", "Member", FormMethod.Post, new { id = "PersonalForm" }))
               {%>
            <div class="error-container">
            </div>
            <div class="clear">
            </div>
            <div class="message">
                <%
                    string PersonalMsg = "";
                    if (ViewData["PersonalMsg"] != null)
                    {
                        PersonalMsg = ViewData["PersonalMsg"].ToString();
                    }%>
                <%= System.Web.HttpUtility.HtmlDecode(PersonalMsg)%>                
            </div>
            <div class="clear">
            </div>
          
            <fieldset style="width: 950px; height:auto">
                <legend>Personal Information</legend>
                <% SeedSpeak.Model.Member m = (SeedSpeak.Model.Member)ViewData["MemberData"];
                    SeedSpeak.Model.MemberProfile s = (SeedSpeak.Model.MemberProfile)ViewData["MemberProfile"]; %>
                <em style="float: right">Required</em><div class="clear">
                </div>
                <label>First Name<em></em>
                    <%: Html.TextBox("userFName",m!=null?m.firstName:"") %>
                    </label>
                    <label>Last Name<em></em>
                    <%: Html.TextBox("userLName",m!=null?m.lastName:"") %>
                    </label>
                <label>
                    State<em></em>
                    <%: Html.DropDownList("id", (SelectList)ViewData["RegionItem"], "Select State")%>
                </label>
                <label> <div class="ununiddl">
                    City<em></em> <div class="clear">
            </div><div class="selector"  ><span >
                    <%: Html.DropDownList("City", (SelectList)ViewData["RegionItem"], "Select City", new { @class = "nonuniselect" })%>
           </span></div> </div></label> <div class="clear">
            </div>
                <label>
                    Home ZipCode<em></em>                    
                    <%: Html.TextBox("ZipCode", s!=null && s.Location!=null? s.Location.zipcode : "")%>
                </label>
                <label>
                    Gender<em></em>
                    <%List<SelectListItem> genders = new List<SelectListItem>();
                      if (m != null)
                      {
                          if (m.MemberProfiles.FirstOrDefault() != null)
                          {
                              if (m.MemberProfiles.FirstOrDefault().sex != null)
                              {
                                  if (m.MemberProfiles.FirstOrDefault().sex == "Male")
                                  {
                                      genders.Add(new SelectListItem { Text = "Male", Value = "Male", Selected = true });
                                      genders.Add(new SelectListItem { Text = "Female", Value = "Female" });
                                  }
                                  else
                                  {
                                      genders.Add(new SelectListItem { Text = "Male", Value = "Male" });
                                      genders.Add(new SelectListItem { Text = "Female", Value = "Female", Selected = true });
                                  }
                              }
                              else
                              {
                                  genders.Add(new SelectListItem { Text = "Male", Value = "Male", Selected = true });
                                  genders.Add(new SelectListItem { Text = "Female", Value = "Female" });
                              }
                          }
                          else
                          {
                              genders.Add(new SelectListItem { Text = "Male", Value = "Male", Selected = true });
                              genders.Add(new SelectListItem { Text = "Female", Value = "Female" });
                          }
                      } %>
                    
                    <%: Html.DropDownListFor(model => model.Sex, genders)%>
                </label>
                
                <label style="width:450px">Set Custom URL<small style="font-size:10px; margin-left:2px; color:#636363">
                ( www.seedspeak.com/<span id="setURLSpan"></span> )</small> 
                
                    <% string finalURL = string.Empty;
                        if(s!=null)
                       {
                           if (!string.IsNullOrEmpty(s.setURL))
                           {
                               string ssURL = s.setURL.ToString();
                               string[] ss = ssURL.Split('/');
                               finalURL = ss[1].ToString();
                           }
                       } %>
                    <%: Html.TextBox("setURL",finalURL) %>
                    <input type="hidden" id="CheckSetURL" name="CheckSetURL" value="available" />
                </label>
                <span id="divStatus"></span><br />
                <label>Bio
                    <%: Html.TextArea("userBio",s!=null && s.bio!=null?s.bio.ToString():"", new { @class = "uniform", style="width:675px; height:100px" })%>
                </label>                
                <%: Html.Hidden("Latitude", s != null && s.Location != null ? s.Location.localLat.ToString() : "", new { @readonly = "readonly" })%>                
                <%: Html.Hidden("Longitude", s != null && s.Location != null ? s.Location.localLong.ToString() : "", new { @readonly = "readonly" })%>
                <div class="btncontainer" style="height:35px; width:235px; float:right; padding:90px 0 0 0px; text-align:left">
              
                
                <input type="submit" value="Update Profile" class="gbtn" onclick="javascript:return calculateCoordinatesProfile();" />
                <input type="button" value="Cancel" class="grbtn" onclick="window.location = '/Member/Dashboard';" />
            </div> <br class="clear" />                
            </fieldset>
          
            <% } %></div>
        <div class="clear">
        </div>
        <div>
            <% using (Html.BeginForm("UploadProfileImage", "Member", FormMethod.Post, new { enctype = "multipart/form-data", id = "ProfileImageForm" }))
               { %>
            <div class="error-container4">
                <ul>
                </ul>
            </div>
            <div class="message">
                <%
                    string ProfileImageMsg = "";
                    if (ViewData["ProfileImageMsg"] != null)
                    {
                        ProfileImageMsg = ViewData["ProfileImageMsg"].ToString();
                    }%>
                <%= System.Web.HttpUtility.HtmlDecode(ProfileImageMsg)%>                
            </div>
            <div class="clear">
            </div>
            <fieldset class="uploadbox" style="width:950px!important">
                <legend>Upload Profile Image</legend>
                <div style="width:950px">
                <div style="width:500px; float:left">
                <div>
                    <label>
                        Profile Image                        
                        <input type="file" name="upProfileImage" id="upProfileImage" onchange="ChangeImage(this,'#imgThumbnail')" />
                    </label>
               </div>
                <% SeedSpeak.Model.Member mData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
                   string imagePath = "";
                   if (mData != null)
                   {
                       if (mData.MemberProfiles.FirstOrDefault() != null)
                       {
                           if (mData.MemberProfiles.FirstOrDefault().imagePath != null)
                           {
                               string img = mData.MemberProfiles.FirstOrDefault().imagePath.ToString();
                               img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                               if (System.IO.File.Exists(img))
                                   imagePath = mData.MemberProfiles.FirstOrDefault().imagePath.ToString();
                               else
                                   imagePath = "../../Content/images/user.gif";
                           }
                           else
                               imagePath = "../../Content/images/user.gif";
                       }
                       else
                       {
                           imagePath = "../../Content/images/user.gif";
                       }
                   } %>
                <img src="<%=imagePath %>" alt="Profile Image" width="100" height="80" /><br />
                <img src="" id="imgThumbnail" alt="" style="visibility:hidden; max-height:900px; max-width:900px;" />
             <br />
                
                
                </div>
                <div style="width:25%; float:right; padding-top:25px">
               <input type="submit" id="btnUpProfileImage" name="btnUpProfileImage" value="Upload Image" onclick="return CheckForFile();" class="gbtn" />
                <input type="button" value="Cancel" class="grbtn" onclick="window.location = '/Member/Dashboard';" />
                <input type="hidden" id="x1" name="x1" class="coor" />
<input type="hidden" id="y1" name="y1" class="coor" />
<input type="hidden" id="x2" name="x2" class="coor" />
<input type="hidden" id="y2" name="y2" class="coor" />
<input type="hidden" id="w" name="w" class="coor" />
<input type="hidden" id="h" name="h" class="coor" />
            </div>
            </div>
            </fieldset>
            <div class="clear">
            </div>
            
            <%} %>
        </div>
        <%});
                   tabstrip.Add().Text("Seed Settings")                       
                       .Content(() =>
                                   {%>
        <div>
            <% using (Html.BeginForm("PrivacyAccounts", "Member", FormMethod.Post, new { id = "PrivacyForm" }))
               {%><div class="message">
                   <%
                       string PrivacyMsg = "";
                       if (ViewData["PrivacyMsg"] != null)
                       {
                           PrivacyMsg = ViewData["PrivacyMsg"].ToString();
                       }%>
                   <%= System.Web.HttpUtility.HtmlDecode(PrivacyMsg)%>                   
               </div>
            <fieldset style="width: 100%; height: 170px;">
                <legend>Privacy</legend>
                <% SeedSpeak.Model.Privacy p = (SeedSpeak.Model.Privacy)ViewData["Privacy"]; %>
                <table>
                <tr><td style="padding-left:8px">
                <label class="lblddlxl" style="width:250px">
                    Show My Username
                    <%: Html.DropDownList("ViewUsername", (SelectList)ViewData["MyUsername"])%>
                </label>
                <label class="lblddlxl" style="width:310px">
                    Seed Contribution
                    <%: Html.DropDownList("seedContribution", (SelectList)ViewData["VSeedContribution"])%>
                </label>
                <label class="lblddlxl" style="width:310px">
                    Seed Commitment
                    <%: Html.DropDownList("seedCommitment", (SelectList)ViewData["VSeedCommitment"])%>
                </label></td>
                </tr>
                </table>                
           <div class="btncontainer" style="padding-top:10px">
                <input type="submit" value="Update Profile" class="gbtn" />
                <input type="button" value="Cancel" class="grbtn" onclick="window.location = '/Member/Dashboard';" /></div> </fieldset>
            
            <% } %>
        </div>
        <%}).Visible(false);%>
        
        <%
                   tabstrip.Add()
             .Text("Change Login/Password")
             .Content(() =>
             {%>
        <div>
            <% using (Html.BeginForm("ChangePassword", "Member", FormMethod.Post, new { id = "ChangePwdForm" }))
               {%>
            <%: Html.ValidationSummary(true) %><div class="error-container3">
                <ul>
                </ul>
            </div>
            <div class="clear">
            </div>
            <div class="message">
                <%
                    string ChangePwd = "";
                    if (ViewData["ChangePwdMsg"] != null)
                    {
                        ChangePwd = ViewData["ChangePwdMsg"].ToString();
                    }%>
                <%= System.Web.HttpUtility.HtmlDecode(ChangePwd)%>                
            </div>
            <fieldset style="width: 100%; height: 190px;">
                <em style="float: right">Required</em><div class="clear">
                </div>
                <legend>Change Password</legend>
                <label>
                    Current Password <em></em>
                    <%: Html.PasswordFor(model => model.OldPassword) %>
                </label>
                <label>
                    New Password <em></em>
                    <%: Html.PasswordFor(model => model.NewPassword) %>
                </label>
                <label>
                    Confirm New Password<em></em>
                    <%: Html.PasswordFor(model => model.ConfirmPassword) %>
                </label><div class="clear">
                <div class="btncontainer" style="margin-top: 0px;">
                <input type="submit" value="Change Password" class="gbtnxl" />
                <input type="button" value="Cancel" class="grbtn" onclick="window.location = '/Member/Dashboard';" /></div>
                </div>
            </fieldset>
            
            <% } %>
        </div>
        <div class="clear">
        </div>
        <div>
            <% using (Html.BeginForm("UpdateUserName", "Member", FormMethod.Post, new { id = "UpdateLoginForm" }))
               {%>
            <div class="error-container2">
                <ul>
                </ul>
            </div>
            <div class="message">
                <%
                    string UpLoginMsg = "";
                    if (ViewData["UpdateLoginMsg"] != null)
                    {
                        UpLoginMsg = ViewData["UpdateLoginMsg"].ToString();
                    }%>
                <%= System.Web.HttpUtility.HtmlDecode(UpLoginMsg)%>
            </div>
            <div class="clear">
            </div>
            <fieldset style="width: 950px;">
                <legend>Update Login</legend>
                <label>
                    New Username<em></em>
                    <%: Html.TextBoxFor(model => model.NewEmail)%>
                </label> <div class="btncontainer"  style="margin-top: 30px;">
                <input type="submit" value="Update" class="gbtn" />
                <input type="button" value="Cancel" class="grbtn" onclick="window.location = '/Member/Dashboard';" />
            </div>
            </fieldset>
           
            <% } %>
        </div>
        <div class="clear">
        </div>
        <div>
            <% using (Html.BeginForm("UpdateOrganization", "Member", FormMethod.Post, new { id = "UpdateOrgForm" }))
               {%>
            <div class="error-containerOrg">
                <ul>
                </ul>
            </div>
            <div class="message">
                <%
                    string UpOrgMsg = "";
                    if (ViewData["UpdateOrg"] != null)
                    {
                        UpOrgMsg = ViewData["UpdateOrg"].ToString();
                    }%>
                <%= System.Web.HttpUtility.HtmlDecode(UpOrgMsg)%>
            </div>
            <fieldset style="width: 950px;">
                <legend>Update Organization</legend>
                <label>
                    New Organization Name<em></em>
                    <%: Html.TextBox("newOrg")%>
                </label> <div class="btncontainer" style="margin-top: 30px;">
                <input type="submit" value="Update" class="gbtn" />
                <input type="button" value="Cancel" class="grbtn" onclick="window.location = '/Member/Dashboard';" />
            </div>
            </fieldset>
           
            <% } %>
        </div>
        <%});
               }).SelectedIndex(Convert.ToInt32(ViewData["SelectedIndex"])).Render();
        %>
    </div>
</asp:Content>
