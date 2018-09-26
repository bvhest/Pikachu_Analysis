<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="catalog-id"/>
  <xsl:param name="ts"/>
  <xsl:param name="channel"/>
  <xsl:param name="full"/>

  <xsl:variable name="full-export" select="if ($full = 'true') then true() else false()"/>
  <xsl:variable name="now" select="format-dateTime(current-dateTime(), '[Y001]-[M01]-[D01]T[H01]:[m01]:[s01]'"/>
  
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="catalog-objects">
          <!--+
              | Select catalog objects from specified catalog
              | whose lastmodified is greater that the lastransmit in CLE.
              +-->
          select co.catalog_id,
                 co.object_id, 
                 co.customer_id, 
                 co.country, 
                 co.division, 
                 to_char(co.sop, 'YYYY-MM-DD') sop, 
                 to_char(co.eop, 'YYYY-MM-DD') eop, 
                 to_char(co.sos, 'YYYY-MM-DD') sos, 
                 to_char(co.eos, 'YYYY-MM-DD') eos, 
                 co.buy_online, 
                 nvl(co.deleted,0) deleted, 
                 to_char(co.lastmodified,'YYYY-MM-DD"T"HH24:MI:SS') lastmodified
          from catalog_objects co
          inner join customer_locale_export cle
                  on cle.ctn = co.catalog_id
          where co.catalog_id = '<xsl:value-of select="$catalog-id"/>'
            and co.country != 'GLOBAL'
          <xsl:if test="not($full-export)">
            and (co.lastmodified &gt; cle.lasttransmit or cle.lasttransmit is null)
          </xsl:if>
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
