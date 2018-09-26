<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="locale">
    en_GB
  </xsl:param>
  <xsl:param name="ct">
    <xsl:choose>
      <xsl:when test="$locale='none'">
        PMT_Raw
      </xsl:when>
      <xsl:when test="starts-with($locale,'master')">
        PMT_Localised
      </xsl:when>
      <xsl:otherwise>
        PMT
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:variable name="country">
    <xsl:choose>
      <xsl:when test="$locale='none'"></xsl:when>
      <xsl:when test="starts-with($locale,'master')">
        <xsl:value-of select="substring-after($locale, '_')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-after($locale, '_')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
	<!-- -->
  <xsl:template match="/">

    <xsl:apply-templates select="@*|node()" />

  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ProductRefs/ProductReference">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <referencedproducts>
        <xsl:apply-templates select="CTN" mode="include">
          <xsl:sort select="@rank" data-type="number" />
        </xsl:apply-templates>
        <xsl:apply-templates select="Product/@ctn" mode="include">
          <xsl:sort select="Product/@rank" data-type="number" />
        </xsl:apply-templates>        
      </referencedproducts>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="CTN|@ctn" mode="include">
    <xsl:call-template name="get-ref-product">
      <xsl:with-param name="ctn" select="."/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="get-ref-product" mode="include">
    <xsl:param name="ctn"/>
    <object id="{$ctn}">
      <sql:execute-query>
        <sql:query>
          select o.DATA
          from octl o
          where o.CONTENT_TYPE = '<xsl:value-of select="$ct" />'
          and o.LOCALISATION = '<xsl:value-of select="$locale" />'
          and o.OBJECT_ID = '<xsl:value-of select="$ctn" />'
          and exists (
            select cc.ctn from customer_catalog cc
            where cc.ctn = '<xsl:value-of select="$ctn" />'
            and cc.customer_id in ('CONSUMER','NORELCO','PROFESSIONAL','FLAGSHIPSHOP','SHOPPUB','SHOPPAR','SHOPEMP','SHOPEXP')
            and sop &lt;= current_date
            and eop &gt; current_date
            <xsl:if test="$country != ''">
              and country = '<xsl:value-of select="$country" />'
            </xsl:if>
          )
        </sql:query>
      </sql:execute-query>
    </object>
  </xsl:template>

</xsl:stylesheet>

