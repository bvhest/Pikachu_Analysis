<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>

  <xsl:template match="/root">
    <html>
      <body>
    		<h2>Upload package brief</h2>
    		<form action="{concat($gui_url,$section_url,'packaging_upload_post')}" method="post" enctype="multipart/form-data">
        <!-- form action="{$gui_url}xml/packaging_upload_post.xml" method="post" enctype="multipart/form-data" -->
    			<input type="file" size="80" name="datafile"/>
    			<br/><br/>
    			<input id="UploadFile" style="width: 137px" type="submit" value="Next"/>
    			<br/><br/><br/>          
    			<hr/>       
    		</form>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
