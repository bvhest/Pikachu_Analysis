<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	
	<xsl:variable name="ct" select="/content-type-definition/content-type"/>
	<xsl:variable name="l" select="/content-type-definition/localisation"/>
	
	<xsl:template match="content-type-definition">
		<content>
		<content-type-log o="{@o}" ct="content_type_definition" l="{@l}">
			<xsl:apply-templates/>
		</content-type-log>
		</content>
	</xsl:template>
	
	<xsl:template match="sql:*|octl-relations">
		<!-- ignore -->
	</xsl:template>
	
	<xsl:template match="content">
		 <xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="octl">
		<outputs>
		<!-- sequence is important! drop relations before creating them! -->
		<xsl:for-each select="/*/octl-relations/sql:rowset/sql:row">
			<drop-relation o-in="{sql:input_object_id}" l-in="{sql:input_localisation}" ct-in="{sql:input_content_type}" 
			     o-out="{sql:output_object_id}" l-out="{sql:output_localisation}" ct-out="{sql:output_content_type}" secondary="0"/>
		</xsl:for-each>
		
		<xsl:for-each select="sql:rowset/sql:row">
			<xsl:variable name="o" select="sql:object_id"/>
			<placeholder o="{$o}" l="{$l}" ct="{$ct}"/>

			<xsl:for-each select="/*/ctl-relations/sql:rowset/sql:row">
				<placeholder o="{$o}" l="{sql:input_localisation}" ct="{sql:input_content_type}"/>
				<relation o-in="{$o}" l-in="{sql:input_localisation}" ct-in="{sql:input_content_type}" 
				     o-out="{$o}" l-out="{sql:output_localisation}" ct-out="{sql:output_content_type}" secondary="0"/>
			</xsl:for-each>
		</xsl:for-each>	
		</outputs>
	</xsl:template>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>