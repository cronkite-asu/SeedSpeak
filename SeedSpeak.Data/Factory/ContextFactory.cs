using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SeedSpeak.Model;

namespace SeedSpeak.Data.Factory
{
    public class ContextFactory
    {
        public static seedspeakdbEntities GetContext()
        {
            return new seedspeakdbEntities();
        }
    }
}
