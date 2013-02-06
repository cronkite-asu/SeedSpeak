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
using Facebook.Rest;
using Facebook.Session;

namespace SeedSpeak.Controllers
{
    public class MemberController : Controller
    {
        //
        // GET: /Member/

        public ActionResult Index()
        {
            return View();
        }

        public bool CheckSessionExist()
        {
            bool isExist = true;
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
            {
                string universalURL = "http://" + (Request.ServerVariables["SERVER_NAME"] + Request.ServerVariables["URL"]).ToString();
                SessionStore.SetSessionValue("RequestedURL", universalURL);
                isExist = false;                
            }
            return isExist;
        }

        public ActionResult NewSeed()
        {            
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AjaxSubmit(int? id)
        {
            Session["ContentLength"] = Request.Files[0].ContentLength;
            Session["ContentType"] = Request.Files[0].ContentType;
            byte[] b = new byte[Request.Files[0].ContentLength];
            Request.Files[0].InputStream.Read(b, 0, Request.Files[0].ContentLength);
            Session["ContentStream"] = b;
            return Content(Request.Files[0].ContentType + ";" + Request.Files[0].ContentLength);
        }

        public ActionResult ImageLoad(int? id)
        {
            byte[] b = (byte[])Session["ContentStream"];
            int length = (int)Session["ContentLength"];
            string type = (string)Session["ContentType"];
            Response.Buffer = true;
            Response.Charset = "";
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = type;
            Response.BinaryWrite(b);
            Response.Flush();
            
            Response.End();
            return Content("");
        }

        // *************************************
        // URL: /Member/Default
        // *************************************
        private string ReturnIP2Address()
        {
            //MaxMind            
            System.Uri objUrl = new System.Uri(" http://j.maxmind.com/app/geoip.js");

            System.Net.WebRequest objWebReq;
            System.Net.WebResponse objResp;
            System.IO.StreamReader sReader;
            string strReturn = string.Empty;

            //Try to connect to the server and retrieve data. 
            try
            {
                objWebReq = System.Net.WebRequest.Create(objUrl);
                objResp = objWebReq.GetResponse();

                //Get the data and store in a return string. 
                sReader = new System.IO.StreamReader(objResp.GetResponseStream());
                strReturn = sReader.ReadToEnd();

                //Close the objects. 
                sReader.Close();
                objResp.Close();
            }
            catch
            {
            }
            finally
            {
                objWebReq = null;
            }

            return strReturn;
        }

        public ActionResult FBUser()
        {
            MemberAction objMember = new MemberAction();
            string[] fbDetails = (string[])SessionStore.GetSessionValue("FacebookDetails");
            Member memberData = objMember.GetMemberByUsername(fbDetails[0].ToString());
            if (memberData != null)
            {
                SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
                return RedirectToAction("Default", "Member");
            }
            return View();
        }

        [HttpPost]
        public ActionResult FBUser(string fbEmail)
        {
            MemberAction objMember = new MemberAction();
            string[] fbDetails = (string[])SessionStore.GetSessionValue("FacebookDetails");
            string[] fbNames = fbDetails[1].Split(' ');
            bool isRegistered = objMember.FBSignup(fbDetails[0].ToString(), fbNames[0].ToString(), fbNames[1].ToString(), fbEmail);
            if (isRegistered == true)
            {
                Member memberData = objMember.GetMemberByUsername(fbDetails[0].ToString());
                if (memberData != null)
                {
                    SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
                    return RedirectToAction("Default", "Member");
                }
            }
            return View();
        }

        public ActionResult Default()
        {
            #region PreviousCoding
            Repository repoObj = new Repository();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData != null)
            {
                //ViewData["LocationData"] = locations;
                //ViewData["Memberlocation"] = memberLocation;
            }
            else
            {
                string logoutString = TempData["Logout"] as string;
                if (logoutString != "Logout")
                {
                    const string myFacebookApiKey = "101151816623334";
                    const string myFacebookSecret = "65f49046dce2d1f54d6991e43c4af675";

                    var connectSession = new ConnectSession(myFacebookApiKey, myFacebookSecret);
                    if (connectSession.IsConnected())
                    {
                        ViewData["FBConnected"] = true;
                        var api = new Api(connectSession);
                        ViewData["FBUser"] = api.Users.GetInfo();
                        ViewData["UserID"] = api.Users.GetInfo().uid;
                        SessionStore.SetSessionValue(SessionStore.FacebookConnect, "FacebookUserLoggedIn");
                        string[] fbDetails = new string[2];
                        fbDetails[0] = Convert.ToString("fb_" + api.Users.GetInfo().uid);
                        fbDetails[1] = api.Users.GetInfo().name;
                        SessionStore.SetSessionValue("FacebookDetails", fbDetails);
                        api.Session.Logout();
                        connectSession.Logout();
                        return RedirectToAction("FBUser", "Member");
                    }
                }                
            }            
            #endregion

            GetTopPlanters();

            CommonMethods objCmnMethods = new CommonMethods();

            string strIpAddress = System.Web.HttpContext.Current.Request.UserHostAddress;
            if (strIpAddress == "127.0.0.1")
                strIpAddress = "61.246.241.162";
            
            string citySearch = string.Empty;
            string stateSearch = string.Empty;
            string zipCodeSearch = string.Empty;
            string latSearch = string.Empty;
            string lngSearch = string.Empty;
            string[] currentAddress;

            string ipLocation = objCmnMethods.MaxMindIPData(strIpAddress);
            if (!string.IsNullOrEmpty(ipLocation) && (!ipLocation.Contains("IP_NOT_FOUND")))
            {
                //IPaddressAPI
                currentAddress = ipLocation.Split(',');

                if (string.IsNullOrEmpty(currentAddress[1].Replace("\"", "").ToString()))
                    stateSearch = "AZ";
                else
                {
                    stateSearch = currentAddress[1].Replace("\"", "").ToString();
                    //stateSearch = "WA";
                }

                if (string.IsNullOrEmpty(currentAddress[2].ToString()))
                    citySearch = "Phoenix";
                else
                {
                    citySearch = currentAddress[2].Replace("\"", "").ToString();
                    //citySearch = "Seattle";
                }

                if (string.IsNullOrEmpty(currentAddress[3].Replace("\"", "").ToString()))
                {
                    //zipCodeSearch = "85027";
                    SeedAction objS = new SeedAction();
                    LocationAction objLocation = new LocationAction();
                    string cityId = objLocation.GetCityIdByCityName(citySearch, stateSearch);
                    zipCodeSearch = objS.GetZipOfSeedByCityId(cityId);
                }
                else
                    zipCodeSearch = currentAddress[3].Replace("\"", "").ToString();

                latSearch = currentAddress[4].Replace("\"", "").ToString();
                lngSearch = currentAddress[5].Replace("\"", "").ToString();
            }            
            else
            {
                //MaxMind
                ipLocation = objCmnMethods.IP2AddressMaxMind();
                currentAddress = ipLocation.Split('\'');

                if (string.IsNullOrEmpty(currentAddress[7].ToString()))
                    stateSearch = "AZ";
                else
                    stateSearch = currentAddress[7].ToString();

                if (string.IsNullOrEmpty(currentAddress[5].ToString()))
                    citySearch = "Phoenix";
                else
                    citySearch = currentAddress[5].ToString();

                if (string.IsNullOrEmpty(currentAddress[15].ToString()))
                    zipCodeSearch = "85027";
                else
                    zipCodeSearch = currentAddress[15].ToString();

                latSearch = currentAddress[11].ToString();
                lngSearch = currentAddress[13].ToString();
            }

            ViewData["LocLat"] = latSearch;
            ViewData["LocLng"] = lngSearch;            
            Session["LocLatLng"] = latSearch + "," + lngSearch;

            SeedAction objSeed = new SeedAction();            
            IList<Seed> lstSeed = getHomeSearchResult(citySearch, "", "", zipCodeSearch, "");
            if (lstSeed.Count > 0)
            {
                ViewData["SeedList"] = lstSeed.OrderByDescending(x => x.createDate).ToList();
                ViewData["userLocation"] = "Your Location : " + citySearch + ", " + stateSearch;
                ViewData["CatLocation"] = citySearch + ", " + stateSearch;
            }
            else
            {
                lstSeed = repoObj.List<Seed>().Where(x => x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING)).OrderByDescending(x => x.createDate).Take(20).ToList();
                ViewData["SeedList"] = lstSeed;
                ViewData["userLocation"] = "Your Location : " + citySearch + ", " + stateSearch;
                ViewData["CatLocation"] = citySearch + ", " + stateSearch;
                ViewData["CitySearchMsg"] = "<span>Sorry, no seeds planted in '" + citySearch + "' area. Showing latest additions.</span>";
                string streamFeed = "Select top 20 * from Seed order by createDate desc";
                SessionStore.SetSessionValue(SessionStore.DefaultFeed, streamFeed);
            }
            
            string advSearch = TempData["DiscoverSeed"] as string;
            if (advSearch != "AdvanceSearch")
            {
                if (lstSeed.Count > 0)
                    SessionStore.SetSessionValue(SessionStore.DiscoverSeed, lstSeed);
            }

            if (SessionStore.GetSessionValue(SessionStore.DiscoverSeed) != null)
                lstSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.DiscoverSeed);

            int rowCount = lstSeed.Count;
            Session["RowCount"] = rowCount;
            Session["PageCount"] = "1";
            ViewData["SeedList"] = lstSeed.Take(10).ToList();
            ViewData["PrevVisibility"] = "visibility:hidden;";
            if (lstSeed.Count > 10)
                ViewData["NxtVisibility"] = "visibility:visible;";
            else
                ViewData["NxtVisibility"] = "visibility:hidden;";

            foreach (Seed sd in lstSeed)
            {
                sd.seedDistance = (int)objCmnMethods.distance(Convert.ToDouble(latSearch), Convert.ToDouble(lngSearch), Convert.ToDouble(sd.Location.localLat), Convert.ToDouble(sd.Location.localLong));
            }
            if (lstSeed.Count > 0)
                SessionStore.SetSessionValue(SessionStore.DiscoverSeed, lstSeed);
            ViewData["SeedList"] = lstSeed.OrderBy(x => x.seedDistance).ToList();

            ViewData["MarkerList"] = MarkerGenerator((IList<Seed>)ViewData["SeedList"]);

            //ListBox
            if (Session["SelectedCategory"] != null)
            {                
                Session["SelectedCategory"] = null;
            }
            else
            {
                if (str != null)
                {
                    string myString = null;
                    for (int i = 0; i < str.Length; i++)
                    {
                        if (i == 0)
                        {
                            myString = str[i];

                        }
                        else
                        {
                            myString = myString + "," + str[i];
                        }
                    }
                    Session["SelectedCategory"] = myString;
                    ViewData["SelectedCategories"] = myString;
                }
            }
            //ListBox
            if (lstSeed.Count > 0)
            {
                CategoryAction objCat = new CategoryAction();
                IList<Category> categ = new List<Category>();
                Category c = null;
                foreach (Seed s in lstSeed)
                {
                    IList<Category> listCategory = s.Categories.ToList();
                    if (listCategory.Count > 0)
                    {
                        foreach (Category c1 in listCategory)
                        {
                            c = objCat.GetCategoryById(s.Categories.FirstOrDefault().id.ToString());
                            if (c != null)
                                categ.Add(c);
                        }
                    }
                }
                ViewData["SeedCategories"] = categ.Distinct().ToList();
            }

