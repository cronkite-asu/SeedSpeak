using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using SeedSpeak.Model.Validation;
using SeedSpeak.Model;
using SeedSpeak.Data.Repository;
using SeedSpeak.Util;
using System.Data;

namespace SeedSpeak.BLL
{
    public class StreamAction : AbstractAction
    {
        Repository repoObj = new Repository();

        /// <summary>
        /// Method to create garden.
        /// </summary>
        /// <param name="garden"></param>
        /// <returns></returns>
        public bool CreateStream(ssStream stream)
        {
            #region Business Logic
            bool actionCompleted = false;
            try
            {
                stream.id = Guid.NewGuid();
                stream.createDate = DateTime.Now;
                stream.status = SystemStatements.STREAM_ACTIVE;
                repoObj.Create<ssStream>(stream);
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
        /// Method to create garden
        /// </summary>
        /// <param name="stream"></param>
        /// <returns></returns>
        public ssStream CreateStream1(ssStream stream)
        {
            #region Business Logic
            try
            {
                stream.id = Guid.NewGuid();
                stream.createDate = DateTime.Now;
                stream.status = SystemStatements.STREAM_ACTIVE;
                repoObj.Create<ssStream>(stream);
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return stream;
            #endregion
        }

        /// <summary>
        /// Method to Update garden.
        /// </summary>
        /// <param name="garden"></param>
        /// <returns></returns>
        public bool UpdateStream(ssStream stream)
        {
            #region Business Logic
            bool actionCompleted = false;
            ssStream streamData = repoObj.List<ssStream>(x => x.id.Equals(stream.id)).FirstOrDefault();
            try
            {
                streamData.description = stream.description;
                streamData.criteria = stream.criteria;
                streamData.streamType = stream.streamType;
                streamData.isPublic = stream.isPublic;
                streamData.createDate = DateTime.Now;
                streamData.status = stream.status;

                repoObj.Update<ssStream>(streamData);
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
        /// Method to update seed stream
        /// </summary>
        /// <param name="stream"></param>
        /// <returns></returns>
        public ssStream UpdateStream1(ssStream stream)
        {
            #region Business Logic
            ssStream streamData = repoObj.List<ssStream>(x => x.id.Equals(stream.id)).FirstOrDefault();
            try
            {
                streamData.description = stream.description;
                streamData.criteria = stream.criteria;
                streamData.streamType = stream.streamType;
                streamData.isPublic = stream.isPublic;
                streamData.createDate = DateTime.Now;
                streamData.status = stream.status;

                repoObj.Update<ssStream>(streamData);
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return streamData;
            #endregion
        }

        /// <summary>
        /// Method to get all garden.
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public IList<ssStream> GetAllStreams(string memberId)
        {
            #region Business Logic
            IList<ssStream> streamData = null;
            try
            {
                streamData = repoObj.List<ssStream>(x => x.Member.id.Equals(new Guid(memberId)) && x.status.Equals(SystemStatements.STREAM_ACTIVE)).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return streamData;
            #endregion
        }

        /// <summary>
        /// Method to get all handpicked streams.
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public IList<ssStream> GetAllHandPickedStreams(string memberId)
        {
            #region Business Logic
            IList<ssStream> streamData = null;
            try
            {
                streamData = repoObj.List<ssStream>(x => x.Member.id.Equals(new Guid(memberId)) && x.streamType.Equals(SystemStatements.STREAM_HANDPICKED) && x.status.Equals(SystemStatements.STREAM_ACTIVE)).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return streamData;
            #endregion
        }

        /// <summary>
        /// Method to get garden by id
        /// </summary>
        /// <param name="gardenId"></param>
        /// <returns></returns>
        public ssStream GetStreamById(string streamId)
        {
            #region Business Logic
            ssStream streamData = null;
            Guid gId = new Guid(streamId);
            try
            {
                streamData = repoObj.List<ssStream>(x => x.id.Equals(gId) && x.status.Equals(SystemStatements.STREAM_ACTIVE)).FirstOrDefault();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return streamData;
            #endregion
        }

        /// <summary>
        /// Method to get stream by search
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        public IList<ssStream> GetStreamsBySearch(string criteria)
        {
            #region Business Logic
            IList<ssStream> streamData = new List<ssStream>();
            try
            {
                streamData = repoObj.List<ssStream>(x => x.status.Equals(SystemStatements.STREAM_ACTIVE)).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return streamData;
            #endregion
        }

        /// <summary>
        /// Method to get stream by zip
        /// </summary>
        /// <param name="zip"></param>
        /// <returns></returns>
        public IList<ssStream> GetAllStreamByZip(string zip)
        {
            #region Business Logic
            IList<ssStream> streamData = new List<ssStream>();
            try
            {
                CommonMethods commMethods = new CommonMethods();
                DataTable allZipCodes = commMethods.GetZipListByRadius("25", zip);
                IList<Location> locationList = repoObj.List<Location>().ToList();
                IList<Location> FilterZip =
                 (from u in locationList
                  join p in allZipCodes.AsEnumerable() on u.zipcode
                  equals p.Field<string>("Zip").Trim().ToUpper()
                  select u).Distinct().ToList();

                foreach (Location loc in FilterZip)
                {
                    if (loc.ssStreams != null && loc.ssStreams.Count > 0)
                    {
                        streamData.Add(loc.ssStreams.FirstOrDefault());
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return streamData;
            #endregion
        }

        /// <summary>
        /// Method to search streams.
        /// </summary>
        /// <param name="title"></param>
        /// <returns></returns>
        public IList<ssStream> GetAllStreamsByTitle(string title)
        {
            #region Business Logic
            IList<ssStream> streamData = null;
            try
            {
                streamData = repoObj.List<ssStream>(x => x.title.Contains(title) && (x.status.Equals(SystemStatements.STREAM_ACTIVE))).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return streamData;
            #endregion
        }

        /// <summary>
        /// Method to search streams.
        /// </summary>
        /// <param name="description"></param>
        /// <returns></returns>
        public IList<ssStream> GetAllStreamsByDescription(string description)
        {
            #region Business Logic
            IList<ssStream> ssData = null;
            try
            {
                ssData = repoObj.List<ssStream>(x => x.description.Contains(description) && (x.status.Equals(SystemStatements.STREAM_ACTIVE))).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return ssData;
            #endregion
        }

        /// <summary>
        /// Method to get streams by crossStreet.
        /// </summary>
        /// <param name="cStreet"></param>
        /// <returns></returns>
        public IList<ssStream> GetStreamByCrossStreet(string cStreet)
        {
            #region Business Logic
            IList<ssStream> ssData = null;
            try
            {
                if (cStreet.Trim().Length > 0)
                {
                    ssData = repoObj.List<ssStream>(x => x.Location.crossStreet.Equals(cStreet)).ToList();
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return ssData;
            #endregion
        }

        /// <summary>
        /// Method to get stream by city name.
        /// </summary>
        /// <param name="cityName"></param>
        /// <returns></returns>
        public IList<ssStream> GetStreamByCity(string cityName)
        {
            #region Business Logic

            IList<ssStream> ssData = new List<ssStream>();
            IList<ssStream> tmpStreamList = null;
            try
            {
                if (cityName.Trim().Length > 0)
                {
                    IList<City> cityData = repoObj.List<City>(x => x.name.Equals(cityName)).ToList();
                    if (cityData != null)
                    {
                        foreach (City cData in cityData)
                        {
                            tmpStreamList = repoObj.List<ssStream>(x => x.Location.City.id.Equals(cData.id)).ToList();
                            foreach (ssStream sData in tmpStreamList)
                            {
                                ssData.Add(sData);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return ssData;
            #endregion
        }

        /// <summary>
        /// Get Members by Name
        /// </summary>
        /// <param name="uName"></param>
        /// <returns></returns>
        public IList<Member> GetAllMembersByName(string uName)
        {
            #region Business Logic
            return repoObj.List<Member>(x => x.status.Equals(SystemStatements.STATUS_ACTIVE) && x.firstName.StartsWith(uName)).ToList();
            #endregion
        }

        /// <summary>
        /// Method to get latest streams.
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public IList<ssStream> GetLatestStreams()
        {
            #region Business Logic
            IList<ssStream> streamData = null;
            try
            {
                streamData = repoObj.List<ssStream>(x => x.isPublic.Value.Equals(true) && x.status.Equals(SystemStatements.STREAM_ACTIVE)).OrderByDescending(x => x.createDate).Take(5).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return streamData;
            #endregion
        }

        /// <summary>
        /// Method to get popular streams.
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public IList<ssStream> GetMostPopularStreams()
        {
            #region Business Logic
            IList<ssStream> streamData = null;
            IList<ssStream> streamFinal = new List<ssStream>();
            IList<ssStreamModel> objss = null;
            try
            {
                streamData = repoObj.List<ssStream>(x => x.status.Equals(SystemStatements.STREAM_ACTIVE)).ToList();                

                objss = (from sd in streamData
                         select new ssStreamModel
                         {
                             id = sd.id,
                             commentCounter = SeedCommentsCounter(sd)
                         }).OrderByDescending(x => x.commentCounter).Take(5).ToList();

                ssStream objStream = null;
                foreach (var ss in objss)
                {
                    objStream = repoObj.List<ssStream>(x => x.id.Equals(ss.id)).FirstOrDefault();
                    streamFinal.Add(objStream);
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            
            return streamFinal;
            #endregion
        }

        /// <summary>
        /// Method to count seed comments
        /// </summary>
        /// <param name="ss"></param>
        /// <returns></returns>
        public int SeedCommentsCounter(ssStream ss)
        {
            int counter = 0;
            foreach (Seed s in ss.Seeds)
            {
                counter += s.Comments.Count();
            }
            return counter;
        }

        /// <summary>
        /// Method to add seed in stream.
        /// </summary>
        /// <param name="seedId"></param>
        /// <param name="streamId"></param>
        /// <returns></returns>
        public bool AddSeedInStream(string seedId, string streamId)
        {
            #region Business Logic
            bool isActionCompleted = false;
            try
            {
                Guid id = new Guid(seedId);
                Guid strmId = new Guid(streamId);
                ssStream streamData = repoObj.List<ssStream>(x => x.id.Equals(strmId)).FirstOrDefault();
                streamData.Seeds.Add(repoObj.List<Seed>(x=>x.id.Equals(id)).FirstOrDefault());
                repoObj.Update<ssStream>(streamData);
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
        /// Terminated Seed Stream
        /// </summary>
        /// <param name="streamid"></param>
        /// <returns></returns>
        public bool TerminateSeedStream(string streamid)
        {
            #region Business Logic
            bool updated = false;
            try
            {
                ssStream objStream = repoObj.List<ssStream>(x => x.id.Equals(new Guid(streamid))).FirstOrDefault();
                if (objStream != null)
                {
                    objStream.status = SystemStatements.STREAM_INACTIVE;
                    repoObj.Update<ssStream>(objStream);
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
        /// Method to add feed categories.
        /// </summary>
        /// <param name="feedId"></param>
        /// <param name="categoryId"></param>
        /// <returns></returns>
        public bool AddFeedCategories(string feedId, string[] categoryId)
        {
            #region Business Logic
            bool isActionCompleted = false;

            try
            {
                Guid id = new Guid(feedId);
                ssStream streamData = repoObj.List<ssStream>(x => x.id.Equals(id)).FirstOrDefault();
                IList<Category> catLst = streamData.Categories.ToList();

                foreach (Category catData in catLst)
                {
                    streamData.Categories.Remove(catData);
                }

                foreach (string cId in categoryId)
                {
                    Guid catId = new Guid(cId);
                    streamData.Categories.Add(repoObj.List<Category>(x => x.id.Equals(catId)).FirstOrDefault());
                }

                repoObj.Update<ssStream>(streamData);
                isActionCompleted = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return isActionCompleted;
            #endregion
        }
    }
}
