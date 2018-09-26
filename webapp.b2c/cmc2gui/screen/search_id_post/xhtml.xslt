<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
    <xsl:if test="$section">
      <xsl:value-of select="concat('section/', $section, '/')"/>
    </xsl:if>
  </xsl:variable>    
	<xsl:param name="id"/>
	<xsl:param name="param1" select="search"/>
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Search for Object ID</h2>
				<hr/>        
				<form method="POST" enctype="multipart/form-data">
					<xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl,'search_id_post')"/></xsl:attribute>
					<table>
						<tr>
              <td style="width: 140px">Enter&#160;a&#160;partial&#160;CTN&#160;to&#160;find<br/>matches&#160;and&#160;associated&#160;content&#160;types:</td>
							<td style="width: 205px">
								<input name="SearchID" size="60" type="text" value="{$id}"/>
							</td>
						</tr>
						<tr>
							<td style="width: 140px"/>
							<td style="width: 205px"/>
						</tr>
						<tr>
              <td align="center" colspan="2">
								<input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
							</td>
						</tr>
					</table>
				</form>
				<br/>
				<br/>
				<h2>ID Search Result</h2>
				<hr/>
				<table class="main">
					<tr>
						<td>ObjectID</td>
						<td>Content Types</td>
					</tr>
					<xsl:apply-templates select="/root/sql:rowset/sql:row"/>
				</table>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset/sql:row">
		<tr>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'search_post?id=', sql:object_id)"/></xsl:attribute>
					<xsl:value-of select="sql:object_id"/>
				</a>
			</td>
			<td>
				<xsl:apply-templates select="sql:rowset[@name = 'search_id_type']"/>
			</td>
		</tr>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset[@name = 'search_id_type']">
		<xsl:for-each select="sql:row">
			<xsl:if test="position() &gt; 1">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:value-of select="sql:content_type"/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
