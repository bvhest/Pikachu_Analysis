<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f"  extension-element-prefixes="cmc2-f">	
	
  <xsl:function name="cmc2-f:formatDate">
	<!--+
	    |	Reformat date string:
	    |		     20070919164110
	    |    	 IN: yyyymmddHH24miss
	    |		  OUT: yyyy-mm-ddTHH:mm:ss
	    +-->
		<xsl:param name="date"/>
		<xsl:choose>
			<xsl:when test="$date=''">
				<xsl:value-of select="''"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T',substring($date,9,2),':',substring($date,11,2),':',substring($date,13,2))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>  
	

  <xsl:function name="cmc2-f:formatFullProductName">
	<!--+
	    |	Create full product name out of constituent parts of NamingString element
	    |    	 IN: NamingString (element)
	    |		  OUT: Full product name (string)
	    +-->
		<xsl:param name="vNamingString"/>
    <xsl:variable name="TempFullNaming">
      <xsl:choose>
        <xsl:when test="$vNamingString!=''">
          <xsl:choose>
            <xsl:when test="string-length($vNamingString/BrandString) &gt; 0">
              <xsl:value-of select="$vNamingString/BrandString"/>
              <xsl:text> </xsl:text>
    					<xsl:value-of select="if($vNamingString/Family/FamilyName != '') then $vNamingString/Family/FamilyName else $vNamingString/Concept/ConceptName"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Descriptor/DescriptorName"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Partner/PartnerProductName"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Alphanumeric"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/VersionString"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/BrandedFeatureString"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/BrandString2"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$vNamingString/MasterBrand/BrandName"/>
              <xsl:text> </xsl:text>
              <xsl:choose>
                <xsl:when test="string-length($vNamingString/Concept/ConceptName) &gt; 0 and $vNamingString/Concept/ConceptName != 'NULL'">
                  <xsl:value-of select="$vNamingString/Concept/ConceptName"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$vNamingString/Partner[1]/PartnerBrand/BrandName"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Descriptor/DescriptorName"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/Alphanumeric"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/VersionString"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$vNamingString/BrandedFeatureString"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
		<xsl:value-of select="normalize-space(replace(replace(replace($TempFullNaming,'NULL',''),'&lt;not applicable&gt;',''),'PHILIPS','Philips'))"/>
  </xsl:function>  
	
</xsl:stylesheet>