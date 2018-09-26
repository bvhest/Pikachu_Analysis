<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1">catalog_definition</xsl:param>
  <xsl:param name="param2">none</xsl:param>
  <xsl:param name="param3">object_id</xsl:param>
  <xsl:param name="id">HQ1212/23</xsl:param>
  <xsl:param name="masterlastmodified_ts">1900-01-01T01:01:01</xsl:param>
  <xsl:param name="lastmodified_ts">1900-01-01T01:01:01</xsl:param>
<!-- -->
  <xsl:template match="/">
  <root>
	<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
<!-- -->
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select DATA
from octl_store os
where 
  os.content_type = '<xsl:value-of select="$param1"/>'
  and os.localisation = '<xsl:value-of select="$param2"/>'
  and os.object_id = '<xsl:value-of select="$id"/>'
  and os.masterlastmodified_ts = to_date('<xsl:value-of select="$masterlastmodified_ts"/>','yyyy-mm-dd"T"hh24:mi:ss')
  and os.lastmodified_ts = to_date('<xsl:value-of select="$lastmodified_ts"/>','yyyy-mm-dd"T"hh24:mi:ss')
      </sql:query>
    </sql:execute-query>
<!-- -->
  </root>
  </xsl:template>
</xsl:stylesheet>