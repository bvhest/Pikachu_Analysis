<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="table" />

  <xsl:variable name="config" select="document('../xml/config.xml')/config"/>
  
  <xsl:template match="/root">
    <root>
      <xsl:variable name="table-config" select="$config/tables/table[@name=$table]"/>
      <sql:execute-query>
        <sql:query>
          select <xsl:value-of select="$table-config/@columns" /> from <xsl:value-of select="$table" />
          <xsl:if test="$table-config/@where-clause != ''">
          where <xsl:value-of select="$table-config/@where-clause" />
          </xsl:if>
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>