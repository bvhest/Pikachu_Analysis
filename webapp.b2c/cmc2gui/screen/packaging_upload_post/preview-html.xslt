<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:info="http://www.philips.com/pikachu/3.0/info"
                exclude-result-prefixes="info">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>
  
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="root">
    <xsl:apply-templates select="PackagingProjectConfiguration"/>
  </xsl:template>
  
  <xsl:template match="PackagingProjectConfiguration">
    <xsl:variable name="project_file" select="@code"/>
    <html>
      <head/>
      <body>
        <table style="background-color: #eee; border-color: #aaa; border-style: solid; border-top-width: 1px; border-left-width: 1px; border-bottom-width: 3px; border-right-width: 3px; border-collapse: separate; border-spacing: 10px;">
          <tr>
            <td colspan="2">
              <table style="width: 100%">
                <xsl:choose>
                  <xsl:when test="not(string-length(@addressee) &gt; 0)">
                    <tr style="height: 40px;">                
<td style="vertical-align: bottom;"><h2 style="margin-top: 0px; margin-bottom: 0px;">The spreadsheet cannot be imported because <br/>no contact email address has been specified</h2></td>
                      <!-- Ok and Cancel buttons -->
                      <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                        &#160;&#160;
                        <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;"
                           href="{concat($gui_url,$section_url,'packaging_import_cancel?project_code=',@code,'&amp;project_file=',$project_file)}"><span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span> Cancel</a>
                      </td>
                    </tr>                
                  </xsl:when>                
                  <xsl:when test="//@info:valid='false' or //@maxLength='NaN'">
                    <tr style="height: 40px;">                
