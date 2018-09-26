<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="sourceDir" as="xs:string"/>
  <xsl:param name="targetDir" as="xs:string"/>
  <!-- -->
  <xsl:template match="/dir:directory">
    <root>
      <xsl:apply-templates select="dir:file"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file[dir:xpath/node()[local-name()='Node']]">                                             
    <xsl:variable name="filename" select="if(contains(@name,'MASTER.xml'))
                                        then @name
                                        else if(contains(@name,'_MASTER_'))
                                             then concat(tokenize(@name,'_')[1],'_',tokenize(@name,'_')[2],'_',tokenize(@name,'_')[3],'_MASTER_',tokenize(@name,'_')[6]) 
                                             else @name"/>
    <shell:move overwrite="true">
      <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
      <shell:target><xsl:value-of select="concat($targetDir,'/',$filename)"/></shell:target>
    </shell:move>
  </xsl:template>
  <!-- -->
  <xsl:template match="dir:file[not(dir:xpath/node()[local-name()='Node'])]">
    <shell:delete>
      <shell:source><xsl:value-of select="concat($sourceDir,'/',@name)"/></shell:source>
    </shell:delete>
  </xsl:template>  
  <!-- -->  
</xsl:stylesheet>