<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="categorization_generic.xsl"/>
  
	<xsl:template name="headers-categorization-overview">
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/categorization/categorization_overview.css"/>
		<script type="text/javascript" src="{$icp-host}js/categorization/categorization_overview.js"></script>
	</xsl:template>
	
	<xsl:template match="/Categorization" mode="categorization-overview">
		<div id="icp_view_overview" class="icp_view">
			<div id="icp_content_overview" class="icp_content">
				<xsl:apply-templates mode="l-cat-overview"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="Catalog" mode="l-cat-overview">
		<div class="icp_container {{id:'{CatalogCode}'}}" id="{CatalogCode}_container_overview">
			<xsl:call-template name="create-tree-node">
				<xsl:with-param name="node-name" select="CatalogName"/>
				<xsl:with-param name="node-type" select="'catalog'"/>
				<xsl:with-param name="id" select="CatalogName/@key"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
	<xsl:template match="Group" mode="l-cat-overview">
		<xsl:call-template name="create-tree-node">
			<xsl:with-param name="node-name" select="GroupName"/>
			<xsl:with-param name="node-type" select="'group'"/>
			<xsl:with-param name="id" select="GroupName/@key"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="Category" mode="l-cat-overview">
		<xsl:call-template name="create-tree-node">
			<xsl:with-param name="node-name" select="CategoryName"/>
			<xsl:with-param name="node-type" select="'category'"/>
			<xsl:with-param name="id" select="CategoryName/@key"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="SubCategory" mode="l-cat-overview">
		<xsl:call-template name="create-tree-node">
			<xsl:with-param name="node-name" select="SubCategoryName"/>
			<xsl:with-param name="node-type" select="'subcategory'"/>
			<xsl:with-param name="id" select="SubCategoryName/@key"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="text()" mode="l-cat-overview">
	</xsl:template>

	<xsl:template match="*|@*" mode="l-cat-overview">
		<xsl:apply-templates mode="l-cat-overview"/>
	</xsl:template>
	
	<xsl:template name="create-tree-node">
		<xsl:param name="node-name"/>
		<xsl:param name="node-type"/>
		<xsl:param name="id"/>
		<xsl:param name="disable-translation-text-marking" select="false()"/>
		<!--div class="cattreenode_container {$node-type}"-->
			<p class="cattreenode {$node-type}" id="{$id}">
				<xsl:choose>
					<xsl:when test="$node-type != 'subcategory'">
						<span class="toggle">►</span>
					</xsl:when>
					<xsl:otherwise>
						<span class="toggle">&#160;</span>
					</xsl:otherwise>
				</xsl:choose>
				<span class="nodename">
					<xsl:choose>
						<xsl:when test="$disable-translation-text-marking">
							<xsl:value-of select="$node-name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="display-text">
								<xsl:with-param name="text-node" select="$node-name"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</span>
				<xsl:choose>
					<xsl:when test="$node-type != 'subcategory'">
						<span class="toggleAll">►►</span>
					</xsl:when>
					<xsl:otherwise>
						<span class="toggleAll">&#160;</span>
					</xsl:otherwise>
				</xsl:choose>
				<!--span class="nodetype"><xsl:value-of select="$node-type"/></span-->
			</p>
			<xsl:if test="$node-type != 'subcategory'">
				<div class="cattreenode_children">
					<xsl:apply-templates mode="l-cat-overview"/>
				</div>
			</xsl:if>
		<!--/div-->
	</xsl:template>
</xsl:stylesheet>
