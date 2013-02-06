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
    public class MemberAction : AbstractAction
    {
        Repository repoObj = new Repository();

        /// <summary>
        /// Method to signup for new users.
        /// </summary>
        /// <param name="rmodel"></param>
        /// <returns></returns>
        public bool Signup(RegisterModel rmodel)
        {
            #region Business Logic

            bool actionCompleted = false;
            Member member = null;
            try
            {
                member = new Member();
                member.id = Guid.NewGuid();
                member.username = rmodel.UserName;
                member.passwd = Security.Encrypt(rmodel.Password, true);
                member.firstName = rmodel.FirstName;
                member.lastName = rmodel.LastName;
                member.secretQ = rmodel.SecretQuestion;
                member.secretA = rmodel.SecretAnswer;
                member.status = SystemStatements.STATUS_ACTIVE;
                member.created = DateTime.Now;
                member.roleId = repoObj.List<Role>(x => x.name == SystemStatements.ROLE_END_USER).FirstOrDefault().id;
                member.isVerified = false;
                member.organisationName = rmodel.organisationName;
                member.Email = rmodel.UserName;
                repoObj.Create<Member>(member);

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
        /// Method to signup for new users via facebook.
        /// </summary>
        /// <param name="rmodel"></param>
        /// <returns></returns>
        public bool FBSignup(string userName, string fname, string lname, string email)
        {
            #region Business Logic
            bool actionCompleted = false;
            Member member = null;
            try
            {
                member = new Member();
                member.id = Guid.NewGuid();
                member.username = userName;
                member.firstName = fname;
                member.lastName = lname;
                member.status = SystemStatements.STATUS_ACTIVE;
                member.created = DateTime.Now;
                member.roleId = repoObj.List<Role>(x => x.name == SystemStatements.ROLE_END_USER).FirstOrDefault().id;
                member.isVerified = false;
                member.Email = email;
                repoObj.Create<Member>(member);

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
        /// Method to signup for new users.
        /// </summary>
        /// <param name="rmodel"></param>
        /// <returns></returns>
        public string MobileSignup(RegisterModel rmodel)
        {
            #region Business Logic

            string result = "";
            Member member = null;
            try
            {
                member = new Member();
                member.id = Guid.NewGuid();
                member.username = rmodel.UserName;
                member.passwd = Security.Encrypt(rmodel.Password, true);
                member.firstName = rmodel.FirstName;
                member.lastName = rmodel.LastName;
                member.secretQ = rmodel.SecretQuestion;
                member.secretA = rmodel.SecretAnswer;
                member.status = SystemStatements.STATUS_ACTIVE;
                member.created = DateTime.Now;
                member.roleId = repoObj.List<Role>(x => x.name == SystemStatements.ROLE_END_USER).FirstOrDefault().id;
                member.isVerified = false;
                member.organisationName = rmodel.organisationName;
                repoObj.Create<Member>(member);

                result = member.id.ToString();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return result;

            #endregion
        }

        /// <summary>
        /// Method to Authenticate the User.
        /// </summary>
        /// <param name="username"></param>
        /// <param name="passwd"></param>
        /// <returns></returns>
        public Member Authenticate(string username, string passwd)
        {
            #region Business Logic

            Member member = null;
            try
            {
                string dbPass = Security.Encrypt(passwd, true);
                member = repoObj.List<Member>(x => x.username.Equals(username.Trim()) && x.passwd.Equals(dbPass) && x.status.Equals(SystemStatements.STATUS_ACTIVE)).FirstOrDefault();

                if (member != null)
                {
                    //Stores logged in member to session
                    //Change member lastlogin to current datetime
                    member.lastLogin = DateTime.Now;
                    repoObj.Update<Member>(member);
                }

                //check username and passwd and active member
                //if exists - update last login
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return member;

            #endregion
        }        

        /// <summary>
        /// Method to Manage Member Profile.
        /// </summary>
        /// <param name="cityName"></param>
        /// <param name="zipcode"></param>
        /// <param name="localLat"></param>
        /// <param name="localLong"></param>
        /// <param name="regionName"></param>
        /// <param name="sex"></param>
        /// <param name="dob"></param>
        /// <returns></returns>
        public bool ManageMemberProfile(Member member, string cityId, string zipcode, double localLat, double localLong, string sex, DateTime dob, string url, string bio)
        {
            #region Business Logic
            bool actionCompleted = false;
            try
            {

                LocationAction lrepo = new LocationAction();
                //Get the location 
                Location location = lrepo.CreateLocation(cityId, zipcode, localLat, localLong, "");

                //Updates the member profile
                this.UpdateMemberProfile(member, sex, dob, location, url, bio);
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
        /// Method to Update Member profile.
        /// </summary>
        /// <param name="member"></param>
        /// <param name="sex"></param>
        /// <param name="dob"></param>
        /// <param name="location"></param>
        /// <returns></returns>
        public bool UpdateMemberProfile(Member member, string sex, DateTime dob, Location location, string url, string bio)
        {
            #region Business Logic

            bool updated = false;
            try
            {
                //see if member.MemberProfile is empty
                //if empty create new
                //if exists, update

                MemberProfile memberProfileData = repoObj.List<MemberProfile>(x => x.Member.id.Equals(member.id)).FirstOrDefault();

                if (memberProfileData == null)
                {
                    memberProfileData = new MemberProfile();
                    memberProfileData.id = Guid.NewGuid();
                    memberProfileData.locationId = location.id;
                    memberProfileData.memberId = member.id;
                    memberProfileData.sex = sex;
                    memberProfileData.setURL = url;
                    memberProfileData.bio = bio;
                    repoObj.Create<MemberProfile>(memberProfileData);
                }
                else
                {
                    memberProfileData.sex = sex;
                    memberProfileData.locationId = location.id;
                    memberProfileData.setURL = url;
                    memberProfileData.bio = bio;
                    repoObj.Update<MemberProfile>(memberProfileData);
                }
                updated = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }


        /// <summary>
        /// Method to check if member exist or not.
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public bool FindByUserName(string userName)
        {
            #region Business Logic
            bool IsUserExist = false;
            try
            {
                Member member = repoObj.List<Member>(x => x.username.Equals(userName.Trim())).FirstOrDefault();

                if (member != null)
                {
                    IsUserExist = true;
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return IsUserExist;
            #endregion
        }

        /// <summary>
        /// Method for Change Member Password.
        /// </summary>
        /// <param name="member"></param>
        /// <param name="newPasswd"></param>
        /// <returns></returns>
        public bool ChangeMemberPasswd(Member member, string newPassword)
        {
            #region Business Logic
            bool updated = false;
            try
            {
                //Get the current member object from session                
                member.passwd = Security.Encrypt(newPassword, true);
                repoObj.Update<Member>(member);
                updated = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Check if old Password Match.
        /// </summary>
        /// <param name="oldPassword"></param>
        /// <returns></returns>
        public bool CheckOldPassword(Member member, string oldPassword)
        {
            #region Business Logic
            bool IsAuthenticate = false;
            //Get the current member object from session
            try
            {
                if (Security.Encrypt(oldPassword, true).Equals(member.passwd))
                {
                    IsAuthenticate = true;
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return IsAuthenticate;

            #endregion
        }

        /// <summary>
        /// Method for Get All Member
        /// </summary>
        /// <returns></returns>

        public IList<Member> GetAllMember()
        {
            #region Business Logic

            IList<Member> memberList = null;
            try
            {
                Guid useRoleId = repoObj.List<Role>(x => x.name == SystemStatements.ROLE_END_USER).FirstOrDefault().id;

                memberList = repoObj.List<Member>(x => x.Role.id.Equals(useRoleId)).OrderBy(x => x.firstName).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return memberList;

            #endregion
        }

        /// <summary>
        /// Method to manage External Members.
        /// </summary>
        /// <param name="externalAccount"></param>
        /// <returns></returns>
        public bool ManageExternalAccount(Member member, ExternalAccount externalAccount)
        {
            #region Business Logic

            bool actionCompleted = false;
            try
            {
                ExternalAccount externalAccountData = null;

                //see if ExternalAccount exists
                externalAccountData = repoObj.List<ExternalAccount>(x => x.accountTye.Equals(externalAccount.accountTye) && x.username.Equals(externalAccount.username)).FirstOrDefault();
                if (externalAccountData != null)
                {
                    externalAccountData.passwd = externalAccountData.passwd;

                    repoObj.Update<ExternalAccount>(externalAccountData);
                }
                else
                {
                    externalAccountData = new ExternalAccount();
                    externalAccountData.id = Guid.NewGuid();
                    externalAccountData.accountTye = externalAccount.accountTye;
                    externalAccountData.username = externalAccount.username;
                    externalAccountData.passwd = externalAccount.passwd;
                    externalAccountData.verified = false;
                    externalAccountData.memberId = member.id;

                    repoObj.Create<ExternalAccount>(externalAccountData);
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
        /// Method to Manage Member Privacy.
        /// </summary>
        /// <param name="privacy"></param>
        /// <returns></returns>
        public bool ManageMemberPrivacy(Member member, Privacy privacy)
        {
            #region Business Logic

            bool actionCompleted = false;
            try
            {
                Privacy privacyData = null;

                //see if Privacy Setting exists

                privacyData = repoObj.List<Privacy>(x => x.Member.id.Equals(member.id)).FirstOrDefault();

                if (privacyData != null)
                {
                    privacyData.viewUsername = privacy.viewUsername;
                    privacyData.seedContribution = privacy.seedContribution;
                    privacyData.seedCommitment = privacy.seedCommitment;
                    privacyData.viewLocation = privacy.viewLocation;
                    privacyData.webNotification = privacy.webNotification;
                    privacyData.devicePush = privacy.devicePush;
                    privacyData.emailNotification = privacy.emailNotification;
                    privacyData.autoTweet = privacy.autoTweet;

                    repoObj.Update<Privacy>(privacyData);
                }
                else
                {
                    privacyData = new Privacy();
                    privacyData.id = Guid.NewGuid();
                    privacyData.memberId = member.id;
                    privacyData.viewUsername = privacy.viewUsername;
                    privacyData.seedContribution = privacy.seedContribution;
                    privacyData.seedCommitment = privacy.seedCommitment;
                    privacyData.viewLocation = privacy.viewLocation;
                    privacyData.webNotification = privacy.webNotification;
                    privacyData.devicePush = privacy.devicePush;
                    privacyData.emailNotification = privacy.emailNotification;
                    privacyData.autoTweet = privacy.autoTweet;

                    repoObj.Create<Privacy>(privacyData);
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
        /// Method to get password for forgot password.
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public string GetPwdByUserName(string user)
        {
            #region Business Logic
            string pwd = "";
            try
            {
                Member member = repoObj.List<Member>(x => x.username.Equals(user.Trim())).FirstOrDefault();

                if (member != null)
                {
                    pwd = Security.Decrypt(member.passwd.ToString(), true);
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return pwd;
            #endregion
        }

        /// <summary>
        /// Method to verify account
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public bool VerifyAcount(string userid)
        {
            #region Business Logic

            bool updated = false;
            try
            {
                Member member = repoObj.List<Member>(x => x.username.Equals(userid.Trim())).FirstOrDefault();

                if (member != null)
                {
                    member.isVerified = true;
                    repoObj.Update<Member>(member);
                }
                updated = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to get external accounts list
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public IList<ExternalAccount> GetExternalAccountsList(string userId)
        {
            #region Business Logic

            IList<ExternalAccount> ExtAcntList = null;
            try
            {
                ExtAcntList = repoObj.List<ExternalAccount>(x => x.Member.id.Equals(new Guid(userId))).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return ExtAcntList;

            #endregion
        }

        /// <summary>
        /// Method to update username
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public bool UpdateUserName(string username, string id)
        {
            #region Business Logic

            bool updated = false;
            try
            {
                Member member = repoObj.List<Member>(x => x.id.Equals(new Guid(id))).FirstOrDefault();

                if (member != null)
                {
                    member.username = username;
                    repoObj.Update<Member>(member);
                }
                updated = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to update organization
        /// </summary>
        /// <param name="org"></param>
        /// <returns></returns>
        public bool UpdateOrganization(string org, string id)
        {
            #region Business Logic

            bool updated = false;
            try
            {
                Member member = repoObj.List<Member>(x => x.id.Equals(new Guid(id))).FirstOrDefault();

                if (member != null)
                {
                    member.organisationName = org;
                    repoObj.Update<Member>(member);
                }
                updated = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to upload profile image
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        public bool UploadProfileImage(Member member, string imagePath)
        {
            #region Business Logic

            bool updated = false;
            try
            {
                //see if member.MemberProfile is empty
                //if empty create new
                //if exists, update

                MemberProfile memberProfileData = repoObj.List<MemberProfile>(x => x.Member.id.Equals(member.id)).FirstOrDefault();

                if (memberProfileData == null)
                {
                    memberProfileData = new MemberProfile();
                    memberProfileData.id = Guid.NewGuid();
                    memberProfileData.memberId = member.id;
                    memberProfileData.imagePath = imagePath;
                    repoObj.Create<MemberProfile>(memberProfileData);
                }
                else
                {
                    memberProfileData.imagePath = imagePath;
                    repoObj.Update<MemberProfile>(memberProfileData);
                }
                updated = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Get Member using Member ID.
        /// </summary>
        /// <param name="MemberId"></param>
        /// <returns></returns>
        public Member GetMemberByMemberId(string MemberId)
        {
            #region Business Logic

            Member member = null;
            try
            {
                //see if Member exists
                //if exists return it
                member = repoObj.List<Member>(x => x.id.Equals(new Guid(MemberId))).FirstOrDefault();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return member;

            #endregion
        }

        /// <summary>
        /// Method to update member.
        /// </summary>
        /// <param name="member"></param>
        /// <returns></returns>
        public bool UpdateMember(Member member)
        {
            #region Business Logic
            bool isUpdated = false;
            try
            {
                repoObj.Update<Member>(member);
                isUpdated = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return isUpdated;
            #endregion
        }

        /// <summary>
        /// Method to get privacy data by member id
        /// </summary>
        /// <param name="MemberId"></param>
        /// <returns></returns>
        public Privacy GetPrivacyByMemberId(Guid MemberId)
        {
            #region Business Logic

            Privacy privacy = null;
            try
            {
                //see if Member exists
                //if exists return it
                privacy = repoObj.List<Privacy>(x => x.Member.id.Equals(MemberId)).FirstOrDefault();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return privacy;

            #endregion
        }

        /// <summary>
        /// Update Members Comments
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool UpdateMemberComments(Guid id)
        {
            #region Business Logic

            bool updated = false;
            try
            {
                Comment memberCommentsData = repoObj.List<Comment>(x => x.id.Equals(id)).FirstOrDefault();
                memberCommentsData.id = id;
                memberCommentsData.isRead = true;
                repoObj.Update<Comment>(memberCommentsData);
                updated = true;

            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to Update commitments by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool UpdateMemberCommitments(Guid id)
        {
            #region Business Logic

            bool updated = false;
            try
            {
                Commitment memberData = repoObj.List<Commitment>(x => x.id.Equals(id)).FirstOrDefault();
                memberData.id = id;
                memberData.isRead = true;
                repoObj.Update<Commitment>(memberData);
                updated = true;

            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to update member flags by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool UpdateMemberFlags(Guid id)
        {
            #region Business Logic

            bool updated = false;
            try
            {
                Flag memberData = repoObj.List<Flag>(x => x.id.Equals(id)).FirstOrDefault();
                memberData.id = id;
                memberData.isRead = true;
                repoObj.Update<Flag>(memberData);
                updated = true;

            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to update likes by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool UpdateMemberLikes(Guid id)
        {
            #region Business Logic

            bool updated = false;
            try
            {
                Rating memberData = repoObj.List<Rating>(x => x.id.Equals(id)).FirstOrDefault();
                memberData.id = id;
                memberData.isRead = true;
                repoObj.Update<Rating>(memberData);
                updated = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to update member info
        /// </summary>
        /// <param name="memData"></param>
        /// <returns></returns>
        public bool UpdateMemberInfoByService(Member memData)
        {
            #region Business Logic

            Member memberData = GetMemberByMemberId(memData.id.ToString());

            bool updated = false;
            try
            {
                memberData.firstName = memData.firstName;
                memberData.lastName = memData.lastName;
                memberData.organisationName = memData.organisationName;

                repoObj.Update<Member>(memberData);
               
                updated = true;
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return updated;
            #endregion
        }

        /// <summary>
        /// Method to get member object by username
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public Member GetMemberByUsername(string userName)
        {
            #region Business Logic
            Member member = null;
            try
            {
                member = repoObj.List<Member>(x => x.username.Equals(userName)).FirstOrDefault();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return member;
            #endregion
        }

        /// <summary>
        /// Method to get member object by email
        /// </summary>
        /// <param name="fbEmail"></param>
        /// <returns></returns>
        public Member GetMemberByFbEmail(string fbEmail)
        {
            #region Business Logic
            Member member = null;
            try
            {
                member = repoObj.List<Member>(x => x.Email.Equals(fbEmail)).FirstOrDefault();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return member;
            #endregion
        }

        /// <summary>
        /// Method to get member object by name
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public IList<Member> GetMembersByName(string name)
        {
            #region Business Logic
            IList<Member> member = null;
            try
            {
                member = repoObj.List<Member>(x => x.firstName.Contains(name) || x.lastName.Contains(name) || x.username.Contains(name) || x.organisationName.Contains(name)).ToList();
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return member;
            #endregion
        }

        /// <summary>
        /// Method to get followers by member id
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public IList<Member> GetFollowers(string memberId)
        {
            #region Business Logic
            Guid id = new Guid(memberId);
            IList<FollowPeople> followerList = null;
            IList<Member> memberList = new List<Member>();
            
            try
            {
                followerList = repoObj.List<FollowPeople>(x => x.Member1.id.Equals(id)).ToList();
                foreach (var fl in followerList)
                {
                    Member mem = new Member();
                    mem = repoObj.List<Member>(x => x.id.Equals(fl.Member.id)).FirstOrDefault();
                    memberList.Add(mem);
                }                
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return memberList;

            #endregion
        }

        /// <summary>
        /// Method to get members user is following
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public IList<Member> GetFollowing(string memberId)
        {
            #region Business Logic
            Guid id = new Guid(memberId);
            IList<FollowPeople> followerList = null;
            IList<Member> memberList = new List<Member>();

            try
            {
                followerList = repoObj.List<FollowPeople>(x => x.Member.id.Equals(id)).ToList();
                foreach (var fl in followerList)
                {
                    Member mem = new Member();
                    mem = repoObj.List<Member>(x => x.id.Equals(fl.Member1.id)).FirstOrDefault();
                    memberList.Add(mem);
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return memberList;

            #endregion
        }

        /// <summary>
        /// Method to get activity done by following members
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public IList<Seed> GetFollowingActivity(string memberId)
        {
            #region Business Logic
            Guid id = new Guid(memberId);
            IList<FollowPeople> followingList = null;
            IList<Seed> seedList = new List<Seed>();
            try
            {
                followingList = repoObj.List<FollowPeople>(x => x.Member.id.Equals(id)).ToList();
                foreach (var fl in followingList)
                {
                    IList<Seed> lst = new List<Seed>();
                    lst = repoObj.List<Seed>(x => x.Member.id.Equals(fl.Member1.id) && (x.status.Equals(SystemStatements.STATUS_NEW) || x.status.Equals(SystemStatements.STATUS_GROWING))).ToList();
                    foreach (Seed sData in lst)
                    {
                        seedList.Add(sData);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            //return memberList;
            return seedList.OrderByDescending(x => x.createDate).ToList();
            #endregion
        }

        /// <summary>
        /// Method to get members by zip
        /// </summary>
        /// <param name="zip"></param>
        /// <returns></returns>
        public IList<Member> GetMembersByZip(string zip)
        {
            #region Business Logic
            IList<Member> memberData = new List<Member>();
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
                    if (loc.MemberProfiles.FirstOrDefault() != null)
                    {
                        if (loc.MemberProfiles.FirstOrDefault().Member != null)
                            memberData.Add(loc.MemberProfiles.FirstOrDefault().Member);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return memberData;
            #endregion
        }

        /// <summary>
        /// Method to follow or unfollow members
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="followingId"></param>
        /// <param name="action"></param>
        /// <returns></returns>
        public bool FollowOrUnFollowPeople(string memberId, string followingId, string action)
        {
            #region Business Logic
            bool actionCompleted = false;            
            try
            {
                //if (action == "Follow")
                if (action == SystemStatements.FOLLOW_PEOPLE)
                {
                    FollowPeople follow = null;
                    follow = new FollowPeople();
                    follow.id = Guid.NewGuid();
                    follow.memberId = new Guid(memberId);
                    follow.followingId = new Guid(followingId);
                    repoObj.Create<FollowPeople>(follow);
                    actionCompleted = true;
                }
                //if (action == "Unfollow")
                if (action == SystemStatements.UNFOLLOW_PEOPLE)
                {
                    FollowPeople follow = repoObj.List<FollowPeople>(x => x.Member.id.Equals(new Guid(memberId)) && x.Member1.id.Equals(new Guid(followingId))).FirstOrDefault();
                    repoObj.Delete<FollowPeople>(follow);
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
        /// Method to like or unlike posts
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="seedId"></param>
        /// <param name="action"></param>
        /// <returns></returns>
        public bool LikeUnlike(string memberId, string seedId, string action)
        {
            #region Business Logic
            bool actionCompleted = false;
            try
            {
                if (action == "Like")
                {
                    Rating objRating = new Rating();
                    objRating.id = Guid.NewGuid();
                    objRating.likes = "Like";
                    objRating.seedId = new Guid(seedId);
                    objRating.memberId = new Guid(memberId);
                    objRating.isRead = false;
                    objRating.ratingDate = DateTime.Now;                    
                    repoObj.Create<Rating>(objRating);
                    actionCompleted = true;
                }                
                if (action == "Dislike")
                {
                    Rating objRating = repoObj.List<Rating>(x => x.memberId == new Guid(memberId) && x.seedId == new Guid(seedId)).FirstOrDefault();
                    repoObj.Delete<Rating>(objRating);
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
        /// Method to mute or unmute members
        /// </summary>
        /// <param name="memberId"></param>
        /// <param name="muteId"></param>
        /// <param name="action"></param>
        /// <returns></returns>
        public bool MuteOrUnMutePeople(string memberId, string muteId, string action)
        {
            #region Business Logic
            bool actionCompleted = false;
            try
            {
                if (action == SystemStatements.MUTE_PEOPLE)
                {
                    MutePeople mute = new MutePeople();
                    mute.id = Guid.NewGuid();
                    mute.memberId = new Guid(memberId);
                    mute.muteId = new Guid(muteId);
                    repoObj.Create<MutePeople>(mute);
                    actionCompleted = true;
                }

                if (action == SystemStatements.UNMUTE_PEOPLE)
                {
                    MutePeople mute = repoObj.List<MutePeople>(x => x.Member.id.Equals(new Guid(memberId)) && x.Member1.id.Equals(new Guid(muteId))).FirstOrDefault();
                    repoObj.Delete<MutePeople>(mute);
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
        /// Method to retrive password
        /// </summary>
        /// <param name="username"></param>
        /// <returns></returns>
        public bool ForgotPassword(string username)
        {
            MemberAction objMember = new MemberAction();
            string memberPwd = objMember.GetPwdByUserName(username);
            if (!string.IsNullOrEmpty(memberPwd))
            {
                //send automated email - content of email will be decided later
                // Creating array list for token 
                ArrayList arrTokens = new ArrayList();
                arrTokens.Add(username);
                arrTokens.Add(memberPwd);

                // Filling mail object
                SendMail objSendMail = new SendMail();
                objSendMail.ToEmailId = username;
                objSendMail.Subject = "email.forget.password.subject.content";
                objSendMail.MsgBody = "email.forget.password.body.content";
                objSendMail.ChangesInMessage = arrTokens;
                objSendMail.SendEmail(objSendMail);//SendMail.(member.username, SystemStatements.DEFAUL_EMAIL_ADDRESS, SystemStatements.EMAIL_SUBJECT_SIGNUP, "");
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Method to get list of mute members
        /// </summary>
        /// <param name="memberId"></param>
        /// <returns></returns>
        public IList<Member> GetMuteMembersByMemberId(string memberId)
        {
            #region Business Logic
            Guid id = new Guid(memberId);
            IList<MutePeople> MuteList = null;
            IList<Member> memberList = new List<Member>();

            try
            {
                MuteList = repoObj.List<MutePeople>(x => x.Member.id.Equals(id)).ToList();
                foreach (var ml in MuteList)
                {
                    Member mem = new Member();
                    mem = repoObj.List<Member>(x => x.id.Equals(ml.Member.id)).FirstOrDefault();
                    memberList.Add(mem);
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return memberList;

            #endregion
        }

        /// <summary>
        /// Method to check if url exist or not.
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public bool FindByURL(string url)
        {
            #region Business Logic
            bool IsURLExist = false;
            try
            {
                IList<Member> lstMember = repoObj.List<Member>(x => x.MemberProfiles.FirstOrDefault() != null).ToList();
                foreach (Member mem in lstMember)
                {
                    if (mem.MemberProfiles.FirstOrDefault() != null)
                    {
                        if (!string.IsNullOrEmpty(mem.MemberProfiles.FirstOrDefault().setURL))
                        {
                            string existingURL = mem.MemberProfiles.FirstOrDefault().setURL;
                            if (existingURL == "www.seedspeak.com/" + url)
                            {
                                IsURLExist = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return IsURLExist;
            #endregion
        }

        /// <summary>
        /// Method to get by profile url.
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public string FindUserIdByURL(string url)
        {
            #region Business Logic
            string URL_ID = string.Empty;
            string findURL = "www.seedspeak.com/" + url;
            try
            {
                MemberProfile memberProfile = repoObj.List<MemberProfile>(x => x.setURL.Equals(findURL)).FirstOrDefault();
                if (memberProfile != null)
                {
                    URL_ID = memberProfile.memberId.ToString();
                }
            }
            catch (Exception ex)
            {
                WriteError(ex);
            }
            return URL_ID;
            #endregion
        }
    }
}
