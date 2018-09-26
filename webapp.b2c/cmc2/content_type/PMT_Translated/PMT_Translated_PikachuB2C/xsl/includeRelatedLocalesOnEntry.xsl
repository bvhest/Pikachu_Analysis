<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
   <!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   <!-- -->
  	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
   <!-- -->
   <xsl:template match="storelocales"/>
   <!-- -->
	<xsl:template match="Product">
     <Product>
       <xsl:copy-of select="@*"/>
       <xsl:attribute name="StoreLocales">
         <xsl:choose>
           <xsl:when test="@IsLocalized='true'"> 
             <xsl:value-of select="../../@l"/>
           </xsl:when>
           <xsl:otherwise>
             <xsl:for-each select="../../storelocales/sql:rowset/sql:row/sql:localisation">
               <xsl:if test="position() != 1 ">,</xsl:if>
                 <xsl:value-of select="."/>
             </xsl:for-each>
           </xsl:otherwise>
        </xsl:choose>
        </xsl:attribute>
      <xsl:apply-templates />
     </Product>
	</xsl:template>  
   <!-- -->
</xsl:stylesheet>