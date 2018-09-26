<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                >

   <xsl:output method="xml" encoding="iso-8859-1"/>
   <xsl:strip-space elements="*" />

   <xsl:template match="//tbody/tr">
     <xsl:apply-templates select="*" />
     <xsl:text>&#x0A;</xsl:text>
   </xsl:template>

   <xsl:template match="//tbody/tr//*">
     <xsl:choose>
         <xsl:when test="count(child::*) > 0">
             <xsl:apply-templates select="*" />
         </xsl:when>
         <xsl:otherwise>
             <xsl:text>"</xsl:text>
             <xsl:value-of select="."/>
             <xsl:text>"</xsl:text>
         </xsl:otherwise>
     </xsl:choose>
     <xsl:if test="position() != last()">
         <xsl:text>,</xsl:text>
     </xsl:if>
   </xsl:template>

   <xsl:template match="h2"/>
</xsl:stylesheet>
