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

    <xsl:template match="Product">
    
    <xsl:if test="not(preceding-sibling::Product[@ctn = current()/@ctn])">
	   	  <xsl:element name="Product">		   	  
	   	  
	   	  	<xsl:apply-templates select="current()/@ctn"/>
	   	  	<xsl:apply-templates select="current()/@subcatName"/>	   	  	
	   	  	<xsl:apply-templates select="current()/@subcat"/>
	   	  	<xsl:apply-templates select="current()/@catName"/>
	   	  	<xsl:apply-templates select="current()/@cat"/>
	   	  	<xsl:apply-templates select="current()/@groupName"/>
	   	  	<xsl:apply-templates select="current()/@group"/>
	   	  	
	   	  	<xsl:choose>
	   	  		<xsl:when test="current()/@tree = 'A_NORMAL'">
	    			<xsl:attribute name="tree">NORMAL</xsl:attribute>
	    		</xsl:when>
		   	  	<xsl:when test="current()/@tree = 'B_ACC'">
	    			<xsl:attribute name="tree">ACC</xsl:attribute>
	    		</xsl:when>	    		
    			<xsl:when test="current()/@tree = 'C_CMC2'">
    				<xsl:attribute name="tree">CMC2</xsl:attribute>
    			</xsl:when>
    			<xsl:when test="current()/@tree = 'D_FALLBACK'">
    				<xsl:attribute name="tree">FALLBACK</xsl:attribute>
    			</xsl:when>
    		</xsl:choose>	   	  	
	   	  	
	   	  	<xsl:apply-templates select="current()/@manufacturer"/>
	   	  	<xsl:apply-templates select="current()/@brand"/>
	   	  	
	   	  	
	   	  </xsl:element>   	  
   	  </xsl:if>
    </xsl:template>
   
   
</xsl:stylesheet>
