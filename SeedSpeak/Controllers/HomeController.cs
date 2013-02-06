using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SeedSpeak.BLL;
using SeedSpeak.Data;
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
using System.Configuration;
using SeedSpeak.Data.Repository;
using System.Text.RegularExpressions;

namespace SeedSpeak.Controllers
{
    [HandleError]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [MvcReCaptcha.CaptchaValidator]
        [HttpPost]
        public ActionResult Index(bool captchaValid)
        {
            if (!captchaValid)
            {
                ModelState.AddModelError("", "You did not type the verification word correctly. Please try again.");
            }
            else
            {
                ModelState.AddModelError("", "Valid");
            }
            return View();

        }

        public ActionResult About()
        {
            ContentAction objContent = new ContentAction();
            Content aboutContent = objContent.GetContentByType("AboutUs");
            ViewData["AboutContent"] = aboutContent != null ? aboutContent.Value1 : "Page is under construction, please visit again";
            return View();
        }

        public ActionResult WatchDemo()
        {
            return View();
        }

        public ActionResult FAQ()
        {
            ContentAction objContent = new ContentAction();
            IList<Content> faqContent = objContent.GetFAQ();
            ViewData["FAQContent"] = faqContent;
            return View();
        }

        public ActionResult News()
        {
            ContentAction objContent = new ContentAction();
            Content newsContent = objContent.GetContentByType("News");
            ViewData["NewsContent"] = newsContent != null ? newsContent.Value1 : "Page is under construction, please visit again";
            return View();
        }

        public ActionResult Contact()
        {
            ContentAction objContent = new ContentAction();
            Content contactContent = objContent.GetContentByType("Contact");
            ViewData["ContactContent"] = contactContent != null ? contactContent.Value1 : "Page is under construction, please visit again";
            return View();
        }

        [HttpPost]
        public ActionResult Contact(string Name, string Phone, string Email, string Address, string Company, string Comments)
        {
            #region
            //send automated email - content of email will be decided later

            // Creating array list for token 
            ArrayList arrTokens = new ArrayList();
            arrTokens.Add(Name);
            if (!string.IsNullOrEmpty(Phone))
                arrTokens.Add(Phone);
            else
                arrTokens.Add("Not Applicable");
            arrTokens.Add(Email);
            arrTokens.Add(Address);
            if (!string.IsNullOrEmpty(Company))
                arrTokens.Add(Company);
            else
                arrTokens.Add("Not Applicable");
            arrTokens.Add(Comments);

            // Filling mail object
            SendMail objSendMail = new SendMail();
            objSendMail.ToEmailId = System.Configuration.ConfigurationManager.AppSettings["AdminMail"].ToString();
            objSendMail.Subject = "email.contactUs.subject.content";
            objSendMail.MsgBody = "email.contactUs.body.content";
            objSendMail.ChangesInMessage = arrTokens;
            objSendMail.SendEmail(objSendMail);
            ViewData["ContactInfo"] = "Thank you for sharing your contact information";

            ContentAction objContent = new ContentAction();
            Content contactContent = objContent.GetContentByType("Contact");
            ViewData["ContactContent"] = contactContent != null ? contactContent.Value1 : "Page is under construction, please visit again";

            return View();
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

        public ActionResult Streams()
        {
            #region
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

            StreamAction objStream = new StreamAction();
            IList<ssStream> streamData = new List<ssStream>();
            streamData = objStream.GetAllStreamByZip(zipCodeSearch);

            if (streamData.Count() < 1)
                streamData = objStream.GetLatestStreams();

            streamData = streamData.Distinct().ToList();
            ViewData["SearchStream"] = streamData;

            IList<ssStream> latestStreams = new List<ssStream>();
            latestStreams = objStream.GetLatestStreams();
            ViewData["LatestStreams"] = latestStreams;

            IList<ssStream> mostPopularStreams = new List<ssStream>();
            mostPopularStreams = objStream.GetMostPopularStreams();
            ViewData["MostPopular"] = mostPopularStreams;

            ViewData["SearchTerm"] = "Nearby Feeds";            
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult Streams(string streamSearch)
        {
            #region
            StreamAction objStream = new StreamAction();
            IList<ssStream> streamData = new List<ssStream>();
            IList<ssStream> tmpStreamList = null;

            string searchOthers = "";
            string searchZip = "";
            string[] criteriaArr = streamSearch.Trim().Split(',');

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
                tmpStreamList = objStream.GetAllStreamByZip(searchZip);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }
            }

            if (searchOthers.Length > 0)
            {
                tmpStreamList = objStream.GetAllStreamsByTitle(searchOthers);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }

                tmpStreamList = objStream.GetAllStreamsByDescription(searchOthers);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }


