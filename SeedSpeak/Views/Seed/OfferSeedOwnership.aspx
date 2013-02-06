<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Offer Seed Ownership
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $("#RequestOwnerForm").validate({
                errorLabelContainer: $("ul", $('div.error-container')),
                wrapper: 'li',
                rules: {
                    OwnerEmail: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    OwnerEmail: {
                        required: " You must specify a email address",
                        email: " Please insert valid email"
                    }
                }
            });
        });

        $(document).ready(function () {
            //Adding autocomplete to Tag input
            $("#OwnerEmail").autocomplete('<%: Url.Action("OwnershipEmail", "Seed") %>', {
                minChars: 0,
                //Don't fill the input while still selecting a value
                autoFill: false,
                //Only suggested values are valid
                mustMatch: true,
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
            })
        });
    </script>
    <h2>
        Offer Seed Ownership</h2>
    <br />
    <div class="frmcontent">
        <div>
            <% using (Html.BeginForm("OfferSeedOwnership", "Seed", FormMethod.Post, new { id = "RequestOwnerForm" }))
               {%>
            <%: Html.ValidationSummary(true) %>
            <fieldset style="width: 98%; height: 350px;">
                <div class="error-container">
                    <ul>
                    </ul>
                </div>
                <div class="clear">
                </div>
                <em style="float: right">Required</em> <legend>Take Ownership</legend>
                <label>
                    E-mail <em></em>
                    <%: Html.TextBox("OwnerEmail") %>
                </label>
                <div style="float: left; margin-top: 30px">
                    <input type="submit" value="Request Ownership" />                    
                </div>
            </fieldset>
            <% } %>
        </div>
    </div>
</asp:Content>
