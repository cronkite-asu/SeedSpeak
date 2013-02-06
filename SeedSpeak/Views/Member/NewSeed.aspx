<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Register Src="~/Views/Seed/ShareIdea.ascx" TagName="ShareIdea" TagPrefix="SeedSpeakUC" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    New Seeds
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
    .scrollcat {   
    margin-left: 0px!important;    
}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="contentarea">
        <div class="stream-left-nav">
          <% string[] DashCount = (string[])SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.DashboardCount); %>
            <div id="navigation">
                <ul>
                    <li class="planNew-sel"><a href="/Member/NewSeed">Plant New</a> </li>
                    <li class="common"><a href="/Member/Dashboard">My Seeds (<%=DashCount[0] %>)</a> </li>
                    <li class="common"><a href="/SeedStream/ListFeeds">My Feeds/Lists (<%=DashCount[1] %>)</a> </li>
                    <li class="common"><a href="/Member/People">My People (<%=DashCount[2] %>)</a></li>
                    <li class="navigation_buttom"><a href="/Member/NewestNearby">Newest Nearby (<%=DashCount[3] %>)</a></li>
                </ul>
            </div>
         
            <div style="clear: both;">
            </div>
        </div>
        <!--navigation-->
        <div id="midcontent">
            <div class="content-rounded-top">
            </div>
            <!--content-rounded-top-->
            <div class="content-mid-bg">
                <div class="containerTbs">
                    <div id="uccontent" class="subpgtext">
                        <div class="ucwrapper">
                        <table width="100%">
                                        <tr>
                                            <td class="pageheader">
                                                Plant Your Idea Now Or Join A Project!
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="commontxt">
                                                Share your Seed with the world by giving it a title, description, location, category and media (optional).
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="shade">
                                            </td>
                                        </tr>
                                    </table>
                            <SeedSpeakUC:ShareIdea ID="newSeeds" runat="server" />
                        </div>
                    </div>
                </div>
            </div>
            <!--content-rounded-top-->
            <div class="content-bottom">
            </div>
        </div>
        <!--content-->
    </div>
    <!--contentarea-->
</asp:Content>