                tmpStreamList = objStream.GetStreamByCrossStreet(searchOthers);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }

                tmpStreamList = objStream.GetStreamByCity(searchOthers);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }
            }
            streamData = streamData.Distinct().ToList();
            ViewData["SearchStream"] = streamData;

            IList<ssStream> latestStreams = new List<ssStream>();
            latestStreams = objStream.GetLatestStreams();
            ViewData["LatestStreams"] = latestStreams;

            IList<ssStream> mostPopularStreams = new List<ssStream>();
            mostPopularStreams = objStream.GetMostPopularStreams();
            ViewData["MostPopular"] = mostPopularStreams;

            ViewData["SearchTerm"] = streamSearch;
            return View();
            #endregion
        }

        public ActionResult Feeds()
        {
            #region
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

            StreamAction objStream = new StreamAction();
            IList<ssStream> streamData = new List<ssStream>();
            streamData = objStream.GetAllStreamByZip(zipCodeSearch);

            if (streamData.Count() < 1)
                streamData = objStream.GetLatestStreams();

            streamData = streamData.Distinct().ToList();
            ViewData["SearchStream"] = streamData;

            IList<ssStream> latestStreams = new List<ssStream>();
            latestStreams = objStream.GetLatestStreams();
            ViewData["LatestStreams"] = latestStreams;

            IList<ssStream> mostPopularStreams = new List<ssStream>();
            mostPopularStreams = objStream.GetMostPopularStreams();
            ViewData["MostPopular"] = mostPopularStreams;

            ViewData["SearchTerm"] = "Nearby Feeds";
            
            return View();
            #endregion
        }

        [HttpPost]
        public ActionResult Feeds(string feedSearch)
        {
            #region
            StreamAction objStream = new StreamAction();
            IList<ssStream> streamData = new List<ssStream>();
            IList<ssStream> tmpStreamList = null;

            string searchOthers = "";
            string searchZip = "";
            string[] criteriaArr = feedSearch.Trim().Split(',');

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
                tmpStreamList = objStream.GetAllStreamByZip(searchZip);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }
            }

            if (searchOthers.Length > 0)
            {
                tmpStreamList = objStream.GetAllStreamsByTitle(searchOthers);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }

                tmpStreamList = objStream.GetAllStreamsByDescription(searchOthers);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }


                tmpStreamList = objStream.GetStreamByCrossStreet(searchOthers);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }

                tmpStreamList = objStream.GetStreamByCity(searchOthers);
                foreach (ssStream ssData in tmpStreamList)
                {
                    streamData.Add(ssData);
                }
            }
            streamData = streamData.Distinct().ToList();
            ViewData["SearchStream"] = streamData;

            IList<ssStream> latestStreams = new List<ssStream>();
            latestStreams = objStream.GetLatestStreams();
            ViewData["LatestStreams"] = latestStreams;

            IList<ssStream> mostPopularStreams = new List<ssStream>();
            mostPopularStreams = objStream.GetMostPopularStreams();
            ViewData["MostPopular"] = mostPopularStreams;

            ViewData["SearchTerm"] = feedSearch;

            return View();
            #endregion
        }

        public ActionResult Team()
        {
            return View();
        }

        public ActionResult HowItWorks()
        {
            return View();
        }

        public ActionResult SearchSeeds()
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

            IList<Seed> lstSeed = null;
            if (SessionStore.GetSessionValue(SessionStore.SearchSeeds) != null)
                lstSeed = (IList<Seed>)SessionStore.GetSessionValue(SessionStore.SearchSeeds);            

            foreach (Seed sd in lstSeed)
            {
                sd.seedDistance = (int)objCmnMethods.distance(Convert.ToDouble(latSearch), Convert.ToDouble(lngSearch), Convert.ToDouble(sd.Location.localLat), Convert.ToDouble(sd.Location.localLong));
            }
            ViewData["SearchSeeds"] = lstSeed;
            return View();
            #endregion
        }
    }
}
