using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GUI.Model;

namespace GUI.Models
{
    public class SqlDataGroup_ElementRepository : IDataGroup_ElementRepository
    {
        DB db;
        public SqlDataGroup_ElementRepository()
        {
            db = new DB();
        }

        public IQueryable<DataGroup_Element> FindAllDataGroup_Elements()
        {
            return db.DataGroup_Elements;
        }

        public DataGroup_Element GetDataGroup_Element(int id)
        {
            return db.DataGroup_Elements.SingleOrDefault(x => x.DataElement_Id == id);
        }

        public void AddDataGroup_Element(DataGroup_Element dataGroup_Element)
        {
            db.DataGroup_Elements.InsertOnSubmit(dataGroup_Element);
            db.SubmitChanges();
        }

        public void UpdateDataGroup_Element(DataGroup_Element dataGroup_Element)
        {
            db.SubmitChanges();
        }

        public void DeleteDataGroup_Element(DataGroup_Element dataGroup_Element)
        {
            db.DataGroup_Elements.DeleteOnSubmit(dataGroup_Element);
            db.SubmitChanges();
        }

    }
}
