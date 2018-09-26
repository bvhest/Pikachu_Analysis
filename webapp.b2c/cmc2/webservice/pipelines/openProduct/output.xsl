<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:pf="http://tempuri.org/"
                exclude-result-prefixes="sql"
                >
  <xsl:param name="gui_url">/cmc2gui/</xsl:param>
  <xsl:param name="internalSystemId">Empower Me</xsl:param>
  <xsl:param name="userID" select="''"/>
  <xsl:param name="ctn" select="''"/>

  <xsl:template match="Products">
    <xsl:element name="html">
      <xsl:element name="head">
        <xsl:call-template name="link">
          <xsl:with-param name="href" select="'/cmc2gui/themes/style_Philips.css'"/>
        </xsl:call-template>
        
        <xsl:element name="title">
          <xsl:value-of select="$internalSystemId"/><xsl:text> | a Philips CL e-Platform tool</xsl:text>
        </xsl:element>
      </xsl:element>
      <xsl:element name="body">
        <table class="gui_main" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr height="80px">
              <td>
                <table class="gui_main" width="950px" height="80px" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table class="gui_main header" width="850px" height="80px" border="0" cellspacing="0" cellpadding="0">
                        <!--Company Bar - logo -->
                        <tr height="21">
                          <td width="500">
                            <img src="{$gui_url}themes/images/Brand_PhilipsLogo.jpg" alt="Philips"/>
                          </td>
                          <td class="environment" width="150" align="right">
                            <b><xsl:value-of select="$internalSystemId"/></b>
                          </td>
                        </tr>
                        <tr height="3">
                          <td colspan="3">
                            <img src="{$gui_url}themes/images/line_graywithwhite.jpg" width="850px" height="3"/>
                          </td>
                        </tr>
                        <!--Company Bar - department -->
                        <tr height="37">
                          <td>
                            <img src="{$gui_url}themes/images/Brand_PhilipsBar.jpg" alt="Consumer Electronics" width="500px"/>
                          </td>
                        </tr>
                        <tr height="3">
                          <td colspan="3">
                            <img src="{$gui_url}themes/images/line_graywithwhite.jpg" width="750px" height="3"/>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td width="80px" align="left">
                      <img src="{$gui_url}themes/images/pikachu.gif" alt="PikaChu"/>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
      
        <xsl:variable name="OpenInPFS_URL" select="Product/OpenInPFS_URL"/>
        <xsl:variable name="OpenInCCRUW_URL" select="Product/OpenInCCRUW_URL"/>
        <xsl:variable name="access-allowed" select="Product/OpenInPFS_URL or Product/OpenInCCRUW_URL"/>
        
        <xsl:choose>
          <xsl:when test="$access-allowed">
            <xsl:element name="table">
              <xsl:element name="tr">
                <xsl:element name="td">
                  <xsl:attribute name="colspan" select="4"/>
                        
                  <xsl:if test="$OpenInPFS_URL">
                    <xsl:element name="a">
                      <xsl:attribute name="href">
                        <xsl:value-of select="$OpenInPFS_URL"/>
                      </xsl:attribute>
                      <xsl:element name="b">
                        <xsl:value-of select="concat('Open product ', $ctn,  ' in PFS')"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:if>    
                </xsl:element>
              </xsl:element>
              <xsl:for-each select="//ContentDetail[ContentType = 'Ref' or ContentType = 'Text'][StatusAlert/UrgencyRank >= 1][UploadURL != '']">
                <xsl:element name="tr">
                  <xsl:element name="td">
                    <xsl:attribute name="bgcolor" select="StatusAlert/Urgency"/>
                  </xsl:element>
                  <xsl:element name="td">
                    <xsl:element name="a">
                       <xsl:attribute name="href">
                         <xsl:value-of select="UploadURL"/>
                      </xsl:attribute>
                      <xsl:value-of select="Description"/>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="td">
                    <xsl:value-of select="Language"/>
                  </xsl:element>
                  <xsl:element name="td">
                    <xsl:value-of select="StatusAlert/Description"/>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
              <xsl:element name="tr">
                <xsl:element name="td">
                  <xsl:attribute name="colspan" select="4"/>
                
                  <xsl:if test="$OpenInCCRUW_URL">
                    <xsl:element name="a">
                       <xsl:attribute name="href">
                         <xsl:value-of select="$OpenInCCRUW_URL"/>
                      </xsl:attribute>
                      <xsl:element name="b">
                        <xsl:value-of select="concat('Open CCR Upload wizard for product ', $ctn)"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:if>    
                </xsl:element>
              </xsl:element>
              <xsl:for-each select="//ContentDetail[ContentType != 'Ref' and ContentType != 'Text'][StatusAlert/UrgencyRank >= 1][UploadURL != '']">
                <xsl:element name="tr">
                  <xsl:element name="td">
                    <xsl:attribute name="bgcolor" select="StatusAlert/Urgency"/>
                    <xsl:attribute name="width" select="'14px'"/>
                  </xsl:element>
                  <xsl:element name="td">
                    <xsl:element name="a">
                       <xsl:attribute name="href">
                         <xsl:value-of select="UploadURL"/>
                      </xsl:attribute>
                      <xsl:value-of select="Description"/>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="td">
                    <xsl:value-of select="Language"/>
                  </xsl:element>
                  <xsl:element name="td">
                    <xsl:value-of select="StatusAlert/Description"/>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="table">
              <xsl:element name="tr">
                <xsl:element name="td">
		            <xsl:text>Sorry, you do not have sufficient rights to access PFS and/or CCR</xsl:text><br/>
		            <xsl:text>Please contact </xsl:text>
		            <a href="mailto:CMST@philips.com?subject=Request authorization for {$userID}">CMST</a>
		        </xsl:element>
		      </xsl:element>
		    </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="link">
    <xsl:param name="type" select="'text/css'"/>
    <xsl:param name="rel" select="'STYLESHEET'"/>
    <xsl:param name="href"/>
    
    <xsl:element name="link">
      <xsl:attribute name="type">
        <xsl:value-of select="$type"/>
      </xsl:attribute>
      <xsl:attribute name="rel">
        <xsl:value-of select="$rel"/>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="$href"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>