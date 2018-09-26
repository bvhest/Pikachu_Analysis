<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="packaging_generic.xsl"/>
  
	<xsl:template name="headers-packaging-overview">
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/packaging/packaging_overview.css"/>
		<script type="text/javascript" src="{$icp-host}js/packaging/packaging_overview.js"></script>
	</xsl:template>

  <xsl:template match="PackagingText" mode="packaging-overview">
		<div id="icp_view_overview" class="icp_view">
			<div id="icp_content_overview" class="icp_content">
				<div class="icp_container {{id:'{@code}'}}" id="{@code}_container_overview">
					<div class="icp_pck_ov_title">Packaging project <xsl:value-of select="@code"/></div>
					
					<xsl:apply-templates select="ProductReferences[1]" mode="l-pck-overview"/>
					
					<div class="icp_pck_ov_texts icp_pck_ov_section icp_ov_section">
						<div class="title">Packaging text</div>
						<xsl:variable name="text-item-count" select="count(PackagingTextItem)"/>
						<table>
							<tr>
								<td class="left">
									<xsl:apply-templates select="PackagingTextItem[position() &lt;= ($text-item-count+1) div 2]" mode="l-pck-overview"/>
								</td>
								<td class="right">
									<xsl:apply-templates select="PackagingTextItem[position() &gt; ($text-item-count+1) div 2]" mode="l-pck-overview"/>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
  </xsl:template>
  
	<!-- For some reason (bug?) the ProductReferences appear duplicated in PText_Translated -->
	<xsl:template match="ProductReferences" mode="l-pck-overview">
		<div class="icp_pck_ov_products icp_pck_ov_section icp_ov_section">
			<div class="title">Product references</div>
			<div>
				<xsl:apply-templates select="ProductReference" mode="l-pck-overview"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="ProductReference" mode="l-pck-overview">
		<div class="product_ref">
			<div class="product_code">
				<xsl:value-of select="@code"/>
			</div>
			<div class="product_photo">
				<xsl:call-template name="display-image">
					<xsl:with-param name="height" select="100"/>
					<xsl:with-param name="id" select="@code"/>
					<xsl:with-param name="doc-type" select="'GAL'"/>
				</xsl:call-template>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="PackagingTextItem" mode="l-pck-overview">
		<xsl:call-template name="display-packaging-text-item">
			<xsl:with-param name="text-item" select="."/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
