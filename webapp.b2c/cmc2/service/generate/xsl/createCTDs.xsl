<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="dir"/>
	<xsl:param name="content_type"/>
	<xsl:param name="description"/>
	<xsl:param name="secondary_derivation"/>
	<xsl:param name="reference_name"/>
	<xsl:param name="localisation"/>
	<xsl:param name="input_content_type"/>
	<xsl:param name="input_localisation"/>
	<xsl:param name="offset_days"/>  
	<!-- -->
	<xsl:template match="/">
	<root>
		<xsl:choose>
			<xsl:when test="$localisation='none' or $localisation='master_global'">
			<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
				<source:source>
					<xsl:value-of select="concat($dir,'/outbox/',$content_type,'_',$localisation,'.xml')"/> 
				</source:source>
				<source:fragment>
					<xsl:apply-templates select="locales"/>
				</source:fragment>
			</source:write>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="locales/sql:rowset/sql:row"/>
			</xsl:otherwise>
		</xsl:choose>
		</root>
	</xsl:template>
	
	<xsl:template match="locales/sql:rowset/sql:row">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:choose>
					<xsl:when test="$localisation='master_'">
				<xsl:value-of select="concat($dir,'/outbox/',$content_type,'_',sql:country_code,'.xml')"/> 
					</xsl:when>
					<xsl:otherwise> <!-- $localisation='locales' -->
				<xsl:value-of select="concat($dir,'/outbox/',$content_type,'_',sql:locale,'.xml')"/> 
					</xsl:otherwise>
				</xsl:choose>
			</source:source>
			<source:fragment>
				<xsl:choose>
					<xsl:when test="$localisation='master_'">
						<xsl:apply-templates select="sql:country_code"/>
					</xsl:when>
					<xsl:otherwise> <!-- $localisation='locales' -->
						<xsl:apply-templates select="sql:locale"/>
					</xsl:otherwise>
				</xsl:choose>
			</source:fragment>
		</source:write>			
	</xsl:template>

	<xsl:template match="locales">
		<content-type-definition o="{$content_type}" ct="content_type_definition" l="none" DocTimeStamp="{sql:rowset[1]/sql:row[1]/sql:ts[1]}">
			<display-name><xsl:value-of select="$content_type"/></display-name>
			<description><xsl:value-of select="$description"/></description>
			<content-type><xsl:value-of select="$content_type"/></content-type><secondary-derivation><xsl:value-of select="$secondary_derivation"/></secondary-derivation>
			<localisation><xsl:value-of select="$localisation"/></localisation>
			<reference-name><xsl:value-of select="$reference_name"/></reference-name>
			<xsl:if test="not($input_content_type='')">
				<input-content-type><xsl:value-of select="$input_content_type"/></input-content-type>
				<input-localisation><xsl:value-of select="$input_localisation"/></input-localisation>
			</xsl:if>
      <offset-days><xsl:value-of select="$offset_days"/></offset-days>
		</content-type-definition>
	</xsl:template>
	
	<xsl:template match="sql:locale|sql:country_code">
		<content-type-definition ct="content_type_definition" l="none" DocTimeStamp="{../sql:ts}">
			<xsl:attribute name="o" select="concat($content_type,'_',text())"/>
			<display-name><xsl:value-of select="$content_type"/></display-name>
			<description><xsl:value-of select="$description"/></description>
			<content-type><xsl:value-of select="$content_type"/></content-type><secondary-derivation><xsl:value-of select="$secondary_derivation"/></secondary-derivation>
			<localisation><xsl:if test="$localisation='master_'">master_</xsl:if><xsl:value-of select="text()"/></localisation>
			<reference-name><xsl:value-of select="$reference_name"/></reference-name> 
			<xsl:if test="not($input_content_type='')">
				<input-content-type><xsl:value-of select="$input_content_type"/></input-content-type>
				<input-localisation>
  				<xsl:choose>
  					<xsl:when test="$input_localisation='master_'">
  						<xsl:value-of select="concat('master_',../sql:country_code/text())"/>
  					</xsl:when>
  					<xsl:when test="$input_localisation='none' or $input_localisation='master_global'">
  						<xsl:value-of select="$input_localisation"/>
  					</xsl:when>
  					<xsl:otherwise><!-- $input_localisation='same' -->
  						<xsl:value-of select="text()"/>
  					</xsl:otherwise>
  				</xsl:choose>
				</input-localisation>
			</xsl:if>
      <offset-days><xsl:value-of select="$offset_days"/></offset-days>  
		</content-type-definition>
	</xsl:template>
  

</xsl:stylesheet>