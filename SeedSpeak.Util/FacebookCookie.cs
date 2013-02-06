/**
 * Thanks for this code to http://www.atlasbay.com/2010/04/21/new-facebook-connect-in-csharp/
 * */



using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections.Specialized;
using System.Text;

namespace SeedSpeak.Util
{
    public class FacebookCookie
    {

        private FacebookCookie()
        {
        }

        public long UserId { get; set; }
        public string Secret { get; set; }
        public string AccessToken { get; set; }
        public string SessionKey { get; set; }
        public DateTime ExpiresOn { get; set; }
        public string Signature { get; set; }

        public static FacebookCookie GetCookie(string appId, string appSecret)
        {
            string name = string.Format("fbs_{0}", appId); // Cookie Name

            // Test if key exists
            if (HttpContext.Current == null
                || HttpContext.Current.Request == null
                || HttpContext.Current.Request.Cookies == null
                || !HttpContext.Current.Request.Cookies.AllKeys.Contains(name))
            {
                return null;
            }
            var httpCookie = HttpContext.Current.Request.Cookies[name];
            return FacebookCookie.Parse(httpCookie.Value, appSecret);
        }

        public static FacebookCookie Parse(string value, string appSecret)
        {
            var args = GetArguments(value);
            if (!FacebookCookie.Validate(args, appSecret))
            {
                throw new Exception("Invalid cookie.");
            }

            var cookie = new FacebookCookie();

            DateTime expires;
            DateTime.TryParse(args["expires"], out expires);
            cookie.ExpiresOn = expires;

            long userId;
            long.TryParse(args["uid"], out userId);
            cookie.UserId = userId;

            cookie.Secret = args["secret"];
            cookie.SessionKey = args["session_key"];
            cookie.Signature = args["sig"];
            cookie.AccessToken = args["access_token"];

            return cookie;
        }

        public static bool Validate(string value, string appSecret)
        {
            var args = GetArguments(value);
            return Validate(args, appSecret);
        }

        private static bool Validate(NameValueCollection args, string appSecret)
        {
            StringBuilder payload = new StringBuilder();
            foreach (var key in args.AllKeys)
            {
                if (key != "sig")
                {
                    payload.AppendFormat("{0}={1}", key, args[key]);
                }
            }
            payload.Append(appSecret);
            var md5 = System.Security.Cryptography.MD5CryptoServiceProvider.Create();
            var hash = md5.ComputeHash(Encoding.ASCII.GetBytes(payload.ToString()));
            StringBuilder signature = new StringBuilder();
            for (int i = 0; i < hash.Length; i++)
            {
                signature.Append(hash[i].ToString("X2"));
            }
            return args["sig"] == signature.ToString().ToLower();
        }

        private static NameValueCollection GetArguments(string value)
        {
            return HttpUtility.ParseQueryString(value.Replace("\"", string.Empty));
        }
    }
}