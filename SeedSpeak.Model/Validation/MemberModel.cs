using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace SeedSpeak.Model.Validation
{
    #region Models
    
    public class MemberModel
    {
        
    }

    public class RegisterModel
    {
        [DisplayName("E-Mail Address")]
        public string LogUserName { get; set; }

        [DataType(DataType.Password)]
        [DisplayName("Password")]
        public string LogPassword { get; set; }

        [Required(ErrorMessage = "E-mail is required")]
        [RegularExpression("^[a-z0-9_\\+-]+(\\.[a-z0-9_\\+-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*\\.([a-z]{2,4})$", ErrorMessage = "Insert valid email address.")]
        [DisplayName("E-Mail Address")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "Password is required")]
        [ValidatePasswordLength(ErrorMessage = "Password must 4 characters long")]
        [DataType(DataType.Password)]
        [DisplayName("Password")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Confirm password is required")]
        [ValidatePasswordLength(ErrorMessage = "Password must 4 characters long")]
        [DataType(DataType.Password)]
        [DisplayName("Confirm Password")]
        public string ConfirmPassword { get; set; }

        [Required(ErrorMessage = "Please provide your first name")]
        [RegularExpression("[a-zA-Z]+", ErrorMessage = "Please insert alphabets only")]
        [DisplayName("First Name")]
        public string FirstName { get; set; }

        [Required(ErrorMessage = "Please provide your last name")]
        [RegularExpression("[a-zA-Z]+", ErrorMessage = "Please insert alphabets only")]
        [DisplayName("Last Name")]
        public string LastName { get; set; }

        [DisplayName("Secret Question")]
        public string SecretQuestion { get; set; }

        [DisplayName("Secret Answer")]
        public string SecretAnswer { get; set; }

        [Required(ErrorMessage = "Captcha is required")]
        public string captcha { get; set; }

        [Required(ErrorMessage = "Please insert e-mail address")]
        [RegularExpression("^[a-z0-9_\\+-]+(\\.[a-z0-9_\\+-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*\\.([a-z]{2,4})$", ErrorMessage = "Insert valid email address.")]
        public string ForgotUserName { get; set; }

        [DisplayName("Organization Name")]
        public string organisationName { get; set; }
    }    

    public class ForgotPasswordModel
    {
        [Required(ErrorMessage = "Please insert username.")]
        [RegularExpression("^[a-z0-9_\\+-]+(\\.[a-z0-9_\\+-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*\\.([a-z]{2,4})$", ErrorMessage = "Insert valid email address.")]
        [DisplayName("UserName")]
        public string UserName { get; set; }
    }    

    public class ProfileModel
    {
        //Privacy
        [DisplayName("View Username")]        
        public string ViewUsername { get; set; }

        [DisplayName("Seed Contribution")]
        public string seedContribution { get; set; }

        [DisplayName("Seed Commitment")]
        public string seedCommitment { get; set; }
                
        [DisplayName("Allow others to view my location")]        
        public bool viewLocation { get; set; }

        [DisplayName("Web Notification")]
        public bool webNotification { get; set; }

        [DisplayName("Device Push")]
        public bool devicePush { get; set; }

        [DisplayName("Email Notification")]
        public bool emailNotification { get; set; }

        [DisplayName("Auto Tweet")]
        public bool autoTweet { get; set; }

        //Personal
        [DataType(DataType.Text)]
        [DisplayName("City")]
        public string City { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("Zip Code")]
        public string ZipCode { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("Latitude")]
        public string Latitude { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("Longitude")]
        public string Longitude { get; set; }

        [DataType(DataType.Text)]
        [DisplayName("Gender")]
        public string Sex { get; set; }

        [DataType(DataType.DateTime)]
        [DisplayName("Date of Birth")]
        public DateTime Dob { get; set; }

        //External Accounts
        [DisplayName("Account Type")]
        public string AccountType { get; set; }

        [DisplayName("User Name")]
        public string Username { get; set; }

        [DisplayName("Password")]
        public string Password { get; set; }

        [DisplayName("Verified")]
        public string Verified { get; set; }

        //update username
        [DisplayName("New Username")]
        public string NewEmail { get; set; }        
        
        // Change Password.
        [DataType(DataType.Password)]
        [DisplayName("Current password")]
        public string OldPassword { get; set; }
                
        [DataType(DataType.Password)]
        [DisplayName("New password")]
        public string NewPassword { get; set; }

        [DataType(DataType.Password)]
        [DisplayName("Confirm new password")]
        public string ConfirmPassword { get; set; }
    }

    #endregion
}
