using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using SeedSpeak.Data.Repository;
using SeedSpeak.Model;
using SeedSpeak.Data.Factory;
using System.Data.Objects;

namespace SeedSpeak.Data.Repository
{
    public abstract class AbstractRepository : IRepository
    {

        #region protected members
        protected seedspeakdbEntities context = ContextFactory.GetContext();

        const string KeyPropertyName = "id";


        protected Expression<Func<T, bool>> CreateGetExpression<T>(Guid id)
        {
            Expression<Func<T, bool>> lambda = null;
            try
            {
                ParameterExpression e = Expression.Parameter(typeof(T), "e");
                PropertyInfo propInfo = typeof(T).GetProperty(KeyPropertyName);
                MemberExpression m = Expression.MakeMemberAccess(e, propInfo);
                ConstantExpression c = Expression.Constant(id, typeof(Guid));
                BinaryExpression b = Expression.Equal(m, c);
                lambda = Expression.Lambda<Func<T, bool>>(b, e);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lambda;
        }


        protected Guid GetKeyPropertyValue<T>(object entity)
        {
            return (Guid)typeof(T).GetProperty(KeyPropertyName).GetValue(entity, null);
        }

        #endregion

        #region IRepository Members

        public abstract ObjectResult<T> ListP<T>(string uspName) where T : class;
        public abstract ObjectResult<T> ListPP<T>(string uspName,string paraValue) where T : class;
        public abstract ObjectResult<T> ListPPP<T>(string uspName, string paraValue) where T : class;

        public abstract IQueryable<T> List<T>() where T : class;

        public abstract IQueryable<T> List<T>(Expression<Func<T, bool>> filter) where T : class;

        public abstract IQueryable<T> List<T>(Expression<Func<T, bool>> filter, string includeFilter) where T : class;

        public abstract long Count<T>() where T : class;

        public abstract long Count<T>(Expression<Func<T, bool>> filter) where T : class;

        public abstract T Get<T>(Guid id) where T : class;

        public abstract void Create<T>(T entityToCreate) where T : class;

        public abstract void Update<T>(T entityToEdit) where T : class;

        public abstract void Delete<T>(T entityToDelete) where T : class;

        #endregion

    }
}
