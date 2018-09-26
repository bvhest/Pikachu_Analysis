<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="project_code"/>
  <xsl:param name="exact_match"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>

  <xsl:template match="/root">
    <html>
      <body>
        <h1>Pikachu Performance Dashboard Details</h1>
        <p /><p />
        <xsl:choose>
          <xsl:when test="sql:rowset/sql:row">
            <table class="main">
              <tr>
                <td>Process name</td>
                <td>Start time</td>
                <td>End time</td>
                <td>Runtime(m)</td>
                <td>Volume in</td>
                <td>Volume out</td>
                <td>Seconds/object</td>
              </tr>
              <xsl:apply-templates select="sql:rowset/sql:row"/>
            </table>
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
      <td>
        <a title="View status" href="{concat($gui_url,$section_url,'reports_Dashboard_details?p_run_schedule=',sql:run_schedule,'&amp;p_output_content_type=',sql:process_name)}"><xsl:value-of select="sql:process_name"/></a>
      </td>
      <td><xsl:value-of select="sql:start_time"/></td>
      <td><xsl:value-of select="sql:end_time"/></td>
      <td align="right">
        <a title="View status" href="{concat($gui_url,$section_url,'reports_Dashboard_process_timing?p_output_content_type=',sql:process_name,'&amp;p_end_date=',sql:start_time)}"><xsl:value-of select="sql:runtime_minutes"/></a>
      </td>
      <td align="right">
		<a title="View status" href="{concat($gui_url,$section_url,'reports_Dashboard_process_counts_in?p_output_content_type=',sql:process_name,'&amp;p_end_date=',sql:start_time)}"><xsl:value-of select="sql:volume_in"/></a>
	  </td>
      <td align="right">
        <a title="View status" href="{concat($gui_url,$section_url,'reports_Dashboard_process_counts?p_output_content_type=',sql:process_name,'&amp;p_end_date=',sql:start_time)}"><xsl:value-of select="sql:volume_out"/></a>
      </td>
      <td align="right"><xsl:value-of select="sql:seconds_per_object"/></td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
