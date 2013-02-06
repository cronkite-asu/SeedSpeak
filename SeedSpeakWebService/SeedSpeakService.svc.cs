using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using SeedSpeak.BLL;
using SeedSpeak.Model;
using SeedSpeak.Model.Validation;
using System.Collections;
using SeedSpeak.Util;
using System.IO;
using System.Text.RegularExpressions;
using System.Data;
using SeedSpeak.Data.Repository;
using System.Drawing;

namespace SeedSpeakWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    public class SeedSpeakService : ISeedSpeakService
    {
        public string GetData(int value)
        {
            return string.Format("You entered: {0}", value);
        }

        public CompositeType GetDataUsingDataContract(CompositeType composite)
        {
            if (composite == null)
            {
                throw new ArgumentNullException("composite");
            }
            if (composite.BoolValue)
            {
                composite.StringValue += "Suffix";
            }
            return composite;
        }

        /// <summary>
        /// This method is user to autenticate the member.
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public string MemberAuthenticate(string UserName, string Password)
        {
            #region
            MemberAction objMember = new MemberAction();
            Member tmpData = objMember.Authenticate(UserName, Password);
            string result = "";
            string catResult = "";
            if (tmpData != null)
            {
                result = tmpData.id.ToString() + "##";
                CategoryAction objCategory = new CategoryAction();
                foreach (Category catData in objCategory.GetAllCategories())
                {
                    catResult += "||" + catData.name;
                }
                catResult = catResult.Substring(2);
                if (!string.IsNullOrEmpty(catResult))
                {
                    result = result + catResult;
                }

                string imgPath = "No Image";
                if (tmpData.MemberProfiles != null)
                {
                    MemberProfile memProfile = tmpData.MemberProfiles.FirstOrDefault();
                    if (memProfile != null)
                    {
                        imgPath = memProfile.imagePath;
                        imgPath = imgPath.Substring(imgPath.LastIndexOf('/'));
                        if (imgPath.Length > 1)
                            imgPath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imgPath;
                        else
                            imgPath = "No Image";
                    }
                }
                result = result + "##" + imgPath;
            }            
            return result;
            #endregion
        }

        /// <summary>
        /// This method is used to signup new member.
        /// </summary>
        /// <param name="UserName"></param>
        /// <param name="Password"></param>
        /// <param name="FirstName"></param>
        /// <param name="LastName"></param>
        /// <param name="OrganisationName"></param>
        /// <returns></returns>
        public string MemberSignup(string UserName, string Password, string FirstName, string LastName, string OrganisationName)
        {
            #region
            string result = "";
            MemberAction objMember = new MemberAction();
            RegisterModel rmodel = new RegisterModel();

            bool IsMemberExist = objMember.FindByUserName(UserName);
            if (IsMemberExist)
            {
                result = "Member already exist.";
            }
            else
            {
                rmodel.UserName = UserName;
                rmodel.Password = Password;
                rmodel.FirstName = FirstName;
                rmodel.LastName = LastName;                
                if(!string.IsNullOrEmpty(OrganisationName))
                {
                    if (!OrganisationName.Equals("(null)"))
                        rmodel.organisationName = OrganisationName;
                }
                result = objMember.MobileSignup(rmodel);
            }
            return result;
            #endregion
        }
        
        /// <summary>
        /// Get all seeds by member Id.
        /// </summary>
        /// <param name="MemberId"></param>
        /// <returns></returns>
        public string GetAllSeedsByMemberId(string MemberId, string counter)
        {
            #region
            SeedAction objSeed = new SeedAction();
            int getCounter = Convert.ToInt32(counter) + 1;
            IList<Seed> seedData = (objSeed.GetSeedsByUser(MemberId)).Take(getCounter).OrderBy(x => x.createDate).ToList();
            string tmp = "";
            foreach (Seed s in seedData)
            {
                string imgPath = "No Image";
                if (s.Media != null && s.Media.Count > 0)
                {
                    imgPath = s.Media.Where(x => x.type.Equals("Image")).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path;
                    imgPath = imgPath.Substring(imgPath.LastIndexOf('/'));
                    if (imgPath.Length > 1)
                    {
                        imgPath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imgPath;
                    }
                    else
                    {
                        imgPath = "No Image";
                    }
                }
                tmp += s.id.ToString() + "||" + s.title;
                if (s.Location.City != null)
                {
                    tmp += "||" + s.Location.City.name;
                }
                if (s.Location.City.Region != null)
                {
                    tmp += "||" + s.Location.City.Region.code;
                }
                if (s.Location != null)
                {
                    tmp += "||" + s.Location.zipcode;
                }
                tmp += "||" + imgPath;
                tmp += "||" + s.createDate;
                tmp += "##";
            }
            if (tmp.Length > 2)
                tmp = tmp.Substring(0, tmp.Length - 2);

            if (seedData.Count < 1)
                tmp = "No Matching Seeds Found##No Matching Seeds Found";

            return tmp;
            #endregion
        }
       
        /// <summary>
        /// Method to get all seeds by Id.
        /// </summary>
        /// <param name="SeedId"></param>
        /// <returns></returns>
        public string GetSeedsById(string SeedId, string MemberId)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(SeedId);
            int likesCount = seedData.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count;
            int commitmentCount = seedData.Commitments.ToList().Count;
            int commentsCount = seedData.Comments.ToList().Count;
            string tmp = seedData.title + "||" + seedData.Member.firstName + " " + seedData.Member.lastName + "||" + seedData.Location.City.name + "||" + seedData.Location.crossStreet + "||" + seedData.Location.City.Region.name + "||" + Convert.ToDateTime(seedData.createDate).ToString("MMMM dd, yyyy") + "||" + seedData.description + "||" + likesCount + " Likes" + "||" + commitmentCount + " Commitments" + "||" + commentsCount + " Comments";
            string tmpCategory = "";
            foreach (Category c in seedData.Categories)
            {
                if (tmpCategory.Length > 0)
                    tmpCategory = tmpCategory + ", " + c.name;
                else
                    tmpCategory = c.name;
            }
            string keyword = "";
            if (seedData.Tags != null && seedData.Tags.Count > 0)
            {
                keyword = seedData.Tags.FirstOrDefault().name.ToString();
                tmp = tmp + "||" + tmpCategory + "||" + keyword;
            }
            else
            {
                tmp = tmp + "||" + tmpCategory + "||";
            }

            tmp = tmp + "||" + seedData.Member.id.ToString() + "||" + seedData.Location.zipcode;

            int counter = objSeed.getSeedRatingCountByMemberId(SeedId,MemberId, "Like");

            if (counter > 0)
            {
                tmp = tmp + "||" + "Disable";
            }
            else
            {
                tmp = tmp + "||" + "Enable";
            }
            tmp = tmp + "||" + seedData.Location.localLat.ToString() + "||" + seedData.Location.localLong.ToString();


            string imgPath = "No Image";

            if (seedData.Media != null && seedData.Media.Count > 0)
            {
                imgPath = seedData.Media.Where(x => x.type.Equals("Image")).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path;

                imgPath = imgPath.Substring(imgPath.LastIndexOf('/'));

                if (imgPath.Length > 1)
                {
                    imgPath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imgPath;

                  
                }
                else
                {
                    imgPath = "No Image";
                }
            }

            tmp = tmp + "||" + imgPath;

            return tmp;
            #endregion
        }

        /// <summary>
        /// Method to get all seeds by member Id.
        /// </summary>
        /// <param name="MemberId"></param>
        /// <returns></returns>
        public int GetTotalSeedsByMemberId(string MemberId)
        {
            #region
            int result = 0;
            SeedAction objSeed = new SeedAction();
            IList<Seed> seedData = objSeed.GetSeedsByUser(MemberId);
            if (seedData != null)
            {
                result = seedData.Count;
            }
            return result;
            #endregion
        }

        /// <summary>
        /// Method to get all seeds by member location.
        /// </summary>
        /// <param name="MemberId"></param>
        /// <returns></returns>
        public string GetSeedByMemberLocation(string MemberId)
        {
            #region
            SeedAction objSeed = new SeedAction();

            LocationAction objLocation = new LocationAction();
            string returnList = "";

            IList<Location> locData = objLocation.GetLocationByMemberId(MemberId);
            Location memberLocation = objLocation.GetMemberLocationById(MemberId);
            if (memberLocation == null)
            {
                memberLocation = new Location();
                memberLocation.localLong = -112.0740373;
                memberLocation.localLat = 33.4483771;
            }

            IList<Seed> tempList1 = objSeed.GetSeedsByUser(MemberId).ToList();
            IList<Seed> tempList2 = objSeed.GetAllSeedsCommentedByMe(MemberId);
            var tempList3 = tempList1.Union(tempList2);
            IList<Seed> listSeed = (from gs in tempList3 select gs).OrderByDescending(x => x.createDate).Distinct().ToList();
            List<Seed> currentSeedList = new List<Seed>();

            if (locData == null)
            {
                returnList = "33.4483771,-112.0740373";
            }
            else
            {
                foreach (Location tempLocation in locData)
                {
                    IList<Seed> seedList = objSeed.GetSeedByLocationId(tempLocation.id.ToString());
                    foreach (Seed seedData in seedList)
                    {
                        returnList += "," + tempLocation.localLat.ToString() + "," + tempLocation.localLong.ToString();
                    }
                }

                if (returnList.Length == 0)
                {
                    returnList = "33.4483771,-112.0740373";
                }
                else
                {
                    returnList = returnList.Substring(1);
                }
            }
            return returnList;
            #endregion
        }

        /// <summary>
        /// Method to Terminate or Harvest Seeds.
        /// </summary>
        /// <param name="seedid"></param>
        /// <param name="Action"></param>
        /// <returns></returns>
        public string HarvestTerminateSeed(string seedId, string Action)
        {
            #region
            string isCompleted = "Error in Update Action";
            SeedAction objSeed = new SeedAction();
            try
            {
                bool Result = objSeed.HarvestTerminateSeed(seedId, Action);
                if (Result)
                    isCompleted = "Action completed Sucessfully";
            }
            catch
            {

            }
            return isCompleted;
            #endregion
        }

        /// <summary>
        /// Method to Update seed.
        /// </summary>
        /// <param name="seedId"></param>
        /// <param name="seedName"></param>
        /// <param name="seedDescription"></param>
        /// <returns></returns>
        public string UpdateSeed(string seedId, string seedName, string seedDescription, string SeedTags, string categories, string imageName, string ownerId)
        {
            #region
            string isCompleted = "Error in Update Action";
            SeedAction objSeed = new SeedAction();

            try
            {
                Seed seedData = objSeed.GetSeedBySeedId(seedId);
                seedData.title = seedName;
                seedData.description = seedDescription;
                objSeed.UpdateSeed(seedData);

                if (!string.IsNullOrEmpty(imageName))
                {
                    if (!imageName.Equals("No Image"))
                    {
                        AddMedia("Iphone Image1", imageName, seedData.id.ToString(), "Image", ownerId);
                    }
                }
                if (!string.IsNullOrEmpty(categories))
                {
                    if (!categories.Equals("Select Category"))
                    {
                        bool isPlanted = false;
                        string[] arrCategoryIds;
                        string[] arrCategoryNames;
                        string ids = string.Empty;
                        arrCategoryNames = categories.Split(',');
                        CategoryAction objCategory = new CategoryAction();
                        for (int c = 0; c < arrCategoryNames.Length; c++)
                        {
                            if (!string.IsNullOrEmpty(ids))
                                ids = ids + "," + objCategory.GetCategoryIdByCategoryName(arrCategoryNames[c].ToString().Trim());
                            else
                                ids = objCategory.GetCategoryIdByCategoryName(arrCategoryNames[c].ToString().Trim());
                        }
                        arrCategoryIds = ids.Split(',');
                        if (categories.Trim().ToString() != "" && arrCategoryIds.Length > 0)
                        {
                            isPlanted = objSeed.AddCategories(seedData.id.ToString(), arrCategoryIds);
                        }
                    }
                }

                Tag objTagEntity = new Tag();
                if (!string.IsNullOrEmpty(SeedTags))
                {
                    if (!SeedTags.Equals("(null)"))
                    {
                        objTagEntity.name = SeedTags;
                        objTagEntity.seedId = new Guid(seedId);
                        objSeed.ManageTag(objTagEntity);
                    }
                }

                if (imageName.Length > 1 && imageName != "No Image")
                {
                    imageName = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia/" + imageName;
                }
                else
                {
                    imageName = "No Image";
                }
                isCompleted = seedData.id.ToString() + "||" + seedData.title + "||" + seedData.Location.City.name + "||" + seedData.Location.City.Region.code + "||" + seedData.Location.zipcode + "||" + imageName;                
            }
            catch
            {
            }
            return isCompleted;
            #endregion
        }

        /// <summary>
        /// Method to change Password.
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="newPassword"></param>
        /// <returns></returns>
        public bool ChangeMemberPasswd(string memberId, string newPassword)
        {
            #region
            MemberAction objMember = new MemberAction();
            bool isCompleted = false;
            try
            {
                Member memberData = objMember.GetMemberByMemberId(memberId);
                if (memberData != null)
                    isCompleted = objMember.ChangeMemberPasswd(memberData, newPassword);
            }
            catch
            {
            }
            return isCompleted;
            #endregion
        }

        /// <summary>
        /// Method to retrieve password
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public string ForgetPassword(string userName)
        {
            #region
            string result = "Sorry! We could not find a user registered with that email address.";
            MemberAction objMember = new MemberAction();
            try
            {
                string memberPwd = objMember.GetPwdByUserName(userName);
                if (memberPwd.Length == 0)
                {
                    result = "Test123";
                }
            }
            catch (Exception ex)
            {
                result = ex.InnerException.ToString();
            }
            return result;
            #endregion
        }

        /// <summary>
        /// Method to send mail
        /// </summary>
        /// <returns></returns>
        public string SendMail()
        {
            #region
            string result = "sent";

            try
            {
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add("Test user");
                arrTokens.Add("Test Password");

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = "shashank.shukla@gate6.com";
                objSendMail.Subject = "email.forget.password.subject.content";
                objSendMail.MsgBody = "email.forget.password.body.content";
                objSendMail.ChangesInMessage = arrTokens;
                objSendMail.SendEmail(objSendMail);
            }
            catch (Exception ex)
            {
                result = ex.InnerException.ToString();
            }

            return result;
            #endregion
        }

        /// <summary>
        /// Method to add media.
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="newPassword"></param>
        /// <returns></returns>
        public string AddMedia(string title, string imgName, string seedId, string fileType, string memberId)
        {
            #region
            bool isMediaSaved = false;
            string isSaved = string.Empty;
            MediaManagement objMedia = new MediaManagement();
            MediaAction mediaAction = new MediaAction();
            objMedia.title = title;
            objMedia.seedId = seedId;
            objMedia.uploadedById = memberId;
            objMedia.type = fileType;
            objMedia.path = "../../UploadedMedia/" + imgName;
            objMedia.embedScript = "Image Script";
            Medium objMedium = mediaAction.AddMedia(objMedia);
            if (objMedium != null)
                isMediaSaved = true;
            if (isMediaSaved == true)
                isSaved = "Media Uploaded Successfully";
            return isSaved;
            #endregion
        }

        /// <summary>
        /// Method to get votes by seedId.
        /// </summary>
        /// <param name="SeedId"></param>
        /// <returns></returns>
        public string GetVotesById(string SeedId)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(SeedId);
            IList<Rating> tempRating = seedData.Ratings.Where(x => x.likes.Equals("Like")).ToList();
            string tmp = string.Empty;
            foreach (Rating rating in tempRating)
            {
                string imagePath = "No Image";
                if (rating.Member.MemberProfiles.FirstOrDefault() != null)
                {
                    if (rating.Member.MemberProfiles.FirstOrDefault().imagePath != null)
                    {
                        imagePath = rating.Member.MemberProfiles.FirstOrDefault().imagePath;
                        imagePath = imagePath.Substring(imagePath.LastIndexOf('/'));
                        imagePath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imagePath;
                    }
                }
                if (string.IsNullOrEmpty(tmp))
                    tmp = imagePath + "||" + rating.Member.firstName + " " + rating.Member.lastName + "||" + "Voted for " + rating.Seed.title + " " + Convert.ToDateTime(rating.ratingDate).ToString("MMMM dd yyyy") + "||" + rating.Member.id.ToString();
                else
                    tmp = tmp + "##" + imagePath + "||" + rating.Member.firstName + " " + rating.Member.lastName + "||" + "Voted for " + rating.Seed.title + " " + Convert.ToDateTime(rating.ratingDate).ToString("MMMM dd yyyy") + "||" + rating.Member.id.ToString();
            }
            return tmp;
            #endregion
        }

        /// <summary>
        /// Method to get commitments by seedId.
        /// </summary>
        /// <param name="SeedId"></param>
        /// <returns></returns>
        public string GetCommitmentsById(string SeedId)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(SeedId);
            IList<Commitment> tempCommitment = seedData.Commitments.ToList();
            string tmp = string.Empty;
            foreach (Commitment commitment in tempCommitment)
            {
                string imagePath = "No Image";
                if (commitment.Member.MemberProfiles.FirstOrDefault() != null)
                {
                    if (commitment.Member.MemberProfiles.FirstOrDefault().imagePath != null)
                    {
                        imagePath = commitment.Member.MemberProfiles.FirstOrDefault().imagePath;
                        imagePath = imagePath.Substring(imagePath.LastIndexOf('/'));
                        imagePath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imagePath;
                    }
                }
                if (string.IsNullOrEmpty(tmp))
                    tmp = imagePath + "||" + commitment.Member.firstName + " " + commitment.Member.lastName + "||" + commitment.msg.ToString() + "||" + Convert.ToDateTime(commitment.commitDate).ToString("MMMM dd yyyy") + "||" + commitment.Member.id.ToString();
                else
                    tmp = tmp + "##" + imagePath + "||" + commitment.Member.firstName + " " + commitment.Member.lastName + "||" + commitment.msg.ToString() + "||" + Convert.ToDateTime(commitment.commitDate).ToString("MMMM dd yyyy") + "||" + commitment.Member.id.ToString();
            }
            return tmp;
            #endregion
        }

        /// <summary>
        /// Method to get comments by seedId.
        /// </summary>
        /// <param name="SeedId"></param>
        /// <returns></returns>
        public string GetCommentsById(string SeedId)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(SeedId);
            IList<Comment> tempComment = seedData.Comments.ToList();
            string tmp = string.Empty;
            foreach (Comment comment in tempComment)
            {
                string imagePath = "No Image";
                if (comment.Member.MemberProfiles.FirstOrDefault() != null)
                {
                    if (comment.Member.MemberProfiles.FirstOrDefault().imagePath != null)
                    {
                        imagePath = comment.Member.MemberProfiles.FirstOrDefault().imagePath;
                        imagePath = imagePath.Substring(imagePath.LastIndexOf('/'));
                        imagePath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imagePath;
                    }
                }
                if (string.IsNullOrEmpty(tmp))
                    tmp = imagePath + "||" + comment.Member.firstName + " " + comment.Member.lastName + "||" + comment.msg.ToString() + "||" + Convert.ToDateTime(comment.commentDate).ToString("MMMM dd yyyy") + "||" + comment.Member.id.ToString();
                else
                    tmp = tmp + "##" + imagePath + "||" + comment.Member.firstName + " " + comment.Member.lastName + "||" + comment.msg.ToString() + "||" + Convert.ToDateTime(comment.commentDate).ToString("MMMM dd yyyy") + "||" + comment.Member.id.ToString(); 
            }
            return tmp;
            #endregion
        }

        /// <summary>
        /// This method is used to Add new Seeds.
        /// </summary>
        /// <param name="SeedName"></param>
        /// <param name="Description"></param>
        /// <param name="CityName"></param>
        /// <param name="Street"></param>
        /// <param name="RegionCode"></param>
        /// <param name="LatLong"></param>
        /// <param name="ZipCode"></param>
        /// <param name="ownerId"></param>
        /// <param name="tagName"></param>
        /// <returns></returns>
        public string AddSeedData(string SeedName, string Description, string CityName, string Street, string RegionCode, string LatLong, string ZipCode, string ownerId, string tagName, string imageName, string categoryNames)
        {
            #region
            bool actionCompleted = false;
            Seed seedData = null;
            string imagePath = imageName;
            string result = "Error while seed planting.";
            try
            {
                SeedAction objSeed = new SeedAction();

                Seed objSeedEntity = new Seed();
                Member memberData = new Member();
                Tag objTagEntity = new Tag();

                objSeedEntity.title = SeedName;
                
                objSeedEntity.description = Description;

                LocationAction objLocation = new LocationAction();
                string cityid = objLocation.GetCityIdByCityName(CityName, RegionCode);
                string latLong = LatLong;
                char[] separator = new char[] { ',' };
                string[] strSplitLatLong = latLong.Split(separator);
                string lat = strSplitLatLong[0].ToString();
                string longt = strSplitLatLong[1].ToString();

                if (cityid.Length > 0)
                {
                    Location objLoc = objLocation.CreateLocation(cityid, (ZipCode).ToString(), Convert.ToDouble(lat), Convert.ToDouble(longt), Street);

                    objSeedEntity.locationId = new Guid(objLoc.id.ToString());
 
                    objSeedEntity.ownerId = new Guid(ownerId);
                    seedData = objSeed.AddSeed(objSeedEntity);

                    actionCompleted = true;
                    result = seedData.id.ToString();
                    if (!string.IsNullOrEmpty(tagName))
                    {
                        if (seedData.id != null && tagName.Length > 0)
                        {
                            if (!tagName.Equals("(null)"))
                            {
                                objTagEntity.name = tagName;
                                objTagEntity.seedId = seedData.id;
                                actionCompleted = objSeed.ManageTag(objTagEntity);
                            }
                        }
                    }
 
                    if (!string.IsNullOrEmpty(imageName))
                    {
                        if (!imageName.Equals("No Image"))
                        {
                            AddMedia("Iphone Image1", imageName, seedData.id.ToString(), "Image", ownerId);

                            imagePath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia/" + imageName;
                        }
                    }
                    if (!string.IsNullOrEmpty(categoryNames))
                    {
                        if (seedData.id != null && categoryNames.Length > 0)
                        {
                            if (!categoryNames.Equals("Select Category"))
                            {
                                string[] arrCategoryIds;
                                string[] arrCategoryNames;
                                string ids = string.Empty;
                                
                                arrCategoryNames = categoryNames.Split(',');
                                CategoryAction objCategory = new CategoryAction();
                                for (int c = 0; c < arrCategoryNames.Length; c++)
                                {
                                    if (!string.IsNullOrEmpty(ids))
                                        ids = ids + "," + objCategory.GetCategoryIdByCategoryName(arrCategoryNames[c].ToString().Trim());
                                    else
                                        ids = objCategory.GetCategoryIdByCategoryName(arrCategoryNames[c].ToString().Trim());
                                }
                                arrCategoryIds = ids.Split(',');
                                if (categoryNames.Trim().ToString() != "" && arrCategoryIds.Length > 0)
                                {
                                    objSeed.AddCategories(seedData.id.ToString(), arrCategoryIds);
                                }
                            }
                        }
                    }

                    result = seedData.id.ToString() + "||" + seedData.title + "||" + CityName + "||" + RegionCode + "||" + ZipCode + "||" + imageName + "||" + imagePath + "||" + DateTime.Now.ToString();
                }
                if (actionCompleted == false)
                {
                    result = "Error while seed planting.";
                }
            }
            catch
            {
                result = "Error while seed planting.";
            }
           
            return result;
            #endregion
        }

        public string GetAllCategories()
        {
            #region
            string result = "";
            CategoryAction objCategory = new CategoryAction();
            foreach (Category catData in objCategory.GetAllCategories())
            {
                result += "||" + catData.name;
            }
            result = result.Substring(2);
            return result;
            #endregion
        }

        public string GetMemberInfoById(string memId)
        {
            #region
            string result = "";
            MemberAction objMember = new MemberAction();
            Member memData = objMember.GetMemberByMemberId(memId);
            result = memData.id.ToString() + "||" + memData.firstName + "||" + memData.lastName + "||" + memData.organisationName;

            string imgPath = "No Image";
            string locationAddress = "";
            if (memData.MemberProfiles != null)
            {
                MemberProfile memProfile = memData.MemberProfiles.FirstOrDefault();
                if (memProfile != null)
                {
                    imgPath = memProfile.imagePath;
                    imgPath = imgPath.Substring(imgPath.LastIndexOf('/'));
                    if (imgPath.Length > 1)
                        imgPath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imgPath;
                    else
                        imgPath = "No Image";

                    if (memProfile.Location != null)
                    {
                        locationAddress = memProfile.Location.City.name + ", " + memProfile.Location.City.Region.name;
                    }
                }
            }

            result = result + "||" + imgPath + "||" + locationAddress;
            return result;
            #endregion
        }

        /// <summary>
        /// Method to add comments.
        /// </summary>
        /// <param name="seedId"></param>
        /// <param name="memberId"></param>
        /// <param name="commentMsg"></param>
        /// <returns></returns>
        public bool addComment(string seedId, string memberId, string commentMsg)
        {
            #region
            bool actionDone = false;
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(seedId);
            seedData.status = SystemStatements.STATUS_GROWING;

            Comment objComment = new Comment();
            objComment.id = Guid.NewGuid();
            objComment.commentDate = DateTime.Now;
            objComment.msg = commentMsg;
            objComment.seedId = seedData.id;
            objComment.commentById = new Guid(memberId);
            objComment.isRead = false;

            seedData.Comments.Add(objComment);
            seedData = objSeed.UpdateSeed(seedData);
            if (seedData != null)
                actionDone = true;

            return actionDone;
            #endregion
        }

        /// <summary>
        /// Method to add commitments.
        /// </summary>
        /// <param name="seedId"></param>
        /// <param name="memberId"></param>
        /// <param name="commitmentDate"></param>
        /// <param name="commitmentMsg"></param>
        /// <returns></returns>
        public bool addCommitment(string seedId, string memberId, string commitmentDate, string commitmentMsg)
        {
            #region
            bool actionDone = false;
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(seedId);
            seedData.status = SystemStatements.STATUS_GROWING;

            Commitment objCommit = new Commitment();
            objCommit.id = Guid.NewGuid();
            objCommit.commitDate = DateTime.Now;
            objCommit.deadline = Convert.ToDateTime(commitmentDate);
            objCommit.memberId = new Guid(memberId);
            objCommit.seedId = seedData.id;
            objCommit.status = SystemStatements.STATUS_ACTIVE;
            objCommit.msg = commitmentMsg;
            objCommit.isRead = false;

            seedData.Commitments.Add(objCommit);
            seedData = objSeed.UpdateSeed(seedData);
            if (seedData != null)
                actionDone = true;

            return actionDone;
            #endregion
        }

        /// <summary>
        /// Method to add rating.
        /// </summary>
        /// <param name="seedId"></param>
        /// <param name="memberId"></param>
        /// <param name="rate"></param>
        /// <returns></returns>
        public string addRating(string seedId, string memberId, string rate)
        {
            #region
            bool actionDone = false;
            SeedAction objSeed = new SeedAction();
            actionDone = objSeed.ManageRating(seedId, memberId.ToString(), rate);

            int count = objSeed.getSeedRatingCountBySeedId(seedId, "Like");

            return count + " Likes";
            #endregion
        }

        public string GetAllMySeeds(string MemberId)
        {
            #region
            SeedAction objSeed = new SeedAction();
            IList<Seed> seedData = objSeed.GetSeedsByUser(MemberId);
            string tmp = "";
            foreach (Seed s in seedData)
            {
                string imgPath = "No Image";
                int likesCount = s.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count;
                int commitmentCount = s.Commitments.ToList().Count;
                int commentsCount = s.Comments.ToList().Count;

                if (s.Media != null && s.Media.Count > 0)
                {
                    imgPath = s.Media.Where(x => x.type.Equals("Image")).OrderByDescending(x => x.dateUploaded).FirstOrDefault().path;
                    imgPath = imgPath.Substring(imgPath.LastIndexOf('/'));
                    if (imgPath.Length > 1)
                        imgPath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imgPath;
                    else
                        imgPath = "No Image";
                }                
                tmp += s.id.ToString() + "||" + s.title;

                if (s.Location.City != null)
                {
                    tmp += "||" + s.Location.City.name;
                }

                if (s.Location.City.Region != null)
                {
                    tmp += "||" + s.Location.City.Region.code;
                }

                if (s.Location != null)
                {
                    tmp += "||" + s.Location.zipcode;
                }

                tmp += "||" + imgPath;

                tmp += "||" + s.Member.firstName + " " + s.Member.lastName + "||" + s.Location.crossStreet + "||" + Convert.ToDateTime(s.createDate).ToString("dd MMMM yyyy") + "||" + s.description + "||" + likesCount + " Likes" + "||" + commitmentCount + " Commitments" + "||" + commentsCount + " Comments";

                string tmpCategory = "";
                foreach (Category c in s.Categories)
                {
                    if (tmpCategory.Length > 0)
                        tmpCategory = tmpCategory + "," + c.name;
                    else
                        tmpCategory = c.name;
                }
                tmp = tmp + "||" + tmpCategory;

                tmp += "##";
            }

            if (tmp.Length > 2)
                tmp = tmp.Substring(0, tmp.Length - 2);

            if (seedData.Count < 1)
                tmp = "No Matching Seeds Found";

            return tmp;
            #endregion
        }

        public string SearchSeeds(string Criteria, string sortBy,string radius,string counter)
        {
            #region
            SeedAction objSeed = new SeedAction();
            IList<Seed> seedData = new List<Seed>();
            IList<Seed> tmpSeedList = null;
            CategoryAction objCategory = new CategoryAction();

            string searchOthers = "";
            string searchZip = "";
            int seedCounter = Convert.ToInt32(counter) + 1;

            string[] criteriaArr = Criteria.Trim().Split(' ');

            foreach(string str in criteriaArr)
            {
                if (this.checkCriteria(str))
                {
                    searchZip = str;
                }
                else
                {
                    searchOthers = searchOthers + " " + str;
                }
            }

            searchOthers = searchOthers.Trim();

            if (searchZip.Length > 0)
            {
                tmpSeedList = objSeed.GetAllSeedsByZip(radius, searchZip);

                foreach (Seed sData in tmpSeedList)
                {
                    seedData.Add(sData);
                }
            }

            if (searchOthers.Length > 0 && seedData.Distinct().ToList().Count < seedCounter)
            {
                IList<Category> catList = objCategory.GetAllCategoriesByName(searchOthers);

                foreach (Category cat in catList)
                {
                    tmpSeedList = objSeed.GetAllSeedsByCategory(cat.id.ToString());
                    foreach (Seed sData in tmpSeedList)
                    {
                        seedData.Add(sData);
                    }
                }

                if (seedData.Distinct().ToList().Count < seedCounter)
                {
                    tmpSeedList = objSeed.GetAllSeedsByTitle(searchOthers);
                    foreach (Seed sData in tmpSeedList)
                    {
                        seedData.Add(sData);
                    }
                }

                if (seedData.Distinct().ToList().Count < seedCounter)
                {
                    tmpSeedList = objSeed.GetAllSeedsByDescription(searchOthers);
                    foreach (Seed sData in tmpSeedList)
                    {
                        seedData.Add(sData);
                    }
                }

                if (seedData.Distinct().ToList().Count < seedCounter)
                {
                    tmpSeedList = objSeed.GetSeedByCrossStreet(searchOthers);
                    foreach (Seed sData in tmpSeedList)
                    {
                        seedData.Add(sData);
                    }
                }
                if (seedData.Distinct().ToList().Count < seedCounter)
                {
                    tmpSeedList = objSeed.GetSeedByCity(searchOthers);
                    foreach (Seed sData in tmpSeedList)
                    {
                        seedData.Add(sData);
                    }
                }
                              
             }

            string tmp = "";        

            seedData = seedData.Distinct().Take(seedCounter).ToList();

            if (!string.IsNullOrEmpty(sortBy))
            {
                switch (sortBy)
                {
                    case "1":
                        seedData = seedData.OrderBy(x => x.Categories.FirstOrDefault() != null ? x.Categories.FirstOrDefault().name : "").ToList();
                        break;
                    case "2":
                        seedData = seedData.OrderBy(x => x.Location.zipcode).ToList();
                        break;
                    case "3":
                        seedData = seedData.OrderBy(x => x.title).ToList();
                        break;
                    default:
                        seedData = seedData.OrderBy(x => x.title).ToList();
                        break;
                }
            }

            string tmpCName = "";

            foreach (Seed s in seedData)
            {
            
                string imgPath = "No Image";

                int likesCount = s.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count;
                int commitmentCount = s.Commitments.ToList().Count;
                int commentsCount = s.Comments.ToList().Count;

                if (s.Media != null && s.Media.Count > 0)
                {
                    imgPath = s.Media.FirstOrDefault().path;

                    imgPath = imgPath.Substring(imgPath.LastIndexOf('/'));

                    if (imgPath.Length > 1)
                        imgPath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imgPath;
                    else
                        imgPath = "No Image";
                }

                tmp += s.id.ToString() + "||" + s.title;

                if (s.Location.City != null)
                {
                    tmp += "||" + s.Location.City.name;
                }

                if (s.Location.City.Region != null)
                {
                    tmp += "||" + s.Location.City.Region.code;
                }

                if (s.Location != null)
                {
                    tmp += "||" + s.Location.zipcode;
                }

                tmp += "||" + imgPath;

                if (s.Categories != null && s.Categories.Count > 0)
                {
                    tmpCName = s.Categories.FirstOrDefault().name;
                }

                tmp += "||" + tmpCName;

                tmp += "||" + s.Member.firstName + " " + s.Member.lastName + "||" + s.Location.crossStreet + "||" + Convert.ToDateTime(s.createDate).ToString("dd MMMM yyyy") + "||" + s.description + "||" + likesCount + " Likes" + "||" + commitmentCount + " Commitments" + "||" + commentsCount + " Comments";

                string tmpCategory = "";
                foreach (Category c in s.Categories)
                {
                    if (tmpCategory.Length > 0)
                        tmpCategory = tmpCategory + "," + c.name;
                    else
                        tmpCategory = c.name;
                }
                tmp = tmp + "||" + tmpCategory;

                tmp += "##";
 
            }

            if (tmp.Length > 2)
                tmp = tmp.Substring(0, tmp.Length - 2);

            if (seedData.Count < 1)
                tmp = "No Matching Seeds Found";

            return tmp;
            #endregion
        }

        public bool checkCriteria(string criteriaTxt)
        {
            bool isChecked = false;
            Regex regex = new Regex(@"^[0-9]{5}$");
            if (regex.IsMatch(criteriaTxt))
                isChecked = true;
            return isChecked;
        }

        public string GetUserById(string MemberId)
        {
            #region
            string result = "";

            MemberAction objMember = new MemberAction();

            Member memData = objMember.GetMemberByMemberId(MemberId);

            result = memData.id.ToString() + "||" + memData.firstName + "||" + memData.lastName + "||" + memData.organisationName;

            string imgPath = "No Image";
            string locationAddress = "";

            if (memData.MemberProfiles != null)
            {
                MemberProfile memProfile = memData.MemberProfiles.FirstOrDefault();

                if(memProfile !=null)
                {
                    imgPath = memProfile.imagePath;

                    imgPath = imgPath.Substring(imgPath.LastIndexOf('/'));

                    if (imgPath.Length > 1)
                        imgPath = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia" + imgPath;
                    else
                        imgPath = "No Image";
                    
                    if (memProfile.Location != null)
                    {
                        locationAddress = memProfile.Location.crossStreet;
                    }
                }
            }

            result = result + "||" + imgPath + "||" + locationAddress;

            return result;
            #endregion
        }

        public bool UpdateMember(string memberId, string fName, string lName, string orgName, string imageName)
        {
            #region
            MemberAction objMember = new MemberAction();

            Member memData = objMember.GetMemberByMemberId(memberId);

            memData.firstName = fName;
            memData.lastName = lName;
            if (!string.IsNullOrEmpty(orgName))
                memData.organisationName = orgName;
            else
                memData.organisationName = null;

            // objMedia.path = "../../UploadedMedia/" + imgName;

            if (!imageName.Equals("No Image"))
             {
                 string ImagePath = "../../UploadedMedia/" + imageName;

                objMember.UploadProfileImage(memData,ImagePath);
                    
            }

            bool result = objMember.UpdateMemberInfoByService(memData);

            return result;
            #endregion
        }

        public string getAllNotificationsByMemberId(string memberId)
        {
            #region
            string notifications = string.Empty;
            string[] tmpArr;
            Repository repoObj = new Repository();

            //----------------Code for get all unread Comments-------------------
            IList<usp_GetCommentNotification_Result> listComments = repoObj.ListPP<usp_GetCommentNotification_Result>("usp_GetCommentNotification", memberId).OrderByDescending(x => x.commentDate).ToList();
            if (listComments.Count > 0)
            {
                for (int i = 0; i < listComments.Count; i++)
                {
                                      
                    if (listComments[i].Notify != null)
                    {
                        tmpArr =  listComments[i].Notify.Split(' ');

                        notifications = notifications + "##" + listComments[i].SeedID.ToString() + "||" + listComments[i].MemberID.ToString() + "||" + tmpArr[0] + "||" + "posted a comment on your"; 
                    }

                   
                }
            }
            //----------------Code for get all unread Commitments----------------
            IList<usp_GetCommitmentNotification_Result> listCommitments = repoObj.ListPP<usp_GetCommitmentNotification_Result>("usp_GetCommitmentNotification", memberId).OrderByDescending(x => x.commitDate).ToList();
            if (listCommitments.Count > 0)
            {
                for (int i = 0; i < listCommitments.Count; i++)
                {
                    if (listCommitments[i].Notify != null)
                    {
                        tmpArr = listCommitments[i].Notify.Split(' ');

                        notifications = notifications + "##" + listCommitments[i].SeedID.ToString() + "||" + listCommitments[i].MemberID.ToString() + "||" + tmpArr[0] + "||" + "made a commitment to your"; 
                    }
 
                   
                }
            }

            //----------------Code for get all unread Flags----------------------
            IList<usp_GetFlagNotification_Result> listFlags = repoObj.ListPP<usp_GetFlagNotification_Result>("usp_GetFlagNotification", memberId).OrderByDescending(x => x.dateFlagged).ToList();
            if (listFlags.Count > 0)
            {
                for (int i = 0; i < listFlags.Count; i++)
                {
                    if (listFlags[i].Notify != null)
                    {
                        tmpArr = listFlags[i].Notify.Split(' ');

                        notifications = notifications + "##" + listFlags[i].SeedID.ToString() + "||" + listFlags[i].MemberID.ToString() + "||" + tmpArr[0] + "||" + "has flagged your"; 
                    }

                     
                }
            }

            //----------------Code for get all unread likes----------------------
            IList<usp_GetLikeNotification_Result> listLikes = repoObj.ListPP<usp_GetLikeNotification_Result>("usp_GetLikeNotification", memberId).ToList();
            if (listLikes.Count > 0)
            {
                for (int i = 0; i < listLikes.Count; i++)
                {
                    if (listLikes[i].Notify != null)
                    {
                        tmpArr = listLikes[i].Notify.Split(' ');

                        notifications = notifications + "##" + listLikes[i].SeedID.ToString() + "||" + listLikes[i].MemberID.ToString() + "||" + tmpArr[0] + "||" + "liked your"; 
                    }

                    
                }
            }

            if (notifications.Length > 0)
            {
                notifications = notifications.Substring(2);
            }

            if (string.IsNullOrEmpty(notifications))
                notifications = "Notifications not found";
            return notifications;
            #endregion
        }

        public mem GetAll()
        {
            mem m = new mem();
            m.Name = "Sample";
            return m;
        }
    }
}
