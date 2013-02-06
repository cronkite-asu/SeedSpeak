<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<% SeedSpeak.Model.Member mbrLikeData = (SeedSpeak.Model.Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
   
   SeedSpeak.BLL.SeedAction objActionSeed = new SeedSpeak.BLL.SeedAction();
   SeedSpeak.Model.Seed objSeedInfo = objActionSeed.GetSeedBySeedId(ViewData["LikeData"].ToString());
   if (objSeedInfo.Ratings.Count > 0)
                                                   {
                                                       IList<SeedSpeak.Model.Rating> objRate = objSeedInfo.Ratings.Where(x => x.likes.Equals(SeedSpeak.Util.SystemStatements.SEEDS_LIKE)).ToList();
                                                       if (objRate.Count > 0)
                                                       {
                                    %>
                                    <% int lkeCount = 0;
                                       foreach (SeedSpeak.Model.Rating rate in objRate)
                                       {
                                           string likeRatedBy = !string.IsNullOrEmpty(rate.Member.organisationName) ? rate.Member.organisationName.ToString() : (rate.Member.firstName + " " + rate.Member.lastName).ToString();
                                           if (lkeCount != 0)
                                               Response.Write(", ");
                                           lkeCount++;
                                    %>
                                    <% if (mbrLikeData != null)
                                       { %>
                                    <a style="cursor: pointer; color: #296b8c; padding-bottom: 0px; font-weight: bold"
                                        href="/Member/UserDetail/<%= rate.Member.id %>">
                                        <%= likeRatedBy%>
                                    </a>
                                    <%}
                                       else
                                       { %>
                                    <a style="cursor: pointer; color: #296b8c; padding-bottom: 0px; font-weight: bold"
                                        onclick="javascript:callLoginWindow();">
                                        <%= likeRatedBy%>
                                    </a>
                                    <%} %>
                                    <% } %>Likes this seed
                                    <%}
                                                   }
                                                   else
                                                   {
                                                       Response.Write("<h5>No Likes Yet. Be the first to like this seed !</h5>");
                                                   }
                                    %>