<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:info="http://www.philips.com/pikachu/3.0/info" exclude-result-prefixes="info">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:param name="gui_url"/>
    <xsl:param name="section"/>
    <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>
    <xsl:template match="@*|node()">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- -->
    <xsl:template match="DerivedCategorizations">
        <xsl:variable name="doctimestamp" select="replace(@DocTimeStamp,'[^0-9]','')"/>
        <xsl:variable name="filename" select="concat('DerivedCategorization_step1_',$doctimestamp)"/>
        <html>
            <head/>
              <body>
                <table style="background-color: #eee; border-color: #aaa; border-style: solid; border-top-width: 1px; border-left-width: 1px; border-bottom-width: 3px; border-right-width: 3px; border-collapse: separate; border-spacing: 10px;">
                    <tr>
                        <td colspan="4">
                            <table style="width: 100%">
                              <xsl:choose>
                                <xsl:when test="not(Nodes/Node[not(@routingCode!='') and count(ProductReferences/ProductReference/CTN) =0])">
                                  <tr style="height: 40px;">
                                      <td style="vertical-align: bottom;">
                                          <h2 style="margin-top: 0px; margin-bottom: 0px;">The&#160;following&#160;information&#160;will&#160;be&#160;imported:</h2>
                                      </td>
                                      <!-- Ok and Cancel buttons -->
                                      <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                                          <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'derivedcategorization_upload_post_step2?doctimestamp=',$doctimestamp,'&amp;filename=',$filename)}">
                                              <span style="color: green; font-family: Arial; font-size: 150%;">&#x25BA;</span>Continue to Step 2</a>
                      &#160;&#160;
                      <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'derivedcategorization_import_cancel?filename=',$filename)}">
                                              <span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span>Cancel</a>
                                      </td>
                                  </tr>
                                </xsl:when>                                
                                <xsl:otherwise>
                                  <tr style="height: 40px;">
<td style="vertical-align: bottom;"><h2 style="margin-top: 0px; margin-bottom: 0px; color: #F00;">The spreadsheet cannot be imported because <br/>a Range has been specified (<xsl:value-of select="string-join(for $i in Nodes/Node[@routingCode='' and count(ProductReferences/ProductReference/CTN) =0]/@code return $i,',')"/>) that has neither a Routing Code nor a product assignment</h2></td>
                                    <!-- Ok and Cancel buttons -->
                                    <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                                      &#160;&#160;
                                      <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;"
                                         href="{concat($gui_url,$section_url,'derivedcategorization_import_cancel?filename=',$filename)}"><span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span> Cancel</a>
                                    </td>
                                  </tr>
                                  </xsl:otherwise>
                                </xsl:choose>
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
                                        <xsl:value-of select="@DocTimeStamp"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right; vertical-align: top; width: 100px;">Catalog</td>
                                    <td style="border: 1px solid #aaf">
                                        <xsl:attribute name="style" select="if(@o = '') then 'margin-top: 0px; margin-bottom: 0px; color: #F00;' else ''"/>
                                        <xsl:value-of select="if(@o != '') then @o else '**MISSING**'"/>
                                    </td>
                                </tr>                                
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="width: 100%; padding: 4px; vertical-align: top; background-color: #fff; border-color: #888; border-style: solid; border-top-width: 2px; border-left-width: 2px; border-bottom-width: 1px; border-right-width: 1px;">
                            <table style="border-collapse: collapse; width: 100%">
                                <xsl:for-each select="DerivedCategorization">
                                    <tr><td colspan="5" style="font-size: 100%; font-weight: bold; background-color: #ffa; border: 1px solid #aaa">Mapping:<xsl:value-of select="@code"/></td></tr>
                                    <tr>
                                        <td colspan="5">
                                            <table width="100%">
                                                <tr>
                                                    <td width="20%" style="font-weight: bold; border: 1px solid #aaf">Destination</td>
                                                    <td>
                                                        <xsl:value-of select="Destination"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="20%" style="font-weight: bold; border: 1px solid #aaf">Source Tree</td>
                                                    <td>
                                                        <xsl:value-of select="SourceTree"/>
                                                    </td>
                                                </tr>                                                
                                                <tr>
                                                    <td width="20%" style="font-weight: bold; border: 1px solid #aaf">Source</td>
                                                    <td>
                                                        <xsl:value-of select="Source"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="20%" style="font-weight: bold; border: 1px solid #aaf">Source level</td>
                                                    <td>
                                                        <xsl:value-of select="SourceLevel"/>
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
