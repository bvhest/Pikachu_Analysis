<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="reload"/>
	<xsl:template match="/">
		<xsl:variable name="now" select="current-dateTime()"/>
		<xsl:variable name="snow" select="replace(replace(substring(xs:string(current-dateTime()),1,16),':',''),'-','')"/>
		<root>
  		<cinclude:include>
        <xsl:choose>
          <xsl:when test="$reload='yes'">
            <xsl:attribute name="src"><xsl:text>cocoon:/reloadSub.</xsl:text><xsl:value-of select="$snow"/><xsl:text>.US.en_US</xsl:text></xsl:attribute>      
          </xsl:when>
          <xsl:otherwise>        
            <xsl:attribute name="src"><xsl:text>cocoon:/exportSub.</xsl:text><xsl:value-of select="$snow"/><xsl:text>.US.en_US</xsl:text></xsl:attribute>
          </xsl:otherwise>                  
        </xsl:choose>        
  		</cinclude:include>
		</root>
	</xsl:template>
</xsl:stylesheet>