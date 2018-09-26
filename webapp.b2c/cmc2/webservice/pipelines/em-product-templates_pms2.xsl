<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
    xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
    xmlns:pms-f="http://www.philips.com/pika/pms/1.0"
    >
  
  <xsl:variable name="configfile_pms2" select="document('./xml/xUCDM_EMP_iPad_config v2.xml')"/>
  
  <xsl:template name="StatusAlertGreen">
    <xsl:element name="StatusAlert">
      <xsl:element name="Description">
        <xsl:value-of select="''"/>
      </xsl:element>
      <xsl:element name="Urgency">
        <xsl:value-of select="'Green'"/>
      </xsl:element>
      <xsl:element name="UrgencyRank">
        <xsl:value-of select="'0'"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="ContentCategories">
    <xsl:param name="product"/>
    <xsl:param name="data"/>
    <xsl:param name="master-data"/>
    <xsl:param name="localized-data"/>
    <xsl:param name="userID"/>
  
    <xsl:for-each select="$configfile_pms2/Config/Views/Content/Column[@type='contentCategory']">
      <xsl:element name="ContentCategory">
        <xsl:attribute name="columnID" select="@id"/>
        <xsl:attribute name="CD_Type" select="@CD_Type"/>
        
        <!-- issue 781: No aggregated alert for FEA in business logic. Use TXT.FEA instead,
                        as it is the only ContentItem
                        The same for NMS / TXT.DES
        -->
        <xsl:choose>
          <xsl:when test="current()/@id = 'FEA'">
            <xsl:call-template name="StatusAlert">
              <xsl:with-param name="alert" select="$product[sql:columnid = 'TXT.FEA']"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="current()/@id = 'NMS'">
	        <xsl:call-template name="StatusAlert">
	          <xsl:with-param name="alert" select="$product[sql:columnid = 'TXT.DES']"/>
	        </xsl:call-template>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:call-template name="StatusAlertCC">
	          <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
	        </xsl:call-template>
	      </xsl:otherwise>
        </xsl:choose>
        
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="content-detail-mode" select="@CD_Type"/>
        
        <xsl:element name="ContentItems">
          <xsl:for-each select="$configfile_pms2/Config/Views/Content/Column[@type='contentCategory'][@id = $id]/Column">
            <!-- #777: Don't show when there is no SubWOW, else Green -->
            <xsl:element name="ContentItem">
              <xsl:attribute name="columnID" select="@id"/>

              <xsl:choose>
                <xsl:when test="(current()/@id = 'TXT.SBW') and ($master-data) and ($master-data/SubWOW)">
                  <xsl:call-template name="StatusAlertGreen"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="StatusAlert">
                    <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
              
              <xsl:if test="$master-data">
                <xsl:if test="$content-detail-mode = 'Feature'">
                  <xsl:element name="ContentDetails">
                    <xsl:for-each select="$master-data/KeyBenefitArea/Feature">
                      <xsl:element name="ContentDetail">
                        <xsl:attribute name="seq" select="position()"/>
                      
                        <xsl:call-template name="StatusAlertCD">
                          <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="FeatureContentDetail">
                          <xsl:with-param name="feature" select="current()"/>
                        </xsl:call-template>
                      </xsl:element>  
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
                <xsl:if test="$content-detail-mode = 'NamingString'">
                  <xsl:element name="ContentDetails">
                    <xsl:element name="ContentDetail">
                      <xsl:attribute name="seq" select="'1'"/>
                      
                      <xsl:call-template name="StatusAlertCD">
                        <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
                      </xsl:call-template>

                      <xsl:call-template name="NamingContentDetail">
                        <xsl:with-param name="naming-string" select="$master-data/NamingString"/>
                      </xsl:call-template>
                    </xsl:element>              
                  </xsl:element>
                </xsl:if>
                <xsl:if test="$content-detail-mode = 'Text'"> 
                  <xsl:if test="(current()/@id != 'TXT.SBW') or ((current()/@id = 'TXT.SBW') and ($master-data/SubWOW))">
                  <xsl:element name="ContentDetails">
                    <xsl:choose>
                      <xsl:when test="current()/@id != 'TXT.KBA'">
	                    <xsl:element name="ContentDetail">
	                      <xsl:attribute name="seq" select="'1'"/>
	                      
	                      <xsl:call-template name="StatusAlertCD">
	                        <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
	                      </xsl:call-template>
	
	                      <xsl:call-template name="TextContentDetail">
	                        <xsl:with-param name="master-data" select="$master-data"/>
	                        <xsl:with-param name="text-column" select="current()/@id"/>
	                        <xsl:with-param name="description" select="current()/@label"/>
	                      </xsl:call-template>                      
	                    </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:for-each select="$master-data/KeyBenefitArea">
                          <xsl:element name="ContentDetail">
                            <xsl:attribute name="seq" select="position()"/>
                          
                            <xsl:call-template name="StatusAlertCD">
                              <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
                            </xsl:call-template>
    
                            <xsl:call-template name="KBAContentDetail">
                              <xsl:with-param name="kba" select="current()"/>
                            </xsl:call-template>
                          </xsl:element>
                        </xsl:for-each>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                  </xsl:if>
                </xsl:if>
              </xsl:if>
              
              <xsl:if test="$localized-data">
                <xsl:if test="$content-detail-mode = 'Review'"> 
                  <xsl:element name="ContentDetails">
                    <xsl:for-each select="$master-data/Award[@AwardType = 'ala_summary' or @AwardType = 'ala_expert'][@globalSource = 'true']">
                      <xsl:element name="ContentDetail">
                        <xsl:attribute name="seq" select="position()"/>
                      
                        <xsl:call-template name="StatusAlertCD">
                          <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="ReviewContentDetail">
                          <xsl:with-param name="review" select="current()"/>
                        </xsl:call-template>
                      </xsl:element>
                     </xsl:for-each>
                     
                     <xsl:variable name="master-count" select="count($master-data/Award[@AwardType = 'ala_summary' or @AwardType = 'ala_expert'][@globalSource = 'true'])"/>
                     
                     <xsl:for-each select="$localized-data/Award[@AwardType = 'ala_summary' or @AwardType = 'ala_expert'][@globalSource = 'false']">
                     <xsl:element name="ContentDetail">
                        <xsl:attribute name="seq" select="position() + $master-count"/>
                      
                        <xsl:call-template name="StatusAlertCD">
                          <xsl:with-param name="alert" select="$product[sql:columnid = current()/@id]"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="ReviewContentDetail">
                          <xsl:with-param name="review" select="current()"/>
                        </xsl:call-template>
                      </xsl:element>
                     </xsl:for-each>
                  </xsl:element>                        
                </xsl:if>
              </xsl:if>
              
              <xsl:if test="$data">
                <xsl:if test="$content-detail-mode = 'Photo' or
                              $content-detail-mode = 'Video' or
                              $content-detail-mode = 'Manual'">
              
                <xsl:variable name="content" select="$data/Content"/>
                <xsl:variable name="completeFlag" select="$content/ContentCategory[@columnID = $id]/ContentItems/ContentItem[@columnID = current()/@id]/StatusAlert/CompleteFlag"/>
                <xsl:variable name="contentItemAlert" select="$product[sql:columnid = current()/@id]"/>
                
                <!-- ContentDetail handling : lookup ContentItem in PMS -->
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
	                        <xsl:call-template name="ContentDetail">
	                          <xsl:with-param name="content-detail" select="current()"/>
	                          <xsl:with-param name="mode" select="$content-detail-mode"/>
	                          <xsl:with-param name="userID" select="$userID"/>
	                        </xsl:call-template>
	                      </xsl:element>
	                      
	                    </xsl:when>
	                    <xsl:when test="current()/@calcType = 'BusinessRule'">
	                      <xsl:element name="ContentDetail">
                            <xsl:attribute name="seq" select="position()"/>
                            
                            <xsl:call-template name="StatusAlertCD">
                              <xsl:with-param name="alert" select="$product[sql:columnid = current()/@columnID]"/>
                            </xsl:call-template>
                            
                            <xsl:choose>
                              <xsl:when test="starts-with(current()/@columnID, 'TXT.FEA')"> 
                                <xsl:call-template name="ContentDetail">
                                  <xsl:with-param name="content-detail" select="current()"/>
                                  <xsl:with-param name="mode" select="$content-detail-mode"/>
                                  <xsl:with-param name="userID" select="$userID"/>
                                </xsl:call-template>
                              </xsl:when>
                              <xsl:when test="current()/@columnID, 'PHO.MIP'"> 
                                <xsl:call-template name="ContentDetail">
                                  <xsl:with-param name="content-detail" select="current()/ContentDetail"/>
                                  <xsl:with-param name="mode" select="$content-detail-mode"/>
                                  <xsl:with-param name="userID" select="$userID"/>
                                </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:call-template name="ContentDetail">
	                              <xsl:with-param name="content-detail" select="current()"/>
	                              <xsl:with-param name="mode" select="$content-detail-mode"/>
	                              <xsl:with-param name="userID" select="$userID"/>
	                            </xsl:call-template>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element>
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
                      
                        <xsl:call-template name="ContentDetail">
                          <xsl:with-param name="content-detail" select="current()"/>
                          <xsl:with-param name="mode" select="$content-detail-mode"/>
                          <xsl:with-param name="userID" select="$userID"/>
                        </xsl:call-template>
                      </xsl:element>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
              </xsl:if>
              
              </xsl:if>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="ReviewContentDetail">
    <xsl:param name="review"/>
    
    <xsl:element name="ReviewCode">
      <xsl:value-of select="$review/AwardCode"/>
    </xsl:element>
    
    <xsl:element name="Type">
      <xsl:value-of select="$review/@AwardType"/>
    </xsl:element>
    
    <xsl:if test="$review/Title != ''">
      <xsl:element name="Title">
        <xsl:value-of select="$review/Title"/>
      </xsl:element>
    </xsl:if>
    
    <!-- SourceLogoURL -->
    
    <xsl:if test="$review/AwardAuthor != ''">
      <xsl:element name="Author">
        <xsl:value-of select="$review/AwardAuthor"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$review/Rating != ''">
      <xsl:element name="Rating">
        <xsl:value-of select="$review/Rating"/>
      </xsl:element>
    </xsl:if>
    
    <!-- RatingURL -->
    
    <xsl:if test="$review/Trend != ''">
      <xsl:element name="Trend">
        <xsl:value-of select="$review/Trend"/>
      </xsl:element>
    </xsl:if>    
    
    <xsl:if test="$review/AwardSourceLocale != ''">
      <xsl:element name="SourceLocale">
        <xsl:value-of select="$review/AwardSourceLocale"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$review/AwardAcknowledgement != ''">
      <xsl:element name="Acknowledgement">
        <xsl:value-of select="$review/AwardAcknowledgement"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$review/TestPros != ''">
      <xsl:element name="TestPros">
        <xsl:value-of select="$review/TestPros"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$review/TestCons != ''">
      <xsl:element name="TestCons">
        <xsl:value-of select="$review/TestCons"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$review/AwardVerdict != ''">
      <xsl:element name="Verdict">
        <xsl:value-of select="$review/AwardVerdict"/>
      </xsl:element>
    </xsl:if>

    <xsl:element name="ReviewURL">
      <xsl:if test="$review/@AwardType = 'ala_expert'"> 
        <xsl:variable name="ala-url" select="'http://alatest.co.uk/redirect/pro-reviews'"/>
        <xsl:variable name="philips-id" select="'50428'"/>
        
        <xsl:variable name="id" select="substring-after($review/AwardCode, '_')"/>
        
        <xsl:value-of select="concat($ala-url, '/', $id, '/', $philips-id)"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="FeatureContentDetail">
    <xsl:param name="feature"/>

    <xsl:element name="FeatureCode">    
      <xsl:value-of select="$feature/FeatureCode"/>
    </xsl:element>
    
    <xsl:element name="ReferenceName">
      <xsl:value-of select="$feature/FeatureReferenceName"/>
    </xsl:element>
    
    <xsl:element name="Name">
      <xsl:value-of select="$feature/FeatureName"/>
    </xsl:element>
    
    <xsl:if test="not(empty($feature/FeatureLongDescription))">
      <xsl:element name="LongDescription">
        <xsl:value-of select="$feature/FeatureLongDescription"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="not(empty($feature/FeatureGlossary))">
      <xsl:element name="Glossary">
        <xsl:value-of select="$feature/FeatureGlossary"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="NamingContentDetail">
    <xsl:param name="naming-string"/>
    
    <xsl:if test="$naming-string/Descriptor/DescriptorName != ''">
      <xsl:element name="Descriptor">
        <xsl:value-of select="$naming-string/Descriptor/DescriptorName"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/Alphanumeric != ''">
      <xsl:element name="Alphanumeric">
        <xsl:value-of select="$naming-string/Alphanumeric"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/BrandString != ''">
      <xsl:element name="BrandString">
        <xsl:value-of select="$naming-string/BrandString"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/BrandString2 != ''">
      <xsl:element name="BrandString2">
        <xsl:value-of select="$naming-string/BrandString2"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/Concept/ConceptNameUsed != ''">
      <xsl:element name="Concept">
        <xsl:attribute name="nameUsed" select="$naming-string/Concept/ConceptNameUsed"/>
        <xsl:value-of select="$naming-string/Concept/ConceptName"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/Family/FamilyNameUsed != ''">
      <xsl:element name="Family">
        <xsl:attribute name="nameUsed" select="$naming-string/Family/FamilyNameUsed"/>
        <xsl:value-of select="$naming-string/Family/FamilyName"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/Range/RangeNameUsed != ''">
      <xsl:element name="Range">
        <xsl:attribute name="nameUsed" select="$naming-string/Range/RangeNameUsed"/>
        <xsl:value-of select="$naming-string/Range/RangeName"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/VersionElement1/VersionElementName != ''">
      <xsl:element name="VersionElement1">
        <xsl:value-of select="$naming-string/VersionElement1/VersionElementName"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/VersionElement2/VersionElementName != ''">
      <xsl:element name="VersionElement2">
        <xsl:value-of select="$naming-string/VersionElement2/VersionElementName"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/VersionElement3/VersionElementName != ''">
      <xsl:element name="VersionElement3">
        <xsl:value-of select="$naming-string/VersionElement3/VersionElementName"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/VersionElement4/VersionElementName != ''">
      <xsl:element name="VersionElement4">
        <xsl:value-of select="$naming-string/VersionElement4/VersionElementName"/>
      </xsl:element>
    </xsl:if>
    
    <xsl:if test="$naming-string/BrandedFeatureString != ''">
      <xsl:element name="BrandedFeatureString">
        <xsl:value-of select="$naming-string/BrandedFeatureString"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="KBAContentDetail">
    <xsl:param name="kba"/>
    
    <xsl:element name="Text">
      <xsl:value-of select="$kba/KeyBenefitAreaCode"/>
    </xsl:element>

    <xsl:element name="Description">
      <xsl:value-of select="$kba/KeyBenefitAreaName"/>    
    </xsl:element>
  </xsl:template>
   
  <xsl:template name="TextContentDetail">
    <xsl:param name="master-data"/>
    <xsl:param name="text-column"/>
    <xsl:param name="description"/>
    
    <xsl:element name="Text">
      <xsl:choose>
        <xsl:when test="$text-column = 'TXT.WOW'">
          <xsl:value-of select="$master-data/WOW"/>
        </xsl:when>
        <xsl:when test="$text-column = 'TXT.SBW'">
          <xsl:value-of select="$master-data/SubWOW"/>
        </xsl:when>
        <xsl:when test="$text-column = 'TXT.MTH'">
          <xsl:value-of select="$master-data/MarketingTextHeader"/>
        </xsl:when>
      </xsl:choose>  
    </xsl:element>
    <xsl:element name="Description">
      <xsl:value-of select="$description"/>
    </xsl:element>
  </xsl:template>
   
  <xsl:template name="ContentDetail">
    <xsl:param name="content-detail"/>
    <xsl:param name="mode"/>
    <xsl:param name="userID"/>
    
    <xsl:choose>
      <xsl:when test="$mode = 'Photo'">
        <xsl:apply-templates select="PreviewURL"/>
        <xsl:apply-templates select="Description"/>
        <xsl:apply-templates select="ContentType"/>
        <xsl:call-template name="Publisher"/>
        <xsl:call-template name="PublicationDate"/>
        <xsl:apply-templates select="ThumbnailURL"/>
        <xsl:apply-templates select="MediumImageURL"/>
        <xsl:call-template name="Size"/>
      </xsl:when>
      <xsl:when test="$mode = 'Video'">
        <xsl:call-template name="StreamingURL"/>
        <xsl:apply-templates select="Description"/>
        <xsl:apply-templates select="ContentType"/>
        <xsl:call-template name="Publisher"/>
        <xsl:call-template name="PublicationDate"/>
        <xsl:apply-templates select="Language"/>
        <xsl:apply-templates select="ThumbnailURL"/>
        <!-- <xsl:apply-templates select="MediumImageURL"/> -->
        <xsl:call-template name="MediumImageURL"/>
        <xsl:call-template name="Length"/>
      </xsl:when>
      <xsl:when test="$mode = 'Manual'">
        <xsl:apply-templates select="DownloadURL"/>
        <xsl:apply-templates select="Description"/>
        <xsl:apply-templates select="ContentType"/>
        <xsl:call-template name="Publisher"/>
        <xsl:call-template name="PublicationDate"/>
        <xsl:apply-templates select="Language"/>
        <xsl:call-template name="Size"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template> 
   
  <xsl:template name="StreamingURL"> 
    <xsl:element name="StreamingURL">
      <!--
      <xsl:value-of select="'http://brightcove.vo.llnwd.net/pd13/media/734546227001/734546227001_748710157001_46PFL9705-flv.mp4'"/>
      -->
    </xsl:element>
  </xsl:template>
  
  <!-- 2011-06-22: temporary code, until the Brightcove uploads have been completed -->
  <xsl:template name="MediumImageURL">
    <xsl:element name="MediumImageURL">
      <xsl:value-of select="'http://pww.empowermeipaddev.philips.com:9080/Empower.me.iPad/imgs/NotAvailable.jpg'"/>
    </xsl:element>
  </xsl:template> 
   
  <xsl:template name="PublicationDate">
    <xsl:if test="PublicationDate != ''">
      <xsl:element name="PublicationDate"> 
        <xsl:value-of select="PublicationDate"/>
      </xsl:element>  
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="Size">
    <xsl:if test="Size != ''">
      <xsl:element name="Size"> 
        <xsl:value-of select="Size"/>
      </xsl:element>  
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="Length">
    <xsl:if test="Size != ''">
      <xsl:element name="Length"> 
        <xsl:value-of select="Size"/>
      </xsl:element>  
    </xsl:if>
  </xsl:template> 
</xsl:stylesheet>

