<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="source"/>
	<xsl:param name="sourceDir"/>  
	<xsl:param name="targetDir"/>

  <!-- Move a file ($source) from $sourceDir to $targetDir -->  
  <!-- Example sitemap implementation:
  
        <map:transform src="{cmc2:xslDir}/common/shell_moveFile.xsl">
          <map:parameter name="source" value="{3}.{4}"/>
          <map:parameter name="sourceDir" value="{cmc2:gdir}/{1}/inbox"/>
          <map:parameter name="targetDir" value="{cmc2:gdir}/{1}/processed"/>
        </map:transform>   
        <map:transform type="shell"/>
   -->  
  
	<xsl:template match="/">
		<page>
  		<shell:move overwrite="true">
  			<shell:source><xsl:value-of select="concat($sourceDir,'/',$source)"/></shell:source>
  			<shell:target><xsl:value-of select="concat($targetDir,'/',$source)"/></shell:target>
  		</shell:move>
		</page>
	</xsl:template>

</xsl:stylesheet>