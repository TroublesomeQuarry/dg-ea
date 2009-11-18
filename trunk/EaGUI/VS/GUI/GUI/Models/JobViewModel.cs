using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using GUI.Model;

namespace GUI.Model
{
    public class JobViewModel
    {
        public Job job {get; set;}
        public ChartData[] chartData {get; set;}
        public String[] BestIndivilual;
        public String StopMessage = "";
    }
}
