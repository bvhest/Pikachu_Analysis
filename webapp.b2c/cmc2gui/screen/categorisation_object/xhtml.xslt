<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
    <xsl:if test="$section">
      <xsl:value-of select="concat('section/', $section, '/')"/>
    </xsl:if>
  </xsl:variable>     
  <!-- -->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>Objects categorized into subcategory "<xsl:value-of select="@id"/>" for categorization "<xsl:value-of select="@catalogcode"/>"</h2>
        <hr/>
        <table class="main">
          <tr>
            <td width="100">ObjectID</td>
            <td width="100">Status</td>            
            <td width="100">Division</td>
            <td width="100">DisplayName</td>
            <td width="100">ObjectType</td>
						<td width="100">Catalog search</td>
          </tr>
          <xsl:choose>
            <xsl:when test="sql:rowset/sql:row">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <tr><td colspan="6" align="center"><xsl:attribute name="bgcolor">#FFD5D1</xsl:attribute>No products are assigned to subcategory "<xsl:value-of select="@id"/>" for categorization "<xsl:value-of select="@catalogcode"/>"</td></tr>
            </xsl:otherwise>
          </xsl:choose>
        </table>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset/sql:row">
    <tr>
      <td>
        <a>
          <xsl:if test="sql:status != ''">
          <xsl:attribute name="href">
          <!--
            <xsl:value-of select="concat($gui_url, $sectionurl,'search_post?id=',sql:object_id)"/>
            -->
            <xsl:value-of select="concat(   $gui_url
                                          , 'xmlraw/object_store/'
                                          , sql:content_type
                                          , '/'
                                          , sql:localisation
                                          , '/'
                                          , translate(sql:object_id,'/','_')
                                          , '.xml?id='
                                          , sql:object_id
                                          , '&amp;masterlastmodified_ts='
                                          , sql:masterlastmodified_ts
                                          , '&amp;lastmodified_ts='
                                          , sql:lastmodified_ts)
            "/>
          </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="sql:object_id"/>
        </a>
        
        
      </td>
      <td>
        <xsl:value-of select="if(sql:status = '') then 'No PCT content' else sql:status"/>
      </td>      
      <td>
        <xsl:value-of select="sql:division"/>
      </td>      
      <td>
        <xsl:value-of select="sql:display_name"/>
      </td>
      <td>
        <xsl:value-of select="sql:object_type"/>
      </td>
					<td>
						<a>
							<xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl,'pikachu_search_post/search?id=', sql:object_id)"/></xsl:attribute>
					Search
				</a>
					</td>      
    </tr>
  </xsl:template>
</xsl:stylesheet>
