<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="locale"/>
  <xsl:param name="catalog"/>
  <xsl:template match="/">
    <Products timestamp="{current-dateTime()">
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="getdata">
              select *
                from octl o
          inner join catalog_objects co
                  on co.object_id = o.object_id
                 and co.customer_id = '<xsl:value-of select="$catalog"/>'
                 and co.sop &lt; sysdate
                 and co.eop &gt; sysdate
                 and nvl(co.deleted,0) = 0
               where o.content_type = 'PMT'
                 and o.localisation = '<xsl:value-of select="$locale"/>'
                 and NVL(o.status, 'XXX') != 'PLACEHOLDER'
               --and rownum &lt; 5
               order by o.object_id
        </sql:query>
      </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
