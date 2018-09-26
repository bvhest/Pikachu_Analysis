<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:saxon="http://saxon.sf.net/" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="sql xsl source">
	<!-- -->
	<xsl:output name="output-def" method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	<!-- -->
	<xsl:param name="dir"/>
  <xsl:param name="datadir"/>
	<xsl:param name="channel"/>
	<xsl:param name="locale"/>
	<xsl:param name="exportdate"/>
  <!-- -->
  <xsl:variable name="directory" select="/root/dir:directory"/>
  <!-- -->
  <xsl:template match="/root/dir:directory"/>
	<!-- -->
	<xsl:template match="/root/root">
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source><xsl:value-of select="$dir"/>logs/Report_<xsl:value-of select="$exportdate"/>.xml</source:source>
			<source:fragment>
				<report>
          <xsl:variable name="content">
            <xsl:apply-templates select="root/sql:rowset"/>
          </xsl:variable>
          <xsl:copy-of select="$content"/>
          <totals>
            <locales><xsl:value-of select="count($content/locale)"/></locales>
            <totalelapsed><xsl:value-of select="sum($content/locale/elapsed_sec)"/></totalelapsed>
            <totalsize><xsl:value-of select="sum($content/locale/sizekb)"/></totalsize>
            <avgrate_kbsec><xsl:value-of select="round(sum($content/locale/sizekb) div sum($content/locale/elapsed_sec))" as="xs:integer"/></avgrate_kbsec>
          </totals>
				</report>
			</source:fragment>
		</source:write>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset">
		<locale code="{sql:row[1]/sql:locale}">
      <xsl:variable name="start" select="sql:row[sql:ctn[contains(.,'START')]]/sql:lasttransmit" as="xs:dateTime"></xsl:variable>
      <xsl:variable name="end" select="sql:row[sql:ctn[contains(.,'END')]]/sql:lasttransmit" as="xs:dateTime"></xsl:variable>
      <xsl:variable name="elapsed" select="$end - $start"/>
      <xsl:variable name="elapsed_sec" select="$elapsed div xdt:dayTimeDuration('PT1S')"/>
      
      <!--
      <xsl:variable name="file" select="document(concat('../',$datadir,'/',sql:row[1]/sql:locale,'.xml'))"/>
      <xsl:variable name="filesize" select="ceiling(string-length(saxon:serialize($file,'output-def')) div 1000)"/>
      -->
      <xsl:variable name="filename" select="concat(sql:row[1]/sql:locale,'.xml')"/>
      <xsl:variable name="filesize" select="$directory/dir:file[@name=$filename]/@size"/>
      <xsl:variable name="filesizekb" select="round(number($filesize) div 1000)"/>
      <sizekb><xsl:value-of select="$filesizekb" as="xs:integer"/></sizekb>
			<start><xsl:value-of select="$start"/></start>
      <end><xsl:value-of select="$end"/></end>      
      <elapsed_sec><xsl:value-of select="$elapsed_sec"/></elapsed_sec>
      <rate_kbsec><xsl:value-of select="if($elapsed_sec gt 0) then round(number($filesizekb idiv $elapsed_sec)) else 0" as="xs:decimal"/></rate_kbsec>
		</locale>
	</xsl:template>
	<!-- -->
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
