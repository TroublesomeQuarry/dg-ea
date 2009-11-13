using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GUI.Model;

namespace GUI.Models
{
    public interface IOptionRepository
    {
        IQueryable<Option> FindAllOptions();
        Option GetOption(int id);
        void AddOption(Option option);
        void UpdateOption(Option option);
        void DeleteOption(Option option);
    }
}
