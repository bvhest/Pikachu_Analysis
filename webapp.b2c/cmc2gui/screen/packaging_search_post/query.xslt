<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="project_code"/>
  <xsl:param name="exact_match"/>
  <xsl:variable name="object_id" select="upper-case($project_code)"/>
  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select object_id as project_code, lastmodified_ts as creation_date, status
from octl
where content_type='PP_Configuration'
<xsl:choose>
  <xsl:when test="$object_id ne '' and $exact_match eq 'true'">
  and object_id='<xsl:value-of select="$object_id"/>'
  </xsl:when>
  <xsl:when test="$object_id ne '' and $exact_match ne 'true'">
  and upper(object_id) like '%<xsl:value-of select="replace($object_id,'_','\\_')"/>%' escape '\'
  </xsl:when>
  <xsl:otherwise>
  and rownum &lt;= 20
  </xsl:otherwise>
</xsl:choose>
order by lastmodified_ts desc
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>
