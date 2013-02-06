<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<SeedSpeak.Model.Validation.MediaManagement>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Upload Video
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="../../Scripts/csspopup.js"></script>
    <script src="../../jwPlayer/jwplayer.js" type="text/javascript"></script>
    <script src="../../jwPlayer/swfobject.js" type="text/javascript"></script>
    <script type="text/javascript">
        function PlayerSetupFunction(pathVideo, pathDiv) {
            jwplayer(pathDiv).setup({
                flashplayer: '../../jwPlayer/player.swf',
                file: pathVideo,
                controlbar: 'over',
                fullscreen: 'true',
                stretching: 'fill',
                image: '../../jwPlayer/SeedSpeakBanner.jpg',
                skin: '../../jwPlayer/whotube.zip',
                height: 350//,
                //width: 730
            });
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            //When you click on a link with class of poplight and the href starts with a # 
            $('a.poplight[href^=#]').click(function () {
                var popID = $(this).attr('rel'); //Get Popup Name
                var popURL = $(this).attr('href'); //Get Popup href to define size

                //Pull Query & Variables from href URL
                var query = popURL.split('?');
                var dim = query[1].split('&');
                var popWidth = dim[0].split('=')[1]; //Gets the first query string value

                //Fade in the Popup and add close button
                //$('#' + popID).fadeIn().css({ 'width': Number(popWidth) }).prepend('<a href="#" class="close"><img src="../../Content/images/mclose.png" class="btn_close" title="Close Window" alt="Close" /></a>');

                $('#' + popID).fadeIn().css({ 'width': 'auto' }).prepend('<a href="#" class="close"><img src="../../Content/images/mclose.png" class="btn_close" title="Close Window" alt="Close" /></a>');

                //Define margin for center alignment (vertical + horizontal) - we add 80 to the height/width to accomodate for the padding + border width defined in the css
                var popMargTop = ($('#' + popID).height() + 80) / 2;
                var popMargLeft = ($('#' + popID).width() + 80) / 2;

                //Apply Margin to Popup
                $('#' + popID).css({
                    'margin-top': -popMargTop,
                    'margin-left': -popMargLeft
                });

                //Fade in Background
                $('body').append('<div id="fade"></div>'); //Add the fade layer to bottom of the body tag.
                $('#fade').css({ 'filter': 'alpha(opacity=80)' }).fadeIn(); //Fade in the fade layer 

                return false;
            });


            //Close Popups and Fade Layer
            $('a.close, #fade').live('click', function () { //When clicking on the close or fade layer...
                $('#fade , .popup_block').fadeOut(function () {
                    $('#fade, a.close').remove();
                }); //fade them both out
                return false;
            });
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#MediaForm").validate({
                errorLabelContainer: $("ul", $('div.error-container')),
                wrapper: 'li',
                rules: {
                    title: {
                        required: true
                    }

                },
                messages: {
                    title: {
                        required: " You must specify a Title"
                    }
                }
            });
        });
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
            var file = document.getElementById('uploadFile');
            var fileName = file.value;
            //Checking for file browsed or not 
            if (Trim(fileName) == '') {
                alert("Please select a file to upload!!!");
                file.focus();
                return false;
            }

            //Setting the extension array for diff. type of text files
            //var extArray = new Array(".mp4", ".avi", ".swf", ".mpg", ".flv", ".wmv");
            var extArray = new Array(".mp4", ".swf", ".mpg", ".flv", ".mov");

            //getting the file name
            while (fileName.indexOf("\\") != -1)
                fileName = fileName.slice(fileName.indexOf("\\") + 1);

            //Getting the file extension                     
            var ext = fileName.slice(fileName.indexOf(".")).toLowerCase();

            //matching extension with our given extensions.
            for (var i = 0; i < extArray.length; i++) {
                if (extArray[i] == ext) {
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
    <div class="vdocontent">
        <div class="vdocontent-top">
            <%SeedSpeak.Model.Member mData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject); SeedSpeak.Model.Seed objSeed = (SeedSpeak.Model.Seed)ViewData["SeedData"]; %>
        </div>
        <div class="vdocontent-bottom">
            <h2><% if (mData.id == objSeed.ownerId)
                   {
            %>
                Upload <%} %>Media for
                "<%: ViewData["SeedTitle"] %>"</h2>
            <% using (Html.BeginForm("UploadVedioMedia", "Seed",
                    FormMethod.Post, new { enctype = "multipart/form-data", id = "MediaForm" }))
               {%><div class="error-container">
                   <ul>
                   </ul>
               </div>
            <div class="clear">
            </div>
            <div>
                <%: Html.ValidationSummary(true)%></div>
            <div class="message">
                <%
string MediaMsg = "";
if (ViewData["MediaMsg"] != null)
{
    MediaMsg = ViewData["MediaMsg"].ToString();
}%>
                <%= System.Web.HttpUtility.HtmlDecode(MediaMsg)%>
            </div>
            <div class="clear">
            </div>
            <% if (mData.id == objSeed.ownerId)
               {
            %>
            <fieldset class="uploadbox">
                <div style="background-color: #E0EFFD; border: 4px solid #E0EFFD; border-radius: 5px 5px 5px 5px;
                    clear: both;">
                    <div class="frmupload">
                        <table width="100%">
                            <tr>
                                <td style="width: 95px">
                                    Title :
                                </td>
                                <td style="width: 400px">
                                    <%: Html.TextBoxFor(model => model.title, new { style = "width:350px;" })%>
                                    <%: Html.Hidden("seedId", ViewData["SeedValue"])%>
                                </td>
                                <td rowspan="2" style="border-left: 1px dashed #B4DFEE; width: 100px">
                                </td>
                                <td>
                                    <input type="submit" value="Upload" onclick="return CheckForFile();" class="gbtn" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Select Media :
                                </td>
                                <td>
                                    <input name="uploadFile" type="file" id="uploadFile" />
                                </td>
                                <td>
                                    <input type="button" value="Back" class="grbtn" onclick="window.location = '/Seed/SeedDetails/<%= ViewData["SeedValue"] %>';" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <ins style="padding-left: 100px">The video file should be under 100MB</ins>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <br />
            </fieldset>
            <% }
               }%>
            <div class="clear">
            </div>
            <div>
                <% foreach (SeedSpeak.Model.Medium w in (List<SeedSpeak.Model.Medium>)ViewData["MList"])
                   { %>
                <div class="tblvediobox">
                    <h3>
                        <label>
                        <% if (w.title.Length>48)
                          { %>
                          Untitled
                          <%}
                          else
                          { %>
                            <%= w.title%>
                            <%} %>
                        </label>
                    </h3>
                    <div class="clear">
                    </div>                    
                    <a href="#?w=735" rel="popupVideo<%=w.id%>" class="poplight" onclick="PlayerSetupFunction('<%= w.path %>','mediaspace<%= w.id %>')">
                        <img alt="<%= w.title %>" src="../../Content/images/video-img.png" /></a>
                    <div id="popupVideo<%=w.id%>" class="popup_block">
                        <div id="mediaspace<%=w.id%>">
                            Loading jw player....</div>
                    </div>
                    <div class="clear">
                    </div>
                    <%if (mData.id == objSeed.ownerId)
                      { %>
                    <div style="width: 200px; padding-left: 55px">
                        <a href="/Seed/DeleteVideo/?id=<%= w.id %>&seedID=<%=ViewData["SeedValue"] %>" onclick="javascript:return confirm('Are you sure want to Delete?')">
                            <img src="../../Content/images/delete.png" /></a></div>
                    <%} %>
                </div>
                <% } %>
            </div>
            <br />
            <br />
        </div>
    </div>
</asp:Content>
