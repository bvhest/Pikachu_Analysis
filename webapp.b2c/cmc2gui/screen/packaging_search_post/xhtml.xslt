<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="project_code"/>
  <xsl:param name="exact_match"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>

  <xsl:template match="/root">
    <html>
      <body>
        <xsl:choose>
          <xsl:when test="$project_code ne '' and $exact_match eq 'true'">
            <h2 style="margin-bottom: 1em;">Search results</h2>
            <p>Result for project code <b><xsl:value-of select="$project_code"/></b></p>
          </xsl:when>
          <xsl:when test="$project_code ne '' and $exact_match ne 'true'">
            <h2 style="margin-bottom: 1em;">Search results</h2>
            <p>Result for project codes containing <b><xsl:value-of select="$project_code"/></b></p>
          </xsl:when>
          <xsl:otherwise>
            <h2 style="margin-bottom: 1em;">Most recently created packaging projects</h2>
            <p>20 most recent packaging projects</p>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="sql:rowset/sql:row">
            <table class="main">
              <tr>
                <td>Project code</td>
                <td>Date</td>
                <td>Status</td>
              </tr>
              <xsl:apply-templates select="sql:rowset/sql:row"/>
            </table>
          </xsl:when>
          <xsl:otherwise>
            <p>No packaging projects were found.</p>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <tr>
      <td>
        <!-- http://localhost:8888/cmc2gui/section/cmc2/ct_search_post/PP_Configuration/none/PP_7FF1MS05.xml?id=PP_7FF1MS05 -->
        <a title="View status" href="{concat($gui_url,$section_url,'packaging_project_status?id=',sql:project_code)}"><xsl:value-of select="sql:project_code"/></a>
      </td>
      <td><xsl:value-of select="sql:creation_date"/></td>
      <td><xsl:value-of select="sql:status"/></td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
