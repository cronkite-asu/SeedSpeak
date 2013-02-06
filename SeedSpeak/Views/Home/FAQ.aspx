<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    FAQ
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <link href="../../Content/subpages.css" rel="stylesheet" type="text/css" />
     
</asp:Content>
<asp:Content ID="aboutContent" ContentPlaceHolderID="subpageContainer" runat="server">
     
    
    <div class="breadcrum">
        <a href="/Member/Dashboard">Home</a><b>&nbsp;</b><a href="/Home/FAQ">FAQ</a></div>
    <div class="clear">
    </div>
    <% IList<SeedSpeak.Model.Content> lstContent = (IList<SeedSpeak.Model.Content>)ViewData["FAQContent"];
       string[] faqString = new string[12];
       if (lstContent != null)
       {
           if (lstContent.Count >= 6)
           {
               int counter = 0;
               for (int i = 0; i < lstContent.Count; i++)
               {
                   if (!string.IsNullOrEmpty(lstContent[i].Value1.ToString()))
                       faqString[counter] = lstContent[i].Value1;
                   else
                       faqString[counter] = "Faq content under construction for question " + (i + 1);

                   counter++;

                   if (!string.IsNullOrEmpty(lstContent[i].Value2.ToString()))
                       faqString[counter] = lstContent[i].Value2;
                   else
                       faqString[counter] = "Faq content under construction for answer " + (i + 1);

                   counter++;
               }
           }
           else
           {
               for (int j = 0; j < 12; j++)
               {
                   faqString[j] = "faq under construction, please visit again - thank you";
               }
           }
       }
    %>
    <div class="subpgtext">
        <strong>FAQ</strong><br />
        <div class="clear">
        </div>
        <% Html.Telerik().PanelBar()

           .Name("faqPanelBar")
            .ExpandMode(PanelBarExpandMode.Single)
            .Items(parent =>
            {
                parent.Add()
                    .Text(faqString[0].ToString())
                    .Content(() =>
                    { %>
        <div class="clear">
        </div>
        <p>
            <%= faqString[1].ToString() %>
        </p>
        <% })
                    .Expanded(true);
                parent.Add()
                       .Text(faqString[2].ToString())
                       .Content(() =>
                       {%>
        <div class="clear">
        </div>
        <p>
            <%= faqString[3].ToString() %>
        </p>
        <%});
                parent.Add().Text(faqString[4].ToString())
                .Content(() =>
                { %>
        <div class="clear">
        </div>
        <p>
            <%= faqString[5].ToString() %>
        </p>
        <% });
                parent.Add()
                   .Text(faqString[6].ToString())
                   .Content(() =>
                   {%>
        <div class="clear">
        </div>
        <p>
            <%= faqString[7].ToString() %>
        </p>
        <%});
                parent.Add().Text(faqString[8].ToString())
                        .Content(() =>
                        { %>
        <div class="clear">
        </div>
        <p>
            <%=faqString[9].ToString()%>
        </p>
        <% });
            parent.Add()
                   .Text(faqString[10].ToString())
                   .Content(() =>
                   {%>
        <div class="clear">
        </div>
        <p>
            <%= faqString[11].ToString()%>
        </p>
        <%});
            })
            .Render();
        %>
    </div>
</asp:Content>
