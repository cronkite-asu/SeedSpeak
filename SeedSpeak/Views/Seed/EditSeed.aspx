<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit Seed
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#EditSeedForm").validate({
                errorLabelContainer: $("ul", $('div.error-container')),
                wrapper: 'li',
                rules: {
                    SeedTitle: {
                        required: true
                    },
                    SeedDescription: {
                        required: true
                    }
                },
                messages: {
                    SeedTitle: {
                        required: " Please specify Seed Name"
                    },
                    SeedDescription: {
                        required: " Please specify Description"
                    }
                }
            });
        });

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
    <div class="frmcontent" >
        <% using (Html.BeginForm("EditSeed", "Seed", FormMethod.Post, new { id = "EditSeedForm" ,style="width:90%;margin:auto" }))
           {%><div class="error-container">
               <ul>
               </ul>
           </div>
      <br /><br />   <fieldset style="width: 550px; margin-left:20px;">
            <% SeedSpeak.Model.Seed objSeed = (SeedSpeak.Model.Seed)ViewData["SeedInfo"];
               if (objSeed != null)
               {
            %>
            <legend>Edit Seed</legend>
            <%: Html.Hidden("SeedId", objSeed.id)%>
            <table width="60%" border="0" style="margin-left:70px;"  cellpadding="8" cellspacing="8">
                <tr>
                    <td valign="top">
                        Seed Name<br />
                        <%: Html.TextBox("SeedTitle", objSeed != null ? objSeed.title : "", new { maxlength = 40 })%>
                    </td>   <td>Add Keyword<br />
                        <%: Html.TextBox("SeedTags", objSeed.Tags.FirstOrDefault() != null ? objSeed.Tags.FirstOrDefault().name : "", new { maxlength = 40})%>
                    </td>
                   </tr>
                <tr> <td valign="top"  colspan="2">
                        Seed Description<br />
                        <%: Html.TextArea("SeedDescription", objSeed != null ? objSeed.description : "", new { maxlength = 1000, style = "width:498px;height:70px" })%><br />
                    </td>
                
                 
                    
                </tr>
                <tr>
                    <td colspan="2">Select Category<br />
                     <div class="chkcontent">   <input type="hidden" id="categoryIds" name="categoryIds" />
                        <%  if (ViewData["categoryId"] != null)
                            {
                                foreach (SeedSpeak.Model.Category c in ViewData["categoryId"] as List<SeedSpeak.Model.Category>)
                                {
                                    string chkStatus = "";
                                    if (ViewData["SelCategory"] != null)
                                    {
                                        foreach (SeedSpeak.Model.Category sc in ViewData["SelCategory"] as List<SeedSpeak.Model.Category>)
                                        {
                                            if (sc.id == c.id)
                                            {
                                                chkStatus = "checked";
                                                break;
                                            }
                                            else
                                                chkStatus = "";
                                        }
                                    }

                                    if (chkStatus != "")
                                    {
                        %>
                    <span class="chkvalue">    <input type="checkbox" id="<%= c.id %>" checked="<%=chkStatus %>" name="category"
                            value='"<%= c.id %>"' /><b><%= c.name%></b></span>
                        <%}
                                    else
                                    {
                        %>
                       <span class="chkvalue">    <input type="checkbox" id="<%= c.id %>" name="category" value='"<%= c.id %>"' /><b><%= c.name%></b></span>
                        <%} %>
                        
                        <% }
                            }%>
                    </div>
                    </td>
                </tr>
            </table>
            <br />
            <%}
               else
               {
                   Response.Write("<div class='error-container'><b>Sorry! we can't find seed information</b></div>");
               }%>
        </fieldset>
        <div class="btncontainer">
            <input type="submit" value="Update Seed" onclick="javascript:return getIds('<%= ViewData["ids"] %>');" class="gbtn" />
            <input type="button" value="Cancel" class="grbtn" onclick="window.location = '/Seed/SeedDetails/<%= objSeed.id %>';" /></div>
        <% } %>
    </div> 
</asp:Content>
