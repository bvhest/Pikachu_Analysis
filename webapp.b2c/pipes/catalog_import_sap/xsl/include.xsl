<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  -->    

  <xsl:template match="/">
    <root>
      <xsl:for-each-group select="dir:directory/dir:file"
      					  group-by="substring(@name, 1, 37)">
      	<xsl:for-each select="current-group()">
         <xsl:sort select="@name" order="descending"/>        
         <cinclude:include>
           <xsl:attribute name="src" select="if(position() = 1) then concat('cocoon:/readFile/',@name) else concat('cocoon:/archiveFile/',@name)"/>
         </cinclude:include>
       </xsl:for-each>
      </xsl:for-each-group>
    </root>
  </xsl:template>
</xsl:stylesheet>