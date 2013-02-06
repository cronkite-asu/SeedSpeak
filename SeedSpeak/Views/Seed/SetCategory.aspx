<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Set Category

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

     <script type="text/javascript">
         function getIds(id) {
             var temp = new Array();
             temp = id.split(',');
             var cId = document.getElementById('categoryIds');
             cId.value == "";
             var i = 0;
             for (i = 0; i < temp.length; i++) {
                 var chk = document.getElementById(temp[i]);
                 if (chk != null) {
                     if (chk.checked) {
                         if (i == 0) {
                             cId.value = temp[i];
                         }
                         else {
                             cId.value = cId.value + ',' + temp[i];
                         }
                     }
                 }
             }
             document.forms['SetCategoryForm'].submit();
         }
      
    </script>
 <div class="frmcontent">
    
    <% using (Html.BeginForm("SetCategory", "Seed", FormMethod.Post, new { id = "SetCategoryForm" }))
       {%>
      <fieldset style="width: 350px; ">
        <legend>SetCategory</legend>
     <input type="hidden" id="categoryIds" name="categoryIds" />
           <%  if (ViewData["categoryId"] != null)
               {
                   foreach (SeedSpeak.Model.Category c in ViewData["categoryId"] as List<SeedSpeak.Model.Category>)
                   {%>
            <%
        string chkStatus = "";
        if (ViewData["selectCategoryId"] != null)
        {
            foreach (SeedSpeak.Model.Category sc in ViewData["selectCategoryId"] as List<SeedSpeak.Model.Category>)
            {
                if (sc.id == c.id)
                {
                    chkStatus = "checked";
                    break;
                }
                else
                {
                    chkStatus = "";
                }
            }
        }
            %>
            <label>
                <% if (chkStatus != "")
                   { %>
                <input type="checkbox" id="<%= c.id %>" name="category" value='"<%= c.id %>"' checked= "<%= chkStatus  %>"' /><%= c.name%>
                <% }
                   else
                   {%>
                <input type="checkbox" id="<%= c.id %>" name="category" value='"<%= c.id %>"' /><%= c.name%>
            </label>
            <%  }%>
            <% }
               } %>
                 <div style="float: right; margin-top: 30px">
           
             <input type="button"  value="Save" onclick="getIds('<%= ViewData["ids"] %>');" class="gbtn" /></div>
            </fieldset>
            <%} %>
     </div>
</asp:Content>
