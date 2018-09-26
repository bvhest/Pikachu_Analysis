<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f"  extension-element-prefixes="cmc2-f">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="sourceDir" as="xs:string"/>
	<xsl:param name="targetDir" as="xs:string"/>
  <!-- -->
  <xsl:include href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="@*|node()"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
	<xsl:template match="dir:file">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
				<source:source>
          <xsl:value-of select="concat($targetDir,'/',@name)"/>
				</source:source>
				<source:fragment>
          <xsl:copy-of copy-namespaces="no" select="document(concat('../',$sourceDir,'/',@name))"/>
				</source:fragment>
		</source:write>
	</xsl:template>
</xsl:stylesheet>
