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
  		<html>
			<body>
				<h2>Check for missed translations</h2>
				<hr/>
				<table cellpadding="0" cellspacing="0">
          <tr>
            <td>To check for incidences of possible missed translations, 
              <a>
                <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'translation_missed')"/></xsl:attribute>
                <xsl:text>click here</xsl:text>
              </a>
            </td>
          </tr>
				</table>
			</body>
		</html>
  </xsl:template>
	<!-- -->
</xsl:stylesheet>
