<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:shell="http://apache.org/cocoon/shell/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
  <xsl:param name="upload_dir"/>
  <xsl:param name="processed_dir"/>
  <xsl:param name="doctimestamp"/>
  <xsl:param name="filename"/>
  
	<xsl:param name="gui_url"/>
	<xsl:param name="id"/>
  <xsl:param name="section"/>
  <xsl:param name="serverName"/>
  <xsl:param name="serverPort"/>  
  <xsl:param name="sitemapURIPrefix"/>      
  <xsl:param name="include_file"/>           
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/', $section, '/') else ''"/>
  <xsl:variable name="schedule_id" select="'775'"/>       


	<xsl:template match="/root">
    <root>
      <xsl:choose>
    		<xsl:when test="sourceResult/execution[./text() ne 'success']">
          <result>
            <html>
              <body>
                <h2>!! Import failed !!</h2>
                <p>
                  Import of <b><xsl:value-of select="$filename"/>.xml</b> failed.
                </p>
                <p style="color: red">
                <xsl:for-each select="sourceResult[execution[./text() ne 'success']]">
                  <xsl:value-of select="message"/>
                </xsl:for-each>
                </p>
              </body>
            </html>
          </result>
          <!--
             | At least one of the two files failed to be created.
             | Delete the file (if any) that was created successfully.
             -->
          <xsl:for-each select="sourceResult[execution[./text() eq 'success']]">
            <shell:delete>
              <shell:source><xsl:value-of select="substring-after(source,'file:/')"/></shell:source>
            </shell:delete>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <!-- Success -->
          <result>
            <html>
              <body>
                <h2>Import finished</h2>
                <p>
                  File <b><xsl:value-of select="$filename"/>.xml</b> was saved in the <i>RangeText_Raw</i> inbox.
                </p>
                  <xsl:text>If all files have been uploaded, the next step is to schedule the RangeText_Raw, RangeText_Localized, RangeText_Translated and RangeText content types.
Press the button below, and then on the following page press FIRE NOW</xsl:text><br/><br/><br/>
                  <button>
                    <xsl:variable name="pipeline" select="concat('cmc2/content_type/Jobs?includefile=',$include_file,'&amp;usefullpath=yes')"/>
                    <xsl:variable name="esc-pipeline" select="encode-for-uri($pipeline)"/>
                    <xsl:variable name="esc-esc-pipeline" select="encode-for-uri($esc-pipeline)"/>
                    <xsl:attribute name="onclick">javascript:window.location='<xsl:value-of select="
                                   concat( 'http://'
                                          , $serverName
                                          , ':'
                                          , $serverPort
                                          , '/'
                                          , 'cmc2gui/'
                                          , $section_url                                                                        
                                          , 'content_type_schedule/Jobs/jobs/'
                                          , $schedule_id
                                          ,'?job=Jobs&amp;pipe='
                                          , $esc-esc-pipeline)"/>'</xsl:attribute>  
                          <xsl:text>Schedule RangeText load</xsl:text>
                  </button>                       
                  <br/><br/><br/>
                  <hr/>                
              </body>
            </html>
          </result>
        </xsl:otherwise>
      </xsl:choose>
    </root>
	</xsl:template>

</xsl:stylesheet>
