<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:me="http://apache.org/a">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
	<xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>		   
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>File Report: Files created for 'PMT_Translated' older than 3 months but still active</h2>
				<hr/>
				<table class="main" style="table-layout: fixed; width: 900px;">
					<tr>
						<td style="width:530px">Filename</td>
						<td style="width:100px">ObjectId</td>
						<td style="width:40px">Locale</td>
						<td style="width:50px">Version</td>
						<td style="width:140px">Document timestamp</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:row">
		<tr>
			<td>
				<xsl:value-of select="sql:filename"/>
			</td>
			<td>
				<a>
				<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,$sectionurl,'ct_search_post/PMT_Translated/',sql:localisation,'/',translate(sql:object_id,'/','_'),'.xml?id=',sql:object_id)"/></xsl:attribute>
				<xsl:value-of select="sql:object_id"/>
				</a>
			</td>          
			<td>
				<a>
				<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,$sectionurl,'content_type_localisation/PMT_Translated/',sql:localisation)"/></xsl:attribute>
				<xsl:value-of select="sql:localisation"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="sql:marketingversion"/>
			</td>
			<td>
				<xsl:value-of select="sql:doctimestamp"/>
			</td>
		</tr>
	</xsl:template>
	<!-- -->
	<xsl:function name="me:strip" as="xs:string">
		<xsl:param name="d"/>
		<xsl:value-of select="translate(translate(translate(translate(substring($d,1,19),'-',''),'T',''),':',''),' ','')"/>
	</xsl:function>
	<!-- -->
	<xsl:function name="me:compDate" as="xs:boolean">
		<xsl:param name="dt_a" as="xs:string"/>
		<xsl:param name="dt_b" as="xs:string"/>
		<xsl:choose>
			<xsl:when test="me:strip($dt_a) &gt; me:strip($dt_b)">
				<xsl:copy-of select="true()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
