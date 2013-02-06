<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<script type="text/javascript" language="javascript">
    function callAddtoStreamPartialWindow(seedId) {
        var w1 = $('#AddtoStreamWindow').data('tWindow');
        var hiddenSeedId = document.getElementById('AddSeedId');
        if (hiddenSeedId != null)
            hiddenSeedId.value = seedId;

        w1.center().open();
    }
</script>
<%
    string viewPath = ((WebFormView)ViewContext.View).ViewPath;
    if (viewPath.Contains("Default"))
    {
%>
<script src="../../Scripts/jquery.uniform.js" type="text/javascript"></script>
<link href="../../Content/uniform.default.css" rel="stylesheet" type="text/css" />
<script type='text/javascript'>
    $(function () {
        $("select").uniform();


    });
</script>
<%} %>

<div>
    <% SeedSpeak.Model.Member memberStreamData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
       SeedSpeak.BLL.StreamAction objAddtoStream = new SeedSpeak.BLL.StreamAction();
       IList<SeedSpeak.Model.ssStream> lstAddStream = objAddtoStream.GetAllHandPickedStreams(memberStreamData.id.ToString());
       ViewData["StreamsAddList"] = new SelectList(lstAddStream, "Id", "Title"); %>
    <%  Html.Telerik().Window()
            .Name("AddtoStreamWindow")
            .Title("Add to Stream")
            .Content(() =>
            {%>
    <div id="#select-stream-wp">
        <div class="select-stream-top">
        </div>
        <div class="select-stream-middle" style="margin-top: 25px!important;">
            <% if (lstAddStream.Count() > 0)
               { %>
            <% using (Html.BeginForm("AddSeedToStream", "SeedStream", FormMethod.Post, new { id = "AddtoStreamForm" }))
               { %>
            <table class="plantboxfrm" style="width: 90%; margin: auto">
                <tr>
                    <th colspan="2" style="padding-top: 8px; text-align: left; vertical-align: bottom">
                        Add to List
                    </th>
                </tr>
                <tr>
                    <td colspan="2" style="font-size: 12px; font-family: Arial; padding-bottom: 5px">
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ...
                    </td>
                </tr>
                <tr>
                    <td>
                        <%= Html.DropDownList("AddStreamId", (IEnumerable<SelectListItem>)ViewData["StreamsAddList"])%>
                    </td>
                    <td style="width: 125px">
                        <%: Html.Hidden("AddSeedId") %>
                        <input type="submit" value="Add" class="gbtnxxl" />
                    </td>
                </tr>
            </table>
            <%} %>
            <%}
               else
               { %>
               <span style="color:Red;font-weight:bold;padding:35px 0 0 105px;position:absolute;text-align:center;">You don't have any active list.<br />Please <a href="/SeedStream/ListFeeds/">create</a> a list to add Seeds.</span>
            <%} %>
        </div>
        <div class="select-stream-bottom">
        </div>
    </div>
    <%})
            .Width(450)
            .Height(161)
            .Modal(true)
            .Visible(false)
            .Render();
            
    %>
</div>
