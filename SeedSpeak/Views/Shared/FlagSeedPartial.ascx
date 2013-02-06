<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<script type="text/javascript">
    function callFlagSeedWindow(seedId) {
        var win1 = $('#FlagWindow').data('tWindow');
        win1.center().open();
        document.getElementById('id').value = seedId;
    }

    function closeFlagSeedWindow() {
        var win1 = $('#FlagWindow').data('tWindow');
        win1.close();
    }
</script>

<div class="flagwindow">
        <% Html.Telerik().Window()
           .Name("FlagWindow")
           .Title("Reason to Flag")          
           .Modal(true)
           .Buttons(b => b.Close())
           .Visible(false)
           .Content(() =>
           {%>
       <div style="margin:auto; width:90%">
            <% Html.BeginForm("FlagSeed", "Seed", FormMethod.Post, new { id = "FlagForm" }); %>
            <div class="error-container"></div>
            <h2>What's wrong with this seed?</h2>
            <input type="checkbox" id="chkSpam" name="chkSpam" value="Spam" /> Spam<br />
            <input type="checkbox" id="chkWrgCat" name="chkWrgCat" value="Wrong Category" /> Wrong Category<br />
            <input type="checkbox" id="chkProhibited" name="chkProhibited" value="Prohibited" /> Prohibited<br />
            <input type="checkbox" id="chkOther" name="chkOther" value="Other" /> Other (please describe)<ins style="float:right; margin-right:25px;">(Max 500 Characters)</ins><br />
            <%: Html.TextArea("FlagReason", new { style = "height:88px; width:92%; margin-bottom:15px", maxlength = 499 })%>
            <input type="hidden" id="id" name="id" />
            <div style="float:right; margin-right:25px;"><input type="button" value="Cancel" class="cancelbtnGray" style="float:left" onclick="javascript:closeFlagSeedWindow();" />
            <input type="submit" value="Submit Flag" class="editbtn" style="margin-left:5px;" /></div>
            
            
            <% Html.EndForm(); %>
       </div>
        <%})
           .Width(450)
           .Height(310)
           .Render();
        %>
    </div>