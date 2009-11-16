using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace playground
{
    class Program
    {
        static void Main(string[] args)
        {

            string stats;
            using (System.IO.StreamReader sr = new System.IO.StreamReader(@"C:\GAProject\ws\EaGUI\VS\GUI\playground\body.txt"))
            {
                stats = sr.ReadToEnd();
            }

            stats = stats.Substring(9,stats.Length-12);
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
                chartData.Best = nodeList[i].Attributes["Best"].Value;
                data[i] = chartData;

            }
            Console.ReadLine();
        }
    }

    struct ChartData
    {
        public int Iteration;
        public int EvalNum;
        public double Max;
        public double Min;
        public double StdDev;
        public double Mean;
        public string Best;
    }
}
