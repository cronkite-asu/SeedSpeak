using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
//using Jsree.Models.External;
//using Jsree.BLL;
//using Jsree.Models;
//using Jsree.Utils;

namespace SeedSpeak.Util
{
    public class ConnectService : LogBase
    {

        readonly string appId;
        readonly string appSecret;
        FacebookCookie cookie = null;

        public ConnectService()
        {
            appId = ConfigurationManager.AppSettings["FacebookAppId"];
            appSecret = ConfigurationManager.AppSettings["FacebookAppSecret"];
        }

        #region 

        private bool IsConnected()
        {
            if (cookie == null)
            {
                cookie = FacebookCookie.GetCookie(appId, appSecret);
            }
            /*logger.Info("_________________________________________");
            logger.Info("cookie = " + cookie + " UserId = " + cookie.UserId + " sessionkey = " + cookie.SessionKey);*/
            return
                cookie != null &&
                cookie.UserId != 0 &&
                !string.IsNullOrEmpty(cookie.SessionKey);
        }

        public string SessionKey
        {
            get
            {
                if (cookie != null)
                {
                    return cookie.SessionKey;
                }
                else
                {
                    return null;
                }
            }
        }

        public long UserId
        {
            get
            {
                if (cookie != null)
                {
                    return cookie.UserId;
                }
                else
                {
                    return 0;
                }
            }
        }

        public string AccessToken
        {
            get
            {
                if (cookie != null)
                {
                    return cookie.AccessToken;
                }
                else
                {
                    return null;
                }
            }
        }

        #endregion

    }
}