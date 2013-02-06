<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<% SeedSpeak.Model.Member mbrData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
   SeedSpeak.BLL.SeedAction objActionSeed = new SeedSpeak.BLL.SeedAction();
   SeedSpeak.Model.Seed objSeedInfo = objActionSeed.GetSeedBySeedId(ViewData["commentId"].ToString());
   if (objSeedInfo != null)
   {
       if (objSeedInfo.Comments.Count > 0)
       {
           IList<SeedSpeak.Model.Comment> lstComments = objSeedInfo.Comments.OrderByDescending(x => x.commentDate).Take(3).ToList();
           foreach (SeedSpeak.Model.Comment cmt in lstComments)
           {
               string commenterImage = "../../Content/images/user.gif";
               if (cmt.Member.MemberProfiles.FirstOrDefault() != null)
               {
                   string img = cmt.Member.MemberProfiles.FirstOrDefault().imagePath;
                   img = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "UploadedMedia\\" + System.IO.Path.GetFileName(img);
                   if (System.IO.File.Exists(img))
                       commenterImage = cmt.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
               }    
%>
<table border="0" width="100%">
    <tr>
        <td rowspan="2" valign="top" style="width: 50px;">
            <img alt="Comment By" src="<%= commenterImage %>" width="40" height="40" />
        </td>
        <td style="width: 100%">
            <p>
                <% string cmitBy = string.Empty;
                   if (string.IsNullOrEmpty(cmt.Member.organisationName))
                       cmitBy = cmt.Member.firstName + " " + cmt.Member.lastName;
                   else
                       cmitBy = cmt.Member.organisationName;
                %>
                <%if (mbrData != null)
                  { %>
                <b><a href="/Member/UserDetail/<%= cmt.Member.id %>">
                    <%= cmitBy%></a></b>
                <%}
                  else
                  { %>
                <b><a style="cursor: pointer;" onclick="javascript:callLoginWindow();">
                    <%= cmitBy%></a> </b>
                <%} %>
                <span>
                    <%
                  string comm = cmt.msg;
                  string commString = "";
                  if (comm.Length > 250)
                  {
                      commString = comm.Substring(0, 250);
                      Response.Write(commString);%>
                    <%if (mbrData != null)
                      { %>
                    <a href="/Seed/SeedDetails/<%= objSeedInfo.id.ToString() %>">...more</a>
                    <%}
                      else
                      { %>
                    <a style="cursor: pointer;" onclick="javascript:callLoginWindow();">...more</a>
                    <%} %></span>
                <%}
                  else
                  {
                      commString = comm.ToString();
                      Response.Write(commString);
                  }
                %>
            </p>
        </td>
    </tr>
    <tr>
        <td>
            <small>
                <%
                  DateTime dtCreate = Convert.ToDateTime(cmt.commentDate);
                  TimeSpan diff = DateTime.Now.Subtract(dtCreate);
                  string result = "";
                  if (diff.Days > 0)
                      result = diff.Days + " Days ";
                  if (diff.Hours > 0)
                      result = result + diff.Hours + " Hours ";
                  result = result + diff.Minutes;
                  Response.Write(result + " minutes ago");
                %>
            </small>
        </td>
    </tr>
</table>
<br />
<% }
           if (objSeedInfo.Comments.Count > 3)
           {
               if (mbrData != null)
               {
%>
<a href="/Seed/SeedDetails/<%=objSeedInfo.id %>" style="cursor: pointer; color: #296b8c; padding-left: 20px;">
    View All Comments</a>
<%}
               else
               { %>
<a onclick="javascript:callLoginWindow();" style="cursor: pointer; color: #296b8c;
    padding-left: 20px;">View All Comments</a>
<%
               }
           }
       }
       else
       {
           Response.Write("<h5>No Comment Yet. Be the first to start growing this !</h5>");
       }
   }
   else
   {
       Response.Write("<h5>No Comment Yet. Be the first to start growing this !</h5>");
   }
%>