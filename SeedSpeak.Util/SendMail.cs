using System;
using System.Text;
using System.Collections;
using SeedSpeak.Util;
using System.Net.Mail;
using System.Net;

namespace SeedSpeak.Util
{
    public class SendMail
    {
        #region < VARIABLES >
        private string _emailId;
        private string _ccEmailId;
        private string _subject;
        private string _msgBody;
        private ArrayList _changesInMessage;
        private ArrayList _changesInSubject;
        #endregion

        #region  <PROPERTIES>
        public string ToEmailId
        {
            get
            {
                if (_emailId == null)
                {
                    return "";
                }
                return _emailId;
            }
            set { _emailId = value; }
        }


        public string CCEmailId
        {
            get
            {
                if (_ccEmailId == null)
                {
                    return "";
                }
                return _ccEmailId;
            }
            set { _ccEmailId = value; }
        }


        public string Subject
        {
            get
            {
                return _subject;
            }
            set
            {
                _subject = value;
            }
        }
        public string MsgBody
        {
            get
            {
                return _msgBody;
            }
            set
            {
                _msgBody = value;
            }
        }

        public ArrayList ChangesInMessage
        {
            get
            {
                return _changesInMessage;
            }
            set
            {
                _changesInMessage = value;
            }
        }

        public ArrayList ChagesInSubject
        {
            get
            {
                return _changesInSubject;
            }
            set
            {
                _changesInSubject = value;
            }
        }

        #endregion

        public bool SendEmail(SendMail obj)
        {
            
            SeedSpeakMail.getCommonTypeTable();

            System.Net.Mail.MailMessage objMailMessage = new System.Net.Mail.MailMessage();
            System.Net.Mail.SmtpClient objSmtpClient = new System.Net.Mail.SmtpClient();

            string mailTo = obj.ToEmailId.ToString();
            string mailFrom = System.Configuration.ConfigurationManager.AppSettings["mailFrom"].ToString();
            string smtpHost = System.Configuration.ConfigurationManager.AppSettings["smtpHost"].ToString();
            string authUserId = System.Configuration.ConfigurationManager.AppSettings["EmailUserId"].ToString();
            string authPwd = System.Configuration.ConfigurationManager.AppSettings["EmailPassword"].ToString();

            string subject = SeedSpeakMail.getKeyValue(obj._subject);

            if (obj._changesInSubject != null && obj._changesInSubject.Count > 0)
            {
                for (int ctr = 0; ctr < obj._changesInSubject.Count; ctr++)
                {
                    string oldval = "#" + (ctr + 1) + "#";
                    string newval = (string)obj._changesInSubject[ctr];
                    subject = subject.Replace(oldval, newval);
                }
            }

            string message = SeedSpeakMail.getKeyValue(obj._msgBody);

            if(obj._changesInMessage !=null && obj._changesInMessage.Count>0)
            {
                for (int ctr = 0; ctr < obj._changesInMessage.Count; ctr++)
                {
                    string oldval = "#" + (ctr + 1) + "#";
                    string newval = (string)obj._changesInMessage[ctr];
                    message = message.Replace(oldval, newval);
                }
            }

            NetworkCredential SMTPUserInfo = new NetworkCredential(authUserId, authPwd);
            objSmtpClient.UseDefaultCredentials = false;
            objSmtpClient.Credentials = SMTPUserInfo;

            objMailMessage.From = new MailAddress(mailFrom);
            objMailMessage.To.Add(mailTo);

            if (obj.CCEmailId != null && obj.CCEmailId.Length > 0)
            {
                objMailMessage.CC.Add(obj.CCEmailId.ToString());
            }

            objMailMessage.Subject = subject;

            objSmtpClient.Port = 587;
            objSmtpClient.EnableSsl = false;
            objSmtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;

            objMailMessage.IsBodyHtml = true;


            objMailMessage.Body = message;
            objSmtpClient.Host = smtpHost;

            try
            {
                objSmtpClient.Send(objMailMessage);

                return (true);
            }
            catch (Exception)
            {
                return (false);
            }

        }
    }
}
