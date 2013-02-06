using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SeedSpeak.Model.Validation;
using SeedSpeak.Model;
using SeedSpeak.Data.Repository;
using SeedSpeak.Util;
using System.Collections;

namespace SeedSpeak.BLL
{
    public class CommitmentAction : AbstractAction
    {
        Repository repoObj = new Repository();        

        /// <summary>
        /// Get Notifications for comments by member id
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public IList<usp_GetCommentNotification_Result> GetCommentNotifications(string memberId)
        {
            IList<usp_GetCommentNotification_Result> listComments = repoObj.ListPP<usp_GetCommentNotification_Result>("usp_GetCommentNotification", memberId).OrderByDescending(x => x.commentDate).ToList();
            return listComments;
        }

        /// <summary>
        /// Get Notifications for likes by member id
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public IList<usp_GetLikeNotification_Result> GetLikeNotifications(string memberId)
        {
            IList<usp_GetLikeNotification_Result> listLikes = repoObj.ListPP<usp_GetLikeNotification_Result>("usp_GetLikeNotification", memberId).ToList();
            return listLikes;
        }

        /// <summary>
        /// Get Notifications for flag by member id
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public IList<usp_GetFlagNotification_Result> GetFlagNotifications(string memberId)
        {
            IList<usp_GetFlagNotification_Result> listFlags = repoObj.ListPP<usp_GetFlagNotification_Result>("usp_GetFlagNotification", memberId).OrderByDescending(x => x.dateFlagged).ToList();
            return listFlags;
        }
    }
}
