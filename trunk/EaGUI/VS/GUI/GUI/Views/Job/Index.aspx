<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<GUI.Model.Job>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Index
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<link href="../../Content/wizard/wizard.css" rel="stylesheet" type="text/css" />
<style type="text/css">
	#draggable { float:right; width: 300px; height: 150px; padding: 0.5em; margin-top:20px;}
	#accordion { float:left; width: 600px; height: 400px; padding: 0.5em; }
	#tabs {  }
	.catLeft {float:left; font-size:small; width:50%}
	.catRight {float:right; font-size:small;  width:50%}
	.category{ overflow: hidden; width:100%; display:block; padding:3px; font-size:medium; font-weight:bold;}
	.aborder{border:solid 1px red; display:block}
</style>
<style type="text/css">
	    #feedback { font-size: 1.4em; }
	    #selectable .ui-selecting { background: #FECA40; }
	    #selectable .ui-selected { background: #F39814; color: white; }
	    #selectable { list-style-type: none; margin: 0; padding: 0; width: 60%; }
	    #selectable li { margin: 3px; padding: 0.4em; font-size: 1.4em; height: 18px; }
	    .cSlider { padding-right:8px; vertical-align:bottom; text-align:right; float:right;  border-color:inherit; background-color:Transparent; color:#f6931f; font-weight:bold;}
	    .ui-progressbar-value { background-image: url(/Content/css/ui-lightness/images/pbar-ani.gif); }
	</style>

<script type="text/javascript">

    var text1 = "<b>Job History</b> - This shows recent and active jobs - you can click on 'details' to see charts showing information about the job "
    var text2 = "<b>To create a new job</b> - select the type of problem to solve. Each of these problem types has certain characteristics that help us to defined part of the algorithm. Some of the parameters of the EA depend on the type of problem you select. "
    var text3 = "<b>User options</b> - Here you can setup some defaults like the email address to send alerts to. "
    var text4 = "<b>Factors</b> - Select the factors that you wish to find loads for. "
    var text5 = "<b>Options</b> - You can override the default options here. "
    var text6 = "<b>Notifications</b> - The email address to send alerts to and the events you want to receive alerts for "
    var text7 = "<b>Confirm</b> - Look over you selection and click finish to submit the job. "
    
    var _job_Id;
    var _problem_Id;
    var factorNameArray;
    $(function() {

        $.extend($.ui.slider.defaults, {
            range: "min",
            animate: true,
            orientation: "horizontal"
        });

        $("#progressbar").progressbar({
            value: 59
        });        

        $("#sliderPopSize").slider({
            max: 200,
            value: 50,
            slide: function(event, ui) {
                $("#PopSizeValue").val(ui.value);
            }
        });

        $("#sliderTimeLimit").slider({
            max: 180,
            value: 60,
            slide: function(event, ui) {
                $("#TimeLimitValue").val(ui.value);
            }

        });

        $("#sliderGenerationDev").slider({
            max: 100,
            value: 50,
            slide: function(event, ui) {
                $("#GenerationDevValue").val(ui.value);
            }
        });

        $("#sliderOptimalValue").slider({
            max: 4000,
            value: 3000,
            slide: function(event, ui) {
                $("#OptimalValue").val(ui.value);
            }
        });


        $("#JobInfoDialog").dialog({
            bgiframe: true,
            height: 400,
            width: 800,
            modal: true,
            autoOpen: false
        });

        $("#accordion").accordion({ header: "h3", autoHeight: false });

        $('#accordion').bind('accordionchange', function(event, ui) {

            var active = $('#accordion').accordion('option', 'active');
            var other = $('#tabs').tabs('option', 'selected');

            switch (active) {
                case 0:
                    $("#draggable").html("<span class='red'>" + text1 + "</span>");
                    break;
                case 1:
                    $("#draggable").html("<span class='red'>" + text2 + "</span>");
                    break;
                case 2:
                    $("#draggable").html("<span class='red'>" + text3 + "</span>");
                    break;
                default:
                    $("#draggable").html(active);
            }

        });
        // Tabs
        $('#tabs').tabs({ disabled: [1, 2, 3, 4] });


        $('#selectable').selectable({
            selected: function(event, ui) {
                _job_Id = $(ui.selected).attr('job_Id');
                _problem_Id = $(ui.selected).attr('problem_Id');
                updateDataTab(_job_Id);
                $('#tab1Next').attr({ disabled: false });
            }
        });

        //        $('#selectable').bind('selected', function(event, ui) {
        //            alert('hewre');
        ////            alert($('tab1Next').attr('disabled'));
        ////            $('tab1Next').attr('disabled', 'false');

        //        });



        $('#tabs').bind('tabsselect', function(event, ui) {

            var active = ui.index;

            switch (active) {
                case 0:
                    $("#draggable").html("<span class='red'>" + text2 + "</span>");
                    break;
                case 1:
                    $("#draggable").html("<span class='red'>" + text4 + "</span>");
                    break;
                case 2:
                    $("#draggable").html("<span class='red'>" + text5 + "</span>");
                    break;
                case 3:
                    $("#draggable").html("<span class='red'>" + text6 + "</span>");
                    break;
                case 4:
                    $("#draggable").html("<span class='red'>" + text7 + "</span>");
                    var stext = "<table><tr>";
                    stext += "<td>";
                    stext += "Problem Type:";
                    stext += "</td>";
                    stext += "<td>";
                    stext += _job_Id;
                    stext += "</td>";
                    stext += "</tr>";
                    stext += "<tr>";
                    stext += "<td valign='top'>";
                    stext += "Factors:";
                    stext += "</td>";
                    stext += "<td valign='top'>";

                    var data = $("input[iType='data']:checked");
                    $.each(data, function(t, item) {
                        stext += $(item).attr('factorName') + "<br/>";
                    });
                    stext += "</td>";
                    stext += "</tr>";
                    stext += "<tr>";
                    stext += "<td valign='top'>";
                    stext += "Options:";
                    stext += "</td>";
                    stext += "<td valign='top'>";

                    var data = $("input[iType='option']:checked");
                    $.each(data, function(t, item) {
                        stext += $(item).attr('optionName') + "<br/>";
                    });
                    stext += "</td>";
                    stext += "</tr></table>";

                    $("#tabs5Content").html("<span class='red'>" + stext + "</span>");
                    break;
                default:
                    $("#draggable").html(active);
            }
        });


        $("#draggable").draggable();



        $.getJSON("/Job?sdh",
                function(data) {

                    $.each(data, function(t, item) {
//                        if (isNewCategory(item.ProblemName)) {
//                            $('#selectable').append("<li job_Id='0' class='ui-widget-content'>Blank " + item.ProblemName + "</li>");
//                        };

                        $('#selectable').append("<li  problemName='" + item.JobName + "' problem_Id='" + item.Problem_Id + "' job_Id='" + item.Job_Id + "' class='ui-widget-content'>" + item.JobName + "</li>");
                    });

                });

        //        $.getJSON("/Option",
        //        function(data) {
        //            $.each(data, function(t, item) {
        //            $("#tabs3Content").append("<INPUT iType='option' optionName='" + item.Name + "'  class='optionInput' TYPE=CHECKBOX NAME='chk" + item.Option_Id + "'/>" + item.Name + ' ' + item.CategoryName + "<br/>");
        //            });
        //        });




        var previousJobCategory = "";
        function isNewCategory(category) {
            if (previousJobCategory != category) {
                previousJobCategory = category;
                return true;
            }
            else
                return false;
        };







        //        $.ajax({
        //            url: "/DataGroup_Element/Index/2",
        //            cache: false,
        //            success: function(html) {
        //                alert(html);
        //            }
        //        });


    });
    
    function ws(field) {
        return field.split(' ').join('');

    };
    
    function loadnext(divout, divin) {

        if (divout > divin) {
            $('#tabs').tabs('disable', divout);   
        }
        else {
//            if (divin == 1) {
//                updateDataTab(_job_Id);
//            }
            $('#tabs').tabs('enable', divin);
        }

        $('#tabs').tabs('select', divin)
       
    };
    function dumpProps(obj, parent) {
        // Go through all the properties of the passed-in object
        for (var i in obj) {
            // if a parent (2nd parameter) was passed in, then use that to
            // build the message. Message includes i (the object's property name)
            // then the object's property value on a new line
            if (parent) { var msg = parent + "." + i + "\n" + obj[i]; } else { var msg = i + "\n" + obj[i]; }
            // Display the message. If the user clicks "OK", then continue. If they
            // click "CANCEL" then quit this level of recursion
            if (!confirm(msg)) { return; }
            // If this property (i) is an object, then recursively process the object
            if (typeof obj[i] == "object") {
                if (parent) { dumpProps(obj[i], parent + "." + i); } else { dumpProps(obj[i], i); }
            }
        }
    }

    var previousCategory = "";
    function GetCategoryHeader(category) {
        if (previousCategory != category) {
            previousCategory = category;
            return "<br/><div id='" + ws(category) + "' class='category'>" + category + "</div><div id='" + ws(category) + "left'  class='catLeft'></div><div id='" + ws(category) + "right' class='catRight'></div>";
        }
        else
            return "";
    };

    function updateDataTab(Job_Id) {
       
        $("#tabs2Content").html("Loading");
        previousCategory = "";
        $.getJSON("/DataGroup_Element/Index/" + Job_Id,
                function(data) {
                    $("#tabs2Content").html("");
                    $.each(data, function(t, item) {
                        var categoryHeader = GetCategoryHeader(item.DataGroupName);                  
                        $("#tabs2Content").append(categoryHeader);
                        if (categoryHeader != "")
                            j = 0;
                        if (j % 2 == 0)
                            $("#" + ws(item.DataGroupName) + "left").append("<INPUT factorName='" + item.DataElementName + "' iType='data' TYPE=CHECKBOX NAME='chk" + item.DataElement_Id + "'/>" + item.DataElementName + "<br/>");
                        else
                            $("#" + ws(item.DataGroupName) + "right").append("<INPUT factorName='" + item.DataElementName + "' iType='data' TYPE=CHECKBOX NAME='chk" + item.DataElement_Id + "'/>" + item.DataElementName + "<br/>");
                        j++;
                    });
                });
    }

   
    function submitJob() {
        alert('here');

        var data = $("input:checked");
        $.each(data, function(t, item) {
        alert($(item).attr('iType'));
        });



    }

    function doDetails(jobID) {

 
        $("#JobInfoDialog").dialog("open");
        
    }
    
</script>


<h2>Welcome</h2>
This tool allows you to find the loads for each of the factors in the quantitive models.
		<div id="accordion">
			<div>

				<h3><a href="#">Job History</a></h3>
				<div>
                     <table>
                                <tr>
                                    <th></th>
                                    <th>
                                        Id
                                    </th>
                                    <th>
                                        Name
                                    </th>
                                    <th>
                                        Template?
                                    </th>
                                </tr>

                            <% foreach (var item in Model) { %>
                            
                                <tr>
                                    <td>
                                       <%-- <%= Html.ActionLink("Edit", "Edit", new { id=item.Job_Id }) %> |--%>
                                       <a href="JavaScript:doDetails('<%=Html.Encode(item.Job_Id)%>')">Details</a>
                                        <%--<%= Html.ActionLink("Details", "Details", new { id=item.Job_Id })%>--%>
                                    </td>
                                    <td>
                                        <%= Html.Encode(item.Job_Id) %>
                                    </td>
                                    <td>
                                        <%= Html.Encode(item.Name) %>
                                    </td>
                                    <td>
                                        <%= Html.Encode(item.IsTemplate) %>
                                    </td>
                                </tr>
                            
                            <% } %>

                      </table>   				
				</div>
			</div>
			<div>
				<h3><a href="#">Create New Job</a></h3>
				<div>
		            <div id="tabs">
			            <ul>
				            <li><a href="#tabs-1">1:Type</a></li>
				            <li><a href="#tabs-2">2:Data</a></li>
				            <li><a href="#tabs-3">3:Options</a></li>
				            <li><a href="#tabs-4">4:Notifications</a></li>
				            <li><a href="#tabs-5">5:Confirm</a></li>
			            </ul>
			            <div id="tabs-1">
			                <div id="tabs1Content">

<ol id="selectable">
	
</ol>
		                
			                </div>				            
			                <div class="buttons">
                                <button type="submit" class="previous"  disabled="disabled"> <img src="/Content/wizard/images/arrow_left.png" alt=""/> Back </button>
                               
                                <button type="submit" class="next" disabled="disabled" id="tab1Next"  onclick="loadnext(0,1);"> Next <img src="/Content/wizard/images/arrow_right.png" alt=""/> </button>
                            </div>
                        </div>
			            <div id="tabs-2">
			                <div id="tabs2Content">
			                </div>	           
			                <div class="buttons">
                              <button type="submit" class="previous" onclick="loadnext(1,0);"> <img src="/Content/wizard/images/arrow_left.png" alt="" /> Back </button>
                              <button type="submit" class="next" onclick="loadnext(1,2);"> Next <img src="/Content/wizard/images/arrow_right.png" alt=""/> </button>
                            </div>
			            </div>
			            <div id="tabs-3">
			                <div id="tabs3Content">
			                <table  style="width:500px">
			                    <tr>
			                        <td colspan="2">
			                            <table width="100%"><tr><td>Population Size</td><td align=right><input  value="50" style="width:40px;border:0;" type="text" id="PopSizeValue" class="cSlider"  /></td></tr></table>
			                        </td>			                        
			                    </tr>
			                    <tr>
			                        <td colspan="2">
			                            <div id="sliderPopSize"></div>
			                        </td>			                        
			                    </tr>		
			                    <tr>
			                        <td valign="top">
			                            Termination:
			                        </td>	
			                        <td valign="top">
			                            <table width="100%"><tr><td>Time Limit (mins)</td><td align=right><input  value="60" style="width:40px;border:0;" type="text" id="TimeLimitValue" class="cSlider"  /></td></tr></table>			                           
			                            <div id="sliderTimeLimit"></div>	
			                            <table width="100%"><tr><td>Generation Deviation</td><td align=right><input  value="50" style="width:40px;border:0;" type="text" id="GenerationDevValue" class="cSlider"  /></td></tr></table>		                            
			                            <div id="sliderGenerationDev"></div>
			                            <table width="100%"><tr><td>Optimal Value</td><td align=right><input  value="300" style="width:40px;border:0;" type="text" id="OptimalValue" class="cSlider"  /></td></tr></table>
			                            <div id="sliderOptimalValue"></div>		                            
			                        </td>			                        		                        
			                    </tr>              
			                </table>
			                </div>	  			            			            
			                <div class="buttons">
                              <button type="submit" class="previous" onclick="loadnext(2,1);"> <img src="/Content/wizard/images/arrow_left.png" alt="" /> Back </button>
                              <button type="submit" class="next" onclick="loadnext(2,3);"> Next <img src="/Content/wizard/images/arrow_right.png" alt=""/> </button>
                            </div>
			            </div>
			            <div id="tabs-4">
			                <div id="tabs4Content">
				 
				                <table>
				                    <tr>
				                        <td>Email address:</td>
				                        <td><input type="text" name="defaultEmail" /></td>
				                    </tr>
				                    <tr>
				                        <td valign="top">Events:</td>
				                        <td valign="top">
				                            <input type="checkbox" name="onError" /> Error
				                            <br /><input type="checkbox" name="onError" /> Complete
				                            <br /><input type="checkbox" name="onError" /> Overrun
            				                
				                       </td>
				                    </tr>				        
				                </table>				  
				  			                
			                </div>	  			            			            			            
                            <div class="buttons">
                              <button type="submit" class="previous" onclick="loadnext(3,2);"> <img src="/Content/wizard/images/arrow_left.png" alt="" /> Back </button>
                              <button type="submit" class="next" onclick="loadnext(3,4);"> Next <img src="/Content/wizard/images/arrow_right.png" alt=""/> </button>
                            </div>
			            </div>
			            <div id="tabs-5">
			                <div id="tabs5Content">
			                </div>	  			            			            			            
			                <div class="buttons">
                                   <button type="submit" class="previous" onclick="loadnext(4,3);"> <img src="/Content/wizard/images/arrow_left.png" alt="" /> Back </button>
                                  <button type="submit" class="next" onclick="submitJob()"> Finish <img src="/Content/wizard/images/arrow_right.png" alt=""/> </button>
                            </div>
			            </div>			            
		            </div>	
				</div>
			</div>

			<div>
				<h3><a href="#">User Options</a></h3>
				  <div>
				    <table>
				        <tr>
				            <td>Default Email address:</td>
				            <td><input type="text" name="defaultEmail" /></td>
				        </tr>
				    </table>				  
				  </div>                                        			            			            
			</div>
			</div>
	


<div id="draggable" style="height:500px" class="ui-widget-content">
	<p><b>Job History</b> - This shows recent and active jobs - you can click on 'details' to see charts showing information about the job.</p>
</div>


<div id="JobInfoDialog" title="Job Information">
	<p>Adding the modal overlay screen makes the dialog look more prominent because it dims out the page content.</p>
<div id="progressbar"></div>

</div>	
</div>

</asp:Content>

