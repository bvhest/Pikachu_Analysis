<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- documentation -->
	<stylesheet xmlns="http://www.relate4u.com/xsl/documentation">
		<description>This is an stylesheet include for the product and product familiy leaflets.
			It contains the common content elements; title, header, body,  ...</description>
	</stylesheet>
	<!-- headers -->
	<xsl:template match="WOW">
		<fo:block xsl:use-attribute-sets="WOW">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="Name" mode="family">
		<fo:block xsl:use-attribute-sets="Designation">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="FamilyName" mode="product">
		<fo:block xsl:use-attribute-sets="FamilyNameProduct">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="DTN">
		<fo:block xsl:use-attribute-sets="Designation">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- body -->
	<xsl:template match="FullProductName" mode="product">
		<fo:block xsl:use-attribute-sets="IntroductionText">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>	
	<xsl:template match="MarketingTextHeader" mode="family">
		<fo:block xsl:use-attribute-sets="IntroductionText">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="MarketingTextHeader" mode="product">
		<fo:block xsl:use-attribute-sets="BodyText">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- generic rich text bullet list -->
	<xsl:template match="Item" mode="genericlist">
		<fo:block>
			<xsl:apply-templates mode="genericlist"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="Head[parent::*/parent::RichText[@type='WarningText']]" mode="genericlist"/>
	<xsl:template match="BulletList" mode="genericlist">
		<fo:list-block provisional-distance-between-starts="2mm" provisional-label-separation="2mm">
			<!-- apply bullet items, sorted by rank -->
			<xsl:apply-templates mode="genericlist" select="BulletItem">
				<xsl:sort data-type="number" select="@rank"/>
			</xsl:apply-templates>
		</fo:list-block>
	</xsl:template>
	<xsl:template match="BulletItem" mode="genericlist">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="BodyText">
					<xsl:text>•</xsl:text>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<!-- apply text or sub list -->
				<xsl:apply-templates mode="genericlist" select="Text | SubList"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="SubList" mode="genericlist">
		<fo:list-block provisional-distance-between-starts="2mm" provisional-label-separation="2mm">
			<!-- apply sub list items, sorted by rank-->
			<xsl:apply-templates mode="genericlist" select="SubItem">
				<xsl:sort data-type="number" select="@rank"/>
			</xsl:apply-templates>
		</fo:list-block>
	</xsl:template>
	<xsl:template match="SubItem" mode="genericlist">
		<!-- render sub list item as body text list with hyphens -->
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="BodyText">
					<xsl:text>-</xsl:text>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates mode="genericlist" select="Text"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	<xsl:template match="Text" mode="genericlist">
		<fo:block xsl:use-attribute-sets="BodyText">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="SUB">
		<fo:inline vertical-align="sub" font-size="smaller">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="SUB" mode="texttable">
		<fo:inline vertical-align="sub" font-size="smaller">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="SUP">
		<fo:inline vertical-align="super" font-size="smaller">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="SUP" mode="texttable">
		<fo:inline vertical-align="super" font-size="smaller">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- ignore sql namespace elements-->
	<xsl:template match="sql:*"/>
</xsl:stylesheet>
