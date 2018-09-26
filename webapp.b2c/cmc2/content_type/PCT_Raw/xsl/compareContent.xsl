<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
   
    
  <xsl:template match="ProductsToCompare">
		  <FilterPCT>
   			 <xsl:choose>
  			 	<xsl:when test="deep-equal(ProductsMsg[1]/Product,ProductsMsg[2]/Product)"><CTN><xsl:value-of select="ProductsMsg[1]/Product/CTN"/></CTN></xsl:when>
  			 	<xsl:otherwise>not equal</xsl:otherwise>
           	</xsl:choose>
           	</FilterPCT>
  </xsl:template>
  
  

</xsl:stylesheet>
