<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<SeedSpeak.Model.Validation.MediaManagement>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Upload Image
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <link href="../../jqueryLightbox/jquery.lightbox-0.4.css" rel="stylesheet" type="text/css" />
    <script src="../../jqueryLightbox/jquery.lightbox-0.4.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $('#gallery a[rel=LightBox]').lightBox(); // Select all links in object with gallery ID            
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
            var extArray = new Array(".jpg", ".png", ".gif");

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

        function verifyFile() {
            var node_list = document.getElementsByTagName('input');
            for (var i = 0; i < node_list.length; i++) {
                var node = node_list[i];
                if (node.getAttribute('type') == 'file') {                    
                    CheckForFile();
                }
            }
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
                Upload <%} %>Images for
                "<%: ViewData["SeedTitle"] %>"</h2>
            <% using (Html.BeginForm("UploadMedia", "Seed",
                    FormMethod.Post, new { enctype = "multipart/form-data", id = "MediaForm" }))
               {%><div class="error-container">
                   <ul>
                   </ul>
               </div>
            <div class="clear">
            </div>
            <div class="success">
                <%: Html.ValidationSummary(true)%></div>
            <div class="message" style="width: 70%">
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
                        </table>
                    </div>
                </div>
                <br />
            </fieldset>
            <% }
               }%>
            <div class="clear">
            </div>
            <br />
            <br />            
            <div class="aulbumcontainer">
                <div id="gallery" class="imgbox">
                    <% foreach (SeedSpeak.Model.Medium objImages in (List<SeedSpeak.Model.Medium>)ViewData["MList"])
                       { %>
                    <div class="tblimg">
                        <h3>
                        <% if (objImages.title.Length>48)
                          { 
                              %>
                          Untitled
                          <%}
                          else
                          { %>
                            <%= objImages.title %>
                            <%} %>
                            </h3>
                        <a href="
            <%= objImages.path %>" title="<%= objImages.title %>" rel="LightBox">
                            <img alt="<%= objImages.title %>" src="<%= objImages.path %>" width="120px" height="100px" /></a>
                        <%if (mData.id == objSeed.ownerId)
                          { %>
                        <a href="/Seed/DeleteMedia/?id=<%= objImages.id %>&seedID=<%=ViewData["SeedValue"] %>"
                            onclick="javascript:return confirm('Are you sure want to Delete?')" style="margin-left: 32px;">
                            <img src="../../Content/images/delete.png" alt="Delete Image" /></a>
                        <%} %>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
