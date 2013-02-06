using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SeedSpeak.Model.Validation;
using SeedSpeak.Model;
using SeedSpeak.Data.Repository;
using SeedSpeak.Util;

namespace SeedSpeak.BLL
{
    public class CategoryAction : AbstractAction
    {
        Repository repoObj = new Repository();

        /// <summary>
        /// Method to Add Category.
        /// </summary>
        /// <param name="CategoryName"></param>
        /// <param name="requestorID"></param>
        /// <returns></returns>
        public string AddCategory(string CategoryName, string requestorID)
        {
            #region Business Logic

            string updated = "Unable to add category";
            try
            {
                Category objCategory = repoObj.List<Category>(x => x.name.Equals(CategoryName)).FirstOrDefault();
                if (objCategory == null)
                {
                    objCategory = new Category();

                    objCategory.id = Guid.NewGuid();

                    objCategory.name = CategoryName;
                    objCategory.status = SystemStatements.STATUS_ACTIVE;
                    objCategory.requestedById = new Guid(requestorID);
                    repoObj.Create<Category>(objCategory);
                    updated = "Category has been added successfully";
                }
                else
                {
                    updated = "Category already exist";
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to update category
        /// </summary>
        /// <param name="CategoryName"></param>
        /// <param name="Status"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool UpdateCategory(string CategoryName, string id)
        {
            #region Business Logic
            bool updated = false;
            try
            {
                Category objCategory = repoObj.List<Category>(x => x.id.Equals(new Guid(id))).FirstOrDefault();

                if (objCategory != null)
                {
                    objCategory.name = CategoryName;
                    repoObj.Update<Category>(objCategory);
                    updated = true;
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to get all categories.
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public IList<Category> GetAllCategories()
        {
            #region Business Logic
            return repoObj.List<Category>(x => x.status.Equals(SystemStatements.STATUS_ACTIVE)).OrderBy(x => x.name).ToList();
            #endregion
        }

        /// <summary>
        /// Method to get categories by name
        /// </summary>
        /// <param name="Cname"></param>
        /// <returns></returns>
        public IList<Category> GetAllCategoriesByName(string Cname)
        {
            #region Business Logic
            return repoObj.List<Category>(x => x.status.Equals(SystemStatements.STATUS_ACTIVE) && x.name.StartsWith(Cname)).ToList();
            #endregion
        }

        /// <summary>
        /// Method to get Category id by Category name.
        /// </summary>
        /// <param name="CategoryName"></param>
        /// <returns></returns>
        public string GetCategoryIdByCategoryName(string CategoryName)
        {
            #region Business Logic
                string CategoryId = "";
                Category objCategory = repoObj.List<Category>(x => x.name.Equals(CategoryName)).FirstOrDefault();
                if (objCategory != null)
                {
                    CategoryId = objCategory.id.ToString();
                }

                return CategoryId;
            #endregion
        }        

        /// <summary>
        /// Method to Request New Category.
        /// </summary>
        /// <param name="CategoryName"></param>
        /// <param name="requestorID"></param>
        /// <returns></returns>
        public string RequestCategory(string CategoryName, string requestorID)
        {
            #region Business Logic

            string updated = "Unable to add category";
            try
            {
                Category objCategory = repoObj.List<Category>(x => x.name.Equals(CategoryName)).FirstOrDefault();
                if (objCategory == null)
                {
                    objCategory = new Category();
                    objCategory.id = Guid.NewGuid();
                    objCategory.name = CategoryName;
                    objCategory.status = SystemStatements.STATUS_INACTIVE;
                    objCategory.requestedById = new Guid(requestorID);
                    repoObj.Create<Category>(objCategory);
                    updated = "New category request submitted successfully";
                }
                else
                {
                    updated = "Category you requested already exist";
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to get category by id
        /// </summary>
        /// <param name="Cid"></param>
        /// <returns></returns>
        public Category GetCategoryById(string Cid)
        {
            #region Business Logic
            return repoObj.List<Category>(x => x.status.Equals(SystemStatements.STATUS_ACTIVE) && x.id == new Guid(Cid)).FirstOrDefault();
            #endregion
        }
    }
}
