<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>

  <xsl:template match="/root">
    <html>
      <body>
    		<h2>Search packaging projects</h2>
    		<form method="post">
          <xsl:attribute name="action" select="concat($gui_url,$section_url,'packaging_search_post')"/>
          <p>
    			Project id: <input name="project_code" size="30" type="text"/>
          <input type="checkbox" name="exact_match" value="true"/>Use exact match
          </p>
    			<hr/>
    			<br/><br/>
    			<input style="width: 137px" type="submit" value="Search"/>
    		</form>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
