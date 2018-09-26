<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:req="http://apache.org/cocoon/request/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="reload"/>  
	<!-- -->
	<xsl:template match="/Products">
		<Products>
			<xsl:apply-templates select="Product-Group"/>
		</Products>
	</xsl:template>
	<xsl:template match="Product-Group">
		<xsl:variable name="masterProduct" select="Master-Product/sql:rowset/sql:row/sql:data/Product"/>
    <xsl:variable name="disclaimerProduct" select="Disclaimer-Product/sql:rowset/sql:row/sql:data/Product"/>
    <xsl:variable name="current-mp-lastmodified"  select="@mplastmodified"/>    
    <xsl:variable name="rmp-prod-lastmodified" select="Master-Product/sql:rowset/sql:row/sql:lastmodified"/>    
    <xsl:variable name="rmp-disc-lastmodified" select="Disclaimer-Product/sql:rowset/sql:row/sql:lastmodified"/>    
    <xsl:variable name="run-timestamp" select="@runts"/>    
    <entry>
      <currmplm><xsl:value-of select="$current-mp-lastmodified"/></currmplm>
      <rmp-p-lm><xsl:value-of select="$rmp-prod-lastmodified"/></rmp-p-lm>      
      <rmp-d-lm><xsl:value-of select="$rmp-disc-lastmodified"/></rmp-d-lm>            
      <xsl:choose>    
        <xsl:when test="$reload='0'">
      		<Product IsMaster="{$masterProduct/@IsMaster}"  IsAccessory="{$masterProduct/@IsAccessory}"  lastModified="{replace($run-timestamp,' ','T')}" Status="{$masterProduct/@Status}"  Division="{Master-Product/sql:rowset/sql:row/sql:division}" Brand="{Master-Product/sql:rowset/sql:row/sql:brand}">
      			<xsl:copy-of copy-namespaces="no" select="$masterProduct/*"/>
      			<xsl:copy-of copy-namespaces="no" select="$disclaimerProduct/Disclaimer"/>
      		</Product>
        </xsl:when>
        <xsl:otherwise>
      		<Product IsMaster="{$masterProduct/@IsMaster}"  IsAccessory="{$masterProduct/@IsAccessory}"  lastModified="{$current-mp-lastmodified}" Status="{$masterProduct/@Status}"  Division="{Master-Product/sql:rowset/sql:row/sql:division}" Brand="{Master-Product/sql:rowset/sql:row/sql:brand}">
      			<xsl:copy-of copy-namespaces="no" select="$masterProduct/*"/>
      			<xsl:copy-of copy-namespaces="no" select="$disclaimerProduct/Disclaimer"/>
      		</Product>      
        </xsl:otherwise>
      </xsl:choose>
    </entry>    
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
