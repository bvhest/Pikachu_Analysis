<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:pf="http://tempuri.org/"
                exclude-result-prefixes="sql"
                >
  <xsl:import href="../em-product-templates.xsl"/>

  <xsl:param name="pmt-preview-url"/>
  <xsl:param name="relative-url-prefix"/>
                  
  <xsl:param name="userID" select="''"/>
  <xsl:param name="ctnRestriction" select="''"/>

  <xsl:param name="schema"/>
  
  <xsl:variable name="sortedCountries" select="distinct-values(root/products/sql:rowset/sql:row/sql:columnid)"/>
  
  <xsl:template match="root">
    <xsl:element name="Products">
      <xsl:attribute name="DocTimeStamp" select="em:formatDate(current-dateTime())"/>
      <xsl:attribute name="DocStatus" select="'draft'"/>
      <xsl:attribute name="DocType" select="'ListOverview'"/>
      <xsl:attribute name="DocVersion" select="em:getVersion($schema)"/>
      <xsl:attribute name="NrOfProductsInThisResult" select="count(distinct-values(products/sql:rowset/sql:row/sql:ctn))"/>
      <xsl:attribute name="NrOfProductsTotal" select="products/count/sql:rowset/sql:row/sql:count"/>
      <xsl:attribute name="xsi:noNamespaceSchemaLocation" select="em:getSchema($schema)"/>
      
      <xsl:element name="CallParameters">
        <xsl:call-template name="CallParameters">
          <xsl:with-param name="userID" select="$userID"/>
          <xsl:with-param name="ctnRestriction" select="$ctnRestriction"/>
        </xsl:call-template>
      </xsl:element>
      
      <xsl:call-template name="CountryColumns"/>
      
      <xsl:choose>
        <xsl:when test="products/sql:rowset">
          <xsl:for-each-group select="products/sql:rowset/sql:row" group-by="sql:ctn">
    
            <xsl:element name="Product">
              <xsl:attribute name="columnID" select="'PUR'"/>
              <xsl:attribute name="lastModified" select="em:formatDate(current()/sql:lastmodified_ts)"/>
            <xsl:attribute name="lastPublished" select="em:formatDate(current()/sql:master_date)"/>
            <xsl:attribute name="seq" select="position()"/>
                 
              <xsl:call-template name="StatusAlertProduct">
                <xsl:with-param name="alert" select="current-group()[sql:columnid = 'PUR']"/>
              </xsl:call-template>
              
              <xsl:call-template name="MasterData"/>
              
              <xsl:call-template name="Categorization">
                <xsl:with-param name="product" select="current-group()[sql:columnid = 'PUR']"/>
              </xsl:call-template>
              
              <xsl:call-template name="ThumbnailURL">
                <xsl:with-param name="url" select="sql:thumbnailurl"/>
              </xsl:call-template>
              
              <xsl:call-template name="MediumImageURL">
                <xsl:with-param name="url" select="sql:mediumimageurl"/>
              </xsl:call-template>  
                
              <xsl:element name="PreviewURL">
                 <xsl:value-of select="concat(substring-before($pmt-preview-url, '/cmc2'), '/cmc2', substring-after(sql:previewurl, '/cmc2'))"/>
              </xsl:element>
              
              <xsl:element name="Content">
                <xsl:attribute name="columnID" select="'PCU'"/>
      
                <xsl:call-template name="StatusAlert">
                  <xsl:with-param name="alert" select="current-group()[sql:columnid = 'PCU']"/>
                </xsl:call-template>
                
                <xsl:call-template name="ContentCategories">
                  <xsl:with-param name="product" select="current-group()"/>
                </xsl:call-template>
              </xsl:element>
              
              <xsl:call-template name="Countries">
                <xsl:with-param name="product" select="current-group()"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="products/Results"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="CallParameters">
    <xsl:param name="userID" select="''"/>
    <xsl:param name="ctnRestriction" select="''"/>
    
    <xsl:element name="userID">
      <xsl:value-of select="$userID"/>
    </xsl:element>
    <xsl:element name="ctnRestriction">
      <xsl:for-each select="tokenize($ctnRestriction, ',')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="ProductOwner">
    <xsl:param name="data"/>
    <xsl:variable name="product-owners" select="/root/products/accounts"/>
    
    <xsl:element name="ProductOwner">
      <xsl:attribute name="columnID" select="'POW'"/>
      <xsl:attribute name="accountID" select="sql:owner"/>
      
      <xsl:value-of select="$product-owners/account[@accountID = current()/sql:owner]/pf:GetDetailsResult/pf:FullName"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="CountryColumns">
    <xsl:element name="CountryColumns">
      <xsl:for-each select="$sortedCountries">
        <xsl:if test="$configfile/Config/RefLists/Countries/Country[@id=current()]/@seq != ''">
          <xsl:element name="CountryColumn">
            <xsl:attribute name="countryID" select="current()"/>
            <xsl:attribute name="seq" select="$configfile/Config/RefLists/Countries/Country[@id=current()]/@seq"/>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
    
    <xsl:element name="CountryColumnsChannels">
      <xsl:for-each select="$sortedCountries">
        <xsl:if test="$configfile/Config/Views/Countries/Column[@id=current()]/@type = 'countryCatalog'">
          <xsl:element name="CountryColumn">
            <xsl:attribute name="channelID" select="substring-after(current(), '.')"/>
            <xsl:attribute name="countryID" select="$configfile/Config/Views/Countries/Column[@id=current()]/@country"/>
            <xsl:attribute name="seq" select="$configfile/Config/RefLists/Countries/Country[@id=$configfile/Config/Views/Countries/Column[@id=current()]/@country]/@seq"/>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

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
              </xsl:call-template> 
            </xsl:if>
          </xsl:element>
        </xsl:if>    
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>