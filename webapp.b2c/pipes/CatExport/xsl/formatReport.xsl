<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="sql xsl source">
  <!-- -->
  <xsl:param name="dir"/>
  <xsl:param name="channel"/>
  <!-- -->
  <xsl:template match="batch">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="concat($dir,'logs/Report_',sql:rowset/sql:row[1]/sql:exporttimestamp,'.xml')"/>
      </source:source>
      <source:fragment>
        <report>
          <xsl:apply-templates select="@*|node()"/>
        </report>
      </source:fragment>
    </source:write>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:row[sql:ctn!='']">
    <item>
      <xsl:apply-templates select="@*|node()"/>
    </item>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:ctn">
    <id>
      <xsl:value-of select="."/>
    </id>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:locale|sql:result|sql:remark">
    <xsl:element name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:exporttimestamp|sql:row[sql:ctn='']"/>
  <!-- -->    
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
