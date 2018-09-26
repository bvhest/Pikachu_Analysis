<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="sectionurl">
  <xsl:if test="$section">
    <xsl:value-of select="concat('section/', $section, '/')"/>
  </xsl:if>
  </xsl:variable>    
  <xsl:param name="param1"/>
  <xsl:variable name="channel" select="/root/sql:rowset/sql:row/sql:id[1]"/>
  <!-- -->
  <xsl:template match="/root">
    <xsl:variable name="rowset" select="sql:rowset"/>
    <html>
      <body contentID="content">
        <xsl:if test="$param1 = ''">
          <h2>Select a channel first!!</h2>
        </xsl:if>
        <xsl:if test="$param1 != ''">
          <h2>Channel catalog selection for <xsl:value-of select="sql:rowset/sql:row/sql:name[1]"/></h2>
          <hr/>
          <form method="POST" enctype="multipart/form-data">
            <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_channel_catalog_selection_post/', $param1, '?channel=', $channel)"/></xsl:attribute>
            <table class="main">
              <tr>
                <td width="100" align="center" style="vertical-align:middle">Locale</td>                
                <td><xsl:value-of select="'Catalog'"/></td>   
                <td><xsl:value-of select="'Division'"/></td>   
                <td><xsl:value-of select="'Brand'"/></td>   
                <td><xsl:value-of select="'Product type'"/></td>                               
                <td><xsl:value-of select="'Enabled'"/></td>                               
                <td><xsl:value-of select="'Locale enabled'"/></td>                               
                <td><xsl:value-of select="'Master locale enabled'"/></td>                        
              </tr>                            
              <xsl:for-each select="distinct-values(sql:rowset/sql:row/sql:locale)">
                <tr>
                  <td align="center" style="vertical-align:middle">
                    <xsl:value-of select="."/>
                  </td>
                  <td><table><xsl:for-each select="$rowset/sql:row[sql:locale=current()]">
                      <tr><td align="center"><xsl:value-of select="sql:catalog_type"/></td></tr>
                  </xsl:for-each></table></td>
                  <td  align="center"><table><xsl:for-each select="$rowset/sql:row[sql:locale=current()]">
                      <tr><td  align="center"><xsl:value-of select="sql:division"/></td></tr>                            
                  </xsl:for-each></table></td>                           
                  <td  align="center"><table><xsl:for-each select="$rowset/sql:row[sql:locale=current()]">
                      <tr><td  align="center"><xsl:value-of select="sql:brand"/></td></tr>                                                        
                  </xsl:for-each></table></td>                                                   
                  <td  align="center"><table><xsl:for-each select="$rowset/sql:row[sql:locale=current()]">                            
                      <tr><td  align="center"><xsl:value-of select="sql:product_type"/></td></tr>                                                
                  </xsl:for-each></table></td>                                                                               
                  <td  align="center"><table><xsl:for-each select="$rowset/sql:row[sql:locale=current()]">                            
                      <tr><td  align="center"><xsl:value-of select="sql:enabled"/></td></tr>                            
                  </xsl:for-each></table></td>                                                                               
                  <td  align="center"><table><xsl:for-each select="$rowset/sql:row[sql:locale=current()]">                            
                      <tr><td  align="center"><xsl:value-of select="sql:localeenabled"/></td></tr>                              
                  </xsl:for-each></table></td>                                                                               
                  <td  align="center"><table><xsl:for-each select="$rowset/sql:row[sql:locale=current()]">                            
                      <tr><td  align="center"><xsl:value-of select="sql:masterlocaleenabled"/></td></tr>                                                
                  </xsl:for-each></table></td>                                                                               
                </tr>
              </xsl:for-each>              
            </table>
          </form>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
