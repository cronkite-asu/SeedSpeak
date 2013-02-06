<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    SignUpThanks
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#LoginPanelForm").validate({
                errorLabelContainer: $("ul", $('div.error-container-Login')),
                wrapper: 'li',
                rules: {
                    LogUserName: {
                        required: true,
                        email: true
                    },
                    LogPassword: {
                        required: true
                    }
                },
                messages: {
                    LogUserName: {
                        required: " Please specify UserName",
                        email: " Please enter valid email"
                    },
                    LogPassword: {
                        required: " Please specify password"
                    }
                }
            });
        });
    </script>
    <br />
    <div style="margin: auto; border: 0px solid #000; width: 80%">
        <div class="message">
            <b>Registration Successful
                <br />
                Thanks for joining SeedSpeak!</b>
        </div>
        <br />
        <br />
        <div id="thanks">
            <fieldset>
                <legend>Please login to plant and grow seeds on SeedSpeak.</legend>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="3" style="text-align: center">
                            <% using (Html.BeginForm("SignUpThanks", "Member", FormMethod.Post, new { id = "LoginPanelForm" }))
                               {%>
                            <div class="error">
                                <%: Html.ValidationSummary() %>
                            </div>
                            <div class="error-container-Login">
                                <ul>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 240px; padding-right: 30px; text-align: right">
                            Username
                        </td>
                        <td>
                            :
                        </td>
                        <td>
                            <%: Html.TextBox("LogUserName")%>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-right: 30px; text-align: right">
                            Password
                        </td>
                        <td>
                            :
                        </td>
                        <td>
                            <%: Html.Password("LogPassword")%>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <input id="btnLogin" type="submit" value="" class="logbtn" /><%} %>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
</asp:Content>
