using System;
using System.Text;

namespace SeedSpeak.Util
{
    public class SystemStatements
    {
        public static string SECURITY_KEY = "JaR6y4pasP";
        public static string DEFAUL_EMAIL_ADDRESS = "";
        public static string SITE_NAME = "SeedSpeak";

        /**************** Status **************************/
        public static string STATUS_NEW = "New";
        public static string STATUS_ACTIVE = "Active";
        public static string STATUS_INACTIVE = "Inactive";
        public static string STATUS_GROWING = "Growing";
        public static string STATUS_HARVESTED = "Harvested";
        public static string STATUS_TERMINATED = "Terminated";

        /**************** Role ***************************/
        public static string ROLE_SUPER_ADMIN = "Super Admin";
        public static string ROLE_END_USER = "End User";

        /**************** Emails ************************/
        public static string EMAIL_SUBJECT_SIGNUP = "Thank You for Signing up with " + SystemStatements.SITE_NAME;

        /**************** Media Types ************************/
        public static string MEDIA_IMAGE = "Image";
        public static string MEDIA_VIDEO = "Video";
        public static string MEDIA_AUDIO = "Audio";

        /**************** Seeds Ratings ************************/
        public static string SEEDS_LIKE = "Like";
        public static string SEEDS_DISLIKE = "DLike";

        /**************** Default Long Lat ************************/
        public static double DEFAULT_Lat = 33.4483771;
        public static double DEFAULT_Long = -112.0740373;

        /**************** Stream ************************/
        //Stream Type
        public static string STREAM_FEED = "Feed";
        public static string STREAM_HANDPICKED = "HandList";
        //Stream Status
        public static string STREAM_ACTIVE = "Active";
        public static string STREAM_INACTIVE = "Inactive";

        /**************** Category ************************/
        public static string CATEGORY_ACTIVE = "Active";
        public static string CATEGORY_INACTIVE = "InActive";

        /**************** Follow/Mute ************************/
        public static string FOLLOW_PEOPLE = "Follow";
        public static string UNFOLLOW_PEOPLE = "Unfollow";
        public static string MUTE_PEOPLE = "Mute";
        public static string UNMUTE_PEOPLE = "Unmute";
    }
}
