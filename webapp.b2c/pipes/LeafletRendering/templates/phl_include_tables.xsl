<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- documentation -->
	<stylesheet xmlns="http://www.relate4u.com/xsl/documentation">
		<description>This is an stylesheet include for the product and product familiy leaflets.
			It contains the layout for table components; specifications, compare table, ...</description>
	</stylesheet>
	<!-- product data -->
	<xsl:template name="drawProductDataTable">
		<xsl:comment>Product data table</xsl:comment>
		<fo:block span="all" xsl:use-attribute-sets="blank-line keep-together-page">
			<!-- text table title -->
			<fo:block xsl:use-attribute-sets="RichTextTitle">
				<!-- get static text -->
				<xsl:call-template name="getStaticText">
					<xsl:with-param name="field">productdata</xsl:with-param>
				</xsl:call-template>
			</fo:block>
			<!-- create block container with two columns, in which a table flows, this will keep the element balanced over the two columns-->
			<fo:block-container axf:column-count="2" axf:column-gap="{$grid-gap}mm">
				<fo:table>
					<fo:table-column column-width="{$grid-2-column}mm"/>
					<fo:table-column column-width="{$grid-gap}mm"/>
					<fo:table-column column-width="{$grid-3-column}mm"/>
					<fo:table-body>
						<!-- add items (table rows), sorted by rank -->
						<xsl:apply-templates select="CSChapters | CSChapter">
							<xsl:sort data-type="number" select="CSChapterRank"/>
						</xsl:apply-templates>
						<!-- add system logo's  -->
						<xsl:if test="descendant::SystemLogo">
							<fo:table-row xsl:use-attribute-sets="keep-together keep-previous">
								<fo:table-cell>
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell padding-top="{$grid-line}mm">
									<!-- render all system logos -->
									<xsl:apply-templates select="descendant::SystemLogo">
										<xsl:sort data-type="number" select="SystemLogoRank"/>
									</xsl:apply-templates>
								</fo:table-cell>
							</fo:table-row>
						</xsl:if>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:block>
		<fo:block clear="both"/>
	</xsl:template>
	<xsl:template match="CSChapters">
		<xsl:apply-templates select="CSChapter">
			<xsl:sort data-type="number" select="CSChapterRank"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="CSChapter">
		<!-- add chapter header (table row)-->
		<xsl:apply-templates select="CSChapterName"/>
		<!-- add items (table rows), sorted by rank -->
		<xsl:apply-templates select="CSItems | CSItem">
			<xsl:sort data-type="number" select="CSItemRank"/>
		</xsl:apply-templates>
		<!-- add blank line -->
		<xsl:if test="following-sibling::CSChapter">
			<fo:table-row>
				<fo:table-cell number-columns-spanned="3">
					<fo:block xsl:use-attribute-sets="blank-line"/>
				</fo:table-cell>
			</fo:table-row>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CSChapterName">
		<fo:table-row xsl:use-attribute-sets="keep-next widoworphan">
			<fo:table-cell number-columns-spanned="3" padding-bottom="{$grid-line}mm" padding-left="1mm">
				<fo:block>
					<fo:list-block provisional-distance-between-starts="2mm" provisional-label-separation="2mm">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block xsl:use-attribute-sets="RichTextHeader">
									<xsl:text>•</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block xsl:use-attribute-sets="RichTextHeader">
									<xsl:apply-templates/>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<xsl:template match="CSItems">
		<xsl:apply-templates select="CSItem">
			<xsl:sort data-type="number" select="CSItemRank"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="CSItem">
		<xsl:if test="descendant::CSValue/CSValueName[normalize-space(.) != '']">
			<fo:table-row xsl:use-attribute-sets="widoworphan">
				<fo:table-cell padding-left="3mm">
					<xsl:call-template name="addDebugBorderRight"/>
					<xsl:apply-templates select="CSItemName"/>
				</fo:table-cell>
				<fo:table-cell>
					<fo:block/>
				</fo:table-cell>
				<fo:table-cell>
					<xsl:apply-templates select="CSValues | CSValue"/>
				</fo:table-cell>
			</fo:table-row>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CSValues">
		<xsl:apply-templates select="CSValue">
			<xsl:sort data-type="number" select="CSValueRank"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="CSValue">
		<xsl:apply-templates select="CSValueName"/>
	</xsl:template>
	<xsl:template match="CSItemName">
		<fo:block xsl:use-attribute-sets="RichTextData hyphenate">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="CSValueName">
		<fo:block xsl:use-attribute-sets="RichTextData">
			<xsl:apply-templates/>
			<!-- add optional value unit-of-measure [...] -->
			<xsl:apply-templates select="../../UnitOfMeasure"/>
			<!-- add optional value description [...] -->
			<xsl:apply-templates select="following-sibling::CSValueDescription"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="UnitOfMeasure">
		<xsl:text> </xsl:text>
		<xsl:value-of select="UnitOfMeasureSymbol"/>
	</xsl:template>
	<xsl:template match="CSValueDescription">
		<xsl:text> [</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]</xsl:text>
	</xsl:template>
	<!-- text table -->
	<xsl:template match="RichText[@type = 'TextTable']">
		<!-- two-column element, preferably kept on single page-->
		<xsl:comment>Specifications table</xsl:comment>
		<fo:block span="all" xsl:use-attribute-sets="keep-together-page blank-line hyphenate">
			<!-- text table title -->
			<xsl:if test="not(preceding-sibling::RichText[@type = 'TextTable'])">
				<fo:block xsl:use-attribute-sets="RichTextTitle">
					<xsl:if test="@tableLabel">
						<xsl:value-of select="@tableLabel"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:call-template name="getStaticText">
						<xsl:with-param name="field">specifications</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</xsl:if>
			<!-- create block container with two columns, in which a table flows, this will keep the element balanced over the two columns-->
			<fo:block-container axf:column-count="2" axf:column-gap="{$grid-gap}mm">
				<xsl:if test="preceding-sibling::RichText[@type = 'TextTable']">
					<xsl:attribute name="margin-top" select="concat(3 * $grid-line,'mm')"/>
				</xsl:if>
				<fo:table>
					<fo:table-column column-width="{$grid-2-column}mm"/>
					<fo:table-column column-width="{$grid-gap}mm"/>
					<fo:table-column column-width="{$grid-3-column}mm"/>
					<fo:table-body>
						<!-- add items (table rows), sorted by rank -->
						<xsl:apply-templates mode="texttable" select="Item">
							<!--<xsl:sort data-type="number" select="@rank"/>-->
						</xsl:apply-templates>
						<!-- add system logo's  -->
						<xsl:if test="$root-node/SystemLogo">
							<fo:table-row xsl:use-attribute-sets="keep-together keep-previous">
								<fo:table-cell>
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block/>
								</fo:table-cell>
								<fo:table-cell padding-top="{$grid-line}mm">
									<!-- render all system logos -->
									<xsl:apply-templates select="$root-node/SystemLogo">
										<xsl:sort data-type="number" select="SystemLogoRank"/>
									</xsl:apply-templates>
								</fo:table-cell>
							</fo:table-row>
						</xsl:if>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:block>
		<fo:block clear="both"/>
	</xsl:template>
	<xsl:template match="Item" mode="texttable">
		<!-- hide empty items -->
		<xsl:if test="normalize-space(.) != ''">
			<!-- each text table item is a table row -->
			<fo:table-row xsl:use-attribute-sets="keep-together">
				<fo:table-cell padding-bottom="{$grid-line}mm">
					<xsl:apply-templates mode="texttable" select="Head"/>
				</fo:table-cell>
				<fo:table-cell>
					<fo:block/>
				</fo:table-cell>
				<fo:table-cell padding-bottom="{$grid-line}mm">
					<xsl:apply-templates mode="texttable" select="BulletList"/>
				</fo:table-cell>
			</fo:table-row>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Head" mode="texttable">
		<!-- text table head is a blue header with bullet -->
		<fo:block>
			<fo:list-block provisional-distance-between-starts="2mm" provisional-label-separation="2mm">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block xsl:use-attribute-sets="RichTextHeader">
							<xsl:text>•</xsl:text>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block xsl:use-attribute-sets="RichTextHeader hyphenate">
							<xsl:apply-templates/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>
	<xsl:template match="BulletList" mode="texttable">
		<xsl:apply-templates mode="texttable" select="BulletItem">
			<xsl:sort data-type="number" select="@rank"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="BulletItem" mode="texttable">
		<xsl:apply-templates mode="texttable" select="Text | SubList"/>
	</xsl:template>
	<xsl:template match="Text" mode="texttable">
		<!-- render text table data text -->
		<fo:block xsl:use-attribute-sets="RichTextData hyphenate">
			<xsl:apply-templates mode="texttable"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="SubList" mode="texttable">
		<fo:list-block provisional-distance-between-starts="2mm" provisional-label-separation="2mm">
			<xsl:apply-templates mode="texttable" select="SubItem">
				<xsl:sort data-type="number" select="@rank"/>
			</xsl:apply-templates>
		</fo:list-block>
	</xsl:template>
	<xsl:template match="SubItem" mode="texttable">
		<!-- render sub list item as body text list with hyphens -->
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="RichTextData">
					<xsl:text>-</xsl:text>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates mode="texttable" select="Text"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<!-- compare table -->
	<xsl:template match="Filters/Purpose[@type = 'Differentiating']">
		<xsl:param name="start-column">1</xsl:param>
		<xsl:variable name="compare-table-exists">
			<xsl:if test="not($root-node/ProductRefs/ProductReference[@ProductReferenceType[. = 'assigned' or . = 'Accessory']]/CTN)">false</xsl:if>
			<xsl:if test="not($root-node/CSChapter/CSItem)">false</xsl:if>
		</xsl:variable>
		<xsl:if test="not(contains($compare-table-exists,'false'))">
			<xsl:variable name="end-column">
				<xsl:apply-templates mode="end-column" select="current()">
					<xsl:with-param name="start-column" select="$start-column"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:variable name="column-range" select="$end-column - $start-column"/>
			<xsl:variable name="empty-columns">
				<xsl:apply-templates mode="empty-column-count" select="current()">
					<xsl:with-param name="start-column" select="$start-column"/>
					<xsl:with-param name="end-column" select="$end-column"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:comment>
				<xsl:text>Differentiating table: start=</xsl:text>
				<xsl:value-of select="$start-column"/>
				<xsl:text>, end=</xsl:text>
				<xsl:value-of select="$end-column"/>
				<xsl:text>, range=</xsl:text>
				<xsl:value-of select="$column-range"/>
				<xsl:text>, empty=</xsl:text>
				<xsl:value-of select="$empty-columns"/>
			</xsl:comment>
			<xsl:variable name="is-wide-table" select="($column-range - $empty-columns) > (if($start-column > 1) then(4) else (6))"/>
			<fo:block-container position="relative">
				<fo:block xsl:use-attribute-sets="blank-line">
					<!-- if table is wider than 7 columns, it goes over full page body -->
					<xsl:if test="$is-wide-table">
						<xsl:attribute name="span">all</xsl:attribute>
					</xsl:if>
					<!-- render table title before every table in absolute block (the invisible version will keep all in place) -->
					<fo:block-container position="absolute">
						<fo:block xsl:use-attribute-sets="RichTextTitle keep-next">
							<xsl:call-template name="getStaticText">
								<xsl:with-param name="field">comparetable</xsl:with-param>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>
					<fo:table width="100%">
						<fo:table-header>
							<fo:table-cell>
								<!-- render an invisible (white) title that is repeated above every table (part) -->
								<fo:block xsl:use-attribute-sets="RichTextTitle keep-next white">
									<xsl:call-template name="getStaticText">
										<xsl:with-param name="field">comparetable</xsl:with-param>
									</xsl:call-template>
								</fo:block>
							</fo:table-cell>
						</fo:table-header>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<fo:block>
										<fo:table border-left="{$border-grey}" border-right="{$border-grey}" border-top="{$border-grey}" table-layout="auto" width="100%">
											<!-- place header cells in table header, so it will be repeated on page break -->
											<fo:table-header>
												<fo:table-row>
													<!-- if this is a continuation of the table, repeat the first 2 columns -->
													<xsl:if test="$start-column > 1">
														<xsl:apply-templates mode="compare-header-lookup" select="CSItems/CSItem[1] | CSItems/CSItem[2]">
															<xsl:sort data-type="number" select="@rank"/>
														</xsl:apply-templates>
													</xsl:if>
													<!-- table header cells (between given start and end column)-->
													<xsl:apply-templates mode="compare-header-lookup" select="CSItems/CSItem[position() &gt;= $start-column and position() &lt;= $end-column]">
														<xsl:sort data-type="number" select="@rank"/>
													</xsl:apply-templates>
												</fo:table-row>
											</fo:table-header>
											<fo:table-body>
												<!-- table content; do lookup via product reference CTN's -->
												<xsl:variable name="product-references" select="$root-node/ProductRefs/ProductReference"/>
												<xsl:variable name="product-CTN-nodes" select="$product-references[@ProductReferenceType = 'assigned']/CTN"/>
												<!-- first render products -->
												<xsl:apply-templates mode="compare-data-lookup" select="$product-CTN-nodes">
													<xsl:sort data-type="number" select="@groupRank"/>
													<xsl:with-param name="start-column" select="$start-column"/>
													<xsl:with-param name="end-column" select="$end-column"/>
												</xsl:apply-templates>
												<!-- then accessories -->
												<xsl:variable name="accessory-CTN-nodes" select="$product-references[@ProductReferenceType = 'Accessory']/CTN"/>
												<xsl:apply-templates mode="compare-data-lookup" select="$accessory-CTN-nodes">
													<xsl:sort data-type="number" select="@groupRank"/>
													<xsl:with-param name="start-column" select="$start-column"/>
													<xsl:with-param name="end-column" select="$end-column"/>
												</xsl:apply-templates>
											</fo:table-body>
										</fo:table>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
			<!-- check if a second part of the table should be rendered -->
			<xsl:if test="count(CSItems/CSItem) &gt; $end-column">
				<!-- render itself again, with other start column value -->
				<xsl:apply-templates select="current()">
					<xsl:with-param name="start-column" select="$end-column + 1"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Filters/Purpose[@type = 'Differentiating']" mode="end-column">
		<xsl:param name="start-column">-1</xsl:param>
		<xsl:variable name="initial-end-column">
			<xsl:choose>
				<xsl:when test="$start-column &gt; 1 and (count(CSItems/CSItem) - $start-column) > 11">
					<xsl:value-of select="$start-column + 9"/>
				</xsl:when>
				<xsl:when test="(count(CSItems/CSItem) - $start-column) > 11">
					<xsl:value-of select="$start-column + 11"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count(CSItems/CSItem)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="empty-column-count">
			<xsl:apply-templates mode="empty-column-count" select="current()">
				<xsl:with-param name="start-column" select="$start-column"/>
				<xsl:with-param name="end-column" select="$initial-end-column"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:value-of select="$initial-end-column + $empty-column-count"/>
	</xsl:template>
	<xsl:template match="Filters/Purpose[@type = 'Differentiating']" mode="empty-column-count">
		<xsl:param name="start-column">-1</xsl:param>
		<xsl:param name="end-column">-1</xsl:param>
		<xsl:variable name="empty-columns-string">
			<xsl:for-each select="CSItems/CSItem[position() &gt;= $start-column and position() &lt;= $end-column]">
				<xsl:variable name="column-exists">
					<xsl:apply-templates mode="compare-header-exists" select="current()"/>
				</xsl:variable>
				<xsl:if test="not($column-exists = 'true')">
					<xsl:text>+</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="empty-column-count" select="string-length($empty-columns-string)"/>
		<xsl:choose>
			<xsl:when test="$empty-column-count > 0">
				<!-- do extra pass on the extra empty columns range to check if there are empty columns in the extra columns -->
				<xsl:variable name="empty-column-count-pass-2">
					<xsl:apply-templates mode="empty-column-count" select="current()">
						<xsl:with-param name="start-column" select="$end-column + 1"/>
						<xsl:with-param name="end-column" select="$end-column + 1 + $empty-column-count"/>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:value-of select="$empty-column-count + $empty-column-count-pass-2"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$empty-column-count"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- compare table: header -->
	<xsl:template match="CSItem" mode="compare-header-lookup">
		<xsl:variable name="CSItem-id" select="@code"/>
		<xsl:variable name="column-exists">
			<xsl:apply-templates mode="compare-header-exists" select="current()"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$column-exists = 'true'">
				<fo:table-cell xsl:use-attribute-sets="TableSpecsHeaderCell">
					<xsl:if test="position() = 1">
						<xsl:attribute name="padding-left">1mm</xsl:attribute>
					</xsl:if>
					<fo:block xsl:use-attribute-sets="hyphenate">
						<xsl:variable name="CSItem-node" select="$root-node/CSChapter/CSItem[CSItemCode = $CSItem-id][1]"/>
						<xsl:apply-templates mode="compare" select="$CSItem-node"/>
						<!-- Use reference name as backup, in case CSItem cannot be found (warning; English only!) -->
						<xsl:if test="not($CSItem-node) or normalize-space($CSItem-node) = ''">
							<fo:block xsl:use-attribute-sets="TableHeaderText">
								<xsl:value-of select="@referenceName"/>
							</fo:block>
						</xsl:if>
					</fo:block>
				</fo:table-cell>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>
					<xsl:text>hiding header cell, column is empty: </xsl:text>
					<xsl:value-of select="$CSItem-id"/>
				</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="CSItem" mode="compare">
		<xsl:apply-templates mode="compare" select="CSItemName"/>
	</xsl:template>
	<xsl:template match="CSItemName" mode="compare">
		<fo:block xsl:use-attribute-sets="TableHeaderText">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- compare table: data -->
	<xsl:template match="CTN" mode="compare-data-lookup">
		<xsl:param name="start-column">-1</xsl:param>
		<xsl:param name="end-column">-1</xsl:param>
		<xsl:variable name="filterCSItems" select="$root-node/Filters/Purpose[@type = 'Differentiating']/CSItems"/>
		<xsl:variable name="CSItem-nodes-exist">
			<!-- do exists check on all CSItems -->
			<xsl:apply-templates mode="compare-data-exists" select="$filterCSItems/CSItem">
				<xsl:with-param name="CTN-id" select="@CTN"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($CSItem-nodes-exist,'true')">
				<fo:table-row>
					<xsl:if test="not(following-sibling::CTN)">
						<xsl:attribute name="keep-with-previous.within-column">10</xsl:attribute>
					</xsl:if>
					<xsl:if test="not(preceding-sibling::CTN)">
						<xsl:attribute name="keep-with-next.within-column">10</xsl:attribute>
					</xsl:if>
					<!-- if this is a continuation of the table, repeat the first to data cells -->
					<xsl:if test="$start-column > 1">
						<xsl:apply-templates mode="compare-data-lookup" select="$filterCSItems/CSItem[1] | $filterCSItems/CSItem[2]">
							<xsl:sort data-type="number" select="@rank"/>
							<xsl:with-param name="CTN-id" select="@CTN"/>
						</xsl:apply-templates>
					</xsl:if>
					<!-- do lookup in differentiating filter purpose via CSItem, to preserve ordering (by @rank) -->
					<xsl:apply-templates mode="compare-data-lookup" select="$filterCSItems/CSItem[position() &gt;= $start-column and position() &lt;= $end-column]">
						<xsl:sort data-type="number" select="@rank"/>
						<xsl:with-param name="CTN-id" select="@CTN"/>
					</xsl:apply-templates>
				</fo:table-row>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>
					<xsl:text>hiding data row, contains no data: </xsl:text>
					<xsl:value-of select="@CTN"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="parent::ProductReference/@ProductReferenceType"/>
				</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="CSItem" mode="compare-data-lookup">
		<xsl:param name="CTN-id">[none]</xsl:param>
		<xsl:variable name="CSItem-id" select="@code"/>
		<xsl:variable name="column-exists">
			<xsl:apply-templates mode="compare-header-exists" select="current()"/>
		</xsl:variable>
		<xsl:variable name="data-exists">
			<xsl:apply-templates mode="compare-data-exists" select="current()">
				<xsl:with-param name="CTN-id" select="$CTN-id"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$column-exists = 'true'">
				<fo:table-cell xsl:use-attribute-sets="TableSpecsDataCell">
					<xsl:if test="position() = 1">
						<xsl:attribute name="padding-left">1mm</xsl:attribute>
					</xsl:if>
					<fo:block xsl:use-attribute-sets="TableDataText">
						<!-- do lookup back on product reference assigned CTN's, to display the value for given CSItem code -->
						<xsl:choose>
							<xsl:when test="$data-exists = 'true'">
								<xsl:variable name="CSItem-id" select="@code"/>
								<xsl:variable name="CTN-nodes" select="$root-node/ProductRefs/ProductReference[@ProductReferenceType[. = 'assigned' or . = 'Accessory']]/CTN"/>
								<xsl:variable name="CTN-node" select="$CTN-nodes[@CTN = $CTN-id][1]"/>
								<xsl:variable name="CTN-value-node" select="$CTN-node/Value[@CSItemCode = $CSItem-id][1]"/>
								<xsl:apply-templates mode="compare" select="$CTN-value-node"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>-</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:table-cell>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>
					<xsl:text>hiding data cell, column is empty: </xsl:text>
					<xsl:value-of select="$CSItem-id"/>
				</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="CTN/Value" mode="compare">
		<xsl:apply-templates/>
	</xsl:template>
	<!-- compare table: exists -->
	<xsl:template match="CSItem" mode="compare-header-exists">
		<xsl:variable name="CSItem-id" select="@code"/>
		<xsl:variable name="CTN-nodes" select="$root-node/ProductRefs/ProductReference[@ProductReferenceType[. = 'assigned' or . = 'Accessory']]/CTN"/>
		<xsl:choose>
			<!-- check if there are any values occuring for this item code -->
			<xsl:when test="$CTN-nodes/Value[@CSItemCode = $CSItem-id]">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="CSItem" mode="compare-data-exists">
		<xsl:param name="CTN-id">[none]</xsl:param>
		<xsl:variable name="CSItem-id" select="@code"/>
		<xsl:variable name="CTN-nodes" select="$root-node/ProductRefs/ProductReference[@ProductReferenceType[. = 'assigned' or . = 'Accessory']]/CTN"/>
		<xsl:variable name="CTN-node" select="$CTN-nodes[@CTN = $CTN-id][1]"/>
		<xsl:variable name="CTN-value-node" select="$CTN-node/Value[@CSItemCode = $CSItem-id][1]"/>
		<xsl:choose>
			<!-- check if the CTN value (matching the CSItemCode) has value -->
			<xsl:when test="not($CTN-value-node) or normalize-space($CTN-value-node) = ''">false</xsl:when>
			<xsl:otherwise>true</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
