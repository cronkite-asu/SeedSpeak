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
using SeedSpeak.Captcha;
using System.Web.Script.Serialization;
using System.IO;
using System.Text;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Data;

namespace SeedSpeak.Controllers
{
    public class SeedStreamController : Controller
    {
        //
        // GET: /SeedStream/

        public ActionResult Index()
        {
            return View();
        }        

        [HttpPost]
        public ActionResult AddStream(string gTitle, string gDesc, string gIsPublic, string streamType, string seedLocationStreamMini, string seedCoordinatesStreamMini, string txtCategoryStreamMini, string isEdit, string StreamId)
        {
            #region Front Logic
            try
            {
                Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
                StreamAction objStream = new StreamAction();
                TempData["StreamTab"] = 1;
                if (isEdit == "Yes" && !string.IsNullOrEmpty(StreamId))
                {
                    ssStream ss = objStream.GetStreamById(StreamId);
                    ss.title = gTitle;
                    ss.description = gDesc;
                    ss.isPublic = Convert.ToBoolean(gIsPublic);
                    //Format address 
                    string StreetAddress1 = string.Empty;
                    string City1 = string.Empty;
                    string ZipCode1 = string.Empty;
                    string StateCode1 = string.Empty;

                    if (!string.IsNullOrEmpty(seedLocationStreamMini))
                    {
                        string[] splitAddress = seedLocationStreamMini.Split(',');
                        if (splitAddress.Length > 4)
                        {
                            StreetAddress1 = splitAddress[0].ToString() + ", " + splitAddress[1].ToString();
                            City1 = splitAddress[2].ToString().Trim();
                            string[] splitZipRegion = splitAddress[3].ToString().Trim().Split(' ');
                            ZipCode1 = splitZipRegion[1].ToString().Trim();
                            StateCode1 = splitZipRegion[0].ToString().Trim();
                        }
                        else
                        {
                            StreetAddress1 = splitAddress[0].ToString();
                            City1 = splitAddress[1].ToString().Trim();
                            string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                            ZipCode1 = splitZipRegion[1].ToString().Trim();
                            StateCode1 = splitZipRegion[0].ToString().Trim();
                        }
                        //End formatting address

                        LocationAction objLocation = new LocationAction();
                        SeedAction objSeed = new SeedAction();
                        string latLong = seedCoordinatesStreamMini;
                        string[] strSplitLatLong = latLong.Split(',');
                        string lat = strSplitLatLong[0].ToString();
                        string longt = strSplitLatLong[1].ToString();
                        string crossStreet = StreetAddress1.Trim();
                        string cityId = objLocation.GetCityIdByCityName(City1, StateCode1);
                        if (string.IsNullOrEmpty(cityId))
                            cityId = objSeed.AddCity(City1, StateCode1);
                        Location loc = objLocation.CreateLocation(cityId, ZipCode1, Convert.ToDouble(lat), Convert.ToDouble(longt), crossStreet);
                        ss.locationId = loc.id;
                    }
                   
                    ss = objStream.UpdateStream1(ss);
                    if (txtCategoryStreamMini != null)
                    {
                        string catIds = string.Empty;
                        string[] splitCategories = txtCategoryStreamMini.Split(',');
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
                            objStream.AddFeedCategories(Convert.ToString(ss.id), arrCatIds);
                        }
                    }

                    if (!string.IsNullOrEmpty(Convert.ToString(ss.id)))
                    {
                        return RedirectToAction("ManageMyFeeds", "SeedStream");
                    }

                    return RedirectToAction("UnexpectedError", "Error");
                }

                ssStream stream = new ssStream();
                stream.title = gTitle;
                stream.description = gDesc;
                if (streamType == SystemStatements.STREAM_FEED)
                {
                    string defaultFeed = (string)SessionStore.GetSessionValue(SessionStore.DefaultFeed);
                    if (!string.IsNullOrEmpty(defaultFeed))
                        stream.criteria = defaultFeed;
                    stream.streamType = streamType;
                }
                else if (streamType == SystemStatements.STREAM_HANDPICKED)
                {
                    stream.streamType = streamType;
                }
                stream.ownerId = memberData.id;

                //Format address 
                string StreetAddress = string.Empty;
                string City = string.Empty;
                string ZipCode = string.Empty;
                string StateCode = string.Empty;

                if (!string.IsNullOrEmpty(seedLocationStreamMini))
                {
                    string[] splitAddress = seedLocationStreamMini.Split(',');
                    if (splitAddress.Length > 4)
                    {
                        StreetAddress = splitAddress[0].ToString() + ", " + splitAddress[1].ToString();
                        City = splitAddress[2].ToString().Trim();
                        string[] splitZipRegion = splitAddress[3].ToString().Trim().Split(' ');
                        ZipCode = splitZipRegion[1].ToString().Trim();
                        StateCode = splitZipRegion[0].ToString().Trim();
                    }
                    else
                    {
                        StreetAddress = splitAddress[0].ToString();
                        City = splitAddress[1].ToString().Trim();
                        string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                        ZipCode = splitZipRegion[1].ToString().Trim();
                        StateCode = splitZipRegion[0].ToString().Trim();
                    }
                    //End formatting address


                    LocationAction objLocation = new LocationAction();
                    SeedAction objSeed = new SeedAction();
                    string latLong = seedCoordinatesStreamMini;
                    string[] strSplitLatLong = latLong.Split(',');
                    string lat = strSplitLatLong[0].ToString();
                    string longt = strSplitLatLong[1].ToString();
                    string crossStreet = StreetAddress.Trim();
                    string cityId = objLocation.GetCityIdByCityName(City, StateCode);
                    if (string.IsNullOrEmpty(cityId))
                        cityId = objSeed.AddCity(City, StateCode);
                    Location loc = objLocation.CreateLocation(cityId, ZipCode, Convert.ToDouble(lat), Convert.ToDouble(longt), crossStreet);
                    stream.locationId = loc.id;
                }
                stream.isPublic = Convert.ToBoolean(gIsPublic);
                
                stream = objStream.CreateStream1(stream);
                if (txtCategoryStreamMini != null)
                {
                    string catIds = string.Empty;
                    string[] splitCategories = txtCategoryStreamMini.Split(',');
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
                        objStream.AddFeedCategories(Convert.ToString(stream.id), arrCatIds);
                    }
                }
                if (!string.IsNullOrEmpty(Convert.ToString(stream.id)))
                {
                    return RedirectToAction("ManageMyFeeds", "SeedStream");
                }
                return RedirectToAction("UnexpectedError", "Error");
            }
            catch (Exception ex)
            {
                SessionStore.SetSessionValue("PlantError", "Error occurred while creating list#" + ex.Message.ToString());
                return RedirectToAction("PlantError", "Seed");
            }
            #endregion
        }

        [HttpPost]
        public ActionResult AddStreamFeed(string gFeedTitle, string gFeedDesc, string gIsPublic, string seedLocationStreamFeed, string seedCoordinatesStreamFeed, string txtCategoryStreamFeed, string feedLocation, string profileLocValue, string NewLocValue, string LocationRadius, string CoordinatesRadius, string gIsMedia, string txtIncludeTerms, string txtExcludeTerms, string isEdit, string StreamId)
        {
            #region Front Logic
            try
            {
                Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
                StreamAction objStream = new StreamAction();
                ssStream stream = new ssStream();
                stream.title = gFeedTitle;
                stream.description = gFeedDesc;

                string feedQuery = "Select Seed.* from Seed where (seed.[status] = 'New' or seed.[status] = 'Growing')";

                #region add location in query
                if (!string.IsNullOrEmpty(feedLocation))
                {
                    if (feedLocation != "AllLocations")
                    {
                        string radius = string.Empty;
                        string radiusZipList = string.Empty;
                        string ZipCodeFeed = string.Empty;
                        if (feedLocation == "ProfileLocation")
                        {
                            radius = profileLocValue;
                            if (memberData.MemberProfiles != null)
                            {
                                if (memberData.MemberProfiles.FirstOrDefault().Location.zipcode != null)
                                    ZipCodeFeed = Convert.ToString(memberData.MemberProfiles.FirstOrDefault().Location.zipcode);
                            }
                            else
                                ZipCodeFeed = "85027";
                        }
                        if (feedLocation == "NewLocation")
                        {
                            radius = NewLocValue;

                            //Format address
                            string[] splitAddressFeed = LocationRadius.Split(',');
                            if (splitAddressFeed.Length > 4)
                            {
                                string[] splitZipRegion = splitAddressFeed[3].ToString().Trim().Split(' ');
                                ZipCodeFeed = splitZipRegion[1].ToString().Trim();
                            }
                            else
                            {
                                string[] splitZipRegion = splitAddressFeed[2].ToString().Trim().Split(' ');
                                ZipCodeFeed = splitZipRegion[1].ToString().Trim();
                            }
                            //End formatting address
                        }

                        //Get zip codes according to radius
                        CommonMethods objCommon = new CommonMethods();
                        radiusZipList = objCommon.GetZipByRadius(radius, ZipCodeFeed);
                        //End get zip codes according to radius

                        if (string.IsNullOrEmpty(radiusZipList))
                            radiusZipList = ZipCodeFeed;

                        feedQuery += " and locationId in (Select id from Location where zipcode in (" + radiusZipList + "))";
                    }
                }
                #endregion

                #region include terms in query
                if (!string.IsNullOrEmpty(txtIncludeTerms))
                {
                    string inCondition = string.Empty;
                    string[] includeTerms = txtIncludeTerms.Split(',');
                    for (int i = 0; i < includeTerms.Length; i++)
                    {
                        if (i == 0)
                            inCondition = "'" + includeTerms[i].ToString() + "'";
                        else
                            inCondition += ",'" + includeTerms[i].ToString() + "'";
                    }
                    feedQuery += " and Seed.id in (select sc.seedId from Category c ,Seed_has_Category sc where c.id=sc.categoryId and c.name in (" + inCondition + ") union select Seed.id from Seed,Member where Member.id = Seed.ownerId and Member.firstName in (" + inCondition + "))";
                }
                #endregion

                #region exclude terms in query
                if (!string.IsNullOrEmpty(txtExcludeTerms))
                {
                    string exCondition = string.Empty;
                    string[] excludeTerms = txtExcludeTerms.Split(',');
                    for (int i = 0; i < excludeTerms.Length; i++)
                    {
                        if (i == 0)
                            exCondition = "'" + excludeTerms[i].ToString() + "'";
                        else
                            exCondition += ",'" + excludeTerms[i].ToString() + "'";
                    }
                    feedQuery += " and Seed.id not in (select sc.seedId from Category c ,Seed_has_Category sc where c.id=sc.categoryId and c.name in (" + exCondition + ") union select Seed.id from Seed,Member where Member.id = Seed.ownerId and Member.firstName in (" + exCondition + "))";
                }
                #endregion

                #region add media in query
                if (!string.IsNullOrEmpty(gIsMedia))
                {
                    switch (gIsMedia)
                    {
                        case "All":
                            feedQuery += " and Seed.id in (Select m.seedId from Media m)";
                            break;
                        case "NoMedia":
                            feedQuery += " and Seed.id not in (Select m.seedId from Media m)";
                            break;
                        case "PhotosOnly":
                            feedQuery += " and Seed.id in (Select m.seedId from Media m where m.[type]='" + SystemStatements.MEDIA_IMAGE + "')";
                            break;
                        case "VideosOnly":
                            feedQuery += " and Seed.id in (Select m.seedId from Media m where m.[type]='" + SystemStatements.MEDIA_VIDEO + "')";
                            break;
                        default:
                            break;
                    }
                }
                #endregion

                stream.criteria = feedQuery;
                stream.streamType = SystemStatements.STREAM_FEED;
                stream.ownerId = memberData.id;

                if (isEdit == "Yes" && !string.IsNullOrEmpty(StreamId))
                {
                    ssStream ss = objStream.GetStreamById(StreamId);
                    ss.title = gFeedTitle;
                    ss.description = gFeedDesc;
                    ss.criteria = feedQuery;
                    ss.isPublic = Convert.ToBoolean(gIsPublic);
                    if (!string.IsNullOrEmpty(seedLocationStreamFeed))
                    {
                        //Format address 
                        string StreetAddress = string.Empty;
                        string City = string.Empty;
                        string ZipCode = string.Empty;
                        string StateCode = string.Empty;
                        string[] splitAddress = seedLocationStreamFeed.Split(',');
                        string feedCountry = string.Empty;
                        if (splitAddress.Length > 4)
                        {
                            StreetAddress = splitAddress[0].ToString() + ", " + splitAddress[1].ToString();
                            City = splitAddress[2].ToString().Trim();
                            string[] splitZipRegion = splitAddress[3].ToString().Trim().Split(' ');
                            ZipCode = splitZipRegion[1].ToString().Trim();
                            StateCode = splitZipRegion[0].ToString().Trim();
                            feedCountry = splitAddress[4].ToString();
                        }
                        else
                        {
                            StreetAddress = splitAddress[0].ToString();
                            City = splitAddress[1].ToString().Trim();
                            string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                            ZipCode = splitZipRegion[1].ToString().Trim();
                            StateCode = splitZipRegion[0].ToString().Trim();
                            feedCountry = splitAddress[3].ToString();
                        }
                        //End formatting address
                        if (feedCountry.Trim().Equals("USA") || feedCountry.Trim().Equals("US"))
                            feedCountry = feedCountry.Trim();
                        else
                            throw new Exception("Feeds can not be created outside region of United States");

                        LocationAction objLocation = new LocationAction();
                        SeedAction objSeed = new SeedAction();
                        string latLong = seedCoordinatesStreamFeed;
                        string[] strSplitLatLong = latLong.Split(',');
                        string lat = strSplitLatLong[0].ToString();
                        string longt = strSplitLatLong[1].ToString();
                        string crossStreet = StreetAddress.Trim();
                        string cityId = objLocation.GetCityIdByCityName(City, StateCode);
                        if (string.IsNullOrEmpty(cityId))
                            cityId = objSeed.AddCity(City, StateCode);
                        Location loc = objLocation.CreateLocation(cityId, ZipCode, Convert.ToDouble(lat), Convert.ToDouble(longt), crossStreet);
                        ss.locationId = loc.id;
                    }
                    ss = objStream.UpdateStream1(ss);
                    if (txtCategoryStreamFeed != null)
                    {
                        string catIds = string.Empty;
                        string[] splitCategories = txtCategoryStreamFeed.Split(',');
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
                            objStream.AddFeedCategories(Convert.ToString(ss.id), arrCatIds);
                        }
                    }
                    if (!string.IsNullOrEmpty(Convert.ToString(ss.id)))
                    {
                        return RedirectToAction("ManageMyFeeds", "SeedStream");
                    }
                    return RedirectToAction("UnexpectedError", "Error");
                }

                if (!string.IsNullOrEmpty(seedLocationStreamFeed))
                {
                    //Format address 
                    string StreetAddress = string.Empty;
                    string City = string.Empty;
                    string ZipCode = string.Empty;
                    string StateCode = string.Empty;
                    string[] splitAddress = seedLocationStreamFeed.Split(',');
                    string feedCountry = string.Empty;
                    if (splitAddress.Length > 4)
                    {
                        StreetAddress = splitAddress[0].ToString() + ", " + splitAddress[1].ToString();
                        City = splitAddress[2].ToString().Trim();
                        string[] splitZipRegion = splitAddress[3].ToString().Trim().Split(' ');
                        ZipCode = splitZipRegion[1].ToString().Trim();
                        StateCode = splitZipRegion[0].ToString().Trim();
                        feedCountry = splitAddress[4].ToString();
                    }
                    else
                    {
                        StreetAddress = splitAddress[0].ToString();
                        City = splitAddress[1].ToString().Trim();
                        string[] splitZipRegion = splitAddress[2].ToString().Trim().Split(' ');
                        ZipCode = splitZipRegion[1].ToString().Trim();
                        StateCode = splitZipRegion[0].ToString().Trim();
                        feedCountry = splitAddress[3].ToString();
                    }
                    //End formatting address
                    if (feedCountry.Trim().Equals("USA") || feedCountry.Trim().Equals("US"))
                        feedCountry = feedCountry.Trim();
                    else
                        throw new Exception("Feeds can not be created outside region of United States");

                    LocationAction objLocation = new LocationAction();
                    SeedAction objSeed = new SeedAction();
                    string latLong = seedCoordinatesStreamFeed;
                    string[] strSplitLatLong = latLong.Split(',');
                    string lat = strSplitLatLong[0].ToString();
                    string longt = strSplitLatLong[1].ToString();
                    string crossStreet = StreetAddress.Trim();
                    string cityId = objLocation.GetCityIdByCityName(City, StateCode);
                    if (string.IsNullOrEmpty(cityId))
                        cityId = objSeed.AddCity(City, StateCode);
                    Location loc = objLocation.CreateLocation(cityId, ZipCode, Convert.ToDouble(lat), Convert.ToDouble(longt), crossStreet);
                    stream.locationId = loc.id;
                }
                stream.isPublic = Convert.ToBoolean(gIsPublic);

                stream = objStream.CreateStream1(stream);
                if (txtCategoryStreamFeed != null)
                {
                    string catIds = string.Empty;
                    string[] splitCategories = txtCategoryStreamFeed.Split(',');
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
                        objStream.AddFeedCategories(Convert.ToString(stream.id), arrCatIds);
                    }
                }
                if (!string.IsNullOrEmpty(Convert.ToString(stream.id)))
                {
                    return RedirectToAction("ManageMyFeeds", "SeedStream");
                }
                return RedirectToAction("UnexpectedError", "Error");
            }
            catch (Exception ex)
            {
                SessionStore.SetSessionValue("PlantError", "Error occurred while creating feed#" + ex.Message.ToString());
                return RedirectToAction("PlantError", "Seed");
            }
            #endregion
        }

        public ActionResult AddSeedToStream(string AddSeedId, string AddStreamId)
        {
            #region
            StreamAction objStream = new StreamAction();
            bool isCompleted = false;
            isCompleted = objStream.AddSeedInStream(AddSeedId, AddStreamId);            
            TempData["StreamTab"] = 1;
            return RedirectToAction("ManageMyFeeds", "SeedStream");
            #endregion
        }

        public ContentResult InExTerms(string q, int limit, Int64 timestamp)
        {
            #region
            StringBuilder responseContentBuilder = new StringBuilder();
            CategoryAction objCat = new CategoryAction();
            StreamAction objStream = new StreamAction();
            IList<Category> lstCat = objCat.GetAllCategoriesByName(q).OrderBy(x => x.name).ToList();
            IList<Member> lstMember = objStream.GetAllMembersByName(q).OrderBy(x => x.firstName).ToList();

            foreach (Category cat in lstCat)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", cat.id, cat.name));

            foreach (Member mem in lstMember)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", mem.id, mem.firstName));

            return Content(responseContentBuilder.ToString());
            #endregion
        }

        public ContentResult SearchHelp(string q, int limit, Int64 timestamp)
        {
            #region
            StringBuilder responseContentBuilder = new StringBuilder();
            CategoryAction objCat = new CategoryAction();
            StreamAction objStream = new StreamAction();
            LocationAction objLocation = new LocationAction();
            IList<Category> lstCat = objCat.GetAllCategoriesByName(q).OrderBy(x => x.name).ToList();
            IList<Member> lstMember = objStream.GetAllMembersByName(q).OrderBy(x => x.firstName).ToList();
            IList<City> lstCity = objLocation.GetAllCities(q).OrderBy(x => x.name).ToList();

            foreach (Category cat in lstCat)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", cat.id, cat.name));

            foreach (Member mem in lstMember)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", mem.id, mem.firstName));

            foreach (City ct in lstCity)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", ct.id, ct.name));

            return Content(responseContentBuilder.ToString());
            #endregion
        }

        public ActionResult ListStreams(string id, string fid)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
            {
                string universalURL = "http://" + (Request.ServerVariables["SERVER_NAME"] + Request.ServerVariables["URL"]).ToString();
                SessionStore.SetSessionValue("RequestedURL", universalURL);
                return RedirectToAction("Default", "Member");
            }
            StreamAction objStream = new StreamAction();
            IList<ssStream> lstStream = objStream.GetAllStreams(memberData.id.ToString());
            ViewData["Streams"] = new SelectList(lstStream, "Id", "Title");

            Repository repoObj = new Repository();

            ssStream stream = null;
            if (lstStream.Count > 0)
                stream = objStream.GetStreamById(lstStream[0].id.ToString());
            IList<Seed> lstSeed = null;
            if (stream != null)
            {
                if (stream.streamType == SystemStatements.STREAM_FEED)
                {
                    lstSeed = repoObj.ListPPP<Seed>("usp_SearchSeeds", stream.criteria).ToList();
                    lstSeed = (from s in lstSeed select s).Distinct().ToList();
                }
                if (stream.streamType == SystemStatements.STREAM_HANDPICKED)
                {
                    lstSeed = stream.Seeds.ToList();
                }
            }

            if (!string.IsNullOrEmpty(id))
            {
                if (lstSeed.Count > 0)
                {
                    switch (id)
                    {
                        case "Date":
                            lstSeed.OrderByDescending(x => x.createDate).ToList();
                            break;
                        case "Category":
                            lstSeed.OrderBy(x => x.Categories.FirstOrDefault() != null ? x.Categories.FirstOrDefault().name : "").ToList();
                            break;
                        case "Likes":
                            lstSeed.OrderByDescending(x => x.Ratings.ToList().Count).ToList();
                            break;
                        case "Comments":
                            lstSeed.OrderByDescending(x => x.Comments.ToList().Count).ToList();
                            break;
                        case "SeedReplies":
                            lstSeed.OrderByDescending(x => x.Commitments.ToList().Count).ToList();
                            break;
                        default:
                            lstSeed.OrderByDescending(x => x.createDate).ToList();
                            break;
                    }
                }
            }

            ViewData["StreamSeedList"] = lstSeed;
            if (lstSeed != null)
                ViewData["StreamMarkerList"] = seedMarkers(lstSeed);

            SessionStore.SetSessionValue(SessionStore.StreamSeeds, lstSeed);

            SeedAction objSeed = new SeedAction();
            string[] dashboardCount = new string[4];
            IList<Seed> tempPlanted = objSeed.GetSeedsByUser(memberData.id.ToString()).Where(x => x.parentSeedID == null).ToList();
            int tmpPlant = tempPlanted.Count();
            dashboardCount[0] = tmpPlant.ToString();
                        
            dashboardCount[1] = lstStream.Count().ToString();

            MemberAction objMember = new MemberAction();
            IList<Member> followingMemberList = objMember.GetFollowing(memberData.id.ToString());
            dashboardCount[2] = followingMemberList.Count().ToString();

            MemberController objMemCtrl = new MemberController();
            IList<Seed> lstNearestSeeds = objMemCtrl.getNewestNearby("15");
            dashboardCount[3] = lstNearestSeeds.Count().ToString();

            SessionStore.SetSessionValue(SessionStore.DashboardCount, dashboardCount);
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult ListStreams(string ListStreamId)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            Repository repoObj = new Repository();
            StreamAction objStream = new StreamAction();
            IList<ssStream> lstStream = objStream.GetAllStreams(memberData.id.ToString());
            ViewData["Streams"] = new SelectList(lstStream, "Id", "Title");

            ssStream stream = objStream.GetStreamById(ListStreamId);
            IList<Seed> lstSeed = null;
            if (stream != null)
            {
                if (stream.streamType == SystemStatements.STREAM_FEED)
                {
                    lstSeed = repoObj.ListPPP<Seed>("usp_SearchSeeds", stream.criteria).ToList();
                    lstSeed = (from s in lstSeed select s).Distinct().ToList();
                }
                if (stream.streamType == SystemStatements.STREAM_HANDPICKED)
                {
                    lstSeed = stream.Seeds.ToList();
                }
            }
            ViewData["StreamSeedList"] = lstSeed;
            if (lstSeed != null)
                ViewData["StreamMarkerList"] = seedMarkers(lstSeed);

            SessionStore.SetSessionValue(SessionStore.StreamSeeds, lstSeed);
            return View();
            #endregion
        }

        public ActionResult ListFeeds(string id, string fid)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
            {
                string universalURL = "http://" + (Request.ServerVariables["SERVER_NAME"] + Request.ServerVariables["URL"]).ToString();
                SessionStore.SetSessionValue("RequestedURL", universalURL);
                return RedirectToAction("Default", "Member");
            }
            StreamAction objStream = new StreamAction();
            IList<ssStream> lstStream = objStream.GetAllStreams(memberData.id.ToString());
            ViewData["Streams"] = new SelectList(lstStream, "Id", "Title");

            Repository repoObj = new Repository();

            ssStream stream = null;
            if (lstStream.Count > 0)
                stream = objStream.GetStreamById(lstStream[0].id.ToString());
            IList<Seed> lstSeed = null;
            if (stream != null)
            {
                if (stream.streamType == SystemStatements.STREAM_FEED)
                {
                    lstSeed = repoObj.ListPPP<Seed>("usp_SearchSeeds", stream.criteria).ToList();
                    lstSeed = (from s in lstSeed select s).Distinct().ToList();
                }
                if (stream.streamType == SystemStatements.STREAM_HANDPICKED)
                {
                    lstSeed = stream.Seeds.ToList();
                }
            }

            if (!string.IsNullOrEmpty(id))
            {
                if (lstSeed.Count > 0)
                {
                    switch (id)
                    {
                        case "Date":
                            lstSeed.OrderByDescending(x => x.createDate).ToList();
                            break;
                        case "Category":
                            lstSeed.OrderBy(x => x.Categories.FirstOrDefault() != null ? x.Categories.FirstOrDefault().name : "").ToList();
                            break;
                        case "Likes":
                            lstSeed.OrderByDescending(x => x.Ratings.ToList().Count).ToList();
                            break;
                        case "Comments":
                            lstSeed.OrderByDescending(x => x.Comments.ToList().Count).ToList();
                            break;
                        case "SeedReplies":
                            lstSeed.OrderByDescending(x => x.Commitments.ToList().Count).ToList();
                            break;
                        default:
                            lstSeed.OrderByDescending(x => x.createDate).ToList();
                            break;
                    }
                }
            }

            ViewData["StreamSeedList"] = lstSeed;
            if (lstSeed != null)
                ViewData["StreamMarkerList"] = seedMarkers(lstSeed);

            SessionStore.SetSessionValue(SessionStore.StreamSeeds, lstSeed);

            SeedAction objSeed = new SeedAction();
            string[] dashboardCount = new string[4];
            IList<Seed> tempPlanted = objSeed.GetSeedsByUser(memberData.id.ToString()).Where(x => x.parentSeedID == null).ToList();
            int tmpPlant = tempPlanted.Count();
            dashboardCount[0] = tmpPlant.ToString();
            dashboardCount[1] = lstStream.Count().ToString();

            MemberAction objMember = new MemberAction();
            IList<Member> followingMemberList = objMember.GetFollowing(memberData.id.ToString());
            dashboardCount[2] = followingMemberList.Count().ToString();

            MemberController objMemCtrl = new MemberController();
            IList<Seed> lstNearestSeeds = objMemCtrl.getNewestNearby("15");
            dashboardCount[3] = lstNearestSeeds.Count().ToString();

            SessionStore.SetSessionValue(SessionStore.DashboardCount, dashboardCount);
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult ListFeeds(string ListStreamId)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            Repository repoObj = new Repository();
            StreamAction objStream = new StreamAction();
            IList<ssStream> lstStream = objStream.GetAllStreams(memberData.id.ToString());
            ViewData["Streams"] = new SelectList(lstStream, "Id", "Title");

            ssStream stream = objStream.GetStreamById(ListStreamId);
            IList<Seed> lstSeed = null;
            if (stream != null)
            {
                if (stream.streamType == SystemStatements.STREAM_FEED)
                {
                    lstSeed = repoObj.ListPPP<Seed>("usp_SearchSeeds", stream.criteria).ToList();
                    lstSeed = (from s in lstSeed select s).Distinct().ToList();
                }
                if (stream.streamType == SystemStatements.STREAM_HANDPICKED)
                {
                    lstSeed = stream.Seeds.ToList();
                }
            }
            ViewData["StreamSeedList"] = lstSeed;
            if (lstSeed != null)
                ViewData["StreamMarkerList"] = seedMarkers(lstSeed);

            SessionStore.SetSessionValue(SessionStore.StreamSeeds, lstSeed);
            return View();
            #endregion
        }

        public string seedMarkers(IList<Seed> lstSeed)
        {
            #region
            string markerList = "";
            foreach (Seed s1 in lstSeed)
            {
                if (s1.Location.localLat != null && s1.Location.localLong != null)
                {
                    if (string.IsNullOrEmpty(markerList))
                        markerList = s1.Location.localLat + "," + s1.Location.localLong;
                    else
                        markerList = markerList + "," + s1.Location.localLat + "," + s1.Location.localLong;
                }
            }
            return markerList;
            #endregion
        }

        public ActionResult SortData(string id)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            StreamAction objStream = new StreamAction();
            IList<ssStream> lstStream = objStream.GetAllStreams(memberData.id.ToString());
            ViewData["Streams"] = new SelectList(lstStream, "Id", "Title");

            IList<Seed> listSeed = null;
            if (SessionStore.GetSessionValue(SessionStore.StreamSeeds) != null)
                listSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.StreamSeeds);

            if (listSeed.Count > 0)
            {
                switch (id)
                {
                    case "Date":
                        listSeed.OrderByDescending(x => x.createDate).ToList();
                        break;
                    case "Category":
                        listSeed.OrderBy(x => x.Categories.FirstOrDefault() != null ? x.Categories.FirstOrDefault().name : "").ToList();
                        break;
                    case "Likes":
                        listSeed.OrderByDescending(x => x.Ratings.ToList().Count).ToList();
                        break;
                    case "Comments":
                        listSeed.OrderByDescending(x => x.Comments.ToList().Count).ToList();
                        break;
                    case "SeedReplies":
                        listSeed.OrderByDescending(x => x.Commitments.ToList().Count).ToList();
                        break;
                    default:
                        listSeed.OrderByDescending(x => x.createDate).ToList();
                        break;
                }
            }

            ViewData["StreamSeedList"] = listSeed;
            ViewData["StreamMarkerList"] = seedMarkers(listSeed);
            return View("ListFeeds");
            #endregion
        }

        public string ManageStream(string streamId)
        {
            #region
            StreamAction objStream = new StreamAction();
            ssStream stream = objStream.GetStreamById(streamId);
            string outStr = string.Empty;
            outStr = stream.id + "," + stream.title + "," + stream.description + "," + stream.streamType;
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(outStr);
            return output;
            #endregion
        }

        public string ManageStream1(string streamId)
        {
            #region
            StreamAction objStream = new StreamAction();
            ssStream stream = objStream.GetStreamById(streamId);
            ssStreamEditModel objModel = new ssStreamEditModel();
            objModel.id = stream.id;
            objModel.sstitle = stream.title;
            objModel.ssDesc = stream.description;
            objModel.ssType = stream.streamType;

            string catList = "";
            foreach (SeedSpeak.Model.Category catData in stream.Categories)
            {
                catList = catList + catData.name + ",";
            }
            catList = catList.TrimEnd(',', ' ');
            objModel.ssCategories = catList;

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(objModel);
            return output;
            #endregion
        }

        public ActionResult ManageMyFeeds(string id)
        {
            #region
            StreamAction objStream = new StreamAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<ssStream> lstFeeds = objStream.GetAllStreams(memberData.id.ToString());
            IList<ssStream> lstMyFeeds = lstFeeds.Where(x => x.streamType.Equals(SystemStatements.STREAM_FEED)).OrderByDescending(x => x.createDate).ToList();
            IList<ssStream> lstMyLists = lstFeeds.Where(x => x.streamType.Equals(SystemStatements.STREAM_HANDPICKED)).OrderByDescending(x => x.createDate).ToList();
            
            ViewData["ActiveTab"] = 0;
            if (!string.IsNullOrEmpty(id))
            {
                if (id == "Date")
                {
                    lstMyFeeds = lstMyFeeds.OrderByDescending(x => x.createDate).ToList();
                    ViewData["ActiveTab"] = 0;
                }
                if (id == "MostActivity")
                {
                    lstMyFeeds = lstMyFeeds.OrderByDescending(x => x.Seeds.ToList().Count()).ToList();
                    ViewData["ActiveTab"] = 0;
                }
                if (id == "Date1")
                {
                    lstMyLists = lstMyLists.OrderByDescending(x => x.Seeds.ToList().Count()).ToList();
                    ViewData["ActiveTab"] = 1;
                }
                if (id == "MostActivity1")
                {
                    lstMyLists = lstMyLists.OrderByDescending(x => x.Seeds.ToList().Count()).ToList();
                    ViewData["ActiveTab"] = 1;
                }
            }

            if (TempData["StreamTab"] != null)
            {
                int data = (int)TempData["StreamTab"];
                ViewData["ActiveTab"] = data;
            }

            ViewData["MyFeeds"] = lstMyFeeds;
            ViewData["MyLists"] = lstMyLists;

            SeedAction objSeed = new SeedAction();
            string[] dashboardCount = new string[4];
            IList<Seed> tempPlanted = objSeed.GetSeedsByUser(memberData.id.ToString()).Where(x => x.parentSeedID == null).ToList();
            int tmpPlant = tempPlanted.Count();
            dashboardCount[0] = tmpPlant.ToString();
            dashboardCount[1] = lstFeeds.Count().ToString();

            MemberAction objMember = new MemberAction();
            IList<Member> followingMemberList = objMember.GetFollowing(memberData.id.ToString());
            dashboardCount[2] = followingMemberList.Count().ToString();

            MemberController objMemCtrl = new MemberController();
            IList<Seed> lstNearestSeeds = objMemCtrl.getNewestNearby("15");
            dashboardCount[3] = lstNearestSeeds.Count().ToString();
            SessionStore.SetSessionValue(SessionStore.DashboardCount, dashboardCount);
            return View();
            #endregion
        }

        public ActionResult FeedDetails(string id)
        {
            #region
            Repository repoObj = new Repository();
            StreamAction objStream = new StreamAction();

            ssStream stream = objStream.GetStreamById(id);
            IList<Seed> lstSeed = null;
            ViewData["FeedName"] = "";
            if (stream != null)
            {
                ViewData["FeedName"] = stream.title;
                ViewData["FeedDesc"] = stream.description;                
                if (stream.streamType == SystemStatements.STREAM_FEED)
                {
                    lstSeed = repoObj.ListPPP<Seed>("usp_SearchSeeds", stream.criteria).ToList();
                    lstSeed = (from s in lstSeed select s).Distinct().ToList();
                }
                if (stream.streamType == SystemStatements.STREAM_HANDPICKED)
                {
                    lstSeed = stream.Seeds.ToList();
                }
            }
            ViewData["ListSeed"] = lstSeed;
            ViewData["FeedSeedsCount"] = lstSeed.Count();

            return View();
            #endregion
        }

        public string TerminateSeedStream(string id)
        {
            #region
            bool isCompleted = false;
            string msg = "false";
            StreamAction objStream = new StreamAction();
            isCompleted = objStream.TerminateSeedStream(id);
            if (isCompleted == true)
                msg = "true";
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(msg);
            return output;
            #endregion
        }
    }
}
