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
	</style>

<script type="text/javascript">
    var _job_Id;
    var _problem_Id;
    $(function() {
        $("#accordion").accordion({ header: "h3", autoHeight: false });

        $('#accordion').bind('accordionchange', function(event, ui) {

            var active = $('#accordion').accordion('option', 'active');
            var other = $('#tabs').tabs('option', 'selected');

            switch (active) {
                case 1:
                    $("#draggable").html("<span class='red'>Hello <b>Again</b> " + other + "</span>");
                    break;
                case 2:
                    $("#draggable").html("<span class='red'>Hello <b>there</b></span>");
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
                case 1:
                    $("#draggable").html("<span class='red'>Hello <b>other</b></span>");
                    break;
                case 2:
                    $("#draggable").html("<span class='red'>Hello <b>more</b></span>");
                    break;
                default:
                    $("#draggable").html(active);
            }
        });


        $("#draggable").draggable();



        $.getJSON("/Job?sd",
                function(data) {

                    $.each(data, function(t, item) {
                        if (isNewCategory(item.ProblemName)) {
                            $('#selectable').append("<li job_Id='0' class='ui-widget-content'>Blank " + item.ProblemName + "</li>");
                        };

                        $('#selectable').append("<li problem_Id='" + item.Problem_Id + "' job_Id='" + item.Job_Id + "' class='ui-widget-content'>" + item.JobName + "</li>");
                    });

                });

        $.getJSON("/Option",
        function(data) {
            $.each(data, function(t, item) {
            $("#tabs3Content").append("<INPUT iType='option' class='optionInput' TYPE=CHECKBOX NAME='chk" + item.Option_Id + "'/>" + item.Name + ' ' + item.CategoryName + "<br/>");
            });
        });




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
                            $("#" + ws(item.DataGroupName) + "left").append("<INPUT iType='data' TYPE=CHECKBOX NAME='chk" + item.DataElement_Id + "'/>" + item.DataElementName + "<br/>");
                        else
                            $("#" + ws(item.DataGroupName) + "right").append("<INPUT iType='data' TYPE=CHECKBOX NAME='chk" + item.DataElement_Id + "'/>" + item.DataElementName + "<br/>");
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
    
</script>


<h2>Welcome</h2>
		<div id="accordion">
			<div>

				<h3><a href="#">Active Jobs</a></h3>
				<div>
                     <table>
                                <tr>
                                    <th></th>
                                    <th>
                                        Job_Id
                                    </th>
                                    <th>
                                        Name
                                    </th>
                                    <th>
                                        IsTemplate
                                    </th>
                                </tr>

                            <% foreach (var item in Model) { %>
                            
                                <tr>
                                    <td>
                                        <%= Html.ActionLink("Edit", "Edit", new { id=item.Job_Id }) %> |
                                        <%= Html.ActionLink("Details", "Details", new { id=item.Job_Id })%>
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
			                </div>	  			            			            
			                <div class="buttons">
                              <button type="submit" class="previous" onclick="loadnext(2,1);"> <img src="/Content/wizard/images/arrow_left.png" alt="" /> Back </button>
                              <button type="submit" class="next" onclick="loadnext(2,3);"> Next <img src="/Content/wizard/images/arrow_right.png" alt=""/> </button>
                            </div>
			            </div>
			            <div id="tabs-4">
			                <div id="tabs4Content">
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
				                                          
			            
			            
			</div>
			</div>
	


<div id="draggable" class="ui-widget-content">
	<p>Drag me around</p>
</div>




</asp:Content>

