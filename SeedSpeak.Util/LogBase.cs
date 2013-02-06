using System;
using System.Text;

namespace SeedSpeak.Util
{
    public abstract class LogBase
    {
        public log4net.ILog logger = log4net.LogManager.GetLogger("File");

        public void WriteError(Exception ex)
        {
            logger.Error("**********************");
            logger.Error(ex.Message);
            logger.Error(ex.StackTrace);
        }

        public void WriteErrorInner(Exception ex)
        {
            logger.Error("**********************");
            logger.Error(ex.Message);
            logger.Error(ex.StackTrace);
            logger.Error("-------------------------------------");
            logger.Error(ex.InnerException);
        }

        public void WriteInfo(string msg)
        {
            logger.Info("**********************");
            logger.Info(msg);
        }

    }
}
