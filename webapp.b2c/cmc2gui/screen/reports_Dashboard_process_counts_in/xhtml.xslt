<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:f="http://www.philips.com/functions">

   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   <xsl:param name="project_code"/>
   <xsl:param name="exact_match"/>
   <xsl:param name="gui_url"/>
   <xsl:param name="section"/>
   <xsl:param name="p_period">60</xsl:param>

   <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>
   <xsl:variable name="colorcodeRunning" select="'#00FF00'"/>
   <!--Green-->
   <xsl:variable name="colorcodeSuspect" select="'#FFA500'"/>
   <!--Orange-->
   <xsl:variable name="colorcodeError"   select="'#FF0000'"/>
   <!--Red-->
   <xsl:variable name="colorcodeWarning" select="'#FF00FF'"/>
   <!--Magenta-->
   
   <xsl:variable name="xMax" select="number('360')"/>
   <xsl:variable name="yMax" select="number('300')"/>
   <xsl:variable name="maxDays" select="number($p_period)"/>
   <xsl:variable name="startDay" select="min(/root/sql:rowset/sql:row/sql:day_of_year)"/>
   <xsl:variable name="maxCount" select="max(/root/sql:rowset/sql:row/sql:object_count_out)"/>
   <xsl:variable name="maxRuntime" select="max(/root/sql:rowset/sql:row/sql:runtime_minutes)"/>

   <xsl:template match="/root">
      <html>
         <body>
            <h1>Pikachu Performance Dashboard Runtime Details</h1>
            <p />
            <p />
            <hr />
            <p>Volume-out for the process : <strong><xsl:value-of select="sql:rowset/sql:row[1]/sql:process_name"/></strong>.
            </p>
            <p>The moving average is calculated over a 7-day period. The results are shown over the last <xsl:value-of select="$p_period"/> day period.
            <br />
            The average object count is calculated over all historic data.
            </p>
            <p>
               <script type="image/svg+xml">
               <svg width="600px" height="450px" viewBox="-15 -15 440 335">
                  <!-- Draw X and Y axis -->
                  <xsl:call-template name="draw_axis"/>
                  <!-- Draw legend -->
                  <xsl:call-template name="draw_legend"/>
                  <!-- draw datasets -->
                  <xsl:call-template name="draw_datasets"/>
                  <!-- Draw Right axis -->
                  <xsl:call-template name="draw_rightAxis"/>
                  <!-- Draw datasets -->
                  <xsl:call-template name="draw_timesets"/>
               </svg>
               </script>
            </p>
            <br /><br />
            <hr />
            <xsl:choose>
               <xsl:when test="sql:rowset/sql:row">
                  <table class="main">
                     <tr>
                        <td>Day</td>
                        <td>Date</td>
                        <td>Runtime</td>
                        <td>Object count</td>
                        <td>Avg Object count</td>
                        <td>Moving average Object count</td>
                     </tr>
                     <xsl:apply-templates select="sql:rowset/sql:row"/>
                  </table>
                  <p>
                     <br/>
                     <strong>Legend:</strong>
                     <table border="1" cellspacing="0" cellpadding="0">
                        <tr>
                           <th>Color</th>
                           <th>Meaning</th>
                        </tr>
                        <tr>
                           <td>
                              <xsl:attribute name="bgcolor" select="$colorcodeError"/>Red</td>
                           <td>Object count is larger then 1.5x the average for the process</td>
                        </tr>
                        <tr>
                           <td>
                              <xsl:attribute name="bgcolor" select="$colorcodeRunning"/>Green</td>
                           <td>Object count is smaller then 0.5x the average for the process</td>
                        </tr>
                        <tr>
                           <td>
                              <xsl:attribute name="bgcolor" select="$colorcodeSuspect"/>Orange</td>
                           <td>Object count is between the two bounds</td>
                        </tr>
                     </table>
                     <br/>
                     <br/>
                  </p>
               </xsl:when>
               <xsl:otherwise>
                  <p>No data was found for the provided parameters (DEBUG: should not be possible).</p>
               </xsl:otherwise>
            </xsl:choose>
         </body>
      </html>
   </xsl:template>

   <xsl:template match="sql:row">
      <tr>
         <xsl:variable name="checkDuration">
            <xsl:value-of select="f:compDuration(sql:object_count_out, 0.5*sql:avg_object_count, 1.5*sql:avg_object_count)"/>
         </xsl:variable>
         <xsl:variable name="bgcolor" select="if ($checkDuration='error') then $colorcodeError
                                       else if ($checkDuration='suspect') then $colorcodeSuspect
                                       else if ($checkDuration='correct') then $colorcodeRunning
                                       else $colorcodeWarning
                                          ">
         </xsl:variable>

         <td align="left">
            <xsl:attribute name="bgcolor" select="$bgcolor"/>
            <xsl:value-of select="sql:day_of_week"/>
         </td>
         <td align="right">
            <xsl:attribute name="bgcolor" select="$bgcolor"/>
            <xsl:value-of select="sql:start_time"/>
         </td>
         <td align="right">
            <xsl:attribute name="bgcolor" select="$bgcolor"/>
            <xsl:value-of select="sql:runtime_minutes"/>
         </td>
         <td align="right">
            <xsl:attribute name="bgcolor" select="$bgcolor"/>
            <xsl:value-of select="sql:object_count_out"/>
         </td>
         <td align="right">
            <xsl:attribute name="bgcolor" select="$bgcolor"/>
            <xsl:value-of select="sql:avg_object_count"/>
         </td>
         <td align="right">
            <xsl:attribute name="bgcolor" select="$bgcolor"/>
            <xsl:value-of select="sql:moving_7day_average"/>
         </td>
      </tr>
   </xsl:template>
   <!-- -->
   <xsl:function name="f:compDuration" as="xs:string">
      <xsl:param name="dur" as="xs:string"/>
      <xsl:param name="avg_dur" as="xs:string"/>
      <xsl:param name="max_dur" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="number($dur) > number($max_dur)">
            <xsl:value-of select="'error'"/>
         </xsl:when>
         <xsl:when test="(number($dur) * 1.5) > number($avg_dur)">
            <xsl:value-of select="'suspect'"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'correct'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!-- SVG code -->
   <!-- Draw our X and Y axis, labeling them as we do -->
   <xsl:template name="draw_axis">
      <g style="stroke:black; stroke-width:0.25">
         <!-- draw axis lines -->
         <line x1="0" y1="0" x2="0" y2="{$yMax}" />
         <line x1="0" y1="{$yMax}" x2="{$xMax}" y2="{$yMax}" />

         <!-- tick marks for X axis -->
         <line x1="{number(0.00*$xMax)}" y1="{$yMax}" x2="{0.00*$xMax}" y2="{number($yMax - 5)}"/>
         <line x1="{number(0.17*$xMax)}" y1="{$yMax}" x2="{0.17*$xMax}" y2="{number($yMax - 5)}"/>
         <line x1="{number(0.34*$xMax)}" y1="{$yMax}" x2="{0.34*$xMax}" y2="{number($yMax - 5)}"/>
         <line x1="{number(0.51*$xMax)}" y1="{$yMax}" x2="{0.51*$xMax}" y2="{number($yMax - 5)}"/>
         <line x1="{number(0.68*$xMax)}" y1="{$yMax}" x2="{0.68*$xMax}" y2="{number($yMax - 5)}"/>
         <line x1="{number(0.84*$xMax)}" y1="{$yMax}" x2="{0.84*$xMax}" y2="{number($yMax - 5)}"/>
         <line x1="{number(1.00*$xMax)}" y1="{$yMax}" x2="{1.00*$xMax}" y2="{number($yMax - 5)}"/>
         <text x="{number(0.50*$xMax)}" y="{number(1.05*$yMax)}" style="text-anchor:start">x-axis (time)</text>
         <text x="{number(0.00*$xMax)}" y="{number(1.05*$yMax)}" style="text-anchor:start">-<xsl:value-of select="$p_period"/> days</text>
         <text x="{number(0.95*$xMax)}" y="{number(1.05*$yMax)}" style="text-anchor:start">now</text>

         <!-- tick marks for Y axis -->
         <line x1="0" y1="{number(0.00*$yMax)}" x2="5" y2="{number(0.00*$yMax)}"/>
         <line x1="0" y1="{number(0.50*$yMax)}" x2="5" y2="{number(0.50*$yMax)}"/>
         <line x1="0" y1="{number(1.00*$yMax)}" x2="5" y2="{number(1.00*$yMax)}"/>
         <text x="{number(0.00*$xMax - 15)}" y="{number(0.50*$yMax)}" style="text-anchor:start">y-axis (volume)</text>
         <text x="{number(0.00*$xMax - 15)}" y="{number(0.00*$yMax)}" style="text-anchor:start">
            <xsl:value-of select="$maxCount"/>
         </text>
      </g>
   </xsl:template>
   
   <!-- Draw right axis -->
   <xsl:template name="draw_rightAxis">
      <g style="stroke:black; stroke-width:0.25">
         <!-- draw axis lines -->
         <line x1="{$xMax}" y1="0" x2="{$xMax}" y2="{$yMax}" />
		 
		 <!-- Marks for Y axis -->
         <text x="{number(1.00*$xMax - 15)}" y="{number(0.50*$yMax)}" style="text-anchor:start">y-axis (runtime)</text>
         <text x="{number(1.00*$xMax - 15)}" y="{number(0.00*$yMax)}" style="text-anchor:start">
            <xsl:value-of select="$maxRuntime"/>
         </text>
      </g>
   </xsl:template>
   
   <!-- Draw our datasets... this involves drawing a legend entry,
     and plotting the points
     -->
   <xsl:template name="draw_timesets">
      <!-- create a colour for the dataset -->
      <xsl:variable name="colour">black</xsl:variable>

      <xsl:for-each select="sql:rowset">
         <g style="fill:{$colour}">
            <!-- put in legend entry -->
            <text font-weight="bold" x="{number(0.50*$xMax)}" y="-5">
               <xsl:value-of select="@name"/>
            </text>
         </g>
         <g style="stroke:{$colour}; stroke-width:0.5">
            <!-- draw datapoints -->
            <xsl:for-each select="sql:row">
               <xsl:call-template name="draw_time"/>
            </xsl:for-each>
         </g>
      </xsl:for-each>

      <!-- add line through the points.
           Example: points="20,20 40,25 60,40 80,120 120,140 200,180" -->
      <polyline style="fill:none;stroke:blue;stroke-width:0.3">
         <xsl:attribute name="points">
            <xsl:apply-templates select="sql:rowset/sql:row" mode="graph4" />
         </xsl:attribute>
      </polyline>
      
   </xsl:template>

   <!-- Draw our datasets... this involves drawing a legend entry,
     and plotting the points
     -->
   <xsl:template name="draw_datasets">
      <!-- create a colour for the dataset -->
      <xsl:variable name="colour">
         <xsl:call-template name="colour_by_index">
            <xsl:with-param name="index" select="1"/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:for-each select="sql:rowset">
         <g style="fill:{$colour}">
            <!-- put in legend entry -->
            <text font-weight="bold" x="{number(0.50*$xMax)}" y="-5">
               <xsl:value-of select="@name"/>
            </text>
         </g>
         <g style="stroke:{$colour}; stroke-width:0.5">
            <!-- draw datapoints -->
            <xsl:for-each select="sql:row">
               <xsl:call-template name="draw_point"/>
            </xsl:for-each>
         </g>
      </xsl:for-each>

      <!-- add line through the points.
           Example: points="20,20 40,25 60,40 80,120 120,140 200,180" -->
      <polyline style="fill:none;stroke:{$colorcodeError};stroke-width:0.3">
         <xsl:attribute name="points">
            <xsl:apply-templates select="sql:rowset/sql:row" mode="graph1" />
         </xsl:attribute>
      </polyline>
      <polyline style="fill:none;stroke:{$colorcodeSuspect};stroke-width:0.3">
         <xsl:attribute name="points">
            <xsl:apply-templates select="sql:rowset/sql:row" mode="graph2" />
         </xsl:attribute>
      </polyline>
      <polyline style="fill:none;stroke:{$colorcodeRunning};stroke-width:0.75">
         <xsl:attribute name="points">
            <xsl:apply-templates select="sql:rowset/sql:row" mode="graph3" />
         </xsl:attribute>
      </polyline>
   </xsl:template>

   <!-- a quick routine to return a colour, given an index -->
   <xsl:template name="colour_by_index">
      <xsl:param name="index"/>
      <xsl:choose>
         <xsl:when test="$index = 1">red</xsl:when>
         <xsl:when test="$index = 2">blue</xsl:when>
         <xsl:when test="$index = 3">green</xsl:when>
         <xsl:otherwise>black</xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- draw a cross at a data point, showing magnitude of
     possible error
     -->
   <xsl:template name="draw_point">

      <xsl:variable name="x" select="(sql:day_of_year - $startDay) * ($xMax div  $maxDays)"/>
      <xsl:variable name="y_raw" select="sql:object_count_out * ($yMax div  $maxCount)"/>
      <xsl:variable name="y" select="$yMax - $y_raw"/>
      <xsl:variable name="x_error" select="2"/>
      <xsl:variable name="y_error" select="2"/>
      <xsl:variable name="x_plus" select="$x + $x_error"/>
      <xsl:variable name="x_minus" select="$x - $x_error"/>
      <xsl:variable name="y_plus" select="$y + $y_error"/>
      <xsl:variable name="y_minus" select="$y - $y_error"/>

      <line x1="{$x_plus}" y1="{$y}" x2="{$x_minus}" y2="{$y}"/>
      <line x1="{$x}" y1="{$y_plus}" x2="{$x}" y2="{$y_minus}"/>
   </xsl:template>  

    <!-- draw a cross at a data time, showing magnitude of
     possible error
     -->
   <xsl:template name="draw_time">
   
      <xsl:variable name="x" select="(sql:day_of_year - $startDay) * ($xMax div  $maxDays)"/>
      <xsl:variable name="y_raw" select="sql:runtime_minutes * ($yMax div  $maxRuntime)"/>
      <xsl:variable name="y" select="$yMax - $y_raw"/>
      <xsl:variable name="x_error" select="2"/>
      <xsl:variable name="y_error" select="2"/>
      <xsl:variable name="x_plus" select="$x + $x_error"/>
      <xsl:variable name="x_minus" select="$x - $x_error"/>
      <xsl:variable name="y_plus" select="$y + $y_error"/>
      <xsl:variable name="y_minus" select="$y - $y_error"/>

      <!--line x1="{$x_plus}" y1="{$y}" x2="{$x_minus}" y2="{$y}"/>
      <line x1="{$x}" y1="{$y_plus}" x2="{$x}" y2="{$y_minus}"/-->	   
	  <circle cx="{$x}" cy="{$y}" r="2" stroke="blue" stroke-width="1" fill="blue"/>
	  
   </xsl:template> 
   
   <xsl:template match="sql:row" mode="graph1">
      <xsl:variable name="x" select="(sql:day_of_year - $startDay) * ($xMax div  $maxDays)"/>
      <xsl:variable name="y_raw" select="sql:object_count_out * ($yMax div  $maxCount)"/>
      <xsl:variable name="y" select="$yMax - $y_raw"/>
      <xsl:value-of select="$x"/>,<xsl:value-of select="$y"/><xsl:text> </xsl:text>
   </xsl:template>

   <xsl:template match="sql:row" mode="graph2">
      <xsl:variable name="x" select="(sql:day_of_year - $startDay) * ($xMax div  $maxDays)"/>
      <xsl:variable name="y_raw" select="sql:moving_7day_average * ($yMax div  $maxCount)"/>
      <xsl:variable name="y" select="$yMax - $y_raw"/>
      <xsl:value-of select="$x"/>,<xsl:value-of select="$y"/><xsl:text> </xsl:text>
   </xsl:template>

   <xsl:template match="sql:row" mode="graph3">
      <xsl:variable name="x" select="(sql:day_of_year - $startDay) * ($xMax div  $maxDays)"/>
      <xsl:variable name="y_raw" select="sql:avg_object_count * ($yMax div  $maxCount)"/>
      <xsl:variable name="y" select="$yMax - $y_raw"/>
      <xsl:value-of select="$x"/>,<xsl:value-of select="$y"/><xsl:text> </xsl:text>
   </xsl:template>

   <xsl:template match="sql:row" mode="graph4">
      <xsl:variable name="x" select="(sql:day_of_year - $startDay) * ($xMax div  $maxDays)"/>
      <xsl:variable name="y_raw" select="sql:runtime_minutes * ($yMax div  $maxRuntime)"/>
      <xsl:variable name="y" select="$yMax - $y_raw"/>
      <xsl:value-of select="$x"/>,<xsl:value-of select="$y"/><xsl:text> </xsl:text>
   </xsl:template>
   
   <xsl:template name="draw_legend">
      <text x="{number(0.05*$xMax)}" y="{number(0.05 * $yMax)}" style="text-anchor:start" fill ="black" font-weight="bold">Legend:</text>
      <text x="{number(0.05*$xMax)}" y="{number(0.05 * $yMax + 10)}" style="text-anchor:start" fill ="{$colorcodeError}"> Volume out (object count)</text>
      <text x="{number(0.05*$xMax)}" y="{number(0.05 * $yMax + 20)}" style="text-anchor:start" fill ="{$colorcodeRunning}"> Long time moving average</text>
      <text x="{number(0.05*$xMax)}" y="{number(0.05 * $yMax + 30)}" style="text-anchor:start" fill ="{$colorcodeSuspect}"> 7 Day moving average</text>
	  <text x="{number(0.05*$xMax)}" y="{number(0.05 * $yMax + 40)}" style="text-anchor:start" fill ="blue"> Runtime (minutes) </text>
   </xsl:template>
</xsl:stylesheet>
