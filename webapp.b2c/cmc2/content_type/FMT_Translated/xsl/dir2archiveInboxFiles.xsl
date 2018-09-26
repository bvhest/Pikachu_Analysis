<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
    xmlns:b2b="http://pww.pikachu.philips.com/b2b/function/1.0"
    extension-element-prefixes="b2b">
  
  <xsl:include href="../../../xsl/common/b2b.functions.xsl"/>
  
  <xsl:param name="sourceDir" />
  <xsl:param name="targetDir" />

  <xsl:template match="/root">
    <page>
      <xsl:apply-templates select="dir:directory/dir:file">
        <xsl:with-param name="success-entries" select="root//entry[result=('OK','Identical octl exists')]"/>
      </xsl:apply-templates>
    </page>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="success-entries"/>
    <xsl:variable name="ctn" select="tokenize(@name, '\.')[position() = last() -1]" />
    <xsl:if test="$success-entries[@o=b2b:fix-family-code($ctn)]">
      <shell:move overwrite="true">
        <shell:source>
          <xsl:value-of select="concat($sourceDir,'/',@name)" />
        </shell:source>
        <shell:target>
          <xsl:value-of select="concat($targetDir,'/',substring($ctn,1,1),'/',$ctn,'.xml')" />
        </shell:target>
      </shell:move>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>