﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:email="http://apache.org/cocoon/transformation/sendmail" xmlns:dir="http://apache.org/cocoon/directory/2.0">
<xsl:preserve-space elements="*"/>
        <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
        <xsl:param name="timestamp"/>
        <xsl:param name="sender"/>
        <xsl:param name="server"/>        
        <xsl:param name="recipient"/>
        <!-- -->
        <xsl:template match="/dir:directory">
          <xsl:call-template name="generateErrorsMail"/>
        </xsl:template>
        
        <!--xsl:template match="//dir:file"-->
        <xsl:template name="generateErrorsMail">
        <xsl:if test="dir:file/dir:xpath/entries/entry">
                <document>
                    <email:sendmail>
                        <email:from><xsl:value-of select="$sender"/></email:from>
                        <email:to><xsl:value-of select="$recipient"/></email:to>
           <email:subject><xsl:value-of select="concat('ERROR: Translation Import Errors (instance:',substring-before(substring-after($server,'http://'),':'),') - autogenerated email sent by Pika Chu')"/></email:subject>                        
                                <email:body mime-type="text/plain">                                
The following length errors were encountered during Translation Import processing:
<xsl:for-each select="dir:file[dir:xpath/entries/entry]">
       Source file: <xsl:value-of select="dir:xpath/entries/originalentriesattributes/filename"/>
         Temp file: <xsl:value-of select="@name"/>
  <xsl:text> 
</xsl:text>
  <xsl:for-each select="dir:xpath/entries/entry[result/error]">
               CTN: <xsl:value-of select="@o"/>
    <xsl:for-each select="result/error">
      Element name: <xsl:value-of select="child::node()/name()"/>
     Element value: <xsl:value-of select="child::node()/text()"/>
        Max length: <xsl:value-of select="@maxLength"/>
     Actual length: <xsl:value-of select="@actualLength"/>
       <xsl:text> 
</xsl:text>
    </xsl:for-each>         
  </xsl:for-each>  
<xsl:text>----------</xsl:text>  
</xsl:for-each>
</email:body>
        </email:sendmail>
      </document>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
