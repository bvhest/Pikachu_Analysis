<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="cinclude xdt fn dir">
	<!-- -->
  
  
  
   <xsl:template match="@*|node()">
     <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
     </xsl:copy>
   </xsl:template>
  
  
   <xsl:template match="Products">
   	<xsl:element name="Products">
   	<xsl:for-each select="current()/Product">
   	
   		<xsl:sort select="current()/@tree"/>
   		<xsl:element name="Product">
   			<xsl:apply-templates select="current()/@*"/>
   		</xsl:element>
   		   				
   	</xsl:for-each>
   	
   </xsl:element>

   	  	   
   </xsl:template>
     
   
</xsl:stylesheet>
