<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
    xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
    xmlns:pms-f="http://www.philips.com/pika/pms/1.0"
    xmlns:pf="http://tempuri.org/"
    >
  <xsl:import href="../../content_type/PMS/xsl/pms.functions.xsl" />
  <xsl:import href="./em-functions.xsl"/>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="sql:*">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template name="Moon">
    <xsl:param name="moon"/>
    
    <xsl:element name="StatusAlert">
      <xsl:element name="Description">
        <xsl:value-of select="$moon/sql:description_on_error"/>
      </xsl:element>
      <xsl:element name="WorkflowUrgency">
        <xsl:value-of select="em:determineUrgency($moon/sql:rank)"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="StatusAlert">
    <xsl:param name="alert"/>
    
    <xsl:element name="StatusAlert">
      <xsl:element name="Description">
        <xsl:choose>
          <xsl:when test="$alert/sql:description_on_error">
            <xsl:value-of select="$alert/sql:description_on_error"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$none-description"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:element name="Urgency">
        <xsl:value-of select="em:determineUrgency(if ($alert/sql:rank) then ($alert/sql:rank) else (-1))"/>
      </xsl:element>
      <xsl:if test="$alert/sql:rank">
        <xsl:element name="UrgencyRank">
          <xsl:value-of select="$alert/sql:rank"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <!-- for ContentDetails, don't show Green and Grey, but show None instead -->
  <xsl:template name="StatusAlertCD">
    <xsl:param name="alert"/>
    
    <xsl:variable name="rank" select="if ($alert/sql:rank) 
                                     then (
                                       if ($alert/sql:rank > 25)
                                       then ($alert/sql:rank)
                                       else (-1)
                                     ) 
                                     else (-1)"/>
    
    <xsl:element name="StatusAlert">
      <xsl:element name="Description">
        <xsl:choose>
          <xsl:when test="$alert/sql:description_on_error != ''">
            <xsl:value-of select="$alert/sql:description_on_error"/>  
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$none-description"/>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:element>
      <xsl:element name="Urgency">
        <xsl:value-of select="em:determineUrgency($rank)"/>
      </xsl:element>
      <xsl:if test="$alert/sql:rank">
        <xsl:element name="UrgencyRank">
          <xsl:value-of select="$alert/sql:rank"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <!-- for ContentCategories, prevent concatenated alert texts to clutter up the GUI -->
  <xsl:template name="StatusAlertCC">
    <xsl:param name="alert"/>
    <xsl:param name="publication-status"/>
    <xsl:variable name="rank" select="if ($alert/sql:rank) then ($alert/sql:rank) else (-1)"/>
    
    <xsl:element name="StatusAlert">
      <xsl:element name="Description">
        <xsl:choose>
          <xsl:when test="$alert/sql:columnid">
            <xsl:value-of select="em:determineDescription($alert/sql:columnid, $rank, $publication-status)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$none-description"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:element name="Urgency">
        <xsl:value-of select="em:determineUrgency($rank)"/>
      </xsl:element>
      <xsl:if test="$alert/sql:rank">
        <xsl:element name="UrgencyRank">
          <xsl:value-of select="$alert/sql:rank"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <!-- for Products, prevent concatenated alert texts to clutter up the GUI -->
  <xsl:template name="StatusAlertProduct">
    <xsl:param name="alert"/>
    <xsl:variable name="rank" select="if ($alert/sql:rank) then ($alert/sql:rank) else (-1)"/>
    
    <xsl:element name="StatusAlert">
      <xsl:element name="Description">
        <xsl:value-of select="em:determineProductDescription($rank)"/>
      </xsl:element>
      <xsl:element name="Urgency">
        <xsl:value-of select="em:determineUrgency($rank)"/>
      </xsl:element>
      <xsl:if test="$alert/sql:rank">
        <xsl:element name="UrgencyRank">
          <xsl:value-of select="$alert/sql:rank"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="StatusAlertMoon">
    <xsl:param name="alert"/>
    <xsl:param name="moon-alert"/>
    <xsl:param name="alert-description"/>
    
    <xsl:element name="StatusAlert">
      <xsl:element name="Description">
        <xsl:choose>
          <xsl:when test="$alert-description">
            <xsl:value-of select="$alert-description/sql:description_on_error"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$alert/sql:description_on_error != ''">
              <xsl:value-of select="$alert/sql:description_on_error"/>
            </xsl:if>
            <xsl:if test="($alert/sql:description_on_error != '') and ($moon-alert/sql:description_on_error != '')">
              <xsl:text>&#10;</xsl:text>
            </xsl:if>
            <xsl:if test="$moon-alert/sql:description_on_error != ''">
              <xsl:value-of select="$moon-alert/sql:description_on_error"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:element name="Urgency">
        <xsl:value-of select="em:determineUrgency($alert/sql:rank)"/>
      </xsl:element>
      <xsl:if test="$alert/sql:rank">
        <xsl:element name="UrgencyRank">
          <xsl:value-of select="$alert/sql:rank"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="$moon-alert">
        <xsl:element name="WorkflowUrgency">
          <xsl:value-of select="em:determineUrgency($moon-alert/sql:rank)"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="MasterData">
    <xsl:param name="data"/>
    
    <xsl:element name="MasterData">
      <xsl:element name="CTN">
        <xsl:attribute name="columnID" select="'CTN'"/>
        <xsl:value-of select="sql:ctn"/>
      </xsl:element>
      <xsl:element name="NamingStringShort">
        <xsl:attribute name="columnID" select="'SNS'"/>
        <xsl:value-of select="sql:namingstringshort"/>
      </xsl:element>
      <xsl:choose>
        <xsl:when test="sql:cr_date != ''">
          <xsl:element name="CRDate">
            <xsl:attribute name="columnID" select="'CRD'"/>
            <xsl:value-of select="em:formatCRDate(sql:cr_date)"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="CRDate">
            <xsl:attribute name="xsi:nil" select="'true'"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:element name="MarketingClass">
        <xsl:attribute name="columnID" select="'MCL'"/>
        <xsl:value-of select="em:formatMarketingClass(sql:marketingclass)"/>
      </xsl:element>
      <xsl:call-template name="ProductOwner">
        <xsl:with-param name="data" select="$data"/>
      </xsl:call-template>
      <xsl:element name="PMTVersion">
        <xsl:attribute name="columnID" select="'MST'"/>
        <xsl:value-of select="sql:pmtversion"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="ProductOwner">
    <xsl:param name="data"/>
     
    <xsl:element name="ProductOwner">
      <xsl:attribute name="columnID" select="'POW'"/>
      <xsl:attribute name="accountID" select="sql:owner"/>
      <xsl:if test="$data">
        <xsl:value-of select="$data/MasterData/ProductOwner"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="Categorization">
    <xsl:param name="product"/>
    
    <xsl:element name="Categorization">
      <xsl:variable name="subcategory" select="$product[sql:gcs_level = 'SU']"/>
      <xsl:if test="$subcategory">
        <xsl:element name="SubCategory">
          <xsl:attribute name="code" select="$subcategory/sql:gcs_category_code"/>
        
          <xsl:value-of select="$subcategory/sql:gcs_category_name"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="ContentCategories">
    <xsl:param name="product"/>
    <xsl:param name="data"/>
    <xsl:param name="userID"/>
    <xsl:param name="uap"/>
  
    <xsl:for-each select="$configfile/Config/Views/Content/Column[@type='contentCategory']">
      <xsl:element name="ContentCategory">
        <xsl:attribute name="columnID" select="@id"/>
        
        <xsl:call-template name="StatusAlertCC">
          <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
        </xsl:call-template>
        
        <xsl:variable name="id" select="@id"/>
        
        <xsl:element name="ContentItems">
          <xsl:for-each select="$configfile/Config/Views/Content/Column[@type='contentItem'][starts-with(@id, $id)]"> 
            <xsl:element name="ContentItem">
              <xsl:attribute name="columnID" select="@id"/>
              <!-- switch on calcType, Aggregate requires an additional moon -->
              <xsl:choose>
                <xsl:when test="current()/@id = 'TXT.MST'">
                  <!-- Description     TXT.MST
                       Urgency         TXT.FPB
                       WorkflowUrgency TXT.MWF -->
                  <xsl:call-template name="StatusAlertMoon">
	                <xsl:with-param name="alert" select="$product[sql:columnid = 'TXT.FPB']"/>
	                <xsl:with-param name="moon-alert" select="$product[sql:columnid = 'TXT.MWF']"/>
	              </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="StatusAlert">
                    <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
              
              <xsl:if test="$data">
                <xsl:variable name="content" select="$data/Content"/>
                <xsl:variable name="completeFlag" select="$content/ContentCategory[@columnID = $id]/ContentItems/ContentItem[@columnID = current()/@id]/StatusAlert/CompleteFlag"/>
                <xsl:variable name="contentItemAlert" select="$product[sql:columnid = current()/@id]"/>
                
                <!-- ContentDetail handling -->
                <xsl:if test="$content/ContentCategory[@columnID = $id]/ContentItems/ContentItem[@columnID = current()/@id]/ContentDetails/ContentDetail">
                  <xsl:element name="ContentDetails">
                    <xsl:for-each-group select="$content/ContentCategory[@columnID = $id]/ContentItems/ContentItem[@columnID = current()/@id]/ContentDetails/ContentDetail" 
                                        group-by="ContentType">                        
                      <xsl:for-each select="current-group()">
                      <xsl:sort select="Language"/>
                      <xsl:choose>
                      
                        <xsl:when test="not(current()/@calcType)">                        
	                      <xsl:element name="ContentDetail">
	                        <xsl:attribute name="seq" select="position()"/>
                            <xsl:if test="current()/@placeholder = 'false'"> 
                              <xsl:element name="StatusAlert">
                                <xsl:element name="Description">
                                  <xsl:value-of select="$none-description"/>
                                </xsl:element>
                                <xsl:element name="Urgency">
                                  <xsl:value-of select="'None'"/>
                                </xsl:element>
                              </xsl:element>
                            </xsl:if>
                            
                            <xsl:if test="current()/@placeholder = 'true'"> 
                              <xsl:call-template name="StatusAlertCD">
                                <xsl:with-param name="alert" select="$contentItemAlert"/>
                              </xsl:call-template>
                            </xsl:if>

	                        <xsl:apply-templates select="current()">
	                          <xsl:with-param name="userID" select="$userID"/>
	                        </xsl:apply-templates>
	                      </xsl:element>
	                      
	                    </xsl:when>
	                    <xsl:when test="current()/@calcType = 'BusinessRule'">
	                      <xsl:element name="ContentDetail">
                            <xsl:attribute name="seq" select="position()"/>
                            
                            <xsl:call-template name="StatusAlertCD">
                              <xsl:with-param name="alert" select="$product[sql:columnid = current()/@columnID]"/>
                            </xsl:call-template>
                           
                            <xsl:apply-templates select="current()">
                              <xsl:with-param name="userID" select="$userID"/>
                            </xsl:apply-templates>
                            
                          </xsl:element>
	                    </xsl:when>
	                    <!-- #401: include MWF as well -->
	                    <xsl:when test="current()/@calcType = 'Aggregate'">
	                      <xsl:if test="current()/@columnID = 'TXT.MWF'">
                            <xsl:element name="ContentDetail">
                              <xsl:attribute name="seq" select="position()"/>
                            
                              <xsl:call-template name="StatusAlertCD">
                                <xsl:with-param name="alert" select="$product[sql:columnid = current()/@columnID]"/>
                              </xsl:call-template>
                            
                              <xsl:apply-templates select="current()">
                                <xsl:with-param name="userID" select="$userID"/>
                              </xsl:apply-templates>
                            </xsl:element>
                          </xsl:if>
                        </xsl:when>
                      </xsl:choose>
                      </xsl:for-each>
                    </xsl:for-each-group>
                  </xsl:element>                  
                </xsl:if>
                
                <!-- Internal handling -->
                <xsl:if test="$content/ContentCategory[@columnID = $id]/ContentItems/ContentItem[@columnID = current()/@id]/ContentDetails/Internal">
                  <xsl:variable name="internal" select="$content/ContentCategory[@columnID = $id]/ContentItems/ContentItem[@columnID = current()/@id]/ContentDetails/Internal"/>
                  
                  <xsl:element name="ContentDetails"> 
                    <xsl:call-template name="StatusAlert">
                      <xsl:with-param name="alert" select="$product[sql:columnid = $internal/@columnID]"/>
                    </xsl:call-template>
                  
                    <xsl:for-each select="$internal/ContentDetail">
                      <xsl:element name="ContentDetail">
                        <xsl:attribute name="seq" select="position()"/>
                      
                        <xsl:apply-templates select="current()">
                          <xsl:with-param name="userID" select="$userID"/>
                        </xsl:apply-templates>
                      </xsl:element>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
              </xsl:if>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
 
  <xsl:template match="ContentDetail">
    <xsl:param name="userID"/>
  
    <xsl:apply-templates select="Description"/>
  
    <xsl:if test="Size != ''">
      <xsl:apply-templates select="Size"/>
    </xsl:if>
  
    <xsl:apply-templates select="ContentType"/>
    
    <xsl:call-template name="Publisher"/>
    
    <xsl:apply-templates select="Language"/>

    <xsl:element name="UploadURL">
      <xsl:variable name="map">
        <param name="user_id" value="{$userID}"/>
      </xsl:variable>
      <xsl:if test="UploadURL != ''">
        <xsl:value-of select="pms-f:fill-placeholders(UploadURL, $map)"/>
      </xsl:if>
    </xsl:element>
     
    <xsl:apply-templates select="PreviewURL|DownloadURL|ThumbnailURL|MediumImageURL"/>
    
    <xsl:if test="DueDate != ''">
      <xsl:apply-templates select="DueDate"/>
    </xsl:if>
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
  
  <xsl:template name="Catalogs">
    <xsl:param name="product"/>
    <xsl:param name="country"/>
    <xsl:param name="data"/>
  
    <xsl:element name="Catalogs">
      <xsl:for-each select="$configfile/Config/Views/Countries/Column[starts-with(@id, $country)]"> 
     
        <xsl:if test="$product[sql:columnid = current()/@id]">
          <xsl:element name="Catalog">
            <xsl:attribute name="columnID" select="current()/@id"/>
        
            <xsl:call-template name="StatusAlertMoon">
              <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
              <xsl:with-param name="moon-alert" select="$product[sql:columnid = concat($country, '_Moon')]"/>
              <xsl:with-param name="alert-description" select="$product[sql:columnid = current()/@id]"/>
            </xsl:call-template>
            
            <xsl:call-template name="PublicationStatus">
              <xsl:with-param name="publication-status" select="$product[sql:columnid = current()/@id]/sql:publication_status"/>
            </xsl:call-template>
            
            <xsl:if test="$data">
              <xsl:apply-templates select="$data/Countries/Country[@countryID = $country]/Catalogs/Catalog[@columnID = current()/@id]/CatalogDetails"/>
            </xsl:if>
          </xsl:element>
        </xsl:if>       
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="PublicationStatus">
    <xsl:param name="publication-status"/>
    
    <xsl:element name="PublicationStatus">
      <xsl:value-of select="$publication-status"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="CatalogDetails">
    <xsl:element name="CatalogDetails">
      
      <xsl:apply-templates select="StartOfPublication|EndOfPublication|CatalogManagerURL"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="Locales">
    <xsl:param name="product"/>
    <xsl:param name="country"/>
    
    <xsl:if test="$country/Locales">
      <xsl:element name="Locales">
        <xsl:for-each select="$country/Locales/Locale">
          <xsl:element name="Locale">
            <xsl:attribute name="LocaleID" select="@LocaleID"/>
            
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
  
  <!-- format PMTVersion to satisfy display requirement ( version (Month Day) ) -->
  <xsl:template match="PMTVersion"> 
    <xsl:element name="PMTVersion">
      <xsl:value-of select="em:formatPMTVersion(., ../LastModifiedDate)"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="Product">
    <xsl:param name="pmt-preview-url"/>
    
    <xsl:element name="Product">
	    <xsl:attribute name="columnID" select="'PUR'"/>
	    <xsl:attribute name="lastModified" select="em:formatDate(current()/sql:lastmodified_ts)"/> 
	    <xsl:attribute name="lastPublished" select="em:formatDate(current()/sql:master_date)"/>
	    <xsl:attribute name="seq" select="position()"/>
	   
	    <xsl:variable name="data" select="/root/octl/sql:rowset/sql:row[sql:object_id = current()/sql:ctn][sql:content_type='PMS']/sql:data/Product"/>
	   
	    <xsl:call-template name="StatusAlertProduct">
	      <xsl:with-param name="alert" select="current-group()[sql:columnid = 'PUR']"/>
	    </xsl:call-template>
	    
	    <xsl:call-template name="MasterData">
	      <xsl:with-param name="data" select="$data"/>
	    </xsl:call-template>
	    
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
<!-- 	    
	    <xsl:element name="Properties">
	       <xsl:value-of select="sql:properties/properties/p[@key='BRAND']/@value"/>
	    </xsl:element>
 -->	    
	    <xsl:element name="Content">
	      <xsl:attribute name="columnID" select="'PCU'"/>
	      <xsl:call-template name="StatusAlert">
	        <xsl:with-param name="alert" select="current-group()[sql:columnid = 'PCU']"/>
	      </xsl:call-template>
	      
	      <xsl:call-template name="ContentCategories">
	        <xsl:with-param name="product" select="current-group()"/>
	        <xsl:with-param name="data" select="$data"/>
	        <xsl:with-param name="userID" select="$userID"/>
	      </xsl:call-template>
	    </xsl:element>
	    
	    <xsl:call-template name="Countries">
	      <xsl:with-param name="product" select="current-group()"/>
	      <xsl:with-param name="data" select="$data"/>
	    </xsl:call-template>
	    
	    <xsl:apply-templates select="$data/OpenInPFS_URL">
	      <xsl:with-param name="userID" select="$userID"/>
	    </xsl:apply-templates>
	        
        <xsl:apply-templates select="$data/OpenInCCRUW_URL"/>
    </xsl:element>
  </xsl:template>

  <!-- override to add email -->
  <xsl:template name="Publisher">
    <xsl:variable name="publishers" select="/root/octl/sql:rowset/sql:row[sql:content_type='PMS']/accounts"/>
    <xsl:variable name="accountID" select="Publisher/@accountID"/>
    
    <xsl:element name="Publisher">
      <xsl:attribute name="accountID" select="$accountID"/>
      
      <xsl:value-of select="$publishers/account[@accountID = $accountID]/pf:GetDetailsResult/pf:FullName"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="OpenInPFS_URL">  
    <xsl:element name="OpenInPFS_URL">
      <xsl:variable name="map">
        <param name="user_id" value="{$userID}"/>
      </xsl:variable>
      <xsl:if test="current() != ''">
        <xsl:value-of select="pms-f:fill-placeholders(current(), $map)"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="ThumbnailURL">
    <xsl:param name="url"/>
    
    <xsl:element name="ThumbnailURL">
      <xsl:value-of select="$url"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="MediumImageURL">
    <xsl:param name="url"/>
    
    <xsl:element name="MediumImageURL">
      <xsl:value-of select="$url"/>
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>

