<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:info="http://www.philips.com/pikachu/3.0/info" exclude-result-prefixes="info">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:param name="gui_url"/>
    <xsl:param name="section"/>
    <xsl:variable name="section_url" select="if ($section ne '') then concat('section/',$section,'/') else ''"/>
    <xsl:template match="@*|node()">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="root">
        <xsl:apply-templates select="RichText_Raw|RichText"/>
    </xsl:template>
    <xsl:template match="RichText_Raw|RichText">
        <xsl:variable name="current-timestamp" select="replace(@DocTimeStamp,'[^0-9]','')"/>
        <xsl:variable name="filename" select="concat(local-name(),'_',$current-timestamp)"/>
        <xsl:variable name="ct" select="local-name()"/>
        <html>
            <head/>
            <body>
                <table style="background-color: #eee; border-color: #aaa; border-style: solid; border-top-width: 1px; border-left-width: 1px; border-bottom-width: 3px; border-right-width: 3px; border-collapse: separate; border-spacing: 10px;">
                    <tr>
                        <td colspan="4">
                            <table style="width: 100%">
                                <tr style="height: 40px;">
                                    <td style="vertical-align: bottom;">
                                        <h2 style="margin-top: 0px; margin-bottom: 0px;">The&#160;following&#160;information&#160;will&#160;be&#160;imported:</h2>
                                    </td>
                                    <!-- Ok and Cancel buttons -->
                                    <td style="text-align: right; vertical-align: bottom; padding: 4px 2px;">
                                        <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" 
                                        href="{concat($gui_url,$section_url,'richtext_raw_import_go?doctimestamp=',$current-timestamp,'&amp;filename=',$filename,'&amp;ct=',$ct)}">
                                            <span style="color: green; font-family: Arial; font-size: 150%;">&#x25BA;</span> Import</a>
                    &#160;&#160;
                    <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'richtext_raw_import_cancel')}">
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
                                        <xsl:value-of select="@DocTimeStamp"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="width: 100%; padding: 4px; vertical-align: top; background-color: #fff; border-color: #888; border-style: solid; border-top-width: 2px; border-left-width: 2px; border-bottom-width: 1px; border-right-width: 1px;">
                            <!--p style="font-size: 120%; font-weight: bold; margin-top: 0px; margin-bottom: 0px;">Product/RichTexts</p-->
                            <table style="border-collapse: collapse; width: 100%">
                                <xsl:for-each select="object">
                                    <tr>
                                        <td colspan="1" style="font-size: 100%; font-weight: bold; background-color: #ffa; border: 1px solid #aaa">
                    CTN:<xsl:value-of select="@object_id"/>
                                        </td>                    
                    <td colspan="3" style="font-size: 100%; font-weight: bold; background-color: #ffa; border: 1px solid #aaa">
                    Locales:<xsl:value-of select="@locales"/>
                                        </td>
                                    </tr>
                                    <xsl:for-each select="RichTexts/RichText">
                                        <tr>
                                            <td colspan="5">
                                                <table width="100%">
                                                    <tr>
                                                        <td colspan="20"><xsl:attribute name="style">background-color: #CFF</xsl:attribute>
                                                            <p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px; border: 1px solid #aaa">RichText: type="<xsl:value-of select="@type"/>"</p>
                                                        </td>
                                                    </tr>
                                                    <xsl:choose>
                                                    <xsl:when test=".//Item">
                                                    <tr><xsl:attribute name="style">background-color: #ddf</xsl:attribute>
                                                        <td width="4%" style="font-weight: bold; border: 1px solid #aaa">Item code</td>
                                                        <td width="10%" style="font-weight: bold; border: 1px solid #aaa">Item name</td>
                                                        <td width="3%" style="font-weight: bold; border: 1px solid #aaa">Item rank</td>
                                                        <td width="30%"  style="font-weight: bold; border: 1px solid #aaa">Head</td>                                                        
                                                        <td width="30%"  style="font-weight: bold; border: 1px solid #aaa">Body</td>
                                                        <td width="23%" style="font-weight: bold; border: 1px solid #aaa"><table  width="100%"><tr><td width="70%"  style="font-weight: bold; border: 0px solid #aaa">BulletItem<br/>Text</td><td width="30%"  style="font-weight: bold; border: 0px solid #aaa">BulletItem<br/>Rank</td></tr></table></td>
<!--
                                                        <td width="20%"  style="font-weight: bold; border: 1px solid #aaa">BulletItemText</td>                                                        
                                                        <td width="3%"  style="font-weight: bold; border: 1px solid #aaa">BulletItemRank</td>                                                         
-->                                                       
                                                    </tr>
                                                    <xsl:for-each select=".//Item">
                                                      <tr>
                                                        <td width="4%" ><xsl:value-of select="@code"/></td>
                                                        <td width="10%" ><xsl:value-of select="@referenceName"/></td>
                                                        <td width="3%" ><xsl:value-of select="@rank"/></td>
                                                        <td width="30%" ><xsl:value-of select="Head"/></td>                                                    
                                                        <td width="30%" ><xsl:value-of select="Body"/></td>                                                                                                        
<td width="23%"><table width="100%"><xsl:for-each select="BulletList/BulletItem"><tr><td width="70%"  style="font-weight: bold; border: 1px solid #aaa"><xsl:value-of select="Text"/></td><td width="30%"  style="font-weight: bold; border: 1px solid #aaa"><xsl:value-of select="@rank"/></td></tr></xsl:for-each></table></td>                                                    
                                                      </tr>                                                      
                                                    </xsl:for-each>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                      <tr><xsl:attribute name="style">background-color: #f00</xsl:attribute>
                                                        <td width="4%" style="font-weight: bold; border: 1px solid #aaa; font-color: #fff">This RichText type will be deleted</td>
                                                      </tr>
                                                    </xsl:otherwise>
                                                    </xsl:choose>
                                                </table>
                                            </td>
                                        </tr>
                                        <!--tr><td colspan="4"><p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px;">RichText: type="<xsl:value-of select="''"/>"</p></td></tr-->
                                    </xsl:for-each>
                                </xsl:for-each>
                            </table>
                        </td>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
