<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:param name="locale"/>
  <!-- -->
  <xsl:template match="/">
    <products>
      <sql:execute-query name="select CRE products">
        <sql:query name="select CRE products">
          SELECT o.content_type
               , o.localisation
               , o.object_id
               , o.masterlastmodified_ts
               , o.lastmodified_ts
               , o.status
               , o.marketingversion
               , o.data
            FROM octl o
      INNER JOIN mv_co_object_id_country mvco 
              ON mvco.object_id        = o.object_id
             AND mvco.country          = '<xsl:value-of select="substring-after($locale,'_')"/>'
             AND mvco.deleted          = 0
             AND mvco.eop           &gt; trunc(sysdate-365)
           WHERE o.content_type        = 'PMT'
             AND o.localisation        = '<xsl:value-of select="$locale"/>'
             AND o.status             != 'PLACEHOLDER'
        ORDER BY o.object_id
        </sql:query>
      </sql:execute-query>
    </products>
  </xsl:template>
</xsl:stylesheet>