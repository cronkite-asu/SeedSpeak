using System;
using System.Linq.Expressions;
using System.Linq;

namespace SeedSpeak.Data.Repository
{
    public interface IRepository 
    {
        //Collection Methods
        IQueryable<T> List<T>() where T : class;
        IQueryable<T> List<T>(Expression<Func<T, bool>> filter) where T : class;
        IQueryable<T> List<T>(Expression<Func<T, bool>> filter, string includeFilter) where T : class;
        long Count<T>() where T : class;
        long Count<T>(Expression<Func<T, bool>> filter) where T : class;

        //Single Object Methods
        T Get<T>(Guid id) where T : class;

        //CRUD Methods
        void Create<T>(T entityToCreate) where T : class;
        void Update<T>(T entityToEdit) where T : class;
        void Delete<T>(T entityToDelete) where T : class;
    }
}
