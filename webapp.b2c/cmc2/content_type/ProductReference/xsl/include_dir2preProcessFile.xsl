<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="dir"/>  
  <xsl:param name="latest"/>    
  <xsl:param name="prefix"/>
  <!--  -->    
  <xsl:template match="/root">
    <root>
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  
   <xsl:template match="dir:directory">
   	<xsl:variable name="dts">
      <xsl:analyze-string select="$timestamp" regex="^(....)(..)(..)(..)(..)(..)$">
        <xsl:matching-substring>
        	 <value><xsl:value-of select="concat( regex-group(1),'-',regex-group(2),'-',regex-group(3),'T',regex-group(4),':', regex-group(5),':', regex-group(6) )"/></value>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <!-- Shouldn't be possible -->
          <value>'ERROR'/></value>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
      </xsl:variable>
		<root>
   			<xsl:apply-templates/>
		</root>
   </xsl:template>

  <!--  -->
  <xsl:template match="dir:file">
    <xsl:variable name="fileextn">
      <xsl:analyze-string select="@name" regex="^(.*)\.(..*)$">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(2)"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <!-- Shouldn't be possible -->
          <xsl:value-of select="'ERROR'"/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:variable name="filestem" select="substring-before(@name,concat('.',$fileextn))"/>
    <cinclude:include><xsl:attribute name="src" select="concat('cocoon:/preProcessFile/',$timestamp,'/',$filestem,'.',$fileextn)"/></cinclude:include>
  </xsl:template>
</xsl:stylesheet>