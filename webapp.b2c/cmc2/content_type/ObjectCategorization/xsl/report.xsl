<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="ts"/>
  
 	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	 <xsl:template match="sql:*">
	 	<xsl:apply-templates select="@*|node()"/>
	 </xsl:template>
	 
	<xsl:template match="sql:error">
		<error-message>
			<xsl:value-of select="."/>
		</error-message>
	 </xsl:template>
	 
	<xsl:template match="sql:returncode">
		<rows-updated>
			<xsl:value-of select="."/>
		</rows-updated>
	 </xsl:template>
 
  <xsl:template match="/">
  <root>
	  <merge-report>
		 <xsl:apply-templates select="@*|node()"/>
	 </merge-report>
      <sql:execute-query>
      <sql:query>
select oc.catalogcode
     , oc.object_id 
  from vw_object_categorization oc
 where lastmodified = to_date('<xsl:value-of select="$ts"/>','yyyymmddhh24miss')  
      </sql:query>
    </sql:execute-query> 
</root>
  </xsl:template>  
</xsl:stylesheet>