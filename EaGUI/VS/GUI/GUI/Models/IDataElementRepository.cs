using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GUI.Model;

namespace GUI.Models
{
    public interface IDataElementRepository
    {
        IQueryable<DataElement> FindAllDataElements();
        DataElement GetDataElement(int id);
        void AddDataElement(DataElement dataElement);
        void UpdateDataElement(DataElement dataElement);
        void DeleteDataElement(DataElement dataElement);
    }
}
