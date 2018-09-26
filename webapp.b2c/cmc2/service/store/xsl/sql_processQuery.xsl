<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
<xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->
  <xsl:template match="sql-escape-string">
    <xsl:element name="sql:escape-string"><xsl:copy-of select="node()"/></xsl:element>
  </xsl:template>  
  <!-- -->
  <xsl:template match="process[../@valid='true' or @force='yes']">
    <!-- force SQL to run if @force = 'yes' -->
    <process>
      <xsl:for-each select="query">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <sql:execute-query>
          <sql:query>
            <xsl:apply-templates select="."/>
          </sql:query>
        </sql:execute-query>
        </xsl:copy>
      </xsl:for-each>
    </process>
  </xsl:template>
  <!-- -->  
  <xsl:template match="process[../@valid='false' and not(@force='yes')]">
    <process/>
  </xsl:template>
</xsl:stylesheet>
