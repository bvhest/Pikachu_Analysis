<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="ct"/>
  <xsl:variable name="doctimestamp" select="'1900-01-01T00:00:00'"/>
  <!-- -->
  <xsl:template match="/">
    <root>
    <RangeText_Raw DocTimeStamp="{$doctimestamp}">
	    <Nodes DocStatus="approved" DocTimeStamp="{$doctimestamp}">
        <sql:execute-query>
          <sql:query>
            SELECT o.content_type
			     , o.localisation
				 , o.object_id
				 , o.masterlastmodified_ts
				 , o.lastmodified_ts
				 , o.status
				 , o.marketingversion
				 , o.data
			  from octl o 
             where o.content_type = 'RangeText_Raw'
               and o.localisation = 'none'
               and NVL(o.status, 'XXX') != 'PLACEHOLDER'         
        </sql:query>
      </sql:execute-query>         
     </Nodes>
    </RangeText_Raw>     
    </root>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  

</xsl:stylesheet>

