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

namespace SeedSpeak.Controllers
{
    public class AdminController : Controller
    {
        //
        // GET: /Admin/

        public ActionResult Index()
        {
            return View();
        }

        // *************************************
        // URL: /Admin/ManageSeeds
        // *************************************
        public ActionResult ManageSeeds()
        {
            GetActiveSeeds();
            GetFlagSeeds();
            GetDyingSeeds();
            GetHarvestedSeeds();
            GetTerminatedSeeds();
            return View();
        }

        private void GetActiveSeeds()
        {
            SeedAction objSeed = new SeedAction();
            IList<Seed> ListActiveSeeds = objSeed.GetSeedsByTwoStatus(SystemStatements.STATUS_NEW, SystemStatements.STATUS_GROWING);
            ViewData["ActiveSeeds"] = ListActiveSeeds;
        }

        private void GetFlagSeeds()
        {
            SeedAction objSeed = new SeedAction();
            IList<Seed> ListFlagSeeds = objSeed.GetFlaggedSeeds();
            ViewData["FlagSeeds"] = ListFlagSeeds;
        }

        private void GetDyingSeeds()
        {
            SeedAction objSeed = new SeedAction();
            IList<Seed> ListDyingSeeds = objSeed.GetAllDyingSeeds();
            ViewData["DyingSeeds"] = ListDyingSeeds;
        }

        private void GetHarvestedSeeds()
        {
            SeedAction objSeed = new SeedAction();
            IList<Seed> ListHarvestedSeeds = objSeed.GetSeedsByStatus(SystemStatements.STATUS_HARVESTED);
            ViewData["HarvestedSeeds"] = ListHarvestedSeeds;
        }

        private void GetTerminatedSeeds()
        {
            SeedAction objSeed = new SeedAction();
            IList<Seed> ListTerminatedSeeds = objSeed.GetSeedsByStatus(SystemStatements.STATUS_TERMINATED);
            ViewData["TerminatedSeeds"] = ListTerminatedSeeds;
        }

        // *************************************
        // URL: /Admin/PolishContent
        // *************************************
        public ActionResult PolishContent()
        {
            GetImageList();
            GetMediaList();
            return View();
        }

        private void GetImageList()
        {
            MediaAction objMedia = new MediaAction();
            IList<Medium> ImageList = objMedia.GetMediaListByMediaType(SystemStatements.MEDIA_IMAGE);
            ViewData["ImageList"] = ImageList;
        }

        private void GetMediaList()
        {
            MediaAction objMedia = new MediaAction();
            IList<Medium> MediaList = objMedia.GetMediaListByMediaType(SystemStatements.MEDIA_VIDEO);
            ViewData["MediaList"] = MediaList;
        }

        public void DeleteMedia(string id)
        {
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
            Response.Redirect("/Admin/PolishContent/");
        }

        // *************************************
        // URL: /Admin/ManageUser
        // *************************************
        private void GetAllMemberList()
        {
            MemberAction objMember = new MemberAction();
            IList<Member> lstMember = objMember.GetAllMember().ToList();
            ViewData["MemberList"] = lstMember;
        }

        public ActionResult ManageUser()
        {
            GetAllMemberList();
            return View();
        }

        public ActionResult MailNewPassword(string id)
        {
            MemberAction objMember = new MemberAction();
            Member member = objMember.GetMemberByMemberId(id);
            string newPwd = GenerateRandomString();
            member.passwd = Security.Encrypt(newPwd, true);
            if (objMember.UpdateMember(member))
            {
                //send automated email
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(member.firstName + " " + member.lastName);
                arrTokens.Add("admin@seedspeak.com");
                arrTokens.Add(newPwd);

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = member.username;
                objSendMail.Subject = "email.newPasswordGenerate.subject.content";
                objSendMail.MsgBody = "email.newPasswordGenerate.body.content";
                objSendMail.ChangesInMessage = arrTokens;

                objSendMail.SendEmail(objSendMail);
                ViewData["ManageUser"] = "<b>New password has been sent to " + member.firstName + " " + member.lastName + "</b>";
            }
            else
            {
                ViewData["ManageUser"] = "Problem occured while sending new password";
            }
            GetAllMemberList();
            return View("ManageUser");
        }

