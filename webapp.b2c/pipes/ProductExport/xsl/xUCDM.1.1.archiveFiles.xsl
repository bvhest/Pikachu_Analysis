<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:shell="http://apache.org/cocoon/shell/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="sourceDir" as="xs:string"/>
	<xsl:param name="targetDir" as="xs:string"/>
	<xsl:param name="channel" as="xs:string"/>  
	<xsl:param name="exporttype" as="xs:string"/>  
  <!-- -->
	<xsl:template match="/dir:directory">
		<root>
			<xsl:apply-templates select="dir:file"/>
		</root>
	</xsl:template>
  <!-- -->
	<xsl:template match="dir:file[not(contains(@name,'filelist.txt'))]">
    <xsl:variable name="locale" select="if(contains(@name,'master_en_UK.xml') or contains(@name,'master_global.xml'))
                                        then 'MASTER.xml'
                                        else if(contains(@name,'master_en_UK.zip'))
                                        then 'MASTER.zip'
                                        else if(starts-with(tokenize(@name,'_')[4],'master'))
                                             then concat(tokenize(@name,'_')[3],'_',tokenize(@name,'_')[4]) 
                                             else concat(tokenize(@name,'_')[4],'_',tokenize(@name,'_')[5])"/>
    <xsl:variable name="timestamp" select="tokenize(@name,'_')[2]"/>
		<shell:move overwrite="true">
			<shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
			<shell:target><xsl:value-of select="concat($targetDir,'/',$channel,'_',$exporttype,'_',$timestamp,'_',$locale)"/></shell:target>      
		</shell:move>
	</xsl:template>
  <!-- -->
	<xsl:template match="dir:file[contains(@name,'filelist.txt')]">
		<shell:move overwrite="true">
			<shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
			<shell:target><xsl:value-of select="concat($targetDir,'/',@name)"/></shell:target>
		</shell:move>
	</xsl:template>
</xsl:stylesheet>