using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SeedSpeak.BLL;
using SeedSpeak.Data;
using SeedSpeak.Data.Repository;
using SeedSpeak.Model;
using SeedSpeak.Model.Validation;
using SeedSpeak.Util;
using System.Collections;
using System.IO;
using System.Net;
using System.Xml;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Text;
using System.Web.Script.Serialization;
using System.Data;
using SeedSpeak.utils;
using System.Text.RegularExpressions;

namespace SeedSpeak.Controllers
{
    public class SeedController : Controller
    {
        //
        // GET: /Seed/

        public ActionResult Index()
        {
            return View();
        }        

        public void GetTopPlanters()
        {
            Repository repoObj = new Repository();
            IList<TopSeedPlanter> listTopPlanters = repoObj.ListP<TopSeedPlanter>("Usp_GetTopSeedPlanter").ToList();
            ViewData["TopPlanters"] = listTopPlanters;
        }        

        public bool checkCriteria(string criteriaTxt)
        {
            bool isChecked = false;
            Regex regex = new Regex(@"^[0-9]{5}$");
            if (regex.IsMatch(criteriaTxt))
                isChecked = true;
            return isChecked;
        }

        public IList<Seed> HomeSearchSeeds(string Criteria, string sortBy, string radius, string counter)
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

            foreach (string str in criteriaArr)
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
            seedData = seedData.Distinct().Take(seedCounter).ToList();
            return seedData;
            #endregion
        }

        [HttpPost]
        public ActionResult SeedInfo(AddSeed objAddSeed, string categoryIds)
        {
            SessionStore.SetSessionValue(SessionStore.SeedInfo, objAddSeed);
            SessionStore.SetSessionValue(SessionStore.CategoryId, categoryIds);
            return RedirectToAction("SeedLocation", "Seed");
        }

        public ActionResult PlaceOnMap()
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
                return RedirectToAction("Default", "Member");

