<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                >
   <!-- -->
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   <xsl:import href="../service-base.xsl"/>
   <xsl:import href="../em-product-templates.xsl"/>
   <!-- -->
   <xsl:param name="userID" select="''"/>
   <xsl:param name="schema" select="''"/>
   <xsl:param name="ctn" select="''"/>
   <xsl:param name="locale" select="''"/>
   <xsl:param name="group" select="''"/>
   <xsl:param name="category" select="''"/>
   <xsl:param name="subcat" select="''"/>
   <xsl:param name="sop" select="''"/>
   <xsl:param name="eop" select="''"/>
   
   <!-- Override service-base -->
   <xsl:template match="/">
      <xsl:apply-templates select="*"/>
   </xsl:template>

   <xsl:template match="sql:rowset">
      <xsl:element name="Result">
         <xsl:attribute name="service" select="'getActiveProductPerLocale'"/>
         <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
         <xsl:attribute name="DocVersion" select="em:getVersion($schema)"/>
         <xsl:attribute name="NrOfProductsInThisResult" select="count(sql:row/sql:ctn)"/>

         <xsl:element name="CallParameters">
            <xsl:call-template name="CallParameters">
               <xsl:with-param name="userID" select="$userID"/>
               <xsl:with-param name="locale" select="$locale"/>
            </xsl:call-template>
         </xsl:element>
         <!-- Override service-base -->
         <xsl:element name="Products">
            <xsl:choose>
               <xsl:when test="sql:error">
                  <error>
                     <description><xsl:value-of select="sql:error" /></description>
                  </error>
               </xsl:when>
               <xsl:when test="empty(sql:row/sql:ctn)">
                  <error>
                     <description>There are no CTNs available for the locale which you passed. Please try with other conditions.</description>
                  </error>
               </xsl:when>
               <xsl:otherwise>         
                  <xsl:apply-templates select="sql:row"/> 
               </xsl:otherwise>
            </xsl:choose>
         </xsl:element>
      </xsl:element>
   </xsl:template>

   <xsl:template match="sql:row">
      <xsl:element name="Product"> 
         <xsl:apply-templates />   
      </xsl:element>
   </xsl:template>

   <xsl:template match="sql:ctn">
      <xsl:element name="CTN"> 
         <xsl:value-of select="." />   
      </xsl:element>
   </xsl:template>
   <xsl:template match="sql:localisation">
      <xsl:element name="Locale"> 
         <xsl:value-of select="." />   
      </xsl:element>
   </xsl:template>
   <xsl:template match="sql:sop">
      <xsl:element name="Sop"> 
         <xsl:value-of select="." />   
      </xsl:element>
   </xsl:template>
   <xsl:template match="sql:eop">
      <xsl:element name="Eop"> 
         <xsl:value-of select="." />   
      </xsl:element>
   </xsl:template>
   <xsl:template match="sql:lastmodified_ts">
      <xsl:element name="Lastmodified_ts"> 
         <xsl:value-of select="." />   
      </xsl:element>
   </xsl:template>
   <xsl:template match="sql:group">
      <xsl:element name="Group"> 
         <xsl:value-of select="." />   
      </xsl:element>
   </xsl:template>
   <xsl:template match="sql:category">
      <xsl:element name="Category"> 
         <xsl:value-of select="." />   
      </xsl:element>
   </xsl:template>
   <xsl:template match="sql:subcategory">
      <xsl:element name="Subcategory"> 
         <xsl:value-of select="." />   
      </xsl:element>
   </xsl:template>

   <xsl:template name="CallParameters">
      <xsl:element name="userid">
         <xsl:value-of select="$userID"/>
      </xsl:element>
      <xsl:element name="ctn">
         <xsl:value-of select="$ctn"/>
      </xsl:element>
      <xsl:element name="locale">
         <xsl:value-of select="$locale"/>
      </xsl:element>
      <xsl:element name="group">
         <xsl:value-of select="$group"/>
      </xsl:element>
      <xsl:element name="category">
         <xsl:value-of select="$category"/>
      </xsl:element>
      <xsl:element name="subcat">
         <xsl:value-of select="$subcat"/>
      </xsl:element>  
      <xsl:element name="sop">
         <xsl:value-of select="$sop"/>
      </xsl:element>
      <xsl:element name="eop">
         <xsl:value-of select="$eop"/>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>