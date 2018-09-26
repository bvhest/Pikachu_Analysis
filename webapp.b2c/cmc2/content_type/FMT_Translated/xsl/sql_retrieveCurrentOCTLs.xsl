<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="ct"/>
  <xsl:param name="locale"/>
  
  <xsl:template match="/">
    <root>
      <xsl:apply-templates/>
      
      <sql:execute-query>
        <sql:query>
          <!-- retrieve placeholder OCTLs -->
          select object_id from octl
          where content_type = '<xsl:value-of select="$ct"/>'
            and localisation = '<xsl:value-of select="$locale"/>'
          and (status = 'PLACEHOLDER' or status='Deleted')
          order by object_id
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>