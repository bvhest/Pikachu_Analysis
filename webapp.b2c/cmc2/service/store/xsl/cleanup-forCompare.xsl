<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	<xsl:strip-space elements="*"/>
		
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()" mode="existing">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="existing"/>
		</xsl:copy>
	</xsl:template>

<!-- note the switch to templateMode=existing so that same filter applies for new and existing content types during copy -->
	<xsl:template match="@*|node()" mode="new">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="existing"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="currentcontent">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="existing"/>
		</xsl:copy>
	</xsl:template>
	
	 <xsl:template match="entry[@valid='true']">
	 	<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" />
			<xsl:element name="newContent">
				<xsl:apply-templates select="content" mode="new"/>
			</xsl:element>
		</xsl:copy>

	</xsl:template>

	<!--
	<xsl:template match="content">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
		<xsl:element name="new">
			<xsl:apply-templates select="@*|node()" mode="new"/>
		</xsl:element>
			
	</xsl:template>
-->

	<xsl:template match="sql:rowset|sql:row|sql:data|octl" mode="existing">
		<xsl:apply-templates select="@*|node()"  mode="existing"/>
	</xsl:template>
	
	<xsl:template match="content" mode="new">
		<xsl:apply-templates select="@*|node()"  mode="existing"/>
	</xsl:template>

	<!-- filtered elements and attributes -->	
	<xsl:template match="sql:*|@lastModified|@masterLastModified" mode="existing"/>

			
</xsl:stylesheet>
