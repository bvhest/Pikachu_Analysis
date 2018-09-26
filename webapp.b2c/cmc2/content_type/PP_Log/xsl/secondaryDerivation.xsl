<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	
	<xsl:param name="o"/>
	
	<xsl:template match="store-outputs">
	  <xsl:copy>
		<!-- deactivate all incomming secondary relations for the following octl-->
	    <drop-relation o-out="{$o}" l-out="none" ct-out="PP_Translations"/>
		<xsl:apply-templates select="../content/PackagingProjectConfiguration/Localizations" mode="so"/>
	  </xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="Localizations" mode="so">
	    <!-- the placeholder for the secondary, one per package-->
		<placeholder o="{$o}" ct="PText_Raw" l="none" needsProcessing="0" />
		<create-relation o-in="{$o}" ct-in="PText_Raw" l-in="none" ct-out="PP_Translations" l-out="none" o-out="{$o}"  secondary="1"/>
		<xsl:apply-templates select="Localization" mode="so"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="Localization" mode="so">
      <xsl:variable name="v_needsprocessing" select="if (@seo = 'true') then '-2' 
                                                     else '1'"/>     
	    <!-- the placeholder for the secondary, one per localization-->
		<placeholder o="{$o}" ct="PText_Translated" l="{replace(@languageCode,'-','_')}" needsProcessing="{$v_needsprocessing}"/>
		<!-- the secondary relation -->
		<create-relation o-in="{$o}" ct-in="PText_Translated" l-in="{replace(@languageCode,'-','_')}" ct-out="PP_Translations" l-out="none" o-out="{$o}" secondary="1"/>
		<!-- this relation should preferably be automatically generated -->
		<create-relation o-in="{$o}" ct-in="PText_Raw" l-in="none" ct-out="PText_Translated" l-out="{replace(@languageCode,'-','_')}" o-out="{$o}" secondary="0" needsProcessing="{$v_needsprocessing}"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
