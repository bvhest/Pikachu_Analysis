<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:variable name="DocStatus">
	<xsl:variable name="lm">
		<xsl:value-of select="//PackagingProjectTranslations/Versioning/Input[LanguageCode='Source Text']/LastModified"/>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$lm=''">
		<DocStatus>PRELIMINARY<Remark>(No Source Text Available)</Remark></DocStatus>
		</xsl:when>	
		<xsl:when test="//PackagingProjectTranslations/Versioning/Input[LanguageCode!=('Configuration','Source Text')][LastModified!=''][compare(LastModified, $lm)=-1]">
		<DocStatus>PRELIMINARY<Remark>(language out of date)</Remark></DocStatus>
		</xsl:when>	
    <!--
		<xsl:when test="count(//PackagingProjectTranslations/Versioning/Input[LastModified='']) = 1">
		<DocStatus>PRELIMINARY<Remark>(Language missing)</Remark></DocStatus>
		</xsl:when>
		<xsl:when test="count(//PackagingProjectTranslations/Versioning/Input[LastModified='']) gt 1">
		<DocStatus>PRELIMINARY<Remark>(<xsl:value-of select="count(//PackagingProjectTranslations/Versioning/Input[LastModified=''])"/> Languages missing)</Remark></DocStatus>
		</xsl:when>   
		<xsl:when test="count(//PackagingProjectTranslations/Versioning/Input[contains(LanguageCode,'partial translations received')]) = 1">
		<DocStatus>PRELIMINARY<Remark>(<xsl:value-of select="count(//PackagingProjectTranslations/Versioning/Input[contains(LanguageCode,'partial translations received')])"/> Language Not Fully Translated)</Remark></DocStatus>
		</xsl:when>       
		<xsl:when test="count(//PackagingProjectTranslations/Versioning/Input[contains(LanguageCode,'partial translations received')]) gt 1">
		<DocStatus>PRELIMINARY<Remark>(<xsl:value-of select="count(//PackagingProjectTranslations/Versioning/Input[contains(LanguageCode,'partial translations received')])"/> Languages Not Fully Translated)</Remark></DocStatus>
		</xsl:when>    
    -->
		<xsl:when test="//PackagingProjectTranslations/Versioning/Input[not(LanguageCode=('Configuration','Source Text'))][LastModified=''] or //PackagingProjectTranslations/Versioning/Input[contains(LanguageCode,'partial translations received')]">
      <xsl:variable name="docstatus" select="'PRELIMINARY'"/>
      <xsl:variable name="countcomplete" select="count(//PackagingProjectTranslations/Versioning/Input[not(LanguageCode=('Configuration','Source Text'))][LastModified!=''][not(contains(LanguageCode,'partial translations received'))])"/>
      <xsl:variable name="countmissing" select="count(//PackagingProjectTranslations/Versioning/Input[not(LanguageCode=('Configuration','Source Text'))][LastModified=''])"/>
      <xsl:variable name="countpartiallycomplete" select="count(//PackagingProjectTranslations/Versioning/Input[LastModified!=''][contains(LanguageCode,'partial translations received')])"/>
  		<DocStatus><xsl:value-of select="$docstatus"/>
        <Remark>
          <xsl:variable name="x" select="if($countcomplete = 1) then ' Language ' else ' Languages '"/>
          <c><xsl:value-of select="concat($countcomplete,$x,'complete')"/></c>
          <xsl:variable name="x" select="if($countmissing = 1) then ' Language ' else ' Languages '"/>
          <m><xsl:value-of select="concat($countmissing,$x,'missing')"/></m>
          <xsl:variable name="x" select="if($countpartiallycomplete = 1) then ' Language ' else ' Languages '"/>
          <p><xsl:value-of select="concat($countpartiallycomplete,$x,'partially translated')"/></p>
        </Remark>
      </DocStatus>
		</xsl:when>    
		<xsl:when test="//PackagingProjectTranslations/@docStatus='final'"><DocStatus>FINAL</DocStatus></xsl:when>
		<xsl:otherwise><DocStatus>COMPLETE</DocStatus></xsl:otherwise>
	</xsl:choose>
</xsl:variable>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="DocStatus">
		<xsl:copy-of select="$DocStatus" copy-namespaces="no"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="@docStatus">
		<xsl:attribute name="docStatus">
			<xsl:value-of select="$DocStatus/DocStatus/text()" />
		</xsl:attribute>
	</xsl:template>
	<!-- -->
	<xsl:template match="status">
		<xsl:copy>
			<xsl:value-of select="$DocStatus/DocStatus/text()" />
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
