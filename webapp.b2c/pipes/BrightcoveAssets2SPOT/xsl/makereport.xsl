<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="sql xsl source">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="dir"/>
  <xsl:param name="error">no</xsl:param>
  <xsl:variable name="timestamp" select="substring(xs:string(current-dateTime()),1,19)"/>
  <xsl:variable name="timestampnumeric" select="replace(replace(replace($timestamp,':',''),'-',''),'T','')"/>
	<!-- -->
	<xsl:template match="/sourceResult">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source><xsl:value-of select="concat($dir,'logs/Report_',$timestampnumeric,'.xml')"/></source:source>
			<source:fragment>
				<report runTimestamp="{$timestamp}">
          <xsl:variable name="doc" select="document(source)"/>
          <exportedassetsxml>
            <xsl:apply-templates select="$doc/ProductsMsg/Product[Asset/License!='Obsolete']/CTN"/>
          </exportedassetsxml>
          <deletedassetsxml>
            <xsl:apply-templates select="$doc/ProductsMsg/Product[not(Asset/License!='Obsolete')]/CTN"/>
          </deletedassetsxml>
				</report>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
	<xsl:template match="/[not(sourceResult)]">
    <root>
  		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
  			<source:source><xsl:value-of select="concat($dir,'logs/Report_',$timestampnumeric,'.xml')"/></source:source>
  			<source:fragment>
  				<report runTimestamp="{$timestamp}">
            <stop>Downloaded assets xml follows</stop>
            <xml><xsl:copy-of select="."/></xml>
  				</report>
  			</source:fragment>
  		</source:write>
      <for-email>
        <report runTimestamp="{$timestamp}">
          <stop>Downloaded assets xml follows</stop>
          <xml><xsl:copy-of select="."/></xml>
        </report>    
      </for-email>        
    </root>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
