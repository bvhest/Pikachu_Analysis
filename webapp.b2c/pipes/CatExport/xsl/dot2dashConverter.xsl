<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                exclude-result-prefixes="sql xsl cinclude data" 
                xmlns:asset-f="http://www.philips.com/xucdm/functions/assets/1.2"
                extension-element-prefixes="asset-f">  
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
   
  <xsl:template match="GroupSeoName[@dotdash = 'true']">
    <GroupSeoName>
	    <xsl:attribute name="romanize" select="@romanize"/>
	    <xsl:attribute name="locale" select="@Locale"/>
      <xsl:value-of select="translate(current(),'.','-')"/>
    </GroupSeoName>    
  </xsl:template>
   
  <xsl:template match="CategorySeoName[@dotdash = 'true']">
    <CategorySeoName>
      <xsl:attribute name="romanize" select="@romanize"/>
      <xsl:attribute name="locale" select="@Locale"/>
      <xsl:value-of select="translate(current(),'.','-')"/>
    </CategorySeoName>    
  </xsl:template>
   
  <xsl:template match="SubCategorySeoName[@dotdash = 'true']">
    <SubCategorySeoName>
      <xsl:attribute name="romanize" select="@romanize"/>
      <xsl:attribute name="locale" select="@Locale"/>
      <xsl:value-of select="translate(current(),'.','-')"/>
    </SubCategorySeoName>
  </xsl:template>
     
</xsl:stylesheet>