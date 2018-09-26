<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- documentation -->
	<stylesheet xmlns="http://www.relate4u.com/xsl/documentation">
		<description>This is an stylesheet include for the product and product familiy leaflets. 
			It contains templates for retreiving and creating static (translated) text and getting date fields</description>
	</stylesheet>
	<!-- external parameters -->
	<xsl:param name="static-text-folder">../Assets/Static text/</xsl:param>
	<!-- variables -->
	<xsl:variable name="locale-code" select="if($root-node/@Locale) 
		then ($root-node/@Locale) 
		else ('global')"/>
	<xsl:variable name="static-text-doc" select="document($static-text-file)"/>
	<xsl:variable name="last-modified-date" select="if ($last-modified) 
		then (xs:dateTime($last-modified)) 
		else (current-dateTime())"/>
	<!-- text retreival -->
	<xsl:template name="getStaticText">
		<xsl:param as="xs:string" name="field">[none]</xsl:param>
		<xsl:choose>
			<xsl:when test="$static-text-doc/static_text">
				<xsl:variable name="fieldElt" select="$static-text-doc/static_text/fields/field[@id = $field]"/>
				<xsl:choose>
					<!-- check if field with given id exists -->
					<xsl:when test="$fieldElt">
						<xsl:apply-templates select="$fieldElt"/>
					</xsl:when>
					<!-- show message if not exists -->
					<xsl:otherwise>
						<fo:inline xsl:use-attribute-sets="bold red">
							<xsl:text>[field not found '</xsl:text>
							<xsl:value-of select="$field"/>
							<xsl:text>']</xsl:text>
						</fo:inline>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="bold red">
					<xsl:text>[no text for '</xsl:text>
					<xsl:value-of select="$locale-code"/>
					<xsl:text>']</xsl:text>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="field">
		<xsl:apply-templates/>
	</xsl:template>
	<!-- static text markup -->
	<xsl:template match="b">
		<fo:inline xsl:use-attribute-sets="bold">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="i">
		<fo:inline xsl:use-attribute-sets="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="u">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="br">
		<!-- preseve the line feed -->
		<fo:inline linefeed-treatment="preserve" xml:space="preserve">
</fo:inline>
	</xsl:template>
	<!-- dates -->
	<xsl:template name="getYearValue">
		<xsl:value-of select="format-dateTime($last-modified-date,'[Y]')"/>
	</xsl:template>
	<xsl:template name="getDateValue">
		<!-- year -->
		<xsl:call-template name="getYearValue"/>
		<xsl:text>, </xsl:text>
		<!-- look up month name in static text file; month_# -->
		<xsl:call-template name="getStaticText">
			<xsl:with-param name="field" select="concat('month_', format-dateTime($last-modified-date,'[M]'))"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
		<!-- day of month -->
		<xsl:value-of select="format-dateTime($last-modified-date,'[D]')"/>
	</xsl:template>
	<xsl:template name="drawDateChangeBlock">
		<fo:block>
			<fo:block xsl:use-attribute-sets="FooterText">
				<xsl:call-template name="getDateValue"/>
			</fo:block>
			<fo:block xsl:use-attribute-sets="FooterText">
				<xsl:call-template name="getStaticText">
					<xsl:with-param name="field">date_change</xsl:with-param>
				</xsl:call-template>
			</fo:block>
		</fo:block>
	</xsl:template>
</xsl:stylesheet>
