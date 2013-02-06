using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SeedSpeak.Util
{
    public class SessionStore
    {
        /// <summary>
        /// This method is used to get session values.
        /// </summary>
        /// <param name="sessionName"></param>
        /// <returns></returns>
        /// 


        public const string Memberobject = "Memberobject";
        public const string Captcha = "Captcha";
        public const string SeedModel = "SeedModel";
        public const string DiscoverSeed = "DiscoverSeed";
        public const string FacebookLogout = "FacebookLogout";
        public const string SeedInfo = "SeedInfo";
        public const string CategoryId = "CategoryId";
        public const string FacebookConnect = "FacebookConnect";
        public const string SeedError = "SeedError";
        public const string DefaultFeed = "DefaultFeed";
        public const string StreamSeeds = "StreamSeeds";
        public const string MySeeds = "MySeeds";
        public const string NearbySeeds = "NearbySeeds";
        public const string SearchSeeds = "SearchSeeds";
        public const string DashboardCount = "DashboardCount";
        public const string PeopleSearch = "PeopleSearch";
        public const string GridViewName = "GridViewName";
        public const string SeedFlagged = "SeedFlagged";
        public const string NearbyCount = "NearbyCount";

        /// <summary>
        /// To get the session Value
        /// </summary>
        /// <param name="sessionName"></param>
        /// <returns></returns>
        public static object GetSessionValue(string sessionName)
        {
            if (HttpContext.Current.Session[sessionName] == null)
            {
                return null;
            }
            else
            {
                return HttpContext.Current.Session[sessionName];
            }
        }

        /// <summary>
        /// This methos is used to set session values.
        /// </summary>
        /// <param name="sessionName"></param>
        /// <param name="sessionValue"></param>
        public static void SetSessionValue(string sessionName, object sessionValue)
        {
            HttpContext.Current.Session[sessionName] = sessionValue;
        }

        /// <summary>
        /// This methos is used to clear session value.
        /// </summary>
        public static void ClearSessionValue()
        {
            HttpContext.Current.Session.Abandon();
            HttpContext.Current.Session.Clear();
        }
    }
}
