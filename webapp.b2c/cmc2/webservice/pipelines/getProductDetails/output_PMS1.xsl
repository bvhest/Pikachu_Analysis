<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:inc="http://apache.org/cocoon/include/1.0"
                xmlns:pf="http://tempuri.org/"
                exclude-result-prefixes="sql"
                >
  <xsl:import href="output.xsl"/>
                  
  <xsl:template name="Countries">
    <xsl:param name="product"/>
    <xsl:param name="data"/>
    
    <xsl:element name="Countries">
      <xsl:attribute name="columnID" select="'PCY'"/>
      
      <xsl:call-template name="StatusAlertCC">
        <xsl:with-param name="alert" select="$product[sql:columnid = 'PCY']"/>
        <xsl:with-param name="publication-status" select="if ($product[sql:columnid = 'PCY']/sql:publication_status) 
                                                          then ($product[sql:columnid = 'PCY']/sql:publication_status)
                                                          else ('None')"/>
      </xsl:call-template>
      
      <xsl:call-template name="PublicationStatus">
        <xsl:with-param name="publication-status" select="if ($product[sql:columnid = 'PCY']/sql:publication_status) 
                                                          then ($product[sql:columnid = 'PCY']/sql:publication_status)
                                                          else ('None')"/>
      </xsl:call-template>
      
      <xsl:for-each select="$configfile/Config/RefLists/Countries/Country">
        <xsl:if test="$product[sql:columnid = current()/@id]"><!-- country exists as pms_alert -->    
          <xsl:element name="Country">
            <xsl:attribute name="countryID" select="@id"/>
            <xsl:attribute name="seq" select="@seq"/>
            
            <xsl:variable name="country" select="@id"/>
            
            <xsl:call-template name="StatusAlertMoon">
              <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
              <xsl:with-param name="moon-alert" select="$product[sql:columnid = concat(current()/@id, '_Moon')]"/>
              <xsl:with-param name="alert-description" select="$product[sql:columnid = current()/@id]"/>
            </xsl:call-template>
    
            <xsl:call-template name="Catalogs">
              <xsl:with-param name="product" select="$product"/>
              <xsl:with-param name="country" select="$country"/>
              <xsl:with-param name="data" select="$data"/>
            </xsl:call-template>
              
            <xsl:if test="$data">
              <xsl:call-template name="Locales">
                <xsl:with-param name="product" select="$product"/>
                <xsl:with-param name="country" select="$data/Countries/Country[@countryID = current()/@id]"/>
                <xsl:with-param name="locales" select="$configfile/Config/RefLists/Locales"/>
              </xsl:call-template> 
            </xsl:if>
          </xsl:element>
        </xsl:if>    
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="Locales">
    <xsl:param name="product"/>
    <xsl:param name="country"/>
    <xsl:param name="locales"/>
    
    <xsl:if test="$country/Locales">
      <xsl:element name="Locales">
        <xsl:for-each select="$country/Locales/Locale">
          <xsl:element name="Locale">
            <xsl:attribute name="LocaleID" select="@LocaleID"/>
            <xsl:attribute name="seq" select="$locales/Locale[@id = current()/@LocaleID]/@seq"/>
            
            <xsl:apply-templates select="LastTranslation"/>
            <xsl:apply-templates select="LeafletURL"/>
            
            <xsl:variable name="pendingTranslations" select="current()/PendingTranslations"/>
            
            <xsl:if test="$product[starts-with(sql:columnid, current()/@LocaleID)]">
              <xsl:element name="PendingTranslations">
                <xsl:for-each select="$product[starts-with(sql:columnid, current()/@LocaleID)]">
                  <xsl:element name="PendingTranslation">
                    <xsl:call-template name="Moon">
                      <xsl:with-param name="moon" select="$product[sql:columnid = current()/sql:columnid]"/>
                    </xsl:call-template>
                
                    <xsl:apply-templates select="$pendingTranslations/PendingTranslation[@columnID = current()/sql:columnid][last()]/PMTVersion"/>
                    <xsl:apply-templates select="$pendingTranslations/PendingTranslation[@columnID = current()/sql:columnid][last()]/LastModifiedDate"/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>