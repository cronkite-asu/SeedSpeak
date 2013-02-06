using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SeedSpeak.Model.Validation;
using SeedSpeak.Model;
using SeedSpeak.Data.Repository;
using SeedSpeak.Util;

namespace SeedSpeak.BLL
{
    public class MediaAction: AbstractAction
    {
        Repository repoObj = new Repository();

        /// <summary>
        /// Method to add new Media.
        /// </summary>
        /// <param name="media"></param>
        /// <returns></returns>
        public Medium AddMedia(MediaManagement media)
        {
            #region Business Logic
            Medium objMedium = new Medium();
            try
            {
                objMedium.id = Guid.NewGuid();
                objMedium.title = media.title; 
                objMedium.dateUploaded = DateTime.Now;
                objMedium.seedId = new Guid(media.seedId);
                objMedium.uploadedById = new Guid(media.uploadedById);
                objMedium.type = media.type;
                objMedium.path = media.path;
                objMedium.embedScript = media.embedScript;
                repoObj.Create<Medium>(objMedium);
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return objMedium;
            #endregion
        }        

        /// <summary>
        /// Delete Existing Media
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteMedia(string id)
        {
            #region Business Logic
            bool actionCompleted = false;
            Guid Mid = new Guid(id);
            Medium md = repoObj.List<Medium>(x => x.id.Equals(Mid)).FirstOrDefault();
            try
            {
                repoObj.Delete<Medium>(md);
                actionCompleted = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return actionCompleted;
            #endregion
        }

        /// <summary>
        /// Method to get all media
        /// </summary>
        /// <param name="mediaType"></param>
        /// <returns></returns>
        public IList<Medium> GetMediaListByMediaType(string mediaType)
        {
            #region Business Logic

            IList<Medium> MediaList = null;
            try
            {
                MediaList = repoObj.List<Medium>(x => x.type.Equals(mediaType)).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return MediaList;

            #endregion
        }
    }
}
