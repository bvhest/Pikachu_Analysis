<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
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
        <h2>Search Catalogs: Specify criteria</h2>
        <hr/>
        <br/>
    Use this screen to retrieve product assignments for a particular catalog and country.<br/>
        <br/>
    You may use the wildcard character '*' to specify a partial ctn, e.g. 42*FL9900*.
    
    <br/>
        <br/>
        <br/>
        <form method="POST" id="to_form" name="to_form" enctype="multipart/form-data">
          <xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'search_by_catalog_post')"/></xsl:attribute>
          <table>
            <tr>
              <td colspan="2">
                <b>Step 1: Specify criteria:</b>
              </td>
            </tr>
            <tr style="background-color:#ddf">
              <td colspan="2">
                <xsl:call-template name="catalog">
                  <xsl:with-param name="catalogs" select="sql:rowset[@name='ctgcountry']"/>
                </xsl:call-template>
              </td>
            </tr>
            <tr/>
            <tr/>
            <tr/>
            <tr/>
            <tr/>
            <tr/>
            <tr>
              <td colspan="2">
                <b>Step 2: Specify filter criteria:</b>
              </td>
            </tr>
            <tr style="background-color:#cff">
              <td>
                <table cellspacing="0">
                  <tr>
                    <td>Retrieve details for:&#160;&#160;&#160;&#160;&#160;&#160;&#160;</td>
                    <td>
                      <BR/>
                      <INPUT TYPE="RADIO" NAME="radiofilesfilter" VALUE="all" checked="true"/>All assignments<BR/>
                      <INPUT TYPE="RADIO" NAME="radiofilesfilter" VALUE="active"/>Only active assignments (SOP &lt; today and EOP in the future)<BR/>
                      <INPUT TYPE="RADIO" NAME="radiofilesfilter" VALUE="inactive"/>Only inactive assignments (SOP &gt; today or EOP &lt; today)<P/>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr/>
            <tr/>
            <tr/>
            <tr/>
            <tr/>
            <tr/>
            <tr>
              <td colspan="2">
                <b>Step 3: Submit:</b>
              </td>
            </tr>
            <tr>
              <td colspan="2" align="center">
                <input id="SendChannelData" style="width: 200px" type="submit" value="Retrieve assignment details"/>
              </td>
            </tr>
          </table>
        </form>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template name="catalog">
    <xsl:param name="catalogs"/>
    <table>
      <tr>
        <td style="width: 180px">
          <b>Specify an object id (optional; partial&#160;or&#160;full):</b>
        </td>
        <td style="width: 205px">
          <input name="id" size="60" type="text"/>
        </td>
      </tr>
      <tr/>
      <tr>
        <td align="left">
          <b>&#160;&#160;&#160;&#160;and</b>
        </td>
      </tr>
      <tr/>
      <tr>
        <td style="width: 180px">
          <b>Choose a catalog id (mandatory)</b>
        </td>
        <td style="width: 205px">
          <select name="catalog">
            <option value="CONSUMER" selected="selected">CONSUMER</option>
            <xsl:for-each select="distinct-values($catalogs/sql:row/sql:customer_id[.!=''])">
              <xsl:sort select="."/>
              <option>
                <xsl:attribute name="value" select="."/>
                <xsl:value-of select="."/>
              </option>
            </xsl:for-each>
          </select>
        </td>
      </tr>
      <tr/>
      <tr>
        <td align="left">
          <b>&#160;&#160;&#160;&#160;and</b>
        </td>
      </tr>
      <tr/>
      <tr>
        <td style="width: 180px">
          <b>Choose a country (mandatory)</b>
        </td>
        <td style="width: 205px">
          <select name="country">
            <option value="AE" selected="selected">AE</option>
            <xsl:for-each select="distinct-values($catalogs/sql:row/sql:country[.!=''])">
              <xsl:sort select="."/>
              <option>
                <xsl:attribute name="value" select="."/>
                <xsl:value-of select="."/>
              </option>
            </xsl:for-each>
          </select>
        </td>
      </tr>
      <tr>
        <td colspan="2"/>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
