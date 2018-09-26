<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="param1"/>
  <!-- -->
  <xsl:template match="/">
  <root>
	<xsl:attribute name="exportdate"><xsl:value-of select="$exportdate"/></xsl:attribute>
	<xsl:attribute name="locale"><xsl:value-of select="$param1"/></xsl:attribute>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select te.locale, te.ctn, te.lasttransmit as exportdate, ti.lasttransmit as importdate, te.remark
from customer_locale_export te
left outer join (
  select locale, id as ctn, lastmodified as lasttransmit 
  from raw_localized_products
  where 
    lastmodified &gt; to_date('<xsl:value-of select="$exportdate"/>','yyyy-mm-dd"T"hh24:mi:ss')
) ti on ti.locale = te.locale and te.ctn = ti.ctn
where 
  te.customer_id = 'TranslationExport'
  and to_char(te.lasttransmit,'yyyy-mm-dd"T"hh24:mi:ss') = '<xsl:value-of select="$exportdate"/>'
  and te.locale = '<xsl:value-of select="$param1"/>'
order by te.ctn
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>