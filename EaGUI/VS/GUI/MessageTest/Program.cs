using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using GUI.ActiveMq;
using Apache.NMS;
using System.Threading;

namespace MessageTest
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string fileContents;
                using (StreamReader sr = new StreamReader(@"C:\GAProject\dgase\EclipseWS\ECJServer\test.params"))
                {
                    fileContents = sr.ReadToEnd();
                }

                Messaging messaging = new Messaging();

                IMapMessage response = messaging.EcjRequest("JOB1", "AddJob", fileContents);

                Console.WriteLine("STATUS: " + response.Body.GetString("STATUS"));
                Thread.Sleep(10000);
                response = messaging.EcjRequest("JOB1", "GetStatistics", fileContents);
                Console.WriteLine("STATUS: " + response.Body.GetString("STATUS"));
                Console.WriteLine("BODY: " + response.Body.GetString("BODY"));

            }
            catch(Exception ex)
            {
                Console.Write(ex);

            }
            Console.ReadLine();
        }
    }
}
