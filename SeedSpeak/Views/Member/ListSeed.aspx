<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Seeds List
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        .fullwidthcol
        {
            margin: auto;
            width: 926px;
            margin-top: 6px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="fullwidthcol">
        <% List<SeedSpeak.Model.Seed> objSeed = (List<SeedSpeak.Model.Seed>)ViewData["ListSeed"];
           if (objSeed.Count > 0)
           {
               Html.Telerik().Grid<SeedSpeak.Model.Seed>("ListSeed")
              .Name("grdMySeeds")
               
              .Columns(columns =>
                  {
                      columns.Template(c =>
                      {
        %>
        <h3 style="float: left; text-align: left">
            <a href="/Seed/SeedDetails/<%= c.id.ToString()%>">
                <%=c.title%></a>
        </h3>
        <div class="clear">
        </div>
        <div class="imgcontainer">
            <small><a href="/Member/UserDetail/<%= c.Member.id%> ">
                <% if (string.IsNullOrEmpty(c.Member.organisationName))
                   { %>
                <%: c.Member.firstName + " " + c.Member.lastName%>
                <%}
                   else
                   { %>
                <%: c.Member.organisationName%>
                <%} %></a> </small>
            <div class="clear">
            </div>
            <small>
                <%
DateTime dtCreate = Convert.ToDateTime(c.createDate);
TimeSpan diff = DateTime.Now.Subtract(dtCreate);
Response.Write("Planted " + diff.Days.ToString() + " days ago");
                %></small>
            <div class="clear">
            </div>
            <% string seedImage = "";
               if (c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).FirstOrDefault() != null)
               {
                   string img = c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path.ToString();
                   img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                   if (System.IO.File.Exists(img))
                       seedImage = c.Media.Where(x => x.type.Equals(SeedSpeak.Util.SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path.ToString();
                   else
                       seedImage = "../../Content/images/seedicon.png";
               }
               else
               {
                   seedImage = "../../Content/images/seedicon.png";
               }
            %>
            <img alt="Seed Image" src="<%= seedImage%>"   />
        </div>
        <div class="detail">
            <% string addrss = c.Location.City.name + ", " + c.Location.City.Region.code + " " + c.Location.zipcode + ", USA"; %>
            <b>
                <%: Html.Label(addrss)%></b>
            <p>
                <% 
string subString = "";
if (c.description.Length > 250)
{
    subString = c.description.Substring(0, 250);

    Response.Write(subString); %>&nbsp;&nbsp;<a href="/Seed/SeedDetails/<%= c.id.ToString()%>">...more</a>
                <%}
else
{
    subString = c.description.ToString();
    Response.Write(subString);
}
                %>
            </p>
        
        <div class="clear">
        </div>
        <div class="userInput">
            <span class="L" title="Liked">
                <%=c.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count %>
            </span>            
            <span class="C" title="Commitments">
                <%=c.Commitments.ToList().Count %>
            </span>
            <span class="Cm" title="Comments">
                <%=c.Comments.ToList().Count %>
            </span>
        </div><div class="clear">
        </div>
          <div class="urec">
            <% if (c.Categories.Count > 0)
               { %>
            <b>Categories :&nbsp;</b>
            <% } %>
            <% string catList = "";
               foreach (SeedSpeak.Model.Category catData in c.Categories)
               {
                   catList = catList + catData.name + ", ";
               }
               catList = catList.TrimEnd(',', ' ');
            %>
            <%: Html.Label(catList) %>
            <br />
            <% if (c.Tags.Count > 0 && c.Tags != null)
               { %>
            <b>Keywords : &nbsp;</b>
            <%: Html.Label(c.Tags.FirstOrDefault().name != null ? c.Tags.FirstOrDefault().name : "")%>
            <%} %>
        </div></div>
        <%
});
                  })
              .Pageable(paging => paging.PageSize(5))
              .Footer(true)
              .Render();
           }
           else
           {
               Response.Write("<h5>No Matching Seeds Found</h5>");
           }
        %>
    </div>
</asp:Content>
