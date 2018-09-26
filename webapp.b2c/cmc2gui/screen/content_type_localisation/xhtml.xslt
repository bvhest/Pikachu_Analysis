<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1">catalog_log</xsl:param>
  <xsl:param name="param2">none</xsl:param>
  <xsl:param name="gui_url"/>
	<xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>		   
  <xsl:variable name="object_preview" select="if(starts-with($param1,'Range')) then 'range_preview' else 'object_preview'"/>
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>
          <xsl:value-of select="concat('''', $param1,''' object list for localisation ''', $param2,'''')"/>
        </h2>
        <hr/>
        <table class="main">
          <tr>
            <td>ObjectID</td>
            <td>Raw</td>
            <td>Preview</td>
            <td>MasterLastModified</td>
            <td>LastModified</td>
            <td>Needsprocessing</td>
            <td>Deleted</td>
          </tr>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset/sql:row">
    <tr>
      <td>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,$sectionurl,'ct_search_post/',$param1,'/',$param2,'/',translate(sql:object_id,'/','_'),'.xml?id=',sql:object_id)"/></xsl:attribute>
          <xsl:value-of select="sql:object_id"/>
        </a>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="sql:dataavailable=1">
            <a target="_default">
              <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/object_store/',$param1,'/',$param2,'/',translate(sql:object_id,'/','_'),'.xml?id=',sql:object_id,'&amp;masterlastmodified_ts=',sql:masterlastmodified_ts,'&amp;lastmodified_ts=',sql:lastmodified_ts)"/></xsl:attribute>
              <xsl:text>Raw</xsl:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="sql:dataavailable=1">
            <a target="_default">
              <xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'xmlraw/',$object_preview,'/',$param1,'/',$param2,'/',translate(sql:object_id,'/','_'),'.html?id=',sql:object_id,'&amp;masterlastmodified_ts=',sql:masterlastmodified_ts,'&amp;lastmodified_ts=',sql:lastmodified_ts)"/></xsl:attribute>
              <xsl:text>Preview</xsl:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="sql:masterlastmodified_ts"/>
      </td>
      <td>
        <xsl:value-of select="sql:lastmodified_ts"/>
      </td>
      <td>
        <xsl:value-of select="sql:needsprocessing_flag"/>
      </td>
      <td>
        <xsl:value-of select="sql:deleted"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
