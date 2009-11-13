using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GUI.Model;

namespace GUI.Models
{
    public interface IDataGroup_ElementRepository
    {
        IQueryable<DataGroup_Element> FindAllDataGroup_Elements();
        DataGroup_Element GetDataGroup_Element(int id);
        void AddDataGroup_Element(DataGroup_Element dataGroup_Element);
        void UpdateDataGroup_Element(DataGroup_Element dataGroup_Element);
        void DeleteDataGroup_Element(DataGroup_Element dataGroup_Element);
    }
}
