<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="range_generic.xsl"/>
  
	<xsl:template name="headers-range-overview">
		<link rel="stylesheet" type="text/css" href="{$icp-host}css/range/range_overview.css"/>
		<xsl:comment>[if IE]&gt;
			<xsl:text>&lt;link rel="stylesheet" type="text/css" href="</xsl:text><xsl:value-of select="$icp-host"/><xsl:text>css/range/range_overview_ie.css" /&gt;</xsl:text>
		&lt;![endif]</xsl:comment>
		<script type="text/javascript" src="{$icp-host}js/range/range_overview.js"></script>
	</xsl:template>
	
	<xsl:template match="Nodes|Products" mode="range-overview">
		<div id="icp_view_overview" class="icp_view">
			<div id="icp_content_overview" class="icp_content">
				<xsl:apply-templates select="Node[position() &lt;= $max-items]" mode="l-rng-ov"/>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="Node" mode="l-rng-ov">
		<div class="icp_container {{id:'{@code}'}}" id="{@code}_container_overview">
			<xsl:if test="position() &gt; 1">
				<xsl:attribute name="style">display: none;</xsl:attribute>
			</xsl:if>
			<div class="icp_rng_ov_section icp_ov_section">
				<div class="title">Core marketing data</div>
				<xsl:apply-templates select="." mode="l-rng-ov-core"/>
			</div>
			
			<xsl:apply-templates select="ProductRefs/ProductReference[@ProductReferenceType='assigned']" mode="l-rng-ov"/>
				
			<xsl:if test="not(ProductRefs/referencedproducts and Filters)">
				<xsl:apply-templates select="Filters" mode="l-rng-ov"/>
			</xsl:if>

			<xsl:apply-templates select="RichTexts" mode="l-rng-ov"/>			
		</div>
	</xsl:template>
	
	<xsl:template match="Node" mode="l-rng-ov-core">
		<dl>
			<dt>Code</dt>
			<dd><xsl:value-of select="@code"/></dd>

			<dt>Type</dt>
			<dd><xsl:value-of select="@nodeType"/></dd>
      
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="Name"/>
			</xsl:call-template>
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="MarketingStatus"/>
			</xsl:call-template>
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="MarketingVersion"/>
			</xsl:call-template>
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="WOW"/>
			</xsl:call-template>
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="SubWOW"/>
			</xsl:call-template>
			<xsl:call-template name="display-field">
				<xsl:with-param name="node" select="MarketingTextHeader"/>
			</xsl:call-template>
		</dl>
	</xsl:template>

	<xsl:template match="ProductReference" mode="l-rng-ov">
		<div class="icp_rng_ov_section icp_ov_section">
			<div class="title">Assigned products</div>
				<xsl:choose>
					<xsl:when test="../referencedproducts and ../Filters">
						<xsl:variable name="ref-products" select="../referencedproducts/Product"/>
						<div class="icp_rng_ov_prd_comp">
							<table class="icp_rng_ov_prd_comp" style="width: {200+120*count($ref-products)}px">
								<thead>
									<tr>
										<th class="icp_rng_ov_header"></th>
										<xsl:for-each select="$ref-products">
											<xsl:apply-templates select="." mode="l-rng-ov-comp"/>
										</xsl:for-each>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="../Filters/Purpose" mode="l-rng-ov-comp">
										<xsl:with-param name="products" select="$ref-products"/>
									</xsl:apply-templates>
								</tbody>
							</table>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="CTN|Product/@ctn" mode="l-rng-ov"/>
					</xsl:otherwise>
				</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="ProductReference/CTN|ProductReference/Product/CTN" mode="l-rng-ov">
		<div class="asset">
			<xsl:call-template name="display-image">
				<xsl:with-param name="id" select="."/>
				<xsl:with-param name="height" select="50"/>
				<xsl:with-param name="doc-type" select="'GAL'"/>
				<xsl:with-param name="class" select="'image'"/>
			</xsl:call-template>
			<p class="caption"><xsl:value-of select="CTN"/></p>
		</div>
	</xsl:template>
	
	<xsl:template match="Product" mode="l-rng-ov-comp">
		<th>
			<xsl:call-template name="display-image">
				<xsl:with-param name="id" select="CTN"/>
				<xsl:with-param name="height" select="50"/>
				<xsl:with-param name="doc-type" select="'GAL'"/>
				<xsl:with-param name="class" select="'image'"/>
			</xsl:call-template>
			<p class="caption"><xsl:value-of select="CTN"/></p>
		</th>
	</xsl:template>

	<xsl:template match="Purpose" mode="l-rng-ov-comp">
		<xsl:param name="products"/>
		<xsl:variable name="description">
			<xsl:choose>
				<xsl:when test="@type='Base'">Base filters</xsl:when>
				<xsl:when test="@type='Differentiating'">Differentiating filters</xsl:when>
				<xsl:otherwise><xsl:value-of select="concat(@type,' filters')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr class="icp_rng_ov_header"><td colspan="{count($products) + 1}"><xsl:value-of select="$description"/></td></tr>
		<xsl:apply-templates select="Features/Feature|CSItems/CSItem" mode="l-rng-ov-comp">
			<xsl:with-param name="products" select="$products"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="Feature" mode="l-rng-ov-comp">
		<xsl:param name="products"/>
		<xsl:variable name="prod-feature" select="($products/Feature[FeatureCode=current()/@code])[1]"/>
		<xsl:variable name="feature-code" select="@code"/>
		<xsl:variable name="row-class">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 0">even</xsl:when>
				<xsl:otherwise>odd</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr class="{$row-class}">
			<td class="icp_rng_ov_header">
				<xsl:choose>
					<xsl:when test="$prod-feature">
						<xsl:call-template name="display-text">
							<xsl:with-param name="text-node" select="$prod-feature/FeatureName"/>
						</xsl:call-template>
						<span class="icp_filter_info">
							<b>Feature</b><br/>
							code: <xsl:value-of select="@code"/><br/>
							Feature rank: <xsl:value-of select="$prod-feature/FeatureRank"/>&#160;
						</span> 
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="concat('[Feature ',@code,' missing in all products]')"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:for-each select="$products">
				<td style="text-align: center;">
					<xsl:choose>
						<xsl:when test="Feature[FeatureCode=$feature-code]">•</xsl:when>
						<xsl:otherwise>-</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:for-each>
		</tr>
	</xsl:template>
	
	<xsl:template match="CSItem" mode="l-rng-ov-comp">
		<xsl:param name="products"/>
		<xsl:variable name="prod-item" select="($products/CSItem[CSItemCode=current()/@code])"/>
		<xsl:variable name="item-code" select="@code"/>
		<xsl:variable name="row-class">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 0">even</xsl:when>
				<xsl:otherwise>odd</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr class="{$row-class}">
			<td class="icp_rng_ov_header">
				<xsl:choose>
					<xsl:when test="$prod-item">
						<xsl:call-template name="display-text">
							<xsl:with-param name="text-node" select="$prod-item/CSItemName"/>
						</xsl:call-template>
						<span class="icp_filter_info">
							<b>CSItem</b><br/>
							code: <xsl:value-of select="@code"/><xsl:text>&#160;</xsl:text><br/>
							rank: <xsl:value-of select="$prod-item/CSItemRank"/>
						</span> 
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="concat('[CSItem ',@code,' missing in all products]')"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:for-each select="$products">
				<xsl:choose>
					<xsl:when test="CSItem[CSItemCode=$item-code]">
						<td>
							<xsl:comment><xsl:value-of select="CSItem[CSItemCode=$item-code]/CSValue/CSValueName"/></xsl:comment>
							<xsl:call-template name="display-csitem-values">
								<xsl:with-param name="csitem" select="CSItem[CSItemCode=$item-code]"/>
								<xsl:with-param name="unit-of-measure-type" select="'symbol'"/>
							</xsl:call-template>
						</td>
					</xsl:when>
					<xsl:otherwise><td style="text-align: center;">-</td></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</tr>
	</xsl:template>

	<xsl:template match="Filters" mode="l-rng-ov">
		<div class="icp_rng_ov_section icp_ov_section">
			<div class="title">Filters</div>
		</div>
	</xsl:template>

	<xsl:template match="RichTexts" mode="l-rng-ov">
		<div class="icp_rng_ov_section icp_ov_section">
			<div class="title">Rich texts</div>
			<xsl:apply-templates select="RichText" mode="l-rng-ov"/>
		</div>
	</xsl:template>

	<xsl:template match="RichText" mode="l-rng-ov">
		<p class="icp_rng_ov_header"><xsl:value-of select="@type"/></p>
		<ul>
			<xsl:apply-templates select="Item" mode="l-rng-ov-rich"/>
		</ul>
	</xsl:template>

	<xsl:template match="Item" mode="l-rng-ov-rich">
		<li>
			<p class="icp_rng_ov_header"><xsl:value-of select="@referenceName"/></p>
			<div class="icp_rng_ov_richtext"><xsl:apply-templates select="*" mode="l-rng-ov-rich"/></div>
		</li>
	</xsl:template>
	
	<xsl:template match="Head" mode="l-rng-ov-rich">
		<p class="icp_rng_ov_rt_head"><xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="."/>
		</xsl:call-template></p>
	</xsl:template>

	<xsl:template match="Body" mode="l-rng-ov-rich">
		<p class="icp_rng_ov_rt_body"><xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="."/>
		</xsl:call-template></p>
	</xsl:template>

	<xsl:template match="BulletList" mode="l-rng-ov-rich">
		<ul class="icp_rng_ov_rt_list">
			<xsl:apply-templates select="*" mode="l-rng-ov-rich"/>
		</ul>
	</xsl:template>

	<xsl:template match="BulletItem" mode="l-rng-ov-rich">
		<li><xsl:call-template name="display-text">
			<xsl:with-param name="text-node" select="Text"/>
		</xsl:call-template></li>
	</xsl:template>

	<xsl:template match="*|@*" mode="l-rng-ov">
		<!-- catch all: do nothing -->
	</xsl:template>

</xsl:stylesheet>