            if (memberData.MemberProfiles != null)
            {
                if (memberData.MemberProfiles.FirstOrDefault().Location != null)
                {
                    ViewData["LocationLat"] = memberData.MemberProfiles.FirstOrDefault().Location.localLat;
                    ViewData["LocationLong"] = memberData.MemberProfiles.FirstOrDefault().Location.localLong;
                }
            }
            else
            {
                ViewData["LocationLat"] = "33.4483771";
                ViewData["LocationLong"] = "-112.0740373";
            }
            
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult PlaceOnMap(string infoLatLong, string seedLocation)
        {
            #region
            try
            {
                SeedAction objSeed = new SeedAction();
                LocationAction objLocation = new LocationAction();

                //Format address and create add seed model
                string[] splitAddress = seedLocation.Split(',');
                AddSeed seedData = (AddSeed)SessionStore.GetSessionValue(SessionStore.SeedInfo);
                seedData.LongLat = infoLatLong;                
                seedData.StreetAddress = splitAddress[0].ToString();
                seedData.City = splitAddress[1].ToString().Trim();
                string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                seedData.ZipCode = splitZipRegion[1].ToString().Trim();
                seedData.StateCode = splitZipRegion[0].ToString().Trim();
                //End formatting address

                string categoryIds = (string)SessionStore.GetSessionValue(SessionStore.CategoryId);
                string[] arrCategoryIds;
                string latLong = seedData.LongLat;
                char[] separator = new char[] { ',' };
                string[] strSplitLatLong = latLong.Split(separator);
                string lat = strSplitLatLong[0].ToString();
                string longt = strSplitLatLong[1].ToString();
                categoryIds = categoryIds.TrimStart(',');
                arrCategoryIds = categoryIds.Split(',');

                string plantedSeedId = AddSeedData(seedData);
                bool isPlanted = false;
                if (categoryIds.Trim().ToString() != "")
                {
                    isPlanted = objSeed.AddCategories(plantedSeedId, arrCategoryIds);
                }
                bindCheckBox(plantedSeedId);

                Seed seed = GetSeedInformation(plantedSeedId);

                #region Send Mail
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(seed.Member.firstName + " " + seed.Member.lastName);
                arrTokens.Add(seed.title);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/SeedDetails/" + seed.id);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/Profile");

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = seed.Member.username;
                objSendMail.Subject = "email.seedPlanted.subject.content";
                objSendMail.MsgBody = "email.seedPlanted.body.content";
                objSendMail.ChangesInMessage = arrTokens;

                objSendMail.SendEmail(objSendMail);
                #endregion

                return Redirect("/Seed/SeedDetails/" + seed.id);
            }
            catch (Exception ex)
            {
                ViewData["SeedPlant"] = ex.Message.ToString();
            }
            bindCategory();
            return View();
            #endregion
        }

        public ActionResult SeedLocation()
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
                return RedirectToAction("Default", "Member");

            if (memberData.MemberProfiles.FirstOrDefault() != null)
            {
                if (memberData.MemberProfiles.FirstOrDefault().Location != null)
                {
                    ViewData["LocationLat"] = memberData.MemberProfiles.FirstOrDefault().Location.localLat;
                    ViewData["LocationLong"] = memberData.MemberProfiles.FirstOrDefault().Location.localLong;
                }
            }
            else
            {
                ViewData["LocationLat"] = "33.448057818272964";
                ViewData["LocationLong"] = "-112.07419395446777";
            }

            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult SeedLocation(string InfoLatLong, string seedLocation)
        {
            #region
            try
            {
                SeedAction objSeed = new SeedAction();
                LocationAction objLocation = new LocationAction();

                //Format address and create add seed model
                string[] splitAddress = seedLocation.Split(',');
                AddSeed seedData = (AddSeed)SessionStore.GetSessionValue(SessionStore.SeedInfo);
                seedData.LongLat = InfoLatLong;
                seedData.StreetAddress = splitAddress[0].ToString();
                seedData.City = splitAddress[1].ToString().Trim();
                string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                seedData.ZipCode = splitZipRegion[1].ToString().Trim();
                seedData.StateCode = splitZipRegion[0].ToString().Trim();
                //End formatting address

                string categoryIds = (string)SessionStore.GetSessionValue(SessionStore.CategoryId);
                string[] arrCategoryIds;
                string latLong = seedData.LongLat;
                char[] separator = new char[] { ',' };
                string[] strSplitLatLong = latLong.Split(separator);
                string lat = strSplitLatLong[0].ToString();
                string longt = strSplitLatLong[1].ToString();
                categoryIds = categoryIds.TrimStart(',');
                arrCategoryIds = categoryIds.Split(',');

                string plantedSeedId = AddSeedData(seedData);
                bool isPlanted = false;
                if (categoryIds.Trim().ToString() != "")
                {
                    isPlanted = objSeed.AddCategories(plantedSeedId, arrCategoryIds);
                }
                bindCheckBox(plantedSeedId);

                Seed seed = GetSeedInformation(plantedSeedId);

                #region Send Mail
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(seed.Member.firstName + " " + seed.Member.lastName);
                arrTokens.Add(seed.title);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/SeedDetails/" + seed.id);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/Profile");

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = seed.Member.username;
                objSendMail.Subject = "email.seedPlanted.subject.content";
                objSendMail.MsgBody = "email.seedPlanted.body.content";
                objSendMail.ChangesInMessage = arrTokens;

                objSendMail.SendEmail(objSendMail);
                #endregion

                return Redirect("/Seed/SeedDetails/" + seed.id);
            }
            catch (Exception ex)
            {
                ViewData["SeedPlant"] = ex.Message.ToString();
            }
            bindCategory();
            return View();
            #endregion
        }

        // *************************************
        // URL: /Seed/PlantSeedNew
        // *************************************
        public ActionResult PlantSeedNew()
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
            {
                string universalURL = "http://" + (Request.ServerVariables["SERVER_NAME"] + Request.ServerVariables["URL"]).ToString();
                SessionStore.SetSessionValue("RequestedURL", universalURL);
                return RedirectToAction("Default", "Member");
            }
            RegionCode();
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult PlantSeedNew(string LongLat, string crossStreet, string cityName, string stateCode, string zipcode)
        {
            #region
            RegionCode();
            string val1 = LongLat;
            return Redirect("/Seed/PlantSeed/" + val1);
            #endregion
        }

        public ActionResult PlantSeed(string id)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
            {
                string universalURL = "http://" + (Request.ServerVariables["SERVER_NAME"] + Request.ServerVariables["URL"]).ToString();
                SessionStore.SetSessionValue("RequestedURL", universalURL);
                return RedirectToAction("Default", "Member");
            }
            if (!string.IsNullOrEmpty(id))
            {
                string[] ab = id.Split(',');
                ViewData["LocationLat"] = ab[0].ToString();
                ViewData["LocationLong"] = ab[1].ToString();
            }   
            bindCategory();
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult PlantSeed(string seedTitle, string description, string info, string address, string keyword, string categoryIds)
        {
            #region
            try
            {
                SeedAction objSeed = new SeedAction();
                LocationAction objLocation = new LocationAction();                

                //Format address and create add seed model
                string[] splitAddress = address.Split(',');
                AddSeed seedData = new AddSeed();
                seedData.SeedName = seedTitle;

                badWordsFilter objWords = new badWordsFilter();
                string filePath=Server.MapPath("~/utils/badWords.xml");
                List<string> lstBadWords = badWordsFilter.BadWordList(ref filePath);
                description = objWords.FilterBadWords(lstBadWords, description);

                seedData.Description = description;
                seedData.LongLat = info;
                seedData.Tag = keyword;
                seedData.StreetAddress = splitAddress[0].ToString();
                seedData.City = splitAddress[1].ToString().Trim();
                string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                seedData.ZipCode = splitZipRegion[1].ToString().Trim();
                seedData.StateCode = splitZipRegion[0].ToString().Trim();
                //End formatting address

                string[] arrCategoryIds;
                string latLong = seedData.LongLat;
                char[] separator = new char[] { ',' };
                string[] strSplitLatLong = latLong.Split(separator);
                string lat = strSplitLatLong[0].ToString();
                string longt = strSplitLatLong[1].ToString();
                categoryIds = categoryIds.TrimStart(',');
                arrCategoryIds = categoryIds.Split(',');

                string plantedSeedId = AddSeedData(seedData);
                bool isPlanted = false;
                if (categoryIds.Trim().ToString() != "")
                {
                    isPlanted = objSeed.AddCategories(plantedSeedId, arrCategoryIds);
                }
                bindCheckBox(plantedSeedId);

                Seed seed = GetSeedInformation(plantedSeedId);

                #region Send Mail
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(seed.Member.firstName + " " + seed.Member.lastName);
                arrTokens.Add(seed.title);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/SeedDetails/" + seed.id);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/Profile");

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = seed.Member.username;
                objSendMail.Subject = "email.seedPlanted.subject.content";
                objSendMail.MsgBody = "email.seedPlanted.body.content";
                objSendMail.ChangesInMessage = arrTokens;

                objSendMail.SendEmail(objSendMail);
                #endregion

                return Redirect("/Seed/SeedDetails/" + seed.id);
            }
            catch (Exception ex)
            {
                ViewData["SeedPlant"] = ex.Message.ToString();
            }
            bindCategory();
            return View();
            #endregion
        }

        // *************************************
        // URL: /Seed/AddSeed
        // *************************************
        public ActionResult AddSeed()
        {
            return View();
        }

        [HttpPost]
        public ActionResult AddSeed(AddSeed objAddSeedModel)
        {
            if (ModelState.IsValid)
            {
                SessionStore.SetSessionValue(SessionStore.SeedModel, objAddSeedModel);
                return RedirectToAction("SetCategory", "Seed");
            }
            else
            {
                return View(objAddSeedModel);
            }
        }

        public string AddSeedData(AddSeed objAddSeedModel)
        {
            #region
            bool actionCompleted = false;
            Seed seedData = null;
            SeedAction objSeed = new SeedAction();

            Seed objSeedEntity = new Seed();
            Member memberData = new Member();
            Tag objTagEntity = new Tag();

            objSeedEntity.title = objAddSeedModel.SeedName;
            if (!string.IsNullOrEmpty(objAddSeedModel.rootSeedId))
                objSeedEntity.rootSeedID = new Guid(objAddSeedModel.rootSeedId);

            if (!string.IsNullOrEmpty(objAddSeedModel.parentSeedId))
                objSeedEntity.parentSeedID = new Guid(objAddSeedModel.parentSeedId);

            string s = Regex.Replace(objAddSeedModel.Description, @"<(.|\n)*?>", string.Empty);
            s = s.Replace("&nbsp;", " ");
            s = Regex.Replace(s, @"\s+", " ");
            s = Regex.Replace(s, @"\r\n", "\n");
            s = Regex.Replace(s, @"\n+", "\n");
            string description = s;

            if (description.Length > 999)
                description = description.Substring(0, 995);

            badWordsFilter objWords = new badWordsFilter();
            string filePath = Server.MapPath("~/utils/badWords.xml");
            List<string> lstBadWords = badWordsFilter.BadWordList(ref filePath);
            description = objWords.FilterBadWords(lstBadWords, description);

            objSeedEntity.description = description;

            LocationAction objLocation = new LocationAction();
            string cityid = objLocation.GetCityIdByCityName(objAddSeedModel.City, objAddSeedModel.StateCode);
            if (string.IsNullOrEmpty(cityid))
                cityid = objSeed.AddCity(objAddSeedModel.City, objAddSeedModel.StateCode);

            if (string.IsNullOrEmpty(cityid))
                throw new Exception("Please select associated state and city");
            string latLong = objAddSeedModel.LongLat;
            char[] separator = new char[] { ',' };
            string[] strSplitLatLong = latLong.Split(separator);
            string lat = strSplitLatLong[0].ToString();
            string longt = strSplitLatLong[1].ToString();
            string crossStreet = objAddSeedModel.StreetAddress.Trim();
            Location objLoc = objLocation.CreateLocation(cityid, (objAddSeedModel.ZipCode).ToString(), Convert.ToDouble(lat), Convert.ToDouble(longt), crossStreet);

            objSeedEntity.locationId = new Guid(objLoc.id.ToString());

            if (SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject) != null)
                memberData = (Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
            objSeedEntity.ownerId = memberData.id;
            seedData = objSeed.AddSeed(objSeedEntity);


            if (objSeedEntity.id != null)
            {
                if (!string.IsNullOrEmpty(objAddSeedModel.Tag))
                {
                    objTagEntity.name = objAddSeedModel.Tag;
                    objTagEntity.seedId = objSeedEntity.id;
                    actionCompleted = objSeed.ManageTag(objTagEntity);
                }
            }
            if (actionCompleted == false)
            {
                ModelState.AddModelError("", "Error while seed planting.");
                RedirectToAction("AddSeed", "Seed");
            }

            return seedData.id.ToString();
            #endregion
        }

        // *************************************
        // URL: /Seed/All
        // *************************************
        public ActionResult MemberList()
        {
            #region
            SeedAction objSeed = new SeedAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<Seed> listSeed = objSeed.GetSeedsByUser(memberData.id.ToString()).ToList();
            ViewData["ListSeed"] = listSeed;

            return View();
            #endregion
        }

        public ActionResult SetCategory(string seedId)
        {
            bindCheckBox(seedId);
            return View();
        }

        public void bindCheckBox(string seedId)
        {
            #region
            SeedAction objSeed = new SeedAction();
            IList<Category> category;
            IList<Category> scategory;

            category = objSeed.GetAllCategories();


            string ids = string.Empty;
            foreach (Category sc in category)
            {
                if (ids.Length > 0)
                {
                    ids = ids + "," + sc.id;
                }
                else
                {
                    ids = sc.id.ToString();
                }
            }

            ViewData["ids"] = ids;

            ViewData["categoryId"] = category;
            if (seedId != null)
            {
                scategory = objSeed.GetCategoryBySeedID(seedId);
                ViewData["selectCategoryId"] = scategory;
            }
            #endregion
        }

        [HttpPost]
        public ActionResult SetCategory(string seedId, string categoryIds, AddSeed objAddSeedModel)
        {
            #region
            if (ModelState.IsValid)
            {
                try
                {
                    SeedAction objSeed = new SeedAction();
                    LocationAction objLocation = new LocationAction();                    
                    AddSeed seedData = (AddSeed)objAddSeedModel;

                    string[] arrCategoryIds;
                    string latLong = seedData.LongLat;
                    char[] separator = new char[] { ',' };
                    string[] strSplitLatLong = latLong.Split(separator);
                    string lat = strSplitLatLong[0].ToString();
                    string longt = strSplitLatLong[1].ToString();
                    categoryIds = categoryIds.TrimStart(',');
                    arrCategoryIds = categoryIds.Split(',');

                    string plantedSeedId = AddSeedData(seedData);
                    bool isPlanted = false;
                    if (categoryIds.Trim().ToString() != "")
                    {
                        isPlanted = objSeed.AddCategories(plantedSeedId, arrCategoryIds);
                    }
                    bindCheckBox(plantedSeedId);                    
                    Seed seed = GetSeedInformation(plantedSeedId);

                    #region Send Mail
                    // Creating array list for token 
                    ArrayList arrTokens = new ArrayList();
                    arrTokens.Add(seed.Member.firstName + " " + seed.Member.lastName);
                    arrTokens.Add(seed.title);
                    arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/SeedDetails/" + seed.id);
                    arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/Profile");

                    // Filling mail object
                    SendMail objSendMail = new SendMail();
                    objSendMail.ToEmailId = seed.Member.username;
                    objSendMail.Subject = "email.seedPlanted.subject.content";
                    objSendMail.MsgBody = "email.seedPlanted.body.content";
                    objSendMail.ChangesInMessage = arrTokens;

                    objSendMail.SendEmail(objSendMail);
                    #endregion

                    return Redirect("/Seed/SeedDetails/" + seed.id);
                }
                catch (Exception ex)
                {
                    ViewData["SeedPlant"] = ex.Message.ToString();
                }
            }
            miniDashboard();
            bindCategory();
            RegionCode();
            return View("../Member/Dashboard");
            #endregion
        }

        public void miniDashboard()
        {
            #region
            SeedAction objSeed = new SeedAction();
            LocationAction objLocation = new LocationAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<Location> locData = objLocation.GetLocationByMemberId(memberData.id.ToString());
            Location memberLocation = objLocation.GetMemberLocationById(memberData.id.ToString());
            if (memberLocation == null)
            {
                memberLocation = new Location();
                memberLocation.localLong = SystemStatements.DEFAULT_Long;
                memberLocation.localLat = SystemStatements.DEFAULT_Lat;
            }

            IList<Seed> listSeed = objSeed.GetSeedsByUser(memberData.id.ToString()).ToList();
            string locations = "";
            if (locData == null)
            {
                locations = SystemStatements.DEFAULT_Lat + "," + SystemStatements.DEFAULT_Long;
            }
            else
            {
                int counter = 0;
                foreach (Location tempLocation in locData)
                {
                    if (counter == 10)
                    {
                        break;
                    }
                    locations += tempLocation.localLat + "," + tempLocation.localLong + ",";
                    counter++;
                }
                locations = locations.Substring(0, locations.Length - 1);
            }

            ViewData["ListSeed"] = listSeed;
            ViewData["LocationData"] = locations;
            ViewData["Memberlocation"] = memberLocation;
            #endregion
        }

        public ActionResult SeedResponse()
        {
            return View();
        }

        [HttpPost]
        public ActionResult DeleteSeed(string id)
        {
            return RedirectToAction("SetCategory", "Seed");
        }

        // *************************************
        // URL: /Seed/EditSeed
        // *************************************
        public ActionResult EditSeed(string id)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
                return RedirectToAction("Default", "Member");
            SeedAction objSeed = new SeedAction();
            Seed seed = objSeed.GetSeedBySeedId(id);
            ViewData["SeedInfo"] = seed;
            bindCategory();
            SelectedCategory(id);
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult EditSeed(string SeedId, string SeedTitle, string SeedDescription, string SeedTags, string categoryIds)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seed = objSeed.GetSeedBySeedId(SeedId);
            seed.title = SeedTitle;

            badWordsFilter objWords = new badWordsFilter();
            string filePath = Server.MapPath("~/utils/badWords.xml");
            List<string> lstBadWords = badWordsFilter.BadWordList(ref filePath);
            string description = objWords.FilterBadWords(lstBadWords, SeedDescription);

            if (description.Length > 999)
                description = description.Substring(0, 995);

            seed.description = description;
            seed = objSeed.UpdateSeed(seed);
            
            string[] arrCategoryIds;            
            char[] separator = new char[] { ',' };
            categoryIds = categoryIds.TrimStart(',');
            arrCategoryIds = categoryIds.Split(',');            
            bool isPlanted = false;
            if (categoryIds.Trim().ToString() != "")
            {
                isPlanted = objSeed.AddCategories(SeedId, arrCategoryIds);
            }

            Tag objTagEntity = new Tag();
            if (!string.IsNullOrEmpty(SeedTags))
            {
                objTagEntity.name = SeedTags;
                objTagEntity.seedId = new Guid(SeedId);
                objSeed.ManageTag(objTagEntity);
            }

            if (seed.id != null)
            {
                //send automated email - content of email will be decided later
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(seed.Member.firstName + " " + seed.Member.lastName);
                arrTokens.Add(seed.title);

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = seed.Member.username;
                objSendMail.Subject = "email.editSeed.subject.content";
                objSendMail.MsgBody = "email.editSeed.body.content";
                objSendMail.ChangesInMessage = arrTokens;

                objSendMail.SendEmail(objSendMail);
            }
            Response.Redirect("/Seed/SeedDetails/" + SeedId);
            return View();
            #endregion
        }

        public ActionResult UploadMedia(string id)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
                return RedirectToAction("Default", "Member");

            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(id);
            ViewData["SeedTitle"] = seedData.title;
            ViewData["SeedValue"] = seedData.id;
            ViewData["SeedData"] = seedData;

            IList<Medium> MList = seedData.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).ToList();
            ViewData["MList"] = MList;
            return View();
            #endregion
        }

        public ActionResult UploadVedioMedia(string id)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
                return RedirectToAction("Default", "Member");
            
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(id);
            ViewData["SeedTitle"] = seedData.title;
            ViewData["SeedValue"] = seedData.id;
            ViewData["SeedData"] = seedData;
            
            IList<Medium> MList = seedData.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_VIDEO)).OrderByDescending(x => x.dateUploaded).ToList();
            ViewData["MList"] = MList;
            return View();
            #endregion
        }

        private string CheckFile(string file, int filesize)
        {
            #region
            string fileCheck = "";
            string extension = "";
            if (file != null)
                extension = System.IO.Path.GetExtension(file);
            if (extension == ".jpg" || extension == ".png" || extension == ".gif" && filesize < 2048)
            {
                fileCheck = SystemStatements.MEDIA_IMAGE;
            }
            else if (extension == ".wmv" || extension == ".mpeg" || extension == ".mp4" || extension == ".avi" || extension == ".swf" || extension == ".mpg" || extension == ".flv")
            {
                if (filesize < 51200000)
                    fileCheck = SystemStatements.MEDIA_VIDEO;
                else
                    fileCheck = "Invalid";
            }
            else
            {
                fileCheck = "Invalid";
            }
            return fileCheck;
            #endregion
        }

        private ImageFormat FileExtensionToImageFormat(String filePath)
        {
            #region
            String ext = Path.GetExtension(filePath).ToLower();
            ImageFormat result = ImageFormat.Jpeg;
            switch (ext)
            {
                case ".gif":
                    result = ImageFormat.Gif;
                    break;
                case ".png":
                    result = ImageFormat.Png;
                    break;
                case ".jpeg":
                    result = ImageFormat.Jpeg;
                    break;

            }
            return result;
            #endregion
        }

        [HttpPost]
        public ActionResult UploadVedioMedia(HttpPostedFileBase uploadFile, MediaManagement objMedia, string seedId)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            try
            {
                if (uploadFile != null)
                {
                    if (uploadFile.ContentLength > 0)
                    {
                        bool isMediaSaved = false;
                        int fileSize = uploadFile.ContentLength;
                        string fileOk = CheckFile(uploadFile.FileName, fileSize);
                        string strFileExtension = System.IO.Path.GetExtension(uploadFile.FileName);
                        
                        DateTime dat = DateTime.Now;
                        string fileUploadtime = dat.Day.ToString() + dat.Month.ToString() + dat.Year.ToString() + dat.Hour.ToString() + dat.Minute.ToString() + dat.Second.ToString();
                        string filePath = Path.Combine(HttpContext.Server.MapPath("/UploadedMedia"), (memberData.id.ToString() + "_" + fileUploadtime + strFileExtension));
                        
                        objMedia.path = "../../UploadedMedia/" + (memberData.id.ToString() + "_" + fileUploadtime + strFileExtension);
                        objMedia.type = fileOk;
                        if (fileOk == SystemStatements.MEDIA_VIDEO)
                        {
                            uploadFile.SaveAs(filePath);
                            objMedia.embedScript = "Media Script";
                            isMediaSaved = SaveMediaInformation(objMedia);
                            if (isMediaSaved == true)
                            {
                                SendMediaUploadMail(seedId);
                                ViewData["MediaMsg"] = "<b>Media has been uploaded successfully.</b>";
                            }
                        }

                        if (fileOk == "Invalid")
                        {
                            ViewData["MediaMsg"] = "<span>Please check file type or file size, Max Size Allowed : 4 MB</span>";
                        }
                    }
                    else
                    {
                        ViewData["MediaMsg"] = "<span>Please check file type or file size.</span>";
                    }
                }
                else
                {
                    ViewData["MediaMsg"] = "<span>Please select a file.</span>";
                }
            }
            catch (Exception ex)
            {
                ViewData["MediaMsg"] = ex.Message.ToString();
            }
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(seedId);
            ViewData["SeedTitle"] = seedData.title;
            ViewData["SeedValue"] = seedData.id;
            ViewData["SeedData"] = seedData;            
            IList<Medium> MList = seedData.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_VIDEO)).OrderByDescending(x => x.dateUploaded).ToList();
            ViewData["MList"] = MList;
            
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult UploadMedia(HttpPostedFileBase uploadFile, MediaManagement objMedia, string seedId)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            try
            {
                if (uploadFile != null)
                {
                    if (uploadFile.ContentLength > 0)
                    {
                        bool isMediaSaved = false;
                        int fileSize = uploadFile.ContentLength;
                        string fileOk = CheckFile(uploadFile.FileName, fileSize);
                        string strImgFileExtension = System.IO.Path.GetExtension(uploadFile.FileName);
                        DateTime datImg = DateTime.Now;
                        string ImgfileUploadtime = datImg.Day.ToString() + datImg.Month.ToString() + datImg.Year.ToString() + datImg.Hour.ToString() + datImg.Minute.ToString() + datImg.Second.ToString();
                        
                        string filePath = Path.Combine(HttpContext.Server.MapPath("/UploadedMedia"), (memberData.id.ToString() + "_" + ImgfileUploadtime + strImgFileExtension));
                        
                        objMedia.path = "../../UploadedMedia/" + (memberData.id.ToString() + "_" + ImgfileUploadtime + strImgFileExtension);
                        objMedia.type = fileOk;
                        
                        if (fileOk == SystemStatements.MEDIA_IMAGE)
                        {
                            int maxImageWidth = 600;
                            Bitmap sourceImage = new Bitmap(uploadFile.InputStream);

                            // Resize if source image width is greater than the max:
                            if (sourceImage.Width > maxImageWidth)
                            {
                                int newImageHeight = (int)(sourceImage.Height * ((float)maxImageWidth / (float)sourceImage.Width));
                                Bitmap resizedImage = new Bitmap(maxImageWidth, newImageHeight);
                                Graphics gr = Graphics.FromImage(resizedImage);
                                gr.InterpolationMode = InterpolationMode.HighQualityBicubic;
                                gr.DrawImage(sourceImage, 0, 0, maxImageWidth, newImageHeight);
                                // Save the resized image:
                                resizedImage.Save(filePath, FileExtensionToImageFormat(filePath));
                                objMedia.embedScript = "Image Script";
                                isMediaSaved = SaveMediaInformation(objMedia);
                                if (isMediaSaved == true)
                                {
                                    SendMediaUploadMail(seedId);
                                    ViewData["MediaMsg"] = "<b>Image has been uploaded successfully.</b>";
                                }
                            }
                            else
                            {
                                // Save the source image (no resizing necessary):
                                sourceImage.Save(filePath, FileExtensionToImageFormat(filePath));
                                objMedia.embedScript = "Image Script";
                                isMediaSaved = SaveMediaInformation(objMedia);
                                if (isMediaSaved == true)
                                {
                                    SendMediaUploadMail(seedId);
                                    ViewData["MediaMsg"] = "<b>Image has been uploaded successfully.</b>";
                                }
                            }
                        }
                        if (fileOk == "Invalid")
                        {
                            ViewData["MediaMsg"] = "<span>Please check file type or file size, Max Size Allowed : 4 MB</span>";
                        }
                    }
                    else
                    {
                        ViewData["MediaMsg"] = "<span>Please check file type or file size.</span>";
                    }
                }
                else
                {
                    ViewData["MediaMsg"] = "<span>Please select a file.</span>";
                }
            }
            catch (Exception ex)
            {
                ViewData["MediaMsg"] = ex.Message.ToString();
            }
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(seedId);
            ViewData["SeedTitle"] = seedData.title;
            ViewData["SeedValue"] = seedData.id;
            ViewData["SeedData"] = seedData;
            IList<Medium> MList = seedData.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).ToList();
            ViewData["MList"] = MList;
            
            return View();
            #endregion
        }

        private bool SaveMediaInformation(MediaManagement objMedia)
        {
            #region
            bool isInfoSaved = false;
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            objMedia.uploadedById = memberData.id.ToString();
            MediaAction objMediaAction = new MediaAction();
            objMediaAction.AddMedia(objMedia);
            isInfoSaved = true;
            return isInfoSaved;
            #endregion
        }

        public void DeleteMedia(string id, string seedID)
        {
            #region
            bool isDeleted = false;
            MediaAction objMedia = new MediaAction();
            isDeleted = objMedia.DeleteMedia(id);
            if (isDeleted == true)
            {
                ModelState.AddModelError("", "Media has been deleted successfully.");
            }
            else
            {
                ModelState.AddModelError("", "Can not delete media.");
            }
            Response.Redirect("/Seed/UploadMedia/" + seedID);
            #endregion
        }

        public void DeleteVideo(string id, string seedID)
        {
            #region
            bool isDeleted = false;
            MediaAction objMedia = new MediaAction();
            isDeleted = objMedia.DeleteMedia(id);
            if (isDeleted == true)
            {
                ModelState.AddModelError("", "Media has been deleted successfully.");
            }
            else
            {
                ModelState.AddModelError("", "Can not delete media.");
            }
            Response.Redirect("/Seed/UploadVedioMedia/" + seedID);
            #endregion
        }

        public void SendMediaUploadMail(string seedID)
        {
            SeedAction objseed = new SeedAction();
            Seed seed = objseed.GetSeedBySeedId(seedID);
            ContributionMail((seed.Member.firstName + " " + seed.Member.lastName).ToString(), seed.title, seed.Member.username, "Media");
        }

        // *************************************
        // URL: /Seed/ManageSeeds
        // *************************************
        private void GetUserCommitments()
        {
            SeedAction objSeed = new SeedAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<Seed> lstSeed = objSeed.GetSeedsByCommitments(memberData.id.ToString());
            ViewData["ListCommitment"] = lstSeed;
        }

        private void GetAllMemberList()
        {
            MemberAction objMember = new MemberAction();
            IList<Member> lstMember = objMember.GetAllMember().ToList();
            ViewData["ListMem"] = lstMember;
        }

        private void GetSavedFavoriteSeeds()
        {
            SeedAction objSeed = new SeedAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<Seed> ListFavoriteSeeds = objSeed.GetAllFavouriteSeeds(memberData.id.ToString());
            ViewData["FavoriteSeeds"] = ListFavoriteSeeds;
        }

        private void GetGrowingSeeds()
        {
            SeedAction objSeed = new SeedAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<Seed> tempList1 = objSeed.GetAllSeedsByStatus(memberData.id.ToString(), SystemStatements.STATUS_GROWING);
            IList<Seed> tempList2 = objSeed.GetAllSeedsCommentedByMe(memberData.id.ToString());
            var tempList3 = tempList1.Union(tempList2);
            IList<Seed> ListGrowingSeeds = (from gs in tempList3 select gs).OrderByDescending(x => x.createDate).Distinct().ToList();
            ViewData["GrowingSeeds"] = ListGrowingSeeds;
        }

        private void GetHarvestedSeeds()
        {
            SeedAction objSeed = new SeedAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<Seed> lstHarvestedSeed = objSeed.GetHarvestedSeedsByUser(memberData.id.ToString());
            ViewData["ListHarvestedSeeds"] = lstHarvestedSeed;
        }

        public ActionResult ManageSeeds()
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
                return RedirectToAction("Default", "Member");
            SeedAction objSeed = new SeedAction();
            IList<Seed> listSeed = objSeed.GetSeedsByUser(memberData.id.ToString()).ToList();
            ViewData["ListSeed"] = listSeed;

            GetGrowingSeeds();
            GetSavedFavoriteSeeds();
            GetUserCommitments();
            GetHarvestedSeeds();

            return View();
            #endregion
        }

        public void HarvestSeed(string id)
        {
            #region
            bool isCompleted = false;
            SeedAction objSeed = new SeedAction();
            Seed seed = GetSeedInformation(id);
            isCompleted = objSeed.HarvestTerminateSeed(id, "Harvest");
            if (isCompleted == true)
            {
                //send automated email to inform the administrator that a new flag has been posted on a seed
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(seed.Member.firstName + " " + seed.Member.lastName);
                arrTokens.Add(seed.title);

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = seed.Member.username;                
                objSendMail.Subject = "email.harvestSeed.subject.content";
                objSendMail.MsgBody = "email.harvestSeed.body.content";
                objSendMail.ChangesInMessage = arrTokens;
                objSendMail.SendEmail(objSendMail);// 
                Response.Redirect("/Seed/ManageSeeds");
            }
            #endregion
        }

        public void TerminateSeed(string id)
        {
            bool isCompleted = false;
            SeedAction objSeed = new SeedAction();
            isCompleted = objSeed.HarvestTerminateSeed(id, "Terminate");
            if (isCompleted == true)
                Response.Redirect("/Seed/ManageSeeds");
        }

        public Seed GetSeedInformation(string seedID)
        {
            SeedAction objSeed = new SeedAction();
            Seed seed = objSeed.GetSeedBySeedId(seedID);
            return seed;
        }

        // *************************************
        // URL: /Seed/DiscoverSeed
        // *************************************
        public ActionResult DiscoverSeed(string cstreet, string city, string zip, string category, string keyword, string LatLongMaster, string byUser, string byRating)
        {
            #region
            string facebookLogin = (string)SessionStore.GetSessionValue(SessionStore.FacebookConnect);
            if (!string.IsNullOrEmpty(facebookLogin))
            {
                if (city == "City" || city == null)
                {
                    string ip = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                    if (string.IsNullOrEmpty(ip))
                    {
                        ip = Request.ServerVariables["REMOTE_ADDR"];
                    }
                    
                    DataTable dtAddress = GetLocation(ip);
                    if (dtAddress != null)
                    {
                        if (dtAddress.Rows.Count > 0)
                        {
                            city = dtAddress.Rows[0]["City"].ToString();
                            if (string.IsNullOrEmpty(city))
                                city = "Phoenix";
                        }
                        else
                        {
                            city = "Phoenix";
                        }
                    }
                }
            }
            
            LocationAction objLocation = new LocationAction();
            SeedAction objSeed = new SeedAction();
            CategoryAction objCategory = new CategoryAction();

            string CatId = objCategory.GetCategoryIdByCategoryName(category);
            IList<Seed> listSeed = null;

            //Storing search result in session
            if (string.IsNullOrEmpty(cstreet) && string.IsNullOrEmpty(city) && string.IsNullOrEmpty(zip) && string.IsNullOrEmpty(category) && string.IsNullOrEmpty(keyword) && string.IsNullOrEmpty(LatLongMaster))
            {
                if (SessionStore.GetSessionValue(SessionStore.DiscoverSeed) != null)
                    listSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.DiscoverSeed);
            }
            else
            {
                listSeed = this.getSearchResult(cstreet, city, CatId, keyword, zip, byUser, byRating);
            }

            if (listSeed.Count > 0)
                SessionStore.SetSessionValue(SessionStore.DiscoverSeed, listSeed);

            string latlong = "";
            if (listSeed.Count > 0)
            {
                for (int i = 0; i < listSeed.Count; i++)
                {
                    if (latlong == "")
                    {
                        latlong = listSeed[i].Location.localLat + "," + listSeed[i].Location.localLong + "," + listSeed[i].title + "-<b>" + listSeed[i].status + "</b> <br />" + listSeed[i].Location.City.name + " " + listSeed[i].Location.zipcode + ",";
                    }
                    else
                    {
                        latlong += listSeed[i].Location.localLat + "," + listSeed[i].Location.localLong + "," + listSeed[i].title + "-<b>" + listSeed[i].status + "</b> <br />" + listSeed[i].Location.City.name + " " + listSeed[i].Location.zipcode + ",";
                    }
                }
            }
            Array late = latlong.Split(',');
            ViewData["LatLongCollection"] = latlong;
            if (listSeed.Count > 0)
                ViewData["ListSeed"] = listSeed;
            else
                ViewData["SearchMsg"] = "No matching seed found for your search criteria";

            return View();
            #endregion
        }

        public DataTable GetLocation(string ipAddress)
        {
            #region
            //Create a WebRequest
            WebRequest rssReq = WebRequest.Create("http://freegeoip.appspot.com/xml/" + ipAddress);

            //Create a Proxy
            WebProxy px = new WebProxy("http://freegeoip.appspot.com/xml/" + ipAddress, true);

            //Assign the proxy to the WebRequest
            rssReq.Proxy = px;

            //Set the timeout in Seconds for the WebRequest
            rssReq.Timeout = 2000;
            try
            {
                //Get the WebResponse
                WebResponse rep = rssReq.GetResponse();

                //Read the Response in a XMLTextReader
                XmlTextReader xtr = new XmlTextReader(rep.GetResponseStream());

                //Create a new DataSet
                DataSet ds = new DataSet();

                //Read the Response into the DataSet
                ds.ReadXml(xtr);
                return ds.Tables[0];
            }
            catch
            {
                return null;
            }
            #endregion
        }

        public ActionResult SortByCategory()
        {
            #region
            IList<Seed> listSeed = null;
            if (SessionStore.GetSessionValue(SessionStore.DiscoverSeed) != null)
                listSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.DiscoverSeed);

            string latlong = "";
            if (listSeed.Count > 0)
            {
                for (int i = 0; i < listSeed.Count; i++)
                {
                    if (latlong == "")
                    {
                        latlong = listSeed[i].Location.localLat + "," + listSeed[i].Location.localLong + "," + listSeed[i].title + "-<b>" + listSeed[i].status + "</b> <br />" + listSeed[i].Location.City.name + " " + listSeed[i].Location.zipcode + ",";
                    }
                    else
                    {
                        latlong += listSeed[i].Location.localLat + "," + listSeed[i].Location.localLong + "," + listSeed[i].title + "-<b>" + listSeed[i].status + "</b> <br />" + listSeed[i].Location.City.name + " " + listSeed[i].Location.zipcode + ",";
                    }
                }
            }
            ViewData["LatLongCollection"] = latlong;
            if (listSeed.Count > 0)
                ViewData["ListSeed"] = listSeed.OrderBy(x => x.Categories.FirstOrDefault() != null ? x.Categories.FirstOrDefault().name : "");
            else
                ViewData["SearchMsg"] = "No matching seed found for your search criteria";

            return View("DiscoverSeed");
            #endregion
        }

        public ActionResult SortByZipcode()
        {
            #region
            IList<Seed> listSeed = null;
            if (SessionStore.GetSessionValue(SessionStore.DiscoverSeed) != null)
                listSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.DiscoverSeed);

            string latlong = "";
            if (listSeed.Count > 0)
            {
                for (int i = 0; i < listSeed.Count; i++)
                {
                    if (latlong == "")
                    {
                        latlong = listSeed[i].Location.localLat + "," + listSeed[i].Location.localLong + "," + listSeed[i].title + "-<b>" + listSeed[i].status + "</b> <br />" + listSeed[i].Location.City.name + " " + listSeed[i].Location.zipcode + ",";
                    }
                    else
                    {
                        latlong += listSeed[i].Location.localLat + "," + listSeed[i].Location.localLong + "," + listSeed[i].title + "-<b>" + listSeed[i].status + "</b> <br />" + listSeed[i].Location.City.name + " " + listSeed[i].Location.zipcode + ",";
                    }
                }
            }
            ViewData["LatLongCollection"] = latlong;
            if (listSeed.Count > 0)
                ViewData["ListSeed"] = listSeed.OrderBy(x => x.Location.zipcode);
            else
                ViewData["SearchMsg"] = "No matching seed found for your search criteria";

            return View("DiscoverSeed");
            #endregion
        }

        public ActionResult SortByKeyword()
        {
            #region
            IList<Seed> listSeed = null;
            if (SessionStore.GetSessionValue(SessionStore.DiscoverSeed) != null)
                listSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.DiscoverSeed);

            string latlong = "";
            if (listSeed.Count > 0)
            {
                for (int i = 0; i < listSeed.Count; i++)
                {
                    if (latlong == "")
                    {
                        latlong = listSeed[i].Location.localLat + "," + listSeed[i].Location.localLong + "," + listSeed[i].title + "-<b>" + listSeed[i].status + "</b> <br />" + listSeed[i].Location.City.name + " " + listSeed[i].Location.zipcode + ",";
                    }
                    else
                    {
                        latlong += listSeed[i].Location.localLat + "," + listSeed[i].Location.localLong + "," + listSeed[i].title + "-<b>" + listSeed[i].status + "</b> <br />" + listSeed[i].Location.City.name + " " + listSeed[i].Location.zipcode + ",";
                    }
                }
            }
            ViewData["LatLongCollection"] = latlong;
            if (listSeed.Count > 0)
                ViewData["ListSeed"] = listSeed.OrderBy(x => x.title);
            else
                ViewData["SearchMsg"] = "No matching seed found for your search criteria";

            return View("DiscoverSeed");
            #endregion
        }        

        // *************************************
        // URL: /Seed/SeedDetails
        // *************************************

        public ActionResult SeedDetailsFB(string id)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedDetail = objSeed.GetSeedBySeedId(id);
            if (seedDetail == null)
                return RedirectToAction("Default", "Member");
            ViewData["SeedDetails"] = seedDetail;

            int result = 0;
            result = objSeed.GetMemberAuthority(seedDetail.ownerId.ToString(), "Contribution");
            if (result == 1)
            {
                ViewData["ContributionAuth"] = "False";
            }
            else
            {
                ViewData["ContributionAuth"] = "True";
            }

            result = objSeed.GetMemberAuthority(seedDetail.ownerId.ToString(), "Commitment");
            if (result == 1)
            {
                ViewData["CommitmentAuth"] = "False";
            }
            else
            {
                ViewData["CommitmentAuth"] = "True";
            }

            result = objSeed.GetMemberAuthority(seedDetail.ownerId.ToString(), "MyUsername");
            switch (result)
            {
                case 0:
                    ViewData["UsernameAuth"] = 0;
                    break;
                case 1:
                    ViewData["UsernameAuth"] = 1;
                    break;
                case 2:
                    ViewData["UsernameAuth"] = 2;
                    break;
                case 3:
                    ViewData["UsernameAuth"] = 3;
                    break;
                default:
                    ViewData["UsernameAuth"] = 0;
                    break;
            }

            ViewData["SeedComments"] = seedDetail.Comments.OrderByDescending(x => x.commentDate).Take(5).ToList();

            int SeedLike = objSeed.getSeedRatingCountBySeedId(id, "Like");
            ViewData["SeedLike"] = SeedLike;
            int SeedDislike = objSeed.getSeedRatingCountBySeedId(id, "DLike");
            ViewData["SeedDislike"] = SeedDislike;
            int SeedCommitments = objSeed.getSeedCommitmentCountBySeedId(id);
            ViewData["SeedCommitments"] = SeedCommitments;

            IList<Medium> MList = seedDetail.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).ToList();
            ViewData["MList"] = MList;

            IList<Medium> VList = seedDetail.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_VIDEO)).ToList();
            ViewData["VList"] = VList.OrderByDescending(x => x.dateUploaded).Take(1).ToList();
            bindCategory();
            GetAllCitiesAndTags();
            RegionCode();
            return View();
            #endregion
        }

        public ActionResult SeedDetails(string id)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
            {
                string universalURL = "http://" + (Request.ServerVariables["SERVER_NAME"] + Request.ServerVariables["URL"]).ToString();
                SessionStore.SetSessionValue("RequestedURL", universalURL);
                return RedirectToAction("Default", "Member");
            }
            SeedAction objSeed = new SeedAction();
            Seed seedDetail = objSeed.GetSeedBySeedId(id);
            if (seedDetail == null)
            {
                SeedSpeak.Util.SessionStore.SetSessionValue(SeedSpeak.Util.SessionStore.SeedError, "Seed Error");
                return RedirectToAction("UnexpectedError", "Error");
            }
            ViewData["SeedDetails"] = seedDetail;
            if (seedDetail != null)
            {
                Member memberDetails = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

                int result = 0;
                result = objSeed.GetMemberAuthority(seedDetail.ownerId.ToString(), "Contribution");
                if (result == 1)
                {
                    ViewData["ContributionAuth"] = "False";
                }
                else
                {
                    ViewData["ContributionAuth"] = "True";
                }

                result = objSeed.GetMemberAuthority(seedDetail.ownerId.ToString(), "Commitment");
                if (result == 1)
                {
                    ViewData["CommitmentAuth"] = "False";
                }
                else
                {
                    ViewData["CommitmentAuth"] = "True";
                }

                result = objSeed.GetMemberAuthority(seedDetail.ownerId.ToString(), "MyUsername");
                switch (result)
                {
                    case 0:
                        ViewData["UsernameAuth"] = 0;
                        break;
                    case 1:
                        ViewData["UsernameAuth"] = 1;
                        break;
                    case 2:
                        ViewData["UsernameAuth"] = 2;
                        break;
                    case 3:
                        ViewData["UsernameAuth"] = 3;
                        break;
                    default:
                        ViewData["UsernameAuth"] = 0;
                        break;
                }

                ViewData["SeedComments"] = seedDetail.Comments.OrderByDescending(x => x.commentDate).Take(5).ToList();
            }
            int SeedLike = objSeed.getSeedRatingCountBySeedId(id, "Like");
            ViewData["SeedLike"] = SeedLike;
            int SeedDislike = objSeed.getSeedRatingCountBySeedId(id, "DLike");
            ViewData["SeedDislike"] = SeedDislike;
            int SeedCommitments = objSeed.getSeedCommitmentCountBySeedId(id);
            ViewData["SeedCommitments"] = SeedCommitments;

            if (seedDetail != null)
            {
                IList<Medium> MList = seedDetail.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).ToList();
                ViewData["MList"] = MList;

                IList<Medium> VList = seedDetail.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_VIDEO)).ToList();
                ViewData["VList"] = VList.OrderByDescending(x => x.dateUploaded).Take(1).ToList();
            }
            bindCategory();
            GetAllCitiesAndTags();
            GetActionNotifications();
            RegionCode();

            string isFlagged = (string)SessionStore.GetSessionValue(SessionStore.SeedFlagged);
            ViewData["isFlagged"] = "NotFlagged";
            if (!string.IsNullOrEmpty(isFlagged))
            {
                if (isFlagged == "FlagTrue")
                {
                    ViewData["isFlagged"] = "FlaggedSeed";
                    SessionStore.SetSessionValue(SessionStore.SeedFlagged, null);
                }
            }

            return View();
            #endregion
        }

        public void RegionCode()
        {
            LocationAction objLocation = new LocationAction();
            MemberAction objMember = new MemberAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<Model.Region> lstRegion = objLocation.GetAllRegions();
            ViewData["RegionList"] = new SelectList(lstRegion, "id", "code");
        }

        public void GetActionNotifications()
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            Repository repoObj = new Repository();

            //----------------Code for get all unread Comments-------------------
            IList<usp_GetCommentNotification_Result> listComments = repoObj.ListPP<usp_GetCommentNotification_Result>("usp_GetCommentNotification", memberData.id.ToString()).OrderByDescending(x => x.commentDate).ToList();
            ViewData["CommentNotification"] = listComments;
            IList<usp_GetCommentNotification_Result> listCommentsLimit = repoObj.ListPP<usp_GetCommentNotification_Result>("usp_GetCommentNotification", memberData.id.ToString()).OrderByDescending(x => x.commentDate).Take(5).ToList();
            ViewData["CommentNotificationLimit"] = listCommentsLimit;

            //----------------Code for get all unread Commitments----------------
            IList<usp_GetCommitmentNotification_Result> listCommitments = repoObj.ListPP<usp_GetCommitmentNotification_Result>("usp_GetCommitmentNotification", memberData.id.ToString()).OrderByDescending(x => x.commitDate).ToList();
            ViewData["CommitmentNotification"] = listCommitments;
            IList<usp_GetCommitmentNotification_Result> listCommitmentsLimit = repoObj.ListPP<usp_GetCommitmentNotification_Result>("usp_GetCommitmentNotification", memberData.id.ToString()).OrderByDescending(x => x.commitDate).Take(5).ToList();
            ViewData["CommitmentNotificationLimit"] = listCommitmentsLimit;

            //----------------Code for get all unread Flags----------------------
            IList<usp_GetFlagNotification_Result> listFlags = repoObj.ListPP<usp_GetFlagNotification_Result>("usp_GetFlagNotification", memberData.id.ToString()).OrderByDescending(x => x.dateFlagged).ToList();
            ViewData["FlagNotification"] = listFlags;
            IList<usp_GetFlagNotification_Result> listFlagsLimit = repoObj.ListPP<usp_GetFlagNotification_Result>("usp_GetFlagNotification", memberData.id.ToString()).OrderByDescending(x => x.dateFlagged).Take(5).ToList();
            ViewData["FlagNotificationLimit"] = listFlagsLimit;

            //----------------Code for get all unread likes----------------------
            IList<usp_GetLikeNotification_Result> listLikes = repoObj.ListPP<usp_GetLikeNotification_Result>("usp_GetLikeNotification", memberData.id.ToString()).ToList();
            ViewData["LikeNotification"] = listLikes;
            IList<usp_GetLikeNotification_Result> listLikesLimit = repoObj.ListPP<usp_GetLikeNotification_Result>("usp_GetLikeNotification", memberData.id.ToString()).Take(5).ToList();
            ViewData["LikeNotificationLimit"] = listLikesLimit;
            #endregion
        }

        public void GetAllCitiesAndTags()
        {
            SeedAction objSeed = new SeedAction();

            IList<Tag> lstTags = (from t in objSeed.GetAllTags()
                                  group t by new { t.name } into g
                                  select new Tag { name = g.Key.name }).ToList();

            ViewData["AutoTags"] = lstTags;
        }

        public void bindCategory()
        {
            #region
            SeedAction objSeed = new SeedAction();
            IList<Category> category;
            category = objSeed.GetAllCategories();
            string ids = string.Empty;
            foreach (Category sc in category)
            {
                if (ids.Length > 0)
                {
                    ids = ids + "," + sc.id;
                }
                else
                {
                    ids = sc.id.ToString();
                }
            }
            ViewData["ids"] = ids;
            ViewData["categoryId"] = category;
            #endregion
        }

        public void SelectedCategory(string seedId)
        {
            SeedAction objSeed = new SeedAction();
            IList<Category> category;
            category = objSeed.GetCategoryBySeedID(seedId);
            ViewData["SelCategory"] = category;
        }

        [HttpPost]
        public ActionResult SeedDetails(string DetailId, string name)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedDetail = objSeed.GetSeedBySeedId(DetailId);
            ViewData["SeedDetails"] = seedDetail;

            ViewData["SeedComments"] = seedDetail.Comments.OrderByDescending(x => x.commentDate).ToList();
            Member memberDetails = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            int result = 0;
            result = objSeed.GetMemberAuthority(seedDetail.ownerId.ToString(), "Contribution");
            if (result == 1)
            {
                ViewData["ContributionAuth"] = "False";
            }
            else
            {
                ViewData["ContributionAuth"] = "True";
            }

            result = objSeed.GetMemberAuthority(seedDetail.ownerId.ToString(), "Commitment");
            if (result == 1)
            {
                ViewData["CommitmentAuth"] = "False";
            }
            else
            {
                ViewData["CommitmentAuth"] = "True";
            }

            result = objSeed.GetMemberAuthority(seedDetail.ownerId.ToString(), "MyUsername");
            switch (result)
            {
                case 0:
                    ViewData["UsernameAuth"] = 0;
                    break;
                case 1:
                    ViewData["UsernameAuth"] = 1;
                    break;
                case 2:
                    ViewData["UsernameAuth"] = 2;
                    break;
                case 3:
                    ViewData["UsernameAuth"] = 3;
                    break;
                default:
                    ViewData["UsernameAuth"] = 0;
                    break;
            }
            int SeedLike = objSeed.getSeedRatingCountBySeedId(DetailId, "Like");
            ViewData["SeedLike"] = SeedLike;
            int SeedDislike = objSeed.getSeedRatingCountBySeedId(DetailId, "DLike");
            ViewData["SeedDislike"] = SeedDislike;
            int SeedCommitments = objSeed.getSeedCommitmentCountBySeedId(DetailId);
            ViewData["SeedCommitments"] = SeedCommitments;

            IList<Medium> MList = seedDetail.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_IMAGE)).OrderByDescending(x => x.dateUploaded).ToList();
            ViewData["MList"] = MList;

            IList<Medium> VList = seedDetail.Media.Where(x => x.type.Equals(SystemStatements.MEDIA_VIDEO)).ToList();
            ViewData["VList"] = VList.OrderByDescending(x => x.dateUploaded).Take(1).ToList();
            bindCategory();
            GetAllCitiesAndTags();
            GetActionNotifications();
            RegionCode();
            return View();
            #endregion
        }

        public void FlagSeed(string id, string FlagReason, string chkSpam, string chkWrgCat, string chkProhibited, string chkOther)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed sdata = objSeed.GetSeedBySeedId(id);

            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            Flag flagdata = new Flag();
            flagdata.id = Guid.NewGuid();
            flagdata.dateFlagged = DateTime.Now;
            flagdata.flaggedById = memberData.id;
            flagdata.seedId = sdata.id;
            flagdata.reason = FlagReason;
            flagdata.isRead = false;

            if (!string.IsNullOrEmpty(chkSpam))
                flagdata.isSpam = true;
            if (!string.IsNullOrEmpty(chkWrgCat))
                flagdata.isWrongCategory = true;
            if (!string.IsNullOrEmpty(chkProhibited))
                flagdata.isProhibited = true;
            if (!string.IsNullOrEmpty(chkOther))
                flagdata.isOther = true;

            sdata.Flags.Add(flagdata);
            objSeed.UpdateSeed(sdata);
            SessionStore.SetSessionValue(SessionStore.SeedFlagged, "FlagTrue");
            ContributionMail((memberData.firstName + " " + memberData.lastName).ToString(), sdata.title, System.Configuration.ConfigurationManager.AppSettings["AdminMail"].ToString(), "Flag");

            Response.Redirect("/Seed/SeedDetails/" + sdata.id);
            #endregion
        }

        public string jsFlagSeed(string id, string FlagReason, string chkSpam, string chkWrgCat, string chkProhibited, string chkOther)
        {
            #region
            Boolean isFlagged = false;
            SeedAction objSeed = new SeedAction();
            Seed sdata = objSeed.GetSeedBySeedId(id);

            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            Flag flagdata = new Flag();
            flagdata.id = Guid.NewGuid();
            flagdata.dateFlagged = DateTime.Now;
            flagdata.flaggedById = memberData.id;
            flagdata.seedId = sdata.id;
            flagdata.reason = FlagReason;
            flagdata.isRead = false;

            if (!string.IsNullOrEmpty(chkSpam))
                flagdata.isSpam = true;
            if (!string.IsNullOrEmpty(chkWrgCat))
                flagdata.isWrongCategory = true;
            if (!string.IsNullOrEmpty(chkProhibited))
                flagdata.isProhibited = true;
            if (!string.IsNullOrEmpty(chkOther))
                flagdata.isOther = true;

            sdata.Flags.Add(flagdata);
            sdata = objSeed.UpdateSeed(sdata);
            isFlagged = true;

            ContributionMail((memberData.firstName + " " + memberData.lastName).ToString(), sdata.title, System.Configuration.ConfigurationManager.AppSettings["AdminMail"].ToString(), "Flag");

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(isFlagged);
            return output;
            #endregion
        }

        public void AddToFavorite(string id)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(id);

            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            Bookmark objBookMark = new Bookmark();
            objBookMark.id = Guid.NewGuid();
            objBookMark.seedId = seedData.id;
            objBookMark.memberId = memberData.id;

            if (objSeed.GetBookmarkList(memberData.id.ToString(), seedData.id.ToString()))
            {
                seedData.Bookmarks.Add(objBookMark);
                objSeed.UpdateSeed(seedData);
            }
            Response.Redirect("/Seed/SeedDetails/" + seedData.id);
            #endregion
        }

        public void AddCommitment(string Sid, string Deadline, string Msg)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(Sid);
            seedData.status = SystemStatements.STATUS_GROWING;

            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            Commitment objCommit = new Commitment();
            objCommit.id = Guid.NewGuid();
            objCommit.commitDate = DateTime.Now;
            objCommit.deadline = Convert.ToDateTime(Deadline);
            objCommit.memberId = memberData.id;
            objCommit.seedId = seedData.id;
            objCommit.status = SystemStatements.STATUS_ACTIVE;
            objCommit.msg = Msg;
            objCommit.isRead = false;

            seedData.Commitments.Add(objCommit);
            objSeed.UpdateSeed(seedData);

            MailForContribution((seedData.Member.firstName + " " + seedData.Member.lastName).ToString(), (memberData.firstName + " " + memberData.lastName).ToString(), seedData.title, ("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/UserDetail/" + memberData.id), seedData.Member.username.ToString(), "Commitment");

            Response.Redirect("/Seed/SeedDetails/" + seedData.id);
            #endregion
        }

        public void AddComment(string Sid, string Comment)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(Sid);
            seedData.status = SystemStatements.STATUS_GROWING;

            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            Comment objComment = new Comment();
            objComment.id = Guid.NewGuid();
            objComment.commentDate = DateTime.Now;
            objComment.msg = Comment;
            objComment.seedId = seedData.id;
            objComment.commentById = memberData.id;
            objComment.isRead = false;

            seedData.Comments.Add(objComment);
            objSeed.UpdateSeed(seedData);
            MailForContribution((seedData.Member.firstName + " " + seedData.Member.lastName).ToString(), (memberData.firstName + " " + memberData.lastName).ToString(), seedData.title, ("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/SeedDetails/" + seedData.id), seedData.Member.username.ToString(), "Comment");

            Response.Redirect("/Seed/SeedDetails/" + seedData.id);
            #endregion
        }

        public void MailForContribution(string name, string committername, string title, string url, string toMail, string contributionType)
        {
            #region
            //send automated email to inform the administrator that a new flag has been posted on a seed
            // Creating array list for token subject
            ArrayList arrTokensSub = new ArrayList();
            arrTokensSub.Add(committername);

            // Creating array list for token message
            ArrayList arrTokens = new ArrayList();

            arrTokens.Add(name);
            arrTokens.Add(committername);
            arrTokens.Add(title);
            arrTokens.Add(url);
            if (contributionType == "Commitment")
            {
                arrTokens.Add(committername);
            }

            // Filling mail object
            SendMail objSendMail = new SendMail();
            objSendMail.ToEmailId = toMail;
            if (contributionType == "Commitment")
            {
                objSendMail.Subject = "email.member.CommitmentPosted.subject.content";
                objSendMail.MsgBody = "email.member.CommitmentPosted.body.content";
            }
            if (contributionType == "Comment")
            {
                objSendMail.Subject = "email.member.CommentPosted.subject.content";
                objSendMail.MsgBody = "email.member.CommentPosted.body.content";
            }
            objSendMail.ChagesInSubject = arrTokensSub;
            objSendMail.ChangesInMessage = arrTokens;
            objSendMail.SendEmail(objSendMail);
            #endregion
        }

        public void ContributionMail(string name, string token, string toMail, string contributionType)
        {
            #region
            //send automated email to inform the administrator that a new flag has been posted on a seed
            // Creating array list for token 
            ArrayList arrTokens = new ArrayList();
            arrTokens.Add(name);
            arrTokens.Add(token);

            // Filling mail object
            SendMail objSendMail = new SendMail();
            objSendMail.ToEmailId = toMail;
            if (contributionType == "Flag")
            {
                objSendMail.Subject = "email.member.flagPosted.subject.content";
                objSendMail.MsgBody = "email.member.flagPosted.body.content";
            }
            if (contributionType == "Media")
            {
                objSendMail.Subject = "email.mediaFileUploaded.subject.content";
                objSendMail.MsgBody = "email.mediaFileUploaded.body.content";
            }
            objSendMail.ChangesInMessage = arrTokens;
            objSendMail.SendEmail(objSendMail);
            #endregion
        }

        public string AddSeedComment(string txtComment, string Sid)
        {
            #region
            Boolean isAuthenticate = false;
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(Sid);

            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            Comment objComment = new Comment();
            objComment.id = Guid.NewGuid();
            objComment.commentDate = DateTime.Now;
            objComment.msg = txtComment;
            objComment.seedId = seedData.id;
            objComment.commentById = memberData.id;

            seedData.Comments.Add(objComment);
            seedData = objSeed.UpdateSeed(seedData);
            if (seedData.Comments != null)
                isAuthenticate = true;
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(isAuthenticate);
            return output;
            #endregion
        }

        // *************************************
        // URL: /Seed/OfferSeedOwnership
        // *************************************
        public ActionResult OfferSeedOwnership()
        {
            return View();
        }

        [HttpPost]
        public ActionResult OfferSeedOwnership(string OwnerEmail)
        {
            #region
            //send automated email - content of email will be decided later
            // Creating array list for token 
            ArrayList arrTokens = new ArrayList();
            arrTokens.Add(OwnerEmail);
            StringBuilder messageAccept = new StringBuilder();
            messageAccept.Append(System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString());
            messageAccept.Append("/Seed/OwnershipDecision?seedid=");
            messageAccept.Append("C5F6B54F-8D43-4F06-B846-152066FACE5A");
            messageAccept.Append("&decision=Accept");
            arrTokens.Add(messageAccept.ToString());

            StringBuilder messageReject = new StringBuilder();
            messageReject.Append(System.Configuration.ConfigurationManager.AppSettings["RootURL"].ToString());
            messageReject.Append("/Seed/OwnershipDecision?seedid=");
            messageReject.Append("C5F6B54F-8D43-4F06-B846-152066FACE5A");
            messageReject.Append("&decision=Reject");
            arrTokens.Add(messageReject.ToString());

            // Filling mail object
            SendMail objSendMail = new SendMail();
            objSendMail.ToEmailId = OwnerEmail;
            objSendMail.Subject = "email.offer.seedownership.subject.content";
            objSendMail.MsgBody = "email.offer.seedownership.body.content";
            objSendMail.ChangesInMessage = arrTokens;

            objSendMail.SendEmail(objSendMail);
            return View();
            #endregion
        }

        // *************************************
        // URL: /Seed/OwnershipDecision
        // *************************************
        public ActionResult OwnershipDecision()
        {
            #region
            Member memberData = (Member)SeedSpeak.Util.SessionStore.GetSessionValue(SeedSpeak.Util.SessionStore.Memberobject);
            SeedAction objSeed = new SeedAction();
            bool ownerUpdated = false;
            if (Request.QueryString["seedid"] != null && Request.QueryString["decision"] != null)
            {
                string seedID = Request.QueryString["seedid"].ToString();
                string decision = Request.QueryString["decision"].ToString();
                if (decision == "Accept")
                {
                    ownerUpdated = objSeed.UpdateSeedOwner(seedID, memberData.id.ToString());
                    if (ownerUpdated == true)
                        ViewData["Decision"] = "Accept";
                    else
                        ViewData["Decision"] = "Problem updating owner";
                }
                if (decision == "Reject")
                {
                    ViewData["Decision"] = "Reject";
                }
            }
            return View();
            #endregion
        }        

        public void LikeDislikeSeed(string id, string LikeDisLike)
        {
            SeedAction objSeed = new SeedAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            bool isCreated = false;
            isCreated = objSeed.ManageRating(id, memberData.id.ToString(), LikeDisLike);
        }

        public void DislikeSeed(string id)
        {
            SeedAction objSeed = new SeedAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            bool isCreated = false;
            isCreated = objSeed.ManageRating(id, memberData.id.ToString(), "DLike");
            Response.Redirect("/Seed/SeedDetails/" + id);
        }

        public void mailSeedInformation(string mSeedid, string eMail, string seedSubject, string seedBody)
        {
            #region
            //send automated email - content of email will be decided later
            //Creating array list for token 
            ArrayList arrTokens = new ArrayList();
            arrTokens.Add(eMail);
            arrTokens.Add(seedSubject);
            arrTokens.Add(seedBody);

            // Filling mail object
            SendMail objSendMail = new SendMail();
            objSendMail.ToEmailId = eMail;
            objSendMail.Subject = "email.seedInformation.subject.content";
            objSendMail.MsgBody = "email.seedInformation.body.content";
            objSendMail.ChangesInMessage = arrTokens;

            objSendMail.SendEmail(objSendMail);

            Response.Redirect("/Seed/SeedDetails/" + mSeedid);
            #endregion
        }

        public IList<Seed> getSearchResult(string cstreet, string city, string catId, string keyword, string zip, string userName, string rating)
        {
            #region Logic
            IList<Seed> seedList = new List<Seed>();
            Repository repoObj = new Repository();
            SeedAction objSeed = new SeedAction();

            string searchString = "";

            if (catId != null && catId.Length > 0)
            {
                searchString = "select seed.* from seed, Seed_has_Category, Tag where (status='New' or status='Growing')";
            }
            else
            {
                searchString = "select seed.* from seed, Tag where (status='New' or status='Growing')";
            }

            bool flag = false;

            #region Search in location table

            if ((!string.IsNullOrEmpty(city) && city != "City") || (!string.IsNullOrEmpty(zip) && zip != "Zipcode") || (!string.IsNullOrEmpty(cstreet) && cstreet != "Cross Street"))
            {
                searchString += " and locationid in ( select id from location where ";

                if (city.Length > 0 && city != "City")
                {
                    searchString += "cityid in (select id from City where name = '" + city + "' ))";

                    flag = true;
                }

                if (!string.IsNullOrEmpty(zip))
                {
                    if (zip.Length > 0 && zip != "Zipcode")
                    {
                        CommonMethods cmnMethod = new CommonMethods();

                        string zipResult = cmnMethod.GetZipByRadius("2", zip);

                        if (flag)
                        {
                            searchString = searchString.Substring(0, searchString.Length - 1);

                            searchString += " and zipcode in (" + zipResult + "))";
                        }
                        else
                        {
                            searchString += "zipcode in (" + zipResult + "))";
                        }
                        flag = true;
                    }
                }

                if (!string.IsNullOrEmpty(cstreet))
                {
                    if (cstreet.Length > 0 && cstreet != "Cross Street")
                    {
                        if (flag)
                        {
                            searchString = searchString.Substring(0, searchString.Length - 1);

                            searchString += " and crossStreet like '%" + cstreet + "%')";
                        }
                        else
                        {
                            searchString += "crossStreet like '%" + cstreet + "%')";
                        }
                        flag = true;
                    }
                }
            }

            #endregion

            #region Search according to categories
            if (catId != null && catId.Length > 0)
            {
                searchString += " and Seed_has_Category.categoryId = '" + catId + "' and Seed.id=Seed_has_Category.seedId";
            }
            #endregion

            #region Search in username, firstname, lastname
            if (!string.IsNullOrEmpty(userName))
            {
                if (userName != "User Name")
                {
                    if (userName.Contains('@'))
                    {
                        searchString += " and Seed.ownerId in (Select id from Member where username = '" + userName + "')";
                    }
                    else
                    {
                        string fName = string.Empty;
                        string lName = string.Empty;
                        string[] splt = userName.Split(' ');
                        if (splt.Count() > 1)
                        {
                            fName = splt[0].ToString();
                            lName = splt[1].ToString();
                            searchString += " and Seed.ownerId in (select id from Member where firstName = '" + fName + "' or lastName='" + lName + "')";
                        }
                        else
                        {
                            fName = splt[0].ToString();
                            searchString += " and Seed.ownerId in (select id from Member where firstName = '" + fName + "')";
                        }
                    }
                }
            }
            #endregion

            #region Search by rating
            if (!string.IsNullOrEmpty(rating))
            {
                if (rating != "Select")
                {
                    searchString += " and Seed.id in (select seedId from Rating where likes = '" + rating + "')";
                }
            }
            #endregion

            #region Search in title or tag or description
            if (!string.IsNullOrEmpty(keyword))
            {
                if (keyword.Length > 0 && keyword != "Keywords")
                {
                    searchString += "and (Seed.title like '%" + keyword + "%' or Tag.name like '%" + keyword + "%' or Seed.description like '%" + keyword + "%') and Seed.id=Tag.seedId";
                }
            }
            #endregion

            seedList = repoObj.ListPPP<Seed>("usp_SearchSeeds", searchString).ToList();
            IList<Seed> returnSeedList = (from s in seedList select s).Distinct().ToList();
            return returnSeedList;

            #endregion
        }

        public ContentResult OwnershipEmail(string q, int limit, Int64 timestamp)
        {
            #region
            StringBuilder responseContentBuilder = new StringBuilder();
            SeedAction objSeed = new SeedAction();
            IList<Member> lstMember = (from t in objSeed.GetMemberInfoByName(q)
                                       select new Member
                                       {
                                           id = t.id,
                                           username = t.username
                                       }).ToList();

            foreach (Member mem in lstMember)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", mem.id, mem.username));
            return Content(responseContentBuilder.ToString());
            #endregion
        }

        public string CheckBadWord(string badWord)
        {
            #region check bad words in string
            bool isChecked = false;
            badWordsFilter objWord = new badWordsFilter();
            string filePath=Server.MapPath("~/utils/badWords.xml");
            isChecked = objWord.IsBadWord(ref badWord, ref filePath);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(isChecked);

            return output;
            #endregion
        }

        public string ShareIdea(string txtSeedTitle, string txtDesc, string seedCoordinates, string seedLocation, string txtCategory)
        {
            #region
            string returnMsg = string.Empty;
            try
            {
                SeedAction objSeed = new SeedAction();
                LocationAction objLocation = new LocationAction();

                //Format address and create add seed model
                string[] splitAddress = seedLocation.Split(',');
                AddSeed seedData = new AddSeed();
                seedData.SeedName = txtSeedTitle;
                seedData.Description = txtDesc;
                seedData.LongLat = seedCoordinates;
                if (splitAddress.Length > 4)
                {
                    seedData.StreetAddress = splitAddress[0].ToString() + ", " + splitAddress[1].ToString();
                    seedData.City = splitAddress[2].ToString().Trim();
                    string[] splitZipRegion = splitAddress[3].ToString().Trim().Split(' ');
                    seedData.ZipCode = splitZipRegion[1].ToString().Trim();
                    seedData.StateCode = splitZipRegion[0].ToString().Trim();
                }
                else
                {
                    seedData.StreetAddress = splitAddress[0].ToString();
                    seedData.City = splitAddress[1].ToString().Trim();
                    string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                    seedData.ZipCode = splitZipRegion[1].ToString().Trim();
                    seedData.StateCode = splitZipRegion[0].ToString().Trim();
                }
                //End formatting address

                string plantedSeedId = AddSeedData(seedData);

                if (txtCategory != null)
                {
                    string catIds = string.Empty;
                    string[] splitCategories = txtCategory.Split(',');
                    for (int i = 0; i < splitCategories.Length; i++)
                    {
                        CategoryAction objCatg = new CategoryAction();
                        string idCatg = objCatg.GetCategoryIdByCategoryName(splitCategories[i].ToString());
                        if (!string.IsNullOrEmpty(idCatg))
                        {
                            if (string.IsNullOrEmpty(catIds))
                                catIds = idCatg;
                            else
                                catIds = catIds + "," + idCatg;
                        }
                    }
                    if (!string.IsNullOrEmpty(catIds))
                    {
                        string[] arrCatIds = catIds.Split(',');
                        objSeed.AddCategories(plantedSeedId, arrCatIds);
                    }
                }

                try
                {
                    // Get the HttpFileCollection
                    HttpFileCollectionBase hfc = Request.Files;
                    for (int i = 0; i < hfc.Count; i++)
                    {
                        if (hfc[i].ContentLength > 0)
                        {
                            hfc[i].SaveAs(Server.MapPath("UploadedMedia") + "\\" + System.IO.Path.GetFileName(hfc[i].FileName));
                        }
                    }
                }
                catch
                {

                }

                #region code to send mail
                Seed seed = GetSeedInformation(plantedSeedId);
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(seed.Member.firstName + " " + seed.Member.lastName);
                arrTokens.Add(seed.title);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/SeedDetails/" + seed.id);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/Profile");

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = seed.Member.username;
                objSendMail.Subject = "email.seedPlanted.subject.content";
                objSendMail.MsgBody = "email.seedPlanted.body.content";
                objSendMail.ChangesInMessage = arrTokens;

                objSendMail.SendEmail(objSendMail);
                #endregion

                returnMsg = "Seed has been planted successfully";
            }
            catch (Exception ex)
            {
                returnMsg = ex.Message.ToString();
            }
            
            return returnMsg;
            #endregion
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult ShareIdea1(string returnAction, string txtSeedTitle, string txtDesc, string seedCoordinates, string seedLocation, string txtCategory, IEnumerable<HttpPostedFileBase> mediaFiles)
        {
            #region codeRegion
            try
            {
                SeedAction objSeed = new SeedAction();
                LocationAction objLocation = new LocationAction();

                //Format address and create add seed model
                string[] splitAddress = seedLocation.Split(',');
                AddSeed seedData = new AddSeed();
                seedData.SeedName = txtSeedTitle;
                seedData.Description = txtDesc;
                seedData.LongLat = seedCoordinates;
                string seedCountry = string.Empty;
                if (splitAddress.Length > 4)
                {
                    seedData.StreetAddress = splitAddress[0].ToString() + ", " + splitAddress[1].ToString();
                    seedData.City = splitAddress[2].ToString().Trim();
                    string[] splitZipRegion = splitAddress[3].ToString().Trim().Split(' ');
                    seedData.ZipCode = splitZipRegion[1].ToString().Trim();
                    seedData.StateCode = splitZipRegion[0].ToString().Trim();
                    seedCountry = splitAddress[4].ToString();
                }
                else
                {
                    seedData.StreetAddress = splitAddress[0].ToString();
                    seedData.City = splitAddress[1].ToString().Trim();
                    string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                    seedData.ZipCode = splitZipRegion[1].ToString().Trim();
                    seedData.StateCode = splitZipRegion[0].ToString().Trim();
                    seedCountry = splitAddress[3].ToString();
                }
                //End formatting address

                if (seedCountry.Trim().Equals("USA") || seedCountry.Trim().Equals("US"))
                    seedCountry = seedCountry.Trim();
                else
                    throw new Exception("Seeds can not be planted outside region of United States");

                string plantedSeedId = AddSeedData(seedData);

                if (txtCategory != null)
                {
                    string catIds = string.Empty;
                    string[] splitCategories = txtCategory.Split(',');
                    for (int i = 0; i < splitCategories.Length; i++)
                    {
                        CategoryAction objCatg = new CategoryAction();
                        string idCatg = objCatg.GetCategoryIdByCategoryName(splitCategories[i].ToString());
                        if (!string.IsNullOrEmpty(idCatg))
                        {
                            if (string.IsNullOrEmpty(catIds))
                                catIds = idCatg;
                            else
                                catIds = catIds + "," + idCatg;
                        }
                    }
                    //bool isPlanted = false;
                    if (!string.IsNullOrEmpty(catIds))
                    {
                        string[] arrCatIds = catIds.Split(',');
                        objSeed.AddCategories(plantedSeedId, arrCatIds);
                    }
                }
                if (mediaFiles != null)
                {
                    foreach (var file in mediaFiles)
                    {
                        if (file.ContentLength > 0)
                        {
                            Bitmap sourceImage = new Bitmap(file.InputStream);
                            MediaManagement objMedia = new MediaManagement();
                            bool isMediaSaved = false;
                            int fileSize = file.ContentLength;
                            string fileOk = CheckFile(file.FileName, fileSize);
                            if (fileOk != "Invalid")
                            {
                                string strImgFileExtension = System.IO.Path.GetExtension(file.FileName);
                                DateTime datImg = DateTime.Now;
                                string ImgfileUploadtime = datImg.Day.ToString() + datImg.Month.ToString() + datImg.Year.ToString() + datImg.Hour.ToString() + datImg.Minute.ToString() + datImg.Second.ToString();                                
                                string filePath = Path.Combine(HttpContext.Server.MapPath("/UploadedMedia"), (plantedSeedId.ToString() + "_" + ImgfileUploadtime + strImgFileExtension));
                                objMedia.title = plantedSeedId.ToString() + "_" + ImgfileUploadtime;
                                objMedia.path = "../../UploadedMedia/" + (plantedSeedId.ToString() + "_" + ImgfileUploadtime + strImgFileExtension);
                                objMedia.type = fileOk;
                                objMedia.seedId = plantedSeedId;
                                sourceImage.Save(filePath, FileExtensionToImageFormat(filePath));
                                objMedia.embedScript = "Image Script";
                                isMediaSaved = SaveMediaInformation(objMedia);
                            }
                            else
                                throw new Exception("Please check file type or file size, Max Size Allowed : (Image : 2 MB) & (Video : 4 MB)");
                        }
                    }
                }
                Seed seed = GetSeedInformation(plantedSeedId);
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(seed.Member.firstName + " " + seed.Member.lastName);
                arrTokens.Add(seed.title);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/SeedDetails/" + seed.id);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/Profile");

                // Filling mail object
                SendMail objSendMail = new SendMail();

                Regex rgxEmail = new Regex("\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*");
                if (rgxEmail.IsMatch(seed.Member.username))
                    objSendMail.ToEmailId = seed.Member.username;
                else
                    objSendMail.ToEmailId = seed.Member.Email;
                objSendMail.Subject = "email.seedPlanted.subject.content";
                objSendMail.MsgBody = "email.seedPlanted.body.content";
                objSendMail.ChangesInMessage = arrTokens;

                objSendMail.SendEmail(objSendMail);

                return Redirect("/Seed/SeedDetails/" + seed.id);
            }
            catch (Exception ex)
            {
                SessionStore.SetSessionValue("PlantError", "Error occurred while planting seed#" + ex.Message.ToString());
                //ViewData["PlantErrMsg"] = ex.Message.ToString();
                return RedirectToAction("PlantError", "Seed");
            }
            #endregion
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult ReplySeed(string txtRplSeedTitle, string txtRplDesc, string seedCoordinatesRpl, string seedLocationRpl, string txtCategoryRpl, IEnumerable<HttpPostedFileBase> mediaFilesRpl, string RplRootSeedID, string RplParentSeedID)
        {
            #region codeRegion
            try
            {
                SeedAction objSeed = new SeedAction();
                LocationAction objLocation = new LocationAction();

                //Format address and create add seed model
                string[] splitAddress = seedLocationRpl.Split(',');
                AddSeed seedData = new AddSeed();
                seedData.SeedName = txtRplSeedTitle;
                seedData.Description = txtRplDesc;
                seedData.LongLat = seedCoordinatesRpl;
                if (splitAddress.Length > 4)
                {
                    seedData.StreetAddress = splitAddress[0].ToString() + ", " + splitAddress[1].ToString();
                    seedData.City = splitAddress[2].ToString().Trim();
                    string[] splitZipRegion = splitAddress[3].ToString().Trim().Split(' ');
                    seedData.ZipCode = splitZipRegion[1].ToString().Trim();
                    seedData.StateCode = splitZipRegion[0].ToString().Trim();
                }
                else
                {
                    seedData.StreetAddress = splitAddress[0].ToString();
                    seedData.City = splitAddress[1].ToString().Trim();
                    string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                    seedData.ZipCode = splitZipRegion[1].ToString().Trim();
                    seedData.StateCode = splitZipRegion[0].ToString().Trim();
                }
                seedData.rootSeedId = RplRootSeedID;
                seedData.parentSeedId = RplParentSeedID;
                //End formatting address

                string plantedSeedId = AddSeedData(seedData);

                if (txtCategoryRpl != null)
                {
                    string catIds = string.Empty;
                    string[] splitCategories = txtCategoryRpl.Split(',');
                    for (int i = 0; i < splitCategories.Length; i++)
                    {
                        CategoryAction objCatg = new CategoryAction();
                        string idCatg = objCatg.GetCategoryIdByCategoryName(splitCategories[i].ToString());
                        if (!string.IsNullOrEmpty(idCatg))
                        {
                            if (string.IsNullOrEmpty(catIds))
                                catIds = idCatg;
                            else
                                catIds = catIds + "," + idCatg;
                        }
                    }
                    if (!string.IsNullOrEmpty(catIds))
                    {
                        string[] arrCatIds = catIds.Split(',');
                        objSeed.AddCategories(plantedSeedId, arrCatIds);
                    }
                }
                if (mediaFilesRpl != null)
                {
                    foreach (var file in mediaFilesRpl)
                    {
                        if (file.ContentLength > 0)
                        {
                            Bitmap sourceImage = new Bitmap(file.InputStream);
                            MediaManagement objMedia = new MediaManagement();
                            bool isMediaSaved = false;
                            int fileSize = file.ContentLength;
                            string fileOk = CheckFile(file.FileName, fileSize);
                            if (fileOk != "Invalid")
                            {
                                string strImgFileExtension = System.IO.Path.GetExtension(file.FileName);
                                DateTime datImg = DateTime.Now;
                                string ImgfileUploadtime = datImg.Day.ToString() + datImg.Month.ToString() + datImg.Year.ToString() + datImg.Hour.ToString() + datImg.Minute.ToString() + datImg.Second.ToString();
                                
                                string filePath = Path.Combine(HttpContext.Server.MapPath("/UploadedMedia"), (plantedSeedId.ToString() + "_" + ImgfileUploadtime + strImgFileExtension));
                                objMedia.title = plantedSeedId.ToString() + "_" + ImgfileUploadtime;
                                objMedia.path = "../../UploadedMedia/" + (plantedSeedId.ToString() + "_" + ImgfileUploadtime + strImgFileExtension);
                                objMedia.type = fileOk;
                                objMedia.seedId = plantedSeedId;
                                sourceImage.Save(filePath, FileExtensionToImageFormat(filePath));
                                objMedia.embedScript = "Image Script";
                                isMediaSaved = SaveMediaInformation(objMedia);
                            }
                            else
                                throw new Exception("Please check file type or file size, Max Size Allowed : (Image : 2 MB) & (Video : 4 MB)");
                        }
                    }
                }
                Seed seed = GetSeedInformation(plantedSeedId);
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(seed.Member.firstName + " " + seed.Member.lastName);
                arrTokens.Add(seed.title);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/SeedDetails/" + seed.id);
                arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/Profile");

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = seed.Member.username;
                objSendMail.Subject = "email.seedPlanted.subject.content";
                objSendMail.MsgBody = "email.seedPlanted.body.content";
                objSendMail.ChangesInMessage = arrTokens;

                objSendMail.SendEmail(objSendMail);

                return Redirect("/Seed/SeedDetails/" + seed.id);
            }
            catch (Exception ex)
            {
                SessionStore.SetSessionValue("PlantError", ex.Message.ToString());
                return RedirectToAction("PlantError", "Seed");
            }
            #endregion
        }

        public string EditSeedById(string id)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seed = objSeed.GetSeedBySeedId(id);
            string outStr = string.Empty;
            outStr = seed.title + "#|@|#" + seed.description + "#|@|#" + seed.Location.localLat + "#|@|#" + seed.Location.localLong;

            string catList = "";
            foreach (SeedSpeak.Model.Category catData in seed.Categories)
            {
                catList = catList + catData.name + ",";
            }
            catList = catList.TrimEnd(',', ' ');
            if (!string.IsNullOrEmpty(catList))
                outStr += "#|@|#" + catList;

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(outStr);
            return output;
            #endregion
        }

        public string EditSeedById1(string id)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seed = objSeed.GetSeedBySeedId(id);
            EditSeed objEdit = new Model.Validation.EditSeed();
            objEdit.id = seed.id;
            objEdit.seedTitle = seed.title;
            objEdit.seedDesc = seed.description;
            objEdit.seedLat = Convert.ToString(seed.Location.localLat);
            objEdit.seedLng = Convert.ToString(seed.Location.localLong);

            string catList = "";
            foreach (SeedSpeak.Model.Category catData in seed.Categories)
            {
                catList = catList + catData.name + ",";
            }
            catList = catList.TrimEnd(',', ' ');

            objEdit.seedCatg = catList;

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(objEdit);
            return output;
            #endregion
        }

        public string TerminateMySeed(string id)
        {
            #region
            bool isCompleted = false;
            string msg = "false";
            SeedAction objSeed = new SeedAction();
            isCompleted = objSeed.HarvestTerminateSeed(id, "Terminate");
            if (isCompleted == true)
                msg = "true";
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(msg);
            return output;
            #endregion
        }

        [HttpPost,ValidateInput(false)]
        public ActionResult EditSeedInfo(string txtEdtSeedTitle, string txtEdtDesc, string seedCoordinatesEdt, string seedLocationEdt, string txtCategoryEdt, IEnumerable<HttpPostedFileBase> mediaFilesEdt, string EdtSeedID)
        {
            #region codeRegion
            try
            {
                SeedAction objSeed = new SeedAction();
                LocationAction objLocation = new LocationAction();

                Seed seed = GetSeedInformation(EdtSeedID);
                seed.title = txtEdtSeedTitle;
                string s = Regex.Replace(txtEdtDesc, @"<(.|\n)*?>", string.Empty);
                s = s.Replace("&nbsp;", " ");
                s = Regex.Replace(s, @"\s+", " ");
                s = Regex.Replace(s, @"\r\n", "\n");
                s = Regex.Replace(s, @"\n+", "\n");
                string description = s;

                badWordsFilter objWords = new badWordsFilter();
                string wordsFilePath = Server.MapPath("~/utils/badWords.xml");
                List<string> lstBadWords = badWordsFilter.BadWordList(ref wordsFilePath);
                description = objWords.FilterBadWords(lstBadWords, description);

                seed.description = description;

                Location loc = seed.Location;
                //Format address and create add seed model
                string[] splitAddress = seedLocationEdt.Split(',');
                string[] strSplitLatLong = seedCoordinatesEdt.Split(',');
                loc.localLat = Convert.ToDouble(strSplitLatLong[0].ToString());
                loc.localLong = Convert.ToDouble(strSplitLatLong[1].ToString());

                if (splitAddress.Length > 4)
                {
                    string[] splitZipRegion = splitAddress[3].ToString().Trim().Split(' ');
                    loc.crossStreet = splitAddress[0].ToString() + ", " + splitAddress[1].ToString();
                    string cityid = objLocation.GetCityIdByCityName(splitAddress[2].ToString().Trim(), splitZipRegion[0].ToString().Trim());
                    loc.cityId = new Guid(cityid);
                    loc.zipcode = splitZipRegion[1].ToString().Trim();
                }
                else
                {
                    string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                    loc.crossStreet = splitAddress[0].ToString();
                    string cityid = objLocation.GetCityIdByCityName(splitAddress[1].ToString().Trim(), splitZipRegion[0].ToString().Trim());
                    loc.cityId = new Guid(cityid);
                    loc.zipcode = splitZipRegion[1].ToString().Trim();
                }
                //End formatting address

                loc = objLocation.UpdateLocation(loc);
                seed.locationId = loc.id;
                seed = objSeed.UpdateSeed(seed);
                string plantedSeedId = seed.id.ToString();

                if (txtCategoryEdt != null)
                {
                    string catIds = string.Empty;
                    string[] splitCategories = txtCategoryEdt.Split(',');
                    for (int i = 0; i < splitCategories.Length; i++)
                    {
                        CategoryAction objCatg = new CategoryAction();
                        string idCatg = objCatg.GetCategoryIdByCategoryName(splitCategories[i].ToString());
                        if (!string.IsNullOrEmpty(idCatg))
                        {
                            if (string.IsNullOrEmpty(catIds))
                                catIds = idCatg;
                            else
                                catIds = catIds + "," + idCatg;
                        }
                    }
                    //bool isPlanted = false;
                    if (!string.IsNullOrEmpty(catIds))
                    {
                        string[] arrCatIds = catIds.Split(',');
                        objSeed.AddCategories(plantedSeedId, arrCatIds);
                    }
                }
                if (mediaFilesEdt != null)
                {
                    foreach (var file in mediaFilesEdt)
                    {
                        if (file.ContentLength > 0)
                        {
                            Bitmap sourceImage = new Bitmap(file.InputStream);
                            MediaManagement objMedia = new MediaManagement();
                            bool isMediaSaved = false;
                            int fileSize = file.ContentLength;
                            string fileOk = CheckFile(file.FileName, fileSize);
                            if (fileOk != "Invalid")
                            {
                                string strImgFileExtension = System.IO.Path.GetExtension(file.FileName);
                                DateTime datImg = DateTime.Now;
                                string ImgfileUploadtime = datImg.Day.ToString() + datImg.Month.ToString() + datImg.Year.ToString() + datImg.Hour.ToString() + datImg.Minute.ToString() + datImg.Second.ToString();                                
                                string filePath = Path.Combine(HttpContext.Server.MapPath("/UploadedMedia"), (plantedSeedId + "_" + ImgfileUploadtime + strImgFileExtension));
                                objMedia.title = plantedSeedId + "_" + ImgfileUploadtime;
                                objMedia.path = "../../UploadedMedia/" + (plantedSeedId + "_" + ImgfileUploadtime + strImgFileExtension);
                                objMedia.type = fileOk;
                                objMedia.seedId = plantedSeedId;
                                sourceImage.Save(filePath, FileExtensionToImageFormat(filePath));
                                objMedia.embedScript = "Image Script";
                                isMediaSaved = SaveMediaInformation(objMedia);
                            }
                            else
                                throw new Exception("Please check file type or file size, Max Size Allowed : (Image : 2 MB) & (Video : 4 MB)");
                        }
                    }
                }
                return Redirect("/Seed/SeedDetails/" + plantedSeedId);
            }
            catch (Exception ex)
            {
                SessionStore.SetSessionValue("PlantError", ex.Message.ToString());                
                return RedirectToAction("PlantError", "Seed");
            }
            #endregion
        }

        public ActionResult PlantError()
        {
            string error = (string)SessionStore.GetSessionValue("PlantError");
            ViewData["PlantError"] = error;
            return View();
        }

        public ActionResult GetReplyPartial()
        {
            return PartialView("ReplySeed");
        }

        [HttpPost]
        public ActionResult AdvanceSearch(string AdvLocation, string currentLocValue, string AnotherLocValue, string LocationAdvSearchRadius, string CoordinatesAdvSearchRadius, string advMedia, string advReplySeeds, string txtAdvSearchIncludeTerms, string txtAdvSearchExcludeTerms)
        {
            #region Front Logic
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            SeedAction objSeed = new SeedAction();

            string advSearchQuery = "Select Seed.* from Seed where (seed.[status] = 'New' or seed.[status] = 'Growing')";
            if (advReplySeeds != "IncludeReplySeeds")
                advSearchQuery += " and seed.parentSeedID is null";

            #region add location in query
            if (!string.IsNullOrEmpty(AdvLocation))
            {
                if (AdvLocation != "AllLocations")
                {
                    string radius = string.Empty;
                    string radiusZipList = string.Empty;
                    string ZipCodeAdvSearch = string.Empty;
                    if (AdvLocation == "CurrentLocation")
                    {
                        radius = currentLocValue;
                        CommonMethods objCmnMethods = new CommonMethods();

                        string strIpAddress = System.Web.HttpContext.Current.Request.UserHostAddress;
                        if (strIpAddress == "127.0.0.1")
                            strIpAddress = "61.246.241.162";

                        string ipLocation = objCmnMethods.IP2AddressAPI(strIpAddress);
                        
                        string[] currentAddress;
                        if (!string.IsNullOrEmpty(ipLocation))
                        {
                            //IPaddressAPI
                            currentAddress = ipLocation.Split(',');
                            if (string.IsNullOrEmpty(currentAddress[7].Replace("\"", "").ToString()))
                                ZipCodeAdvSearch = "85027";
                            else
                                ZipCodeAdvSearch = currentAddress[7].Replace("\"", "").ToString();
                        }
                        else
                        {
                            //MaxMind
                            ipLocation = objCmnMethods.IP2AddressMaxMind();
                            currentAddress = ipLocation.Split('\'');
                            if (string.IsNullOrEmpty(currentAddress[15].ToString()))
                                ZipCodeAdvSearch = "85027";
                            else
                                ZipCodeAdvSearch = currentAddress[15].ToString();
                        }
                    }
                    if (AdvLocation == "NewLocation")
                    {
                        radius = AnotherLocValue;

                        //Format address
                        string[] splitAddressSearch = LocationAdvSearchRadius.Split(',');
                        if (splitAddressSearch.Length > 4)
                        {
                            string[] splitZipRegion = splitAddressSearch[3].ToString().Trim().Split(' ');
                            ZipCodeAdvSearch = splitZipRegion[1].ToString().Trim();
                        }
                        else
                        {
                            string[] splitZipRegion = splitAddressSearch[2].ToString().Trim().Split(' ');
                            ZipCodeAdvSearch = splitZipRegion[1].ToString().Trim();
                        }
                        //End formatting address
                    }

                    //Get zip codes according to radius
                    CommonMethods objCommon = new CommonMethods();
                    radiusZipList = objCommon.GetZipByRadiusNew(radius, ZipCodeAdvSearch);
                    //End get zip codes according to radius

                    if (string.IsNullOrEmpty(radiusZipList))
                        radiusZipList = ZipCodeAdvSearch;

                    advSearchQuery += " and locationId in (Select id from Location where zipcode in (" + radiusZipList + "))";
                }
            }
            #endregion

            #region include terms in query
            if (!string.IsNullOrEmpty(txtAdvSearchIncludeTerms))
            {
                string inCondition = string.Empty;
                string[] includeTerms = txtAdvSearchIncludeTerms.Split(',');
                for (int i = 0; i < includeTerms.Length; i++)
                {
                    if (i == 0)
                        inCondition = "'" + includeTerms[i].ToString() + "'";
                    else
                        inCondition += ",'" + includeTerms[i].ToString() + "'";
                }
                advSearchQuery += " and Seed.id in (select sc.seedId from Category c ,Seed_has_Category sc where c.id=sc.categoryId and c.name in (" + inCondition + ") union select Seed.id from Seed,Member where Member.id = Seed.ownerId and Member.firstName in (" + inCondition + "))";
            }
            #endregion

            #region exclude terms in query
            if (!string.IsNullOrEmpty(txtAdvSearchExcludeTerms))
            {
                string exCondition = string.Empty;
                string[] excludeTerms = txtAdvSearchExcludeTerms.Split(',');
                for (int i = 0; i < excludeTerms.Length; i++)
                {
                    if (i == 0)
                        exCondition = "'" + excludeTerms[i].ToString() + "'";
                    else
                        exCondition += ",'" + excludeTerms[i].ToString() + "'";
                }
                advSearchQuery += " and Seed.id not in (select sc.seedId from Category c ,Seed_has_Category sc where c.id=sc.categoryId and c.name in (" + exCondition + ") union select Seed.id from Seed,Member where Member.id = Seed.ownerId and Member.firstName in (" + exCondition + "))";
            }
            #endregion

            #region add media in query
            if (!string.IsNullOrEmpty(advMedia))
            {
                switch (advMedia)
                {
                    case "All":
                        advSearchQuery += " and Seed.id in (Select m.seedId from Media m)";
                        break;
                    case "NoMedia":
                        advSearchQuery += " and Seed.id not in (Select m.seedId from Media m)";
                        break;
                    case "PhotosOnly":
                        advSearchQuery += " and Seed.id in (Select m.seedId from Media m where m.[type]='" + SystemStatements.MEDIA_IMAGE + "')";
                        break;
                    case "VideosOnly":
                        advSearchQuery += " and Seed.id in (Select m.seedId from Media m where m.[type]='" + SystemStatements.MEDIA_VIDEO + "')";
                        break;
                    default:
                        break;
                }
            }
            #endregion

            IList<Seed> lstSeed = null;
            lstSeed = objSeed.GetSeedListByCriteria(advSearchQuery);            
            lstSeed = lstSeed.Distinct().ToList();
            SessionStore.SetSessionValue(SessionStore.SearchSeeds, lstSeed);
            TempData["DiscoverSeed"] = "AdvanceSearch";
            #endregion
                        
            return RedirectToAction("SearchSeeds", "Home");
        }

        [HttpPost]
        public ActionResult MasterAdvanceSearch(string searchTxt)
        {
            #region Front Logic
            SeedAction objSeed = new SeedAction();
            IList<Seed> seedList = new List<Seed>();
            seedList = objSeed.MasterSearch(searchTxt).Distinct().ToList();            
            SessionStore.SetSessionValue(SessionStore.SearchSeeds, seedList);
            TempData["DiscoverSeed"] = "AdvanceSearch";
            #endregion

            return RedirectToAction("SearchSeeds", "Home");
        }

        public string HideUnhide(string seedId, string btnAction)
        {
            #region
            var output = string.Empty;
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            SeedAction objSeed = new SeedAction();
            bool isDone = objSeed.HideOrUnhideSeed(memberData.id.ToString(), seedId, btnAction);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            output = serializer.Serialize(isDone);
            return output;
            #endregion
        }
    }
}
