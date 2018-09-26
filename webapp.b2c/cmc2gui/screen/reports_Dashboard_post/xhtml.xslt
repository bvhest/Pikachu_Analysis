<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
            xmlns:xs="http://www.w3.org/2001/XMLSchema">
            
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>

  <xsl:template match="/root">
    
   <xsl:variable name="process_count" select="count(sql:rowset/sql:row/sql:rowset/sql:row/sql:end_time)"/>
   <xsl:variable name="process_startTime" select="sql:rowset/sql:row/sql:rowset/sql:row[1]/sql:start_time"/>
   
   
   <xsl:variable name="process_endTime">
      <xsl:choose>
         <xsl:when test="sql:rowset/sql:row/sql:rowset/sql:row[$process_count - 1]/sql:end_time = '1900-01-01 00:00:00'">
            <xsl:value-of select="sql:rowset/sql:row/sql:rowset/sql:row[$process_count - 2]/sql:end_time"/>
         </xsl:when>
         <xsl:when test="sql:rowset/sql:row/sql:rowset/sql:row[$process_count]/sql:end_time = '1900-01-01 00:00:00'">
            <xsl:value-of select="sql:rowset/sql:row/sql:rowset/sql:row[$process_count - 1]/sql:end_time"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="sql:rowset/sql:row/sql:rowset/sql:row[$process_count]/sql:end_time"/>
         </xsl:otherwise>
      </xsl:choose>   
   </xsl:variable>
   
   <xsl:variable name="error_process_name">
      <xsl:choose>
         <xsl:when test="sql:rowset/sql:row/sql:rowset/sql:row[$process_count - 1]/sql:end_time = '1900-01-01 00:00:00'">            
            <xsl:value-of select="sql:rowset/sql:row/sql:rowset/sql:row[$process_count - 1]/sql:process_name" /> , 
            <xsl:value-of select="sql:rowset/sql:row/sql:rowset/sql:row[$process_count]/sql:process_name" /> are
         </xsl:when>
         <xsl:when test="sql:rowset/sql:row/sql:rowset/sql:row[$process_count]/sql:end_time = '1900-01-01 00:00:00'">            
            <xsl:value-of select="sql:rowset/sql:row/sql:rowset/sql:row[$process_count]/sql:process_name" /> is 
         </xsl:when>
         <xsl:otherwise>NULL</xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   
   <xsl:variable name="v_runmode" select="substring(sql:rowset/sql:row[1]/sql:run_schedule,1,6)"/>
   
   <html>
      <body>
        <h1>Pikachu Performance Dashboard</h1>
        <p /><p /><hr />
        <xsl:if test="sql:rowset/sql:row/sql:rowset/sql:row">
         <p>
         <table>               
            <xsl:if test="$v_runmode != 'MANUAL' ">
               <tr>
                  <td> Results for the run </td>
                  <td> : </td>
                        <td><strong><xsl:value-of select="sql:rowset/sql:row/sql:run_schedule"/></strong> </td>
               </tr>
               <tr>
                  <td> Process runtime </td>
                  <td> : </td>
                  <td><strong> <xsl:value-of select="$process_startTime"/> - <xsl:value-of select="$process_endTime"/></strong></td>
               </tr>
               <tr>
                  <td></td> 
                  <td></td>
                  <xsl:choose>
                     <xsl:when test="$error_process_name != 'NULL'">
                        <td style="color:red">
                           <strong>
                              <xsl:call-template name="date_diff">
                                 <xsl:with-param name="startTime" select="$process_startTime"/>
                                 <xsl:with-param name="endTime" select="$process_endTime"/>
                              </xsl:call-template>                           
                           </strong>
                           <small> (Process - <xsl:value-of select="$error_process_name"/> still running/has crashed.) </small>
                        </td>
                     </xsl:when>
                     <xsl:otherwise>
                        <td>
                           <strong>
                              <xsl:call-template name="date_diff">
                                 <xsl:with-param name="startTime" select="$process_startTime"/>
                                 <xsl:with-param name="endTime" select="$process_endTime"/>
                              </xsl:call-template>
                           </strong>
                        </td>
                     </xsl:otherwise>
                  </xsl:choose>
               </tr>   
            </xsl:if>
            <xsl:if test="$v_runmode = 'MANUAL' ">
               <tr>
                  <td> Results for the run </td>
                  <td> : </td>
                  <td><strong><xsl:value-of select="substring(sql:rowset/sql:row[1]/sql:run_schedule,1,16)"/>*</strong> </td>
               </tr>
            </xsl:if>                  
         </table>
         </p><hr />
      </xsl:if>
        
        <xsl:choose>
          <xsl:when test="sql:rowset/sql:row/sql:rowset/sql:row">
            <table class="main" width="680">
              <tr>
                <td width="240">Process name</td>
                <td width="90">Start time</td>
                <td width="90">End time</td>
                <td width="80">Runtime(m)</td>
                <td width="100">Volume in</td>
                <td width="100">Volume out</td>
                <td width="100">Seconds/object</td>
              </tr>
              <xsl:apply-templates select="sql:rowset/sql:row/sql:rowset/sql:row"/>
            </table>
          </xsl:when>
          <xsl:otherwise>
            <p> <strong> No data was found for the provided search details. </strong>
            <br/><br/> <input type="button" value="Back to Run Report" onClick="javascript:history.back()"/>
         </p>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="sql:rowset[@name='qry_dashboard_main']/sql:row">
    <tr>
      <td>
        <a title="View status" href="{concat($gui_url,$section_url,'reports_Dashboard_details?p_run_schedule=',sql:run_schedule,'&amp;p_output_content_type=',sql:process_name)}"><xsl:value-of select="sql:process_name"/></a>
      </td>
      <td><xsl:value-of select="sql:start_time"/></td>
      <td><xsl:value-of select="sql:end_time"/></td>
      <td align="right">
         <a title="View status" href="{concat($gui_url,$section_url,'reports_Dashboard_process_timing?p_output_content_type=',sql:process_name,'&amp;p_end_date=',sql:start_time,'&amp;p_period=',sql:period)}"><xsl:value-of select="sql:runtime_minutes"/></a>
      </td>
      <td align="right">
         <a title="View status" href="{concat($gui_url,$section_url,'reports_Dashboard_process_counts_in?p_output_content_type=',sql:process_name,'&amp;p_end_date=',sql:start_time,'&amp;p_period=',sql:period)}"><xsl:value-of select="sql:volume_in"/></a>
      </td>
      <td align="right">
         <a title="View status" href="{concat($gui_url,$section_url,'reports_Dashboard_process_counts?p_output_content_type=',sql:process_name,'&amp;p_end_date=',sql:start_time,'&amp;p_period=',sql:period)}"><xsl:value-of select="sql:volume_out"/></a>
      </td>
      <td align="right">
         <a title="View status" href="{concat($gui_url,$section_url,'reports_Dashboard_process_obj_timing?p_output_content_type=',sql:process_name,'&amp;p_end_date=',sql:start_time,'&amp;p_period=',sql:period)}"><xsl:value-of select="sql:seconds_per_object"/></a>
      </td>
    </tr> 
  </xsl:template>
  
  <xsl:template name="date_diff">
  
   <xsl:param name="startTime"/>
    <xsl:param name="endTime"/>
   
   <xsl:if test="$endTime != '1900-01-01 00:00:00'">   
      <xsl:variable name="ay" select="substring($startTime,1,4)"/>
      <xsl:variable name="am" select="substring($startTime,6,2)"/>
      <xsl:variable name="ad" select="substring($startTime,9,2)"/>
      
      <xsl:variable name="ah" select="substring($startTime,12,2)"/>
      <xsl:variable name="ami" select="substring($startTime,15,2)"/>
      <xsl:variable name="as" select="substring($startTime,18,2)"/>
         
      <xsl:variable name="by" select="substring($endTime,1,4)"/>
      <xsl:variable name="bm" select="substring($endTime,6,2)"/>
      <xsl:variable name="bd" select="substring($endTime,9,2)"/>
      
      <xsl:variable name="bh" select="substring($endTime,12,2)"/>
      <xsl:variable name="bmi" select="substring($endTime,15,2)"/>
      <xsl:variable name="bs" select="substring($endTime,18,2)"/>   
      
      <xsl:variable name="endDataTime" select="concat(string($by),'-',string($bm),'-',string($bd),'T',string($bh),':',string($bmi),':',string($bs),'Z')"/>   
      <xsl:variable name="startDataTime" select="concat(string($ay),'-',string($am),'-',string($ad),'T',string($ah),':',string($ami),':',string($as),'Z')"/>   
      
      <xsl:variable name="diff_date" select="xs:dateTime($endDataTime) - xs:dateTime($startDataTime)"/>
      <!-- Writes the Hours and Minutes -->
      <xsl:value-of select="(days-from-duration($diff_date)*24) + hours-from-duration($diff_date)"/> Hours , <xsl:value-of select="minutes-from-duration($diff_date)"/> Minutes      
   </xsl:if>   
   
  </xsl:template>
  
</xsl:stylesheet>
