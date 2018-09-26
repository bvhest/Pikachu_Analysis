<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:param name="timestamp"/>
  <xsl:param name="secondpass"/>
  <!-- Add a second to the timestamp for second pass batches -->
  <xsl:variable name="v1" select="xs:dateTime(concat(  substring($timestamp,1,4)
                                                      ,'-'
                                                      ,substring($timestamp,5,2)
                                                      ,'-'
                                                      ,substring($timestamp,7,2)
                                                      ,'T'
                                                      ,substring($timestamp,9,2)
                                                      ,':'
                                                      ,substring($timestamp,11,2)
                                                      ,':'
                                                      ,substring($timestamp,13,2)))   
                                + xs:dayTimeDuration('PT1S')"/>
  <xsl:variable name="v2" select="format-dateTime($v1,'[Y0001][M01][D01][H01][m01][s01]')"/>
  <xsl:variable name="v_timestamp" select="if($secondpass='true') then $v2 else $timestamp"/>
	
	<xsl:template match="/root">
		<root>
			<xsl:apply-templates select="sql:rowset/sql:row"/>
		</root>
	</xsl:template>

	<xsl:template match="sql:rowset/sql:row">
		<cinclude:include src="cocoon:/createEntryRecords/{sql:content_type}/{sql:localisation}/{$v_timestamp}/{sql:batch_number}" />
	</xsl:template>

</xsl:stylesheet>