<td style="vertical-align: bottom;"><h2 style="margin-top: 0px; margin-bottom: 0px;">The spreadsheet cannot be imported because <br/>errors have been detected in the input</h2></td>
                      <!-- Ok and Cancel buttons -->
                      <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                        &#160;&#160;
                        <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;"
                           href="{concat($gui_url,$section_url,'packaging_import_cancel?project_code=',@code,'&amp;project_file=',$project_file)}"><span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span> Cancel</a>
                      </td>
                    </tr>                
                  </xsl:when>                                  
                  <xsl:otherwise>
                    <tr style="height: 40px;">
                      <td style="vertical-align: bottom;"><h2 style="margin-top: 0px; margin-bottom: 0px;">The following information will be imported:</h2></td>
                    <!-- Ok and Cancel buttons -->
                      <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                        <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;"
                         href="{concat($gui_url,$section_url,'packaging_import_go?project_code=',@code,'&amp;project_file=',$project_file)}"><span style="color: green; font-family: Arial; font-size: 150%;">&#x25BA;</span> Import</a>
                      &#160;&#160;
                        <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;"
                         href="{concat($gui_url,$section_url,'packaging_import_cancel?project_code=',@code,'&amp;project_file=',$project_file)}"><span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span> Cancel</a>
                      </td>
                    </tr>
                  </xsl:otherwise>
                </xsl:choose>
              </table>
            </td>
          </tr>
          <tr>
            <td style="width: 50%; padding: 4px; vertical-align: top; background-color: #fff; border-color: #888; border-style: solid; border-top-width: 2px; border-left-width: 2px; border-bottom-width: 1px; border-right-width: 1px;">
              <p style="font-size: 120%; font-weight: bold; margin-top: 0px; margin-bottom: 0px;">Project info</p>
              <table style="width: 100%; border-collapse: separate; border-spacing: 3px;">
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">Code</td>
                  <td style="border: 1px solid #aaf"><xsl:value-of select="@code"/></td>
                </tr>
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">Name</td>
                  <td style="border: 1px solid #aaf"><xsl:value-of select="concat(@referenceName,'&#160;')"/></td>
                </tr>
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">Internal Categorization - code</td>
                  <td style="border: 1px solid #aaf"><xsl:value-of select="@categorizationcodepath"/></td>
                </tr>                
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">Internal Categorization - name</td>
                  <td style="border: 1px solid #aaf"><xsl:value-of select="@categorizationnamepath"/></td>
                </tr>                                
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">AG-MAG Categorization - code</td>
                  <td style="border: 1px solid #aaf"><xsl:value-of select="@agmagcodepath"/></td>
                </tr>                
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">AG-MAG Categorization - name</td>
                  <td style="border: 1px solid #aaf"><xsl:value-of select="@agmagnamepath"/></td>
                </tr>                                                
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">Contact</td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="string-length(@addressee) &gt; 0">
                        <xsl:attribute name="style">border: 1px solid #aaf</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">border: 1px solid #aaf; background-color: #f00</xsl:attribute>                      
                      </xsl:otherwise>
                    </xsl:choose>
                  <xsl:value-of select="concat(@addressee,'&#160;')"/></td>
                </tr>                
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">Remarks for <b>Packaging Engineer</b></td>
                  <td style="border: 1px solid #aaf">
                    <div style="width: 100%; height: 120px; overflow: auto">
                      <xsl:value-of select="@remarks4engineer"/>
                    </div>
                   </td>
                </tr>
                <tr>
                  <td style="text-align: right; vertical-align: top; width: 100px;">Remarks for <b>Translation Agency</b></td>
                  <td style="border: 1px solid #aaf">
                    <div style="width: 100%; height: 120px; overflow: auto">
                      <xsl:value-of select="@remarks4translation"/>
                    </div>
                   </td>
                </tr>
                
              </table>
            </td>
            <td style="width: 50%; padding: 4px; vertical-align: top; background-color: #fff; border-color: #888; border-style: solid; border-top-width: 2px; border-left-width: 2px; border-bottom-width: 1px; border-right-width: 1px;">
              <p style="font-size: 120%; font-weight: bold; margin-top: 0px; margin-bottom: 0px;">Languages</p>
              <table style="width: 100%; border-collapse: separate; border-spacing: 3px;">
                <tr>
                  <td style="border: 1px solid #aaf">
                    <div style="width: 100%; height: 174px; overflow: auto">
                      <xsl:for-each select="Localizations/Localization">
                        <p>
                          <xsl:choose>
                            <xsl:when test="@info:valid='false'">
                              <xsl:attribute name="style">font-weight: bold; color: red; background-color: transparent; margin: 0px;</xsl:attribute>
                              <xsl:value-of select="'! '"/>
                            </xsl:when>
                            <xsl:when test="@seo = 'true'">
                              <xsl:attribute name="style">color: green;</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="position() mod 2 != 0">
                              <xsl:attribute name="style">background-color: transparent; margin: 0px;</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="style">background-color: #ddf; margin: 0px;</xsl:attribute>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:value-of select="concat(@info:name,' [',@languageCode,']')"/>
   								<xsl:if test="@seo = 'true'"><xsl:text> (SEO translation)</xsl:text></xsl:if>
                        </p>
                      </xsl:for-each>
                    </div>
                   </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td colspan="2" style="width: 100%; padding: 4px; vertical-align: top; background-color: #fff; border-color: #888; border-style: solid; border-top-width: 2px; border-left-width: 2px; border-bottom-width: 1px; border-right-width: 1px;">
              <p style="font-size: 120%; font-weight: bold; margin-top: 0px; margin-bottom: 0px;">Packaging texts</p>
              <table style="border-collapse: collapse; width: 100%">
                <tr>
                  <td style="font-weight: bold; background-color: #ffa; border: 1px solid #aaa">
                    Name
                  </td>
                  <td style="font-weight: bold; background-color: #ffa; border: 1px solid #aaa">
                    Description
                  </td>
                  <td style="font-weight: bold; background-color: #ffa; border: 1px solid #aaa">
                    Text
                  </td>
                  <td style="font-weight: bold; background-color: #ffa; border: 1px solid #aaa">
                    Remarks
                  </td>
                  <td style="font-weight: bold; background-color: #ffa; border: 1px solid #aaa">
                    MaxLength
                  </td>                  
                </tr>
                <xsl:for-each select="PackagingText/PackagingTextItem">
                  <tr>
                    <xsl:choose>
                      <xsl:when test="@info:valid='false'">
                        <xsl:attribute name="style">font-weight: bold; color: red; background-color: transparent; margin: 0px;</xsl:attribute>
                      </xsl:when>                    
                      <xsl:when test="position() mod 2 = 0">
                        <xsl:attribute name="style">background-color: transparent</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">background-color: #ddf</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    <td style="vertical-align: top; background-color: transparent; border: 1px solid #aaa">
                      <xsl:value-of select="@referenceName"/>
                    </td>
                    <td style="vertical-align: top; background-color: transparent; border: 1px solid #aaa">
                      <xsl:value-of select="@itemDescription"/>
                    </td>
                    <td style="vertical-align: top; background-color: transparent; border: 1px solid #aaa">
                      <xsl:value-of select="ItemText/text()"/>
                    </td>
                    <td style="vertical-align: top; background-color: transparent; border: 1px solid #aaa">
                      <xsl:value-of select="@remarks"/>
                    </td>
                    <td style="vertical-align: top; background-color: transparent; border: 1px solid #aaa; text-align: right">
                      <xsl:value-of select="@maxLength"/>
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
