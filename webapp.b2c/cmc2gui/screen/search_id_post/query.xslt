<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="id"/>
  <xsl:variable name="id2" select="upper-case(/h:request/h:requestParameters/h:parameter[@name='SearchID']/h:value)"/>
  <xsl:variable name="idreal">
    <xsl:choose>
      <xsl:when test="not ($id2 = '')">
        <xsl:value-of select="$id2"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="upper-case($id)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="search_id">
select distinct object_id
from octl
where upper(object_id) like '%<xsl:value-of select="$idreal"/>%'
order by object_id
				</sql:query>
        <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
          <sql:query name="search_id_type">
select distinct content_type
from octl
where object_id = '<sql:ancestor-value name="object_id" level="1"/>'
order by content_type
				</sql:query>
        </sql:execute-query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
