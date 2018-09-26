<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dir="http://apache.org/cocoon/directory/2.0">
                
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="id"/>
  <xsl:param name="section"/>
  <xsl:param name="serverName"/>
  <xsl:param name="serverPort"/>  
  <xsl:param name="sitemapURIPrefix"/>      
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/', $section, '/') else ''"/>
  <xsl:variable name="schedule_id" select="'775'"/>     

	<xsl:template match="/dir:directory">
    <html>
      <body>
        <h2>Load packaging projects</h2>
        <xsl:choose>
          <xsl:when test="dir:file">
            <p>Available project files:</p>
    		    <xsl:apply-templates select="dir:file"/>
            <hr/>
            <br/><br/><br/><xsl:text>To schedule the load, press the button below, and then on the following page press FIRE NOW</xsl:text><br/><br/><br/>
            <button>
              <xsl:attribute name="onclick">javascript:window.location='<xsl:value-of select="
                             concat( 'http://'
                                    , $serverName
                                    , ':'
                                    , $serverPort
                                    , '/'
                                    , $sitemapURIPrefix
                                    , $section_url                                                                        
                                    , 'content_type_schedule/Jobs/jobs/'
                                    ,$schedule_id
                                    ,'?job=Jobs&amp;pipe=cmc2/content_type/Jobs?includefile='
                                    ,'packaging_project_load&#47;jobs_include.xml')"/>'</xsl:attribute>
                    <xsl:text>Schedule packaging load</xsl:text>
            </button>
          </xsl:when>
          <xsl:otherwise>
            <p>There are no project files available for loading</p>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
	</xsl:template>

	<xsl:template match="dir:file">
    <p><xsl:value-of select="@name"/></p>
	</xsl:template>
	
</xsl:stylesheet>
