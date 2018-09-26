<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:me="http://apache.org/a">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="id">0</xsl:param>
	<xsl:param name="gui_url"/>
	<xsl:param name="param1"/>
	<xsl:param name="section"/>
	<xsl:variable name="sectionurl">
		<xsl:if test="$section">
			<xsl:value-of select="concat('section/', $section, '/')"/>
		</xsl:if>
	</xsl:variable>
	<!-- -->
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Pika-Chu channel overview</h2>
				<hr/>
				<table>
					<tr>
						<td width="40">Id</td>
						<td width="100">Name</td>
						<td width="100">Type</td>
						<td>Pipeline</td>
						<td>MachineAffinity</td>
						<td width="120">StartExec<br/>EndExec</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:row">
		<tr>
			<td>
				<xsl:value-of select="sql:id"/>
			</td>
			<td>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'section/', sql:type, '/pikachu_channel_home/', sql:location)"/></xsl:attribute>
					<xsl:value-of select="sql:name"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="sql:type"/>
			</td>
			<td>
				<xsl:value-of select="sql:pipeline"/>
			</td>
			<td>
				<xsl:value-of select="sql:machineaffinity"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="me:compDate(sql:startexec, sql:endexec)">
						<xsl:attribute name="bgcolor">#FF0000</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
    				<xsl:choose>
    					<xsl:when test="sql:resultcode = 0">          
                <xsl:attribute name="bgcolor">#00FF00</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="bgcolor">#FF00FF</xsl:attribute>
              </xsl:otherwise>              
            </xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				<table width="100%">
					<tr>
						<td>
							<xsl:value-of select="sql:startexec"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:value-of select="sql:endexec"/>
						</td>
					</tr>
				</table>
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
			<xsl:when test="me:strip($dt_a) gt me:strip($dt_b)">
				<xsl:copy-of select="true()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
