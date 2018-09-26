<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="id">0</xsl:param>
  <xsl:param name="channel"/>
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>
          <xsl:value-of select="sql:rowset/sql:row/sql:name"/> deleted</h2>
        <hr/>
        <xsl:for-each select="//sql:error">
          <p>
            <xsl:value-of select="node()"/>
          </p>
        </xsl:for-each>
        <p>done</p>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="sql:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
