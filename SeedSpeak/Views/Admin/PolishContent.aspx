<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Police Content
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .imgbox
        {
            margin-top: -7px;
        }
        .vediobox
        {
            margin-top: -7px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function DeleteMedia() {
            msg = "Are you sure, you want to delete ?";
            return confirm(msg);
        }
    </script>
    <div id="fullpage_content">
        <h2>
            Police Content</h2>
        <% Html.Telerik().TabStrip()
           .Name("PolishContentTab").Items(tabstrip =>
               {
                   tabstrip.Add().Text("Images")
                       .Content(() =>
                                   {%>
        <div class="imgbox">
            <% foreach (SeedSpeak.Model.Medium objImages in (List<SeedSpeak.Model.Medium>)ViewData["ImageList"])
               { %>
            <div class="tblimg">
                <h3>
                    <%= objImages.title %></h3>
                <div class="clear">
                </div>
                <img alt="<%= objImages.title %>" src="<%= objImages.path %>" width="120px" height="100px" />
                <div class="clear">
                </div>
                <a href="/Admin/DeleteMedia/<%= objImages.id %>" onclick="javascript:return DeleteMedia();">
                    <img src="../../Content/images/delete.png" /></a></div>
            <% } %>
        </div>
        <%});

                   tabstrip.Add()
                       .Text("Video")
                       .Content(() =>
                       {%>
        <div class="vediobox">
            <% foreach (SeedSpeak.Model.Medium objVideo in (List<SeedSpeak.Model.Medium>)ViewData["MediaList"])
               { %>
            <div class="tblvediobox">
                <h3>
                    <%= objVideo.title %></h3>
                <div class="clear">
                </div>
                <object id="MediaPlayer" width="192" height="180" classid="CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95"
                    standby="Loading Windows Media Player components..." type="application/x-oleobject">
                    <param name="FileName" value="../<%= objVideo.path %>" />
                    <param name="ShowControls" value="true" />
                    <param name="ShowStatusBar" value="false" />
                    <param name="ShowDisplay" value="false" />
                    <param name="autostart" value="false" />
                    <embed type="application/x-mplayer2" src="../<%= objVideo.path %>" name="MediaPlayer"
                        width="192" height="180" showcontrols="1" showstatusbar="0" showdisplay="0" autostart="0"> </embed>
                </object>
                <div class="clear">
                </div>
                <a href="/Admin/DeleteMedia/<%= objVideo.id %>" onclick="javascript:return DeleteMedia();">
                    <img src="../../Content/images/delete.png" />
                </a>
            </div>
            <% } %>
        </div>
        <%});
               }).SelectedIndex(0).Render();
        %></div>
</asp:Content>
