<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:shell="http://apache.org/cocoon/shell/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="upload_dir"/>
  <xsl:param name="processed_dir"/>
  <xsl:param name="project_file"/>
  
	<xsl:template match="/root">
		<shell:move>
      <shell:source><xsl:value-of select="concat($upload_dir,'/',$project_file,'.xml')"/></shell:source>
      <shell:target><xsl:value-of select="concat($processed_dir,'/',$project_file,'.xml')"/></shell:target>
    </shell:move>
	</xsl:template>

</xsl:stylesheet>
