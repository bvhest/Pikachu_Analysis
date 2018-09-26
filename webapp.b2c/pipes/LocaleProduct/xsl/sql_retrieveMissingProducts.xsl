<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:sql-disabled="http://apache.org/cocoon/SQL/2.0/disabled" 
                xmlns:i="http://apache.org/cocoon/include/1.0" 
                exclude-result-prefixes="sql xsl i">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--  -->

	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

    <xsl:template match="Products">
      <Products>
          <xsl:for-each select="id">
            <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
		<sql:query name="product">
                    SELECT o.object_id id, o.data FROM 
                        OCTL o
                    WHERE o.content_type='PMT_Master'
                    AND o.localisation='master_global'
                    AND o.object_id='<xsl:value-of select="."/>'
                </sql:query>
   	        <sql:execute-query>
	    	    <sql:query name="cat">
                      SELECT distinct sc.GROUPCODE, sc.GROUPNAME, sc.CATEGORYCODE, sc.CATEGORYNAME, sc.SUBCATEGORYCODE, sc.SUBCATEGORYNAME
                      FROM SUBCAT_PRODUCTS sp
                      INNER JOIN SUBCAT sc on sp.SUBCATEGORYCODE = sc.SUBCATEGORYCODE
                      WHERE sp.ID = '<sql:ancestor-value name="id" level="1"/>'
                    </sql:query>
		</sql:execute-query>
  	    </sql:execute-query>
          </xsl:for-each>

          <xsl:apply-templates/>
      </Products>
    </xsl:template>

    <xsl:template match="sql:*">
       <xsl:element name="{concat('sql-disabled:', local-name())}">
         <xsl:apply-templates select="node()|@*"/>
       </xsl:element>
    </xsl:template>

    <xsl:template match="id"/>
</xsl:stylesheet>
