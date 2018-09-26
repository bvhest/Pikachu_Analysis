<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsl saxon xs">
    <xsl:param name="l"/>
    <!-- Products\Product\ProductDivision\ProductDivisionCode -->
    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- -->
    <xsl:template match="GreenData">
        <xsl:choose>
            <xsl:when test="parent::Product/ProductDivision/ProductDivisionCode = '0100'">                  
        <xsl:choose>
            <xsl:when test="$l=( 
                             'master_AT'                            
                            ,'master_BE'
                            ,'master_BG'
                            ,'master_CY'                           
                            ,'master_CZ'                           
                            ,'master_DK'                            
                            ,'master_EE'
                            ,'master_FI'
                            ,'master_FR'
			,'master_DE'                            
                            ,'master_GR'                            
                            ,'master_HU'
			,'master_IS'
                            ,'master_IE'                            
                            ,'master_IT'                            
                            ,'master_LV'
			,'master_LI'
                            ,'master_LT'
                            ,'master_LU'
                            ,'master_MT'
                            ,'master_NL'
                            ,'master_NO'
                            ,'master_PL'
                            ,'master_PT'
                            ,'master_RO'
                            ,'master_SK'
                            ,'master_SI'
                            ,'master_ES'
                            ,'master_SE'
                            ,'master_CH'
                            ,'master_TR'
			,'master_GB'
                            )">
                <xsl:copy>
               <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
        </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>

    