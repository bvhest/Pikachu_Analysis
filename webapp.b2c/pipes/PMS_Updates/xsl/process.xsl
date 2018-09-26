<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
   <xsl:param name="objects" select="''"/>
   
   <xsl:template match="/">
     <root>
       <sql:execute-query>
         <sql:query isstoredprocedure="true">
         BEGIN
         <xsl:choose>
            <xsl:when test="$objects != ''">
            PMS.process_alerts(<xsl:value-of select="$objects"/>);
            </xsl:when>
            <xsl:otherwise>
            PMS.process_alerts;
            </xsl:otherwise>
         </xsl:choose>
         END;
         </sql:query>
       </sql:execute-query>
     </root>
   </xsl:template>
</xsl:stylesheet>