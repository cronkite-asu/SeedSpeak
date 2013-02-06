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

namespace SeedSpeak.Controllers
{
    public class UserProfileController : Controller
    {
        //
        // GET: /UserProfile/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ViewMyProfile(string username)
        {
            if (!string.IsNullOrEmpty(username))
            {
                MemberAction objMember = new MemberAction();
                string UserId = objMember.FindUserIdByURL(username);
                if (!string.IsNullOrEmpty(UserId))
                    Response.Redirect("/Member/UserDetail/" + UserId);
                else
                    return RedirectToAction("NotFound", "UserProfile");
            }
            else
            {
                return RedirectToAction("NotFound", "UserProfile");
            }
            return View();
        }

        public ActionResult NotFound()
        {
            return View();
        }
    }
}
