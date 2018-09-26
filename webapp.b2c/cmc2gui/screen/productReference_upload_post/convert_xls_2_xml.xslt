<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Convert an Excel input file read by the HSSFGenerator
  to Accessory xml content
  
  See example input file at the bottom of this stylesheet.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gmr="http://www.gnome.org/gnumeric/v7" xmlns:info="http://www.philips.com/pikachu/3.0/info" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- file name of the uploaded file -->
	<xsl:param name="datafile"/>
	<xsl:param name="division" select="'CE'"/>
	<xsl:variable name="current-datetime" select="replace(string(current-dateTime()),'.*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}).*','$1')"/>
	<xsl:variable name="current-timestamp" select="replace($current-datetime,'[^0-9]','')"/>
	<xsl:variable name="docTimestamp" select="$current-datetime"/>
	<xsl:variable name="main-sheet" select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[gmr:Name='Data Collection']"/>
	<xsl:variable name="cells" select="$main-sheet/gmr:Cells"/>	
	
	<xsl:variable name="header-row" select="$cells/gmr:Cell[.='Acc CTN' or .='Sub CTN' ]/@Row cast as xs:integer" as="xs:integer"/>
	<xsl:variable name="maxrow" select="$main-sheet/gmr:MaxRow cast as xs:integer" as="xs:integer" />
	
	<xsl:variable name="Accessories" select="$cells/gmr:Cell[.='Accessories']"/>
	<xsl:variable name="Variations" select="$cells/gmr:Cell[.='Variations']"/>

	<xsl:variable name="SubCTN-col" select="$cells/gmr:Cell[@Row=$header-row and (.='Sub CTN' or .='Acc CTN') ]/@Col"/>	
	<xsl:variable name="SubAlpha-col" select="$cells/gmr:Cell[@Row=$header-row and (.='Sub Alphanumeric' or .='Acc Alphanumeric') ]/@Col"/>	
	<xsl:variable name="SubSubcat-col" select="$cells/gmr:Cell[@Row=$header-row and (.='Sub Subcat' or .='Acc Subcat') ]/@Col"/>	
	<xsl:variable name="SubAG-col" select="$cells/gmr:Cell[@Row=$header-row and (.='Sub AG' or .='Acc AG') ]/@Col"/>
	<xsl:variable name="ObjCTN-col" select="$cells/gmr:Cell[@Row=$header-row and (.='Obj CTN' or .='Perf CTN') ]/@Col"/>	
	<xsl:variable name="ObjAlpha-col" select="$cells/gmr:Cell[@Row=$header-row and (.='Obj Alphanumeric' or .='Perf Alphanumeric' )]/@Col"/>	
	<xsl:variable name="ObjSubcat-col" select="$cells/gmr:Cell[@Row=$header-row and (.='Obj Subcat' or .='Perf Subcat' )]/@Col"/>	
	<xsl:variable name="ObjAG-col" select="$cells/gmr:Cell[@Row=$header-row and (.='Obj AG' or .='Perf AG' )]/@Col"/>	
	
	
	<xsl:template match="node()|@*">
		<xsl:apply-templates select="node()|@*"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="gmr:Workbook/gmr:Sheets">
			<xsl:variable name="referenceType" select="if ($Accessories)  then 'Accessories' else 'Variations' "/>
			<ProductReferences info:source-file="{$datafile}" referenceType="{$referenceType}">
				<xsl:attribute name="DocTimeStamp" select="$docTimestamp"/>
				<!-- Process each Object for each row in the spreadsheet-->
				<xsl:for-each select="for $i in $header-row+1 to $maxrow return $i">
					<xsl:call-template name="processRow">
						<xsl:with-param name="current-row" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</ProductReferences>
	</xsl:template>
	<!-- -->
	<xsl:template name="processRow">
		<xsl:param name="current-row"/>
		
		<xsl:variable name="SubCTN" select="$cells/gmr:Cell[@Row=$current-row and @Col=$SubCTN-col]"/>
		<xsl:variable name="SubAlpha" select="$cells/gmr:Cell[@Row=$current-row and @Col=$SubAlpha-col]"/>
		<xsl:variable name="SubSubcat" select="$cells/gmr:Cell[@Row=$current-row and @Col=$SubSubcat-col]"/>
		<xsl:variable name="SubAG" select="$cells/gmr:Cell[@Row=$current-row and @Col=$SubAG-col]"/>
		<xsl:variable name="ObjCTN" select="$cells/gmr:Cell[@Row=$current-row and @Col=$ObjCTN-col]"/>
		<xsl:variable name="ObjAlpha" select="$cells/gmr:Cell[@Row=$current-row and @Col=$ObjAlpha-col]"/>
		<xsl:variable name="ObjSubcat" select="$cells/gmr:Cell[@Row=$current-row and @Col=$ObjSubcat-col]"/>
		<xsl:variable name="ObjAG" select="$cells/gmr:Cell[@Row=$current-row and @Col=$ObjAG-col]"/>
		
		<ProductReference>
			<Subject>
				<xsl:choose>
					<xsl:when test="$SubCTN != '' ">
						<xsl:attribute name="type" select="'CTN'"/>
						<id><xsl:value-of select="$SubCTN"/></id>
					</xsl:when>
					<xsl:when test="$SubAlpha != '' ">
						<xsl:attribute name="type" select="'Alphanumeric'"/>
						<id><xsl:value-of select="$SubAlpha"/></id>
					</xsl:when>
					<xsl:when test="$SubSubcat != '' ">
						<xsl:attribute name="type" select="'Subcat'"/>
						<id><xsl:value-of select="$SubSubcat"/></id>
					</xsl:when>
					<xsl:when test="$SubAG != '' ">
						<xsl:attribute name="type" select="'AG'"/>
						<id><xsl:value-of select="$SubAG"/></id>
					</xsl:when>
				</xsl:choose>
			</Subject>
			<Object>
				<xsl:choose>
					<xsl:when test="$ObjCTN != '' ">
						<xsl:attribute name="type" select="'CTN'"/>
						<id><xsl:value-of select="$ObjCTN"/></id>
					</xsl:when>
					<xsl:when test="$ObjAlpha != '' ">
						<xsl:attribute name="type" select="'Alphanumeric'"/>
						<id><xsl:value-of select="$ObjAlpha"/></id>
					</xsl:when>
					<xsl:when test="$ObjSubcat != '' ">
						<xsl:attribute name="type" select="'Subcat'"/>
						<id><xsl:value-of select="$ObjSubcat"/></id>
					</xsl:when>
					<xsl:when test="$ObjAG != '' ">
						<xsl:attribute name="type" select="'AG'"/>
						<id><xsl:value-of select="$ObjAG"/></id>
					</xsl:when>
				</xsl:choose>
			</Object>
		</ProductReference>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
