<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  exclude-result-prefixes="sql">
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset" />
  <!-- -->
  <xsl:template match="OwnerId">
	  <xsl:copy>
		  <xsl:value-of select="sql:rowset/sql:row/sql:object_id"/>
	  </xsl:copy>  
  </xsl:template>
  <xsl:template match="Categorization[sql:rowset/sql:row]" exclude-result-prefixes="sql">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each select="sql:rowset/sql:row[sql:catalogcode='MASTER']">
			<SubCategory code="{sql:agc}"><xsl:value-of select="sql:ag"/></SubCategory>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <!-- -->

</xsl:stylesheet>
