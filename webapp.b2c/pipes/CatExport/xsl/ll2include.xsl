<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:param name="master"/>
  <xsl:param name="exportassignments"/>
  <xsl:param name="exportCTN"/>
  <xsl:variable name="exporttimestamp" select="/root/sql:rowset/sql:row[1]/sql:exporttimestamp"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="root/sql:rowset/sql:row/sql:languagecode"/>
      <xsl:choose>
     	 <xsl:when test="$exportCTN='yes'">
      		<cinclude:include><xsl:attribute name="src"><xsl:value-of select="concat('cocoon:/exportLocale.',$exporttimestamp,'.','MASTER?exportassignments=yes')"/></xsl:attribute></cinclude:include>
     	 </xsl:when>
      	<xsl:otherwise>
     		 <xsl:if test="$master='yes'"> 
      			<cinclude:include><xsl:attribute name="src"><xsl:value-of select="concat('cocoon:/exportLocale.',$exporttimestamp,'.','MASTER?exportassignments=no')"/></xsl:attribute></cinclude:include>
      		</xsl:if>
      	</xsl:otherwise>
      </xsl:choose>
     
     
      <xsl:if test="$exportassignments='yes'">
        <cinclude:include><xsl:attribute name="src"><xsl:value-of select="concat('cocoon:/exportAssignments.',$exporttimestamp,'.','MASTER')"/></xsl:attribute></cinclude:include>
      </xsl:if>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:languagecode">
    <cinclude:include>
      <xsl:attribute name="src"><xsl:value-of select="concat('cocoon:/exportLocale.',$exporttimestamp,'.',.)"/></xsl:attribute>
    </cinclude:include>
  </xsl:template>
</xsl:stylesheet>