            return View();
        }

        public ActionResult SortingDefault(string id)
        {
            GetTopPlanters();

            IList<Seed> listSeed = null;
            if (SessionStore.GetSessionValue(SessionStore.DiscoverSeed) != null)
                listSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.DiscoverSeed);

            if (listSeed.Count > 0)
            {
                switch (id)
                {
                    case "Proximity":                        
                        ViewData["SeedList"] = listSeed.OrderBy(x => x.seedDistance).ToList();
                        break;
                    case "Date":
                        ViewData["SeedList"] = listSeed.OrderByDescending(x => x.createDate).ToList();
                        break;
                    case "Category":
                        ViewData["SeedList"] = listSeed.OrderByDescending(x => x.Categories.FirstOrDefault() != null ? x.Categories.FirstOrDefault().name : "").ToList();
                        break;
                    case "Likes":
                        ViewData["SeedList"] = listSeed.OrderByDescending(x => x.Ratings.ToList().Count).ToList();
                        break;
                    case "Comments":
                        ViewData["SeedList"] = listSeed.OrderByDescending(x => x.Comments.ToList().Count).ToList();
                        break;
                    case "SeedReplies":
                        ViewData["SeedList"] = listSeed.OrderByDescending(x => x.Seed1.ToList().Count).ToList();
                        break;
                    default:
                        ViewData["SeedList"] = listSeed.OrderByDescending(x => x.createDate).ToList();
                        break;
                }
            }

            ViewData["MarkerList"] = MarkerGenerator(listSeed);

            Session["RowCount"] = listSeed.Count();
            Session["PageCount"] = "1";
            ViewData["PrevVisibility"] = "visibility:hidden;";
            if (listSeed.Count > 10)
                ViewData["NxtVisibility"] = "visibility:visible;";
            else
                ViewData["NxtVisibility"] = "visibility:hidden;";

            return View("Default");
        }

        public IList<Seed> ProximitySort()
        {
            IList<Seed> listSeed = null;            
            string ip = System.Web.HttpContext.Current.Request.UserHostAddress;
            if (ip == "127.0.0.1")
                ip = "61.246.241.162";

            CommonMethods objCmnMethods = new CommonMethods();
            //MaxMind
            string zipSearch = string.Empty;            
            string[] currentAddress = objCmnMethods.IP2AddressMaxMind().Split('\'');
            if (currentAddress[15].ToString() == "")
                zipSearch = "85027";

            listSeed = getHomeSearchResult("", "", "", zipSearch, "");
            return listSeed;
        }

        public void GetTopPlanters()
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            Repository repoObj = new Repository();
            IList<TopSeedPlanter> listTopPlanters = repoObj.ListP<TopSeedPlanter>("Usp_GetTopSeedPlanter").ToList();
            IList<Member> mostFollowedList = repoObj.List<Member>(x => x.id.Equals(x.FollowPeoples1.FirstOrDefault().Member1.id)).OrderByDescending(x => x.FollowPeoples1.Count()).Take(10).ToList();
            if (memberData != null)
            {
                listTopPlanters = listTopPlanters.Where(x => x.id != memberData.id).ToList();
                mostFollowedList = mostFollowedList.Where(x => x.id != memberData.id).ToList();
            }
            ViewData["TopPlanters"] = listTopPlanters;
            ViewData["MostFollowed"] = mostFollowedList;            
            #endregion
        }
        
        static string[] str;
        //Fill ListBox

        [HttpPost]
        public ActionResult Default(string addr, string criteria, string[] sel0, string searchCriteriaTxt, string btnNext, string btnPrevious, string postLat, string postLng, string postZip)
        {
            GetTopPlanters();

            ViewData["LocLat"] = postLat;
            ViewData["LocLng"] = postLng;

            #region fb Coding
            string appid = ConfigurationManager.AppSettings["AppID"];
            ViewData["AppID"] = ConfigurationManager.AppSettings["AppID"];

            Repository repoObj = new Repository();            
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData != null)
            {
                
            }
            else
            {
                FacebookConnect fbConnect = new FacebookConnect();
                if (fbConnect.IsConnected)
                {
                    // message = "You are connected to Facebook";

                    //Use the wrapper class to get the access token
                    string token = fbConnect.AccessToken;
                    //Alternatively you can just pull the accesstoken out directly with the following line
                    //string token = HttpContext.Request.Cookies["fbs_" + ConfigurationManager.AppSettings["AppID"]]["\"access_token"];

                    //Note - you need to decode the token or it will be encoded twice.
                    token = HttpUtility.UrlDecode(token);

                    FacebookAPI api = new FacebookAPI(token);
                    JSONObject me = api.Get("/" + fbConnect.UserID);
                    SessionStore.SetSessionValue(SessionStore.FacebookConnect, "FacebookUserLoggedIn");
                    
                    return RedirectToAction("DiscoverSeed", "Seed");
                }
                else
                {
                    
                }
            }
            #endregion

            #region Search Code
            //Category Selected Seeds
            Session["SelectedCategory"] = null;            
            str = sel0;
            string myChoise = null;
            if (sel0 != null)
            {
                for (int i = 0; i < sel0.Length; i++)
                {
                    if (i == 0)
                    {
                        myChoise = sel0[0];
                    }
                    else
                    {
                        myChoise = myChoise + "," + sel0[i];
                    }
                }
            }
            Session["SelectedCategory"] = myChoise;
            
            ViewData["SelectedCategory"] = Session["SelectedCategory"];
            if (sel0 != null)
            {
                if (sel0.Count() == 1 && sel0[0].ToString().Equals("all"))
                    Session["SelectedCategory"] = null;
            }            
            #endregion

            #region Home Page Paging
            if (btnNext == ".." || btnPrevious == ".")
            {
                int PageCount = Convert.ToInt32(Session["PageCount"]);
                int rowCount = Convert.ToInt32(Session["RowCount"]);
                int NoOfPage = rowCount / 10;
                if (rowCount % 10 != 0)
                {
                    NoOfPage += 1;
                }

                IList<Seed> lstseed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.DiscoverSeed);
                if (btnNext != null && btnNext == "..")
                {
                    int skipRecord = PageCount * 10;
                    IList<Seed> lst = lstseed.Skip(skipRecord).ToList();
                    ViewData["SeedList"] = lst.Take(10).ToList();
                    PageCount += 1;
                    Session["PageCount"] = PageCount;
                    if (PageCount == NoOfPage)
                    {
                        ViewData["NxtVisibility"] = "visibility:hidden;";
                        ViewData["PrevVisibility"] = "visibility:visible;";
                    }
                }
                else if (btnPrevious != null && btnPrevious == ".")
                {
                    int takeRecord = (PageCount - 1) * 10;
                    IList<Seed> lst = lstseed.Take(takeRecord).ToList();
                    ViewData["SeedList"] = lst.Reverse().Take(10).Reverse().ToList();
                    PageCount -= 1;
                    if (PageCount == 1)
                    {
                        ViewData["NxtVisibility"] = "visibility:visible;";
                        ViewData["PrevVisibility"] = "visibility:hidden;";
                    }
                    Session["PageCount"] = PageCount;
                }

                ViewData["MarkerList"] = MarkerGenerator((IList<Seed>)ViewData["SeedList"]);
                return View();
            }
            #endregion

            #region Search Logic
            if (addr != "" || criteria != "" || sel0 != null)
            {
                string categList = string.Empty;
                if (sel0 != null)
                {
                    if (sel0.Count() == 1 && sel0[0].ToString().Equals("all"))
                    {
                        categList = "all";
                    }
                    else if (sel0.Count() > 0 && !sel0[0].ToString().Equals("all"))
                    {
                        for (int c = 0; c < sel0.Count(); c++)
                        {
                            if (string.IsNullOrEmpty(categList))
                                categList = "'" + sel0[c].ToString() + "'";
                            else
                                categList = categList + ",'" + sel0[c].ToString() + "'";
                        }
                    }
                    else if (sel0.Count() > 1 && sel0[0].ToString().Equals("all"))
                    {
                        for (int c = 1; c < sel0.Count(); c++)
                        {
                            if (string.IsNullOrEmpty(categList))
                                categList = "'" + sel0[c].ToString() + "'";
                            else
                                categList = categList + ",'" + sel0[c].ToString() + "'";
                        }
                    }
                }

                //Neighborhood
                try
                {
                    if (!string.IsNullOrEmpty(addr))
                    {
                        if (!addr.Contains(','))
                        {
                            string[] checkString = addr.Trim().Split(' ');
                            if (checkString.Length > 1)
                            {
                                int splitCount = checkString.Count();
                                if (checkString[splitCount - 1].ToString().Length == 2)
                                {
                                    int idx = addr.LastIndexOf(' ');
                                    string idxString = addr.Insert(idx, ",");
                                    addr = idxString;
                                }
                            }
                        }
                    }
                }
                catch { }

                string[] splitString1 = addr.Split(',');
                string cityName1 = string.Empty;
                if (splitString1.Length > 0)
                {
                    string citySplit = splitString1[0].ToString();
                    if (citySplit.Contains("Your Location"))
                        citySplit = citySplit.Replace("Your Location : ", "");

                    cityName1 = citySplit;
                }
                ViewData["CatLocation"] = cityName1;
                IList<Seed> newListSeed = this.getHomeSearchResult(cityName1, categList, criteria, postZip, criteria);
                ViewData["SeedList"] = newListSeed.Distinct().ToList();

                if (newListSeed.Count > 0)
                {
                    ViewData["SeedList"] = newListSeed.OrderByDescending(x => x.createDate).ToList();
                }
                else
                {
                    newListSeed = repoObj.List<Seed>().Where(x => (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).Take(20).OrderByDescending(x => x.createDate).ToList();
                    ViewData["SeedList"] = newListSeed;
                    ViewData["CitySearchMsg"] = "<span>Sorry, no seeds planted in '" + cityName1 + "' area. Showing latest additions.</span>";
                    string streamFeed = "Select top 20 * from Seed order by createDate desc";
                    SessionStore.SetSessionValue(SessionStore.DefaultFeed, streamFeed);
                }

                if (newListSeed.Count > 0)
                    SessionStore.SetSessionValue(SessionStore.DiscoverSeed, newListSeed);
                Session["RowCount"] = newListSeed.Count();
                Session["PageCount"] = "1";
                ViewData["PrevVisibility"] = "visibility:hidden;";
                if (newListSeed.Count > 10)
                    ViewData["NxtVisibility"] = "visibility:visible;";
                else
                    ViewData["NxtVisibility"] = "visibility:hidden;";

                CommonMethods objCmnMethods = new CommonMethods();
                string locLatLng = Session["LocLatLng"].ToString();
                string[] locLatLngSplit = locLatLng.Split(',');
                foreach (Seed sd in newListSeed)
                {
                    sd.seedDistance = (int)objCmnMethods.distance(Convert.ToDouble(locLatLngSplit[0].ToString()), Convert.ToDouble(locLatLngSplit[1].ToString()), Convert.ToDouble(sd.Location.localLat), Convert.ToDouble(sd.Location.localLong));
                }
                if (newListSeed.Count > 0)
                    SessionStore.SetSessionValue(SessionStore.DiscoverSeed, newListSeed);
                ViewData["SeedList"] = newListSeed.OrderBy(x => x.seedDistance).ToList();
                ViewData["MarkerList"] = MarkerGenerator(newListSeed);
                ViewData["Criteria"] = criteria;

                if (newListSeed.Count > 0)
                {
                    CategoryAction objCat = new CategoryAction();
                    IList<Category> categ = new List<Category>();
                    Category c = null;
                    foreach (Seed s in newListSeed)
                    {
                        IList<Category> listCategory = s.Categories.ToList();
                        if (listCategory.Count > 0)
                        {
                            foreach (Category c1 in listCategory)
                            {
                                c = objCat.GetCategoryById(s.Categories.FirstOrDefault().id.ToString());
                                if (c != null)
                                    categ.Add(c);
                            }
                        }
                    }
                    ViewData["SeedCategories"] = categ.Distinct().ToList();
                }
            }
            #endregion

            return View();
        }

        public string MarkerGenerator(IList<Seed> ListSeed)
        {
            #region
            string domainname = HttpContext.Request.ServerVariables["SERVER_NAME"];
            domainname = "http://" + domainname + "/Seed/SeedDetails/";
            string marker = "";

            foreach (Seed objSeed in ListSeed)
            {
                if (objSeed.Location.localLat != null && objSeed.Location.localLong != null)
                {
                    if (string.IsNullOrEmpty(marker))
                        marker = objSeed.Location.localLat + "," + objSeed.Location.localLong + "," + domainname + objSeed.id.ToString() + "," + objSeed.title + "," + objSeed.Location.City.name + " " + objSeed.Location.zipcode;
                    else
                        marker = marker + "," + objSeed.Location.localLat + "," + objSeed.Location.localLong + "," + domainname + objSeed.id.ToString() + "," + objSeed.title + "," + objSeed.Location.City.name + " " + objSeed.Location.zipcode;
                }
            }
            return marker;
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

        public ActionResult AddCommentAtHomePage(string SCid, string commentValue)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(SCid);
            seedData.status = SystemStatements.STATUS_GROWING;

            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            Comment objComment = new Comment();
            objComment.id = Guid.NewGuid();
            objComment.commentDate = DateTime.Now;
            objComment.msg = commentValue;
            objComment.seedId = seedData.id;
            objComment.commentById = memberData.id;
            objComment.isRead = false;

            seedData.Comments.Add(objComment);
            objSeed.UpdateSeed(seedData);

            ContributionMailAlert((seedData.Member.firstName + " " + seedData.Member.lastName).ToString(), (memberData.firstName + " " + memberData.lastName).ToString(), seedData.title, ("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/SeedDetails/" + seedData.id), seedData.Member.username.ToString(), "Comment");
            ViewData["commentId"] = seedData.id;
            return PartialView("CommentPartial");
            #endregion
        }

        public ActionResult LikeSeedPartial(string SLikedid, string partialLike)
        {
            #region
            SeedAction objSeed = new SeedAction();
            Seed seedData = objSeed.GetSeedBySeedId(SLikedid);
            seedData.status = SystemStatements.STATUS_GROWING;
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            bool isDone = objMember.LikeUnlike(memberData.id.ToString(), SLikedid, partialLike);            
            seedData = objSeed.GetSeedBySeedId(SLikedid);            
            ViewData["LikeData"] = seedData.id;
            return PartialView("LikePartial");
            #endregion
        }

        public void ContributionMailAlert(string name, string committername, string title, string url, string toMail, string contributionType)
        {
            #region Send Mail Code
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

        public ActionResult Logout()
        {
            #region Logout Code
            SessionStore.ClearSessionValue();

            //For Facebook logout if facebook login exists            
            string cookieName = "101151816623334_session_key";
            HttpCookie cookie = this.ControllerContext.HttpContext.Response.Cookies[cookieName];
            if (cookie != null)
            {
                cookie.Domain = "localhost";
                cookie.Value = null;
                cookie.Secure = false;
                cookie.Expires = DateTime.Now.AddDays(-3);
                this.ControllerContext.HttpContext.Response.Cookies.Add(cookie);
            }
            HttpCookie cookieRequest = this.ControllerContext.HttpContext.Request.Cookies[cookieName];
            if (cookieRequest != null)
            {
                cookieRequest.Secure = false;
                cookieRequest.Domain = "localhost";
                cookieRequest.Value = null;
                cookieRequest.Expires = DateTime.Now.AddDays(-3);
            }
            //Code ends for Facebook logout
            TempData["Logout"] = "Logout";
            return RedirectToAction("Default", "Member");
            #endregion
        }

        public ActionResult PasswordSent()
        {
            return View();
        }

        // *************************************
        // URL: /Member/SignUpUser
        // *************************************

        public CaptchaResult GetCaptcha()
        {
            string captchaText = SeedSpeak.Captcha.Captcha.GenerateRandomString();
            SessionStore.SetSessionValue(SessionStore.Captcha, captchaText);
            return new CaptchaResult(captchaText);
        }

        [HttpPost]
        public ActionResult SignUpUser(RegisterModel objRegModel, string captcha)
        {
            #region Code for Registration
            MemberAction objMember = new MemberAction();
            bool isUserExist = objMember.FindByUserName(objRegModel.UserName.Trim());

            if (isUserExist)
            {
                ModelState.AddModelError("", "User Already exist. Please change Username.");
            }
            else
            {
                bool isRegistered = objMember.Signup(objRegModel);
                if (isRegistered == true)
                {
                    #region Send Mail if Registration Successful
                    //send automated email - content of email will be decided later
                    // Creating array list for token 
                    ArrayList arrTokens = new ArrayList();
                    arrTokens.Add(objRegModel.FirstName + " " + objRegModel.LastName);
                    arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/Dashboard");
                    arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Seed/DiscoverSeed");
                    arrTokens.Add("http://" + Request.ServerVariables["SERVER_NAME"] + "/Member/Profile");                    

                    // Filling mail object
                    SendMail objSendMail = new SendMail();
                    objSendMail.ToEmailId = objRegModel.UserName;
                    objSendMail.Subject = "email.member.signup.subject.content";
                    objSendMail.MsgBody = "email.member.signup.body.content";
                    objSendMail.ChangesInMessage = arrTokens;

                    objSendMail.SendEmail(objSendMail);//    SendMail.(member.username, SystemStatements.DEFAUL_EMAIL_ADDRESS, SystemStatements.EMAIL_SUBJECT_SIGNUP, "");
                    #endregion

                    return RedirectToAction("SignUpThanks", "Member");
                }
                else
                {
                    ModelState.AddModelError("", "Error occured while registration.");
                }
            }
            return View("Default");
            #endregion
        }

        // *************************************
        // URL: /Member/SignUpThanks
        // *************************************
        public ActionResult SignUpThanks()
        {
            return View();
        }

        [HttpPost]
        public ActionResult SignUpThanks(string LogUserName, string LogPassword)
        {
            MemberAction objMember = new MemberAction();
            Member memberData = objMember.Authenticate(LogUserName, LogPassword);

            if (memberData != null)
            {
                SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
                if (memberData.Role.name == SystemStatements.ROLE_SUPER_ADMIN)
                    return RedirectToAction("AdminDashboard", "Admin");
                else if (memberData.Role.name == SystemStatements.ROLE_END_USER)
                    return RedirectToAction("Dashboard", "Member");
                else
                    return RedirectToAction("Dashboard", "Member");
            }
            else
            {
                ModelState.AddModelError("", "Login failed for current user.");
            }
            return View();
        }        

        // *************************************
        // URL: /Member/Dashboard
        // *************************************
        public ActionResult Dashboard(string id)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
                return RedirectToAction("Default", "Member");

            SeedAction objSeed = new SeedAction();

            IList<Seed> tempPlanted = objSeed.GetSeedsByUser(memberData.id.ToString()).Where(x => x.parentSeedID == null).ToList();
            IList<Seed> tempCommented = objSeed.GetAllSeedsCommentedByMe(memberData.id.ToString());
            tempCommented = tempCommented.Where(x => x.ownerId != memberData.id).ToList();
            IList<Seed> tempReply = objSeed.GetAllReplySeedsbyMember(memberData.id.ToString());
            var tempCmtReply = tempCommented.Union(tempReply);
            IList<Seed> tempFavSeeds = objSeed.GetAllFavouriteSeeds(memberData.id.ToString());

            string replySeedCount = objSeed.GetReplySeedCountbyOwnerId(memberData.id.ToString());

            if (!string.IsNullOrEmpty(id))
            {
                if (id == "Date")
                    tempPlanted = tempPlanted.OrderByDescending(x => x.createDate).ToList();

                if (id == "Category")
                    tempPlanted = tempPlanted.OrderBy(x => x.Categories.FirstOrDefault() != null ? x.Categories.FirstOrDefault().name : "").ToList();

                if (id == "Likes")
                    tempPlanted = tempPlanted.OrderByDescending(x => x.Ratings.ToList().Count).ToList();

                if (id == "Comments")
                    tempPlanted = tempPlanted.OrderByDescending(x => x.Comments.ToList().Count).ToList();

                if (id == "SeedReply")
                    tempPlanted = tempPlanted.OrderByDescending(x => x.Seed1.ToList().Count).ToList();
            }

            ViewData["MyPlantedSeeds"] = tempPlanted;
            ViewData["PlantedSeedCount"] = tempPlanted.Count();

            ViewData["MyCommentsAndReply"] = (from gs in tempCmtReply select gs).OrderByDescending(x => x.createDate).Distinct().ToList();
            ViewData["CommentsAndReplyCount"] = (from gs in tempCmtReply select gs).OrderByDescending(x => x.createDate).Distinct().ToList().Count();

            ViewData["MyFavSeeds"] = tempFavSeeds;
            ViewData["FavSeedsCount"] = tempFavSeeds.Count();

            SessionStore.SetSessionValue(SessionStore.MySeeds, tempPlanted);

            string[] dashboardCount = new string[4];
            int tmpPlant = tempPlanted.Count();
            int cmtReply = (from gs in tempCmtReply select gs).OrderByDescending(x => x.createDate).Distinct().ToList().Count();
            int fav = tempFavSeeds.Count();
            int MySeedsCount = tmpPlant + cmtReply + fav;
            dashboardCount[0] = MySeedsCount.ToString();

            StreamAction objStream = new StreamAction();
            IList<ssStream> lstStream = objStream.GetAllStreams(memberData.id.ToString());
            dashboardCount[1] = lstStream.Count().ToString();

            MemberAction objMember = new MemberAction();
            IList<Member> followingMemberList = objMember.GetFollowing(memberData.id.ToString());
            dashboardCount[2] = followingMemberList.Count().ToString();

            IList<Seed> lstNearestSeeds = getNewestNearby("15");
            dashboardCount[3] = lstNearestSeeds.Count().ToString();

            SessionStore.SetSessionValue(SessionStore.DashboardCount, dashboardCount);

            ViewData["SelectedIndex"] = 0;
            if (Request.QueryString["gridCmtReply-page"] != null)
                ViewData["SelectedIndex"] = 1;
            if (Request.QueryString["gridFavs-page"] != null)
                ViewData["SelectedIndex"] = 2;

            return View();
            #endregion
        }

        public void RegionCode()
        {
            LocationAction objLocation = new LocationAction();
            MemberAction objMember = new MemberAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<Model.Region> lstRegion = objLocation.GetAllRegions();
            ViewData["RegionList"] = new SelectList(lstRegion, "code", "code");
        }

        //Check Unread Comments
        public void CheckUnreadComments(string ids)
        {
            //if (ids != null)
            if (!ids.Equals("undefined") && !string.IsNullOrEmpty(ids))
            {
                string[] strSplitArr = ids.Split(';');
                MemberAction objMemberAction = new MemberAction();
                if (strSplitArr.Length > 0)
                {
                    for (int i = 0; i <= strSplitArr.Length - 1; i++)
                    {
                        if (!string.IsNullOrEmpty(strSplitArr[i].ToString()))
                            objMemberAction.UpdateMemberComments(new Guid(strSplitArr[i].ToString()));
                    }
                }
            }
        }

        //Check Unread Commitment
        public void CheckUnreadCommitment(string ids)
        {
            if (!ids.Equals("undefined") && !string.IsNullOrEmpty(ids))
            {
                string[] strSplitArr = ids.Split(';');
                MemberAction objMemberAction = new MemberAction();
                if (strSplitArr.Length > 0)
                {
                    for (int i = 0; i <= strSplitArr.Length - 1; i++)
                    {
                        if (!string.IsNullOrEmpty(strSplitArr[i].ToString()))
                            objMemberAction.UpdateMemberCommitments(new Guid(strSplitArr[i].ToString()));
                    }
                }
            }
        }

        //Check Unread Flags
        public void CheckUnreadFlags(string ids)
        {
            if (!ids.Equals("undefined") && !string.IsNullOrEmpty(ids))
            {
                string[] strSplitArr = ids.Split(';');
                MemberAction objMemberAction = new MemberAction();
                if (strSplitArr.Length > 0)
                {
                    for (int i = 0; i <= strSplitArr.Length - 1; i++)
                    {
                        if (!string.IsNullOrEmpty(strSplitArr[i].ToString()))
                            objMemberAction.UpdateMemberFlags(new Guid(strSplitArr[i].ToString()));
                    }
                }
            }
        }

        //Check Unread Likes
        public void CheckUnreadLikes(string ids)
        {
            if (!ids.Equals("undefined") && !string.IsNullOrEmpty(ids))
            {
                string[] strSplitArr = ids.Split(';');
                MemberAction objMemberAction = new MemberAction();
                if (strSplitArr.Length > 0)
                {
                    for (int i = 0; i <= strSplitArr.Length - 1; i++)
                    {
                        if (!string.IsNullOrEmpty(strSplitArr[i].ToString()))
                            objMemberAction.UpdateMemberLikes(new Guid(strSplitArr[i].ToString()));
                    }
                }
            }
        }

        //Check Unread Notifications
        public void CheckUnreadNotifications(string id)
        {
            if (!id.Equals("undefined") && !string.IsNullOrEmpty(id))
            {
                MemberAction objMember = new MemberAction();
                string[] notifyIds = id.Split(',');
                for (int i = 0; i < notifyIds.Count(); i++)
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

        public ActionResult FacebookLogout()
        {
            SessionStore.ClearSessionValue();

            string cookieName = "fbs_" + ConfigurationManager.AppSettings["AppID"];
            HttpCookie cookie = this.ControllerContext.HttpContext.Response.Cookies[cookieName];
            if (cookie != null)
            {
                cookie.Domain = ConfigurationManager.AppSettings["Domain"];
                cookie.Value = null;
                cookie.Secure = false;
                cookie.Expires = DateTime.Now.AddDays(-3);
                this.ControllerContext.HttpContext.Response.Cookies.Add(cookie);
            }
            HttpCookie cookieRequest = this.ControllerContext.HttpContext.Request.Cookies[cookieName];
            if (cookieRequest != null)
            {
                cookieRequest.Secure = false;
                cookieRequest.Domain = ConfigurationManager.AppSettings["Domain"];
                cookieRequest.Value = null;
                cookieRequest.Expires = DateTime.Now.AddDays(-3);
            }
            return RedirectToAction("Default", "Member");
        }

        public void GetActionNotifications()
        {
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
        }

        public ActionResult GetNotifications()
        {
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            Repository repoObj = new Repository();
            IList<usp_GetCommentNotification_Result> listComments = repoObj.ListPP<usp_GetCommentNotification_Result>("usp_GetCommentNotification", memberData.id.ToString()).OrderByDescending(x => x.commentDate).ToList();
            ViewData["CommentNotification"] = listComments;
            IList<usp_GetCommitmentNotification_Result> listCommitments = repoObj.ListPP<usp_GetCommitmentNotification_Result>("usp_GetCommitmentNotification", memberData.id.ToString()).OrderByDescending(x => x.commitDate).ToList();
            ViewData["CommitmentNotification"] = listCommitments;
            IList<usp_GetFlagNotification_Result> listFlags = repoObj.ListPP<usp_GetFlagNotification_Result>("usp_GetFlagNotification", memberData.id.ToString()).OrderByDescending(x => x.dateFlagged).ToList();
            ViewData["FlagNotification"] = listFlags;
            return View("GetNotifications");
        }

        public ContentResult Tags(string q, int limit, Int64 timestamp)
        {
            StringBuilder responseContentBuilder = new StringBuilder();
            SeedAction objSeed = new SeedAction();
            IList<Tag> lstTags = (from t in objSeed.GetAllTagsByName(q)
                                  group t by new { t.name } into g
                                  select new Tag { name = g.Key.name }).ToList();

            foreach (Tag tag in lstTags)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", tag.id, tag.name));
            return Content(responseContentBuilder.ToString());
        }

        public ContentResult Category(string q, int limit, Int64 timestamp)
        {
            StringBuilder responseContentBuilder = new StringBuilder();
            CategoryAction objCat = new CategoryAction();
            IList<Category> lstCat = objCat.GetAllCategoriesByName(q).OrderBy(x => x.name).ToList();

            foreach (Category cat in lstCat)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", cat.id, cat.name));

            return Content(responseContentBuilder.ToString());
        }

        public ContentResult Titles(string q, int limit, Int64 timestamp)
        {
            StringBuilder responseContentBuilder = new StringBuilder();
            SeedAction objSeed = new SeedAction();
            IList<Seed> finalList = new List<Seed>();

            IList<Seed> lstSeed = objSeed.GetAllSeedsByTitle(q).OrderBy(x => x.title).ToList();

            foreach (Seed s in lstSeed)
            {
                finalList.Add(s);
            }

            foreach (Seed seed in finalList)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", seed.id, seed.title));

            IList<Tag> lstTags = (from t in objSeed.GetAllTagsByName(q)
                                  group t by new { t.name } into g
                                  select new Tag { name = g.Key.name }).ToList();

            foreach (Tag tag in lstTags)
                responseContentBuilder.Append(String.Format("{0}|{1}\n", tag.id, tag.name));

            return Content(responseContentBuilder.ToString());
        }

        public ContentResult Cities(string q, int limit, Int64 timestamp)
        {
            StringBuilder responseContentBuilder = new StringBuilder();
            LocationAction objLoc = new LocationAction();
            IList<City> lstCity = objLoc.GetAllCities(q).OrderBy(x => x.Region.code).ToList();            

            foreach (City city in lstCity)
                responseContentBuilder.Append(String.Format("{0}|{1}|{2}\n", city.id, city.Region.code, city.name));

            return Content(responseContentBuilder.ToString());
        }


        public void bindCheckBox()
        {
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
        }

        // *************************************
        // URL: /Member/LoginUser
        // *************************************
        [HttpPost]
        public ActionResult Login(RegisterModel objLoginModel, string chkRemember)
        {
            #region
            MemberAction objMember = new MemberAction();
            Member memberData = objMember.Authenticate(objLoginModel.LogUserName, objLoginModel.LogPassword);

            if (memberData != null)
            {
                if (chkRemember != null)
                {
                    //Create a new cookie, passing the name into the constructor
                    HttpCookie cookie = new HttpCookie("UserInfo");
                    HttpCookie cookie1 = new HttpCookie("PassInfo");

                    //Set the cookies value
                    cookie.Value = objLoginModel.LogUserName;
                    cookie1.Value = objLoginModel.LogPassword;

                    //Set the cookie to expire in 1 minute
                    DateTime dtNow = DateTime.Now.AddDays(30);

                    cookie.Expires = dtNow;
                    cookie1.Expires = dtNow;

                    //Add the cookie
                    Response.Cookies.Add(cookie);
                    Response.Cookies.Add(cookie1);
                }

                SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
                string requestURL = (string)SessionStore.GetSessionValue("RequestedURL");
                SessionStore.SetSessionValue("RequestedURL", null);

                if (memberData.Role.name == SystemStatements.ROLE_SUPER_ADMIN)
                {
                    if (!string.IsNullOrEmpty(requestURL))
                        return Redirect(requestURL);
                    else
                        return RedirectToAction("AdminDashboard", "Admin");
                }
                else if (memberData.Role.name == SystemStatements.ROLE_END_USER)
                {
                    if (!string.IsNullOrEmpty(requestURL))
                    {
                        //Response.Redirect(requestURL);
                        return Redirect(requestURL);
                    }
                    else
                    {
                        //return RedirectToAction("Dashboard", "Member");
                        return RedirectToAction("Default", "Member");
                    }
                }
                else
                {
                    if (!string.IsNullOrEmpty(requestURL))
                        return Redirect(requestURL);
                    else
                    {
                        //return RedirectToAction("Dashboard", "Member");
                        return RedirectToAction("Default", "Member");
                    }
                }
            }
            else
            {
                ModelState.AddModelError("", "Login failed for current user.");
            }
            return View("Default");
            #endregion
        }

        public string CheckMember(string userName, string password)
        {
            Boolean isAuthenticate = false;

            MemberAction objMember = new MemberAction();
            Member memberData = objMember.Authenticate(userName, password);
            if (memberData != null)
            {
                isAuthenticate = true;
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(isAuthenticate);

            return output;
        }

        public string CheckUserSignUp(string userName, string captaText, string checkString)
        {
            bool isUserFind;
            string userMessage = "true";
            //  string captchaValue = SessionStore.GetSessionValue(SessionStore.Captcha).ToString();

            MemberAction objMember = new MemberAction();
            isUserFind = objMember.FindByUserName(userName);

            MvcReCaptcha.CaptchaValidatorAttribute valAttributr = new MvcReCaptcha.CaptchaValidatorAttribute();

            bool isCaptchaMatch = valAttributr.myValidator(checkString, captaText);

            if (isUserFind)
            {
                userMessage = "User already exist, Please enter different email";
            }
            else if (isCaptchaMatch == false)
            {
                userMessage = "Captcha value is not valid";
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var output = serializer.Serialize(userMessage);

            return output;
        }

        // *************************************
        // URL: /Member/ChangePassword
        // *************************************
        public ActionResult ChangePassword()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ChangePassword(ProfileModel objChangePwdModel)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            MemberAction objMember = new MemberAction();
            Privacy privacyData = objMember.GetPrivacyByMemberId(memberData.id);
            bool isVerified = objMember.CheckOldPassword(memberData, objChangePwdModel.OldPassword);
            if (isVerified == true)
            {
                bool isPwdUpdated = objMember.ChangeMemberPasswd(memberData, objChangePwdModel.NewPassword);
                if (isPwdUpdated == true)
                {
                    ViewData["ChangePwdMsg"] = "<b>Password has been updated successfully.</b>";
                }
                else
                {
                    ViewData["ChangePwdMsg"] = "Error occured while updating password.";
                }
            }
            else
            {
                ViewData["ChangePwdMsg"] = "Old password does not match.";
            }
            ViewData["SelectedIndex"] = 2;
            GetRegions();
            MyUsername(privacyData);
            SeedContributionMessage(privacyData);
            SeedCommitmentMessage(privacyData);
            GetExternalAccountList();
            ViewData["LoggedInMember"] = memberData.id.ToString();
            return View("Profile");
            #endregion
        }

        // *************************************
        // URL: /Member/ManageProfile
        // *************************************
        private void GetRegions()
        {
            #region
            LocationAction objLocation = new LocationAction();
            MemberAction objMember = new MemberAction();

            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);

            Location locData = objLocation.GetLocationDetailByMemberId(memberData.id.ToString());

            string cityId = "";
            string regionId = "";

            if (locData != null)
            {
                if (locData.City != null)
                {
                    cityId = locData.City.id.ToString();

                    if (locData.City.Region != null)
                    {
                        regionId = locData.City.Region.id.ToString();
                    }
                }
            }

            IList<Model.Region> lstRegionItem = objLocation.GetAllRegions();

            ViewData["CityId"] = cityId;

            if (regionId.Length > 0)
            {
                Model.Region selLstRegionItem = objLocation.GetRegionById(regionId);
                ViewData["RegionItem"] = new SelectList(lstRegionItem, "id", "name", selLstRegionItem.id);
            }
            else
            {
                ViewData["RegionItem"] = new SelectList(lstRegionItem, "id", "name");
            }
            #endregion
        }

        private void MyUsername(Privacy privacyData)
        {
            #region
            LocationAction objLocation = new LocationAction();

            var lstMyUsername = from u in objLocation.GetAllMyUsernameMessages()
                                select new
                                {
                                    ViewUsername = u.id,
                                    uMessage = u.displayMessage
                                };

            if (privacyData != null)
            {
                Guid uName = new Guid(privacyData.viewUsername);

                var selectedUserMessage = (from m in objLocation.GetMessageById(uName)
                                           select new
                                           {
                                               ViewUsername = m.id,
                                               uMessage = m.displayMessage
                                           }).FirstOrDefault();

                ViewData["MyUsername"] = new SelectList(lstMyUsername, "ViewUsername", "uMessage", selectedUserMessage.ViewUsername);
            }
            else
            {
                ViewData["MyUsername"] = new SelectList(lstMyUsername, "ViewUsername", "uMessage");
            }
            #endregion
        }

        private void SeedContributionMessage(Privacy privacyData)
        {
            #region
            LocationAction objLocation = new LocationAction();
            var lstSeedContributionMessage = from u in objLocation.GetAllSeedContributionMessages()
                                             select new
                                             {
                                                 seedContribution = u.id,
                                                 cMessage = u.displayMessage
                                             };

            if (privacyData != null)
            {
                Guid uName = new Guid(privacyData.seedContribution);

                var selectedContriMessage = (from m in objLocation.GetMessageById(uName)
                                             select new
                                             {
                                                 seedContribution = m.id,
                                                 cMessage = m.displayMessage
                                             }).FirstOrDefault();

                ViewData["VSeedContribution"] = new SelectList(lstSeedContributionMessage, "seedContribution", "cMessage", selectedContriMessage.seedContribution);
            }
            else
            {
                ViewData["VSeedContribution"] = new SelectList(lstSeedContributionMessage, "seedContribution", "cMessage");
            }
            #endregion
        }

        private void SeedCommitmentMessage(Privacy privacyData)
        {
            #region
            LocationAction objLocation = new LocationAction();
            var lstSeedCommitmentMessage = from u in objLocation.GetAllSeedCommitmentMessages()
                                           select new
                                           {
                                               seedCommitment = u.id,
                                               comMessage = u.displayMessage
                                           };

            if (privacyData != null)
            {
                Guid uName = new Guid(privacyData.seedCommitment);

                var selectedCommitMessage = (from m in objLocation.GetMessageById(uName)
                                             select new
                                             {
                                                 seedCommitment = m.id,
                                                 comMessage = m.displayMessage
                                             }).FirstOrDefault();

                ViewData["VSeedCommitment"] = new SelectList(lstSeedCommitmentMessage, "seedCommitment", "comMessage", selectedCommitMessage.seedCommitment);
            }
            else
            {
                ViewData["VSeedCommitment"] = new SelectList(lstSeedCommitmentMessage, "seedCommitment", "comMessage");
            }
            #endregion
        }

        private void GetAllCities(string regId)
        {
            #region
            if (regId == null)
                regId = "31a173d8-4bba-df11-9a64-7071bc4b6942";

            LocationAction objLocation = new LocationAction();
            IEnumerable<SelectListItem> lstCityItem = objLocation.GetAllCitiesForRegion(regId).Select(c => new SelectListItem { Value = c.id.ToString(), Text = c.name });
            ViewData["CityListItem"] = lstCityItem;
            #endregion
        }

        public ActionResult Models(string id)
        {
            string regId = id;
            LocationAction objLocation = new LocationAction();
            IEnumerable<SelectListItem> lstCityItem = objLocation.GetAllCitiesForRegion(regId).Select(c => new SelectListItem { Value = c.id.ToString(), Text = c.name }).OrderBy(c => c.Text);

            return Json(lstCityItem.ToList(), JsonRequestBehavior.AllowGet);
        }

        // *************************************
        // URL: /Member/ListMember
        // *************************************
        private void GetAllMemberList()
        {
            MemberAction objMember = new MemberAction();
            IList<Member> lstMember = objMember.GetAllMember().ToList();
            ViewData["MemberList"] = lstMember;
        }

        public ActionResult ListMember()
        {
            GetAllMemberList();
            return View();
        }

        // *************************************
        // URL: /Member/ForgotPassword
        // *************************************
        [HttpPost]
        public ActionResult ForgotPassword(RegisterModel objPwdModel)
        {
            #region Send Mail for password
            MemberAction objMember = new MemberAction();
            string memberPwd = objMember.GetPwdByUserName(objPwdModel.ForgotUserName);
            if (!string.IsNullOrEmpty(memberPwd))
            {
                //send automated email - content of email will be decided later
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(objPwdModel.ForgotUserName);
                arrTokens.Add(memberPwd);

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = objPwdModel.ForgotUserName;
                objSendMail.Subject = "email.forget.password.subject.content";
                objSendMail.MsgBody = "email.forget.password.body.content";
                objSendMail.ChangesInMessage = arrTokens;
                objSendMail.SendEmail(objSendMail);
                ViewData["Message"] = "Your password has been sent to the specified email address. Please check your email to find out the password.";

                return View("PasswordSent");
            }
            else
            {
                ViewData["Message"] = "Sorry! We could not find a user registered with that email address";
                return View("PasswordSent");
            }
            #endregion
        }

        // *************************************
        // URL: /Member/Profile
        // *************************************
        private void GetRegions1()
        {
            LocationAction objLocation = new LocationAction();
            IEnumerable<SelectListItem> lstRegionItem = objLocation.GetAllRegions().Select(r => new SelectListItem { Value = r.id.ToString(), Text = r.name });
            ViewData["RegionItem"] = lstRegionItem;
        }

        private void GetAllCities1(string regId)
        {
            if (regId == null)
                regId = "31a173d8-4bba-df11-9a64-7071bc4b6942";

            LocationAction objLocation = new LocationAction();
            IEnumerable<SelectListItem> lstCityItem = objLocation.GetAllCitiesForRegion(regId).Select(c => new SelectListItem { Value = c.id.ToString(), Text = c.name });
            ViewData["CityListItem"] = lstCityItem;
        }

        public ActionResult Models1(string id)
        {
            string regId = id;

            LocationAction objLocation = new LocationAction();
            IEnumerable<SelectListItem> lstCityItem = objLocation.GetAllCitiesForRegion(regId).Select(c => new SelectListItem { Value = c.id.ToString(), Text = c.name });
            return Json(lstCityItem.ToList(), JsonRequestBehavior.AllowGet);
        }

        private void GetExternalAccountList()
        {
            MemberAction objMember = new MemberAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            IList<ExternalAccount> listAccount = objMember.GetExternalAccountsList(memberData.id.ToString()).ToList();
            ViewData["AccountList"] = listAccount;
        }

        private void GetProfileData()
        {
            MemberAction objMember = new MemberAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            memberData = objMember.GetMemberByMemberId(memberData.id.ToString());
            ViewData["MemberData"] = memberData;
            MemberProfile objMemberProfile = memberData.MemberProfiles.FirstOrDefault();
            ViewData["MemberProfile"] = objMemberProfile;
            Privacy objPrivacy = memberData.Privacies.FirstOrDefault();
            ViewData["Privacy"] = objPrivacy;
        }

        public ActionResult Profile()
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);            
            if (memberData == null)
            {
                string universalURL = "http://" + (Request.ServerVariables["SERVER_NAME"] + Request.ServerVariables["URL"]).ToString();
                SessionStore.SetSessionValue("RequestedURL", universalURL);
                return RedirectToAction("Default", "Member");
            }

            MemberAction objMember = new MemberAction();
            Privacy privacyData = objMember.GetPrivacyByMemberId(memberData.id);
            if (memberData == null)
                return RedirectToAction("Default", "Member");
            
            GetRegions();
            MyUsername(privacyData);
            SeedContributionMessage(privacyData);
            SeedCommitmentMessage(privacyData);
            GetExternalAccountList();
            GetProfileData();
            ViewData["LoggedInMember"] = memberData.id.ToString();
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult Profile(ProfileModel objProfileModel, string userFName, string userLName, string setURL, string userBio)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            Privacy privacyData = objMember.GetPrivacyByMemberId(memberData.id);
            if (!string.IsNullOrEmpty(setURL))
                setURL = "www.seedspeak.com/" + setURL;
            bool isProfileUpdated = objMember.ManageMemberProfile(memberData, objProfileModel.City, objProfileModel.ZipCode, double.Parse(objProfileModel.Latitude), double.Parse(objProfileModel.Longitude), objProfileModel.Sex, objProfileModel.Dob, setURL, userBio);
            if (!string.IsNullOrEmpty(userFName) || !string.IsNullOrEmpty(userLName))
            {
                memberData.firstName = userFName;
                memberData.lastName = userLName;
                bool updated = objMember.UpdateMember(memberData);
                if (updated == true)
                {
                    ViewData["PersonalMsg"] = "<b>Name updated successfully.</b>";
                }
                else
                {
                    ViewData["PersonalMsg"] = "Error while updating name.";
                }
            }
            if (isProfileUpdated == true)
            {
                ViewData["PersonalMsg"] = "<b>Profile updated successfully.</b>";
            }
            else
            {
                ViewData["PersonalMsg"] = "Error occured while updating profile.";
            }
            ViewData["SelectedIndex"] = 0;
            GetRegions();
            MyUsername(privacyData);
            SeedContributionMessage(privacyData);
            SeedCommitmentMessage(privacyData);
            GetExternalAccountList();
            GetProfileData();
            ViewData["LoggedInMember"] = memberData.id.ToString();
            return View(objProfileModel);
            #endregion
        }

        [HttpPost]
        public ActionResult ExternalAccounts(ProfileModel objExternalModel)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            Privacy privacyData = objMember.GetPrivacyByMemberId(memberData.id);
            SeedSpeak.Model.ExternalAccount extAccount = new SeedSpeak.Model.ExternalAccount();
            extAccount.accountTye = objExternalModel.AccountType;
            extAccount.username = objExternalModel.Username;
            extAccount.passwd = objExternalModel.Password;
            extAccount.verified = false;
            bool saved = objMember.ManageExternalAccount(memberData, extAccount);
            if (saved == true)
            {
                ViewData["ExternalMsg"] = "<b>External account saved succesfully.</b>";
            }
            else
            {
                ViewData["ExternalMsg"] = "Problem saving external account.";
            }
            ViewData["SelectedIndex"] = 2;
            GetRegions();
            MyUsername(privacyData);
            SeedContributionMessage(privacyData);
            SeedCommitmentMessage(privacyData);
            GetExternalAccountList();
            GetExternalAccountList();
            GetProfileData();
            ViewData["LoggedInMember"] = memberData.id.ToString();
            return View("Profile");
            #endregion
        }

        [HttpPost]
        public ActionResult PrivacyAccounts(ProfileModel objPrivacyModel)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            SeedSpeak.Model.Privacy privacyAccount = new SeedSpeak.Model.Privacy();
            privacyAccount.viewUsername = objPrivacyModel.ViewUsername;
            privacyAccount.seedContribution = objPrivacyModel.seedContribution;
            privacyAccount.seedCommitment = objPrivacyModel.seedCommitment;
            privacyAccount.viewLocation = Convert.ToBoolean(objPrivacyModel.viewLocation);
            privacyAccount.webNotification = Convert.ToBoolean(objPrivacyModel.webNotification);
            privacyAccount.devicePush = Convert.ToBoolean(objPrivacyModel.devicePush);
            privacyAccount.emailNotification = Convert.ToBoolean(objPrivacyModel.emailNotification);            

            bool saved = objMember.ManageMemberPrivacy(memberData, privacyAccount);
            if (saved == true)
            {
                ViewData["PrivacyMsg"] = "<b>Privacy account saved succesfully.</b>";
            }
            else
            {
                ViewData["PrivacyMsg"] = "Problem saving privacy account.";
            }
            ViewData["SelectedIndex"] = 1;
            GetRegions();
            MyUsername(privacyAccount);
            SeedContributionMessage(privacyAccount);
            SeedCommitmentMessage(privacyAccount);
            GetExternalAccountList();
            GetExternalAccountList();
            GetProfileData();
            ViewData["LoggedInMember"] = memberData.id.ToString();
            return View("Profile");
            #endregion
        }

        [HttpPost]
        public ActionResult UpdateUserName(ProfileModel objNewEmail)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            Privacy privacyData = objMember.GetPrivacyByMemberId(memberData.id);
            string newemail = objNewEmail.NewEmail.ToString();
            bool updated = objMember.UpdateUserName(newemail, memberData.id.ToString());
            if (updated == true)
            {
                //send automated email 
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(memberData.firstName + " " + memberData.lastName);
                arrTokens.Add(newemail);

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = newemail;
                objSendMail.Subject = "email.member.usernameChange.subject.content";
                objSendMail.MsgBody = "email.member.usernameChange.body.content";
                objSendMail.ChangesInMessage = arrTokens;
                objSendMail.SendEmail(objSendMail);
                ViewData["UpdateLoginMsg"] = "<b>Username updated successfully.</b>";
            }
            else
            {
                ViewData["UpdateLoginMsg"] = "Error while updating username.";
            }
            ViewData["SelectedIndex"] = 2;
            GetRegions();
            MyUsername(privacyData);
            SeedContributionMessage(privacyData);
            SeedCommitmentMessage(privacyData);
            GetExternalAccountList();
            GetProfileData();
            ViewData["LoggedInMember"] = memberData.id.ToString();
            return View("Profile");
            #endregion
        }

        [HttpPost]
        public ActionResult UpdateOrganization(string newOrg)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            Privacy privacyData = objMember.GetPrivacyByMemberId(memberData.id);
            bool updated = objMember.UpdateOrganization(newOrg, memberData.id.ToString());
            if (updated == true)
            {
                ViewData["UpdateOrg"] = "<b>Organization updated successfully.</b>";
                memberData = objMember.GetMemberByMemberId(memberData.id.ToString());
                memberData.organisationName = newOrg;
                SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
            }
            else
            {
                ViewData["UpdateOrg"] = "Error while updating organization.";
            }
            ViewData["SelectedIndex"] = 2;
            GetRegions();
            MyUsername(privacyData);
            SeedContributionMessage(privacyData);
            SeedCommitmentMessage(privacyData);
            GetExternalAccountList();
            GetProfileData();
            ViewData["LoggedInMember"] = memberData.id.ToString();
            return View("Profile");
            #endregion
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UploadProfileImage(HttpPostedFileBase upProfileImage, string btnUpProfileImage, string x1, string y1, string x2, string y2, string w, string h)
        {
            #region
            MemberAction objMember = new MemberAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            Privacy privacyData = objMember.GetPrivacyByMemberId(memberData.id);

            if (btnUpProfileImage == null)
            {
                Session["ContentLength"] = null;
                Session["ContentType"] = null;
                Session["ContentStream"] = null;

                Session["ContentLength"] = Request.Files[0].ContentLength;
                Session["ContentType"] = Request.Files[0].ContentType;
                byte[] b = new byte[Request.Files[0].ContentLength];
                Request.Files[0].InputStream.Read(b, 0, Request.Files[0].ContentLength);
                Session["ContentStream"] = b;
                return Content(Request.Files[0].ContentType + ";" + Request.Files[0].ContentLength);
            }
            else
            {
                #region Code to upload profile image
                int X1 = Convert.ToInt32(x1);
                int Y1 = Convert.ToInt32(y1);
                int X2 = Convert.ToInt32(x2);
                int Y2 = Convert.ToInt32(y2);
                int X = System.Math.Min(X1, X2);
                int Y = System.Math.Min(Y1, Y2);
                int w1 = Convert.ToInt32(w);
                int h1 = Convert.ToInt32(h);
                // That can be any image type (jpg,jpeg,png,gif) from any where in the local server
                if (!Directory.Exists(Server.MapPath("~/jcrop/tempImage/")))
                {
                    Directory.CreateDirectory(Server.MapPath("~/jcrop/tempImage/"));
                }
                string OPath = Server.MapPath("~/jcrop/tempImage/");
                upProfileImage.SaveAs(OPath + "temp.png");
                string originalFile = Server.MapPath("~/jcrop/tempImage/") + "temp.png";

                using (Image img = Image.FromFile(originalFile))
                {
                    using (System.Drawing.Bitmap _bitmap = new System.Drawing.Bitmap(w1, h1))
                    {
                        _bitmap.SetResolution(img.HorizontalResolution, img.VerticalResolution);
                        using (Graphics _graphic = Graphics.FromImage(_bitmap))
                        {
                            _graphic.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                            _graphic.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                            _graphic.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
                            _graphic.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
                            _graphic.DrawImage(img, 0, 0, w1, h1);
                            _graphic.DrawImage(img, new Rectangle(0, 0, w1, h1), X, Y, w1, h1, GraphicsUnit.Pixel);

                            string extension = Path.GetExtension(originalFile);

                            string croppedFileName = memberData.id.ToString();

                            if (!Directory.Exists(Server.MapPath("~/UploadedMedia/")))
                            {
                                Directory.CreateDirectory(Server.MapPath("~/UploadedMedia/"));
                            }
                            string path = Server.MapPath("~/UploadedMedia/");

                            // If the image is a gif file, change it into png
                            if (extension.EndsWith("gif", StringComparison.OrdinalIgnoreCase))
                            {
                                extension = ".png";
                            }

                            string newFullPathName = string.Concat(path, croppedFileName, extension);

                            using (System.Drawing.Imaging.EncoderParameters encoderParameters = new System.Drawing.Imaging.EncoderParameters(1))
                            {
                                encoderParameters.Param[0] = new System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 100L);
                                _bitmap.Save(newFullPathName, GetImageCodec(extension), encoderParameters);
                            }
                            ViewData["CropImage"] = "~/UploadedMedia/" + croppedFileName + extension;
                            string upPath = "../../UploadedMedia/" + croppedFileName + extension;
                            bool isMediaSaved = SaveProfileImage(upPath);
                            if (isMediaSaved == true)
                            {
                                ViewData["ProfileImageMsg"] = "<b>Image has been uploaded successfully.</b>";
                                memberData = objMember.GetMemberByMemberId(memberData.id.ToString());
                                memberData.MemberProfiles.FirstOrDefault().imagePath = upPath;
                                SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
                            }
                        }
                    }
                }
                #endregion
            }
            ViewData["SelectedIndex"] = 0;
            GetRegions();
            MyUsername(privacyData);
            SeedContributionMessage(privacyData);
            SeedCommitmentMessage(privacyData);
            GetExternalAccountList();
            GetExternalAccountList();
            GetProfileData();
            ViewData["LoggedInMember"] = memberData.id.ToString();
            return View("Profile");
            #endregion
        }

        public static System.Drawing.Imaging.ImageCodecInfo GetImageCodec(string extension)
        {
            extension = extension.ToUpperInvariant();
            System.Drawing.Imaging.ImageCodecInfo[] codecs = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();
            foreach (System.Drawing.Imaging.ImageCodecInfo codec in codecs)
            {
                if (codec.FilenameExtension.Contains(extension))
                {
                    return codec;
                }
            }
            return codecs[1];
        }

        private bool CheckFileType(string file, int filesize)
        {
            bool isValidImage = false;
            string extension = "";
            if (file != null)
                extension = System.IO.Path.GetExtension(file);
            if (extension == ".jpg" || extension == ".png" || extension == ".gif")
            {
                //if (filesize < 1024)
                //{
                isValidImage = true;
                //}
            }
            return isValidImage;
        }

        private ImageFormat FileExtensionToImageFormat(String filePath)
        {
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
        }

        private bool SaveProfileImage(string path)
        {
            MemberAction objMember = new MemberAction();
            bool isInfoSaved = false;
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            isInfoSaved = objMember.UploadProfileImage(memberData, path);
            return isInfoSaved;
        }

        // *************************************
        // URL: /Member/VerifyAccount
        // *************************************
        public ActionResult VerifyAccount()
        {
            #region
            bool isVerified = false;
            MemberAction objMember = new MemberAction();
            if (Request.QueryString["id"] != null)
            {
                isVerified = objMember.VerifyAcount(Request.QueryString["id"].ToString());
                if (isVerified == true)
                {
                    ViewData["Verify"] = "Congratulations ! your account has been verified.";
                }
                else
                {
                    ModelState.AddModelError("", "Sorry, no account found associated with this userid.");
                }
            }
            else
            {
                ViewData["Verify"] = "No account found to verify.";
            }
            return View();
            #endregion
        }

        public ActionResult UserDetail(string id)
        {
            #region
            Member memData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memData != null)
            {
                if (Convert.ToString(memData.id) == id)
                    ViewData["ProfileView"] = "Self";
                else
                    ViewData["ProfileView"] = "Other";
            }
            MemberAction objMember = new MemberAction();
            Member memberData = objMember.GetMemberByMemberId(id);
            ViewData["MemberInfo"] = memberData;

            SeedAction objSeed = new SeedAction();
            IList<Seed> listSeed = objSeed.GetSeedsByUser(id).ToList();
            
            ViewData["ListSeed"] = listSeed;
            
            IList<Member> followerMemberList = objMember.GetFollowers(id);
            IList<Member> followingMemberList = objMember.GetFollowing(id);
            IList<Seed> seedList = objMember.GetFollowingActivity(id);
            ViewData["LatestActivity"] = seedList;
            ViewData["Following"] = followingMemberList;
            ViewData["Followers"] = followerMemberList;

            IList<Seed> FavSeeds = objSeed.GetAllFavouriteSeeds(id);
            ViewData["FavSeeds"] = FavSeeds;

            StreamAction objStream = new StreamAction();            
            IList<ssStream> lstFeeds = objStream.GetAllStreams(id);
            IList<ssStream> lstMyFeeds = lstFeeds.Where(x => x.streamType.Equals(SystemStatements.STREAM_FEED)).OrderByDescending(x => x.createDate).ToList();
            IList<ssStream> lstMyLists = lstFeeds.Where(x => x.streamType.Equals(SystemStatements.STREAM_HANDPICKED)).OrderByDescending(x => x.createDate).ToList();

            ViewData["UserFeeds"] = lstMyFeeds;
            ViewData["UserLists"] = lstMyLists;

            IList<Seed> LatestActivity = objMember.GetFollowingActivity(id);
            ViewData["LatestActivity"] = LatestActivity;

            string[] counts = new string[7];
            counts[0] = Convert.ToString(listSeed.Count());
            counts[1] = Convert.ToString(FavSeeds.Count());
            counts[2] = Convert.ToString(followerMemberList.Count());
            counts[3] = Convert.ToString(lstMyFeeds.Count());
            counts[4] = Convert.ToString(lstMyLists.Count());
            counts[5] = Convert.ToString(followingMemberList.Count());
            counts[6] = Convert.ToString(LatestActivity.Count());
            ViewData["Counts"] = counts;

            ViewData["ParentTabSelectedIndex"] = 0;
            ViewData["ChildTabSelectedIndex"] = 0;
            if (Request.QueryString["PlantedSeedsgridbox-page"] != null)
                ViewData["ParentTabSelectedIndex"] = 0;
            if (Request.QueryString["Likesgridbox-page"] != null)
                ViewData["ParentTabSelectedIndex"] = 1;
            if (Request.QueryString["gridboxFeeds-page"] != null)
                ViewData["ParentTabSelectedIndex"] = 3;
            if (Request.QueryString["gridboxLists-page"] != null)
                ViewData["ParentTabSelectedIndex"] = 4;
            if (Request.QueryString["Following-page"] != null)
            {
                ViewData["ParentTabSelectedIndex"] = 2;
                ViewData["ChildTabSelectedIndex"] = 0;
            }
            if (Request.QueryString["Followers-page"] != null)
            {
                ViewData["ParentTabSelectedIndex"] = 2;
                ViewData["ChildTabSelectedIndex"] = 1;
            }
            if (Request.QueryString["LatestActivitygridbox-page"] != null)
            {
                ViewData["ParentTabSelectedIndex"] = 2;
                ViewData["ChildTabSelectedIndex"] = 2;
            }

            return View();
            #endregion
        }

        public ActionResult ListSeed()
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (memberData == null)
                return RedirectToAction("Default", "Member");
            SeedAction objSeed = new SeedAction();
            LocationAction objLocation = new LocationAction();
            IList<Location> locData = objLocation.GetLocationByMemberId(memberData.id.ToString());

            List<Seed> currentSeedList = new List<Seed>();

            if (locData != null)
            {
                foreach (Location tempLocation in locData)
                {
                    IList<Seed> seedList = objSeed.GetSeedByLocationId(tempLocation.id.ToString());
                    foreach (Seed seedData in seedList)
                    {
                        if (seedData.status == SystemStatements.STATUS_NEW || seedData.status == SystemStatements.STATUS_GROWING)
                            currentSeedList.Add(seedData);
                    }
                }
            }

            ViewData["ListSeed"] = currentSeedList;

            return View();
            #endregion
        }

        public IList<Seed> getHomeSearchResult(string city, string catId, string keyword, string zip, string userName)
        {
            #region Logic
            IList<Seed> seedList = new List<Seed>();
            Repository repoObj = new Repository();
            SeedAction objSeed = new SeedAction();

            string searchString = "";
            if (catId != null && catId.Length > 0)
            {                
                searchString = "select distinct seed.* from seed, Seed_has_Category where (status='New' or status='Growing')";
            }
            else
            {
                searchString = "select distinct seed.* from seed where (status='New' or status='Growing')";
            }
            bool flag = false;

            #region Search in location table
            if ((!string.IsNullOrEmpty(city) && city != "Set Your location") || (!string.IsNullOrEmpty(zip) && zip != "Zipcode"))
            {
                searchString += " and locationid in ( select distinct(id) from location where ";
                if (city.Length > 0 && city != "City")
                {
                    if (!string.IsNullOrEmpty(zip))
                        searchString += "cityid in (select id from City where name = '" + city + "' )";
                    else
                        searchString += "cityid in (select id from City where name = '" + city + "' ))";
                    flag = true;
                }

                if (!string.IsNullOrEmpty(zip))
                {
                    if (zip.Length > 0 && zip != "Zipcode")
                    {
                        CommonMethods cmnMethod = new CommonMethods();
                        string zipResult = cmnMethod.GetZipByRadiusNew("25", zip);
                        if (flag)
                        {
                            searchString += " or ";
                        }

                        if (!string.IsNullOrEmpty(zipResult))
                        {
                            searchString = searchString.Substring(0, searchString.Length - 1);
                            searchString += " zipcode in (" + zipResult + "))";
                        }
                        else
                        {
                            searchString += " zipcode in (" + zip + "))";
                        }

                        flag = true;
                    }
                }
            }
            #endregion

            #region Search according to categories
            if (catId != null && catId.Length > 0)
            {
                if (!catId.Equals("all"))
                    searchString += " and Seed_has_Category.categoryId in (" + catId + ") and Seed.id=Seed_has_Category.seedId";
            }
            #endregion

            #region Search in username, firstname, lastname
            if (!string.IsNullOrEmpty(userName))
            {
                if (userName != "Search by user, category, keywords")
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

            #region Search in title or description
            if (!string.IsNullOrEmpty(keyword))
            {
                if (keyword.Length > 0 && keyword != "Search by user, category, keywords")
                {
                    searchString += " or (Seed.title like '%" + keyword + "%' or Seed.description like '%" + keyword + "%')";
                }
            }
            #endregion

            seedList = repoObj.ListPPP<Seed>("usp_SearchSeeds", searchString).ToList();
            IList<Seed> returnSeedList = (from s in seedList select s).Distinct().ToList();
            SessionStore.SetSessionValue(SessionStore.DefaultFeed, searchString);
            return returnSeedList;
            #endregion
        }

        public ActionResult SortDBData(string id)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            LocationAction objLocation = new LocationAction();
            Location memberLocation = objLocation.GetMemberLocationById(memberData.id.ToString());
            if (memberLocation == null)
            {
                memberLocation = new Location();
                memberLocation.localLong = SystemStatements.DEFAULT_Long;
                memberLocation.localLat = SystemStatements.DEFAULT_Lat;
            }
            ViewData["Memberlocation"] = memberLocation;

            IList<Seed> listSeed = null;
            if (SessionStore.GetSessionValue(SessionStore.MySeeds) != null)
                listSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.MySeeds);

            if (listSeed.Count > 0)
            {
                switch (id)
                {
                    case "Proximity":
                        //listSeed = ProximitySort();
                        //ViewData["StreamSeedList"] = listSeed;
                        break;
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
                        listSeed.OrderByDescending(x => x.Seed1.ToList().Count).ToList();
                        break;
                    default:
                        listSeed.OrderByDescending(x => x.createDate).ToList();
                        break;
                }
            }

            ViewData["ListSeed"] = listSeed;
            string markerList = "";
            foreach (Seed s1 in listSeed)
            {
                if (s1.Location.localLat != null && s1.Location.localLong != null)
                {
                    //if (string.IsNullOrEmpty(markerList))
                    //    markerList = s1.Location.localLat + "," + s1.Location.localLong;
                    //else
                    //    markerList += "," + s1.Location.localLat + "," + s1.Location.localLong;
                    markerList += s1.Location.localLat + "," + s1.Location.localLong + "," + s1.title + "-<b>" + s1.status + "</b> <br />" + s1.Location.City.name + " " + s1.Location.zipcode + ",";
                }
            }

            ViewData["LocationData"] = markerList;

            return View("Dashboard");
            #endregion
        }

        public ActionResult People(string id)
        {
            #region
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            IList<Member> followerMemberList = objMember.GetFollowers(memberData.id.ToString());
            IList<Member> followingMemberList = objMember.GetFollowing(memberData.id.ToString());
            IList<Seed> seedList = objMember.GetFollowingActivity(memberData.id.ToString());

            if (!string.IsNullOrEmpty(id))
            {
                if (id == "Proximity")
                    seedList = seedList.OrderByDescending(x => x.createDate).ToList();

                if (id == "Date")
                    seedList = seedList.OrderByDescending(x => x.createDate).ToList();

                if (id == "Category")
                    seedList = seedList.OrderByDescending(x => x.Categories.FirstOrDefault() != null ? x.Categories.FirstOrDefault().name : "").ToList();

                if (id == "Likes")
                    seedList = seedList.OrderByDescending(x => x.Ratings.ToList().Count).ToList();

                if (id == "Comments")
                    seedList = seedList.OrderByDescending(x => x.Comments.ToList().Count).ToList();
                
                if (id == "SeedReply")
                    seedList = seedList.OrderByDescending(x => x.Seed1.ToList().Count).ToList();
            }

            ViewData["LatestActivity"] = seedList;
            ViewData["Following"] = followingMemberList;
            ViewData["Followers"] = followerMemberList;
            return View();
            #endregion
        }

        public ActionResult NewestNearby(string id)
        {
            #region
            IList<Seed> lstSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.NearbySeeds);
            if (lstSeed != null)
            {
                if (lstSeed.Count() > 0)
                    ViewData["ListSeed"] = lstSeed;
                else
                {
                    lstSeed = getNewestNearby("15");
                    ViewData["ListSeed"] = lstSeed;
                }
            }
            else
            {
                lstSeed = getNewestNearby("15");
                ViewData["ListSeed"] = lstSeed;
            }

            if (!string.IsNullOrEmpty(id))
            {
                if (id == "Proximity")
                    ViewData["ListSeed"] = lstSeed.OrderByDescending(x => x.createDate).ToList();
                else if (id == "Date")
                    ViewData["ListSeed"] = lstSeed.OrderByDescending(x => x.createDate).ToList();
                else if (id == "Category")
                    ViewData["ListSeed"] = lstSeed.OrderBy(x => x.Categories.Count()).ToList();
                else if (id == "Likes")
                    ViewData["ListSeed"] = lstSeed.OrderByDescending(x => x.Ratings.Count()).ToList();
                else if (id == "Comments")
                    ViewData["ListSeed"] = lstSeed.OrderByDescending(x => x.Comments.Count()).ToList();
                else if (id == "Replies")
                    ViewData["ListSeed"] = lstSeed.OrderByDescending(x => x.Seed1.ToList().Count()).ToList();
                else
                    ViewData["ListSeed"] = lstSeed;
            }
            string[] DashCount = (string[])SessionStore.GetSessionValue(SessionStore.DashboardCount);
            DashCount[3] = lstSeed.Count().ToString();
            SessionStore.SetSessionValue(SessionStore.DashboardCount, DashCount);
            string ddlCount = (string)SessionStore.GetSessionValue(SessionStore.NearbyCount);
            if (!string.IsNullOrEmpty(ddlCount))
                ViewData["NewestNearbyRange"] = new SelectList(new[] { "15", "20", "25", "50" }, ddlCount);
            else
                ViewData["NewestNearbyRange"] = new SelectList(new[] { "15", "20", "25", "50" });

            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult NewestNearby(string milesRadius, string SeedsNoPerPage, string SortByExp)
        {
            #region
            IList<Seed> lstSeeds = null;
            if (!string.IsNullOrEmpty(SortByExp))
            {
                lstSeeds = getNewestNearby(milesRadius);
                if (SortByExp == "Proximity")
                    ViewData["ListSeed"] = lstSeeds.OrderByDescending(x => x.createDate).ToList();
                else if (SortByExp == "Date")
                    ViewData["ListSeed"] = lstSeeds.OrderByDescending(x => x.createDate).ToList();
                else if (SortByExp == "Category")
                    ViewData["ListSeed"] = lstSeeds.OrderBy(x => x.Categories.Count()).ToList();
                else if (SortByExp == "Likes")
                    ViewData["ListSeed"] = lstSeeds.OrderByDescending(x => x.Ratings.Count()).ToList();
                else if (SortByExp == "Comments")
                    ViewData["ListSeed"] = lstSeeds.OrderByDescending(x => x.Comments.Count()).ToList();
                else if (SortByExp == "Replies")
                    ViewData["ListSeed"] = lstSeeds.OrderByDescending(x => x.Seed1.ToList().Count()).ToList();
                else
                    ViewData["ListSeed"] = lstSeeds;
            }
            else
            {
                lstSeeds = getNewestNearby(milesRadius);
                ViewData["ListSeed"] = lstSeeds;
            }
            if (lstSeeds.Count() > 0)
                SessionStore.SetSessionValue(SessionStore.NearbySeeds, lstSeeds);

            string[] DashCount = (string[])SessionStore.GetSessionValue(SessionStore.DashboardCount);
            DashCount[3] = lstSeeds.Count().ToString();
            SessionStore.SetSessionValue(SessionStore.DashboardCount, DashCount);            
            SessionStore.SetSessionValue(SessionStore.NearbyCount, milesRadius);
            ViewData["NewestNearbyRange"] = new SelectList(new[] { "15", "20", "25", "50" }, milesRadius);
            return View();
            #endregion
        }

        public IList<Seed> getNewestNearby(string radius)
        {
            #region
            CommonMethods objCmnMethods = new CommonMethods();
            string strIpAddress = System.Web.HttpContext.Current.Request.UserHostAddress;
            if (strIpAddress == "127.0.0.1")
                strIpAddress = "61.246.241.162";

            string ipLocation = objCmnMethods.IP2AddressAPI(strIpAddress);
            string citySearch = string.Empty;
            string stateSearch = string.Empty;
            string zipCodeSearch = string.Empty;
            string latSearch = string.Empty;
            string lngSearch = string.Empty;
            string[] currentAddress;
            if (!string.IsNullOrEmpty(ipLocation))
            {
                //IPaddressAPI
                currentAddress = ipLocation.Split(',');

                if (string.IsNullOrEmpty(currentAddress[4].Replace("\"", "").ToString()))
                    stateSearch = "AZ";
                else
                    stateSearch = currentAddress[4].Replace("\"", "").ToString();

                if (string.IsNullOrEmpty(currentAddress[6].ToString()))
                    citySearch = "Phoenix";
                else
                    citySearch = currentAddress[6].Replace("\"", "").ToString();

                if (string.IsNullOrEmpty(currentAddress[7].Replace("\"", "").ToString()))
                    zipCodeSearch = "85027";
                else
                    zipCodeSearch = currentAddress[7].Replace("\"", "").ToString();

                latSearch = currentAddress[8].Replace("\"", "").ToString();
                lngSearch = currentAddress[9].Replace("\"", "").ToString();
            }
            else
            {
                //MaxMind
                ipLocation = objCmnMethods.IP2AddressMaxMind();
                currentAddress = ipLocation.Split('\'');

                if (string.IsNullOrEmpty(currentAddress[7].ToString()))
                    stateSearch = "AZ";
                else
                    stateSearch = currentAddress[7].ToString();

                if (string.IsNullOrEmpty(currentAddress[5].ToString()))
                    citySearch = "Phoenix";
                else
                    citySearch = currentAddress[5].ToString();

                if (string.IsNullOrEmpty(currentAddress[15].ToString()))
                    zipCodeSearch = "85027";
                else
                    zipCodeSearch = currentAddress[15].ToString();

                latSearch = currentAddress[11].ToString();
                lngSearch = currentAddress[13].ToString();
            }
            SeedAction objSeed = new SeedAction();
            IList<Seed> lstSeed = objSeed.GetAllSeedsByZip(radius, zipCodeSearch);
            return lstSeed.Where(x => (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();
            #endregion
        }

        public ActionResult TopPeople()
        {
            #region
            MemberAction objMember = new MemberAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            //Most Active            
            IList<Member> memberList = null;
            if (Request.QueryString["grdMostActive-page"] != null)
            {
                memberList = (IList<Member>)SessionStore.GetSessionValue(SessionStore.PeopleSearch);
                if (memberList != null && memberList.Count > 0)
                {
                    memberList = memberList.OrderByDescending(x => x.Seeds.Count()).ToList();
                }
            }
            else
            {
                memberList = objMember.GetAllMember();
                if (memberData != null)
                {
                    memberList = memberList.Where(x => x.id != memberData.id).OrderByDescending(x => x.Seeds.Count()).ToList();
                }
                else
                {
                    memberList = memberList.OrderByDescending(x => x.Seeds.Count()).ToList();
                }
                SessionStore.SetSessionValue(SessionStore.PeopleSearch, memberList);
            }
            ViewData["MostActive"] = memberList;

            //Nearby Users
            CommonMethods objCmnMethods = new CommonMethods();
            string strIpAddress = System.Web.HttpContext.Current.Request.UserHostAddress;
            if (strIpAddress == "127.0.0.1")
                strIpAddress = "61.246.241.162";

            string ipLocation = objCmnMethods.IP2AddressAPI(strIpAddress);
            string zipCodeSearch = string.Empty;
            string[] currentAddress;
            if (!string.IsNullOrEmpty(ipLocation))
            {
                //IPaddressAPI
                currentAddress = ipLocation.Split(',');

                if (string.IsNullOrEmpty(currentAddress[7].Replace("\"", "").ToString()))
                    zipCodeSearch = "85027";
                else
                    zipCodeSearch = currentAddress[7].Replace("\"", "").ToString();
            }
            else
            {
                //MaxMind
                ipLocation = objCmnMethods.IP2AddressMaxMind();
                currentAddress = ipLocation.Split('\'');

                if (string.IsNullOrEmpty(currentAddress[15].ToString()))
                    zipCodeSearch = "85027";
                else
                    zipCodeSearch = currentAddress[15].ToString();
            }
            IList<Member> lstMember = new List<Member>();
            if (memberData != null)
                lstMember = objMember.GetMembersByZip(zipCodeSearch).Where(x => x.id != memberData.id).ToList();
            else
                lstMember = objMember.GetMembersByZip(zipCodeSearch);
            ViewData["NearbyUsers"] = lstMember.Distinct().ToList();
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult TopPeople(string peopleSearch)
        {
            #region
            MemberAction objMember = new MemberAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            //Search User by name
            IList<Member> memberSearchList = objMember.GetMembersByName(peopleSearch);
            if (memberSearchList.Count > 0)
            {
                ViewData["MostActive"] = memberSearchList;
                SessionStore.SetSessionValue(SessionStore.PeopleSearch, memberSearchList);
            }
            else
            {
                //Most Active if search does not return result
                IList<Member> memberList = objMember.GetAllMember();
                if (memberData != null)
                {
                    memberList = memberList.Where(x => x.id != memberData.id).OrderByDescending(x => x.Seeds.Count()).ToList();
                }
                else
                {
                    memberList = memberList.OrderByDescending(x => x.Seeds.Count()).ToList();
                }
                ViewData["MostActive"] = memberList;
                ViewData["NoResult"] = "Your search did not return any result, showing most active users";
            }

            //Nearby Users
            CommonMethods objCmnMethods = new CommonMethods();
            string strIpAddress = System.Web.HttpContext.Current.Request.UserHostAddress;
            if (strIpAddress == "127.0.0.1")
                strIpAddress = "61.246.241.162";

            string ipLocation = objCmnMethods.IP2AddressAPI(strIpAddress);
            string zipCodeSearch = string.Empty;
            string[] currentAddress;
            if (!string.IsNullOrEmpty(ipLocation))
            {
                //IPaddressAPI
                currentAddress = ipLocation.Split(',');

                if (string.IsNullOrEmpty(currentAddress[7].Replace("\"", "").ToString()))
                    zipCodeSearch = "85027";
                else
                    zipCodeSearch = currentAddress[7].Replace("\"", "").ToString();
            }
            else
            {
                //MaxMind
                ipLocation = objCmnMethods.IP2AddressMaxMind();
                currentAddress = ipLocation.Split('\'');

                if (string.IsNullOrEmpty(currentAddress[15].ToString()))
                    zipCodeSearch = "85027";
                else
                    zipCodeSearch = currentAddress[15].ToString();
            }
            IList<Member> lstMember = new List<Member>();
            if (memberData != null)
                lstMember = objMember.GetMembersByZip(zipCodeSearch).Where(x => x.id != memberData.id).ToList();
            else
                lstMember = objMember.GetMembersByZip(zipCodeSearch);
            ViewData["NearbyUsers"] = lstMember.Distinct().ToList();
            return View();
            #endregion
        }

        public string FollowUnfollow(string followingId, string btnAction)
        {
            #region
            var output = string.Empty;
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            bool isDone = objMember.FollowOrUnFollowPeople(memberData.id.ToString(), followingId, btnAction);
            memberData = objMember.GetMemberByMemberId(memberData.id.ToString());
            SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            if (btnAction == "Follow" && isDone == true)
                output = serializer.Serialize("Unfollow");
            if (btnAction == "Unfollow" && isDone == true)
                output = serializer.Serialize("Follow");
            return output;
            #endregion
        }

        public string MuteUnMute(string muteId, string btnAction)
        {
            #region
            var output = string.Empty;
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            bool isDone = objMember.MuteOrUnMutePeople(memberData.id.ToString(), muteId, btnAction);
            memberData = objMember.GetMemberByMemberId(memberData.id.ToString());
            SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            if (btnAction == "Mute" && isDone == true)
                output = serializer.Serialize("Unmute");
            if (btnAction == "Unmute" && isDone == true)
                output = serializer.Serialize("Mute");
            return output;
            #endregion
        }

        public ActionResult BlockedUsers()
        {
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            MemberAction objMember = new MemberAction();
            IList<Member> memberList = objMember.GetMuteMembersByMemberId(memberData.id.ToString());

            return View();
        }

        public JsonResult CheckURL(string urlString)
        {
            MemberAction objMember = new MemberAction();
            bool isURLAvailable = objMember.FindByURL(urlString);
           
            if (isURLAvailable == true)
                return Json(false);
            return Json(true);
        }

        public ActionResult xd_receiver()
        {
            return View();
        }

        [HttpPost]
        public ActionResult FbLogin(string fbUserId, string fbUserName, string fbUserEmail, string fbUserPic)
        {
            #region check facebook login and sign up if a new user
            MemberAction objMember = new MemberAction();
            string fbUId = "fb_" + fbUserId;
            string[] fbUName = fbUserName.Split(' ');            
            Member memberData = objMember.GetMemberByUsername(fbUserEmail);
            if (memberData == null)
                memberData = objMember.GetMemberByFbEmail(fbUId);

            if (!string.IsNullOrEmpty(fbUserId))
            {
                if (memberData != null)
                {
                    SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
                    return RedirectToAction("Default", "Member");
                }
                else
                {
                    bool isRegistered = objMember.FBSignup(fbUserEmail, fbUName[0].ToString(), fbUName[1].ToString(), fbUId);
                    if (isRegistered == true)
                    {
                        memberData = objMember.GetMemberByFbEmail(fbUId);
                        if (memberData != null)
                        {
                            if (!string.IsNullOrEmpty(fbUserPic))
                                objMember.UploadProfileImage(memberData, fbUserPic);
                            SessionStore.SetSessionValue(SessionStore.Memberobject, memberData);
                            return RedirectToAction("Default", "Member");
                        }
                    }
                }
            }
            else
            {
                return RedirectToAction("Default", "Member");
            }
            return View();
            #endregion
        }

        public ActionResult Notifications()
        {
            return View();
        }
    }
}
