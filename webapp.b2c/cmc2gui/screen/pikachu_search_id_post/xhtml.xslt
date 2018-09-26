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
	<xsl:variable name="idreal">
		<xsl:choose>
			<xsl:when test="not (/root/@id = '')">
				<xsl:value-of select="upper-case(/root/@id)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="upper-case($id)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- -->
	<xsl:template match="/root">
		<html>
			<body>
				<h2>Pikachu Fuzzy CTN Search</h2>
				<hr/>
				<form method="POST" enctype="multipart/form-data">
					<xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_id_post/search?id=', $idreal)"/></xsl:attribute>
					<table>
						<tr>
							<td style="width: 140px">Enter&#160;a&#160;CTN&#160;or&#160;partial&#160;CTN<br/>(minimum&#160;3&#160;characters):</td>
							<td style="width: 40px">
								<input name="SearchID" size="60" type="text" value="{$idreal}"/>
							</td>
						</tr>
						<!--
			<tr>
              <td style="width: 140px">Locale</td>
              <td style="width: 205px">
                <input name="Locale" size="60" type="text" value="Master"/>
              </td>
            </tr>
			-->
						<tr>
							<td style="width: 140px"/>
							<td style="width: 205px"/>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
							</td>
							<td style="width: 205px"/>
						</tr>
					</table>
				</form>
				<br/>
				<br/>
				<h2>Search Result</h2>
				<hr/>
				<table class="main">
					<tr>
            <td>CTN</td>
						<td>Subcategory &amp; Catalog Info<a href="javascript:return false" title="Click for subcategory assignment and catalog assignment information">?</a></td>
						<td>Detailed Status Info&#160;<a href="javascript:return false" title="Click for detailed info on OCTLs for this product (PMT_Raw, PMT_Enriched etc.) ">?</a></td>
						<td>Subcategories</td>
					</tr>
					<xsl:apply-templates select="/root/sql:rowset/sql:row"/>
				</table>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset/sql:row">
		<tr>
      <td><xsl:value-of select="sql:id"/></td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_search_post?id=', sql:id)"/></xsl:attribute>
					<xsl:text>Click</xsl:text>
				</a>
			</td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_status_post?id=', sql:id)"/></xsl:attribute>
					<xsl:text>Click</xsl:text>
				</a>
			</td>
			<td>
				<xsl:apply-templates select="sql:rowset[@name = 'subcat']"/>
			</td>
		</tr>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset[@name = 'subcat']">
    <xsl:choose>
      <xsl:when test="sql:row">
    		<xsl:for-each select="sql:row">
    			<xsl:if test="position() &gt; 1">
    				<xsl:text>, </xsl:text>
    			</xsl:if>
    			<xsl:value-of select="sql:subcategorycode"/>
    		</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>This product is not assigned to any subcategories
      </xsl:otherwise>
    </xsl:choose>
    
	</xsl:template>
</xsl:stylesheet>
