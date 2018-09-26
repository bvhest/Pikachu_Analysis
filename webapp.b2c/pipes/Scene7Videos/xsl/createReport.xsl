<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:i="http://apache.org/cocoon/include/1.0"
  exclude-result-prefixes="sql i"
  >
  
  <xsl:template match="/root">
    <report>
      <xsl:apply-templates select="root/asset[root/text='File is read']"/>
    </report>
  </xsl:template>
  
  <xsl:template match="asset">
    <item>
      <id>
        <xsl:value-of select="@ref"/>
      </id>
      <locale>n/a</locale>
      <result>1</result>
      <remark>Exported</remark>
    </item>
  </xsl:template>
</xsl:stylesheet>