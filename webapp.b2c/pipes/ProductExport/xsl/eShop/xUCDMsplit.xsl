<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <xsl:param name="dir" />
  <xsl:param name="prefix" />
  <xsl:param name="postfix" />
  <xsl:param name="country" />
  <xsl:param name="ext" select="'.xml'"/>
  <xsl:param name="bycategory" select="'no'"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$bycategory='yes'">
        <xsl:apply-templates select="@*|node()" mode="bycategory" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@*|node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Product">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
		<xsl:choose>
			<xsl:when test="$prefix=''">
				<xsl:value-of select="$dir" />
				<xsl:value-of select="concat($country,'_master_')" />
				<xsl:value-of select="translate(CTN,'/','_')" />
				<xsl:value-of select="$postfix" />
				<xsl:value-of select="$ext" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$dir" />
				<xsl:value-of select="$prefix" />
				<xsl:value-of select="translate(CTN,'/','_')" />
				<xsl:value-of select="$postfix" />
				<xsl:value-of select="$ext" />
			</xsl:otherwise>
		</xsl:choose>
      </source:source>
      <source:fragment>
        <Products>
          <xsl:apply-templates select="../@*" />
          <Product>
            <xsl:apply-templates select="@*|node()" />
          </Product>
        </Products>
      </source:fragment>
    </source:write>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="bycategory">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="bycategory" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Products" mode="bycategory">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each-group select="Product" group-by="Categorization/CategoryCode">
        <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
          <source:source>
			<xsl:choose>
				<xsl:when test="$prefix=''">
					<xsl:value-of select="$dir" />
					<xsl:value-of select="concat($country,'_master_')" />
					<xsl:value-of select="current-grouping-key()" />
					<xsl:value-of select="$postfix" />
					<xsl:value-of select="$ext" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$dir" />
					<xsl:value-of select="$prefix" />
					<xsl:value-of select="current-grouping-key()" />
					<xsl:value-of select="$postfix" />
					<xsl:value-of select="$ext" />
				</xsl:otherwise>
			</xsl:choose>
          </source:source>
          <source:fragment>
            <!--
              <xsl:processing-instruction name="xml-stylesheet"> <xsl:text>href="xucdm-FSS.xsl"
              type="text/xsl"</xsl:text> </xsl:processing-instruction>
            -->
            <Products>
              <xsl:apply-templates select="../@*" mode="bycategory" />
              <xsl:for-each select="current-group()">
                <Product>
                  <xsl:apply-templates select="@*|node()" mode="bycategory" />
                </Product>
              </xsl:for-each>
            </Products>
          </source:fragment>
        </source:write>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
