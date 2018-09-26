<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 

  <xsl:template match="ProductRefs">
    <ProductRefs>
      <xsl:if test="ancestor::content/octl[@ct='PMT_Refs']/sql:rowset/sql:row[sql:productreferencetype='Accessory']">
         <ProductReference>
            <xsl:attribute name="ProductReferenceType" select="'Accessory'" />
            <xsl:for-each select="ancestor::content/octl[@ct='PMT_Refs']/sql:rowset/sql:row[sql:productreferencetype='Accessory']">
               <CTN><xsl:value-of select="sql:accesory" /></CTN>
            </xsl:for-each>
         </ProductReference>
      </xsl:if>
      <xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType != 'Accessory']"/>
      <xsl:apply-templates select="ProductReferences[@ProductReferenceType != 'Accessory']"/>
    </ProductRefs>
  </xsl:template>
  
  <xsl:template match="octl[@ct='PMT_Refs']" />
    
</xsl:stylesheet>
