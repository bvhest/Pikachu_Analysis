<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:ph="http://www.philips.com/catalog/pdl"
>
  <xsl:param name="country" select="'XX'"/>
  <xsl:param name="language" select="'en'"/>
	
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ph:id">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="replace(.,'_global',concat('_',$country))" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ph:catalog">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="replace(.,'_global',concat('_',$country))" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ph:country">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="$country" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ph:language">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="concat('en_',$country)" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ph:subcategory">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="replace(.,'_global',concat('_',$country))" />
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
