<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="ProductReferences">
		<xsl:variable name="lastModified" select="@DocTimeStamp"/>
		<xsl:variable name="referenceType" select="@referenceType"/>
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*"/>
			<xsl:choose>
				<!-- 	A C C E S S O R I E S -->
				<xsl:when test="$referenceType='Accessories' ">
					<xsl:for-each-group select="ProductReference/Object" group-by="id">
						<xsl:for-each select="current-group()">
							<xsl:if test="position() = 1">
								<xsl:variable name="ctn" select="current-grouping-key()"/>
								<ProductReferenceObject lastModified="{$lastModified}" spreadsheetType="{$referenceType}" >
									<CTN>
										<xsl:value-of select="$ctn"/>
									</CTN>
									<xsl:for-each-group select="../../ProductReference[Object/id=$ctn]/Subject" group-by="id">
										<xsl:for-each select="current-group()">
											<xsl:if test="position() = 1">
												<ProductReference ProductReferenceType="Accessory">
													<CTN>
														<xsl:value-of select="id"/>
													</CTN>
													<ProductReferenceRank>0</ProductReferenceRank>
												</ProductReference>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each-group>
									<xsl:for-each-group select="../../ProductReference[Subject/id=$ctn]/Object" group-by="id">
										<xsl:for-each select="current-group()">
											<xsl:if test="position() = 1">
												<ProductReference ProductReferenceType="Performer">
													<CTN>
														<xsl:value-of select="id"/>
													</CTN>
													<ProductReferenceRank>0</ProductReferenceRank>
												</ProductReference>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each-group>
								</ProductReferenceObject>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each-group>
					<xsl:for-each-group select="ProductReference/Subject[not(id=../../ProductReference/Object/id)]" group-by="id">
						<xsl:for-each select="current-group()">
							<xsl:if test="position() = 1">
								<xsl:variable name="ctn" select="current-grouping-key()"/>
								<ProductReferenceObject lastModified="{$lastModified}" spreadsheetType="{$referenceType}" >
									<CTN>
										<xsl:value-of select="$ctn"/>
									</CTN>
									<xsl:for-each-group select="../../ProductReference[Subject/id=$ctn]/Object" group-by="id">
										<xsl:for-each select="current-group()">
											<xsl:if test="position() = 1">
												<ProductReference ProductReferenceType="Performer">
													<CTN>
														<xsl:value-of select="id"/>
													</CTN>
													<ProductReferenceRank>0</ProductReferenceRank>
												</ProductReference>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each-group>
								</ProductReferenceObject>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each-group>
				</xsl:when>
				<!-- V A R I A T I O N S -->
				<xsl:when test="$referenceType='Variations' ">
					<xsl:for-each-group select="ProductReference/Subject|ProductReference/Object" group-by="id">
						<xsl:for-each select="current-group()">
							<xsl:if test="position() = 1">
								<xsl:variable name="ctn" select="current-grouping-key()"/>
								<ProductReferenceObject lastModified="{$lastModified}" spreadsheetType="{$referenceType}">
									<CTN>
										<xsl:value-of select="$ctn"/>
									</CTN>
									<xsl:for-each-group select="../../ProductReference[Subject/id=$ctn]/Object|../../ProductReference[Object/id=$ctn]/Subject" group-by="id">
										<xsl:for-each select="current-group()">
											<xsl:if test="position() = 1">
												<ProductReference ProductReferenceType="Variation">
													<CTN>
														<xsl:value-of select="id"/>
													</CTN>
													<ProductReferenceRank>0</ProductReferenceRank>
												</ProductReference>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each-group>
								</ProductReferenceObject>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each-group>
				</xsl:when>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
