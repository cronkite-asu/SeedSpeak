using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Net;
using System.IO;
using System.Xml;
using System.Text.RegularExpressions;

namespace SeedSpeak.Util
{
    public class CommonMethods
    {
        public string GetZipByRadius(string Radius, string Zip)
        {
            #region
            string URL = "http://www.zip-codes.com/zip-code-radius-finder.asp?zipMilesLow=0&zipMilesHigh=" + Radius + "&zip1=" + Zip + "&Submit=Search";

            DataTable SiteResult = new DataTable();
            string webStreamData = string.Empty;
            string ResultZip = "";

            try
            {
                // prepare the web page we will be asking for
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);

                // execute the request
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                // we will read data via the response stream
                Stream webStream = response.GetResponseStream();

                //read responce text
                StreamReader webReader = new StreamReader(webStream);

                webStreamData = webReader.ReadToEnd();
               // webStreamData = System.Web.HttpContext.Current.Server.HtmlEncode(webStreamData);

                webStreamData = System.Web.HttpUtility.HtmlEncode(webStreamData);

                

                string zipCode = string.Empty;

                int Cpos = 0;  
                int Zpos = 0;
                int x = 0;
                try
                {
                    while (Cpos != -1)
                    {
                        x++;
                        Cpos = webStreamData.IndexOf("&lt;/b&gt;&lt;br&gt;", Cpos + 20);
                        if (Cpos == -1)
                            break;
                        if (x == 1)
                        {
                            zipCode = webStreamData.Substring(Cpos + 29, 5);
                            ResultZip += "'" + zipCode + "'";
                        }
                        if (x == 1)
                            continue;

                        Zpos = webStreamData.IndexOf("&amp;zip2=", Cpos);

                        zipCode = webStreamData.Substring(Zpos + 10, 5);

                        ResultZip += ",'" + zipCode + "'";
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return ResultZip;
            #endregion
        }

        public string GetZipByRadiusNew(string Radius, string Zip)
        {
            #region
            string URL = "http://www.zip-codes.com/zip-code-radius-finder.asp?zipMilesLow=0&zipMilesHigh=" + Radius + "&zip1=" + Zip + "&Submit=Search";

            DataTable SiteResult = new DataTable();
            string webStreamData = string.Empty;
            string ResultZip = "";

            try
            {
                // prepare the web page we will be asking for
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);

                // execute the request
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                // we will read data via the response stream
                Stream webStream = response.GetResponseStream();

                //read responce text
                StreamReader webReader = new StreamReader(webStream);

                webStreamData = webReader.ReadToEnd();
                // webStreamData = System.Web.HttpContext.Current.Server.HtmlEncode(webStreamData);

                webStreamData = System.Web.HttpUtility.HtmlEncode(webStreamData);



                string zipCode = string.Empty;

                int Cpos = 0;
                int Zpos = 0;
                int x = 0;
                try
                {
                    Cpos = webStreamData.IndexOf("var json = ", Cpos + 20);
                    while (Cpos != -1)
                    {
                        x++;
                        if (Zpos == -1)
                            break;
                        if (Cpos == -1)
                            break;
                        if (x == 1)
                        {
                            Cpos = webStreamData.IndexOf("zip1=", Cpos);
                            zipCode = webStreamData.Substring(Cpos + 29, 5);
                            ResultZip += "'" + zipCode + "'";
                        }
                        if (x == 1)
                            continue;

                        Zpos = webStreamData.IndexOf("&amp;zip2=", Cpos);

                        zipCode = webStreamData.Substring(Zpos + 10, 5);
                        Cpos = Zpos + 15;

                        ResultZip += ",'" + zipCode + "'";
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return ResultZip;
            #endregion
        }

        public DataTable GetZipListByRadius(string Radius, string Zip)
        {
            #region
            string URL = "http://www.zip-codes.com/zip-code-radius-finder.asp?zipMilesLow=0&zipMilesHigh=" + Radius + "&zip1=" + Zip + "&Submit=Search";

            DataTable returnZipList = new DataTable();
            string webStreamData = string.Empty;
            try
            {


                // prepare the web page we will be asking for
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);

                // execute the request
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                // we will read data via the response stream
                Stream webStream = response.GetResponseStream();

                //read responce text
                StreamReader webReader = new StreamReader(webStream);

                webStreamData = webReader.ReadToEnd();
                webStreamData = System.Web.HttpUtility.HtmlEncode(webStreamData);

               // RetResult = FetchData(webStreamData);

              
                returnZipList.Columns.Add("Id");
                returnZipList.Columns.Add("Zip");

                string zipCode = string.Empty;

                int Cpos = 0;
                int Zpos = 0;
                int x = 0;
                try
                {
                    while (Cpos != -1)
                    {
                        x++;
                        Cpos = webStreamData.IndexOf("&lt;/b&gt;&lt;br&gt;", Cpos + 20);
                        if (Cpos == -1)
                            break;
                        if (x == 1)
                        {
                            zipCode = webStreamData.Substring(Cpos + 29, 5);

                            DataRow myNewRow1;
                            myNewRow1 = returnZipList.NewRow();
                            myNewRow1["Id"] = x;
                            myNewRow1["Zip"] = zipCode;

                            returnZipList.Rows.Add(myNewRow1);
                        }
                        if (x == 1)
                            continue;

                        Zpos = webStreamData.IndexOf("&amp;zip2=", Cpos);

                        zipCode = webStreamData.Substring(Zpos + 10, 5);

                        DataRow myNewRow;
                        myNewRow = returnZipList.NewRow();
                        myNewRow["Id"] = x;                  
                        myNewRow["Zip"] = zipCode;

                        returnZipList.Rows.Add(myNewRow);
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return returnZipList;
            #endregion
        }

        public DataTable GetZipListByRadiusNew(string Radius, string Zip)
        {
            #region
            string URL = "http://www.zip-codes.com/zip-code-radius-finder.asp?zipMilesLow=0&zipMilesHigh=" + Radius + "&zip1=" + Zip + "&Submit=Search";

            DataTable returnZipList = new DataTable();
            string webStreamData = string.Empty;
            try
            {


                // prepare the web page we will be asking for
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);

                // execute the request
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                // we will read data via the response stream
                Stream webStream = response.GetResponseStream();

                //read responce text
                StreamReader webReader = new StreamReader(webStream);

                webStreamData = webReader.ReadToEnd();
                webStreamData = System.Web.HttpUtility.HtmlEncode(webStreamData);

                // RetResult = FetchData(webStreamData);


                returnZipList.Columns.Add("Id");
                returnZipList.Columns.Add("Zip");

                string zipCode = string.Empty;

                int Cpos = 0;
                int Zpos = 0;
                int x = 0;
                try
                {
                    Cpos = webStreamData.IndexOf("var json = ", Cpos + 20);
                    while (Cpos != -1)
                    {
                        x++;
                        if (Zpos == -1)
                            break;
                        if (Cpos == -1)
                            break;
                        if (x == 1)
                        {
                            Cpos = webStreamData.IndexOf("zip1=", Cpos);
                            zipCode = webStreamData.Substring(Cpos + 5, 5);

                            DataRow myNewRow1;
                            myNewRow1 = returnZipList.NewRow();
                            myNewRow1["Id"] = x;
                            myNewRow1["Zip"] = zipCode;

                            returnZipList.Rows.Add(myNewRow1);
                        }
                        if (x == 1)
                            continue;

                        Zpos = webStreamData.IndexOf("&amp;zip2=", Cpos);
                        
                        zipCode = webStreamData.Substring(Zpos + 10, 5);
                        Cpos = Zpos + 15;

                        DataRow myNewRow;
                        myNewRow = returnZipList.NewRow();
                        myNewRow["Id"] = x;
                        myNewRow["Zip"] = zipCode;

                        returnZipList.Rows.Add(myNewRow);
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return returnZipList;
            #endregion
        }

        public string IP2AddressAPI(string ipAddress)
        {
            #region
            string apiKey = System.Configuration.ConfigurationManager.AppSettings["IpAddressAPIKey"];
            System.Uri objUrl = new System.Uri("http://www.ipaddressapi.com/l/" + apiKey + "?h=" + ipAddress);

            System.Net.WebRequest objWebReq;
            System.Net.WebResponse objResp;
            System.IO.StreamReader sReader;
            string strReturn = string.Empty;

            //Try to connect to the server and retrieve data. 
            try
            {
                objWebReq = System.Net.WebRequest.Create(objUrl);
                objResp = objWebReq.GetResponse();

                //Get the data and store in a return string. 
                sReader = new System.IO.StreamReader(objResp.GetResponseStream());
                strReturn = sReader.ReadToEnd();

                //Close the objects. 
                sReader.Close();
                objResp.Close();
            }
            catch
            {
            }
            finally
            {
                objWebReq = null;
            }
            return strReturn;
            #endregion
        }

        public string IP2AddressMaxMind()
        {
            #region
            //MaxMind            
            System.Uri objUrl = new System.Uri(" http://j.maxmind.com/app/geoip.js");

            System.Net.WebRequest objWebReq;
            System.Net.WebResponse objResp;
            System.IO.StreamReader sReader;
            string strReturn = string.Empty;

            //Try to connect to the server and retrieve data. 
            try
            {
                objWebReq = System.Net.WebRequest.Create(objUrl);
                objResp = objWebReq.GetResponse();

                //Get the data and store in a return string. 
                sReader = new System.IO.StreamReader(objResp.GetResponseStream());
                strReturn = sReader.ReadToEnd();

                //Close the objects. 
                sReader.Close();
                objResp.Close();
            }
            catch
            {
            }
            finally
            {
                objWebReq = null;
            }

            return strReturn;
            #endregion
        }

        public DataTable MaxMindIP2Address(string ipAddress)
        {
            #region
            string URL = "http://www.maxmind.com/app/locate_demo_ip?ips=" + ipAddress;

            DataTable fetchData = new DataTable();
            string webStreamData = string.Empty;
            try
            {
                // prepare the web page we will be asking for
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);

                // execute the request
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                // we will read data via the response stream
                Stream webStream = response.GetResponseStream();

                //read responce text
                StreamReader webReader = new StreamReader(webStream);

                webStreamData = webReader.ReadToEnd();
                webStreamData = System.Web.HttpUtility.HtmlEncode(webStreamData);

                // RetResult = FetchData(webStreamData);
                fetchData.Columns.Add("Fields");
                fetchData.Columns.Add("Values");

                string Value = string.Empty;

                int SIndex = 0;
                int LIndex = 0;
                int counter = 0;
                try
                {
                    SIndex = webStreamData.IndexOf("class=oldH3", SIndex + 20) + 1205;

                    webStreamData = webStreamData.Substring(SIndex, 1000);

                    SIndex = 0;

                    while (SIndex != -1)
                    {
                        SIndex = webStreamData.IndexOf("&lt;td&gt;&lt;font size=&quot;-1&quot;&gt;", SIndex);

                        LIndex = webStreamData.IndexOf("&lt;/font&gt;&lt;/td&gt;", SIndex);

                        Value = webStreamData.Substring(SIndex + 42, LIndex - (SIndex + 42));
                        SIndex = LIndex;

                        DataRow myNewRow;
                        myNewRow = fetchData.NewRow();
                        if (counter == 0)
                        {
                            myNewRow["Fields"] = "Hostname";
                        }
                        else if (counter == 1)
                        {
                            myNewRow["Fields"] = "Country Code";
                        }
                        else if (counter == 2)
                        {
                            myNewRow["Fields"] = "Country Name";
                        }
                        else if (counter == 3)
                        {
                            myNewRow["Fields"] = "Region";
                        }
                        else if (counter == 4)
                        {
                            myNewRow["Fields"] = "Region Name";
                        }
                        else if (counter == 5)
                        {
                            myNewRow["Fields"] = "City";
                        }
                        else if (counter == 6)
                        {
                            myNewRow["Fields"] = "Postal Code";
                        }
                        else if (counter == 7)
                        {
                            myNewRow["Fields"] = "Latitude";
                        }
                        else if (counter == 8)
                        {
                            myNewRow["Fields"] = "Longitude";
                        }
                        else if (counter == 9)
                        {
                            myNewRow["Fields"] = "ISP";
                        }
                        else if (counter == 10)
                        {
                            myNewRow["Fields"] = "Organization";
                        }
                        else if (counter == 11)
                        {
                            myNewRow["Fields"] = "Metro Code";
                        }
                        else if (counter == 12)
                        {
                            myNewRow["Fields"] = "Area Code";
                        }

                        myNewRow["Values"] = Value;

                        fetchData.Rows.Add(myNewRow);

                        if (counter == 12)
                            break;

                        counter++;
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return fetchData;
            #endregion
        }

        public DataTable MaxMindIPAddress(string ip)
        {
            #region
            string URL = "http://www.maxmind.com/app/locate_demo_ip?ips=" + ip;

            DataTable returnZipList = new DataTable();
            string webStreamData = string.Empty;
            try
            {
                // prepare the web page we will be asking for
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);

                // execute the request
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                // we will read data via the response stream
                Stream webStream = response.GetResponseStream();

                //read responce text
                StreamReader webReader = new StreamReader(webStream);

                webStreamData = webReader.ReadToEnd();
                webStreamData = System.Web.HttpUtility.HtmlEncode(webStreamData);

                // RetResult = FetchData(webStreamData);
                returnZipList.Columns.Add("Fields");
                returnZipList.Columns.Add("Values");

                string fieldx = string.Empty;
                string valuex = string.Empty;

                int Cpos = 0;

                Cpos = webStreamData.IndexOf("class=oldH3", Cpos + 20);                
                string mydata = webStreamData.Substring(Cpos, 2200);
                string newString1 = System.Web.HttpUtility.HtmlDecode(mydata);                
                string[] lines = Regex.Split(newString1, "</th>");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return returnZipList;
            #endregion
        }

        public DataTable IP_MANGO()
        {
            #region
            string URL = "http://www.ipmango.com/";

            DataTable returnZipList = new DataTable();
            string webStreamData = string.Empty;
            try
            {
                // prepare the web page we will be asking for
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);

                // execute the request
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                // we will read data via the response stream
                Stream webStream = response.GetResponseStream();

                //read responce text
                StreamReader webReader = new StreamReader(webStream);

                webStreamData = webReader.ReadToEnd();
                webStreamData = System.Web.HttpUtility.HtmlEncode(webStreamData);

                // RetResult = FetchData(webStreamData);
                returnZipList.Columns.Add("Fields");
                returnZipList.Columns.Add("Values");

                string fieldx = string.Empty;
                string valuex = string.Empty;

                int Cpos = 0;

                Cpos = webStreamData.IndexOf("ipmangomain", Cpos + 20);                
                string mydata = webStreamData.Substring(Cpos, 3000);                
                string newString1 = System.Web.HttpUtility.HtmlDecode(mydata);                
                string[] lines = Regex.Split(newString1, "</th>");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return returnZipList;
            #endregion
        }

        public string MaxMindIPData(string IP)
        {
            #region
            System.Uri objUrl = new System.Uri("http://geoip.maxmind.com/f?l=j809aZlOsk4G&i=" + IP);

            System.Net.WebRequest objWebReq;
            System.Net.WebResponse objResp;
            System.IO.StreamReader sReader;
            string strReturn = string.Empty;

            //Try to connect to the server and retrieve data. 
            try
            {
                objWebReq = System.Net.WebRequest.Create(objUrl);
                objResp = objWebReq.GetResponse();

                //Get the data and store in a return string. 
                sReader = new System.IO.StreamReader(objResp.GetResponseStream());
                strReturn = sReader.ReadToEnd();

                //Close the objects. 
                sReader.Close();
                objResp.Close();
            }
            catch
            {
            }
            finally
            {
                objWebReq = null;
            }

            return strReturn;
            #endregion
        }

        /// <summary>
        /// Function to get distance between two zipcodes
        /// </summary>
        /// <param name="originZip"></param>
        /// <param name="destinationZip"></param>
        /// <returns></returns>
        public string GetDistanceBtwZipCodes(string originZip, string destinationZip)
        {
            #region
            string URL = "http://maps.googleapis.com/maps/api/distancematrix/xml?origins=" + originZip + "&destinations=" + destinationZip + "&sensor=false";
            
            DataTable SiteResult = new DataTable();
            string webStreamData = string.Empty;
            string ResultDistance = "";
            try
            {
                // prepare the web page we will be asking for
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(URL);
                // execute the request
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                // we will read data via the response stream
                Stream webStream = response.GetResponseStream();
                //read responce text
                StreamReader webReader = new StreamReader(webStream);
                webStreamData = webReader.ReadToEnd();                
                XmlDocument xmlReport = new XmlDocument();
                xmlReport.LoadXml(webStreamData);
                string textKMS = xmlReport.SelectSingleNode("DistanceMatrixResponse/row/element/distance/text").InnerText;
                textKMS = textKMS.Replace(" km", "");
                double kms = Convert.ToDouble(textKMS.Trim());
                ResultDistance = Convert.ToString(kms * 0.6) + " miles";
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return ResultDistance;
            #endregion
        }

        /// <summary>
        /// Function to get distance between two lat long
        /// </summary>
        /// <param name="lat1"></param>
        /// <param name="lon1"></param>
        /// <param name="lat2"></param>
        /// <param name="lon2"></param>
        /// <param name="unit"></param>
        /// <returns></returns>
        public double distance(double lat1, double lon1, double lat2, double lon2)
        {
            double theta = lon1 - lon2;
            double dist = Math.Sin(deg2rad(lat1)) * Math.Sin(deg2rad(lat2)) + Math.Cos(deg2rad(lat1)) * Math.Cos(deg2rad(lat2)) * Math.Cos(deg2rad(theta));
            dist = Math.Acos(dist);
            dist = rad2deg(dist);
            dist = dist * 60 * 1.1515;            
            return (dist);
        }

        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        //::  This function converts decimal degrees to radians             :::
        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        private double deg2rad(double deg)
        {
            return (deg * Math.PI / 180.0);
        }

        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        //::  This function converts radians to decimal degrees             :::
        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        private double rad2deg(double rad)
        {
            return (rad / Math.PI * 180.0);
        }
        //Function to get distance between two lat long ends here
    }
}
