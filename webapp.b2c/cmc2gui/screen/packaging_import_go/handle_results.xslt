<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:shell="http://apache.org/cocoon/shell/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
  <xsl:param name="upload_dir"/>
  <xsl:param name="processed_dir"/>
  <xsl:param name="project_code"/>
  <xsl:param name="project_file"/>
  
	<xsl:template match="/root">
    <root>
      <xsl:choose>
    		<xsl:when test="sourceResult/execution[./text() ne 'success']">
          <result>
            <html>
              <body>
                <h2>!! Import failed !!</h2>
                <p>
                  Not all import files could be created
                  for packaging project <b><xsl:value-of select="$project_code"/></b>.
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
                  Import files for packaging project <b><xsl:value-of select="$project_code"/></b>
                  were saved in the respective inboxes of <i>PP_Configuration</i> and <i>PText_Raw</i>.
                </p>
              </body>
            </html>
          </result>
        </xsl:otherwise>
      </xsl:choose>
    </root>
	</xsl:template>

</xsl:stylesheet>
