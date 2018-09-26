<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<!-- -->
	<xsl:template match="@*|node()" >
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="FixedCategorization" >
		<xsl:copy copy-namespaces="no">
					<xsl:call-template name="ProductDivision"/>
		</xsl:copy>
	</xsl:template>	
	
	<xsl:template name="ProductDivision" >
		<xsl:choose>
			<xsl:when test="./ProductDivision">
				<xsl:for-each select="./ProductDivision">
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="ProductDivisionCode|ProductDivisionName|ProductDivisionRank"/>
					<xsl:call-template name="BusinessGroup"/>
				</xsl:copy>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="./Group">
			<ProductDivision>
					<xsl:call-template name="BusinessGroup"/>
			</ProductDivision>
			</xsl:when>
			<xsl:otherwise/>		
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="BusinessGroup" >
		<xsl:choose>
			<xsl:when test="./BusinessGroup">
				<xsl:for-each select="./BusinessGroup">
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<BusinessGroup>
					<xsl:apply-templates select="@*|node()"/>
				</BusinessGroup>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:template>	
	
		
	<xsl:template match="Category" >
		<xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@type"/>
					<xsl:copy-of select="CategoryCode"/>
					<xsl:copy-of select="CategoryReferenceName"/>
					<xsl:copy-of select="CategoryName"/>
					<xsl:copy-of select="CategorySeoName"/>
					<xsl:copy-of select="CategoryRank"/>
					<xsl:if test="SubCategory">
						<L3><L4><L5><L6><xsl:apply-templates select="SubCategory"/></L6></L5></L4></L3>
					</xsl:if>					
					<xsl:apply-templates select="L3"/>
		</xsl:copy>
	</xsl:template>
		
	<xsl:template match="L3" >
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="L3Code|L3ReferenceName|L3Name|L3Rank"/>
					<xsl:if test="SubCategory">
						<L4><L5><L6><xsl:apply-templates select="SubCategory"/></L6></L5></L4>
					</xsl:if>	
					<xsl:apply-templates select="L4"/>
				</xsl:copy>
	</xsl:template>
	
	<xsl:template match="L4" >
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="L4Code|L4ReferenceName|L4Name|L4Rank"/>
					<xsl:if test="SubCategory">
						<L5><L6><xsl:apply-templates select="SubCategory"/></L6></L5>
					</xsl:if>	
					<xsl:apply-templates select="L5"/>
				</xsl:copy>
	</xsl:template>
	
	<xsl:template match="L5" >
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="L5Code|L5ReferenceName|L5Name|L5Rank"/>
					<xsl:if test="SubCategory">
						<L6><xsl:apply-templates select="SubCategory"/></L6>
					</xsl:if>	
					<xsl:apply-templates select="L6"/>
				</xsl:copy>
	</xsl:template>
	
	<xsl:template match="L6" >
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="L6Code|L6ReferenceName|L6Name|L6Rank"/>
					<xsl:apply-templates select="SubCategory"/>
				</xsl:copy>
	</xsl:template>
		
	
		
	
	</xsl:stylesheet>