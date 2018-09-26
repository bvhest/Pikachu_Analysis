<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="store_dir"/>
  <xsl:param name="project_code"/>
  <xsl:param name="project_file"/>
  
	<xsl:template match="/">
		<root store_dir="{$store_dir}" project_code="{$project_code}">
			<shell:delete>
        <shell:source><xsl:value-of select="concat($store_dir,'/',$project_file,'.xml')"/></shell:source>
      </shell:delete>
      <result>
        <html>
          <body>
            <h2>Import canceled</h2>
            <p>
              The import for packaging project <b><xsl:value-of select="$project_code"/></b>
              was canceled.
            </p>
          </body>
        </html>
      </result>
		</root>
	</xsl:template>

</xsl:stylesheet>
