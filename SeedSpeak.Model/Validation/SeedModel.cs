using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace SeedSpeak.Model.Validation
{
    public class SeedModel
    {
    }

    public class AddSeed
    {
        //[Required(ErrorMessage = "Seed name is required.")]
        [DisplayName("Seed Name")]
        public string SeedName { get; set; }

        //[Required(ErrorMessage = "Description is required.")]
        [DisplayName("Brief Description")]
        public string Description { get; set; }

        //[Required(ErrorMessage="Address is required.")]
        [DisplayName("Street Address")]
        public string StreetAddress { get; set; }

        //[Required(ErrorMessage = "City is required.")]
        [DisplayName("City")]
        public string City { get; set; }

        //[Required(ErrorMessage="Zip code is required.")]
        [DisplayName("Zip Code")] 
        public string ZipCode { get; set; }

        //[Required(ErrorMessage = "Country is required.")]
        [DisplayName("Country")]
        public string Country { get; set; }

        [DisplayName("Tag")]
        public string Tag { get; set; }

        public string LongLat { get; set; }

        public string StateCode { get; set; }

        public string rootSeedId { get; set; }

        public string parentSeedId { get; set; }
    }

    public class MediaManagement
    {
        //[Required(ErrorMessage = "Title is required.")]
        [DisplayName("Title")]
        public string title { get; set; }

        [DisplayName("Seed Name")]
        public string seedId { get; set; }

        [DisplayName("Select Media")]
        public string path { get; set; }

        public string uploadedById { get; set; }

        public string type { get; set; }

        public string embedScript { get; set; }
    }

    public class ssStreamModel
    {
        public Guid id { get; set; }
        public int commentCounter { get; set; }
    }

    public class EditSeed 
    {
        public Guid id { get; set; }
        public string seedTitle { get; set; }
        public string seedDesc { get; set; }
        public string seedLat { get; set; }
        public string seedLng { get; set; }
        public string seedCatg { get; set; }
    }

    public class ssStreamEditModel
    {
        public Guid id { get; set; }
        public string sstitle { get; set; }
        public string ssDesc { get; set; }
        public string ssType { get; set; }
        public string ssCategories { get; set; }
    }
}
