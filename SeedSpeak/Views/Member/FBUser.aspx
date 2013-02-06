<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    FB User
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  
  
   <br /> <div style="margin: auto; border: 0px solid #000; width: 80%">
        <div class="message">
            <b>Facebook login successful</b>
        </div>
        <br />
        <br />
        <div  id="thanks">

        <fieldset>
        <legend>Please fill one time information form to get full access of seedspeak.</legend>
<% using (Html.BeginForm("FBUser", "Member", FormMethod.Post, new { id = "FBRegForm" }))
               {%>
            
            <div class="loginInner">

                <table width="100%">
                    <tr>
                        <td colspan="2">
                        <div class="error-container-Login">
                            <ul></ul>
                        </div>
                       </td>
                    </tr>
                     <tr>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width:200px; padding-right:20px; text-align:right">Email</td>
                        <td><input type="text" style="width:275px" id="fbEmail" name="fbEmail" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:center; padding-top:25px" colspan="2">
                    <input type="submit" value="Submit" class="editbtn" style="float:none" />
                    <input type="button" value="Cancel" class="cancelbtn" style="float:none" /></td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                </table>
                    
                    </div>
               
                <%} %>
       </fieldset>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#FBRegForm").validate({
                errorLabelContainer: $("ul", $('div.error-container-Login')),
                wrapper: 'li',
                rules: {
                    fbEmail: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    fbEmail: {
                        required: " Please specify email",
                        email: " Please enter valid email"
                    }
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
</asp:Content>
