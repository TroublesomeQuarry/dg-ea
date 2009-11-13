using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GUI.Model;

namespace GUI.Models
{
    public class SqlJobRepository : IJobRepository
    {
        DB db;
        public SqlJobRepository()
        {
            db = new DB();
        }

        public IQueryable<Job> FindAllJobs()
        {
            return db.Jobs;
        }

        public Job GetJob(int id)
        {
            return db.Jobs.SingleOrDefault(x => x.Job_Id == id);
        }

        public void AddJob(Job job)
        {
            db.Jobs.InsertOnSubmit(job);
            db.SubmitChanges();
        }

        public void UpdateJob(Job job)
        {
            db.SubmitChanges();
        }

        public void DeleteJob(Job job)
        {
            db.Jobs.DeleteOnSubmit(job);
            db.SubmitChanges();
        }

    }
}