        public string GenerateRandomString()
        {
            string[] chars = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S",
                        "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" };

            Random rnd = new Random();
            string random = string.Empty;
            for (int i = 0; i < 6; i++)
            {
                random += chars[rnd.Next(0, 33)];
            }
            return random;
        }

        public ActionResult ActiveInactiveMember(string id)
        {
            MemberAction objMember = new MemberAction();
            Member member = objMember.GetMemberByMemberId(id);
            if (member != null)
            {
                if (member.status == SystemStatements.STATUS_ACTIVE)
                {
                    member.status = SystemStatements.STATUS_INACTIVE;
                }
                else
                {
                    member.status = SystemStatements.STATUS_ACTIVE;
                }
            }
            if (objMember.UpdateMember(member))
            {
                ViewData["ManageUser"] = "<b>Status has been changed successfully</b>";
            }
            else
            {
                ViewData["ManageUser"] = "Problem occured while updating status";
            }
            GetAllMemberList();
            return View("ManageUser");
        }

        public ActionResult AdminDashboard()
        {
            return View();
        }

        public void unFlagSeed(string id)
        {
            bool isCompleted = false;
            SeedAction objSeed = new SeedAction();
            isCompleted = objSeed.unFlagSeed(id);
            if (isCompleted == true)
                Response.Redirect("/Admin/ManageSeeds");
        }

        public void TerminateSeed(string id)
        {
            bool isCompleted = false;
            SeedAction objSeed = new SeedAction();
            isCompleted = objSeed.HarvestTerminateSeed(id, "Terminate");
            if (isCompleted == true)
                Response.Redirect("/Admin/ManageSeeds");
        }

        // *************************************
        // URL: /Admin/ManageContent
        // *************************************        
        public ActionResult ManageContent()
        {
            ViewData["index"] = 0;
            GetContent();
            return View();
        }

        public void GetContent()
        {
            ContentAction objContent = new ContentAction();
            Content mngContent = objContent.GetContentByType("AboutUs");
            if (mngContent != null)
                ViewData["AboutUs"] = mngContent.Value1;

            mngContent = objContent.GetContentByType("News");
            if (mngContent != null)
                ViewData["News"] = mngContent.Value1;

            mngContent = objContent.GetContentByType("Contact");
            if (mngContent != null)
                ViewData["Contact"] = mngContent.Value1;

            IList<Content> mngFAQ = objContent.GetFAQ();
            if (mngFAQ != null)
                ViewData["FAQs"] = mngFAQ;
        }

        [HttpPost]
        public ActionResult ManageContent(string aboutText, string newsText, string contactText)
        {
            ContentAction objContent = new ContentAction();
            bool isCompleted = false;
            if (!string.IsNullOrEmpty(aboutText))
            {
                isCompleted = objContent.ManageContent("AboutUs", aboutText);
                ViewData["index"] = 1;
            }

            if (!string.IsNullOrEmpty(newsText))
            {
                isCompleted = objContent.ManageContent("News", newsText);
                ViewData["index"] = 2;
            }

            if (!string.IsNullOrEmpty(contactText))
            {
                isCompleted = objContent.ManageContent("Contact", contactText);
                ViewData["index"] = 3;
            }

            GetContent();
            return View();
        }


        [HttpPost]
        public ActionResult EditContent(Guid id, string Value1, string Value2)
        {
            ContentAction objContent = new ContentAction();
            if (!string.IsNullOrEmpty(Value1) && !string.IsNullOrEmpty(Value2))
            {
                if (objContent.ManageFAQs(id, Value1, Value2))
                    Response.Redirect("/Admin/ManageContent/" + id + "?Grid-mode=update");
                else
                    ViewData["Result"] = "Error in Update.";
            }
            else
            {
                ViewData["Result"] = "Please enter question/answer";
                GetContent();
            }
            ViewData["index"] = 0;
            return View("ManageContent");
        }
    }
}
