<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Contact
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/subpages.css" rel="stylesheet" type="text/css" />
      
</asp:Content>
<asp:Content ID="aboutContent" ContentPlaceHolderID="subpageContainer" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ContactForm").validate({
                errorLabelContainer: $("ul", $('div.error-container')),
                wrapper: 'li',
                rules: {
                    Name: {
                        required: true
                    },
                    Phone: {                        
                        digits: true
                    },
                    Email: {
                        required: true,
                        email: true
                    },
                    Address: {
                        required: true
                    },                    
                    Comments: {
                        required: true
                    }
                },
                messages: {
                    Name: {
                        required: " Please specify Name"
                    },
                    Phone: {                        
                        digits: " Please insert only digits in Phone"
                    },
                    Email: {
                        required: " Please specify email",
                        email: " Please insert valid email"
                    },
                    Address: {
                        required: " Please specify a address"
                    },                    
                    Comments: {
                        required: " Please specify comments"
                    }
                }
            });
        });
    </script>
    
    <style>
   #cont form label {
    border: 0 solid #000000;
    display: block;
    float: left;
    margin: 0.5em 0 10px 10px;
    width: 280px;
}
#cont textarea {background: url("../../content/images/txt-area.png") repeat-x scroll 0 0 transparent;
    border-color: #DBDFE4;
    border-radius: 2px 2px 2px 2px;
    border-style: solid;
    border-width: 2px 2px 1px;
    color: #777777;
    font-size: 12px;
    font-weight: normal;
    outline: 0 none;}
    </style>


    <div class="breadcrum">
        <a href="/Member/Dashboard">Home</a><b>&nbsp;</b><a href="/Home/Contact">Contact</a></div>
    <div class="clear">
    </div>
    <div class="subpgtext">
        <strong>Contact Info</strong><br /><br />
        <div class="clear">
        </div>
        <div>
            <%= System.Web.HttpUtility.HtmlDecode(ViewData["ContactContent"].ToString())%>
        </div>
       <div id="cont"> <div class="formcontain">
            <% Html.BeginForm("Contact", "Home", FormMethod.Post, new { id = "ContactForm" }); %>
          <fieldset style="width: 950px;">     <legend>Let us know how we can help you</legend>  <br />   <div class="error-container">
                <ul>
                </ul>
            </div> <div class="clear">
                </div>
         
                <div class="message">
                    <% if (ViewData["ContactInfo"] != null)
                       { %>   <div class="clear">
                </div>
                    <b>
                        <%: ViewData["ContactInfo"]%></b>
                    <%} %>
                </div>
                <div class="clear">
                </div>
           
               <div style="width:62%; float:left"> <label>
                    Name
                    <%: Html.TextBox("Name") %>
                </label>
                <label>
                    Phone
                    <%: Html.TextBox("Phone") %>
                </label> <br />
                <label>
                    Email
                    <%: Html.TextBox("Email") %>
                </label>
                <label>
                    Company
                    <%: Html.TextBox("Company") %>
                </label>
                <br />
                <label class="wide" style="width:580px">
                    Address
                    <%: Html.TextBox("Address") %>
                </label></div>
               <div style="float:left; width:30%">
                <label class="wide">
                    Comments
                    <%: Html.TextArea("Comments", new { style="height:185px; width:325px"})%>
                </label></div>
            </fieldset>
            <br />
            <div class="btncontainer" style="width: 97%">
                <input type="submit" value="Submit" class="gbtn" />
                <% Html.EndForm(); %>
            </div>
        </div></div>
    </div>
</asp:Content>
