<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:shell="http://apache.org/cocoon/shell/1.0">
  <!--  -->    

  <xsl:param name="removeDir"/>

  <xsl:template match="/">
    <root>
      <xsl:for-each-group select="dir:directory/dir:file" group-by="substring(@name, 9)"> 
        <xsl:for-each select="current-group()">
          <xsl:if test="count(current-group()) = position()">
            <cinclude:include src="cocoon:/processUAPGroups/{current-group()/@name}"/>
          </xsl:if>
          
          <delete>
	        <shell:delete>
	          <shell:source>
	            <xsl:value-of select="concat($removeDir, '/', @name)" />
	          </shell:source>
	        </shell:delete>
          </delete>
        </xsl:for-each>
      </xsl:for-each-group>
    </root>    
  </xsl:template>
</xsl:stylesheet>