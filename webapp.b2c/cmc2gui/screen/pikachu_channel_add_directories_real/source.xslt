<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="dir"/>
	<xsl:param name="channel"/>
	<xsl:template match="/">
		<root>
			<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
				<source:source><xsl:value-of select="$dir"/><xsl:value-of select="$channel"/><xsl:text>/inbox/placeholder.txt</xsl:text></source:source>      
				<source:fragment>		
					<root/>
				</source:fragment>
			</source:write>
			<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
				<source:source><xsl:value-of select="$dir"/><xsl:value-of select="$channel"/><xsl:text>/outbox/placeholder.txt</xsl:text></source:source>      
				<source:fragment>		
					<root/>
				</source:fragment>
			</source:write>
			<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
				<source:source><xsl:value-of select="$dir"/><xsl:value-of select="$channel"/><xsl:text>/disclaimers/placeholder.txt</xsl:text></source:source>      
				<source:fragment>		
					<root/>
				</source:fragment>
			</source:write>
			<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
				<source:source><xsl:value-of select="$dir"/><xsl:value-of select="$channel"/><xsl:text>/temp/placeholder.txt</xsl:text></source:source>      
				<source:fragment>		
					<root/>
				</source:fragment>
			</source:write>
			<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
				<source:source><xsl:value-of select="$dir"/><xsl:value-of select="$channel"/><xsl:text>/archive/placeholder.txt</xsl:text></source:source>      
				<source:fragment>		
					<root/>
				</source:fragment>
			</source:write>
            <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
              <source:source><xsl:value-of select="$dir"/><xsl:value-of select="$channel"/><xsl:text>/archive_ftp/placeholder.txt</xsl:text></source:source>      
              <source:fragment>   
                <root/>
              </source:fragment>
            </source:write>
			<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
				<source:source><xsl:value-of select="$dir"/><xsl:value-of select="$channel"/><xsl:text>/logs/placeholder.txt</xsl:text></source:source>      
				<source:fragment>		
					<root/>
				</source:fragment>
			</source:write>
            <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
              <source:source><xsl:value-of select="$dir"/><xsl:value-of select="$channel"/><xsl:text>/processed/placeholder.txt</xsl:text></source:source>      
              <source:fragment>   
                <root/>
              </source:fragment>
            </source:write>
            <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
              <source:source><xsl:value-of select="$dir"/><xsl:value-of select="$channel"/><xsl:text>/cache/placeholder.txt</xsl:text></source:source>      
              <source:fragment>   
                <root/>
              </source:fragment>
            </source:write>
		</root>
	</xsl:template>
</xsl:stylesheet>
