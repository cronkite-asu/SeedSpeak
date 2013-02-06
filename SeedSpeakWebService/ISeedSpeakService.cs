using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using SeedSpeak.Model;

namespace SeedSpeakWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface ISeedSpeakService
    {
        [OperationContract]
        string GetData(int value);

        [OperationContract]
        CompositeType GetDataUsingDataContract(CompositeType composite);
        
        [OperationContract]
        string MemberAuthenticate(string UserName, string Password);

        [OperationContract]
        string MemberSignup(string UserName, string Password, string FirstName, string LastName, string OrganisationName);

        [OperationContract]
        string AddSeedData(string SeedName, string Description, string CityName, string Street, string RegionCode, string LatLong, string ZipCode, string ownerId, string tagName, string imageName, string categoryNames);

        [OperationContract]
        string GetAllSeedsByMemberId(string MemberId,string counter);

        [OperationContract]
        string GetSeedsById(string SeedId, string MemberId);

        [OperationContract]
        string GetSeedByMemberLocation(string MemberId);

        [OperationContract]
        int GetTotalSeedsByMemberId(string MemberId);

        [OperationContract]
        string HarvestTerminateSeed(string seedId, string Action);

        [OperationContract]
        string UpdateSeed(string seedId, string seedName, string seedDescription, string SeedTags, string categories, string imageName, string ownerId);

        [OperationContract]
        bool ChangeMemberPasswd(string memberId, string newPassword);        

        [OperationContract]
        string ForgetPassword(string userName);

        [OperationContract]
        string SendMail();

        [OperationContract]
        string AddMedia(string title, string imgName, string seedId, string fileType, string memberId);

        [OperationContract]
        string GetVotesById(string SeedId);

        [OperationContract]
        string GetCommitmentsById(string SeedId);

        [OperationContract]
        string GetCommentsById(string SeedId);

        [OperationContract]
        string GetAllCategories();

        [OperationContract]
        string GetMemberInfoById(string memId);

        [OperationContract]
        bool addComment(string seedId, string memberId, string commentMsg);

        [OperationContract]
        bool addCommitment(string seedId, string memberId, string commitmentDate, string commitmentMsg);

        [OperationContract]
        string addRating(string seedId, string memberId, string rate);

        [OperationContract]
        string GetAllMySeeds(string MemberId);

        [OperationContract]
        string SearchSeeds(string Criteria, string sortBy, string radius,string counter);

        [OperationContract]
        string GetUserById(string MemberId);

        [OperationContract]
        bool UpdateMember(string memberId, string fName, string lName, string orgName, string imageName);

        [OperationContract]
        string getAllNotificationsByMemberId(string memberId);

        [OperationContract]
        [WebInvoke(Method = "GET", BodyStyle = WebMessageBodyStyle.Wrapped, ResponseFormat = WebMessageFormat.Json)]
        [return: MessageParameter(Name = "data")]
        mem GetAll();

        // TODO: Add your service operations here
    }

    
      
    

    // Use a data contract as illustrated in the sample below to add composite types to service operations.
    [DataContract]
    public class mem
    {
        
        string name;
 
        [DataMember]
        public string Name
        {
            get { return name; }
            set { name = value; }
        }


    }

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
