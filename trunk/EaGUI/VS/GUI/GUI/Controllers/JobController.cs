using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using GUI.Model;
using GUI.Models;

namespace GUI.Controllers
{
    public class JobController : Controller
    {
        IJobRepository _jobRepository;

        public JobController()
        {
            _jobRepository = new SqlJobRepository();
        }

        public JobController(IJobRepository jobRepository)
        {
            _jobRepository = jobRepository;
        }
        //
        // GET: /Job/

        public ActionResult Index()
        {

            var jobs = _jobRepository.FindAllJobs();

            if (Request.IsAjaxRequest())
            {
                var jsonJob = from job in jobs
                              select new JsonJob
                              {
                                  JobName = job.Name,
                                  JobDesc = "",
                                  ProblemName = job.Problem.Name,
                                  ProblemDesc = job.Problem.Description,
                                  Job_Id = job.Job_Id,
                                  Problem_Id = job.Problem_Id
                              };

                return Json(jsonJob.ToList());
            }

            return View(jobs);
        }

        //
        // GET: /Job/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /Job/Create

        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /Job/Create

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(Job job)
        {

            if (ModelState.IsValid)
            {
                try
                {
                    _jobRepository.AddJob(job);
                    return RedirectToAction("Index");
                }
                catch
                {
                    return View(job);
                }
            }
            else
            {
                return View(job);
            }
 
        }

        //
        // GET: /Job/Edit/5
 
        public ActionResult Edit(int id)
        {
            var job = _jobRepository.GetJob(id);
            return View(job);
        }

        //
        // POST: /Job/Edit/5

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Edit(int id, FormCollection collection)
        {
            var job = _jobRepository.GetJob(id);
            try
            {
                UpdateModel(job, collection.ToValueProvider());
                _jobRepository.UpdateJob(job);
                return RedirectToAction("Index");
            }
            catch
            {
                return View(job);
            }
        }

        //
        // GET: /Job/Details/5
        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize(Roles="Adminstrator")]
        public ActionResult Delete(int id)
        {
            var job = _jobRepository.GetJob(id);
            _jobRepository.DeleteJob(job);
            return RedirectToAction("Index");
        }
    }

    public class JsonJob
    {
        public string JobName { get; set; }
        public string JobDesc { get; set; }
        public string ProblemName { get; set; }
        public string ProblemDesc { get; set; }
        public int Job_Id { get; set; }
        public int Problem_Id { get; set; }
    }

}
