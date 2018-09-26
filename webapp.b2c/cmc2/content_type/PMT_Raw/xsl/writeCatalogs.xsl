<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:param name="dir"/>  
	<!-- -->
<xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
</xsl:template>
  
	<xsl:template match="countryGroup">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'/catalog_definition/inbox/',@catalog-id,'_',@ts,'_def.xml')"/>
			</source:source>
			<source:fragment>
				<catalog-definition o="{@catalog-id}" ct="catalog_definition" l="none" DocTimeStamp="{@DocTimeStamp}">
					 <xsl:apply-templates select="object"/>
				</catalog-definition>
			</source:fragment>
		</source:write>
		
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'/catalog_configuration/inbox/',@catalog-id,'_',@ts,'_conf.xml')"/>
			</source:source>
			<source:fragment>
				<catalog-configuration o="{@catalog-id}" ct="catalog_configuration" l="none" DocTimeStamp="{@DocTimeStamp}">
					 <xsl:apply-templates select="ctl"/>
				</catalog-configuration>
			</source:fragment>
		</source:write>
		
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source>
				<xsl:value-of select="concat($dir,'/PMT_Raw/temp/runCatalogProcess.xml')"/>
			</source:source>
			<source:fragment>
				<root>Run Catalogs</root>
			</source:fragment>
		</source:write>		
		
		
	</xsl:template>
	
	
	

</xsl:stylesheet>
