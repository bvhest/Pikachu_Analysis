<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

<xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>	
	
	<xsl:template match="entry">
	    <xsl:copy>
    			 <xsl:copy-of select="@*[not(local-name()='valid')]"/>

			<xsl:if test="@valid='true'">
				<xsl:choose>
					<xsl:when test="store-outputs//sql:error">
						<xsl:attribute name="valid">true</xsl:attribute>
						<result>Store Output Warning: <xsl:value-of select="store-outputs//sql:error"/></result>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="valid">true</xsl:attribute>
						<result>OK</result>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>

			<xsl:if test="@valid='false'">
				<xsl:copy-of copy-namespaces="no" select="result"/>
			</xsl:if>
 			 <xsl:apply-templates select="node()[not(local-name()='result')]"/>      
 			 
		   </xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
