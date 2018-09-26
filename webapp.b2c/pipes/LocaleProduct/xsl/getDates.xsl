<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="reportDate">test</xsl:param>
	<!--  -->
	<xsl:template match="/">
		<root>
			<xsl:attribute name="ctn"><xsl:value-of select="/Products/Product[1]/CTN"/></xsl:attribute>
			<xsl:attribute name="locale"><xsl:value-of select="/Products/Product[1]/@Locale"/></xsl:attribute>
			<CreateDate>
				<!-- xsl:value-of select="/Products/Product[1]/WOW"/ -->
				<xsl:call-template name="FormatDate">
					<xsl:with-param name="DateTime" select="/Products/Product[1]/WOW"/>
				</xsl:call-template>
			</CreateDate>
			<ProcessStartDate>
				<xsl:value-of select="/Products/Product[1]/@masterLastModified"/>
			</ProcessStartDate>
			<ProcessEndDate>
				<xsl:value-of select="/Products/Product[1]/@lastModified"/>
			</ProcessEndDate>
			<ReportDate>
				<xsl:value-of select="$reportDate"/>
			</ReportDate>
		</root>
	</xsl:template>
	<!--  -->
	<xsl:template name="FormatDate">
		<xsl:param name="DateTime"/>
		<xsl:choose>
			<xsl:when test="string-length($DateTime) &gt; 14">
					<xsl:value-of select="concat( substring($DateTime,1,4),'-', substring($DateTime,5,2),'-', substring($DateTime,7,5),':', substring($DateTime,12,2),':', substring($DateTime,14,2))"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- new date format 2006-01-14T08:55:22 -->
				<xsl:variable name="mo">
					<xsl:value-of select="substring($DateTime,4,3)"/>
				</xsl:variable>
				<xsl:variable name="day">
					<xsl:value-of select="substring($DateTime,1,2)"/>
				</xsl:variable>
				<xsl:variable name="year">
					<xsl:value-of select="substring($DateTime,8,2)"/>
				</xsl:variable>
				<xsl:value-of select="'20'"/>
				<xsl:value-of select="$year"/>
				<xsl:value-of select="'-'"/>
				<xsl:choose>
					<xsl:when test="$mo = 'JAN'">01</xsl:when>
					<xsl:when test="$mo = 'FEB'">02</xsl:when>
					<xsl:when test="$mo = 'MAR'">03</xsl:when>
					<xsl:when test="$mo = 'APR'">04</xsl:when>
					<xsl:when test="$mo = 'MAY'">05</xsl:when>
					<xsl:when test="$mo = 'JUN'">06</xsl:when>
					<xsl:when test="$mo = 'JUL'">07</xsl:when>
					<xsl:when test="$mo = 'AUG'">08</xsl:when>
					<xsl:when test="$mo = 'SEP'">09</xsl:when>
					<xsl:when test="$mo = 'OCT'">10</xsl:when>
					<xsl:when test="$mo = 'NOV'">11</xsl:when>
					<xsl:when test="$mo = 'DEC'">12</xsl:when>
				</xsl:choose>
				<xsl:value-of select="'-'"/>
				<xsl:value-of select="$day"/>
				<xsl:value-of select="'T12:00:00'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
