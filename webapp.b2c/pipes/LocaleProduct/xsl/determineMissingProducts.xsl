<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:i="http://apache.org/cocoon/include/1.0" 
                exclude-result-prefixes="sql xsl i">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--  -->

        <xsl:param name="ctnList"/>

        <xsl:key name="k_ctns" match="/Products/sql:rowset/sql:row/sql:id" use="."/>

	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

    <xsl:template match="Products">
      <Products>
          <xsl:variable name="missing" select="for $ctn in tokenize($ctnList,',') return 
                                              if (empty(sql:rowset/sql:row[sql:id=$ctn])) 
                                              then $ctn 
                                              else ()"/> 
          <xsl:for-each select="$missing">
              <id><xsl:value-of select="."/></id>
          </xsl:for-each>

          <xsl:for-each select="sql:row">
            <id><xsl:value-of select="sql:id"/></id>
          </xsl:for-each>

          <xsl:apply-templates/>
      </Products>
    </xsl:template>

</xsl:stylesheet>
