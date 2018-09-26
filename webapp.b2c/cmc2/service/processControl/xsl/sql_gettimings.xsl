<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
   <xsl:param name="schedule_id"/>
  
	<!-- -->
	<xsl:template match="/">
	<root>
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query name="getTimings">
				SELECT * 
				from content_type_schedule
				where id ='<xsl:value-of select="$schedule_id"/>'
			</sql:query>
		</sql:execute-query>
	</root>
</xsl:template>
</xsl:stylesheet>