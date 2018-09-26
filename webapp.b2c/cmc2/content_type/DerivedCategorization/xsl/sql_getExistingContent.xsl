<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:cmc2-f="http://www.philips.com/cmc2-f" 
                extension-element-prefixes="cmc2-f">
  <xsl:param name="ct"/>
  <xsl:param name="timestamp"/>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>

  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($timestamp)" />
  <!-- -->
  <xsl:template match="/">
    <Categorization DocTimeStamp="{$processTimestamp}">
        <sql:execute-query>
          <sql:query>
          SELECT o.*
		  FROM octl o
		 WHERE o.content_type = '<xsl:value-of select="$ct"/>'
		  AND o.localisation = 'none'    
        </sql:query>
      </sql:execute-query>         
     </Categorization>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  

</xsl:stylesheet>

