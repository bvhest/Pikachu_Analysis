<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:assets="http://www.w3.org/1999/XSL/Transform/assets">
    
  <xsl:template match="node()|@*" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Users/User">
    <xsl:element name="User">
      <xsl:attribute name="accountID" select="@accountID"/>
      <xsl:attribute name="status" select="if (Authorizations/@status = 'Active') then ('Active') else ('Deleted')"/>
      
      <xsl:apply-templates select="Name"/>
      
      <xsl:for-each select="Authorizations">
        <xsl:sort select="@source" order="ascending"/>
      
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="ContentTypes">
    <xsl:element name="ContentTypes">
      <xsl:for-each select="ContentType">
        <xsl:sort select="@code" order="ascending"/>
      
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="Restriction">
    <xsl:element name="Restriction">
      <xsl:for-each select="SubCategory">
        <xsl:sort select="SubcategoryCode" order="ascending"/>
      
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>  
  
  <xsl:template match="Roles">
    <xsl:element name="Roles">
      <xsl:for-each select="Role">
        <xsl:sort select="." order="ascending"/>
      
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>