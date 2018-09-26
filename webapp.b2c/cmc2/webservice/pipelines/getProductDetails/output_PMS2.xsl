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
  <xsl:import href="../em-product-templates_pms2.xsl"/>
                  
  <xsl:template name="Product">
    <xsl:element name="Product">
        <xsl:attribute name="columnID" select="'PUR'"/>
        <xsl:attribute name="lastModified" select="em:formatDate(current()/sql:lastmodified_ts)"/> 
        <xsl:attribute name="lastPublished" select="em:formatDate(current()/sql:master_date)"/>
        <xsl:attribute name="seq" select="position()"/>
       
        <xsl:variable name="data" select="/root/octl/sql:rowset/sql:row[sql:object_id = current()/sql:ctn][sql:content_type='PMS']/sql:data/Product"/>
        <xsl:variable name="master-data" select="/root/octl/sql:rowset/sql:row[sql:object_id = current()/sql:ctn][sql:content_type='PMT_Master']/sql:data/Product"/>
        <xsl:variable name="localized-data" select="/root/octl/sql:rowset/sql:row[sql:object_id = current()/sql:ctn][sql:content_type='PMA']/sql:data/object/Awards"/>
        
        <xsl:call-template name="StatusAlertProduct">
          <xsl:with-param name="alert" select="current-group()[sql:columnid = 'PUR']"/>
        </xsl:call-template>
        
        <xsl:call-template name="MasterData">
          <xsl:with-param name="data" select="$data"/>
        </xsl:call-template>
        
        <xsl:call-template name="Categorization">
          <xsl:with-param name="product" select="current-group()[sql:columnid = 'PUR']"/>
        </xsl:call-template>
        
        <xsl:element name="ThumbnailURL">
          <xsl:value-of select="em:getRelativeImageURL(sql:thumbnailurl, $relative-url-prefix)"/>
        </xsl:element>
          
        <xsl:element name="MediumImageURL">  
          <xsl:value-of select="em:getRelativeImageURL(sql:mediumimageurl, $relative-url-prefix)"/>
        </xsl:element>
        
        <xsl:element name="PreviewURL">
           <xsl:value-of select="sql:previewurl"/>
        </xsl:element>
        
        <xsl:element name="Content">
          <xsl:attribute name="columnID" select="'PCU'"/>
          <xsl:call-template name="StatusAlert">
            <xsl:with-param name="alert" select="current-group()[sql:columnid = 'PCU']"/>
          </xsl:call-template>
          
          <xsl:call-template name="ContentCategories">
            <xsl:with-param name="product" select="current-group()"/>
            <xsl:with-param name="data" select="$data"/>
            <xsl:with-param name="master-data" select="$master-data"/>
            <xsl:with-param name="localized-data" select="$localized-data"/>
            <xsl:with-param name="userID" select="$userID"/>
          </xsl:call-template>
        </xsl:element>
        
        <xsl:apply-templates select="$data/OpenInPFS_URL"/>
            
        <xsl:apply-templates select="$data/OpenInCCRUW_URL"/>
    </xsl:element>
  </xsl:template>
  
  <!-- override to add email -->
  <xsl:template name="Publisher">
    <xsl:variable name="publishers" select="/root/octl/sql:rowset/sql:row[sql:content_type='PMS']/accounts"/>
    <xsl:variable name="accountID" select="Publisher/@accountID"/>
    
    <xsl:element name="Publisher">
      <xsl:attribute name="accountID" select="$accountID"/>
      <xsl:attribute name="email" select="$publishers/account[@accountID = $accountID]/pf:GetDetailsResult/pf:Email"/>
      
      <xsl:value-of select="$publishers/account[@accountID = $accountID]/pf:GetDetailsResult/pf:FullName"/>
    </xsl:element>
  </xsl:template> 
   
  <!-- override to add email -->
  <xsl:template name="ProductOwner">
    <xsl:param name="data"/>
    <xsl:variable name="product-owners" select="/root/products/accounts"/>
    
    <xsl:element name="ProductOwner">
      <xsl:attribute name="columnID" select="'POW'"/>
      <xsl:attribute name="accountID" select="sql:owner"/>
      <xsl:attribute name="email" select="$product-owners/account[@accountID = current()/sql:owner]/pf:GetDetailsResult/pf:Email"/>
      
      <xsl:if test="$data">
        <xsl:value-of select="$data/MasterData/ProductOwner"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <!-- Relative URLs -->
  <xsl:template match="MediumImageURL|ThumbnailURL|PreviewURL|DownloadURL"> 
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="em:getRelativeImageURL(current(), $relative-url-prefix)"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>