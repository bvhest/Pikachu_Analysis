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
        <xsl:apply-templates select="ProductReferences"/>
    </xsl:template>
    <xsl:template match="ProductReferences">
        <xsl:variable name="current-timestamp" select="replace(@DocTimeStamp,'[^0-9]','')"/>
        <xsl:variable name="filename" select="concat('ProductReferences_',$current-timestamp)"/>
        <xsl:variable name="referenceType" select="@referenceType"/>
        <xsl:variable name="subjectName" select="if ($referenceType = 'Accessories') then 'Accessory' else 'Variation' "/>
        <xsl:variable name="objectName" select="if ($referenceType = 'Accessories') then 'Performer' else 'Variation' "/>
        
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
                                        href="{concat($gui_url,$section_url,'productReference_import_go?doctimestamp=',$current-timestamp,'&amp;filename=',$filename)}">
                                            <span style="color: green; font-family: Arial; font-size: 150%;">&#x25BA;</span> Import</a>
                    &#160;&#160;
                    <a style="height: 30px; font-size: 120%; color: #000; text-decoration: none; vertical-align: center; border: 1px solid #888; border-right-width: 2px; border-bottom-width: 2px; background-color: #ccc; padding: 2px 5px;" href="{concat($gui_url,$section_url,'productReference_import_cancel')}">
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
                            <table style="border-collapse: collapse; width: 100%">
                            
                                <xsl:for-each select="ProductReference">                         
                                    <tr>
                                        <td colspan="4" style="font-size: 100%; font-weight: bold; background-color: #ffa; border: 1px solid #aaa">
                   <xsl:value-of select="$referenceType"/> Association
                                        </td>
                                    </tr>
                                        <tr>
                                            <td colspan="5">
                                                <table width="100%">
                                                    <tr>
                                                        <td colspan="20"><xsl:attribute name="style">background-color: #CFF</xsl:attribute>
                                                            <p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px; border: 1px solid #aaa"><xsl:value-of select="concat($subjectName,' Type=',Subject/@type)"/></p>
                                                        </td>
                                                         <td colspan="20"><xsl:attribute name="style">background-color: #CFF</xsl:attribute>
                                                            <p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px; border: 1px solid #aaa"><xsl:value-of select="concat($subjectName,' ID=',Subject)"/></p>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="5">
                                                <table width="100%">
                                                    <tr>
                                                        <td colspan="20"><xsl:attribute name="style">background-color: #EEE</xsl:attribute>
                                                            <p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px; border: 1px solid #aaa"><xsl:value-of select="concat($objectName,' Type=',Object/@type)"/></p>
                                                        </td>
                                                        <td>
                                                            <p style="font-size: 100%; font-weight: bold; margin-top: 0px; margin-bottom: 0px; border: 1px solid #aaa"><xsl:value-of select="concat($objectName,' ID=',Object)"/></p>
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
