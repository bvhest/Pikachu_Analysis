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
   <xsl:param name="ctn" />
   <xsl:param name="locale" />

   <!-- Override service-base -->
   <xsl:template match="/">
      <xsl:choose>
         <!-- Warning condition -->
         <xsl:when test="empty(sql:rowset/sql:row/sql:pmtmaster/Product) or empty(sql:rowset/sql:row/sql:pmttrltd/Product)">
           <xsl:element name="Result">
               <xsl:attribute name="service" select="'getPMTMasterAndTranslatedData'"/>
               <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
               <xsl:attribute name="DocVersion" select="em:getVersion($schema)"/>
               <xsl:attribute name="NrOfProductsInThisResult" select="count(sql:row/Product)"/>
               <xsl:element name="CallParameters">
                  <xsl:call-template name="CallParameters"/>
               </xsl:element>
               <xsl:element name="Products">
                  <!-- Warning condition -->
                  <xsl:choose>
                  <xsl:when test="(sql:rowset/sql:row/sql:pmtmaster_warning) and (sql:rowset/sql:row/sql:pmttrltd_warning)">
                  <!-- Checks if both master and localized content has valid data -->             
                      <xsl:element name="warning">
                          <xsl:element name="description">PMT_Master and PMT_Translated are not same versions.</xsl:element>
                      </xsl:element>                      
                      <xsl:copy-of select="sql:rowset/sql:row/sql:pmtmaster_warning/Product"/>
                      <xsl:copy-of select="sql:rowset/sql:row/sql:pmttrltd_warning/Product"/>
                  </xsl:when>
                  <xsl:otherwise>
                  <!-- Error condition for invalid data -->       
                      <xsl:element name="error">
                           <xsl:element name="description"> There is no data available for the CTN and locale combination. Please try with another CTN.</xsl:element>
                      </xsl:element>
                      <xsl:copy-of select="sql:rowset/sql:row/sql:pmtmaster_error/Product"/>
                      <xsl:copy-of select="sql:rowset/sql:row/sql:pmttrltd_error/Product"/>
                  </xsl:otherwise>                  
                  </xsl:choose>
               </xsl:element>              
             </xsl:element>
         </xsl:when>
         <!-- Valid condition -->
         <xsl:when test="(sql:rowset/sql:row/sql:pmtmaster/Product) and (sql:rowset/sql:row/sql:pmttrltd/Product)">
             <xsl:element name="Result">
               <xsl:attribute name="service" select="'getPMTMasterAndTranslatedData'"/>
               <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
               <xsl:attribute name="DocVersion" select="em:getVersion($schema)"/>
               <xsl:attribute name="NrOfProductsInThisResult" select="count(sql:row/Product)"/>
               <xsl:element name="CallParameters">
                  <xsl:call-template name="CallParameters"/>
               </xsl:element>
               <xsl:element name="Products">
                      <xsl:copy-of select="sql:rowset/sql:row/sql:pmtmaster/Product"/>
                      <xsl:copy-of select="sql:rowset/sql:row/sql:pmttrltd/Product"/>                 
               </xsl:element>              
             </xsl:element>             
         </xsl:when>
         <!-- Database Error condition -->
         <xsl:when test="sql:rowset/sql:error">
           <xsl:element name="Result">
               <xsl:attribute name="service" select="'getPMTMasterAndTranslatedData'"/>
               <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
               <xsl:attribute name="DocVersion" select="em:getVersion($schema)"/>
               <xsl:attribute name="NrOfProductsInThisResult" select="count(sql:row/Product)"/>
               <xsl:element name="CallParameters">
                  <xsl:call-template name="CallParameters"/>
               </xsl:element>
               <xsl:element name="Products">
                   <xsl:element name="error">
                      <xsl:element name="description"><xsl:value-of select="sql:rowset/sql:error" /></xsl:element>
                    </xsl:element>
               </xsl:element>              
             </xsl:element>
         </xsl:when>
         <!-- Error condition for invalid data -->
         <xsl:otherwise>      
             <xsl:element name="Result">
               <xsl:attribute name="service" select="'getPMTMasterAndTranslatedData'"/>
               <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
               <xsl:attribute name="DocVersion" select="em:getVersion($schema)"/>
               <xsl:attribute name="NrOfProductsInThisResult" select="count(sql:row/Product)"/>
                 <xsl:element name="CallParameters">
                    <xsl:call-template name="CallParameters"/>
                 </xsl:element>
               <xsl:element name="Products">   
                  <xsl:element name="error">
                      <xsl:element name="description"> There is no data available for the CTN and locale combination. Please try with another CTN.</xsl:element>
                 </xsl:element> 
              </xsl:element>
            </xsl:element>            
         </xsl:otherwise>          
      </xsl:choose>
   </xsl:template>
   

  <xsl:template name="CallParameters">
      <xsl:element name="UserID">
         <xsl:value-of select="$userID"/>
      </xsl:element>
      <xsl:element name="ctn">
         <xsl:value-of select="$ctn"/>
      </xsl:element>
      <xsl:element name="Locale">
         <xsl:value-of select="$locale"/>
      </xsl:element>
  </xsl:template>

</xsl:stylesheet>