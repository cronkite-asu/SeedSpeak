using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Collections;
using SeedSpeak.Model.Validation;
using SeedSpeak.Model;
using SeedSpeak.Data.Repository;
using SeedSpeak.Util;
using System.Xml;

namespace SeedSpeak.utils
{
    public class badWordsFilter
    {
        /// <summary>
        /// method for loading banned words from an
        /// XML document into a generic list (List(T)
        /// </summary>
        /// <param name="file">the file that holds the banned words</param>
        /// <returns></returns>
        public static List<string> BadWordList(ref string file)
        {
            //create a new List(T) for holding the words
            List<string> words = new List<string>();
            //create a new XmlDocument, this will read our XML file
            XmlDocument xmlDoc = new XmlDocument();
            //here is where XPath comes into play, when we use
            //SelectNodes we will pass this XPath query into it
            //so we can navigate straight to the nodes we want
            string query = "/WordList/word";
            //now load the XML document
            xmlDoc.Load(file);
            //loop through all the XmlNodes that meet our XPath criteria
            foreach (XmlNode node in xmlDoc.SelectNodes(query))
            {
                //add the InnerText of each ChildNodes we find
                words.Add(node.ChildNodes[0].InnerText);
            }
            //return the populated List(T)
            return words;
        }

        /// <summary>
        /// method for determining if the provided word is in
        /// the banned word list
        /// </summary>
        /// <param name="word">the word we are looking for</param>
        /// <param name="file">file name containing the words we're to search against</param>
        /// <returns></returns>
        public bool IsBadWord(ref string word, ref string file)
        {
            //create a new List(T) to hold the words. Then populate the list
            //by calling the BadWordList method in the IOManager class
            List<string> badWords = BadWordList(ref file);
            //now we need a loop as long as the words count
            for (int i = 0; i < badWords.Count; i++)
            {
                //on each iteration we compare the two (1 provided, 1 from the List(T))
                //to see if they match. If they do then return true and exit the loop
                if (word.ToLower() == badWords[i].ToLower()) return true;
            }
            //we made it through the entire list and no match found
            //so we return false as this word isnt a banned word
            return false;
        }

        public string FilterBadWords(List<string> badWordsList, string desc)
        {
            string finalDesc = string.Empty;
            for (int i = 0; i < badWordsList.Count; i++)
            {
                if (i == 0)
                    finalDesc = desc.Replace(badWordsList[i].ToString(), "");
                else
                    finalDesc = finalDesc.Replace(badWordsList[i].ToString(), "");
            }
            while (finalDesc.IndexOf("  ") != -1)
            {
                //remove extra spaces in the middle of the string
                finalDesc = finalDesc.Remove(finalDesc.IndexOf("  "), 1);
            }
            return finalDesc;
        }
    }
}