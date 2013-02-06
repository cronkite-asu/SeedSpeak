<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<SeedSpeak.Model.Validation.ChangePasswordModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Change Password
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
    <script type="text/javascript">
        $(document).ready(function () {
            $("#OldPassword").attr("value", "");
            $("#ChangePwdForm").validate({
                errorLabelContainer: $("ul", $('div.error-container')),
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
    </script>
    <br />
    <div class="frmcontent">
       
        <% using (Html.BeginForm("ChangePassword", "Member", FormMethod.Post, new { id = "ChangePwdForm", @class = "jqtransform" }))
           {%>
        <%: Html.ValidationSummary(true) %>
        <fieldset style="width: 96%; height: 350px;"><em style="float: right">Required</em><div class="clear">
            </div>
         <div class="error-container">
            <ul>
            </ul>
        </div> <div class="clear">
            </div>
            <legend>Change Password</legend> 
            <label>
                Current password <em></em>
                <%: Html.PasswordFor(model => model.OldPassword) %>
            </label>
            <label>
                New password <em></em>
                <%: Html.PasswordFor(model => model.NewPassword) %>
            </label>
            <label>
                Confirm new password
                <%: Html.PasswordFor(model => model.ConfirmPassword) %>
            </label>
          
          <div style="float:left;margin-top:30px;" >
                <input type="submit" value="Change Password" class="gbtnxl" /> <input type="button" value="Cancel" class="grbtn" onclick="window.location = '/Member/Dashboard';" /></div>
        </fieldset>
        <% } %>
    </div>
</asp:Content>
