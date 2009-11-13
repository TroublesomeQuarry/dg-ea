using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using GUI.Models;
using GUI.Model;

namespace GUI.Controllers
{
    public class DataElementController : Controller
    {

        IDataElementRepository _dataElementRepository;

        public DataElementController()
        {
            _dataElementRepository = new SqlDataElementRepository();
        }

        public DataElementController(IDataElementRepository dataElementRepository)
        {
            _dataElementRepository = dataElementRepository;
        }
        //
        // GET: /DataElement/

        public ActionResult Index()
        {

            var DataElements = _dataElementRepository.FindAllDataElements();

            if (Request.IsAjaxRequest())
            {
                var jsonDataElement = from DataElement in DataElements
                                      where DataElement.DataType_Id == 1
                              select new JsonDataElement
                              {
                                  Name = DataElement.Name,
                                  DataElement_Id = DataElement.DataElement_Id
                              };

                return Json(jsonDataElement.ToList());
            }

            return View(DataElements);
        }



        //
        // GET: /DataElement/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /DataElement/Create

        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /DataElement/Create

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(DataElement dataElement)
        {

            if (ModelState.IsValid)
            {
                try
                {
                    _dataElementRepository.AddDataElement(dataElement);
                    return RedirectToAction("Index");
                }
                catch
                {
                    return View(dataElement);
                }
            }
            else
            {
                return View(dataElement);
            }
 
        }

        //
        // GET: /DataElement/Edit/5
 
        public ActionResult Edit(int id)
        {
            var DataElement = _dataElementRepository.GetDataElement(id);
            return View(DataElement);
        }

        //
        // POST: /DataElement/Edit/5

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Edit(int id, FormCollection collection)
        {
            var DataElement = _dataElementRepository.GetDataElement(id);
            try
            {
                UpdateModel(DataElement, collection.ToValueProvider());
                _dataElementRepository.UpdateDataElement(DataElement);
                return RedirectToAction("Index");
            }
            catch
            {
                return View(DataElement);
            }
        }

        //
        // GET: /DataElement/Details/5
        [AcceptVerbs(HttpVerbs.Post)]
        [Authorize(Roles="Adminstrator")]
        public ActionResult Delete(int id)
        {
            var dataElement = _dataElementRepository.GetDataElement(id);
            _dataElementRepository.DeleteDataElement(dataElement);
            return RedirectToAction("Index");
        }
    }

    public class JsonDataElement
    {
        public string Name { get; set; }
        public int DataElement_Id { get; set; }
        public string GroupName { get; set; }
    }     
  
}
