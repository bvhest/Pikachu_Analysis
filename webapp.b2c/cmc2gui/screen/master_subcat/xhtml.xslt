<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:param name="catalogcode"/>
  <xsl:variable name="sectionurl">
    <xsl:if test="$section">
      <xsl:value-of select="concat('section/', $section, '/')"/>
    </xsl:if>
  </xsl:variable>
  <!-- -->
  <xsl:template match="/root">
    <html>
      <body contentID="content">
        <h2>CMC2.0 Master SubCategory List for the <xsl:value-of select="$catalogcode"/> Category Tree</h2>
        <hr/>
        <table class="main">
        <xsl:if test="$catalogcode = 'ProductTree'">
          <xsl:attribute name="style" select="'width: 1600px;'"/>
        </xsl:if>
          <tr>
            <td>CatTree Code</td>
            <xsl:if test="$catalogcode = 'ProductTree'">
              <td style="width:100px;">Product<br/>Division Code</td>
              <td style="width:150px;">Product<br/>Division Name</td>
              <td style="width:100px;">Business<br/>Group Code</td>
              <td style="width:200px;">Business<br/>Group Name</td>
              <td style="width:100px;">Business<br/>Unit Code</td>
              <td style="width:200px;">Business<br/>Unit Name</td>
              <td style="width:100px;">Main Article<br/>Group Code</td>
              <td style="width:200px;">Main Article<br/>Group Name</td>
            </xsl:if>
            <td style="width:100px;">
              <xsl:value-of select="if($catalogcode = 'ProductTree') then 'Article Group Code' else 'SubCategory Code'"/>&#160;<a href="javascript:return false" title="Click to see details of products assigned to this subcategory">?</a>
            </td>
            <td style="width:200px;">
              <xsl:value-of select="if($catalogcode = 'ProductTree') then 'Article Group Name' else 'SubCategory Name'"/>&#160;<a href="javascript:return false" title="Click to see translation details for this subcategory">?</a>
            </td>
            <td>CTN count&#160;<a href="javascript:return false" title="This is the number of products assigned to this subcategory">?</a>
            </td>
          </tr>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="sql:row">
    <tr>
      <td>
        <xsl:value-of select="sql:catalogcode"/>
      </td>
      <xsl:if test="$catalogcode = 'ProductTree'">
        <td>
          <a>
            <xsl:value-of select="sql:pdcode"/>
          </a>
        </td>
        <td>
          <a>
            <xsl:value-of select="sql:pdname"/>
          </a>
        </td>
        <td>
          <a>
            <xsl:value-of select="sql:bgroupcode"/>
          </a>
        </td>
        <td>
          <a>
            <xsl:value-of select="sql:bgroupname"/>
          </a>
        </td>
        <td>
          <a>
            <xsl:value-of select="sql:groupcode"/>
          </a>
        </td>
        <td>
          <a>
            <xsl:value-of select="sql:groupname"/>
          </a>
        </td>
        <td>
          <a>
            <xsl:value-of select="sql:categorycode"/>
          </a>
        </td>
        <td>
          <a>
            <xsl:value-of select="sql:categoryname"/>
          </a>
        </td>
      </xsl:if>
      <td>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'categorisation_object/', sql:subcategorycode,'/', sql:catalogcode)"/></xsl:attribute>
          <xsl:value-of select="sql:subcategorycode"/>
        </a>
      </td>
      <td>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="concat($gui_url, $sectionurl, 'translatedsubcats/', sql:subcategorycode)"/></xsl:attribute>
          <xsl:value-of select="sql:subcategoryname"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="sql:count"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
