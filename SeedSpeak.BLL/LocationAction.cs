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
    public class LocationAction : AbstractAction
    {
        Repository repoObj = new Repository();

        /// <summary>
        /// Method to manage location.
        /// </summary>
        /// <param name="cityId"></param>
        /// <param name="zipcode"></param>
        /// <param name="localLat"></param>
        /// <param name="localLong"></param>
        /// <param name="crossStreet"></param>
        /// <returns>Location</returns>
        public Location CreateLocation(string cityId, string zipcode, double localLat, double localLong, string crossStreet)
        {
            #region Business Logic
            Location location = null;
            try
            {
                location = new Location();
                location.id = Guid.NewGuid();
                location.cityId = new Guid(cityId);
                location.zipcode = zipcode;
                location.localLat = localLat;
                location.localLong = localLong;
                location.crossStreet = crossStreet;
                repoObj.Create<Location>(location);
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return location;
            #endregion
        }

        /// <summary>
        /// Method to Update location.
        /// </summary>
        /// <param name="location"></param>
        /// <returns>location</returns>
        public Location UpdateLocation(Location location)
        {
            #region Business Logic
            try
            {
                repoObj.Update<Location>(location);
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return location;
            #endregion
        }        

        /// <summary>
        /// Find location.
        /// </summary>
        /// <param name="cityId"></param>
        /// <param name="zipcode"></param>
        /// <param name="localLat"></param>
        /// <param name="localLong"></param>
        /// <returns></returns>
        public IList<Location> FindLocationList(string cityId, double localLat, double localLong)
        {
            #region Business Logic
            IList<Location> location = null;
            try
            {
                if (cityId.Length > 0)
                { 
                    location = repoObj.List<Location>(x => x.City.id.Equals(new Guid(cityId)) && x.Seeds.Count >0 &&
                        ((localLat + 5) >= x.localLat && (localLat - 5) <= x.localLat) && ((localLong + 5) >= x.localLong && (localLong - 5) <= x.localLong)).ToList();
                }
                else
                {
                    location = repoObj.List<Location>(x => x.Seeds.Count > 0 && ((localLat + 5) >= x.localLat && (localLat - 5) <= x.localLat) && ((localLong + 5) >= x.localLong && (localLong - 5) <= x.localLong)).ToList();
                }
                //if not create and return
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return location;
            #endregion
        }
        
        /// <summary>
        /// Method to get all cities for a region.
        /// </summary>
        /// <param name="regionId"></param>
        /// <returns></returns>
        public IList<City> GetAllCitiesForRegion(string regionId)
        {
            #region Business Logic
               return repoObj.List<City>(x => x.Region.id.Equals(new Guid(regionId))).OrderBy(x => x.name ).ToList();
            #endregion
        }

        /// <summary>
        /// Method to get all cities
        /// </summary>
        /// <param name="scity"></param>
        /// <returns></returns>
        public IList<City> GetAllCities(string scity)
        {
            #region Business Logic
                return repoObj.List<City>(x => x.name.StartsWith(scity), "Region").ToList();
            #endregion
        }        

        //only for USA!
        /// <summary>
        /// Method to get all regions.
        /// </summary>
        /// <returns></returns>
        public IList<Region> GetAllRegions()
        {
            #region Business Logic
                return repoObj.List<Region>().ToList();
            #endregion
        }

        /// <summary>
        /// Method to get region by Id
        /// </summary>
        /// <param name="rid"></param>
        /// <returns></returns>
        public Region GetRegionById(string rid)
        {
            #region Business Logic
            Guid id = new Guid(rid);

                return repoObj.List<Region>(x=>x.id.Equals(id)).FirstOrDefault();
            #endregion
        }

        /// <summary>
        /// Method to get master messages
        /// </summary>
        /// <returns></returns>
        public IList<Message> GetAllMyUsernameMessages()
        {
            #region Business Logic
            return repoObj.List<Message>(x => x.type.Equals("MyUsername")).ToList();
            #endregion
        }

        /// <summary>
        /// Method to get seed contribution messages
        /// </summary>
        /// <returns></returns>
        public IList<Message> GetAllSeedContributionMessages()
        {
            #region Business Logic
            return repoObj.List<Message>(x => x.type.Equals("SeedContribution")).ToList();
            #endregion
        }

        /// <summary>
        /// Method to get seed commitment messages
        /// </summary>
        /// <returns></returns>
        public IList<Message> GetAllSeedCommitmentMessages()
        {
            #region Business Logic
            return repoObj.List<Message>(x => x.type.Equals("SeedCommitment")).ToList();
            #endregion
        }

        /// <summary>
        /// Method to get Message by id
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public IList<Message> GetMessageById(Guid Id)
        {
            #region Business Logic
                return repoObj.List<Message>(x => x.id.Equals(Id)).ToList();
            #endregion
        }

        /// <summary>
        /// Method to get City id by City name.
        /// </summary>
        /// <param name="CityName"></param>
        /// <param name="RegionCode"></param>
        /// <returns></returns>
        public string GetCityIdByCityName(string CityName, string RegionCode)
        {
            #region Business Logic
            string cityid = "";
            City objCity = null;
            if (RegionCode.Trim().Length > 0)
            {
                objCity = repoObj.List<City>(x => x.name.Equals(CityName) && x.Region.code.Equals(RegionCode)).FirstOrDefault();
            }
            else
            {
                objCity = repoObj.List<City>(x => x.name.Equals(CityName)).FirstOrDefault();
            }

            if (objCity != null)
            {
                cityid = objCity.id.ToString();
            }

            return cityid;
            #endregion
        }

        /// <summary>
        /// Method to get city by city name and region name
        /// </summary>
        /// <param name="CityName"></param>
        /// <param name="RegionName"></param>
        /// <returns></returns>
        public City GetCityByCityAndRegion(string CityName, string RegionName)
        {
            #region Business Logic
           
            City objCity = null;
            if (RegionName.Trim().Length > 0)
            {
                objCity = repoObj.List<City>(x => x.name.Equals(CityName) && x.Region.name.Equals(RegionName)).FirstOrDefault();
            }
            else
            {
                objCity = repoObj.List<City>(x => x.name.Equals(CityName)).FirstOrDefault();
            }

            return objCity;
            #endregion
        }

        /// <summary>
        /// Method to get locations near by member location.
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public IList<Location> GetLocationByMemberId(string memberId)
        {
            #region Business Logic

            IList<Location> location = null;
            Guid memId = new Guid(memberId);

            try
            {
                //see if locaiton exists
                //if exists return it
                MemberProfile memProfile = repoObj.List<MemberProfile>(x => x.Member.id.Equals(memId), "Location").FirstOrDefault();

                if (memProfile != null)
                {
                    Location tempLocation = memProfile.Location;

                    if (tempLocation != null)
                    {
                        location = this.FindLocationList("", Convert.ToDouble(tempLocation.localLat), Convert.ToDouble(tempLocation.localLong));
                    }
                }
                //if not create and return
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return location;

            #endregion
        }

        /// <summary>
        /// Get location by member id
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public Location GetLocationDetailByMemberId(string memberId)
        {
            #region Business Logic

            Location location = null;

            Guid memId = new Guid(memberId);

            try
            {
                //see if locaiton exists
                //if exists return it
                MemberProfile memProfile = repoObj.List<MemberProfile>(x => x.Member.id.Equals(memId), "Location").FirstOrDefault();

                if (memProfile != null)
                {
                   location = memProfile.Location;
                }
                //if not create and return
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return location;

            #endregion
        }

        /// <summary>
        /// Method to find member location.
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public Location GetMemberLocationById(string memberId)
        {
            #region Business Logic

            Location location = null;
            Guid memId = new Guid(memberId);

            try
            {
                //see if locaiton exists
                //if exists return it
                location = repoObj.List<MemberProfile>(x => x.Member.id.Equals(memId), "Location").FirstOrDefault().Location;                
                //if not create and return
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return location;

            #endregion
        }
    }
}
