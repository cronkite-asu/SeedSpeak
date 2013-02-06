using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SeedSpeak.Model.Validation;
using SeedSpeak.Model;
using SeedSpeak.Data.Repository;
using SeedSpeak.Util;
using System.Collections;
using System.Data;
//using System.Data.Objects;

namespace SeedSpeak.BLL
{
    public class SeedAction : AbstractAction
    {
        Repository repoObj = new Repository();        

        /// <summary>
        /// Method to get seeds by location Id.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetSeedByLocationId(string locationId)
        {
            #region Business Logic
            IList<Seed> seedData = null;
            try
            {
                if (locationId.Trim().Length > 0)
                {
                    seedData = repoObj.List<Seed>(x => x.Location.id.Equals(new Guid(locationId)) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get seed reply count
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetReplySeedCount(string id)
        {
            #region Business Logic
            IList<Seed> seedData = null;
            try
            {
                seedData = repoObj.List<Seed>(x => x.parentSeedID == new Guid(id)).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData.Count().ToString();
            #endregion
        }

        /// <summary>
        /// Method to get seed reply count by owner id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetReplySeedCountbyOwnerId(string ownerId)
        {
            #region Business Logic
            IList<Seed> seedData = null;
            try
            {
                seedData = repoObj.List<Seed>(x => x.ownerId == new Guid(ownerId) && x.parentSeedID != null).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData.Count().ToString();
            #endregion
        }

        /// <summary>
        /// Method to get seeds by crossStreet.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetSeedByCrossStreet(string cStreet)
        {
            #region Business Logic

            IList<Seed> seedData = null;

            try
            {
                if (cStreet.Trim().Length > 0)
                {
                    seedData = repoObj.List<Seed>(x => x.Location.crossStreet.Equals(cStreet)).ToList();
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get seeds by crossStreet.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetSeedByCity(string cityName)
        {
            #region Business Logic

            IList<Seed> seedData = new List<Seed>();
            IList<Seed> tmpSeedList = null;
            try
            {
                if (cityName.Trim().Length > 0)
                {
                    IList<City> cityData = repoObj.List<City>(x => x.name.Equals(cityName)).ToList();
                    if (cityData != null)
                    {
                        foreach (City cData in cityData)
                        {
                            tmpSeedList = repoObj.List<Seed>(x => x.Location.City.id.Equals(cData.id)).ToList();
                            foreach (Seed sData in tmpSeedList)
                            {
                                seedData.Add(sData);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to search seeds.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public List<Seed> GetAllSeedsByLocation(IList<Location> locationIds)
        {
            #region Business Logic

            IList<Seed> tempSeedData = null;
            List<Seed> seedData = new List<Seed>();

            try
            {
                foreach (Location lData in locationIds)
                {
                    tempSeedData = repoObj.List<Seed>(x => x.Location.id.Equals(lData.id) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();
                  
                    foreach(Seed sData in tempSeedData)
                    {
                        seedData.Add(sData);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to search seeds.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public List<Seed> GetAllSeedsByCategory(string categoryId)
        {
            #region Business Logic
           
            List<Seed> seedList = new List<Seed>();

            IList<Seed> tempSeedList = null;

            try
            {

                tempSeedList = repoObj.List<Seed>(x => x.Categories.Count > 0 && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();
               
                foreach (Seed seedData in tempSeedList)
                {
                    foreach (Category catData in seedData.Categories)
                    {
                        if (catData.id.ToString().ToUpper().Equals(categoryId.ToUpper()))
                                seedList.Add(seedData);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedList;
            #endregion
        }

        /// <summary>
        /// Filter seeds from existing list
        /// </summary>
        /// <param name="tempSeedList"></param>
        /// <param name="categoryId"></param>
        /// <returns></returns>
        public List<Seed> FilterSeedsByCategory(List<Seed> tempSeedList, string categoryId)
        {
            #region Business Logic

            List<Seed> seedList = new List<Seed>();

            try
            {
                foreach (Seed seedData in tempSeedList)
                {
                    foreach (Category catData in seedData.Categories)
                    {
                        if (catData.id.ToString().ToUpper().Equals(categoryId.ToUpper()))
                            seedList.Add(seedData);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedList;
            #endregion
        }

        /// <summary>
        /// Method to search seeds.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsByDescription(string description)
        {
            #region Business Logic

            IList<Seed> seedData = null;

            try
            {
                seedData = repoObj.List<Seed>(x => x.description.Contains(description) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to search seeds.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsByTitle(string title)
        {
            #region Business Logic

            IList<Seed> seedData = null;
 
            try
            {
                seedData = repoObj.List<Seed>(x => x.title.Contains(title) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get list of seeds by tag
        /// </summary>
        /// <param name="title"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsByTag(string title)
        {
            #region Business Logic

            IList<Seed> seedData = new List<Seed>();

            IList<Tag> tagData = null;
            
            try
            {
                tagData = repoObj.List<Tag>(x => x.name.Contains(title),"seed").ToList();

                foreach (Tag t in tagData)
                {
                    Seed s = t.Seed;
                    
                    if (s.status.Equals(SystemStatements.STATUS_NEW) || s.status.Equals(SystemStatements.STATUS_GROWING))
                    {
                        seedData.Add(s);
                    }
                }
               
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get list of seeds by zip
        /// </summary>
        /// <param name="radius"></param>
        /// <param name="zip"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsByZip(string radius, string zip)
        {
            #region Business Logic

            IList<Seed> seedData = new List<Seed>();

            try
            {
                CommonMethods commMethods = new CommonMethods();

                DataTable allZipCodes = commMethods.GetZipListByRadiusNew(radius, zip);

                //string abc = commMethods.GetZipByRadius(radius, zip);

                IList<Location> locationList = repoObj.List<Location>().ToList();

                IList<Location> FilterZip =
                 (from u in locationList
                 join p in allZipCodes.AsEnumerable() on u.zipcode
                 equals p.Field<string>("Zip").Trim().ToUpper()
                 select u).Distinct().ToList();



                //seedData = repoObj.List<Location>(x => x.zipcode.Equals(zip) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();

               // IList<Location> locationList = repoObj.List<Location>(x => x.zipcode.Equals(zip)).ToList();

                foreach (Location l in FilterZip)
                {
                    if (l.Seeds != null && l.Seeds.Count > 0)
                    {
                        seedData.Add(l.Seeds.FirstOrDefault());
                    }
                    //foreach (Seed s in l.Seeds)
                    //{
                        //if (s.status.Equals(SystemStatements.STATUS_NEW) || s.status.Equals(SystemStatements.STATUS_GROWING))
                        //{
                            
                       // }ss
                    //}
                }
            }

            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get list of seeds by cross street
        /// </summary>
        /// <param name="cStreet"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsBycstreet(string cStreet)
        {
            #region Business Logic

            IList<Seed> seedData = new List<Seed>();

            try
            {
                //seedData = repoObj.List<Location>(x => x.zipcode.Equals(zip) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();

                IList<Location> locationList = repoObj.List<Location>(x => x.crossStreet.Contains(cStreet)).ToList();

                foreach (Location l in locationList)
                {
                    foreach (Seed s in l.Seeds)
                    {
                        if (s.status.Equals(SystemStatements.STATUS_NEW) || s.status.Equals(SystemStatements.STATUS_GROWING))
                        {
                            seedData.Add(s);
                        }
                    }
                }
            }

            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get list of seeds by city
        /// </summary>
        /// <param name="city"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsByCity(string city)
        {
            #region Business Logic

            IList<Seed> seedData = new List<Seed>();

            try
            {
                IList<Location> locationList = repoObj.List<Location>(x => x.City.name.Equals(city),"city").ToList();

                foreach (Location l in locationList)
                {
                    foreach (Seed s in l.Seeds)
                    {
                        if(s.status.Equals(SystemStatements.STATUS_NEW) || s.status.Equals(SystemStatements.STATUS_GROWING))
                        {
                            seedData.Add(s);
                        }
                    }
                }
            }

            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }        

        /// <summary>
        /// Filter seeds from existing list
        /// </summary>
        /// <param name="tmpSeedList"></param>
        /// <param name="title"></param>
        /// <returns></returns>
        public IList<Seed> FilterSeedsByTitle(List<Seed> tmpSeedList, string title)
        {
            #region Business Logic

            IList<Seed> seedData = null;
            try
            {
                seedData = (from s in tmpSeedList where (s.title.Contains(title)) select s).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to search seeds.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetAllFavouriteSeeds(string memberid)
        {
            #region Business Logic

            Guid memId = new Guid(memberid);
            IList<Seed> seedList = new List<Seed>();
            try
            {
               IList<Bookmark> tmpBookMarkList = repoObj.List<Bookmark>(x => x.Member.id.Equals(memId),"Seed").ToList();
               foreach (Bookmark bookmarkData in tmpBookMarkList)
               {
                   seedList.Add(bookmarkData.Seed);
               }
               IList<Rating> tmpRatingList = repoObj.List<Rating>(x => x.Member.id.Equals(memId) && x.likes.Equals("Like"), "Seed").ToList();
               foreach (Rating ratingData in tmpRatingList)
               {
                   seedList.Add(ratingData.Seed);
               }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedList.Distinct().ToList();
            #endregion
        }

        /// <summary>
        /// Method to search seeds.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsByStatus(string memberid,string status)
        {
            #region Business Logic

            Guid memId = new Guid(memberid);
            IList<Seed> seedList = null;

            try
            {
                seedList = repoObj.List<Seed>(x => x.Member.id.Equals(memId) && x.status.Equals(status)).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedList;
            #endregion
        }

        /// <summary>
        /// Get list of seeds by comments done
        /// </summary>
        /// <param name="memberid"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsCommentedByMe(string memberid)
        {
            #region Business Logic

            Guid memId = new Guid(memberid);
            IList<Seed> seedList = new List<Seed>();

            try
            {
                IList<Comment> commentList = repoObj.List<Comment>(x => x.Member.id.Equals(memId)).ToList();

                foreach(Comment comm in commentList)
                {
                    if (comm.Seed.status.Equals(SystemStatements.STATUS_NEW) || comm.Seed.status.Equals(SystemStatements.STATUS_GROWING))
                    {
                        seedList.Add(comm.Seed);
                    }
                }                
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedList;
            #endregion
        }        

        /// <summary>
        /// Method to add new seed.
        /// </summary>
        /// <param name="seed"></param>
        /// <returns></returns>
        public Seed AddSeed(Seed seed)
        {
            #region Business Logic

            try
            {
                seed.id = Guid.NewGuid();
                seed.createDate = DateTime.Now;
                seed.status = SystemStatements.STATUS_NEW;

                repoObj.Create<Seed>(seed);
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seed;
            #endregion
        }

        /// <summary>
        /// Method to update seed.
        /// </summary>
        /// <param name="seed"></param>
        /// <returns></returns>
        public Seed UpdateSeed(Seed seed)
        {
            #region Business Logic

            try
            {
                repoObj.Update<Seed>(seed);
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seed;
            #endregion
        }        

        /// <summary>
        /// Method to manage tag for seed.
        /// </summary>
        /// <param name="tag"></param>
        /// <returns></returns>
        public bool ManageTag(Tag tag)
        {
            #region Business Logic

                bool actionCompleted = false;

                try
                {
                    //see if tag exists

                    Guid tempId = new Guid(tag.seedId.ToString());

                    Tag tagData = repoObj.List<Tag>(x => x.Seed.id.Equals(tempId)).FirstOrDefault();

                    if (tagData != null)
                    {
                        tagData.name = tag.name;
                        repoObj.Update<Tag>(tagData);
                    }
                    else
                    {
                        tag.id = Guid.NewGuid();

                        repoObj.Create<Tag>(tag);
                    }

                    actionCompleted = true;
                }
                catch (Exception ex)
                {
                    WriteError(ex);
                }
                return actionCompleted;
            #endregion
        }

        /// <summary>
        /// Method to get seeds by user.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetSeedsByUser(string Id)
        {
            #region Business Logic

            IList<Seed> seedData = null;

            try
            {
                Guid memberid = new Guid(Id.Trim());
                // if location and title
                if (!string.IsNullOrEmpty(Id))
                {
                    seedData = repoObj.List<Seed>(x => x.Member.id.Equals(memberid) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).OrderByDescending(x => x.createDate).ToList();
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get harvested seeds by user.
        /// </summary>        
        /// <param name="Id"></param>
        /// <returns></returns>
        public IList<Seed> GetHarvestedSeedsByUser(string Id)
        {
            #region Business Logic

            IList<Seed> seedData = null;

            try
            {
                Guid memberid = new Guid(Id.Trim());
                // if location and title
                if (!string.IsNullOrEmpty(Id))
                {
                    seedData = repoObj.List<Seed>(x => x.Member.id.Equals(memberid) && x.status.Equals(SystemStatements.STATUS_HARVESTED)).OrderByDescending(x => x.createDate).ToList();
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get seeds by commitments.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetSeedsByCommitments(string Id)
        {
            #region Business Logic

            Guid memId = new Guid(Id);
            IList<Seed> seedList = new List<Seed>();
            try
            {
                IList<Commitment> tmpCommitmentList = repoObj.List<Commitment>(x => x.Member.id.Equals(memId)).ToList();
                foreach (Commitment CommitmentData in tmpCommitmentList)
                {
                    if (CommitmentData.Seed.status.Equals(SystemStatements.STATUS_NEW) || CommitmentData.Seed.status.Equals(SystemStatements.STATUS_GROWING))
                    {
                        seedList.Add(CommitmentData.Seed);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedList.Distinct().ToList();

            //IList<Seed> seedData = null;
            //try
            //{
            //    Guid memberid = new Guid(Id.Trim());
            //    // if location and title
            //    if (!string.IsNullOrEmpty(Id))
            //    {
            //        seedData = repoObj.List<Seed>(x => x.Member.id.Equals(memberid) && x.Commitments.Count > 0 && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).OrderByDescending(x => x.createDate).ToList();
            //    }
            //}
            //catch (Exception ex)
            //{
            //    WriteError(ex);
            //}
            //return seedData;
            #endregion
        }

        /// </summary>
        /// Get seed by SeedId.
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public Seed GetSeedBySeedId(string Id)
        {
            #region Business Logic

            Seed seedData = null;

            try
            {
                Guid seedid = new Guid(Id.Trim());
                // if location and title
                if (!string.IsNullOrEmpty(Id))
                {
                    seedData = repoObj.List<Seed>(x => x.id.Equals(seedid) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get seed by name
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public Seed Test(string name)
        {
            #region Business Logic

            Seed seedData = null;

            try
            {
                seedData = repoObj.List<Seed>(x => x.title.Equals(name)).FirstOrDefault();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get all Categories.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Category> GetAllCategories()
        {
            #region Business Logic

            return repoObj.List<Category>(x => x.status.Equals(SystemStatements.STATUS_ACTIVE)).OrderBy(x => x.name).ToList();
             // return repoObj.List<Category>().ToList();
              
            #endregion
        }

        /// <summary>
        /// Method to search seeds.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Category> GetCategoryBySeedID(string seedId)
        {
            #region Business Logic
                Guid id = new Guid(seedId);

                Seed seedData = null;
                IList<Category> categoryData = null;

                try
                {
                    seedData = repoObj.List<Seed>(x => x.id.Equals(id)).FirstOrDefault();
                    categoryData = seedData.Categories.ToList();
                }
                catch (Exception ex)
                {
                    WriteError(ex);
                }

                return categoryData;
            #endregion
        }

        /// <summary>
        /// Method to add new seed.
        /// </summary>
        /// <param name="seed"></param>
        /// <returns></returns>
        public bool AddCategories(string seedId,string[] categoryId)
        {
            #region Business Logic
            bool isActionCompleted = false;

            try
            {
                Guid id = new Guid(seedId);
                Seed seedData = repoObj.List<Seed>(x => x.id.Equals(id)).FirstOrDefault();
                IList<Category> catLst = seedData.Categories.ToList();
                foreach (Category catData in catLst)
                {
                    seedData.Categories.Remove(catData);
                }

                foreach(string cId in categoryId)
                {
                    Guid catId = new Guid(cId);
                    seedData.Categories.Add(repoObj.List<Category>(x => x.id.Equals(catId)).FirstOrDefault());
                }

                repoObj.Update<Seed>(seedData);
                isActionCompleted = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return isActionCompleted;
            #endregion
        }

        /// <summary>
        /// Method to Update Seed Owner.
        /// </summary>        
        /// <param name="seedid"></param>
        /// <param name="memberid"></param>        
        /// <returns></returns>
        public bool UpdateSeedOwner(string seedid, string memberid)
        {
            #region Business Logic

            bool updated = false;
            string prevOwner = "";
            try
            {
                Seed objSeed = repoObj.List<Seed>(x => x.id.Equals(new Guid(seedid))).FirstOrDefault();
                prevOwner = objSeed.ownerId.ToString();
                if (objSeed != null)
                {
                    objSeed.ownerId = new Guid(memberid);
                    repoObj.Update<Seed>(objSeed);
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
        /// Method to Harvest and Terminate Seed.
        /// </summary>        
        /// <param name="seedid"></param>
        /// <param name="memberid"></param>
        /// <returns></returns>
        public bool HarvestTerminateSeed(string seedid, string Action)
        {
            #region Business Logic
            bool updated = false;
            try
            {
                Seed objSeed = repoObj.List<Seed>(x => x.id.Equals(new Guid(seedid))).FirstOrDefault();
                if (objSeed != null)
                {
                    if (Action == "Harvest")
                        objSeed.status = SystemStatements.STATUS_HARVESTED;

                    if (Action == "Terminate")
                        objSeed.status = SystemStatements.STATUS_TERMINATED;

                    repoObj.Update<Seed>(objSeed);
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
        /// Method to search seeds from global search.
        /// </summary>
        /// <param name="locationList"></param>
        /// <param name="catId"></param>
        /// <param name="keyword"></param>
        /// <returns></returns>
        public IList<Seed> searchSeedFromMaster(IList<Location> locationList, string cstreet, string city, string catId, string keyword, string zip)
        {
            #region Business Logic
            IList<Seed> seedList = new List<Seed>();

            string searchString = "select seed.* from seed,Seed_has_Category where (status='New' or status='Growing')";

            bool flag = false;

            #region Search in location table

            if ((city.Length > 0 && city != "City") || (zip.Length > 0 && zip != "Zipcode") || (cstreet.Length > 0 && cstreet != "Cross Street"))
            {
                searchString += " and locationid in ( select id from location where ";

                if (city.Length > 0 && city != "City")
                {
                    searchString += "cityid in (select id from City where name = '" + city + "' ))";

                    flag = true;
                }

                if (zip.Length > 0 && zip != "Zipcode")
                {
                    if (flag)
                    {
                        searchString = searchString.Substring(0, searchString.Length - 1);

                        searchString += " and zipcode = '" + zip + "')";
                    }
                    else
                    {
                        searchString += "zipcode = '" + zip + "')";
                    }
                }

                if (cstreet.Length > 0 && cstreet != "Cross Street")
                {
                    if (flag)
                    {
                        searchString = searchString.Substring(0, searchString.Length - 1);

                        searchString += " and crossStreet = '" + cstreet + "')";
                    }
                    else
                    {
                        searchString += "crossStreet = '" + cstreet + "')";
                    }
                }
            }

            #endregion

            if (catId != null && catId.Length > 0)
            {
                if (flag)
                {
                    searchString += " and Seed_has_Category.categoryId = '" + catId + "'";
                }
                else
                {
                    searchString += " Seed_has_Category.categoryId = '" + catId + "'";
                }

                flag = true;
            }

            if (keyword.Length > 0)
            {
                if (keyword != "Keywords")
                {
                    if (flag)
                    {
                        searchString += " and Seed.title = '" + keyword + "'";
                    }
                    else
                    {
                        searchString += " Seed.title = '" + keyword + "'";
                    }
                }
            }

            if (!string.IsNullOrEmpty(keyword))
            {
                if (keyword.Length > 0)
                {
                    if (keyword != "Keywords")
                    {
                        IList<Seed> tagSeedList = this.GetAllSeedsByTag(keyword);

                        foreach (Seed s in tagSeedList)
                        {
                            seedList.Add(s);
                        }
                    }
                }
            }

            searchString = "select * from seed";
            IList<Seed> returnSeedList = (from s in seedList select s).Distinct().ToList();
            return returnSeedList;

            #endregion
        }

        /// <summary>
        /// Get seed count by rating.
        /// </summary>
        /// <param name="seedId"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public int getSeedRatingCountBySeedId(string seedId,string type)
        {
            #region Business Logic

            int seedCount = 0;

            Guid sId = new Guid(seedId);

            try
            {
                seedCount = repoObj.List<Rating>(x => x.Seed.id.Equals(sId) && x.likes.Equals(type)).Count();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }

            return seedCount;
            #endregion
        }

        /// <summary>
        /// Get seed count by rating.
        /// </summary>
        /// <param name="seedId"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public int getSeedRatingCountByMemberId(string seedId, string memberId, string type)
        {
            #region Business Logic

            int seedCount = 0;

            Guid sId = new Guid(seedId);

            Guid mId = new Guid(memberId);

            try
            {
                seedCount = repoObj.List<Rating>(x =>x.Seed.id.Equals(sId) && x.Member.id.Equals(mId) && x.likes.Equals(type)).Count();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }

            return seedCount;
            #endregion
        }

        /// <summary>
        /// Get seed count by commitment.
        /// </summary>
        /// <param name="seedId"></param>
        /// <returns></returns>
        public int getSeedCommitmentCountBySeedId(string seedId)
        {
            #region Business Logic

            int seedCount = 0;
            Guid sId = new Guid(seedId);
            try
            {
                seedCount = repoObj.List<Commitment>(x => x.Seed.id.Equals(sId)).Count();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }

            return seedCount;
            #endregion
        }

        /// <summary>
        /// Method to search seeds by Status.
        /// </summary>
        /// <param name="status"></param>
        /// <returns></returns>
        public IList<Seed> GetSeedsByStatus(string status)
        {
            #region Business Logic
            
            IList<Seed> seedList = null;
            try
            {
                seedList = repoObj.List<Seed>(x => x.status.Equals(status)).OrderByDescending(x => x.createDate).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedList;
            #endregion
        }

        /// <summary>
        /// Method to search seeds by Status.
        /// </summary>
        /// <param name="status1"></param>
        /// <param name="status2"></param>
        /// <returns></returns>
        public IList<Seed> GetSeedsByTwoStatus(string status1, string status2)
        {
            #region Business Logic

            IList<Seed> seedList = null;
            try
            {
                seedList = repoObj.List<Seed>(x => x.status.Equals(status1) || x.status.Equals(status2)).OrderByDescending(x => x.createDate).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedList;
            #endregion
        }

        /// <summary>
        /// Method to get flagged seeds.
        /// </summary>
        /// <param name=""></param>        
        /// <returns></returns>
        public IList<Seed> GetFlaggedSeeds()
        {
            #region Business Logic

            IList<Seed> seedList = null;
            try
            {
                seedList = repoObj.List<Seed>(x => x.Flags.Count > 0 && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).OrderByDescending(x => x.createDate).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedList;
            #endregion
        }

        /// <summary>
        /// Method to get tags.
        /// </summary>
        /// <param name=""></param>        
        /// <returns></returns>
        public IList<Tag> GetAllTagsByName(string tag)
        {
            #region Business Logic

            IList<Tag> tagList = null;
            try
            {
                tagList = repoObj.List<Tag>(x=>x.name.StartsWith(tag)   ).Distinct().ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return tagList;
            #endregion
        }

        /// <summary>
        /// Method to get all tags
        /// </summary>
        /// <returns></returns>
        public IList<Tag> GetAllTags()
        {
            #region Business Logic

            IList<Tag> tagList = null;
            try
            {
                tagList = repoObj.List<Tag>().Distinct().ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return tagList;
            #endregion
        }

        /// <summary>
        /// Method to manage rating.
        /// </summary>
        /// <returns></returns>
        public bool ManageRating(string seedId, string memberId,string rate)
        {
            #region Business Logic

            bool actionComplete = false;
            Guid sId = new Guid(seedId);
            Guid memId = new Guid(memberId);

            try
            {
                Rating ratingData = repoObj.List<Rating>(x => x.Seed.id.Equals(sId) && x.Member.id.Equals(memId)).FirstOrDefault();

                try
                {
                    if (ratingData == null)
                    {
                        ratingData = new Rating();
                        
                        ratingData.id = Guid.NewGuid();
                        ratingData.Seed = repoObj.List<Seed>(x => x.id.Equals(sId)).FirstOrDefault();
                        ratingData.Member = repoObj.List<Member>(x => x.id.Equals(memId)).FirstOrDefault();
                        ratingData.likes = rate;
                        ratingData.isRead = false;
                        ratingData.ratingDate = DateTime.Now;
                        repoObj.Create<Rating>(ratingData);
                    }
                    else
                    {
                        if (rate == "DLike")
                            repoObj.Delete<Rating>(ratingData);
                    }

                    actionComplete = true;
                }
                catch (Exception ex)
                {
                    WriteError(ex);
                }
            }
            catch
            {

            }
            return actionComplete;

            #endregion
        }

        /// <summary>
        /// Method to get seeds by user.
        /// </summary>
        /// <param name="MemberId"></param>
        /// <param name="seedId"></param>
        /// <returns></returns>
        public bool GetBookmarkList(string MemberId, string SeedId)
        {
            #region Business Logic
            bool isChecked = false;
            IList<Bookmark> bookmarkData = null;

            try
            {
                Guid memberid = new Guid(MemberId.Trim());
                Guid seedid = new Guid(SeedId.Trim());
                // if location and title
                if (!string.IsNullOrEmpty(MemberId))
                {
                    bookmarkData = repoObj.List<Bookmark>(x => x.Member.id.Equals(memberid) && x.Seed.id.Equals(seedid)).ToList();
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            if (bookmarkData.Count < 1)
                isChecked = true;
            //return bookmarkData;
            return isChecked;
            #endregion
        }

        /// <summary>
        /// Method to get Member authorities
        /// </summary>
        /// <param name="memId"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public int GetMemberAuthority(string memId,string type)
        {
            #region Business Logic
            Guid memberid = new Guid(memId);

            Privacy privacyData = repoObj.List<Privacy>(x => x.Member.id.Equals(memberid)).FirstOrDefault();

            Message messageData = null;

            if (privacyData != null)
            {
                if (type.Equals("Contribution"))
                {
                    messageData = repoObj.List<Message>(x => x.id.Equals(new Guid(privacyData.seedContribution))).FirstOrDefault();
                }
                else if (type.Equals("Commitment"))
                {
                    messageData = repoObj.List<Message>(x => x.id.Equals(new Guid(privacyData.seedCommitment))).FirstOrDefault();
                }
                else if (type.Equals("MyUsername"))
                {
                    messageData = repoObj.List<Message>(x => x.id.Equals(new Guid(privacyData.viewUsername))).FirstOrDefault();
                }
                return Convert.ToInt32(messageData.typeId);
            }

            return 10;
            #endregion
        }

        /// <summary>
        /// Method to get list of dying seeds
        /// </summary>
        /// <returns></returns>
        public IList<Seed> GetAllDyingSeeds()
        {
            #region Business Logic
            IList<Seed> seedList = new List<Seed>();
            IList<Seed> allSeeds = null;
            IList<Seed> dyingSeeds = null;
            DateTime dt = DateTime.Now.AddDays(-30);

            IList<Comment> commentSeeds = repoObj.List<Comment>(x => x.commentDate > dt).ToList();
            foreach (Comment comm in commentSeeds)
            {
                seedList.Add(comm.Seed);
            }

            IList<Commitment> commitmentSeeds = repoObj.List<Commitment>(x => x.commitDate > dt).ToList();
            foreach (Commitment commit in commitmentSeeds)
            {
                seedList.Add(commit.Seed);
            }

            IList<Flag> flagSeeds = repoObj.List<Flag>(x => x.dateFlagged > dt).ToList();
            foreach (Flag flag in flagSeeds)
            {
                seedList.Add(flag.Seed);
            }

            IList<Seed> distinctseedList = (from x in seedList select x).Distinct().ToList();
            allSeeds = repoObj.List<Seed>(x => x.status != SystemStatements.STATUS_TERMINATED && x.status != SystemStatements.STATUS_HARVESTED && x.status != SystemStatements.STATUS_INACTIVE && x.createDate < dt).OrderByDescending(x => x.createDate).ToList();
            dyingSeeds = allSeeds.Except<Seed>(distinctseedList).ToList();
            return dyingSeeds;
            #endregion
        }

        /// <summary>
        /// Method to unflag Seed.
        /// </summary>        
        /// <param name="id"></param>
        /// <returns></returns>
        public bool unFlagSeed(string id)
        {
            #region Business Logic
            bool updated = false;
            try
            {
                Flag objflag = repoObj.List<Flag>(x => x.id.Equals(new Guid(id))).FirstOrDefault();
                if (objflag != null)
                {
                    repoObj.Delete<Flag>(objflag);
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
        /// Method to get member by name.
        /// </summary>
        /// <param name=""></param>        
        /// <returns></returns>
        public IList<Member> GetMemberInfoByName(string member)
        {
            #region Business Logic

            IList<Member> memberList = null;
            try
            {
                memberList = repoObj.List<Member>(x => x.username.StartsWith(member)).Distinct().ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return memberList;
            #endregion
        }

        /// <summary>
        /// Method to Add City.
        /// </summary>
        /// <param name="cityName"></param>
        /// <param name="regionId"></param>
        /// <returns></returns>
        public string AddCity(string cityName, string regionCode)
        {
            #region Business Logic
            Region objRegion = repoObj.List<Region>(x => x.code.Equals(regionCode)).FirstOrDefault();
            
            City objCity = repoObj.List<City>(x => x.name.Equals(cityName) && x.Region.id.Equals(objRegion.id)).FirstOrDefault();
            try
            {                
                if (objCity == null)
                {
                    objCity = new City();
                    objCity.id = Guid.NewGuid();
                    objCity.name = cityName;
                    objCity.regionId = objRegion.id;
                    repoObj.Create<City>(objCity);
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return objCity.id.ToString();
            #endregion
        }

        /// <summary>
        /// Method to get list of seeds by category name
        /// </summary>
        /// <param name="uniqueId"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsByCategoryName(string uniqueId)
        {
            #region Business Logic
            IList<Seed> SeedResult = repoObj.List<Category>(x => x.id.Equals(new Guid(uniqueId))).FirstOrDefault().Seeds.ToList();

            return SeedResult;
            #endregion
        }

        /// <summary>
        /// Method to get seed lists by criteria
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        public IList<Seed> GetSeedListByCriteria(string criteria)
        {
            IList<Seed> lstSeed = null;
            lstSeed = repoObj.ListPPP<Seed>("usp_SearchSeeds", criteria).ToList();
            lstSeed = (from s in lstSeed select s).Distinct().ToList();
            return lstSeed;
        }

        /// <summary>
        /// Method to get list of seeds using search criteria
        /// </summary>
        /// <param name="searchTxt"></param>
        /// <returns></returns>
        public IList<Seed> MasterSearch(string searchTxt)
        {
            #region
            IList<Seed> seedList = new List<Seed>();
            string searchString = "";
            searchString = "select distinct seed.* from seed where (seed.[status]='New' or seed.[status]='Growing')";

            if (!string.IsNullOrEmpty(searchTxt))
            {
                if (searchTxt != "Search by user, category, keywords")
                {
                    if (searchTxt.Contains('@'))
                    {
                        searchString += " and (Seed.ownerId in (Select id from Member where username = '" + searchTxt + "')";
                    }
                    else
                    {
                        string fName = string.Empty;
                        string lName = string.Empty;
                        string[] splt = searchTxt.Split(' ');
                        if (splt.Count() > 1)
                        {
                            fName = splt[0].ToString();
                            lName = splt[1].ToString();
                            searchString += " and (Seed.ownerId in (select id from Member where firstName = '" + searchTxt + "' or lastName='" + searchTxt + "')";
                        }
                        else
                        {
                            fName = splt[0].ToString();
                            searchString += " and (Seed.ownerId in (select id from Member where firstName = '" + searchTxt + "')";
                        }
                    }
                }
            }

            if (!string.IsNullOrEmpty(searchTxt))
            {
                if (searchTxt.Length > 0 && searchTxt != "Search by user, category, keywords")
                {
                    searchString += " or (Seed.title like '%" + searchTxt + "%' or Seed.description like '%" + searchTxt + "%')";
                    searchString += " or (Seed.locationId in (Select id from Location where cityId in (Select id from City where name like '" + searchTxt + "%'))))";
                }
            }

            seedList = repoObj.ListPPP<Seed>("usp_SearchSeeds", searchString).ToList();
            IList<Seed> returnSeedList = (from s in seedList select s).Distinct().ToList();
            return returnSeedList;
            #endregion
        }

        /// <summary>
        /// Method to search seeds.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetAllSeedsByUserName(string userName)
        {
            #region Business Logic

            IList<Seed> seedData = null;

            try
            {
                seedData = repoObj.List<Seed>(x => x.Member.firstName.Contains(userName) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get seeds by Parrent Seed ID.
        /// </summary>
        /// <param name="title"></param>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public IList<Seed> GetSeedsByParrentSeedID(string Id)
        {
            #region Business Logic

            IList<Seed> seedData = null;

            try
            {
                Guid parentid = new Guid(Id.Trim());
                // if location and title
                if (!string.IsNullOrEmpty(Id))
                {
                    seedData = repoObj.List<Seed>(x => x.parentSeedID == parentid && x.parentSeedID != null).ToList();
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get reply seeds
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public IList<Seed> GetAllReplySeedsbyMember(string ownerId)
        {
            #region Business Logic
            IList<Seed> seedData = null;
            try
            {
                seedData = repoObj.List<Seed>(x => x.ownerId == new Guid(ownerId) && x.parentSeedID != null && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// <summary>
        /// Method to get 20 latest Seeds
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public IList<Seed> GetLatestSeeds()
        {
            #region Business Logic
            IList<Seed> seedData = null;
            try
            {
                seedData = repoObj.List<Seed>(x => x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING)).Take(20).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedData;
            #endregion
        }

        /// </summary>
        /// Get seed name by SeedId.
        /// <param name="id"></param>        
        /// <returns></returns>
        public string GetSeedNameBySeedId(string Id)
        {
            #region Business Logic
            Seed seedData = null;
            string seedName = string.Empty;
            try
            {
                Guid seedid = new Guid(Id.Trim());                
                if (!string.IsNullOrEmpty(Id))
                {
                    seedData = repoObj.List<Seed>(x => x.id.Equals(seedid)).FirstOrDefault();
                    seedName = seedData.title;
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return seedName;
            #endregion
        }

        /// <summary>
        /// Method to hide or unhide seeds
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="seedId"></param>
        /// <param name="action"></param>
        /// <returns></returns>
        public bool HideOrUnhideSeed(string memberId, string seedId, string action)
        {
            #region Business Logic
            bool actionCompleted = false;
            try
            {
                if (action == "Hide")
                {
                    HideUnhide hide = new HideUnhide();
                    hide.id = Guid.NewGuid();
                    hide.memId = new Guid(memberId);
                    hide.seedId = new Guid(seedId);
                    repoObj.Create<HideUnhide>(hide);
                    actionCompleted = true;
                }

                if (action == "Unhide")
                {
                    HideUnhide hide = repoObj.List<HideUnhide>(x => x.memId == (new Guid(memberId)) && x.seedId == (new Guid(seedId))).FirstOrDefault();

                    

                    repoObj.Delete<HideUnhide>(hide);
                    actionCompleted = true;
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return actionCompleted;
            #endregion
        }

        /// <summary>
        /// Method to get zip of seed by city id
        /// </summary>
        /// <param name="cityId"></param>
        /// <returns></returns>
        public string GetZipOfSeedByCityId(string cityId)
        {
            #region Business Logic
            string zipCode = string.Empty;
            Seed seedData = null;
            try
            {
                if (cityId.Trim().Length > 0)
                {
                    seedData = repoObj.List<Seed>(x => x.Location.cityId == new Guid(cityId) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).FirstOrDefault();
                    if (seedData != null)
                        zipCode = seedData.Location.zipcode;
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return zipCode;
            #endregion
        }
    }
}
