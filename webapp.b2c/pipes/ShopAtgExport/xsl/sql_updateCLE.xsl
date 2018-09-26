<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="channel"/>
	<xsl:param name="locale"/>
	<xsl:param name="batchnumber"/>
	<xsl:param name="exportdate"/>
	
	<!-- -->
	<xsl:template match="/root">
	<root>
	<!-- set flag to 1 if the export was before the last modified date -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT cle
set flag=0
  , BATCH=0
  , lasttransmit = to_date('<xsl:value-of select="@ts"/>','YYYYMMDDHH24MISS')
where cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
  and flag=1
			</sql:query>
		</sql:execute-query>
	<!-- set batch = 0, flag to 0 for all remaining rows that have batch!=0 or flag!=0 -->
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
UPDATE CUSTOMER_LOCALE_EXPORT cle
set flag=0
  , BATCH=0
where cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
  and (flag!=0 or batch!=0)
			</sql:query>
		</sql:execute-query>    
	</root>
</xsl:template>
</xsl:stylesheet>