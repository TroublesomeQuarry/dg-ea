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
    public class DataGroup_ElementController : Controller
    {
        IDataGroup_ElementRepository _dataGroup_ElementRepository;

        public DataGroup_ElementController()
        {
            _dataGroup_ElementRepository = new SqlDataGroup_ElementRepository();
        }

        public DataGroup_ElementController(IDataGroup_ElementRepository dataGroup_ElementRepository)
        {
            _dataGroup_ElementRepository = dataGroup_ElementRepository;
        }
        //
        // GET: /DataGroup_Element/

        public ActionResult Index(int id)
        {

            var dataGroup_Elements = _dataGroup_ElementRepository.FindAllDataGroup_Elements();

            if (Request.IsAjaxRequest())
            {
                var jsonDataGroup_Element = from dataGroup_Element in dataGroup_Elements
                                            where dataGroup_Element.DataGroup_Id == id
                              select new JsonDataGroup_Element
                              {
                                  DataElementName = dataGroup_Element.DataElement.Name,
                                  DataGroupName = dataGroup_Element.DataGroup.Name,
                                  DataElement_Id = dataGroup_Element.DataElement_Id
                              };
  

                return Json(jsonDataGroup_Element.ToList());
            }

            return View(dataGroup_Elements);
        }

        //
        // GET: /DataGroup_Element/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /DataGroup_Element/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /DataGroup_Element/Create

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(DataGroup_Element dataGroup_Element)
        {

            if (ModelState.IsValid)
            {
                try
                {
                    _dataGroup_ElementRepository.AddDataGroup_Element(dataGroup_Element);
                    return RedirectToAction("Index");
                }
                catch
                {
                    return View(dataGroup_Element);
                }
            }
            else
            {
                return View(dataGroup_Element);
            }

        }

        //
        // GET: /DataGroup_Element/Edit/5

        public ActionResult Edit(int id)
        {
            var dataGroup_Element = _dataGroup_ElementRepository.GetDataGroup_Element(id);
            return View(dataGroup_Element);
        }

        //
        // POST: /DataGroup_Element/Edit/5

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Edit(int id, FormCollection collection)
        {
            var dataGroup_Element = _dataGroup_ElementRepository.GetDataGroup_Element(id);
            try
            {
                UpdateModel(dataGroup_Element, collection.ToValueProvider());
                _dataGroup_ElementRepository.UpdateDataGroup_Element(dataGroup_Element);
                return RedirectToAction("Index");
            }
            catch
            {
                return View(dataGroup_Element);
            }
        }

        //
        // GET: /DataGroup_Element/Details/5
        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize(Roles = "Adminstrator")]
        public ActionResult Delete(int id)
        {
            var dataGroup_Element = _dataGroup_ElementRepository.GetDataGroup_Element(id);
            _dataGroup_ElementRepository.DeleteDataGroup_Element(dataGroup_Element);
            return RedirectToAction("Index");
        }
    }

    public class JsonDataGroup_Element
    {
        public string DataElementName { get; set; }
        public string DataGroupName { get; set; }
        public int DataElement_Id { get; set; }
    }

}
