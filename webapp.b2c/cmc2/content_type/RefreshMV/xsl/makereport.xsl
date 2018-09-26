<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:saxon="http://saxon.sf.net/" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="sql xsl source">
	<!-- -->
	<xsl:output name="output-def" method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	<!-- -->
	<xsl:param name="dir"/>
	<xsl:param name="channel"/>
	<xsl:param name="exportdate"/>
  <!-- -->
	<xsl:template match="/entries">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source><xsl:value-of select="$dir"/>logs/Report_<xsl:value-of select="$exportdate"/>.xml</source:source>
			<source:fragment>
       <entry includeinreport='yes'>
  				<report>
            <xsl:copy-of select="."/>
  				</report>
        </entry>
			</source:fragment>
		</source:write>
	</xsl:template>
</xsl:stylesheet>
