using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GUI.Model;

namespace GUI.Models
{

    public class SqlDataElementRepository : IDataElementRepository
    {
        DB db;
        public SqlDataElementRepository()
        {
            db = new DB();
        }

        public IQueryable<DataElement> FindAllDataElements()
        {
            return db.DataElements;
        }

        public DataElement GetDataElement(int id)
        {
            return db.DataElements.SingleOrDefault(x => x.DataElement_Id == id);
        }

        public void AddDataElement(DataElement dataElement)
        {
            db.DataElements.InsertOnSubmit(dataElement);
            db.SubmitChanges();
        }

        public void UpdateDataElement(DataElement dataElement)
        {
            db.SubmitChanges();
        }

        public void DeleteDataElement(DataElement dataElement)
        {
            db.DataElements.DeleteOnSubmit(dataElement);
            db.SubmitChanges();
        }

    }
}
