<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
   
  	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

    
  <xsl:template match="entry[@valid='true']">
  		<xsl:copy copy-namespaces="no">
  			<xsl:apply-templates select="@*[not(local-name()='valid')] "/>
  			<!-- now do the compare -->
   			 <xsl:choose>
  			 	<xsl:when test="deep-equal(newContent/*,currentcontent/*)">
  			 		<xsl:attribute name="valid">false</xsl:attribute>
  			 		<xsl:element name="result">Identical octl exists</xsl:element>
    			 	</xsl:when>
  			 	<xsl:otherwise>
  			 		<xsl:apply-templates select="@valid|result"/>
             		</xsl:otherwise>
           	</xsl:choose>
  			<xsl:apply-templates select="node()[not(local-name()='result')] "/>
  		</xsl:copy>
  </xsl:template>
  
  <xsl:template match="newContent|currentcontent"/>


</xsl:stylesheet>
