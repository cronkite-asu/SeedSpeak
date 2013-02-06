using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using System.Data;
using System.Data.Objects;


namespace SeedSpeak.Data.Repository
{
    public class Repository : AbstractRepository
    {
        protected string GetEntitySetName<T>()
        {
            if (typeof(T).Name.Contains("Country"))
                return String.Format("Countries");
            if(typeof(T).Name.Contains("City"))
                return String.Format("Cities");
            if (typeof(T).Name.Contains("Category"))
                return String.Format("Categories");
            if (typeof(T).Name.Contains("Privacy"))
                return String.Format("Privacies");
            if (typeof(T).Name.Contains("Medium"))
                return String.Format("Media");
            return String.Format("{0}s", typeof(T).Name);
        }

        #region IRepository Members


        public override ObjectResult<T> ListP<T>(string uspName)
        {

            return context.ExecuteFunction<T>(uspName);
            //return context.usp_UserGrowingSeed().ToList();
        }

        public override ObjectResult<T> ListPP<T>(string uspName,string pValue)
        {

            ObjectParameter objpara = new ObjectParameter("MemberID", new Guid(pValue));

            try
            {

                return context.ExecuteFunction<T>(uspName, objpara);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            //return context.usp_UserGrowingSeed().ToList();
        }

        public override ObjectResult<T> ListPPP<T>(string uspName, string pValue)
        {

            ObjectParameter objpara = new ObjectParameter("criteria", pValue);

            try
            {
                context.CommandTimeout = 9600;
                return context.ExecuteFunction<T>(uspName, objpara);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            //return context.usp_UserGrowingSeed().ToList();
        }

        //public override ObjectResult<T> ListPPP<T>(string uspName, string pValue)
        //{

        //    ObjectParameter objpara = new ObjectParameter("MemberID", pValue);

        //    try
        //    {

        //        return context.ExecuteFunction<T>(uspName, objpara);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //    //return context.usp_UserGrowingSeed().ToList();
        //}
      
        public override IQueryable<T> List<T>()
        {

            return context.CreateQuery<T>(GetEntitySetName<T>());
            //return context.usp_UserGrowingSeed().ToList();
        }
        
        public override IQueryable<T> List<T>(Expression<Func<T, bool>> filter)
        {
            return context.CreateQuery<T>(GetEntitySetName<T>()).Where(filter);
        }

        public override IQueryable<T> List<T>(Expression<Func<T, bool>> filter, string includeFilter)
        {
            return context.CreateQuery<T>(GetEntitySetName<T>()).Include(includeFilter).Where(filter);
        }

        public override long Count<T>()
        {
            return context.CreateQuery<T>(GetEntitySetName<T>()).Count();
        }

        public override long Count<T>(Expression<Func<T, bool>> filter)
        {
            return context.CreateQuery<T>(GetEntitySetName<T>()).Where(filter).Count();
        }

        public override T Get<T>(Guid id)
        {
            return List<T>().FirstOrDefault(CreateGetExpression<T>(id));
        }

        public override void Create<T>(T entityToCreate)
        {
            try
            {
                var entitySetName = GetEntitySetName<T>();
                context.AddObject(entitySetName, entityToCreate);
                context.SaveChanges();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public override void Update<T>(T entityToEdit)
        {
            try
            {
                var originalEntity = Get<T>(GetKeyPropertyValue<T>(entityToEdit));
                context.ApplyCurrentValues<T>(GetEntitySetName<T>(), entityToEdit);
                context.SaveChanges();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public override void Delete<T>(T entityToDelete)
        {
            //first find and delate all relationships
            //need to further review code
            try
            {
                var originalEntity = Get<T>(GetKeyPropertyValue<T>(entityToDelete));
                context.DeleteObject(originalEntity);
                context.SaveChanges();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        #endregion

    }
}
