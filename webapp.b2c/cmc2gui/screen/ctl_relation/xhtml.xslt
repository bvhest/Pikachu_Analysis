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
    <xsl:choose>
      <xsl:when test="(not ($param1 = '')) and ($param1 != 'yes')">
        <xsl:apply-templates select="root"/>
      </xsl:when>
      <xsl:otherwise>
      <!-- No need to display anything; message is displayed by ltrace/xhtml.xsl 
        <html>
          <body contentID="content">
            <h2>
              <xsl:text>Select a content type first!!</xsl:text>
            </h2>
          </body>
        </html>
        -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  
	<xsl:template match="root">
		<html>
			<body>
				<h2>Relation overview</h2>
				<hr/>
				<table cellpadding="0" cellspacing="0">
					<xsl:apply-templates select="/root/sql:rowset[@name = 'input-relations']"/>
					<xsl:apply-templates select="/root/sql:rowset[@name = 'output-relations']"/>
				</table>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="/root/sql:rowset[@name = 'input-relations']">
		<tr>
			<td>
				<b>
					<xsl:value-of select="../@id"/> - input relations
        </b>
			</td>
		</tr>
		<tr>
			<td>
				<table style="gui_main" cellpadding="0" cellspacing="0" width="800">
					<tr>
						<td width="120">In-CT</td>
						<td width="120">In-Loc</td>
						<td width="120">In-ObjectID</td>
						<td width="120">Out-CT</td>
						<td width="120">Out-Loc</td>
						<td width="120">Out-ObjectID</td>
						<td width="80">IsSec</td>
					</tr>
					<xsl:apply-templates select="/root/sql:rowset[@name = 'input-relations']/sql:row"/>
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
	<xsl:template match="/root/sql:rowset[@name = 'input-relations']/sql:row">
		<tr>
			<td>
				<xsl:value-of select="sql:input_content_type"/>
			</td>
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
