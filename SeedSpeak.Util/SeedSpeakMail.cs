using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.IO;

namespace SeedSpeak.Util
{
    public sealed class SeedSpeakMail 
    {
              //This is a hash table which store the list of messages
        private static Hashtable commonMessageTable = new Hashtable();

        static SeedSpeakMail()
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + "\\SeedSpeakMail.properties";
            TextReader reader = null;
            try
            {
                reader = new StreamReader(path);
                String stmt = null;
                while ((stmt = reader.ReadLine()) != null)
                {
                    if (stmt != null && stmt.Trim().Length > 0)
                    {
                        int pos = stmt.IndexOf("=");
                        String messageKey = stmt.Substring(0, pos);
                        String messageVal = stmt.Substring(pos + 1);
                        commonMessageTable.Add(messageKey, messageVal);
                    }
                }

                int size = commonMessageTable.Count;
            }
            catch (Exception ex)
            {
                throw ex;
                //System.Console.WriteLine(" Error in reading the message file " + ex);
            }
            finally
            {
                reader.Close();
                reader.Dispose();
            }
        }

        /// <summary>
        ///  This function is used to return the common type list for the given common type.
        ///  
        /// </summary>
        /// <param name="keyname">Common type</param>
        /// <returns>The list of common types</returns>

        public static String getKeyValue(string keyname)
        {
            String messageVal = "";
            try
            {
                messageVal = (String)commonMessageTable[keyname];
            }
            catch (Exception)
            {
                throw;
               // System.Console.WriteLine(" Errors in returning the value for the corresponding key ");
            }

            return messageVal;
        }
        /// <summary>
        /// This function is used to return the whole hash table which contains all the 
        /// common types list for each common type
        /// 
        /// </summary>
        /// <returns>list of common types</returns>
        /// 

        public static Hashtable getCommonTypeTable()
        {
            return commonMessageTable;
        }
    }
}
