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
using System.ServiceModel.Activation;

namespace SSWebService
{
    [ServiceBehavior(IncludeExceptionDetailInFaults = true)]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    public class SSService : ISSService
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
        public IList<MemberLogin> MemberAuthenticate(string UserName, string Password)
        {
            IList<MemberLogin> lstMemberLogIn = new List<MemberLogin>();
            MemberLogin objMemberLogin = new MemberLogin();
            MemberAction objMember = new MemberAction();
            Member tmpData = objMember.Authenticate(UserName, Password);

            string catResult = "";
            if (tmpData != null)
            {
                objMemberLogin.MemberID = tmpData.id.ToString();
                CategoryAction objCategory = new CategoryAction();
                foreach (Category catData in objCategory.GetAllCategories())
                {
                    catResult += "||" + catData.name;
                }
                catResult = catResult.Substring(2);
                if (!string.IsNullOrEmpty(catResult))
                {
                    objMemberLogin.Categories = catResult;
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
                objMemberLogin.MemberURL = imgPath;
                lstMemberLogIn.Add(objMemberLogin);
            }
            //result = result.Substring(2);
            return  lstMemberLogIn;
        }


        /// <summary>
        /// Get all seeds by member Id.
        /// </summary>
        /// <param name="MemberId"></param>
        /// <returns></returns>

        public IList<MemberSeeds> GetAllSeedsByMemberId(string MemberId, string counter)
        {
            IList<MemberSeeds> lstMemberSeeds = new List<MemberSeeds>();
            SeedAction objSeed = new SeedAction();

            int getCounter = Convert.ToInt32(counter) + 1;
            
            IList<Seed> seedData = (objSeed.GetSeedsByUser(MemberId)).Take(getCounter).OrderBy(x => x.createDate).ToList();

            //int i = 0;

            foreach (Seed s in seedData)
            {
                MemberSeeds objMemberSeed = new MemberSeeds();
                string imgPath = "No Image";
                objMemberSeed.SeedID = s.id.ToString();
                objMemberSeed.Title = s.title;
                if (s.Media != null && s.Media.Where(x => x.type.Equals("Image")).Count() > 0)
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
                objMemberSeed.Path = imgPath;
                if (s.Location.City != null)
                {
                    objMemberSeed.City = s.Location.City.name;
                }

                if (s.Location.City.Region != null)
                {
                    objMemberSeed.State = s.Location.City.Region.code;
                }

                if (s.Location != null)
                {
                    objMemberSeed.Zip = s.Location.zipcode;
                    objMemberSeed.Latitude = s.Location.localLat.ToString();
                    objMemberSeed.Longitude = s.Location.localLong.ToString();
                }
                objMemberSeed.CreateDate=s.createDate.ToString();
                lstMemberSeeds.Add(objMemberSeed);
            }


            //if (seedData.Count < 1)
            //{
            //    MemberSeeds objMemberSeed = new MemberSeeds();
            //    objMemberSeed.SeedID = "No Matching Seeds Found##No Matching Seeds Found";
            //    lstMemberSeeds.Add(objMemberSeed);
            //}

            return lstMemberSeeds;
        }

        public IList<MemberSeeds> GetAllSeedsByParrentId(string ParrentId, string counter)
        {
            IList<MemberSeeds> lstMemberSeeds = new List<MemberSeeds>();
            SeedAction objSeed = new SeedAction();

            int getCounter = Convert.ToInt32(counter) + 1;

            IList<Seed> seedData = (objSeed.GetSeedsByParrentSeedID(ParrentId)).Take(getCounter).OrderBy(x => x.createDate).ToList();

            //int i = 0;

            foreach (Seed s in seedData)
            {
                MemberSeeds objMemberSeed = new MemberSeeds();
                string imgPath = "No Image";
                objMemberSeed.SeedID = s.id.ToString();
                objMemberSeed.Title = s.title;
                if (s.Media != null && s.Media.Where(x => x.type.Equals("Image")).Count() > 0)
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
                objMemberSeed.Path = imgPath;
                if (s.Location.City != null)
                {
                    objMemberSeed.City = s.Location.City.name;
                }

                if (s.Location.City.Region != null)
                {
                    objMemberSeed.State = s.Location.City.Region.code;
                }

                if (s.Location != null)
                {
                    objMemberSeed.Zip = s.Location.zipcode;
                    objMemberSeed.Latitude = s.Location.localLat.ToString();
                    objMemberSeed.Longitude = s.Location.localLong.ToString();
                }
                objMemberSeed.CreateDate = s.createDate.ToString();
                lstMemberSeeds.Add(objMemberSeed);
            }


            //if (seedData.Count < 1)
            //{
            //    MemberSeeds objMemberSeed = new MemberSeeds();
            //    objMemberSeed.SeedID = "No Matching Seeds Found##No Matching Seeds Found";
            //    lstMemberSeeds.Add(objMemberSeed);
            //}

            return lstMemberSeeds;
        }

        
        /// <summary>
        /// Method to get all seeds by Id.
        /// </summary>
        /// <param name="SeedId"></param>
        /// <returns></returns>
        public IList<SeedDetail> GetSeedsById(string SeedId, string MemberId)
        {
            IList<SeedDetail> lstSeedDetail = new List<SeedDetail>();
            SeedDetail objSeedDetail = new SeedDetail();
            SeedAction objSeed = new SeedAction();
            //For finding total reply seeds of the current seed
            //int getCounter = 200;
           // IList<Seed> seedDataCounter = (objSeed.GetSeedsByParrentSeedID(SeedId)).Take(getCounter).OrderBy(x => x.createDate).ToList();
            //

            Seed seedData = objSeed.GetSeedBySeedId(SeedId);
            int likesCount = seedData.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count;
            int replyCount = Convert.ToInt16(objSeed.GetReplySeedCount(SeedId));// seedData.Commitments.ToList().Count;
            int commentsCount = seedData.Comments.ToList().Count;
            
            objSeedDetail.Title = seedData.title;
            if (seedData.Member.organisationName != null)
            {
                objSeedDetail.MemberName = seedData.Member.organisationName;
            }
            else
            {
                objSeedDetail.MemberName = seedData.Member.firstName + " " + seedData.Member.lastName;
            }


            objSeedDetail.City = seedData.Location.City.name;
            objSeedDetail.Address = seedData.Location.crossStreet;
            objSeedDetail.State = seedData.Location.City.Region.name;
            objSeedDetail.CreateDate = Convert.ToDateTime(seedData.createDate).ToString("MMMM dd, yyyy");
            objSeedDetail.Description = seedData.description;
            objSeedDetail.Likes = likesCount + " Likes";
            objSeedDetail.ReplySeeds = replyCount + " Reply Seeds"; 
            objSeedDetail.Comments=   commentsCount + " Comments";
            objSeedDetail.RootSeedID =seedData.id.ToString();
            objSeedDetail.ParentSeedID = seedData.parentSeedID != null ? seedData.parentSeedID.ToString() : seedData.id.ToString();
            string tmpCategory = "";
            foreach (Category c in seedData.Categories)
            {
                if (tmpCategory.Length > 0)
                    tmpCategory = tmpCategory + ", " + c.name;
                else
                    tmpCategory = c.name;
            }
            objSeedDetail.Categories = tmpCategory;
            if (seedData.Tags != null && seedData.Tags.Count > 0)
            {
                objSeedDetail.Keywords = seedData.Tags.FirstOrDefault().name.ToString();

            }
            else
            {
                objSeedDetail.Keywords = "";
            }

            objSeedDetail.MemberID = seedData.Member.id.ToString();
            objSeedDetail.Zip = seedData.Location.zipcode;
          

            int counter = objSeed.getSeedRatingCountByMemberId(SeedId, MemberId, "Like");

            if (counter > 0)
            {
             objSeedDetail.Rating= "Disable";
            }
            else
            {
                objSeedDetail.Rating = "Enable";
            }

            objSeedDetail.Latitude = seedData.Location.localLat.ToString();
            objSeedDetail.Longitude = seedData.Location.localLong.ToString();

            string imgPath = "No Image";

            if (seedData.Media != null && seedData.Media.Where(x => x.type.Equals("Image")).Count() > 0)
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

            objSeedDetail.Path = imgPath;

            lstSeedDetail.Add(objSeedDetail);
            return lstSeedDetail;
        }


        public IList<MemberInfo> GetMemberInfoById(string memId)
        {

            IList<MemberInfo> lstMemberInfo = new List<MemberInfo>();
            MemberInfo objMemberInfo = new MemberInfo();
            string result = "";

            MemberAction objMember = new MemberAction();

            Member memData = objMember.GetMemberByMemberId(memId);

            result = memData.id.ToString() + "||" + memData.firstName + "||" + memData.lastName + "||" + memData.organisationName;
            objMemberInfo.MemberID = memData.id.ToString();
            objMemberInfo.FirstName = memData.firstName;
            objMemberInfo.LastName = memData.lastName;
            if (memData.organisationName != null)
            {
                objMemberInfo.Organisation = memData.organisationName;
            }
            else
            {
                objMemberInfo.Organisation = "";
            }


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
            objMemberInfo.Path = imgPath;
            objMemberInfo.LocationAddress = locationAddress;
            lstMemberInfo.Add(objMemberInfo);

            return lstMemberInfo;
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
            bool actionDone = false;
            SeedAction objSeed = new SeedAction();
            actionDone = objSeed.ManageRating(seedId, memberId.ToString(), rate);

            int count = objSeed.getSeedRatingCountBySeedId(seedId, "Like");

            return count + " Likes";
        }

        /// <summary>
        /// Method to get comments by seedId.
        /// </summary>
        /// <param name="SeedId"></param>
        /// <returns></returns>
        public IList<SeedComment> GetCommentsById(string SeedId)
        {

            IList<SeedComment> lstSeedComment = new List<SeedComment>();
           
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(SeedId);
            IList<Comment> tempComment = seedData.Comments.ToList();

            foreach (Comment comment in tempComment)
            {
                SeedComment objSeedComment = new SeedComment();
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

                // imagePath = comment.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();
                objSeedComment.Path = imagePath;
                objSeedComment.MemberName = comment.Member.firstName + " " + comment.Member.lastName;
                objSeedComment.CommentMessage = comment.msg.ToString();
               // objSeedComment.CommentDate = Convert.ToDateTime(comment.commentDate).ToString("MMMM dd yyyy");
                objSeedComment.CommentDate = Convert.ToDateTime(comment.commentDate).ToString();
                objSeedComment.MemberID = comment.Member.id.ToString();
                lstSeedComment.Add(objSeedComment);
                            }//for loop

            return lstSeedComment;
        }

        /// <summary>
        /// Method to get commitments by seedId.
        /// </summary>
        /// <param name="SeedId"></param>
        /// <returns></returns>
        public IList<SeedComment> GetCommitmentsById(string SeedId)
        {
            IList<SeedComment> lstSeedComment = new List<SeedComment>();
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(SeedId);
            IList<Commitment> tempCommitment = seedData.Commitments.ToList();

            foreach (Commitment commitment in tempCommitment)
            {
                SeedComment objSeedComment = new SeedComment();
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

                // imagePath = commitment.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();

                objSeedComment.Path = imagePath;
                objSeedComment.MemberName = commitment.Member.firstName + " " + commitment.Member.lastName;
                objSeedComment.CommentMessage = commitment.msg.ToString();
                //objSeedComment.CommentDate = Convert.ToDateTime(commitment.commitDate).ToString("MMMM dd yyyy");
                objSeedComment.CommentDate = Convert.ToDateTime(commitment.commitDate).ToString();
                objSeedComment.MemberID = commitment.Member.id.ToString();
                lstSeedComment.Add(objSeedComment);

                         
            }
            return lstSeedComment;
        }


        /// <summary>
        /// Method to get votes by seedId.
        /// </summary>
        /// <param name="SeedId"></param>
        /// <returns></returns>
        public IList<SeedComment> GetVotesById(string SeedId)
        {
            IList<SeedComment> lstGetVotesById = new List<SeedComment>();

            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(SeedId);
            IList<Rating> tempRating = seedData.Ratings.Where(x => x.likes.Equals("Like")).ToList();
            string tmp = string.Empty;
            foreach (Rating rating in tempRating)
            {
                SeedComment objGetVotesById = new SeedComment();
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
                //   imagePath = rating.Member.MemberProfiles.FirstOrDefault().imagePath.ToString();

                objGetVotesById.Path = imagePath;
                objGetVotesById.MemberName = rating.Member.firstName + " " + rating.Member.lastName;
               // objGetVotesById.CommentMessage = "Voted for " + rating.Seed.title + " " + Convert.ToDateTime(rating.ratingDate).ToString();
                objGetVotesById.CommentMessage =Convert.ToDateTime(rating.ratingDate).ToShortDateString() + "-" + rating.Seed.title ;
                //objGetVotesById.CommentDate = Convert.ToDateTime(rating.ratingDate).ToString("MMMM dd yyyy");
                objGetVotesById.CommentDate = Convert.ToDateTime(rating.ratingDate).ToString();
                objGetVotesById.MemberID = rating.Member.id.ToString(); 
                lstGetVotesById.Add(objGetVotesById);

            }            
            return lstGetVotesById;
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
            bool actionDone = false;
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(seedId);
            seedData.status = SystemStatements.STATUS_GROWING;

            Comment objComment = new Comment();
            objComment.id = Guid.NewGuid();
            objComment.commentDate = DateTime.Now;
            objComment.msg = commentMsg.Replace("|", "&");
            objComment.seedId = seedData.id;
            objComment.commentById = new Guid(memberId);
            objComment.isRead = false;

            seedData.Comments.Add(objComment);
            seedData = objSeed.UpdateSeed(seedData);
            if (seedData != null)
                actionDone = true;

            return actionDone;
        }

        public bool UpdateMember(string memberId, string fName, string lName, string orgName, string imageName)
        {
            MemberAction objMember = new MemberAction();

            Member memData = objMember.GetMemberByMemberId(memberId);

            memData.firstName = fName;
            memData.lastName = lName;
            if (!string.IsNullOrEmpty(orgName))
                memData.organisationName = orgName.Replace("|", "&");
            else
                memData.organisationName = null;

            // objMedia.path = "../../UploadedMedia/" + imgName;

            if (!imageName.Equals("No Image"))
            {
                string ImagePath = "../../UploadedMedia/" + imageName;

                objMember.UploadProfileImage(memData, ImagePath);

            }

            bool result = objMember.UpdateMemberInfoByService(memData);

            return result;
        }


        /// <summary>
        /// Method to change Password.
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="newPassword"></param>
        /// <returns></returns>

        public bool ChangeMemberPasswd(string memberId, string newPassword)
        {
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
        }

        /// <summary>
        /// To get Password
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="newPassword"></param>
        /// <returns></returns>
        public bool ForgotPasswd(string userName)
        {
            MemberAction objMember = new MemberAction();

            bool isCompleted = false;

            try
            {
                isCompleted = objMember.ForgotPassword(userName);

                
            }
            catch
            {
            }

            return isCompleted;
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
        public string AddSeedData(string SeedName, string Description, string CityName, string Street, string RegionCode, string Lat, string Lng, string ZipCode, string ownerId, string tagName, string imageName, string categoryNames)
        {

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

                objSeedEntity.title = SeedName.Replace("|","&");

                objSeedEntity.description = Description.Replace("|", "&");

                LocationAction objLocation = new LocationAction();
                string cityid = objLocation.GetCityIdByCityName(CityName, RegionCode);
                if (string.IsNullOrEmpty(cityid))
                    cityid = objSeed.AddCity(CityName, RegionCode);

                string lat = Lat;
                string longt = Lng;

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
                                //categoryNames = categoryNames.TrimStart(',');
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
            catch (Exception ex)
            {
                result = "Error while seed planting.";
            }

            return result;
        }


        public string AddReplySeedData(string SeedName, string Description, string CityName, string Street, string RegionCode, string Lat, string Lng, string ZipCode, string ownerId, string tagName, string imageName, string categoryNames, string RootSeedId, string ParentSeedId)
        {

            bool actionCompleted = false;
            Seed seedData = null;
            string imagePath = imageName;
            string result = "Error while seed planting.";
            string result2 = "Error while seed planting.";
            try
            {
                SeedAction objSeed = new SeedAction();

                Seed objSeedEntity = new Seed();
                Member memberData = new Member();
                Tag objTagEntity = new Tag();

                objSeedEntity.title = SeedName.Replace("|", "&");

                objSeedEntity.description = Description.Replace("|", "&");
                if (!string.IsNullOrEmpty(RootSeedId))
                    objSeedEntity.rootSeedID = new Guid(RootSeedId);

                if (!string.IsNullOrEmpty(ParentSeedId))
                    objSeedEntity.parentSeedID = new Guid(ParentSeedId);

                LocationAction objLocation = new LocationAction();
                string cityid = objLocation.GetCityIdByCityName(CityName, RegionCode);
                if (string.IsNullOrEmpty(cityid))
                    cityid = objSeed.AddCity(CityName, RegionCode);
                //string latLong = LatLong;
                //char[] separator = new char[] { ',' };
                //string[] strSplitLatLong = latLong.Split(separator);
                string lat = Lat;
                string longt = Lng;

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
                                //categoryNames = categoryNames.TrimStart(',');
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
                else
                {
                    result2 = "City Not Found";
                }
                if (actionCompleted == false)
                {
                    result = result2;
                }
            }
            catch (Exception ex)
            {
                result = result2 ;
            }

            return result;
        }

        /// <summary>
        /// Method to add media.
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="newPassword"></param>
        /// <returns></returns>
        public string AddMedia(string title, string imgName, string seedId, string fileType, string memberId)
        {
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
                if (!string.IsNullOrEmpty(OrganisationName))
                {
                    if (!OrganisationName.Equals("(null)"))
                        rmodel.organisationName = OrganisationName;
                }
                result = objMember.MobileSignup(rmodel);
            }

            return result;
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
            string isCompleted = "Error in Update Action";
            SeedAction objSeed = new SeedAction();

            try
            {
                Seed seedData = objSeed.GetSeedBySeedId(seedId);

                seedData.title = seedName.Replace("|", "&");
                seedData.description = seedDescription.Replace("|", "&");
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

                //isCompleted = "Seed Update Successfully";

                if (imageName.Length > 1 && imageName != "No Image")
                {
                    imageName = System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString() + "/UploadedMedia/" + imageName;
                }
                else
                {
                    imageName = "No Image";
                }

                isCompleted = seedData.id.ToString() + "||" + seedData.title + "||" + seedData.Location.City.name + "||" + seedData.Location.City.Region.code + "||" + seedData.Location.zipcode + "||" + imageName;



                //isCompleted = "SeedId: " + seedId + ", Seed Name: " + seedName + ", Seed Description: " + seedDescription;
            }
            catch
            {

            }
            return isCompleted;
        }

        //Check Unread Notifications
        public void CheckUnreadNotifications(string commentDesc)
        {
            if (!commentDesc.Equals("undefined") && !string.IsNullOrEmpty(commentDesc))
            {
                MemberAction objMember = new MemberAction();
                string[] notifyIds = commentDesc.Split(',');
                for (int i = 0; i < notifyIds.Count()-1; i++)
                {
                    if (notifyIds[i + 1] == "Comment")
                    {
                        objMember.UpdateMemberComments(new Guid(notifyIds[i]));
                    }
                    else if (notifyIds[i + 1] == "Flag")
                    {
                        objMember.UpdateMemberFlags(new Guid(notifyIds[i]));
                    }
                    else if (notifyIds[i + 1] == "Rating")
                    {
                        objMember.UpdateMemberLikes(new Guid(notifyIds[i]));
                    }
                    i++;
                }
            }
        }


        /// <summary>
        /// To All Notification By member
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public IList<MemberNotification> getAllNotificationsByMemberId(string memberId)
        {

            string[] tmpArr;
            Repository repoObj = new Repository();

            IList<MemberNotification> lstMemberNotification = new List<MemberNotification>();

            //----------------Code for get all unread Comments-------------------
            IList<usp_GetCommentNotification_Result> listComments = repoObj.ListPP<usp_GetCommentNotification_Result>("usp_GetCommentNotification", memberId).OrderByDescending(x => x.commentDate).ToList();
            if (listComments.Count > 0)
            {
                for (int i = 0; i < listComments.Count; i++)
                {

                    if (listComments[i].Notify != null )
                    {
                        
                        tmpArr = listComments[i].Notify.Split(' ');
                        MemberNotification objMemberNotification = new MemberNotification();
                        objMemberNotification.SeedID = listComments[i].SeedID.ToString();
                        objMemberNotification.MemberID = listComments[i].MemberID.ToString();
                        objMemberNotification.MemberName = tmpArr[0];
                        objMemberNotification.Message = "posted a comment on your";
                        objMemberNotification.CommentDesc = listComments[i].id.ToString() + "," + "Comment";
                        if (listComments[i].commentDate == null)
                        {
                            objMemberNotification.CommentDate = "No Date";
                        }
                        else
                        {
                            objMemberNotification.CommentDate = listComments[i].commentDate.ToString().TrimStart();
                        }
                        lstMemberNotification.Add(objMemberNotification);
                       
                    }


                }
            }
            //----------------Code for get all unread Commitments----------------
            /*
            IList<usp_GetCommitmentNotification_Result> listCommitments = repoObj.ListPP<usp_GetCommitmentNotification_Result>("usp_GetCommitmentNotification", memberId).OrderByDescending(x => x.commitDate).ToList();
            if (listCommitments.Count > 0)
            {
                for (int i = 0; i < listCommitments.Count; i++)
                {
                    if (listCommitments[i].Notify != null)
                    {
                        tmpArr = listCommitments[i].Notify.Split(' ');
                        MemberNotification objMemberNotification = new MemberNotification();
                        objMemberNotification.SeedID = listComments[i].SeedID.ToString();
                        objMemberNotification.MemberID = listComments[i].MemberID.ToString();
                        objMemberNotification.MemberName = tmpArr[0];
                        objMemberNotification.Message = "made a commitment to your";
                        lstMemberNotification.Add(objMemberNotification);
                       
                    }


                }
            }
            */
            //----------------Code for get all unread Flags----------------------
            IList<usp_GetFlagNotification_Result> listFlags = repoObj.ListPP<usp_GetFlagNotification_Result>("usp_GetFlagNotification", memberId).OrderByDescending(x => x.dateFlagged).ToList();
            if (listFlags.Count > 0)
            {
                for (int i = 0; i < listFlags.Count; i++)
                {
                    if (listFlags[i].Notify != null)
                    {
                        tmpArr = listFlags[i].Notify.Split(' ');
                        MemberNotification objMemberNotification = new MemberNotification();
                        objMemberNotification.SeedID = listComments[i].SeedID.ToString();
                        objMemberNotification.MemberID = listComments[i].MemberID.ToString();
                        objMemberNotification.MemberName = tmpArr[0];
                        objMemberNotification.Message = "has flagged your";
                        objMemberNotification.CommentDesc = listComments[i].id.ToString() + "," + "Flag";
                        objMemberNotification.CommentDate = listComments[i].commentDate.ToString().TrimStart(); ;
                        lstMemberNotification.Add(objMemberNotification);
                      
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
                        MemberNotification objMemberNotification = new MemberNotification();
                        objMemberNotification.SeedID = listComments[i].SeedID.ToString();
                        objMemberNotification.MemberID = listComments[i].MemberID.ToString();
                        objMemberNotification.MemberName = tmpArr[0];
                        objMemberNotification.Message = "liked your";
                        objMemberNotification.CommentDesc = listComments[i].id.ToString() + "," + "Rating";
                        objMemberNotification.CommentDate = listComments[i].commentDate.ToString().TrimStart(); ;
                        lstMemberNotification.Add(objMemberNotification);
                       
                    }


                }
            }

            if (lstMemberNotification.Count < 1)
            {
                MemberNotification objMemberNotification = new MemberNotification();
                objMemberNotification.SeedID = null;
                objMemberNotification.MemberID = null;
                objMemberNotification.MemberName ="No New Notifications" ;
                objMemberNotification.Message = "liked your";
                objMemberNotification.CommentDesc = null;
                objMemberNotification.CommentDate = null ;
                lstMemberNotification.Add(objMemberNotification);
            }


       
            return lstMemberNotification;
        }


        /// <summary>
        /// Search Seeds
        /// </summary>
        /// <param name="Criteria"></param>
        /// <param name="sortBy"></param>
        /// <param name="radius"></param>
        /// <param name="counter"></param>
        /// <returns></returns>
        public IList<SeedDetail> SearchSeeds(string Criteria, string sortBy, string radius, string counter)
        {
            SeedAction objSeed = new SeedAction();
            IList<Seed> seedData = new List<Seed>();
            IList<Seed> tmpSeedList = null;
            CategoryAction objCategory = new CategoryAction();

            string searchOthers = "";
            string searchZip = "";
            int seedCounter = Convert.ToInt32(counter) + 1;

            string[] criteriaArr = Criteria.Trim().Split(' ');

            foreach (string str in criteriaArr)
            {
                //Checking that searchstring contains zipcode
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
               // radius = "50";
                tmpSeedList = objSeed.GetAllSeedsByZip(radius, searchZip);

                foreach (Seed sData in tmpSeedList)
                {
                    if (sData.status.Equals(SystemStatements.STATUS_NEW) || sData.status.Equals(SystemStatements.STATUS_GROWING))
                    {
                        seedData.Add(sData);
                    }
                    //seedData.Add(sData);
                }
            }

            if (searchOthers.Length > 0 && seedData.Distinct().ToList().Count < seedCounter)
            {
                //Searching in Category
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
                    //Searching in Description
                    tmpSeedList = objSeed.GetAllSeedsByDescription(searchOthers);
                    foreach (Seed sData in tmpSeedList)
                    {
                        seedData.Add(sData);
                    }
                }

                if (seedData.Distinct().ToList().Count < seedCounter)
                {
                    //Searching in FirstName
                    tmpSeedList = objSeed.GetAllSeedsByUserName(searchOthers);
                    foreach (Seed sData in tmpSeedList)
                    {
                        seedData.Add(sData);
                    }
                }

                if (seedData.Distinct().ToList().Count < seedCounter)
                {
                    //Searching in CrossStreet
                    tmpSeedList = objSeed.GetSeedByCrossStreet(searchOthers);
                    foreach (Seed sData in tmpSeedList)
                    {
                        seedData.Add(sData);
                    }
                }
                if (seedData.Distinct().ToList().Count < seedCounter)
                {
                    //Searching in City
                    tmpSeedList = objSeed.GetSeedByCity(searchOthers);
                    foreach (Seed sData in tmpSeedList)
                    {
                        seedData.Add(sData);
                    }
                }

            }

          //  string tmp = "";

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

            IList<SeedDetail> lstSeedList = new List<SeedDetail>();

            foreach (Seed s in seedData)
            {

                SeedDetail objSeedDetail = new SeedDetail();

                string imgPath = "No Image";

                int likesCount = s.Ratings.Where(x => x.likes.Equals("Like")).ToList().Count;
                int replyCount =Convert.ToInt16(objSeed.GetReplySeedCount(s.id.ToString()));// s.Commitments.ToList().Count;
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

                objSeedDetail.SeedID = s.id.ToString();
                objSeedDetail.Title = s.title;
           

                if (s.Location.City != null)
                {
                   // tmp += "||" + s.Location.City.name;
                    objSeedDetail.City = s.Location.City.name;
                }

                if (s.Location.City.Region != null)
                {
                    objSeedDetail.State = s.Location.City.Region.code;
                    //tmp += "||" + s.Location.City.Region.code;
                }

                if (s.Location != null)
                {
                    objSeedDetail.Zip = s.Location.zipcode; 
                  //  tmp += "||" + s.Location.zipcode;
                }
                objSeedDetail.Path = imgPath;
               // tmp += "||" + imgPath;

                if (s.Categories != null && s.Categories.Count > 0)
                {
                    tmpCName = s.Categories.FirstOrDefault().name;
                }

                if (s.Location != null)
                {

                    objSeedDetail.Latitude = s.Location.localLat.ToString();
                    objSeedDetail.Longitude = s.Location.localLong.ToString();
                }
                objSeedDetail.TempCategory = tmpCName;
               // tmp += "||" + tmpCName;

                objSeedDetail.MemberName = s.Member.firstName + " " + s.Member.lastName;
                objSeedDetail.Address = s.Location.crossStreet;
                objSeedDetail.CreateDate = Convert.ToDateTime(s.createDate).ToString();
                objSeedDetail.Description = s.description;
                objSeedDetail.Likes = likesCount + " Likes";
                objSeedDetail.Comments = commentsCount + " Comments";
                objSeedDetail.ReplySeeds = replyCount + " Reply Seeds";
                objSeedDetail.PopularCount = (likesCount + commentsCount + replyCount).ToString();
                //tmp += "||" + s.Member.firstName + " " + s.Member.lastName + "||" + s.Location.crossStreet + "||" + Convert.ToDateTime(s.createDate).ToString("dd MMMM yyyy") + "||" + s.description + "||" + likesCount + " Likes" + "||" + commitmentCount + " Commitments" + "||" + commentsCount + " Comments";

                string tmpCategory = "";
                foreach (Category c in s.Categories)
                {
                    if (tmpCategory.Length > 0)
                        tmpCategory = tmpCategory + "," + c.name;
                    else
                        tmpCategory = c.name;
                }
                objSeedDetail.Categories = tmpCategory;
             //   tmp = tmp + "||" + tmpCategory;


                lstSeedList.Add(objSeedDetail);
            }//For each seed

            return lstSeedList;
        }

        public bool checkCriteria(string criteriaTxt)
        {
            bool isChecked = false;
            Regex regex = new Regex(@"^[0-9]{5}$");
            if (regex.IsMatch(criteriaTxt))
                isChecked = true;
            return isChecked;
        }

    
    
    }//Class
}//NameSpace
