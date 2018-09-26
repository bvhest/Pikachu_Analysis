<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:a="http://feed.alatest.com" extension-element-prefixes="cmc2-f">
                
<xsl:include href="../../../xsl/common/cmc2.function.xsl" />
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


 <xsl:template match="/">
 <root>
		<divisions>  
		     <xsl:sequence select="cmc2-f:get-division-sql()"/>
		</divisions>
 </root>
 
 </xsl:template>
 
 <xsl:template match="@*|node()">
  <xsl:copy copy-namespaces="no">
    <xsl:apply-templates select="node()|@*" />
  </xsl:copy>
</xsl:template>             
                
</xsl:stylesheet>
                