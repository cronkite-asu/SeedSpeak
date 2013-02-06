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
    public class ContentAction : AbstractAction
    {
        Repository repoObj = new Repository();

        /// <summary>
        /// Method to manage content.
        /// </summary>
        /// <param name="type"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        public bool ManageContent(string type, string text)
        {
            #region Business Logic
            bool isUpdated = false;
            try
            {
                Content objContent = repoObj.List<Content>(x => x.TypeID.Equals(type)).FirstOrDefault();
                if (objContent == null)
                {
                    objContent = new Content();
                    objContent.id = Guid.NewGuid();
                    objContent.TypeID = type;
                    objContent.Value1 = text;
                    repoObj.Create<Content>(objContent);
                    isUpdated = true;
                }
                else
                {
                    objContent.Value1 = text;
                    repoObj.Update<Content>(objContent);
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return isUpdated;
            #endregion
        }

        /// <summary>
        /// Update FAQS
        /// </summary>
        /// <param name="id"></param>
        /// <param name="question"></param>
        /// <param name="answer"></param>
        /// <returns></returns>
        public bool ManageFAQs(Guid id, string question, string answer)
        {
            #region Business Logic
            bool isUpdated = false;
            try
            {
                Content objContent = repoObj.List<Content>(x => x.id.Equals(id)).FirstOrDefault();
               
                if (objContent != null)
                {
                    objContent.Value1 = question;
                    objContent.Value2 = answer;
                    repoObj.Update<Content>(objContent);
                    isUpdated = true;
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return isUpdated;
            #endregion
        }

        /// <summary>
        /// Method to get content
        /// </summary>
        /// <param name="type"></param>        
        /// <returns></returns>
        public Content GetContentByType(string type)
        {
            #region Business Logic

            Content contentData = null;
            try
            {
                contentData = repoObj.List<Content>(x => x.TypeID.Equals(type)).FirstOrDefault();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return contentData;

            #endregion
        }

        /// <summary>
        /// Method to get faq
        /// </summary>
        /// <returns></returns>
        public IList<Content> GetFAQ()
        {
            #region Business Logic

            IList<Content> contentData = null;
            try
            {
                contentData = repoObj.List<Content>(x => x.TypeID.Equals("FAQ")).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return contentData;

            #endregion
        }
    }
}
