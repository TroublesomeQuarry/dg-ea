using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using GUI.Model;
using GUI.Models;
using GUI.ActiveMq;
using Apache.NMS;
using System.Threading;
using System.Xml;

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
                              where job.IsTemplate == true
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

            Messaging messaging = new Messaging();
            foreach (Job j in jobs)
            {
                if (String.IsNullOrEmpty(j.Status) || (!j.Status.Equals("Complete") && !j.Status.Equals("Orphan")))
                {
                    try
                    {
                        //IMapMessage mapMessage = messaging.RequestMap(j.Name, "GetStatus", "");
                        //String status = mapMessage.Body.GetString("BODY");
                        //j.Status = status;
                        //if (status.Equals("Complete"))
                        //    j.EndTime = DateTime.Now;

                        //_jobRepository.UpdateJob(j);
                    }
                    catch { }
                }

            }

            return View(jobs);
        }

        //
        // GET: /Job/Details/5
        public ActionResult Details(int id)
        {
            String stats = "";
            Messaging messaging = new Messaging();
            var job = _jobRepository.GetJob(id);
            JobViewModel model = new JobViewModel();
           

            if (String.IsNullOrEmpty(job.Status) || !job.Status.Equals("Complete"))
            {

                IMapMessage mapMessage = messaging.RequestMap(job.Name, "GetStatus", "");
                job.Status = mapMessage.Body.GetString("BODY");

                ITextMessage response = messaging.RequestText(job.Name, "GetStatistics", "");
                // String stats = response.Body.GetString("BODY");
                stats = response.Text;
                stats = stats.Substring(9, stats.Length - 12);

                job.Stats = stats;

                _jobRepository.UpdateJob(job);
            }
            else
            {
                stats = job.Stats;
            }
           

            XmlDocument xmlStats = new XmlDocument();
            xmlStats.LoadXml(stats);
            XmlNodeList nodeList = xmlStats.SelectNodes("//genStat");
            Console.WriteLine("maxValues.Count " + nodeList.Count.ToString());
            ChartData[] data = new ChartData[nodeList.Count];
            
            for (int i = 0; i < nodeList.Count; i++)
            {
                ChartData chartData = new ChartData();
                chartData.Iteration = Int32.Parse(nodeList[i].Attributes["Iteration"].Value);
                chartData.EvalNum = Int32.Parse(nodeList[i].Attributes["EvalNum"].Value);
                chartData.Max = Double.Parse(nodeList[i].Attributes["Max"].Value);
                chartData.Min = Double.Parse(nodeList[i].Attributes["Min"].Value);
                chartData.StdDev = Double.Parse(nodeList[i].Attributes["StdDev"].Value);
                chartData.Mean = Double.Parse(nodeList[i].Attributes["Mean"].Value);
               // chartData.Best = nodeList[i].Attributes["Best"].Value;
                data[i] = chartData;

            }

            model.chartData = data;
            model.job = job;

          //   Response.Write("Stats: " + response.Body.GetString("BODY"));

           // Response.Write("Stats: " + response.Body.ToString());
           // Response.End();
             return View(model);
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
            if (Request.Form.HasKeys())
            {
                foreach (string x in Request.Form)
                {
                    Response.Write(x + ": " + Request.Form[x] + "<br />");
                } 

            }
            string jobName = "CMAES" + DateTime.Now.Second.ToString();

            Messaging messaging = new Messaging();

            IMapMessage response = messaging.RequestMap(jobName, "AddJob", jobName);

           job.IsTemplate = false;
           job.Name = jobName;
           job.Problem_Id = 1;
           job.Status = "Submitted";
           job.StartTime = DateTime.Now;
           _jobRepository.AddJob(job);



            Response.Redirect("/default.aspx");
            return View(job);
          //  var jobs = _jobRepository.FindAllJobs();
            //return View(jobs);

            //if (ModelState.IsValid)
            //{
            //    try
            //    {
            //        _jobRepository.AddJob(job);
            //        return RedirectToAction("Index");
            //    }
            //    catch
            //    {
            //        return View(job);
            //    }
            //}
            //else
            //{
            //    return View(job);
            //}
 
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
