<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:variable name="channel_id" select="/h:request/h:requestParameters/h:parameter[@name='channel']/h:value"/>'
  <xsl:variable name="catalogs"><catalogs><xsl:copy-of select="/h:request/h:requestParameters/h:parameter[starts-with(@name,'select')]"/></catalogs></xsl:variable>

  <xsl:template match="/h:request/h:requestParameters">
    <root>
      <xsl:attribute name="channel"><xsl:value-of select="h:parameter[@name='name']/h:value"/></xsl:attribute>      
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="delete channels">
          delete from CHANNEL_CATALOGS
          where customer_id = '<xsl:value-of select="h:parameter[@name='channel']/h:value"/>' 
        </sql:query>
      </sql:execute-query>      
      <xsl:apply-templates/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="h:parameter[@name='locale']/h:value[. != '']">
    <xsl:variable name="locale" select="."/>
    <xsl:for-each-group select="$catalogs/catalogs/h:parameter[starts-with(@name,'select_')][h:value = $locale ]" group-by="substring-after(@name,'__')">
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="{$locale}">
          INSERT INTO CHANNEL_CATALOGS ( CUSTOMER_ID
                                        ,LOCALE
                                        ,CATALOG_TYPE
                                        ,DIVISION
                                        ,ENABLED
                                        ,LOCALEENABLED                                        
                                        ,MASTERLOCALEENABLED)
          VALUES   (  '<xsl:value-of select="$channel_id"/>'
                     ,'<xsl:value-of select="$locale"/>'
                     ,'<xsl:value-of select="substring-after(current-grouping-key(),'--')"/>'
                     ,'<xsl:value-of select="substring-before(current-grouping-key(),'--')"/>'
                     , 1
                     , <xsl:choose>
                         <xsl:when test="$catalogs/catalogs/h:parameter[@name = concat('select_LOCALE__',current-grouping-key())]/h:value[. = $locale]">1</xsl:when>
                         <xsl:otherwise>0</xsl:otherwise>
                       </xsl:choose>
                     , <xsl:choose>
                         <xsl:when test="$catalogs/catalogs/h:parameter[@name = concat('select_MASTERLOCALE__',current-grouping-key())]/h:value[. = $locale]">1</xsl:when>
                         <xsl:otherwise>0</xsl:otherwise>
                       </xsl:choose>                       
                    )
        </sql:query>
      </sql:execute-query>    
    </xsl:for-each-group>
  </xsl:template>
  <!-- -->
  <xsl:template match="h:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>