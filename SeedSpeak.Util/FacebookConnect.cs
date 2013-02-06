using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Web;

namespace SeedSpeak.Util
{
    public class FacebookConnect
    {
        #region Constructors
        public FacebookConnect()
        {
        }
        #endregion

        #region Properties and Instance members
        public bool IsConnected
        {
            get
            {
                //Note that this can be insufficient in certain cases, such as when the user logs out of facebook in another window
                //at that point the session/access_token is invalid 
                return (SessionKey != null && UserID > 0);
            }
        }


        public string SessionKey
        {
            get
            {
                string sessionKey = GetFacebookCookieValue("session_key");
                return sessionKey;
            }
        }

        public long UserID
        {
            get
            {
                long userID = -1;
                string uid = GetFacebookCookieValue("uid");
                if (!string.IsNullOrEmpty(uid))
                {
                    uid = uid.Trim(new char[] { '"', '\\' });
                    long.TryParse(uid, out userID);
                }
                return userID;
            }
        }

        public string AccessToken
        {
            get
            {
                //NOTE: oddly enough the accesstoken key in the cookie is actually \"access_token
                string token = GetFacebookCookieValue("\"access_token");
                return token;
            }
        }
        #endregion

        #region Methods
        private string GetFacebookCookieValue(string cookieValue)
        {
            string cookieName = "fbs_" + ConfigurationManager.AppSettings["AppID"];
            string retString = null;
            HttpCookie c = HttpContext.Current.Request.Cookies[cookieName];
            if (HttpContext.Current.Request.Cookies[cookieName] != null)
                retString = HttpContext.Current.Request.Cookies[cookieName][cookieValue];

            return retString;
        }
        #endregion
    }
}
