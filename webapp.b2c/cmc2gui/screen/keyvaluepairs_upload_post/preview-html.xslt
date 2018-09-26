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
  <xsl:template match="KeyValuePairs">
    <xsl:variable name="current-timestamp" select="replace(@DocTimeStamp,'[^0-9]','')"/>
    <xsl:variable name="filename" select="concat('KeyValuePairs_',$current-timestamp)"/>
    <html>
      <head/>
      <body>
        <table style="background-color: #eee; border-color: #aaa; border-style: solid; border-top-width: 1px; border-left-width: 1px; border-bottom-width: 3px; border-right-width: 3px; border-collapse: separate; border-spacing: 10px;">
          <xsl:choose>
            <!--xsl:when test="KeyValuePair[...]">
              <tr style="height: 40px;">
                <td style="vertical-align: bottom;">
                  <h3 style="margin-top: 0px; margin-bottom: 0px; color: #F00;">The spreadsheet cannot be imported because <br/>a KeyValuePair has been specified (<xsl:value-of select="string-join(for $i in KeyValuePair[Active='YES'][Country='' or SubCategory='']/@code return $i,',')"/>) that: <ul>
                      <li>is missing a Country specification, or</li>
                      <li>is missing a SubCategory specification</li>
                    </ul>
                  </h3>
                </td>
                <!- - Ok and Cancel buttons - ->
                <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                                      &#160;&#160;
                                      <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'rangetext_raw_import_cancel?filename=',$filename)}">
                    <span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span> Cancel</a>
                </td>
              </tr>
            </xsl:when>
            <xsl:when test="KeyValuePair[Active='YES'][Action='REPLACE'][MasterString='']">
              <tr style="height: 40px;">
                <td style="vertical-align: bottom;">
                  <h3 style="margin-top: 0px; margin-bottom: 0px; color: #F00;">The spreadsheet cannot be imported because <br/>a KeyValuePair has been specified (<xsl:value-of select="string-join(for $i in KeyValuePair[Active='YES'][Action='REPLACE'][MasterString='']/@code return $i,',')"/>) that: <ul>
                      <li>has action = 'Replace'</li>
                      <li>is missing a MasterString specification</li>
                    </ul>
                  </h3>
                </td>
                <!- - Ok and Cancel buttons - ->
                <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                                      &#160;&#160;
                                      <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'rangetext_raw_import_cancel?filename=',$filename)}">
                    <span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span> Cancel</a>
                </td>
              </tr>
            </xsl:when>
            <xsl:when test="KeyValuePair[Active='YES'][Action='REMOVE'][ProductNode2Remove=''][RangeNode2Remove='']">
              <tr style="height: 40px;">
                <td style="vertical-align: bottom;">
                  <h3 style="margin-top: 0px; margin-bottom: 0px; color: #F00;">The spreadsheet cannot be imported because <br/>a KeyValuePair has been specified (<xsl:value-of select="string-join(for $i in KeyValuePair[Active='YES'][Action='REMOVE'][ProductNode2Remove=''][RangeNode2Remove='']/@code return $i,',')"/>) that: <ul>
                      <li>is active </li>
                      <li>has action = 'Remove'</li>
                      <li>is missing a ProductNode to Remove</li>
                      <li>is missing a RangeNode to Remove</li>
                    </ul>
                  </h3>
                </td>
                <!- - Ok and Cancel buttons - ->
                <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                                      &#160;&#160;
                                      <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'rangetext_raw_import_cancel?filename=',$filename)}">
                    <span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span> Cancel</a>
                </td>
              </tr>
            </xsl:when>
            <xsl:when test="KeyValuePair[Active='YES'][Action='REPLACE'][ProductNode2Replace=''][RangeNode2Replace='']">
              <tr style="height: 40px;">
                <td style="vertical-align: bottom;">
                  <h3 style="margin-top: 0px; margin-bottom: 0px; color: #F00;">The spreadsheet cannot be imported because <br/>a KeyValuePair has been specified (<xsl:value-of select="string-join(for $i in KeyValuePair[Active='YES'][Action='REPLACE'][ProductNode2Replace=''][RangeNode2Replace='']/@code return $i,',')"/>) that: <ul>
                      <li>is active </li>
                      <li>has action = 'Replace'</li>
                      <li>is missing a ProductNode to Replace</li>
                      <li>is missing a RangeNode to Replace</li>
                    </ul>
                  </h3>
                </td>
                <!- - Ok and Cancel buttons - ->
                <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                                      &#160;&#160;
                                      <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'rangetext_raw_import_cancel?filename=',$filename)}">
                    <span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span> Cancel</a>
                </td>
              </tr>
            </xsl:when-->
            <xsl:otherwise>
              <tr>
                <td colspan="4">
                  <table style="width: 100%">
                    <tr style="height: 40px;">
                      <td style="vertical-align: bottom;">
                        <h2 style="margin-top: 0px; margin-bottom: 0px;">The&#160;following&#160;information&#160;will&#160;be&#160;imported:</h2>
                      </td>
                      <!-- Ok and Cancel buttons -->
                      <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                        <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'keyvaluepairs_import_go?doctimestamp=',$current-timestamp,'&amp;filename=',$filename)}">
                          <span style="color: green; font-family: Arial; font-size: 150%;">&#x25BA;</span>Continue to Step 2</a>
                    &#160;&#160;
                    <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'keyvaluepairs_import_cancel?filename=',$filename)}">
                          <span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span>Cancel</a>
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
                        <xsl:value-of select="@DocTimeStamp"/>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td colspan="2" style="width: 100%; padding: 4px; vertical-align: top; background-color: #fff; border-color: #888; border-style: solid; border-top-width: 2px; border-left-width: 2px; border-bottom-width: 1px; border-right-width: 1px;">
                  <table style="border-collapse: collapse; width: 100%">
                    <xsl:for-each select="object">
                      <tr>
                        <td colspan="5" style="font-size: 100%; font-weight: bold; background-color: #ffa; border: 1px solid #aaa">Object Id: <xsl:value-of select="@code"/>
                        </td>
                      </tr>
                      <xsl:for-each select="KeyValuePair">
                      <tr>
                        <td colspan="5">
                          <table width="100%">
                            <tr>
                              <td colspan="2">
                                <xsl:variable name="active-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0']/@Col"/>
                                <p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px; background-color: #ddf; border: 1px solid #aaa">
                                  <xsl:value-of select="'KeyValuePair Data'"/>
                                </p>
                              </td>
                            </tr>
                            <tr>
                              <td width="20%" style="font-weight: bold; border: 1px solid #aaf">Key</td>
                              <td>
                                <xsl:value-of select="Key"/>
                              </td>
                            </tr>
                            <tr>
                              <td width="20%" style="font-weight: bold; border: 1px solid #aaf">Value</td>
                              <td>
                                <xsl:value-of select="Value"/>
                              </td>
                            </tr>
                            <tr>
                              <td width="20%" style="font-weight: bold; border: 1px solid #aaf">Type</td>
                              <td>
                                <xsl:value-of select="Type"/>
                              </td>
                            </tr>
                            <tr>
                              <td width="20%" style="font-weight: bold; border: 1px solid #aaf">Unit of Measure</td>
                              <td>
                                <xsl:value-of select="UnitOfMeasure"/>
                              </td>
                            </tr>                            
                            <tr>
                              <td width="20%" style="font-weight: bold; border: 1px solid #aaf">ACTION</td>
                              <td><xsl:if test="@action='Delete'">
                              <xsl:attribute name="style" select="'background-color: #f00; font-weight: bold; border: 1px solid #aaa; font-color: #fff'"/></xsl:if>
                                <xsl:value-of select="@action"/>
                              </td>
                            </tr>                                                        
                          </table>
                        </td>
                      </tr>
                      </xsl:for-each>
                    </xsl:for-each>
                  </table>
                </td>
              </tr>
            </xsl:otherwise>
          </xsl:choose>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
