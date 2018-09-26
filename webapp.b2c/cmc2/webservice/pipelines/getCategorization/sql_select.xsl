<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >

  <xsl:param name="categorizationID" select="'MASTER'"/>

  <xsl:template match="/root">
    <root>
      <sql:execute-query>
        <sql:query>
          select * 
          from octl o
          where 
            o.content_type='Categorization_Raw'
            and
            o.localisation='none'
            and o.object_id = '<xsl:value-of select="$categorizationID"/>'
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
