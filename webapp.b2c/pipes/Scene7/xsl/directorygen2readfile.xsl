<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="ct"/>
		
	<xsl:template match="/">
		<root>
      <xsl:for-each select="dir:directory/dir:file">
	      <xsl:sort select="@name"/>
		    <cinclude:include src="cocoon:/readFile.{@name}"/>
		  </xsl:for-each>
		</root>
	</xsl:template>

</xsl:stylesheet>