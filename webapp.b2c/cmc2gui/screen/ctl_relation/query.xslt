<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="id"/>
  <xsl:variable name="id2" select="upper-case(/h:request/h:requestParameters/h:parameter[@name='SearchContent']/h:value)"/>
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
      <xsl:attribute name="id"><xsl:value-of select="$idreal"/></xsl:attribute>
      <!-- -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="input-relations">
          select oc.*
          from octl_relations oc
          left outer join (select content_type, max(id) id from content_type_schedule group by content_type) cts 
            on cts.content_type = oc.input_content_type
          where upper(input_object_id) = '<xsl:value-of select="$idreal"/>'
          order by nvl(cts.id,0), input_content_type, input_localisation, output_content_type, output_localisation
				</sql:query>
      </sql:execute-query>
      <!-- -->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="output-relations">
          select oc.*
          from octl_relations oc
          left outer join (select content_type, max(id) id from content_type_schedule group by content_type) cts 
            on cts.content_type = oc.input_content_type
          where upper(output_object_id) = '<xsl:value-of select="$idreal"/>'
          order by nvl(cts.id,0), output_content_type, output_localisation, input_content_type, input_localisation
				</sql:query>
      </sql:execute-query>
      <!-- -->
    </root>
  </xsl:template>
</xsl:stylesheet>
