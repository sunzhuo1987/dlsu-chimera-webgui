<%-- 
    Document   : index
    Created on : 01 14, 14, 10:00:45 PM
    Author     : Emerson Chua
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="/ServletInitialize" />
<!DOCTYPE html>
<html>
    <head>
        <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700|Open+Sans:300italic,400,300,700' rel='stylesheet' type='text/css'>
        <link rel="stylesheet" type="text/css" href="packaged/css/semantic.css">
        <link rel="stylesheet" type="text/css" href="style.css">

        <script src="jquery.js"></script>
        <script src="jquery.sticky.js"></script>
        <script src="packaged/javascript/semantic.js"></script>
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="https://www.google.com/jsapi"></script>
        <script src="javascript.js"></script>

        <script type="text/javascript">
            google.load("visualization", "1", {packages: ["corechart"]});
            function drawChart(graph, _title, id) {
                //var dataTable = new google.visualization.DataTable(json);
                var data = google.visualization.arrayToDataTable(graph);
                var options = {
                    title: _title
                };
                var chart = new google.visualization.LineChart(document.getElementById('chart_div' + id));
                chart.draw(data, options);
            }
        </script>

        <script>
            $(document).ready(function() {
            <% if (request.getAttribute("runningtask") == "gathering") {%>
                initialize("gathering");

                var startgraphms = +new Date();
                $('#dcolumn').append("<div id='chart_div" + "dat_timed" + "' style='width:900px;height:500px;'></div>");
                $('#dcolumn').append("<div id='chart_div" + "dat_count" + "' style='width:900px;height:500px;'></div>");
                $('#dcolumn').append("<div id='chart_div" + "dat_tsize" + "' style='width:900px;height:500px;'></div>");
                $('#dcolumn').append("<div id='chart_div" + "dat_asize" + "' style='width:900px;height:500px;'></div>");
                $('#dcolumn').append("<div id='chart_div" + "dat_rates" + "' style='width:900px;height:500px;'></div>");
                var dat_timed = [['Time', 'Encounter Time Delta']]; //time delta graph
                var dat_count = [['Time', 'Encounter Count']]; //count graph
                var dat_tsize = [['Time', 'Total Encounter Size']]; //total size graph
                var dat_asize = [['Time', 'Average Encounter Size']]; //averge size graph
                var dat_rates = [['Time', 'Encounter Rate per Second']]; //rates graph
                var timer = setInterval(function() {
                    $.get('ServletDashboard', {
                        action: 'state'
                    }, function(responseText) {
                        //extract data
                        var datapoint = $.parseJSON(responseText);
                        var ms = +new Date();
                        var timeexisted = ms - (datapoint['timeCreatedNanos'] / 1000000);
                        var sec = timeexisted / 1000;
                        var timed = ((datapoint['lastLastEncounterNanos'] < 0) ? -1 : datapoint['lastEncounterNanos'] - datapoint['lastLastEncounterNanos']) / 1000000;
                        var count = datapoint['totalEncounters'] / 1000;
                        var tsize = datapoint['totalSize'] / 1024;
                        var asize = ((datapoint['totalEncounters'] > 0) ? datapoint['totalSize'] / datapoint['totalEncounters'] : datapoint['totalSize']) / 1024;
                        var rates = (sec > 0) ? datapoint['totalEncounters'] / sec : datapoint['totalEncounters'];
                        //insert into graph
                        var time = (ms - startgraphms) / 1000;
                        dat_timed.splice(1, 0, [time, timed]);
                        dat_count.splice(1, 0, [time, count]);
                        dat_tsize.splice(1, 0, [time, tsize]);
                        dat_asize.splice(1, 0, [time, asize]);
                        dat_rates.splice(1, 0, [time, rates]);
                        //delete out of scope data points
                        if (dat_timed.length > 22)
                            dat_timed = dat_timed.slice(0, 22);
                        if (dat_count.length > 22)
                            dat_count = dat_count.slice(0, 22);
                        if (dat_tsize.length > 22)
                            dat_tsize = dat_tsize.slice(0, 22);
                        if (dat_asize.length > 22)
                            dat_asize = dat_asize.slice(0, 22);
                        if (dat_rates.length > 22)
                            dat_rates = dat_rates.slice(0, 6);
//                        $('#dstats').text(debugObject(dat_timed));
                        drawChart(dat_timed, 'Encounter Time Delta', 'dat_timed');
                        drawChart(dat_count, 'Encounter Count', 'dat_count');
                        drawChart(dat_tsize, 'Total Encounter Size', 'dat_tsize');
                        drawChart(dat_asize, 'Average Encounter Size', 'dat_asize');
                        drawChart(dat_rates, 'Encounter Rate per Second', 'dat_rates');
                    }, 'html');

                }, 1200);
            <% } else if (request.getAttribute("runningtask") == "training") {%>
                initialize("training");
                $('#dstats').text('No graphs/statistics available for Training Phase.');
            <% } else if (request.getAttribute("runningtask") == "production") {%>
                initialize("production");
                
                var startgraphms = +new Date();
                $('#dcolumn').append("<div id='chart_div" + "dat_timed" + "' style='width:900px;height:500px;'></div>");
                $('#dcolumn').append("<div id='chart_div" + "dat_count" + "' style='width:900px;height:500px;'></div>");
                $('#dcolumn').append("<div id='chart_div" + "dat_tsize" + "' style='width:900px;height:500px;'></div>");
                $('#dcolumn').append("<div id='chart_div" + "dat_asize" + "' style='width:900px;height:500px;'></div>");
                $('#dcolumn').append("<div id='chart_div" + "dat_rates" + "' style='width:900px;height:500px;'></div>");
                var dat_timed = [['Time', 'Encounter Time Delta']]; //time delta graph
                var dat_count = [['Time', 'Encounter Count']]; //count graph
                var dat_tsize = [['Time', 'Total Encounter Size']]; //total size graph
                var dat_asize = [['Time', 'Average Encounter Size']]; //averge size graph
                var dat_rates = [['Time', 'Encounter Rate per Second']]; //rates graph
                var timer = setInterval(function() {
                    $.get('ServletDashboard', {
                        action: 'state'
                    }, function(responseText) {
                        //extract data
                        var datapoint = $.parseJSON(responseText);
                        var ms = +new Date();
                        var timeexisted = ms - (datapoint['timeCreatedNanos'] / 1000000);
                        var sec = timeexisted / 1000;
                        var timed = ((datapoint['lastLastEncounterNanos'] < 0) ? -1 : datapoint['lastEncounterNanos'] - datapoint['lastLastEncounterNanos']) / 1000000;
                        var count = datapoint['totalEncounters'] / 1000;
                        var tsize = datapoint['totalSize'] / 1024;
                        var asize = ((datapoint['totalEncounters'] > 0) ? datapoint['totalSize'] / datapoint['totalEncounters'] : datapoint['totalSize']) / 1024;
                        var rates = (sec > 0) ? datapoint['totalEncounters'] / sec : datapoint['totalEncounters'];
                        //insert into graph
                        var time = (ms - startgraphms) / 1000;
                        dat_timed.splice(1, 0, [time, timed]);
                        dat_count.splice(1, 0, [time, count]);
                        dat_tsize.splice(1, 0, [time, tsize]);
                        dat_asize.splice(1, 0, [time, asize]);
                        dat_rates.splice(1, 0, [time, rates]);
                        //delete out of scope data points
                        if (dat_timed.length > 22)
                            dat_timed = dat_timed.slice(0, 22);
                        if (dat_count.length > 22)
                            dat_count = dat_count.slice(0, 22);
                        if (dat_tsize.length > 22)
                            dat_tsize = dat_tsize.slice(0, 22);
                        if (dat_asize.length > 22)
                            dat_asize = dat_asize.slice(0, 22);
                        if (dat_rates.length > 22)
                            dat_rates = dat_rates.slice(0, 6);
//                        $('#dstats').text(debugObject(dat_timed));
                        drawChart(dat_timed, 'Encounter Time Delta', 'dat_timed');
                        drawChart(dat_count, 'Encounter Count', 'dat_count');
                        drawChart(dat_tsize, 'Total Encounter Size', 'dat_tsize');
                        drawChart(dat_asize, 'Average Encounter Size', 'dat_asize');
                        drawChart(dat_rates, 'Encounter Rate per Second', 'dat_rates');
                    }, 'html');

                }, 1200);
            <% } else { %>
                $('#dstats').text('No task is running.');
            <% }%>

                $('#dgbrowseseen').click(function() {
                    $('#dgbrowse').click();
                });
                $('#dgbrowse').on('change', function() {
                    $('#dgoutputfile').val($('#dgbrowse').val());
                });
                $('#tbrowseseen').click(function() {
                    $('#tbrowse').click();
                });
                $('#tbrowse').on('change', function() {
                    $('#ttrainingfile').val($('#tbrowse').val());
                });
                $('#pbrowseseen').click(function() {
                    $('#pbrowse').click();
                });
                $('#pbrowse').on('change', function() {
                    $('#pmodelfile').val($('#pbrowse').val());
                });

                $('#dgtrainingfilter').hide();
                $('#dgenabletrainingfilter').val('off');
                $('#dgenabletrainingfiltercb').checkbox({
                    'onEnable': function() {
                        $('#dgenabletrainingfilter').val('on');
                        $('#dgtrainingfilter').slideDown("slow");
                    },
                    'onDisable': function() {
                        $('#dgenabletrainingfilter').val('off');
                        $('#dgtrainingfilter').hide();
                    }
                });

                $('#dgpacketfilter').hide();
                $('#dgenablepacketfilter').val('off');
                $('#dgenablepacketfiltercb').checkbox({
                    'onEnable': function() {
                        $('#dgenablepacketfilter').val('on');
                        $('#dgpacketfilter').slideDown("slow");
                    },
                    'onDisable': function() {
                        $('#dgenablepacketfilter').val('off');
                        $('#dgpacketfilter').hide();
                    }
                });

                $('#tfilter').hide();
                $('#tenablefilter').val('off');
                $('#tenablefiltercb').checkbox({
                    'onEnable': function() {
                        $('#tenablefilter').val('on');
                        $('#tfilter').slideDown("slow");
                    },
                    'onDisable': function() {
                        $('#tenablefilter').val('off');
                        $('#tfilter').hide();
                    }
                });

                $('#dgpacketfilterswitch').val('off');
                $('#dgpacketfilterswitchcb').checkbox({
                    'onEnable': function() {
                        $('#dgpacketfilterswitch').val('on')
                    },
                    'onDisable': function() {
                        $('#dgpacketfilterswitch').val('off')
                    }
                });

                $('#dgattackswitch').val('off');
                $('#dgattackswitchcb').checkbox({
                    'onEnable': function() {
                        $('#dgattackswitch').val('on')
                    },
                    'onDisable': function() {
                        $('#dgattackswitch').val('off')
                    }
                });

                $('#texclude').val('off');
                $('#texcludecb').checkbox({
                    'onEnable': function() {
                        $('#texclude').val('on')
                    },
                    'onDisable': function() {
                        $('#texclude').val('off')
                    }
                });

                $('#psyslog').hide();
                $('#penablesyslog').val('off');
                $('#penablesyslogcb').checkbox({
                    'onEnable': function() {
                        $('#penablesyslog').val('on');
                        $('#psyslog').slideDown('slow');
                    },
                    'onDisable': function() {
                        $('#penablesyslog').val('off');
                        $('#psyslog').hide();
                    }
                });

                $('#psyslogport').hide();
                $('#penablesyslogport').val('off');
                $('#penablesyslogportcb').checkbox({
                    'onEnable': function() {
                        $('#penablesyslogport').val('on');
                        $('#psyslogport').slideDown('slow');
                    },
                    'onDisable': function() {
                        $('#penablesyslogport').val('off');
                        $('#psyslogport').hide();
                    }
                });

                $('#pfirewall').val('off');
                $('#pfirewallcb').checkbox({
                    'onEnable': function() {
                        $('#pfirewall').val('on');
                    },
                    'onDisable': function() {
                        $('#pfirewall').val('off');
                    }
                });
            });
        </script>

        <script>
            $(document).ready(function() {
                var rules = {
                    interface: {
                        identifier: 'interface',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please select the protected interface'
                            }
                        ]
                    }
                };
                var settings = {
                    onSuccess: function() {
                        document.getElementById('datagatherform').submit();
                        //submitDataGatheringForm();
                    }
                };
                $('#datagatherform').form(rules, settings);
            });
        </script>

        <script>
            $(document).ready(function() {
                var rules = {
                    outputfile: {
                        identifier: 'trainingfile',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please select a training file'
                            },
                            {
                                type: 'length[1]',
                                prompt: 'Training file should be in .ctset format'
                            }
                        ]
                    }
                };
                var settings = {
                    onSuccess: function() {
                        //submitTrainingForm();
                        document.getElementById('trainingform').submit();
                    }
                };
                $('#trainingform').form(rules, settings);
            });
        </script>

        <script>
            $(document).ready(function() {
                var rules = {
                    modelfile: {
                        identifier: 'modelfile',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please select a model file'
                            },
                            {
                                type: 'contains[.cmodel]',
                                prompt: 'Training file should be in .cmodel format'
                            }
                        ]
                    }
                };
                var settings = {
                    onSuccess: function() {
                        //submitProductionForm();
                        document.getElementById('productionform').submit();
                    }
                };
                $('#productionform').form(rules, settings);
            });
        </script>

        <script>
            $(document).ready(function() {
                var rules = {};
                var settings = {
                    onSuccess: function() {
                        submitConfigurationForm();
                    }
                };
                $('#configurationform').form(rules, settings);
            });
        </script>

        <script>
            $(document).ready(function() {
                var rules = {
                    firstName: {
                        identifier: 'first-name',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please enter your first name'
                            }
                        ]
                    },
                    lastName: {
                        identifier: 'last-name',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please enter your last name'
                            }
                        ]
                    },
                    username: {
                        identifier: 'username',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please enter a username'
                            }
                        ]
                    },
                    role: {
                        identifier: 'role',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please select a role'
                            }
                        ]
                    },
                    password: {
                        identifier: 'password',
                        rules: [
                            {
                                type: 'empty',
                                prompt: 'Please enter a password'
                            },
                            {
                                type: 'length[6]',
                                prompt: 'Your password must be at least 6 characters'
                            }
                        ]
                    },
                    terms: {
                        identifier: 'terms',
                        rules: [
                            {
                                type: 'checked',
                                prompt: 'You must agree to the terms and conditions'
                            }
                        ]
                    }
                };
                var settings = {
                    onSuccess: function() {
                        $('#ustartdimmer').dimmer('toggle');
                    }
                };
                $('#adduserform').form(rules, settings);
            });
        </script>



        <style type="text/css">
            #dgtab{display:none;}
            #ttab{display:none;}
            #ptab{display:none;}
            #ctab{display:none;}
            #itab{display:none;}
            #dtab{}
            #utab{display:none;}
        </style>

        <script type="text/javascript">
            function tab(tab) {
                document.getElementById('dgtab').style.display = 'none';
                document.getElementById('ttab').style.display = 'none';
                document.getElementById('ptab').style.display = 'none';
                //document.getElementById('ctab').style.display = 'none';
                document.getElementById('itab').style.display = 'none';
                document.getElementById('dtab').style.display = 'none';
                //document.getElementById('utab').style.display = 'none';

                document.getElementById('navdgtab').setAttribute("class", "blue item");
                document.getElementById('navttab').setAttribute("class", "blue item");
                document.getElementById('navptab').setAttribute("class", "blue item");
                //document.getElementById('navctab').setAttribute("class", "blue item");
                document.getElementById('navitab').setAttribute("class", "blue item");
                document.getElementById('navdtab').setAttribute("class", "blue item");
                //document.getElementById('navutab').setAttribute("class", "blue item");

                document.getElementById(tab).style.display = 'block';

                var d = document.getElementById('nav' + tab);
                d.className = "active " + d.className;
            }
        </script>

    <body>
        <div class="mainheader">
            <div class="tint"></div>

            <div class="minheader">

                <div class="ui labeled icon menu">
                    <a class="red item">
                        <i class="phone icon"></i>
                        Contact
                    </a>
                    <a class="green item">
                        <i class="help icon"></i>
                        Help
                    </a>
                    <!--<a class="teal item">
                        <i class="user icon"></i>
                        fechua
                    </a>-->
                </div>
                <img id="logo" class="ui image" src="images/chimera2.png">

            </div>
        </div>
        <div class="mainbody">
            <div class="minbody" id="tabs">
                <div class="wrapper">
                    <div class="sticky">
                        <div class="ui secondary vertical pointing menu" id="tabs">
                            <a class="active blue item" onclick="tab('dtab')" id="navdtab">
                                <i class="dashboard icon"></i> Dashboard
                            </a>
                            <a class="blue item" onclick="tab('dgtab')" id="navdgtab">
                                <i class="download disk icon"></i> Data Gathering
                            </a>
                            <a class="blue item" onclick="tab('ttab')" id="navttab">
                                <i class="wrench icon"></i> Training
                            </a>
                            <a class="blue item" onclick="tab('ptab')" id="navptab">
                                <i class="legal icon"></i> Production
                            </a>
                            <!--<a class="blue item" onclick="tab('ctab')" id="navctab">
                                <i class="settings icon"></i> Configuration
                            </a>-->
                            <a class="blue item" onclick="tab('itab')" id="navitab">
                                <i class="sitemap icon"></i> Interfaces
                            </a>
                            <!--<a class="blue item" onclick="tab('utab')" id="navutab">
                                <i class="users icon"></i> Users
                            </a>-->
                        </div>
                    </div>
                </div>

                <div id="Content_Area">

                    <div id="dtab">
                        <h2 class="ui dividing header">Dashboard</h2>
                        <div class="ui grid">
                            <div class="column" id="dcolumn">
                                <h4 class="ui header">About the Dashboard</h4>
                                <p>
                                    The cdiag command prints the state of a specified component.
                                    <br>The command will only work if there is an ongoing phase.
                                </p>
                                <div class="ui section divider"></div>

                                <div class="ui right overlay very wide floating sidebar" id="dside">
                                    <div class="ui form" style="padding:15px;">
                                        <div class="field">
                                            <p>Component state</p>
                                            <textarea></textarea>
                                        </div>
                                    </div>
                                </div>

                                <div id="dstats"></div>

                            </div>
                        </div>
                    </div>

                    <div id="dgtab">
                        <h2 class="ui dividing header">Data Gathering</h2>
                        <div class="ui grid">
                            <div class="column" id="dgcolumn">
                                <h4 class="ui header">About the Data Gathering</h4>
                                <p>The Data Gathering Phase includes packet capture and analysis of attacks which is already a preliminary work before implementing and running the system. It involves capturing the traffic flowing towards the DMZ and vice versa. CHIMERA places sniffed traffic onto a Packet Dump File and forwards packets out the appropriate interface.<br>
                                    <br>The cgather command starts the CHIMERA's Data Gathering phase.
                                    <br>The training set used in the Training Phase is compiled in this phase.
                                    <br>This phase produces the said training set using the traffic captured.
                                    <br>Training set produced is stored on a .csv file.
                                </p>


                                <div class="ui section divider"></div>

                                <h4 class="ui header" id="dgheaderchange">Data Gathering Settings</h4>
                                <div id="dghidden"></div>

                                <form class="ui form" id="datagatherform" action="ServletGathering" method="post">
                                    <div class="ui error message"></div>

                                    <div class="ui selection dropdown">
                                        <input name="interface" id="dginterface" type="hidden">
                                        <label>Protected Interface:</label>
                                        <div class="text">Select</div>
                                        <i class="dropdown icon"></i>
                                        <div class="menu" id="dgdropdown">
                                            <%
                                                int i = 0;
                                                while ((String) request.getAttribute("iface" + i) != null) {
                                            %>
                                            <div class="item" data-value="<%=(String) request.getAttribute("iface" + i)%>"><%=(String) request.getAttribute("iface" + i)%></div>
                                            <%
                                                    i++;
                                                }
                                            %>
                                        </div>
                                    </div>

                                    <div class="ui section divider"></div>

                                    <div class="ui message">
                                        <div class="ui toggle checkbox" id="dgenabletrainingfiltercb">
                                            <input type="checkbox" name="enabletrainingfilter" id="dgenabletrainingfilter">
                                            <label><b>Training Filter Expression</b></label>
                                        </div>

                                        <ul class="list">
                                            <li>If provided, the following apply:</li>
                                            <ul>
                                                <li>If the /attack flag is set, the following apply:</li>
                                                <ul>
                                                    <li>Matching packets are flagged as attacks.</li>
                                                    <li>Non matching packets are flagged as normal.</li>
                                                </ul>
                                                <li>If the /attack flag is not set, the following apply:</li>
                                                <ul>
                                                    <li>Matching packets are flagged as normal.</li>
                                                    <li>Non matching packets are flagged as attacks.</li>
                                                </ul>
                                            </ul>

                                            <li>If not provided, the following apply:</li>
                                            <ul>
                                                <li>If the /attack flag is set, the following apply:</li>
                                                <ul>
                                                    <li>All packets are flagged as attacks.</li>
                                                </ul>
                                            </ul>
                                            <ul>
                                                <li>If the /attack flag is not set, the following apply:</li>
                                                <ul>
                                                    <li>All packets are flagged as normal.</li>
                                                </ul>
                                            </ul>

                                        </ul>
                                    </div>

                                    <div style="margin-top:20px;display:block;" class="field" id="dgtrainingfilterfield">
                                        <textarea name="trainingfilter" id="dgtrainingfilter"></textarea>
                                    </div>

                                    <div style="margin-top:20px;display:block;" class="ui toggle checkbox" id="dgattackswitchcb">
                                        <input type="checkbox" name="attackswitch" id="dgattackswitch">
                                        <label>Mark traffic as attack</label>
                                    </div>

                                    <div class="ui section divider"></div>

                                    <div class="ui message">
                                        <div class="ui toggle checkbox" id="dgenablepacketfiltercb">
                                            <input type="checkbox" name="enablepacketfilter" id="dgenablepacketfilter">
                                            <label><b>JNetPcap Packet Filter Expression</b></label>
                                        </div>

                                        <ul class="list">
                                            <li>If provided, the following apply:</li>
                                            <ul>
                                                <li>If the /allow flag is set, the following apply:</li>
                                                <ul>
                                                    <li>Matching packets are included in the training set.</li>
                                                    <li>Non matching packets are excluded from the training set.</li>
                                                </ul>
                                                <li>If the /allow flag is not set, the following apply:</li>
                                                <ul>
                                                    <li>Matching packets are excluded from the training set.</li>
                                                    <li>Non matching packets are included in the training set.</li>
                                                </ul>
                                            </ul>

                                            <li>If not provided, the following apply:</li>
                                            <ul>
                                                <li>If the /allow flag is set, the following apply:</li>
                                                <ul>
                                                    <li>All packets are included in the training set.</li>
                                                </ul>
                                            </ul>
                                            <ul>
                                                <li>If the /allow flag is not set, the following apply:</li>
                                                <ul>
                                                    <li>All packets are excluded from the training set.</li>
                                                </ul>
                                            </ul>

                                        </ul>
                                    </div>

                                    <div style="margin-top:20px;display:block;" class="field" id="dgpacketfilterfield">
                                        <textarea name="packetfilter" id="dgpacketfilter"></textarea>
                                    </div>

                                    <div style="margin-top:20px;display:block;" class="ui toggle checkbox" id="dgpacketfilterswitchcb">
                                        <input type="checkbox" name="packetfilterswitch" id="dgpacketfilterswitch">
                                        <label>Allow packet filter switch</label>
                                    </div>

                                    <a class="ui teal submit button" style="margin-top:20px;">Start</a>
                                    <input type="text" id="dgaction" name="action" value="start" style="display:none;"/>
                                </form>
                                <div class="ui page dimmer" id="dgstopdimmer">
                                    <div class="content">
                                        <div class="center">
                                            <h2 class="ui inverted icon header">
                                                <i class="icon circular inverted emphasized green download disk"></i>
                                                Data Gathering successfully stopped!
                                                <div class="sub header">The training file is now available</div>
                                            </h2>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div id="ttab">
                        <h2 class="ui dividing header">Training</h2>
                        <div class="ui grid">
                            <div class="column" id="tcolumn">
                                <h4 class="ui header">About the Training Phase</h4>
                                <p>After capturing the needed information, CHIMERA goes into Training Phase where a decision tree is generated from the data captured during the Data Gathering Phase. The data to be used the normal network baseline is created on a day-to-day basis. The baselines and the simulated attacks act as input datasets to generate the decision tree. The simulated attacks are already trained before the Training Phase of the system.<br>

                                    <br>The ctrain command starts the CHIMERA's model building phase.
                                    <br>The 'normal' model used in the Production Phase is built in this phase.
                                    <br>This phase produces the said model using the training set captured during Data Gathering.
                                    <br>The model produced is stored on a .cmodel file.
                                </p>
                                <div class="ui section divider"></div>

                                <h4 class="ui header" id="theaderchange">Training Settings</h4>
                                <div id="thidden"></div>

                                <form class="ui form" id="trainingform" action="ServletTraining" method="post" enctype="multipart/form-data">
                                    <div class="ui error message"></div>

                                    <div class="field">
                                        <div class="ui pointing below label">
                                            Contains datasets or the tabled attributes of the traffic gathered during the Data Gathering Phase and should be in the .ctset format
                                        </div>
                                        <div class="ui fluid labeled action input">
                                            <div class="ui corner label">
                                                <i class="icon asterisk"></i>
                                            </div>
                                            <input type="text" placeholder="Choose training file..." id="ttrainingfile">
                                            <div class="ui button" id="tbrowseseen">Browse</div>
                                        </div>
                                    </div>

                                    <div class="ui message">
                                        <div class="ui toggle checkbox" id="tenablefiltercb">
                                            <input type="checkbox" name="enablefiltersample">
                                            <label><b>Attribute filter</b></label>
                                        </div>

                                        <input type="checkbox" name="enablefilter" id="tenablefilter" style="display:none;" checked>

                                        <!--<br>May be used to exclude certain attributes from the training set.-->
                                        <ul class="list">
                                            <li>If provided, the following apply:</li>
                                            <ul>
                                                <li>If the /exclude flag is set, the following apply:</li>
                                                <ul>
                                                    <li>Matching attributes are excluded.</li>
                                                    <li>Non matching attributes are included.</li>
                                                </ul>
                                                <li>If the /exclude flag is not set, the following apply</li>
                                                <ul>
                                                    <li>Matching attributes are not included.</li>
                                                    <li>Non matching attributes are excluded.</li>
                                                </ul>
                                            </ul>

                                            <li>If not provided, the following apply:</li>
                                            <ul>
                                                <li>If the /exclude flag is set, the following apply:</li>
                                                <ul>
                                                    <li>All attributes are excluded.</li>
                                                </ul>
                                            </ul>
                                            <ul>
                                                <li>If the /exclude flag is not set, the following apply:</li>
                                                <ul>
                                                    <li>All attributes are included.</li>
                                                </ul>
                                            </ul>

                                        </ul>
                                    </div>

                                    <div style="margin-top:20px;display:block;" class="field">
                                        <textarea name="filter" id="tfilter"></textarea>
                                    </div>

                                    <div style="margin-top:20px;display:block;" class="ui toggle checkbox" id="texcludecb">
                                        <input type="checkbox" name="exclude" id="texclude">
                                        <label>Exclude attributes</label>
                                    </div>

                                    <a class="ui teal submit button" style="margin-top:20px;">Start</a>
                                    <input type="text" name="action" value="start" style="display:none;"/>
                                    <input type="file" name="trainingfile" id="tbrowse" style="display:none;">
                                </form>

                                <div class="ui page dimmer" id="tstartdimmer">
                                    <div class="content">
                                        <div class="center">
                                            <h2 class="ui inverted icon header">
                                                <i class="icon circular inverted emphasized green wrench"></i>
                                                Training successfully started!
                                                <div class="sub header">View the progress bar to view its progress</div>
                                            </h2>
                                        </div>
                                    </div>
                                </div>
                                <div class="ui page dimmer" id="tfinishdimmer">
                                    <div class="content">
                                        <div class="center">
                                            <h2 class="ui inverted icon header">
                                                <i class="icon circular inverted emphasized green wrench"></i>
                                                Training completed successfully!
                                                <div class="sub header">Model file is now available</div>
                                            </h2>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div id="ptab">
                        <h2 class="ui dividing header">Production</h2>
                        <div class="ui grid">
                            <div class="column" id="pcolumn">
                                <h4 class="ui header">About the Production Phase</h4>
                                <p>The Production Phase involves analyzing the traffic coming into the DMZ and back, while performing state calculations and updates, and evaluation on inbound traffic using layer 7 inspections and analysis of the current network traffic using the decision tree generated during the Training Phase. The decision tree is responsible for differentiating normal from anomalous behavior. Based on the results, certain packets are either allowed to pass or be dropped.<br>

                                    <br>The cproduce command starts the CHIMERA's Production phase.
                                    <br>The 'normal' model produced in the Training Phase is used in this phase.
                                    <br>This phase checks network traffic for possible Denial-of-Service attacks.
                                    <br>Upon the discovery of an attack, logs and rules can optionally be created.
                                </p>
                                <div class="ui section divider"></div>

                                <h4 class="ui header" id="pheaderchange">Production Settings</h4>
                                <div id="phidden"></div>

                                <form class="ui form" id="productionform" action="ServletProduction" method="post" enctype="multipart/form-data">
                                    <div class="ui error message"></div>

                                    <div class="ui pointing below label">
                                        The output file of the training phase in the .cmodel format
                                    </div>

                                    <div class="field">
                                        <div class="ui fluid labeled action input">
                                            <div class="ui corner label">
                                                <i class="icon asterisk"></i>
                                            </div>
                                            <input type="text" placeholder="Choose model file..." id="pmodelfile">
                                            <div class="ui button" id="pbrowseseen">Browse</div>
                                        </div>
                                    </div>

                                    <div style="margin-top:20px;display:block;" class="ui toggle checkbox" id="penablesyslogcb">
                                        <input type="checkbox" name="enablesyslogsample">
                                        <label>Specify syslog server address</label>
                                    </div>
                                    <input type="checkbox" name="enablesyslog" id="penablesyslog" style="display:none;" checked>
                                    <div class="field" style="margin-top:20px;" >
                                        <input type="text" placeholder="Syslog server address..." name="syslog" id="psyslog">
                                    </div>


                                    <div style="margin-top:20px;display:block;" class="ui toggle checkbox" id="penablesyslogportcb">
                                        <input type="checkbox" name="enablesyslogportsample">
                                        <label>Specify syslog server port</label>
                                    </div>
                                    <input type="checkbox" name="enablesyslogport" id="penablesyslogport" style="display:none;" checked>
                                    <div class="field" style="margin-top:20px;" >
                                        <input type="text" placeholder="Syslog server port..." name="syslogport" id="psyslogport">
                                    </div>

                                    <div style="margin-top:20px;display:block;" class="ui toggle checkbox" id="pfirewallcb">
                                        <input type="checkbox" name="firewall" id="pfirewall">
                                        <label>Create firewall rules</label>
                                    </div>

                                    <a class="ui teal submit button" style="margin-top:20px;">Start</a>
                                    <input type="text" name="action" value="start" style="display:none;"/>
                                    <input type="file" name="modelfile" id="pbrowse" style="display:none;">
                                </form>

                                <div class="ui page dimmer" id="pstartdimmer">
                                    <div class="content">
                                        <div class="center">
                                            <h2 class="ui inverted icon header">
                                                <i class="icon circular inverted emphasized green legal"></i>
                                                Production successfully started!
                                                <div class="sub header">View the progress bar to view its progress</div>
                                            </h2>
                                        </div>
                                    </div>
                                </div>

                                <div class="ui right overlay very wide floating sidebar" id="pside">
                                    <div class="ui form" style="padding:15px;">
                                        <div class="field">
                                            <p>Output messages</p>
                                            <textarea></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="ctab">
                        <h2 class="ui dividing header">Configurations</h2>
                        <div class="ui grid">
                            <div class="column">
                                <h4 class="ui header">About the Configuration</h4>
                                <p>This page allows the administrator to input additional parameters that will affect the system's operation.<br>

                                    <br>The cdiag command prints the state of a specified component.
                                    <br>The command will only work if there is an ongoing phase."
                                </p>
                                <div class="ui section divider"></div>

                                <div class="ui success message">
                                    <i class="close icon"></i>
                                    <div class="header">
                                        Settings successfully saved!
                                    </div>
                                </div>
                                
                                <h4 class="ui header">Parameters</h4>

                                <div class="ui form" id="configurationform" action="ServletConfig" method="post">
                                    <div class="two fields">
                                        <div class="field">
                                            <div class="ui pointing below label">
                                                The amount of time before a TCP state is allowed to be idle
                                            </div>
                                            <input type="text" placeholder="TCP state timeout..." name="tcptimeout" id="ctcptimeout">
                                        </div>

                                        <div class="field">
                                            <div class="ui pointing below label">
                                                The amount of time before a criteria instance is allowed to be idle
                                            </div>
                                            <input type="text" placeholder="Criteria instance timeout..." name="criteriatimeout" id="ccriteriatimeout">
                                        </div>
                                    </div>

                                    <div class="field">
                                        <div class="ui pointing below label">
                                            The port to listen for control messages during deployment
                                        </div>
                                        <input type="text" placeholder="Control message port number..." name="controlport" id="ccontrolport">
                                    </div>

                                    <div class="field" style="margin-top:20px;" >
                                        <input type="text" placeholder="Syslog server port number..." name="csyslogport" id="csyslogport">
                                    </div>

                                    <div class="ui selection dropdown">
                                        <input name="confinterface" type="hidden" id="cconfinterface">
                                        <label>Protected Interface:</label>
                                        <div class="text">Select</div>
                                        <i class="dropdown icon"></i>
                                        <div class="menu" id="dgdropdown">
                                            <%
                                                int i2 = 0;
                                                while ((String) request.getAttribute("iface" + i2) != null) {
                                            %>
                                            <div class="item" data-value="<%=(String) request.getAttribute("iface" + i2)%>"><%=(String) request.getAttribute("iface" + i2)%></div>
                                            <%
                                                    i2++;
                                                }
                                            %>
                                        </div>
                                    </div>

                                    <div class="ui page dimmer" id="cstartdimmer">
                                        <div class="content">
                                            <div class="center">
                                                <h2 class="ui inverted icon header">
                                                    <i class="icon circular inverted emphasized green download disk"></i>
                                                    Configuration successfully saved and applied!
                                                    <div class="sub header">Configuration is now being used by the currently running task</div>
                                                </h2>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="margin-top:20px;">
                                        <a class="ui teal submit button" name="action" value="apply">Apply</a>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div id="itab">
                        <h2 class="ui dividing header">Interfaces</h2>
                        <div class="ui grid">
                            <div class="column">
                                <h4 class="ui header">About the Interfaces</h4>
                                <p>
                                    The cifaces command prints the configuration of all detected interfaces.
                                    <br>The index of an interface is indicated by its position in the output list.
                                </p>
                                <div class="ui section divider"></div>

                                <div class="ui list">
                                    <%
                                        int n = 0;
                                        while ((String) request.getAttribute("iface" + n) != null) {
                                    %>
                                    <div class="item">
                                        <i class="sitemap image icon"></i>
                                        <div class="content">
                                            <div class="header"><%=(String) request.getAttribute("iface" + n)%></div>
                                            <%=(String) request.getAttribute("ifacedesc" + n)%>
                                        </div>
                                        <div class="list">
                                            <div class="item">
                                                <i class="desktop icon"></i>
                                                <div class="content">
                                                    <a class="header">Hardware Address</a>
                                                    <div class="description"><%=(String) request.getAttribute("ifacehard" + n)%></div>
                                                </div>
                                            </div>
                                            <div class="item">
                                                <i class="url icon"></i>
                                                <div class="content">
                                                    <a class="header">IP Address</a>
                                                    <div class="description"><%=(String) request.getAttribute("ifaceip" + n)%></div>
                                                </div>
                                            </div>
                                            <div class="item">
                                                <i class="code icon"></i>
                                                <div class="content">
                                                    <a class="header">Subnet Mask</a>
                                                    <div class="description"><%=(String) request.getAttribute("ifacesubnet" + n)%></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%
                                            n++;
                                        }
                                    %>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div id="utab">
                        <h2 class="ui dividing header">Users</h2>
                        <div class="ui grid">
                            <div class="column">
                                <h4 class="ui header">About Users</h4>
                                <p>These are sets of username and passwords assigned to people who are authorized to configure the system with certain levels of permissions and priveleges.
                                </p>
                                <div class="ui section divider"></div>

                                <div class="ui success message">
                                    <i class="close icon"></i>
                                    <div class="header">
                                        User successfully added!
                                    </div>
                                </div>

                                <div class="ui fluid left icon action input">
                                    <i class="users icon"></i>
                                    <input type="text" placeholder="Search users...">
                                    <div class="ui button">Search</div>
                                </div>

                                <div class="ui page dimmer" id="ustartdimmer">
                                    <div class="content">
                                        <div class="center">
                                            <h2 class="ui inverted icon header">
                                                <i class="icon circular inverted emphasized green download disk"></i>
                                                User successfully added!
                                                <div class="sub header">User can now login to the system</div>
                                            </h2>
                                        </div>
                                    </div>
                                </div>

                                <div style="margin-top:20px;" class="ui active button" id="newuser">
                                    <i class="user icon"></i>
                                    Add User
                                </div>

                                <div class="ui right overlay very wide floating sidebar" id="uside">
                                    <form class="ui form" id="adduserform" action="ServletUsers" method="post" style="margin:20px;">

                                        <div class="ui error message"></div>
                                        <div class="two fields">
                                            <div class="field">
                                                <div class="ui labeled icon input">
                                                    <div class="ui corner label">
                                                        <i class="icon asterisk"></i>
                                                    </div>
                                                    <input placeholder="First Name" name="first-name" type="text">
                                                </div>
                                            </div>
                                            <div class="field">
                                                <div class="ui labeled icon input">
                                                    <div class="ui corner label">
                                                        <i class="icon asterisk"></i>
                                                    </div>
                                                    <input placeholder="Last Name" name="last-name" type="text">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui left labeled icon input">
                                                <input type="text" placeholder="Username" name="username">
                                                <i class="user icon"></i>
                                                <div class="ui corner label">
                                                    <i class="icon asterisk"></i>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui left labeled icon input">
                                                <input type="password" name="password">
                                                <i class="lock icon"></i>
                                                <div class="ui corner label">
                                                    <i class="icon asterisk"></i>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="field">
                                            <div class="ui selection dropdown">
                                                <input type="hidden" name="role">
                                                <label>Role:</label>
                                                <div class="text">Select</div>
                                                <i class="dropdown icon"></i>
                                                <div class="menu">
                                                    <div class="item" data-value="admin">Admin</div>
                                                    <div class="item" data-value="moderator">Moderator</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="inline field">
                                            <div class="ui checkbox">
                                                <input type="checkbox" name="terms">
                                                <label>I agree to the Terms and Conditions</label>
                                            </div>
                                        </div>

                                        <div class="ui blue submit button" name="action" value="submit">Submit</div>

                                    </form>
                                </div>

                                <div class="ui divided selection list">
                                    <div class="item">
                                        <img class="ui avatar image" src="images/users/emer.jpg">
                                        <div class="content">
                                            <div class="header">Emerson Chua</div>
                                            Admin
                                        </div>
                                    </div>
                                    <div class="item">
                                        <img class="ui avatar image" src="images/users/nikkol.jpg">
                                        <div class="content">
                                            <div class="header">Nikkol Morales</div>
                                            Admin
                                        </div>
                                    </div>
                                    <div class="item">
                                        <img class="ui avatar image" src="images/users/johnp.jpg">
                                        <div class="content">
                                            <div class="header">John Penafiel</div>
                                            Admin
                                        </div>
                                    </div>
                                    <div class="item">
                                        <img class="ui avatar image" src="images/users/jeno.jpg">
                                        <div class="content">
                                            <div class="header">Jeno Rigor</div>
                                            Admin
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div> <!-- Content Area End -->

            </div>
        </div>
    </body>
</html>
