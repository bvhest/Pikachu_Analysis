<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    >

  <xsl:variable name="gnow" select="current-dateTime()" />

	<xsl:template match="/">
		<root>
			<xsl:variable name="runtimestamp" select="/root/sql:rowset[@name='timestamp']/sql:row/sql:startexec"/>
			<xsl:variable name="timestamp" select="replace(replace(replace(substring(xs:string($runtimestamp),1,19),':',''),'-',''),' ','')"/>
			<xsl:apply-templates select="/root/sql:rowset[@name='locales']/sql:row">
				<xsl:with-param name="timestamp" select="$timestamp"/>
			</xsl:apply-templates>	
		</root>
	</xsl:template>

	<xsl:template match="sql:row">
		<xsl:variable name="locale" select="sql:locale"/>
		<xsl:variable name="catalogtype" select="sql:catalogtype"/>
		<xsl:param name="timestamp"/>
		<cinclude:include>
      <xsl:attribute name="src" select="concat('cocoon:/batchSub.'
                                             , $timestamp, '.'
                                             , substring-after($locale,'_'),'.'
                                             , $locale
                                             , '?islatin=', sql:islatin)"/>
		</cinclude:include>
	</xsl:template>

</xsl:stylesheet>