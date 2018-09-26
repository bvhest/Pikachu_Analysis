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
  <xsl:param name="authorizationRestriction" select="''"/>
  <xsl:param name="catalogTypeRestriction" select="''"/>
  <xsl:param name="productCatRestriction" select="''"/>
  <xsl:param name="requiringAttentionRestriction" select="''"/>
  <xsl:param name="ctnRestriction" select="''"/>
  <xsl:param name="query" select="''"/>
  <xsl:param name="sortBy" select="'CTN|true'"/>
  <xsl:param name="recordFrom" select="'1'"/>
  <xsl:param name="maxResults" select="'20'"/>

  <xsl:param name="schema"/>
  
  <xsl:variable name="column" select="substring-before($sortBy, '|')"/>
  <xsl:variable name="order" select="substring-after($sortBy, '|')"/>

  <xsl:variable name="sort-column" select="concat('sql:', em:determineColumn($column))"/>

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
          <xsl:with-param name="authorizationRestriction" select="$authorizationRestriction"/>
          <xsl:with-param name="productCatRestriction" select="$productCatRestriction"/>
          <xsl:with-param name="requiringAttentionRestriction" select="$requiringAttentionRestriction"/>
          <xsl:with-param name="ctnRestriction" select="$ctnRestriction"/>
          <xsl:with-param name="query" select="$query"/>
          <xsl:with-param name="sortBy" select="$sortBy"/>
          <xsl:with-param name="recordFrom" select="$recordFrom"/>
          <xsl:with-param name="maxResults" select="$maxResults"/>
        </xsl:call-template>
      </xsl:element>
      
      <xsl:choose>
        <xsl:when test="products/sql:rowset">
          <xsl:for-each-group select="products/sql:rowset/sql:row" group-by="sql:ctn">
            <xsl:sort select="if ($sort-column = 'sql:ctn') 
                              then (current()/sql:ctn) else 
                              (
                                if ($sort-column = 'sql:namingstringshort')
                                then (current()/sql:namingstringshort)
                                else
                                (
                                  if ($sort-column = 'sql:cr_date')
                                  then (current()/sql:cr_date)
                                  else
                                  (
                                    if ($sort-column = 'sql:thumbnailurl')
                                    then (current()/sql:thumbnailurl)
                                    else
                                    (
                                      if ($sort-column = 'sql:marketingclass')
                                      then (current()/sql:sortmcl)
                                      else
                                      (
                                        if ($sort-column = 'sql:owner')
                                    then (current()/sql:owner)
                                    else
                                    (
                                      number(current-group()[sql:columnid = $column]/sql:sort_order)
                                    )
                                      )
                                    )
                                  )
                                )
                              )" 
                      order="{if ($order = 'true') then ('ascending') else ('descending')}"/>
                      
            <xsl:sort select="current()/sql:ctn" 
                      order="{if ($order = 'true') then ('ascending') else ('descending')}"/>
    
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
    <xsl:param name="authorizationRestriction" select="''"/>
    <xsl:param name="catalogTypeRestriction" select="''"/>
    <xsl:param name="productCatRestriction" select="''"/>
    <xsl:param name="requiringAttentionRestriction" select="''"/>
    <xsl:param name="ctnRestriction" select="''"/>
    <xsl:param name="query" select="''"/>
    <xsl:param name="sortBy" select="''"/>
    <xsl:param name="recordFrom" select="'0'"/>
    <xsl:param name="maxResults" select="'20'"/>
    
    <xsl:variable name="field" select="substring-before($requiringAttentionRestriction, ',')"/>
    <xsl:variable name="range" select="substring-after($requiringAttentionRestriction, ',')"/>
    <xsl:variable name="fromInc" select="substring-before($range, ',')"/>
    <xsl:variable name="toInc" select="substring-after($range, ',')"/>
  
    <xsl:element name="userID">
      <xsl:value-of select="$userID"/>
    </xsl:element>
    <xsl:element name="authorizationRestriction">
      <xsl:value-of select="$authorizationRestriction"/>
    </xsl:element>
    <xsl:element name="productCatRestriction">
      <xsl:for-each select="tokenize($productCatRestriction, ',')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="requiringAttentionRestriction">
      <xsl:element name="field">
        <xsl:value-of select="$field"/>
      </xsl:element>
      <xsl:element name="fromInc">
        <xsl:value-of select="$fromInc"/>
      </xsl:element>
      <xsl:element name="toInc">
        <xsl:value-of select="$toInc"/>
      </xsl:element>
    </xsl:element>
    <xsl:element name="ctnRestriction">
      <xsl:for-each select="tokenize($ctnRestriction, ',')">
        <xsl:element name="item">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="query">
      <xsl:value-of select="$query"/>
    </xsl:element>
    <xsl:element name="sortBy">
      <xsl:element name="item">
        <xsl:element name="field">
          <xsl:value-of select="substring-before($sortBy, '|')"/>
        </xsl:element>
        <xsl:element name="asc">
          <xsl:value-of select="substring-after($sortBy, '|')"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
    <xsl:element name="recordFrom">
      <xsl:value-of select="$recordFrom"/>
    </xsl:element>
    <xsl:element name="maxResults">
      <xsl:value-of select="$maxResults"/>
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

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>