using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GUI.Model;

namespace GUI.Models
{
    public interface IJobRepository
    {
        IQueryable<Job> FindAllJobs();
        Job GetJob(int id);
        void AddJob(Job job);
        void UpdateJob(Job job);
        void DeleteJob(Job job);
    }
}
