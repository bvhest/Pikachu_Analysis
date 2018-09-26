<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:source="http://apache.org/cocoon/source/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" encoding="iso-8859-1" omit-xml-declaration="yes"/>
  
  <xsl:param name="channel"/>
  <xsl:param name="exportdate"/>
	<xsl:param name="exporttype"/>    
  
  

	<xsl:template match="/">
<xsl:text>Files exported on </xsl:text><xsl:value-of select="$exportdate"/><xsl:text> for channel </xsl:text><xsl:value-of select="$channel"/><xsl:text>:
</xsl:text>
    <xsl:apply-templates select="//dir:file"/>
	</xsl:template>

	<xsl:template match="dir:file">
    <xsl:variable name="locale" select="if(contains(@name,'master_en_UK.xml'))
                                        then 'MASTER.xml'
                                        else if(contains(@name,'master_en_UK.zip'))
                                        then 'MASTER.zip'
                                        else if(starts-with(tokenize(@name,'_')[4],'master'))
                                             then concat(tokenize(@name,'_')[3],'_',tokenize(@name,'_')[4]) 
                                             else concat(tokenize(@name,'_')[4],'_',tokenize(@name,'_')[5])"/>
    <xsl:variable name="timestamp" select="tokenize(@name,'_')[2]"/>  
    <xsl:value-of select="concat($channel,'_',$exporttype,'_',$timestamp,'_',$locale)"/><xsl:text>
</xsl:text>
	</xsl:template>

</xsl:stylesheet>
