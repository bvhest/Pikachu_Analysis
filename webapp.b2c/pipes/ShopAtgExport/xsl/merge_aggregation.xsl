<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">

  <xsl:template match="/root">
    <Products>
      <xsl:for-each-group select="Products/Product" group-by="CTN">
        <xsl:copy-of select="current-group()[1]" />
      </xsl:for-each-group>
	  <xsl:for-each-group group-by="CTN" select="Products/MasterProduct">
		<xsl:copy-of select="current-group()[1]"/>		 
	  </xsl:for-each-group>
    </Products>
  </xsl:template>
</xsl:stylesheet>
