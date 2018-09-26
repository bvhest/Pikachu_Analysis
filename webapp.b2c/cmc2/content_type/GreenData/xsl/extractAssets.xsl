<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:i="http://apache.org/cocoon/include/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

<xsl:param name="ccr_dir" />
<xsl:param name="content_type"/>
<xsl:param name="svcURL"/>

  <xsl:template match="/root">
    <root>
      <xsl:for-each select="sql:rowset/sql:row">
        <!-- the url is something like http://pww.pcc.philips.com/mprdata/201109/2011090801.xml -->
        <xsl:variable name="url" select="concat($ccr_dir,substring-after(sql:internalresourceidentifier,'mprdata'))" />
        <xsl:variable name="mimetype" select="sql:format" />
        <xsl:variable name="filename" select="replace(sql:object_id,'[^0-9a-zA-Z_\-]','_')" />
        <xsl:variable name="fileext" select="substring-after($mimetype, '/')" />
        
        <product filename="{concat($filename,'.',$fileext}" ctn="{sql:object_id}">
          <i:include>
            <xsl:attribute name="src" select="concat('cocoon:/download/',$filename,'.',$fileext,'/',$url,'?mimeType=',$mimetype,'&amp;ctn=',sql:object_id)" />
          </i:include>
        </product>
      </xsl:for-each> <!-- end loop over assets -->	  
	  <i:include src="{$svcURL}/processControl/sql_storeFileCount/{$content_type}/{count(sql:rowset/sql:row)}"/>	  
    </root>
  </xsl:template>
</xsl:stylesheet>

<!--
{count(sql:rowset/sql:row)}
-->