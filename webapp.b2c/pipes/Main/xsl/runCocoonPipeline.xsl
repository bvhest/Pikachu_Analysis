<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<!-- Parameters:
      |  1) runMode  : process modus; batch, fastlane or manual (note: runMode <> modus)
	  |  2) groupName : This is used to generate set of log files in the temp folder. Which is used when we run parallel jobs.
      |-->
  <xsl:param name="runMode"/>
  <xsl:param name="groupName"/>
  <!-- -->
  <xsl:variable name="runId" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01]_[H01][m01][s01]')" />
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>

  <xsl:template match="sql:row">
    <xsl:variable name="requestparams" select="substring-after(sql:pipeline,'?')"/>
    <xsl:variable name="pipe" select="if($requestparams != '') then  substring-before(sql:pipeline,'?') else sql:pipeline"/>
    <xsl:variable name="requestparams_suffix" select="if($requestparams != '') then  concat('?',$requestparams) else ''"/>
    <xsl:variable name="pipe_requestparams" select="if ($requestparams_suffix != '') then  concat($requestparams_suffix, '&amp;runId=',$runId) 
                                                    else concat('?runId=',$runId,'&amp;groupName=',$groupName)"/>
    
    <!-- include (start up) process
       -->
    <xsl:choose>
      <xsl:when test="starts-with(sql:pipeline,'pipes')">
        <cinclude:include src="{concat('cocoon:/run_',$pipe,'/',$runMode,$pipe_requestparams,'&amp;groupName=',$groupName)}" />
      </xsl:when>
      <xsl:when test="starts-with(sql:pipeline,'cmc2')">
        <xsl:variable name="s_scheduleid" select="if($requestparams!='') then '&amp;schedule_id=' else '?schedule_id='"/>
        <cinclude:include src="{concat('cocoon:/run_',sql:pipeline,$s_scheduleid,sql:id,'&amp;runId=',$runId,'&amp;groupName=',$groupName)}" />
      </xsl:when>
    </xsl:choose>        
  </xsl:template>
  
</xsl:stylesheet>