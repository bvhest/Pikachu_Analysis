<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:r4u="http://www.relate4u.com/xsl/functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- documentation -->
	<stylesheet xmlns="http://www.relate4u.com/xsl/documentation">
		<description>This is an stylesheet include for the product and product familiy leaflets. 
			It contains style definitions, colors and layout variables</description>
	</stylesheet>
	<!-- external parameters -->
	<xsl:param name="debug-borders">false</xsl:param>
	<!-- grid units -->
	<xsl:variable name="grid-line">1.5875</xsl:variable>
	<xsl:variable name="blank-line" select="concat(3 * $grid-line,'mm')"/>
	<xsl:variable name="border-width">0.07055</xsl:variable>
	<!-- transform case -->
	<xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<!-- colors -->
	<xsl:variable name="black">rgb-icc(0%,0%,0%,#CMYK,0%,0%,0%,100%)</xsl:variable>
	<xsl:variable name="white">rgb-icc(0%,0%,0%,#CMYK,0%,0%,0%,0%)</xsl:variable>
	<xsl:variable name="blue_base">rgb-icc(0%,0%,0%,#CMYK,100%,40%,0%,0%)</xsl:variable>
	<xsl:variable name="blue_soft">rgb-icc(0%,0%,0%,#CMYK,50%,0%,0%,5%)</xsl:variable>
	<xsl:variable name="blue_tint">rgb-icc(0%,0%,0%,#CMYK,20%,0%,0%,0%)</xsl:variable>
	<xsl:variable name="red">rgb-icc(0%,0%,0%,#CMYK,0%,100%,100%,0%)</xsl:variable>
	<xsl:variable name="grey">rgb-icc(0%,0%,0%,#CMYK,0%,0%,0%,40%)</xsl:variable>
	<!-- color sets -->
	<xsl:attribute-set name="blue">
		<xsl:attribute name="color" select="$blue_base"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="black">
		<xsl:attribute name="color" select="$black"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="white">
		<xsl:attribute name="color" select="$white"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="red">
		<xsl:attribute name="color" select="$red"/>
	</xsl:attribute-set>
	<!-- fonts -->
	<xsl:attribute-set name="page">
		<xsl:attribute name="axf:ligature-mode">all</xsl:attribute>
		<xsl:attribute name="hyphenate">false</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="base">
		<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		<xsl:attribute name="font-selection-strategy">character-by-character</xsl:attribute>
		<xsl:attribute name="line-stacking-strategy">font-height</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="regular" use-attribute-sets="base">
		<xsl:attribute name="font-family">Gill Sans Alt One WGL, Arial Unicode MS</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="light" use-attribute-sets="base">
		<xsl:attribute name="font-family">Gill Sans Alt One WGL Light , Arial Unicode MS</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="bold" use-attribute-sets="regular">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="italic" use-attribute-sets="regular">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	<!-- grid alignment -->
	<xsl:attribute-set name="baseline-one">
		<xsl:attribute name="line-height" select="concat(1 * $grid-line,'mm')"/>
		<xsl:attribute name="text-altitude" select="concat(1 * $grid-line,'mm')"/>
		<xsl:attribute name="text-depth">0mm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="baseline-one-half">
		<xsl:attribute name="line-height" select="concat(1.5 * $grid-line,'mm')"/>
		<xsl:attribute name="text-altitude" select="concat(1.5 * $grid-line,'mm')"/>
		<xsl:attribute name="text-depth">0mm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="baseline-two">
		<xsl:attribute name="line-height" select="concat(2 * $grid-line,'mm')"/>
		<xsl:attribute name="text-altitude" select="concat(2 * $grid-line,'mm')"/>
		<xsl:attribute name="text-depth">0mm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="baseline-three">
		<xsl:attribute name="line-height" select="concat(3 * $grid-line,'mm')"/>
		<xsl:attribute name="text-altitude" select="concat(2 * $grid-line,'mm')"/>
		<xsl:attribute name="text-depth" select="concat(1 * $grid-line,'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="baseline-four">
		<xsl:attribute name="line-height" select="concat(4 * $grid-line,'mm')"/>
		<xsl:attribute name="text-altitude" select="concat(3 * $grid-line,'mm')"/>
		<xsl:attribute name="text-depth" select="concat(1 * $grid-line,'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="baseline-five">
		<xsl:attribute name="line-height" select="concat(5 * $grid-line,'mm')"/>
		<xsl:attribute name="text-altitude" select="concat(4 * $grid-line,'mm')"/>
		<xsl:attribute name="text-depth" select="concat(1 * $grid-line,'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="baseline-six">
		<xsl:attribute name="line-height" select="concat(6 * $grid-line,'mm')"/>
		<xsl:attribute name="text-altitude" select="concat(5 * $grid-line,'mm')"/>
		<xsl:attribute name="text-depth" select="concat(1 * $grid-line,'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="baseline-eight">
		<xsl:attribute name="line-height" select="concat(8 * $grid-line,'mm')"/>
		<xsl:attribute name="text-altitude" select="concat(6 * $grid-line,'mm')"/>
		<xsl:attribute name="text-depth" select="concat(2 * $grid-line,'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="baseline-nine">
		<xsl:attribute name="line-height" select="concat(9 * $grid-line,'mm')"/>
		<xsl:attribute name="text-altitude" select="concat(7 * $grid-line,'mm')"/>
		<xsl:attribute name="text-depth" select="concat(2 * $grid-line,'mm')"/>
	</xsl:attribute-set>
	<!-- convenience methods -->
	<xsl:attribute-set name="blank-line">
		<xsl:attribute name="margin-bottom" select="$blank-line"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="blank-space">
		<xsl:attribute name="space-after" select="$blank-line"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="keep-next">
		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="keep-previous">
		<xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="keep-together">
		<xsl:attribute name="keep-together.within-column">5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="keep-together-page">
		<xsl:attribute name="keep-together.within-page">100</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="keep-together-always">
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="image-block">
		<xsl:attribute name="font-size">0pt</xsl:attribute>
		<xsl:attribute name="line-height">0pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hyphenate">
		<xsl:attribute name="hyphenate">true</xsl:attribute>
		<xsl:attribute name="hyphenation-push-character-count">4</xsl:attribute>
		<xsl:attribute name="hyphenation-remain-character-count">4</xsl:attribute>
		<xsl:attribute name="language">
			<!-- get 'de' from 'de_DE', should point to 'de.xml' in {XSLFormatter}/hyphenation folder -->
			<xsl:value-of select="substring-before($locale-code,'_')"/>
		</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="widoworphan">
		<xsl:attribute name="orphans">2</xsl:attribute>
		<xsl:attribute name="widows">2</xsl:attribute>
	</xsl:attribute-set>
	<!-- headers -->
	<xsl:attribute-set name="FamilyNameProduct" use-attribute-sets="light blue baseline-five">
		<xsl:attribute name="font-size">24pt</xsl:attribute>
		<xsl:attribute name="space-after" select="concat((5 * $grid-line),'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="FamiliyNameFamily" use-attribute-sets="light black baseline-five blank-line keep-next">
		<xsl:attribute name="font-size">18pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="Designation" use-attribute-sets="light blue baseline-three">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="space-after" select="concat((5 * $grid-line),'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="WOW" use-attribute-sets="light blue baseline-eight blank-line keep-next">
		<xsl:attribute name="font-size">28pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="BodyHeader" use-attribute-sets="bold blue baseline-three keep-next">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="PageHeading" use-attribute-sets="regular white baseline-four">
		<xsl:attribute name="font-size">12pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="CaptionHeader" use-attribute-sets="regular blue baseline-three">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- body -->
	<xsl:attribute-set name="IntroductionText" use-attribute-sets="light black blank-line baseline-four blank-line">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="BodyText" use-attribute-sets="regular black blank-line baseline-three blank-line">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="FooterText" use-attribute-sets="regular black baseline-two">
		<xsl:attribute name="font-size">7.5pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="CaptionText" use-attribute-sets="light black baseline-three">
		<xsl:attribute name="font-size">7.5pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="LegalText" use-attribute-sets="regular baseline-one-half">
		<xsl:attribute name="color" select="$grey"/>
		<xsl:attribute name="font-size">4.8pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- text table -->
	<xsl:attribute-set name="RichTextTitle" use-attribute-sets="light blue baseline-four blank-line keep-next">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="RichTextHeader" use-attribute-sets="regular blue baseline-two">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="RichTextData" use-attribute-sets="regular black baseline-two">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- grid table -->
	<xsl:attribute-set name="TableSpecsHeaderCell">
		<xsl:attribute name="background-color" select="$blue_tint"/>
		<xsl:attribute name="border-bottom" select="$border-grey"/>
		<xsl:attribute name="padding-right">2mm</xsl:attribute>
		<xsl:attribute name="padding-bottom" select="concat(($grid-line - (1.5 * $border-width)),'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="TableHeaderText" use-attribute-sets="bold black baseline-two">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="TableSubHeaderText" use-attribute-sets="bold black baseline-two">
		<xsl:attribute name="font-size">6pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="TableDimensionDataCell">
		<xsl:attribute name="border-bottom" select="$border-black"/>
		<xsl:attribute name="padding-right">2mm</xsl:attribute>
		<!-- TODO: fix this; requires a unexplainable offset of 0.025 mm per table row to maintain alignment to baseline grid-->
		<xsl:attribute name="padding-bottom" select="concat(($grid-line - $border-width + 0.025),'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="TableSpecsDataCell">
		<xsl:attribute name="border-bottom" select="$border-grey"/>
		<xsl:attribute name="padding-right">2mm</xsl:attribute>
		<xsl:attribute name="padding-bottom" select="concat(($grid-line - $border-width),'mm')"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="TableDataText" use-attribute-sets="light black baseline-two">
		<xsl:attribute name="font-size">6pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- borders -->
	<xsl:variable name="border-grey">
		<xsl:value-of select="$border-width"/>
		<xsl:text>mm solid </xsl:text>
		<xsl:value-of select="$grey"/>
	</xsl:variable>
	<xsl:variable name="border-black">
		<xsl:value-of select="$border-width"/>
		<xsl:text>mm solid </xsl:text>
		<xsl:value-of select="$black"/>
	</xsl:variable>
	<!-- debug -->
	<xsl:attribute-set name="DebugBody" use-attribute-sets="bold red baseline-three blank-line">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="DebugBodySmall" use-attribute-sets="bold red baseline-one blank-line">
		<xsl:attribute name="font-size">4pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template name="addDebugBorders">
		<xsl:if test="$debug-borders = 'true'">
			<xsl:attribute name="border">
				<xsl:text>0.3pt dashed </xsl:text>
				<xsl:value-of select="$grey"/>
			</xsl:attribute>
			<xsl:attribute name="padding">-0.3pt</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="addDebugBorderLeft">
		<xsl:if test="$debug-borders = 'true'">
			<xsl:attribute name="border-left">
				<xsl:text>0.3pt dashed </xsl:text>
				<xsl:value-of select="$grey"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="addDebugBorderRight">
		<xsl:if test="$debug-borders = 'true'">
			<xsl:attribute name="border-right">
				<xsl:text>0.3pt dashed </xsl:text>
				<xsl:value-of select="$grey"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<!-- functions -->
	<xsl:function name="r4u:convert-pt-mm">
		<xsl:param name="pt"/>
		<xsl:choose>
			<xsl:when test="string(number($pt)) = 'NaN'">
				<xsl:value-of select="$pt"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="(127 div 360) * number($pt)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="r4u:convert-mm-pt">
		<xsl:param name="mm"/>
		<xsl:choose>
			<xsl:when test="string(number($mm)) = 'NaN'">
				<xsl:value-of select="$mm"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="(360 div 127) * number($mm)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
