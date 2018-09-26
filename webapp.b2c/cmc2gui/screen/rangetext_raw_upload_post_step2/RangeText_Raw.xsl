<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- -->
  <xsl:import href="../../../cmc2xucdm/xucdm-preview/xucdm-range-generic.xsl"/>
  <xsl:param name="img_link" select="'http://pww.p3c.philips.com/cgi-bin/newmpr/get.pl'"/>
  <xsl:param name="gui_url"/>
  <xsl:param name="section"/>
  <xsl:param name="doctimestamp"/>
  <xsl:param name="filename"/>
  <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>
  <xsl:template match="/RangeText_Raw/Nodes">
    <html>
      <xsl:call-template name="range_head"/>
      <body contentID="content">
        <div class="philips-body">
          <table style="border-color: #2554C7" border="0">
            <tr style="border-style:none">
              <td>
                <table style="border-color: #aaa; background-color: #eee; border-style:solid" border="1">
                  <tr>
                    <td width="66%" style="border-style:none">
                      <table>
                        <tr>
                          <td>
                            <table width="800px">
                              <tr style="height: 40px;">
                                <td style="vertical-align: bottom; border-style:none" width="33%">
                                  <h2 style="margin-top: 0px; margin-bottom: 0px;">The&#160;following&#160;information&#160;will&#160;be&#160;imported:</h2>
                                </td>
                                <td style="vertical-align: bottom; border-style:none" width="20%"/>
                                <!-- Ok and Cancel buttons -->
                                <td style="text-align: right; vertical-align: bottom; padding: 4px 2px; border-style:none">
                                  <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'rangetext_raw_import_go?doctimestamp=',$doctimestamp,'&amp;filename=',$filename)}">
                                    <span style="color: green; font-family: Arial; font-size: 150%;">&#x25BA;</span>Continue to Step 3</a>
                    &#160;&#160;
                    <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'rangetext_raw_import_cancel?filename=',$filename)}">
                                    <span style="color: red; font-family: Arial; font-size: 150%;">&#x25A0;</span>Cancel</a>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
              <td width="33%"/>
            </tr>
            <tr style="border-style:none">
              <td style="border-style:none">
                <xsl:apply-templates mode="range"/>
              </td>
            </tr>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
