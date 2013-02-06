using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace SSWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface ISSService
    {

        [OperationContract]
        string GetData(int value);

        [OperationContract]
        CompositeType GetDataUsingDataContract(CompositeType composite);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<MemberLogin> MemberAuthenticate(string UserName, string Password);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<MemberSeeds> GetAllSeedsByMemberId(string MemberId, string counter);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<MemberSeeds> GetAllSeedsByParrentId(string ParrentId, string counter);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<SeedDetail> GetSeedsById(string SeedId, string MemberId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<MemberInfo> GetMemberInfoById(string memId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        string addRating(string seedId, string memberId, string rate);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<SeedComment> GetCommentsById(string SeedId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<SeedComment> GetCommitmentsById(string SeedId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<SeedComment> GetVotesById(string SeedId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<MemberNotification> getAllNotificationsByMemberId(string memberId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        bool addComment(string seedId, string memberId, string commentMsg);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        bool addCommitment(string seedId, string memberId, string commitmentDate, string commitmentMsg);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        bool ChangeMemberPasswd(string memberId, string newPassword);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        void CheckUnreadNotifications(string commentDesc);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        bool UpdateMember(string memberId, string fName, string lName, string orgName, string imageName);
        
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        bool ForgotPasswd(string userName);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        string AddSeedData(string SeedName, string Description, string CityName, string Street, string RegionCode,  string Lat, string Lng, string ZipCode, string ownerId, string tagName, string imageName, string categoryNames);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        string AddReplySeedData(string SeedName, string Description, string CityName, string Street, string RegionCode, string Lat, string Lng, string ZipCode, string ownerId, string tagName, string imageName, string categoryNames, string RootSeedId, string ParentSeedId);
        

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        string UpdateSeed(string seedId, string seedName, string seedDescription, string SeedTags, string categories, string imageName, string ownerId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        string MemberSignup(string UserName, string Password, string FirstName, string LastName, string OrganisationName);
        
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        IList<SeedDetail> SearchSeeds(string Criteria, string sortBy, string radius, string counter);
        // TODO: Add your service operations here
    }


    // Use a data contract as illustrated in the sample below to add composite types to service operations.

    [DataContract]
    public class MemberLogin
    {
        [DataMember]
        public string MemberID { get; set; }
        [DataMember]
        public string Categories { get; set; }
        [DataMember]
        public string MemberURL { get; set; }
        
    }


    [DataContract]
    public class MemberSeeds
    {
        [DataMember]
        public string SeedID { get; set; }
        [DataMember]
        public string Title { get; set; }
        [DataMember]
        public string City { get; set; }
        [DataMember]
        public string State { get; set; }
        [DataMember]
        public string Zip { get; set; }
        [DataMember]
        public string Path { get; set; }
        [DataMember]
        public string CreateDate { get; set; }
        [DataMember]
        public string Latitude { get; set; }
        [DataMember]
        public string Longitude { get; set; }

    }

    [DataContract]
    public class SeedDetail
    {
        [DataMember]
        public string SeedID { get; set; }
        [DataMember]
        public string Title { get; set; }
        [DataMember]
        public string MemberName { get; set; }
        [DataMember]
        public string City { get; set; }
        [DataMember]
        public string Address { get; set; }
        [DataMember]
        public string State { get; set; }
        [DataMember]
        public string CreateDate { get; set; }
        [DataMember]
        public string Description { get; set; }
        [DataMember]
        public string Likes { get; set; }
        [DataMember]
        public string ReplySeeds { get; set; }
        [DataMember]
        public string Comments { get; set; }
        [DataMember]
        public string Categories { get; set; }
        [DataMember]
        public string Keywords { get; set; }
        [DataMember]
        public string MemberID { get; set; }
        [DataMember]
        public string Zip { get; set; }
        [DataMember]
        public string Rating { get; set; }
        [DataMember]
        public string Latitude { get; set; }
        [DataMember]
        public string Longitude { get; set; }
        [DataMember]
        public string Path { get; set; }
        [DataMember]
        public string TempCategory { get; set; }
        [DataMember]
        public string RootSeedID { get; set; }
        [DataMember]
        public string ParentSeedID { get; set; }
        [DataMember]
        public string PopularCount { get; set; }


    }


    [DataContract]
    public class MemberInfo
    {
        [DataMember]
        public string MemberID { get; set; }
        [DataMember]
        public string FirstName { get; set; }
        [DataMember]
        public string LastName { get; set; }
        [DataMember]
        public string Organisation { get; set; }
        [DataMember]
        public string Path { get; set; }
        [DataMember]
        public string LocationAddress { get; set; }

    }

    [DataContract]
    public class SeedComment
    {
        [DataMember]
        public string MemberID { get; set; }
        [DataMember]
        public string MemberName { get; set; }

        [DataMember]
        public string CommentMessage { get; set; }
        [DataMember]
        public string Path { get; set; }
        [DataMember]
        public string CommentDate { get; set; }

    }

    [DataContract]
    public class MemberNotification
    {
        [DataMember]
        public string SeedID { get; set; }
        [DataMember]
        public string MemberID { get; set; }

        [DataMember]
        public string MemberName { get; set; }
        [DataMember]
        public string Message { get; set; }
        [DataMember]
        public string CommentDate { get; set; }
        [DataMember]
        public string CommentDesc { get; set; }


    }


    [DataContract]
    public class CompositeType
    {
        bool boolValue = true;
        string stringValue = "Hello ";

        [DataMember]
        public bool BoolValue
        {
            get { return boolValue; }
            set { boolValue = value; }
        }

        [DataMember]
        public string StringValue
        {
            get { return stringValue; }
            set { stringValue = value; }
        }
    }
}
