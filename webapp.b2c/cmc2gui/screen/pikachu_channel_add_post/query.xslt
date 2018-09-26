<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:h="http://apache.org/cocoon/request/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="channel"/>
	<xsl:template match="/h:request/h:requestParameters">
		<xsl:choose>
			<xsl:when test="$channel=''">
				<root>
					<xsl:attribute name="location"><xsl:value-of select="h:parameter[@name='Location']/h:value"/></xsl:attribute>
					<xsl:attribute name="channel"><xsl:value-of select="h:parameter[@name='ID']/h:value"/></xsl:attribute>
					<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
						<sql:query name="channels">
INSERT INTO Channels(id, Name, Locale, Catalog, Location, type, Pipeline, MachineAffinity)
VALUES(
'<xsl:value-of select="h:parameter[@name='ID']/h:value"/>', 
'<xsl:value-of select="h:parameter[@name='Name']/h:value"/>',
'<xsl:value-of select="h:parameter[@name='Locale']/h:value"/>',
'<xsl:value-of select="h:parameter[@name='Catalog']/h:value"/>',
'<xsl:value-of select="translate(h:parameter[@name='Location']/h:value,' ','')"/>',
'<xsl:value-of select="h:parameter[@name='Type']/h:value"/>',
'<xsl:value-of select="translate(h:parameter[@name='Pipeline']/h:value,' ','')"/>',
'<xsl:value-of select="h:parameter[@name='MachineAffinity']/h:value"/>')
				</sql:query>
					</sql:execute-query>
				</root>
			</xsl:when>
			<xsl:otherwise>
				<root>
					<xsl:attribute name="location"><xsl:value-of select="h:parameter[@name='Location']/h:value"/></xsl:attribute>
					<xsl:attribute name="channel"><xsl:value-of select="$channel"/></xsl:attribute>
					<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
						<sql:query name="channels">
UPDATE Channels
   SET Name = '<xsl:value-of select="h:parameter[@name='Name']/h:value"/>'
      ,Locale = '<xsl:value-of select="h:parameter[@name='Locale']/h:value"/>'
      ,Catalog = '<xsl:value-of select="h:parameter[@name='Catalog']/h:value"/>'
      ,Location = '<xsl:value-of select="h:parameter[@name='Location']/h:value"/>'
      ,type = '<xsl:value-of select="h:parameter[@name='Type']/h:value"/>'
      ,Pipeline = '<xsl:value-of select="h:parameter[@name='Pipeline']/h:value"/>'
      ,MachineAffinity = '<xsl:value-of select="h:parameter[@name='MachineAffinity']/h:value"/>'
 WHERE id='<xsl:value-of select="$channel"/>'
						</sql:query>
					</sql:execute-query>
				</root>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="h:node()">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
