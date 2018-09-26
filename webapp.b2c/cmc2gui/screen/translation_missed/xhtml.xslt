<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="id"/>
	<xsl:param name="param1" select="search"/>
	<xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>	  
  
  
  <xsl:template match="/">
    <xsl:apply-templates select="root"/>
  </xsl:template>


  
	<xsl:template match="root">
		<html>
			<body>
				<h2>Possible missed translations</h2>
				<hr/>
				<table cellpadding="0" cellspacing="0">
					<xsl:apply-templates select="/root/sql:rowset[@name = 'missedtranslations']"/>
				</table>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset[@name = 'missedtranslations']">
      <tr><td>&#160;</td></tr>
  		<tr><td>Below is a list of products (i.e. OCTLs, content type = PMT_Localised) that possibly ought to have been exported for translation since the PMT_Localised OCTL changed, but which have not been.</td></tr>
      <tr><td>&#160;</td></tr>
      <tr><td>&#160;</td></tr>
		<tr>
			<td>
				<table class="main" cellpadding="0" cellspacing="0" width="800">
					<tr>
            <xsl:choose>
              <xsl:when test="sql:row">
                <xsl:for-each select="sql:row[1]/node()">
                  <td width="120"><xsl:value-of select="upper-case(local-name())"/></td>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <td><b>None found.</b></td>
              </xsl:otherwise>
            </xsl:choose>
					</tr>
					<xsl:apply-templates select="sql:row"/>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset[@name = 'missedtranslations']/sql:row">
		<tr>
    <xsl:for-each select="node()">
			<td>
				<xsl:value-of select="text()"/>
			</td>
      
      <!--
			<td>
				<xsl:value-of select="sql:input_localisation"/>
			</td>
			<td>
				<xsl:value-of select="sql:input_object_id"/>
			</td>
			<td>
				<xsl:value-of select="sql:output_content_type"/>
			</td>
			<td>
				<xsl:value-of select="sql:output_localisation"/>
			</td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,$sectionurl, 'search_post?id=', sql:output_object_id)"/></xsl:attribute>
					<xsl:value-of select="sql:output_object_id"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="sql:issecondary"/>
			</td>
      -->
                </xsl:for-each>
		</tr>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset[@name = 'output-relations']">
		<tr>
			<td>
				<b>
					<xsl:value-of select="../@id"/> - output relations
        </b>
			</td>
		</tr>
		<tr>
			<td>
				<table style="gui_main" cellpadding="0" cellspacing="0" width="800">
					<tr>
						<td width="120">Out-CT</td>
						<td width="120">Out-Loc</td>
						<td width="120">Out-ObjectID</td>
						<td width="120">In-CT</td>
						<td width="120">In-Loc</td>
						<td width="120">In-ObjectID</td>
						<td width="80">IsSec</td>
					</tr>
					<xsl:apply-templates select="/root/sql:rowset[@name = 'output-relations']/sql:row"/>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset[@name = 'output-relations']/sql:row">
		<tr>
			<td>
				<xsl:value-of select="sql:output_content_type"/>
			</td>
			<td>
				<xsl:value-of select="sql:output_localisation"/>
			</td>
			<td>
				<xsl:value-of select="sql:output_object_id"/>
			</td>
			<td>
				<xsl:value-of select="sql:input_content_type"/>
			</td>
			<td>
				<xsl:value-of select="sql:input_localisation"/>
			</td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,$sectionurl, 'search_post?id=', sql:input_object_id)"/></xsl:attribute>
					<xsl:value-of select="sql:input_object_id"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="sql:issecondary"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
