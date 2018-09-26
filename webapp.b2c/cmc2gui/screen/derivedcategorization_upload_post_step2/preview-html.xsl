<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:info="http://www.philips.com/pikachu/3.0/info" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
  exclude-result-prefixes="info">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="Categorization">
    <xsl:variable name="doctimestamp" select="replace(ancestor::DerivedCategorizations/@DocTimeStamp,'[^0-9]','')"/>
    <xsl:variable name="filename" select="concat('DerivedCategorization_step2_',$doctimestamp)"/>
    <xsl:variable name="scheduleid" select="ancestor::DerivedCategorizations/scheduleid/sql:rowset/sql:row/sql:id"/>
    <html>
      <head/>
      <body>
        <table style="background-color: #eee; border-color: #aaa; border-style: solid; border-top-width: 1px; border-left-width: 1px; border-bottom-width: 3px; border-right-width: 3px; border-collapse: separate; border-spacing: 10px;">
          <tr>
            <td>
              <table style="width: 100%">
                <tr style="height: 40px;">
                  <td style="vertical-align: bottom;">
                    <h2 style="margin-top: 0px; margin-bottom: 0px;">The&#160;following&#160;information&#160;will&#160;be&#160;imported:</h2>
                  </td>
                  <!-- Ok and Cancel buttons -->
                  <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                    <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'derivedcategorization_import_go?doctimestamp=',$doctimestamp,'&amp;filename=',$filename,'&amp;scheduleid=',$scheduleid)}">
                      <span style="color: green; font-family: Arial; font-size: 150%;">&#x25BA;</span> Import</a>
                    &#160;&#160;
                    <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'derivedcategorization_import_cancel')}">
                      <span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span> Cancel</a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style="width: 100%; padding: 4px; vertical-align: top; background-color: #fff; border-color: #888; border-style: solid; border-top-width: 2px; border-left-width: 2px; border-bottom-width: 1px; border-right-width: 1px;">
              <p style="font-size: 120%; font-weight: bold; margin-top: 0px; margin-bottom: 0px;">Upload info</p>
              <table style="width: 100%; border-collapse: separate; border-spacing: 3px;">
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">DocTimeStamp</td>
                  <td style="border: 1px solid #aaf">
                    <xsl:value-of select="ancestor::DerivedCategorizations/@DocTimeStamp"/>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style="width: 100%; padding: 4px; vertical-align: top; background-color: #fff; border-color: #888; border-style: solid; border-top-width: 2px; border-left-width: 2px; border-bottom-width: 1px; border-right-width: 1px;">
              <table style="border-collapse: collapse; width: 100%">
                <xsl:for-each select="Catalog">
                  <tr>
                    <td style="font-size: 100%; font-weight: bold; background-color: #ddf; border: 1px solid #aaa">
                    Catalog:<xsl:value-of select="CatalogCode"/>
                      <table width="100%">
                        <tr>
                          <td>
                            <table width="100%">
                              <xsl:for-each select="FixedCategorization/Group">
                                <tr>
                                  <td>
                                    <table width="100%">
                                      <tr>
                                        <xsl:attribute name="style">background-color: #CFF</xsl:attribute>
                                        <td style="border: 1px solid #aaa">
                                          <p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px">Group code: <xsl:value-of select="GroupCode"/>
                                          </p>
                                          <table width="100%">
                                            <tr>
                                              <td>
                                                <xsl:choose>
                                                  <xsl:when test="descendant::CatRef">
                                                    <!-- Group has mappings somewhere -->
                                                    <xsl:for-each select="Category">
                                                      <tr>
                                                        <td>
                                                          <table width="100%">
                                                            <tr>
                                                              <xsl:attribute name="style">background-color: #ddF</xsl:attribute>
                                                              <td width="100%" style="font-weight: bold; border: 1px solid #aaa">
                                                                <p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px; xxborder: 1px solid #aaa">Category code: <xsl:value-of select="CategoryCode"/>
                                                                </p>
                                                                <table width="100%">
                                                                  <tr>
                                                                    <td>
                                                                      <table width="100%">
                                                                        <xsl:choose>
                                                                          <xsl:when test="descendant::CatRef">
                                                                            <!-- Category has mappings somewhere -->
                                                                            <xsl:for-each select="SubCategory">
                                                                              <tr>
                                                                                <td>
                                                                                  <table width="100%">
                                                                                    <tr>
                                                                                      <xsl:attribute name="style">background-color: #cff</xsl:attribute>
                                                                                      <td style="font-weight: bold; border: 1px solid #aaa">
                                                                                        <p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px">SubCategory code: <xsl:value-of select="SubCategoryCode"/>
                                                                                        </p>
                                                                                        <table width="100%">
                                                                                          <tr>
                                                                                            <td>
                                                                                              <table width="100%">
                                                                                                <xsl:choose>
                                                                                                  <xsl:when test="descendant::CatRef">
                                                                                                    <!-- SubCategory has mappings -->
                                                                                                    <xsl:for-each select="CatRef">
                                                                                                      <tr>
                                                                                                        <xsl:attribute name="style">background-color: #fff</xsl:attribute>
                                                                                                        <td style="font-weight: bold">
                                                                            Source tree:<xsl:value-of select="@sourcetree"/>
                                                                                                        </td>
                                                                                                      </tr>
                                                                                                      <tr>
                                                                                                        <xsl:attribute name="style">background-color: #fff</xsl:attribute>
                                                                                                        <td style="font-weight: bold">
                                                                            Source mapping:<xsl:value-of select="."/>
                                                                                                        </td>
                                                                                                      </tr>
                                                                                                      
                                                                                                    </xsl:for-each>
                                                                                                  </xsl:when>
                                                                                                  <xsl:otherwise>
                                                                                                    <tr>
                                                                                                      <xsl:attribute name="style">background-color: #fff</xsl:attribute>
                                                                                                      <td width="4%" style="color:#f00; border: 1px solid #aaa">This SubCategory has no mappings to itself or its descendant nodes</td>
                                                                                                    </tr>
                                                                                                  </xsl:otherwise>
                                                                                                </xsl:choose>
                                                                                              </table>
                                                                                            </td>
                                                                                          </tr>
                                                                                        </table>
                                                                                      </td>
                                                                                    </tr>
                                                                                  </table>
                                                                                </td>
                                                                              </tr>
                                                                            </xsl:for-each>
                                                                          </xsl:when>
                                                                          <xsl:otherwise>
                                                                            <tr>
                                                                              <xsl:attribute name="style">background-color: #fff</xsl:attribute>
                                                                              <td width="4%" style="font-weight: bold; border: 1px solid #aaa; color:#f00">This Category has no mappings to itself or its descendant nodes</td>
                                                                            </tr>
                                                                          </xsl:otherwise>
                                                                        </xsl:choose>
                                                                      </table>
                                                                    </td>
                                                                  </tr>
                                                                </table>
                                                              </td>
                                                            </tr>
                                                          </table>
                                                        </td>
                                                      </tr>
                                                    </xsl:for-each>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                    <tr>
                                                      <xsl:attribute name="style">background-color: #fff</xsl:attribute>
                                                      <td width="4%" style="font-weight: bold; border: 1px solid #aaa; color: #f00">This Group has no mappings to itself or its descendant nodes</td>
                                                    </tr>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </xsl:for-each>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
