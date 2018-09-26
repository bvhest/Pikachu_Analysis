<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:me="http://apache.org/a">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="section"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="serverName"/>
  <xsl:param name="serverPort"/>  
  <xsl:param name="sitemapURIPrefix"/>    
    <xsl:variable name="sectionurl">
    <xsl:if test="$section">
    <xsl:value-of select="concat('section/', $section, '/')"/>
    </xsl:if>
  </xsl:variable>    
  <!--xsl:variable name="schedule_id" select="//sql:rowset[@name='schedule_id']/sql:row"/-->
  <!-- Have to hard code this for now, as the shell transformer is required to make the upload work -->
  <xsl:variable name="schedule_id" select="'710'"/>      
  <!-- -->
  <xsl:template match="/root">  
    <html>
      <body contentID="content">
      <hr/>
			Done.      
      <hr/>      
        <h2>catalog.xml translation export request - Step 2</h2><hr/>
        <xsl:text>To schedule a translation export, press the button below, and then on the following page press FIRE NOW</xsl:text><br/><br/><br/>
        <button>
          <xsl:attribute name="onclick">javascript:window.location='<xsl:value-of select="
                concat( 'http://'
                       , $serverName
                       , ':'
                       , $serverPort
                       , '/'
                       , $sitemapURIPrefix
                       , $sectionurl
                       , 'content_type_schedule/PMT_Translated/jobs/'
                       , $schedule_id
                       , '?job=TranslationExport&amp;pipe=cmc2/content_type/PMT_Translated?runcatalogexport=yes'
                       )"/>'</xsl:attribute>
          <xsl:text>Schedule translation export job</xsl:text>
        </button>                          
        <br/><br/><br/>
        <hr/>  
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
