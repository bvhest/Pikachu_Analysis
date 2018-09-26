<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:source="http://apache.org/cocoon/source/1.0" 
                exclude-result-prefixes="sql xsl source">


  <xsl:param name="dir" />
  <xsl:param name="threshold" />
  <xsl:param name="filecount" />
  <xsl:param name="rel-count" />
  <xsl:param name="locale" />
  
  <xsl:variable name="timestamp" select="substring(xs:string(current-dateTime()),1,19)" />
  <xsl:variable name="timestampnumeric" select="replace(replace(replace($timestamp,':',''),'-',''),'T','')" />

  <xsl:template match="/">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="concat($dir,'/logs/ErrorReportDeletions_',$locale,'_',$timestampnumeric,'.xml')" />
      </source:source>
      <source:fragment>
        <report runTimestamp="{$timestamp}">
          <error>
            <message>Too many deleted families for locale <xsl:value-of select="$locale"/></message>
            <threshold>
              <xsl:value-of select="$threshold" /><xsl:text>%</xsl:text>
            </threshold>
            <filecount>
              <xsl:value-of select="$filecount" />
            </filecount>
            <relative-count>
              <xsl:value-of select="$rel-count" /><xsl:text>%</xsl:text>
            </relative-count>
          </error>
        </report>
      </source:fragment>
    </source:write>
  </xsl:template>
</xsl:stylesheet>