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

namespace SeedSpeak.Controllers
{
    public class CategoryController : Controller
    {
        //
        // GET: /Category/

        public ActionResult Index()
        {
            return View();
        }

        // *************************************
        // URL: /Category/ViewCategories
        // *************************************
        private void GetCategories()
        {
            CategoryAction objCatg = new CategoryAction();
            IList<Category> lstCategory = objCatg.GetAllCategories();
            ViewData["ListCategory"] = lstCategory;
        }

        public ActionResult AddEditCategory()
        {
            GetCategories();
            return View();
        }

        [HttpPost]
        public ActionResult InsertCategory(string name)
        {
            CategoryAction objCatg = new CategoryAction();
            Member memData = (Member) SessionStore.GetSessionValue(SessionStore.Memberobject);
            if (!string.IsNullOrEmpty(name))
            {
                string result = objCatg.AddCategory(name, memData.id.ToString());
                ViewData["Result"] = result;
                return RedirectToAction("AddEditCategory", "Category");
            }
            else
            {
                ViewData["Result"] = "Please enter category name";
            }
            GetCategories();
            return View("AddEditCategory");
        }

        [HttpPost]
        public ActionResult EditCategory(string id, string name)
        {
            CategoryAction objCatg = new CategoryAction();
            if (!string.IsNullOrEmpty(name))
            {
                objCatg.UpdateCategory(name, id);
                return RedirectToAction("AddEditCategory", "Category");
            }
            else
            {
                ViewData["Result"] = "Please enter category name";
            }
            GetCategories();
            return View("AddEditCategory");
        }

        public ActionResult ManageCategory()
        {
            CategoryAction objCatg = new CategoryAction();

            IList<Category> lstCategory = objCatg.GetAllCategories();

            for (int j = 0; j <= lstCategory.Count - 1; j++)
            {
                new Category() { id = lstCategory[j].id, name = lstCategory[j].name.ToString() };
            }

            var tList = new MultiSelectList(lstCategory, "id", "name");
            ViewData["CategoryList"] = tList;

            return View();
        }

        [HttpPost]
        public ActionResult ManageCategory(string[] Category)
        {
            CategoryAction objCatg = new CategoryAction();
            return View();
        }

        public ActionResult RequestCategory()
        {
            return View();
        }

        [HttpPost]
        public ActionResult RequestCategory(string CategoryName)
        {
            CategoryAction objCategory = new CategoryAction();
            Member memberData = (Member)SessionStore.GetSessionValue(SessionStore.Memberobject);
            string result = objCategory.RequestCategory(CategoryName, memberData.id.ToString());
            if (!string.IsNullOrEmpty(result))
                ViewData["RequestCategory"] = result;
            return View();
        }
    }
}
