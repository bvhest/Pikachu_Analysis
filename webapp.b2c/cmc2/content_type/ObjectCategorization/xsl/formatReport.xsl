<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >

<xsl:param name="ts"/>
<xsl:param name="ct"/>
  
  	<xsl:template match="@*|node()" >
			<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
  
  <xsl:template match="/">
  <root>
		  <report>
			 <entries ct="{$ct}" ts ="{$ts}">
			  <xsl:apply-templates/>
			</entries>
		</report>
	</root>
  </xsl:template>  
  
  <xsl:template match="sql:row">
  <entry ct="{$ct}" o="{sql:object_id}" l="none" valid="true">
	  <result>OK</result>
  </entry>
   </xsl:template>
   
  <xsl:template match="merge-report">
  <entry ct="{$ct}" o="MergeResult" l="none" valid="true">
	  <xsl:choose>
			<xsl:when test="root/error-message"><sql-error><xsl:value-of select="root/error-message"/></sql-error></xsl:when>
			<xsl:otherwise><result>OK</result></xsl:otherwise>
		</xsl:choose>
  </entry>

  </xsl:template>
</xsl:stylesheet>