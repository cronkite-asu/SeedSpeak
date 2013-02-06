using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace SeedSpeak
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Default", // Route name
                "{controller}/{action}/{id}", // URL with parameters
                new { controller = "Member", action = "Default", id = UrlParameter.Optional }, // Parameter defaults
                new { controller = "Home|Member|Seed|Admin|Category|Error|SeedStream|xd_receiver|UserProfile" }
            );

            //routes.MapRoute(
            //    "Profile",
            //    "{id}",
            //    new { Controller = "UserProfile", Action = "ViewMyProfile", id = UrlParameter.Optional }
            //);

            //routes.MapRoute("Profile", "{username}/{action}", new { Controller = "UserProfile", Action = "ViewMyProfile" });
            routes.MapRoute("Profile", "{username}", new { Controller = "UserProfile", Action = "ViewMyProfile" });
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);

            log4net.Config.XmlConfigurator.Configure(new System.IO.FileInfo(HttpContext.Current.Server.MapPath("log4net.config")));
        }
    }
}