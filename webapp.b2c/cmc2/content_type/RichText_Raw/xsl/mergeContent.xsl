<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
   
  	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="merge">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="merge"/>
		</xsl:copy>
	</xsl:template>

    
  <xsl:template match="content[../@valid='true']">
  		<xsl:copy copy-namespaces="no">
  			<xsl:apply-templates mode="merge"/>
  		</xsl:copy>
  </xsl:template>
  
  	<xsl:template match="RichTexts" mode="merge">
  	  		<xsl:variable name="currentRichTexts" select="../../../currentcontent/octl/sql:rowset/sql:row/sql:data/object/RichTexts"/>
  	  	     <xsl:variable name="newRichTexts" select="."/>
  		<xsl:copy copy-namespaces="no">
  			<!-- merge Rich Text elements here -->
  			<xsl:copy-of select="$currentRichTexts/RichText[not(@type=$newRichTexts/RichText/@type)]"/>
			<xsl:apply-templates select="@*|node()" mode="merge"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="RichText[not(child::*)]" mode="merge"/>

</xsl:stylesheet>
