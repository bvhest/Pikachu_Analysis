<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="ct"/>

  <xsl:template match="/">
    <root>
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <sql:execute-query>
          <sql:query>
            <!-- retrieve placeholder OCTLs -->
            select object_id from octl
            where content_type = '<xsl:value-of select="$ct"/>'
            and localisation='none'
            --AND OBJECT_ID LIKE '42PFL%'
            and (status = 'PLACEHOLDER' or status='Deleted')
            order by object_id
          </sql:query>
        </sql:execute-query>
      </xsl:copy>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>