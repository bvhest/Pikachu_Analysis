<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:param name="file-pattern"/>
  
  <!--+
      | For each country/catalog type read the latest and archive the others.  
      +-->
  <xsl:template match="/">
    <root>
      <xsl:for-each-group select="dir:directory/dir:file[matches(@name,$file-pattern)]" group-by="replace(@name,'LP_(\w+?)\.([A-Z]{2})\..*\.xml','$1.$2')">
        <xsl:for-each select="current-group()">
          <xsl:sort select="@name" order="descending"/>        
          <cinclude:include>
            <xsl:attribute name="src" select="if(position() = 1) then 
                                                  concat('cocoon:/readFile/',@name)
                                              else 
                                                  concat('cocoon:/archiveFile/',@name)"/>
          </cinclude:include>
        </xsl:for-each>
      </xsl:for-each-group>
    </root>
  </xsl:template>
</xsl:stylesheet>