<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="source sql">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"/>   
  <!-- $catalogfilename will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->
  <xsl:param name="filename"/>
  <xsl:param name="ct"/>
  <xsl:param name="initialtableload">true</xsl:param>
  <xsl:variable name="now" select="if($initialtableload='false') then substring(xs:string(current-dateTime()),1,19) else '1900-01-01T00:00:00'"/> 
  <!-- -->
  <xsl:template match="/Products">
	  <xsl:apply-templates  select="Product"/>
  </xsl:template>  
  <!-- -->  
  <xsl:template match="Product">
      <!-- Insert a row into OCTL_TRANSLATIONS for each OCTL in the the file -->
      <xsl:variable name="v_entries" select="ancestor::Products"/>
      <xsl:variable name="v_entry" select="."/>    
      <xsl:variable name="v_category">
        <xsl:choose>
          <xsl:when test="$ct='PMT_Translated'"><xsl:value-of select="$v_entries/@category"/></xsl:when>
          <xsl:when test="$ct='Categorization_Translated'">Default</xsl:when>
          <xsl:when test="$ct='PText_Translated'">Default</xsl:when>
          <xsl:otherwise><xsl:value-of select="$v_entries/@category"/></xsl:otherwise>          
        </xsl:choose>     
      </xsl:variable>        
      <xsl:variable name="v_routingCode">
        <xsl:choose>
          <xsl:when test="$ct='PMT_Translated'"><xsl:value-of select="$v_entries/@routingCode"/></xsl:when>
          <xsl:when test="$ct='Categorization_Translated'">Default</xsl:when>
          <xsl:when test="$ct='PText_Translated'">Default</xsl:when>
          <xsl:otherwise><xsl:value-of select="$v_entries/@routingCode"/></xsl:otherwise>
        </xsl:choose>     
      </xsl:variable>      
      
      <xsl:for-each select="tokenize(@StoreLocales,',')">
        <sql:execute-query>
          <sql:query>
            insert into octl_translations ( content_type
                                          , localisation
                                          , object_id
                                          , masterlastmodified_ts
                                          , lastmodified_ts
                                          , filename                                        
                                          , doctimestamp                                        
                                          , targetlocale
                                          , storelocales
                                          , category                                        
                                          , routing_code
                                          , workflow
                                          , priority
                                          , fileobjectcount
                                          , import_ts) 
                                    
            values (  '<xsl:value-of select="$ct"/>'
                    , '<xsl:value-of select="."/>'
                    , '<xsl:value-of select="$v_entry/CTN"/>'
                    , to_date('<xsl:value-of select="$v_entry/@masterLastModified"/>','YYYY-MM-DD"T"HH24:MI:SS')
                    , to_date('<xsl:value-of select="$v_entry/@lastModified"/>','YYYY-MM-DD"T"HH24:MI:SS')
                    , '<xsl:value-of select="$filename"/>'
                    , to_date('<xsl:value-of select="$v_entries/@docTimeStamp"/>','YYYYMMDD"T"HH24MISS')
                    , '<xsl:value-of select="$v_entries/@targetLocale"/>'
                    , '<xsl:value-of select="$v_entry/@StoreLocales"/>'
                    <!--
                    , '<xsl:value-of select="$v_entries/@category"/>'                                    
                    , '<xsl:value-of select="$v_entries/@routingCode"/>'
                    -->
                    , '<xsl:value-of select="$v_category"/>'                                    
                    , '<xsl:value-of select="$v_routingCode"/>'                  
                    , '<xsl:value-of select="$v_entries/@workflow"/>'
                    , '<xsl:value-of select="$v_entries/@priority"/>'
                    , '<xsl:value-of select="count($v_entries/Product)"/>'
                    , null)
            </sql:query>
        </sql:execute-query>      
      </xsl:for-each>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
