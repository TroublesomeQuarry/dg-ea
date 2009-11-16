<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Dialog.Master" Inherits="System.Web.Mvc.ViewPage<GUI.Model.JobViewModel>" %>



<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    
    
        <%
            System.Web.UI.DataVisualization.Charting.Chart Chart1 = new System.Web.UI.DataVisualization.Charting.Chart();
            Chart1.Width = 750;
            Chart1.Height = 400;
            Chart1.RenderType = RenderType.ImageTag;
            Chart1.ImageLocation = "..\\..\\TempImages\\ChartPic_#SEQ(200,30)";

            Chart1.Palette = ChartColorPalette.BrightPastel;
            Title t = new Title(Model.job.Name + " Progress", Docking.Top, new System.Drawing.Font("Trebuchet MS", 14, System.Drawing.FontStyle.Bold), System.Drawing.Color.FromArgb(26, 59, 105));
            Chart1.Titles.Add(t);
            Chart1.ChartAreas.Add("Series 1");

            // create a couple of series
            Chart1.Series.Add("Max");
            Chart1.Series["Max"].ChartType = SeriesChartType.Line;
            Chart1.Series.Add("Min");
            Chart1.Series["Min"].ChartType = SeriesChartType.Line;
            Chart1.Series.Add("Mean");
            Chart1.Series["Mean"].ChartType = SeriesChartType.Line;        
                    
            //Chart1.Series.Add("Min");
            //Chart1.Series.Add("Mean");
            //Chart1.Series.Add("StdDev");

            for (int i = 0; i < Model.chartData.Length; i++)
            {
                double[] dataItems = new double[4];
                dataItems[0] = Model.chartData[i].Max;
                dataItems[1] = Model.chartData[i].Min;
                dataItems[2] = Model.chartData[i].Mean;
                dataItems[3] = Model.chartData[i].StdDev;

                int iter = Model.chartData[i].Iteration;

                Chart1.Series["Max"].Points.AddXY(iter, dataItems[0]);
                Chart1.Series["Min"].Points.AddXY(iter, dataItems[1]);
                Chart1.Series["Mean"].Points.AddXY(iter, dataItems[2]);
               // Chart1.Series["Progress"].Points[0].YValues[1] = dataItems[1];
                //Chart1.Series["Progress"].Points[iter].YValues[2] = dataItems[2];
                //Chart1.Series["Progress"].Points[iter].YValues[3] = dataItems[3];
                
            }             




            Chart1.BorderSkin.SkinStyle = BorderSkinStyle.Emboss;
            Chart1.BorderColor = System.Drawing.Color.FromArgb(26, 59, 105);
            Chart1.BorderlineDashStyle = ChartDashStyle.Solid;
            Chart1.BorderWidth = 2;

            Chart1.Legends.Add("Legend1");

            // show legend based on check box value
            Chart1.Legends["Legend1"].Enabled = true;

            // Render chart control
            Chart1.Page = this;
            HtmlTextWriter writer = new HtmlTextWriter(Page.Response.Output);
            Chart1.RenderControl(writer);

     
            //// Populate series data
            //double[] yValues = { 55.62, 45.54, 73.45, 9.73, 88.42, 45.9, 63.6, 85.1, 67.2, 23.6 };
            //chart1.Series["DataSeries"].Points.DataBindY(yValues);

            //// Set Box Plot chart type
            //chart1.Series["BoxPlotSeries"].ChartType = SeriesChartType.BoxPlot;

            //// Specify data series name for the Box Plot
            //chart1.Series["BoxPlotSeries"]["BoxPlotSeries"] = "DataSeries";

            //// Set whiskers percentile
            //chart1.Series["BoxPlotSeries"]["BoxPlotWhiskerPercentile"] = "5";

            //// Set box percentile
            //chart1.Series["BoxPlotSeries"]["BoxPlotPercentile"] = "30";

            //// Hide Average line
            //chart1.Series["BoxPlotSeries"]["BoxPlotShowAverage"] = "false";

            //// Show/Hide Median line
            //chart1.Series["BoxPlotSeries"]["BoxPlotShowMedian"] = "true";

            //// Show Unusual points
            //chart1.Series["BoxPlotSeries"]["BoxPlotShowUnusualValues"] = "true";

            //chart1.Page = this;
            //HtmlTextWriter writer = new HtmlTextWriter(Page.Response.Output);
            //chart1.RenderControl(writer);
            
                        //System.Web.UI.DataVisualization.Charting.Chart Chart2 = new System.Web.UI.DataVisualization.Charting.Chart();
                        //Chart2.Width = 700;
                        //Chart2.Height = 296;
                        //Chart2.RenderType = RenderType.ImageTag;

                        //Chart2.Palette = ChartColorPalette.BrightPastel;
                        //Title t = new Title("Algoritm Progess", Docking.Top, new System.Drawing.Font("Trebuchet MS", 14, System.Drawing.FontStyle.Bold), System.Drawing.Color.FromArgb(26, 59, 105));
                        //Chart2.Titles.Add(t);
                        //Chart2.ChartAreas.Add("Std. Dev.");

                        //// create a couple of series
                        //Chart2.Series.Add("Max");
                        //Chart2.Series.Add("Min");

                        //// add points to series 1
                   
                        //    for (int i = 0; i < 40; i++)
                        //    Chart2.Series["Min"].Points.AddY(i);
                        

                    
                        //    for(int i=0; i< 40; i++)
                        //        Chart2.Series["Max"].Points.AddY(i + 1);
                      

                        //Chart2.BorderSkin.SkinStyle = BorderSkinStyle.Emboss;
                        //Chart2.BorderColor = System.Drawing.Color.FromArgb(26, 59, 105);
                        //Chart2.BorderlineDashStyle = ChartDashStyle.Solid;
                        //Chart2.BorderWidth = 2;

                        //Chart2.Legends.Add("Legend1");
           

                        //// Render chart control
                        //Chart2.Page = this;
                        //HtmlTextWriter writer = new HtmlTextWriter(Page.Response.Output);
                        //Chart2.RenderControl(writer);

                     %>
     
   
</asp:Content>

