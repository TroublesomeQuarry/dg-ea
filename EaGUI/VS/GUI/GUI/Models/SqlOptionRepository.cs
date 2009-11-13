using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GUI.Model;

namespace GUI.Models
{
    public class SqlOptionRepository : IOptionRepository
    {
        DB db;
        public SqlOptionRepository()
        {
            db = new DB();
        }

        public IQueryable<Option> FindAllOptions()
        {
            return db.Options;
        }

        public Option GetOption(int id)
        {
            return db.Options.SingleOrDefault(x => x.Option_Id == id);
        }

        public void AddOption(Option option)
        {
            db.Options.InsertOnSubmit(option);
            db.SubmitChanges();
        }

        public void UpdateOption(Option option)
        {
            db.SubmitChanges();
        }

        public void DeleteOption(Option option)
        {
            db.Options.DeleteOnSubmit(option);
            db.SubmitChanges();
        }

    }
}
