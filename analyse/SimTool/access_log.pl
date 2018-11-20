<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href=/nino/css/sim.css ></HEAD><BODY>
<FORM action=/mod_perl/njobs.pl target=_self method=POST ><INPUT TYPE="hidden" NAME="action" VALUE="showfile" ><INPUT TYPE="hidden" NAME="snmpini" VALUE="/applusr/pals/nino/conf/snmp.ini" >
<ul id="qm0" class="qmmc">

	<li><a class="qmparent" href="javascript:void(0);"><IMG SRC=/nino/images/ninologo.gif BORDER=0></a>

		<ul>
		<li><a href="/mod_perl/nino.pl?action=getversion">About</a></li>
		<li><a href="/mod_perl/njobs.pl?action=print_comments">Help</a></li>
		</ul></li>

	<li><a class="qmparent" href="javascript:void(0);">File</a>

		<ul>
		<li><a href="/mod_perl/nino.pl?action=selectfile&dir=htdocs%2Fnino%2Freports">Open reports</a></li>
		<li><a href="/mod_perl/njobs.pl?action=selectdata">Open data</a></li>
		<li><a href="/mod_perl/njobs.pl?action=selectweb">Open logs</a></li>
		<li><a href="javascript:self.close();">Quit</a></li>
		</ul></li>

        <li><a class="qmparent" href="javascript:void(0);">Edit</a>

                <ul>
                <li><a href="/mod_perl/nino.pl?action=input_response">Host / url</a></li>
                <li><a href="/mod_perl/nino.pl?action=choosemonitor">Monitoring</a></li>
                <li><a href="/mod_perl/nino.pl?action=inputdevice">New device</a></li>
                <li><a href="/mod_perl/nino.pl?action=cg_newconfig">New group</a></li>
                <li><a href="/mod_perl/nino.pl?action=cg_hostconfig">Group properties</a></li>
                <li><a href="/mod_perl/nino.pl?action=edit_devicetype">Device type</a></li>
                <li><a href="/mod_perl/admin.pl?action=adminaaa">Security</a>
                <ul>
                  <li><a href="/mod_perl/admin.pl?action=userlist">Users</a></li>
                  <li><a href="/mod_perl/admin.pl?action=inputgroup">Groups</a></li>
                  <li><a href="/mod_perl/admin.pl?action=inputfunctions">Functions</a></li>
                  <li><a href="/mod_perl/admin.pl?action=ninoaaa">Configuration</a></li>
                </ul>
                </li>
                <li><a href="javascript:void(0);">Administration</a>

                <UL>
                <li><a href="/mod_perl/admin.pl?action=severityadmin">Severity</a></li>
                <li><a href="/mod_perl/admin.pl?action=edittable">Database tables</a></li>
                <li><a href="/mod_perl/admin.pl?action=expimpdb">Import/Export database</a></li>
                <li><a href="/mod_perl/nino.pl?action=diagmenu">Diagnostic</a></li>
                <li><a href="/mod_perl/admin.pl?action=ninoadmin">Configuration</a></li>
                <li><a href="/mod_perl/admin.pl?action=listconfigpreset">Import presets</a></li>
                </ul>
                </li>


                </ul></li>

        <li><a class="qmparent" href="javascript:void(0);">Events</a>

                <ul>
                <li><a href="/mod_perl/nino.pl?action=inputreport">Report</a></li>
                <li><a href="/mod_perl/nino.pl?action=draw_fish">Dashboard</a></li>
                <li><a href="/mod_perl/nino.pl?action=events">Events</a></li>
                <li><a href="/mod_perl/nino.pl?action=categories">Status</a></li>
                <li><a href="/mod_perl/nino.pl?action=listdevices">Devices</a></li>
                <li><a href="/mod_perl/nino.pl?action=templates">Templates</a></li>
                <li><a href="/mod_perl/njobs.pl?action=eventstatus&host=pccstg1">Events pccstg1</a></li>
                <li><a href="/mod_perl/njobs.pl?action=eventstatus&host=pcsstg1">Events pcsstg1</a></li>
                <li><a href="/mod_perl/njobs.pl?action=eventstatus&host=plistg1">Events plistg1</a></li>
                <li><a href="/mod_perl/njobs.pl?action=logcheck">Log monitor</a></li>
                </ul></li>

        <li><a class="qmparent" href="javascript:void(0);">Jobs</a>

                <ul>
                <li><a href="/mod_perl/njobs.pl?action=jobstatus">Job status</a></li>
                <li><a href="/mod_perl/njobs.pl?action=searchjob">Job search</a></li>
                <li><a href="/mod_perl/njobs.pl?action=inputjob">Schedule job</a></li>
                <li><a href="/mod_perl/njobs.pl?action=jobsummary">Job summary</a></li>
                <li><a href="/mod_perl/njobs.pl?action=jobcleanup">Job cleanup</a></li>
                <li><a href="/mod_perl/njobs.pl?action=editjob">Edit job</a></li>
                <li><a href="/mod_perl/njobs.pl?action=edittask">Edit task</a></li>
                <li><a href="/mod_perl/njobs.pl?action=task_filetransfers">File transfers</a></li>
                </ul></li>


        <li><a class="qmparent" href="javascript:void(0);">Tools</a>

                <ul>
                <li><a href="/mod_perl/nino.pl?action=inputipscan">Discover IP range</a></li>
                <li><a href="/mod_perl/nino.pl?action=inputnetworkscan">Discover Network</a></li>
                <li><a href="/mod_perl/nino.pl?action=inputfilescan">Discover using feed file </a></li>
                <li><a href="/mod_perl/nino.pl?action=scanmac">Scan MAC addresses</a></li>
                <li><a href="/mod_perl/nino.pl?action=inputgo">SNMP Query devices</a></li>
                <li><a href="/mod_perl/nino.pl?action=inputsnmpwalk">SNMP Walk</a></li>
                <li><a href="/mod_perl/nino.pl?action=inputtrap">SNMP trap send</a></li>
                <li><a href="/mod_perl/nino.pl?action=input_find_oid">Search MIB database</a></li>
                <li><a href="/mod_perl/nino.pl?action=mibexplore">MIB Browser</a></li>
                <li><a href="/mod_perl/nino.pl?action=inputmibs">Import MIB files</a></li>
                </ul></li>

        <li><a class="qmparent" href="javascript:void(0);">System</a>

                <ul>
                <li><a href="/mod_perl/njobs.pl?action=show_config">Show config</a></li>
                <li><a href="/mod_perl/njobs.pl?action=show_storage">Data storage</a></li>
                <li><a href="/mod_perl/njobs.pl?action=systemstat">System status</a></li>
                <li><a href="/mod_perl/njobs.pl?action=top">Top processes</a></li>
                </ul></li>

