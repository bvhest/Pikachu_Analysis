<?xml version="1.0"?>
<?altova_samplexml KeyValueList.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="batchsize">2</xsl:param>
  <xsl:param name="dir">temp/</xsl:param>
  <xsl:param name="prefix"/>
  <xsl:param name="postfix"/>
  <xsl:param name="ext">.xml</xsl:param>
  <!-- -->
  <xsl:template match="/Products">
    <Products>
      <xsl:call-template name="RecursiveGrouping">
        <xsl:with-param name="list" select="Product"/>
        <xsl:with-param name="group" select="1"/>
      </xsl:call-template>
    </Products>
  </xsl:template>
  <!-- -->
  <xsl:template name="RecursiveGrouping">
    <xsl:param name="list"/>
    <xsl:param name="group"/>
    <!-- -->
    <xsl:if test="count($list)>0">
      <xsl:call-template name="DoIt">
        <xsl:with-param name="list" select="$list[position() &lt;= $batchsize]"/>
        <xsl:with-param name="group" select="$group"/>
      </xsl:call-template>
      <!-- If there are other groups left, calls itself -->
      <xsl:call-template name="RecursiveGrouping">
        <xsl:with-param name="list" select="$list[position() > $batchsize]"/>
        <xsl:with-param name="group" select="$group+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template name="DoIt">
    <xsl:param name="list"/>
    <xsl:param name="group"/>
    <!-- -->
    <source:write>
      <source:source>
        <xsl:value-of select="concat($dir,$prefix,$group,$postfix,$ext)"/>
      </source:source>
      <source:fragment>
        <Products>
          <xsl:for-each select="$list">
            <Product>
              <xsl:apply-templates select="@*|node()"/>
            </Product>
          </xsl:for-each>
        </Products>
      </source:fragment>
    </source:write>
  </xsl:template>
  <!--  -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
