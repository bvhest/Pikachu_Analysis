<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                >

  <xsl:param name="userID" select="''"/>
  <xsl:param name="categoryCode" select="''"/>
  <xsl:param name="categorizationID" select="'ProductTree'"/>
  
  <xsl:template match="/root">
    <root>
      <sql:execute-query>
        <sql:query>
          select object_id
            from vw_object_categorization
            where catalogcode = '<xsl:value-of select="$categorizationID"/>'
            and subcategory   = '<xsl:value-of select="$categoryCode"/>'
            order by object_id        
        </sql:query>
      </sql:execute-query>	      
    </root>
  </xsl:template>
</xsl:stylesheet>
