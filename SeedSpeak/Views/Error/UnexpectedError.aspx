<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    UnexpectedError
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="head" runat="server">
    <style>
        .imglnk
        {
            display: none;
        }
        .title, #lnk
        {
            display: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <div class="errpgmessage">
        <h5>
            Sorry, an unexpected error occurred while processing your request.<br />
            We are very sorry for inconvenience.
            <br />
            <br />
            <% string seedError = (string)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.SeedError);
               if (!string.IsNullOrEmpty(seedError))
               {
                   if (seedError == "Seed Error")
                   {
            %>
            <b>Seed you are looking for might have been removed, harvested or terminated.<br />
            Please begin your seed search again with any other keyword.</b><br /><br />
            <% 
}
                SeedSpeak.Util.SessionStore.SetSessionValue(SeedSpeak.Util.SessionStore.SeedError, "Seed Error Displayed");
           }
            %>
            Thank You<br />
            SeedSpeak
        </h5>
    </div>
</asp:Content>