<li class="qmclear">&nbsp;</li></ul>

<INPUT TYPE="hidden" NAME="file" VALUE="access_log" ><INPUT TYPE="hidden" NAME="dir" VALUE="/applusr/pals/nino/logs" ><TABLE class=style_table><TR ><TD class=style_alt_td><A HREF="/mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs&file=access_log&start=0&max=60&search=" >|<</A></TD><TD class=style_alt_td><A HREF="/mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs&file=access_log&start=0&max=60&search=" ><<</A></TD><TD class=style_alt_td><A HREF="/mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs&file=access_log&start=60&max=60&search=" >>></A></TD><TD class=style_alt_td><A HREF="/mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs&file=access_log&start=last&max=60&search=" >>|</A></TD><TD class=style_alt_td><INPUT TYPE="text" NAME="start" VALUE="0" SIZE="5" MAXLENGTH="15" ></TD><TD class=style_alt_td> Lines: </TD><TD class=style_alt_td><INPUT TYPE="text" NAME="max" VALUE="60" SIZE="5" MAXLENGTH="5" ></TD><TD class=style_alt_td>Search:</TD><TD class=style_alt_td><INPUT TYPE="text" NAME="search" VALUE="" SIZE="" MAXLENGTH="" ><INPUT TYPE="submit" NAME="submit" VALUE=GO ></TD><TD class=style_alt_td><A HREF="/mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs&file=access_log&start=0&max=4000000&mode=download&search=" TARGET="new" ><IMG SRC="/nino/images/FOLDEROPEN.GIF" ALT="Download"  BORDER=0 ></A><A HREF="/mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs&file=access_log&start=0&max=4000000&mode=view&search=" TARGET="new" ><IMG SRC="/nino/images/ITEM.GIF" ALT="View"  BORDER=0 ></A></TD><TD class=style_alt_td><A HREF="/mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs&file=access_log&start=0&max=60&mode=view&search=" TARGET="new" >access_log</A></TD></TR></TABLE><PRE><FONT size=2>130.144.96.239 - jgerstel [19/Sep/2017:10:54:22 +0200] "GET /mod_perl/njobs.pl HTTP/1.1" 200 42733
130.144.96.239 - jgerstel [19/Sep/2017:10:54:31 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=145943&archive= HTTP/1.1" 200 7838
130.144.96.239 - jgerstel [19/Sep/2017:10:54:34 +0200] "GET /mod_perl/njobs.pl?action=jobcontrol&id=145943&job=sdl-london-to-pikachu HTTP/1.1" 200 6653
130.144.96.239 - jgerstel [19/Sep/2017:10:54:35 +0200] "GET /mod_perl/njobs.pl?action=jobcontrol&control=play&id=145943&job=sdl-london-to-pikachu HTTP/1.1" 200 6332
130.144.96.239 - jgerstel [19/Sep/2017:10:54:37 +0200] "GET /mod_perl/njobs.pl?action=jobstatus HTTP/1.1" 200 43138
130.144.96.239 - jgerstel [19/Sep/2017:10:54:39 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=146008&archive= HTTP/1.1" 200 7707
130.144.96.239 - jgerstel [19/Sep/2017:10:54:41 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&job=sdl-london-to-pikachu&max=2000&search= HTTP/1.1" 200 9
340
130.144.96.239 - jgerstel [19/Sep/2017:10:54:44 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9338
130.144.96.239 - jgerstel [19/Sep/2017:10:54:46 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9338
130.144.96.239 - jgerstel [19/Sep/2017:10:54:48 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9338
130.144.96.239 - jgerstel [19/Sep/2017:10:54:53 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:54:53 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:54:55 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:54:57 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:54:58 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:54:59 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:55:00 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:55:00 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:55:00 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:55:01 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:55:04 +0200] "GET /mod_perl/njobs.pl?action=jobstatus HTTP/1.1" 200 43152
130.144.96.239 - jgerstel [19/Sep/2017:10:55:07 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=145577&archive= HTTP/1.1" 200 7786
130.144.96.239 - jgerstel [19/Sep/2017:10:55:09 +0200] "GET /mod_perl/njobs.pl?action=jobarchive&id=145577 HTTP/1.1" 200 42760
130.144.96.239 - jgerstel [19/Sep/2017:10:55:11 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=145989&archive= HTTP/1.1" 200 7841
130.144.96.239 - jgerstel [19/Sep/2017:10:55:13 +0200] "GET /mod_perl/njobs.pl?action=jobarchive&id=145989 HTTP/1.1" 200 42242
130.144.96.239 - jgerstel [19/Sep/2017:10:55:15 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=144420&archive= HTTP/1.1" 200 7734
130.144.96.239 - jgerstel [19/Sep/2017:10:55:16 +0200] "GET /mod_perl/njobs.pl?action=jobarchive&id=144420 HTTP/1.1" 200 41804
130.144.96.239 - jgerstel [19/Sep/2017:10:55:20 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=146008&archive= HTTP/1.1" 200 7793
130.144.96.239 - jgerstel [19/Sep/2017:10:55:22 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&job=sdl-london-to-pikachu&max=2000&search= HTTP/1.1" 200 9
564
130.144.96.239 - jgerstel [19/Sep/2017:10:55:28 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9650
130.144.96.239 - jgerstel [19/Sep/2017:10:55:31 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9667
130.144.96.239 - jgerstel [19/Sep/2017:10:55:34 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9667
130.144.96.239 - jgerstel [19/Sep/2017:10:55:35 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9667
130.144.96.239 - jgerstel [19/Sep/2017:10:55:38 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 9695
130.144.96.239 - jgerstel [19/Sep/2017:10:58:51 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146008.log&start=last&max=2000&search= HTTP/1.1" 200 11901
130.144.96.239 - jgerstel [19/Sep/2017:10:59:02 +0200] "GET /mod_perl/njobs.pl?action=jobstatus HTTP/1.1" 200 41800
130.144.96.239 - jgerstel [19/Sep/2017:10:59:04 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=146008&archive= HTTP/1.1" 200 7796
130.144.96.239 - jgerstel [19/Sep/2017:10:59:06 +0200] "GET /mod_perl/njobs.pl?action=jobcontrol&id=146008&job=sdl-london-to-pikachu HTTP/1.1" 200 6647
130.144.96.239 - jgerstel [19/Sep/2017:10:59:07 +0200] "GET /mod_perl/njobs.pl?action=jobcontrol&control=stop&id=146008&job=sdl-london-to-pikachu HTTP/1.1" 200 6739
130.144.96.239 - jgerstel [19/Sep/2017:10:59:09 +0200] "GET /mod_perl/njobs.pl?action=jobcontrol&control=kill&id=146008&job=sdl-london-to-pikachu HTTP/1.1" 200 6317
130.144.96.239 - jgerstel [19/Sep/2017:10:59:14 +0200] "GET /mod_perl/njobs.pl?action=jobstatus HTTP/1.1" 200 41791
130.144.96.239 - jgerstel [19/Sep/2017:10:59:18 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=146008&archive= HTTP/1.1" 200 7827
130.144.96.239 - jgerstel [19/Sep/2017:10:59:20 +0200] "GET /mod_perl/njobs.pl?action=jobcontrol&id=146008&job=sdl-london-to-pikachu HTTP/1.1" 200 6653
130.144.96.239 - jgerstel [19/Sep/2017:10:59:21 +0200] "GET /mod_perl/njobs.pl?action=jobcontrol&control=play&id=146008&job=sdl-london-to-pikachu HTTP/1.1" 200 6332
130.144.96.239 - jgerstel [19/Sep/2017:10:59:23 +0200] "GET /mod_perl/njobs.pl?action=jobstatus HTTP/1.1" 200 42196
130.144.96.239 - jgerstel [19/Sep/2017:10:59:26 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=146010&archive= HTTP/1.1" 200 7707
130.144.96.239 - jgerstel [19/Sep/2017:10:59:27 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146010.log&job=sdl-london-to-pikachu&max=2000&search= HTTP/1.1" 200 9
340
130.144.96.239 - jgerstel [19/Sep/2017:10:59:29 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146010.log&start=last&max=2000&search= HTTP/1.1" 200 9338
130.144.96.239 - jgerstel [19/Sep/2017:10:59:34 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146010.log&start=last&max=2000&search= HTTP/1.1" 200 9338
130.144.96.239 - jgerstel [19/Sep/2017:10:59:37 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146010.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:59:40 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146010.log&start=last&max=2000&search= HTTP/1.1" 200 9366
130.144.96.239 - jgerstel [19/Sep/2017:10:59:46 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146010.log&start=last&max=2000&search= HTTP/1.1" 200 9958
130.144.96.239 - jgerstel [19/Sep/2017:10:59:56 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146010.log&start=last&max=2000&search= HTTP/1.1" 200 11185
130.144.96.239 - jgerstel [19/Sep/2017:11:01:48 +0200] "GET /mod_perl/njobs.pl?action=showfile&dir=%2Fapplusr%2Fpals%2Fnino%2Flogs%2Fscripts%2Fsdl-london-to-pikachu&file=sdl-london-to-pikachu.20170919.146010.log&start=last&max=2000&search= HTTP/1.1" 200 12390
130.144.96.239 - jgerstel [19/Sep/2017:11:02:21 +0200] "GET /mod_perl/njobs.pl?action=jobstatus HTTP/1.1" 200 42287
130.144.96.239 - jgerstel [19/Sep/2017:11:02:23 +0200] "GET /mod_perl/njobs.pl?action=jobinfo&id=146010&archive= HTTP/1.1" 200 7796
130.144.96.239 - jgerstel [19/Sep/2017:11:02:25 +0200] "GET /mod_perl/njobs.pl?action=jobcontrol&id=146010&job=sdl-london-to-pikachu HTTP/1.1" 200 6647
</FONT></PRE>
</FORM></BODY></HTML>
