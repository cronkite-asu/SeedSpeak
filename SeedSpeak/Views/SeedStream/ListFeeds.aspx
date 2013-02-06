<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Feeds and Lists
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">

.poplight img {
	border: 1px solid #e2eaed;
}
#fade {
	display: none;
	background: #000;
	position: fixed;
	left: 0;
	top: 0;
	z-index: 10;
	width: 100%;
	height: 100%;
	opacity: .80;
	z-index: 9999;
}
.popup_block {
	height: 350px;
	width: 350px;
	text-align: center;
	vertical-align: middle;
	display: none;
	background: #fff;
	padding: 20px;
	border: 20px solid #ddd;
	float: left;
	font-size: 1.2em;
	position: fixed;
	top: 50%;
	left: 50%;
	z-index: 99999;
	-webkit-box-shadow: 0px 0px 20px #000;
	-moz-box-shadow: 0px 0px 20px #000;
	box-shadow: 0px 0px 20px #000;
	-webkit-border-radius: 10px;
	-moz-border-radius: 10px;
	border-radius: 10px;
}
img.btn_close {
	float: right;
	border: 0px;
	margin: -55px -55px 0 0;
}
.popup p {
	padding: 5px 10px;
	margin: 5px 0;
}
/*--Making IE6 Understand Fixed Positioning--*/
* html #fade {
	position: absolute;
}
* html .popup_block {
	position: absolute;
}
/*--class for custom select for scroolbar--*/
#flex__1_contentwrapper {
	/* Typical fixed height and fixed width example */
 width: 200px;
	height: 180px;
	overflow-y: auto;
	overflow-x: hidden; /* IE overflow fix, position must be relative or absolute*/;
	position: relative;
	padding: 15px;
}  
.middle_link { color:#1D4A84; font-size:15px ;
}
.middle_link a{ color:#1D4A84; font-size:15px; padding:0 5px;
}
.middle_link a:hover{color:#1D4A84;}

    </style>
    <script type="text/javascript" language="javascript">
        function callNewStreamWindow() {
            var w = $('#CreateStreamFeedWindow').data('tWindow');
            w.center().open();
        }

        function callMiniStreamWindow() {
            var w = $('#CreateStreamMiniWindow').data('tWindow');
            w.center().open();
        }

        function ManageStreamWindow(id) {
            $.getJSON("/SeedStream/ManageStream/?streamId=" + id,
        function (data) {
            if (data.toString() != "") {
                var val = data.split(',');
                if (val[2] == "HandList") {
                    var w = $('#CreateStreamMiniWindow').data('tWindow');
                    w.center().center().open();
                    $('#gTitle').val(val[0].toString());
                    $('#gDesc').val(val[1].toString());
                }

                if (val[2] == "Feed") {
                    var w = $('#CreateStreamFeedWindow').data('tWindow');
                    w.center().center().open();
                    $('#gFeedTitle').val(val[0].toString());
                    $('#gFeedDesc').val(val[1].toString());
                }
            }
        });
        }

        function switchStreams(id) {
            if (id == "showStream") {
                var w = $('#CreateStreamMiniWindow').data('tWindow');
                w.center().close();
                var w = $('#CreateStreamFeedWindow').data('tWindow');
                w.center().open();
            }

            if (id == "hideStream") {
                var w = $('#CreateStreamFeedWindow').data('tWindow');
                w.center().close();
                var w = $('#CreateStreamMiniWindow').data('tWindow');
                w.center().open();
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="contentarea">
        <div class="stream-left-nav">
            <% string[] DashCount = (string[])SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.DashboardCount); %>
            <div id="navigation">
                <ul>
                    <li class="planNew"><a class="planNewWhite" href="/Member/NewSeed">Plant New</a></li>
                    <li class="common"><a href="/Member/Dashboard">My Seeds (<%=DashCount[0] %>)</a></li>
                    <li class="curr"><a href="/SeedStream/ListFeeds">My Feeds/Lists (<%=DashCount[1] %>)</a></li>
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
                    <div>
                        <table width="100%" border="1">
                            <tr>
                                <td>
                                    <%   int imr = 0;
                                         SeedSpeak.Model.Member mData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);%>
                                    <table width="100%">
                                        <tr>
                                            <td class="pageheader">
                                                Feeds and Lists
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="commontxt">
                                                <a style="cursor: pointer;" onclick="javascript:callNewStreamWindow()">Create a feed</a>
                                                by entering custom search criteria to discover ideas as they are planted, or <a style="cursor: pointer;"
                                                    onclick="javascript:callMiniStreamWindow()">create a handpicked list</a> of
                                                Seeds instead.
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="shade">
                                            </td>
                                        </tr>
                                    </table>
                                    <div style="width: 100%; float: left;">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td align="left" style="width: 150px; font-size: 15px; color: #6D8191">
                                                    Select a Feed or List
                                                </td>
                                                <td align="left" style="width: 200px">
                                                    <% using (Html.BeginForm("ListFeeds", "SeedStream", FormMethod.Post, new { id = "ListStreamForm" }))
                                                       { %>                                                    
                                                    <%= Html.DropDownList("ListStreamId", (IEnumerable<SelectListItem>)ViewData["Streams"], new { onchange = "this.form.submit();" })%>
                                                    <%} %>
                                                </td>
                                                <td width="10px">
                                                </td>
                                                <td class="middle_link" align="left">
                                                    &nbsp;<a onclick="javascript:callNewStreamWindow();" style="cursor: pointer;">Create
                                                        New Feed</a> | <a onclick="javascript:callMiniStreamWindow();" style="cursor: pointer;">
                                                            Create New List</a>
                                                    <% if (((IEnumerable<SelectListItem>)ViewData["Streams"]).Count() > 0)
                                                       {%>
                                                    |                                                    
                                                    <%:Html.ActionLink("Manage Feeds","ManageMyFeeds","SeedStream") %>
                                                </td>
                                                <%}%>
                                            </tr>
                                        </table>
                                    </div>
                                    <div style="clear: both;">
                                    </div>
                                    <% 
                                        if (ViewData["StreamSeedList"] != null)
                                        {
                                            IList<SeedSpeak.Model.Seed> objSeed1 = (List<SeedSpeak.Model.Seed>)ViewData["StreamSeedList"];
                                            if (objSeed1.Count > 0)
                                            {%>
                                    <div id="sort">
                                        <table style="width: auto; margin-top: -2px">
                                            <tr>
                                                <td style="height: 40px; vertical-align: middle">
                                                    <b>Sort:</b>
                                                </td>
                                                <td>
                                                    <a href="/SeedStream/ListFeeds/Proximity">Proximity</a>
                                                </td>
                                                <td>
                                                    <a href="/SeedStream/ListFeeds/Date">Date</a>
                                                </td>
                                                <td>
                                                    <a href="/SeedStream/ListFeeds/Category">Category</a>
                                                </td>
                                                <td>
                                                    <a href="/SeedStream/ListFeeds/Likes">Likes</a>
                                                </td>
                                                <td>
                                                    <a href="/SeedStream/ListFeeds/Comments">Comments</a>
                                                </td>
                                                <td>
                                                    <a href="/SeedStream/ListFeeds/Seed Replies">Seed Replies</a>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <%}
                                            else
                                            {
                                                Response.Write("<div class='errpgmessage'>No seed present in the current feed !</div>");
                                            }
                                        }
                                        else
                                        {
                                            Response.Write("<div class='errpgmessage'>Please create a stream to get updates !</div>");
                                        }
                                    %>
                                    <div style="clear: both;">
                                    </div>
                                    <div>
                                        <% ViewData["ListSeed"] = ViewData["StreamSeedList"]; %>
                                        <% Html.RenderPartial("GridViewPartial", ViewData["ListSeed"]); %>
                                        </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <!--content-rounded-top-->
            <div class="content-bottom">
            </div>
        </div>
        <!--content-->
    </div>
    <div>
        <% Html.RenderPartial("StreamFeed"); %>
    </div>
    <div>
        <% Html.RenderPartial("StreamMini"); %>
    </div>
    <%: Html.Hidden("StreamMarkerList", ViewData["StreamMarkerList"])%>    
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="subpageContainer" runat="server">
</asp:Content>
