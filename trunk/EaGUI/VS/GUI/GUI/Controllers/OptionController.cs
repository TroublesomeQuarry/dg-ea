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
    public class OptionController : Controller
    {
        IOptionRepository _optionRepository;

        public OptionController()
        {
            _optionRepository = new SqlOptionRepository();
        }

        public OptionController(IOptionRepository OptionRepository)
        {
            _optionRepository = OptionRepository;
        }
        //
        // GET: /Option/

        public ActionResult Index()
        {

            var Options = _optionRepository.FindAllOptions();
            Options.OrderBy(x => x.OptionCategory.Name);

            if (Request.IsAjaxRequest())
            {
                var jsonOption = from Option in Options
                              select new JsonOption
                              {
                                  Name = Option.Name,
                                  Option_Id = Option.Option_Id,
                                  Type = Option.DataType.Name,
                                  CategoryName = Option.OptionCategory.Name
                              };

                return Json(jsonOption.ToList());
            }

            return View(Options);
        }

        //
        // GET: /Option/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /Option/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Option/Create

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(Option option)
        {

            if (ModelState.IsValid)
            {
                try
                {
                    _optionRepository.AddOption(option);
                    return RedirectToAction("Index");
                }
                catch
                {
                    return View(option);
                }
            }
            else
            {
                return View(option);
            }

        }

        //
        // GET: /Option/Edit/5

        public ActionResult Edit(int id)
        {
            var option = _optionRepository.GetOption(id);
            return View(option);
        }

        //
        // POST: /Option/Edit/5

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Edit(int id, FormCollection collection)
        {
            var option = _optionRepository.GetOption(id);
            try
            {
                UpdateModel(option, collection.ToValueProvider());
                _optionRepository.UpdateOption(option);
                return RedirectToAction("Index");
            }
            catch
            {
                return View(option);
            }
        }

        //
        // GET: /Option/Details/5
        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize(Roles = "Adminstrator")]
        public ActionResult Delete(int id)
        {
            var option = _optionRepository.GetOption(id);
            _optionRepository.DeleteOption(option);
            return RedirectToAction("Index");
        }
    }

    public class JsonOption
    {
        public string CategoryName { get; set; }
        public string Name { get; set; }
        public int Option_Id { get; set; }
        public string Type { get; set; }
    }

}
