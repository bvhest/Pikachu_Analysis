<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:pms-f="http://www.philips.com/pika/pms/1.0" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    extension-element-prefixes="pms-f xs" exclude-result-prefixes="sql">

  <xsl:import href="pms.functions.xsl" />
  <xsl:include href="pmsBase.xsl"/>
    
  <xsl:param name="asset-edit-url" />  
  <xsl:param name="pmt-edit-url" />
  <xsl:param name="pmt-preview-url" />
    
  <xsl:variable name="doctypes-config" select="document('../../../xml/emp_doctype_groups.xml')/Product" />
  <xsl:variable name="doctypes-attr" select="document('../../../xml/doctype_attributes.xml')/doctypes" />
  
  <!--
    Create a StatusAlert.
    Context is a doctype config Node.
  -->
  <xsl:template name="statusAlert">
    <xsl:param name="p" />
    <xsl:param name="path" />
    <xsl:param name="restrictionType" />
    <xsl:param name="requiredStr" />
    <xsl:param name="baseUrgency" />
    <xsl:param name="descriptionOnError" />
    <xsl:param name="locale" />

    <xsl:variable name="path" select="concat( 'count(', $path, ')' )" />
    <xsl:variable name="required" select="if ($requiredStr != '') then number($requiredStr) else 0" />
    <xsl:variable name="count" select="$p/saxon:evaluate($path)" />
    <xsl:variable name="complete">
      <xsl:choose>
        <xsl:when test="$restrictionType = 'max'">
          <xsl:value-of select="if ($count &gt; $required) then 0 else 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="if ($count &lt; $required) then 0 else 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- No StutusAlert if required is 0 and actual is 0 -->
    <xsl:if test="not($required=0 and $count=0)">
      <xsl:element name="StatusAlert">
        <xsl:attribute name="required" select="$required" />
        <xsl:attribute name="actual" select="$count" />
        <xsl:attribute name="restrictionType" select="$restrictionType" />
        <xsl:element name="CompleteFlag">
          <xsl:value-of select="$complete" />
        </xsl:element>
        <xsl:element name="BaseUrgency">
          <xsl:value-of select="$baseUrgency" />
        </xsl:element>
        <xsl:element name="Label">
          <xsl:if test="number($complete) = 0">
            <xsl:variable name="map">
              <param name="act" value="{$count}"/>
              <param name="req" value="{$required}"/>
              <param name="locale" value="{$locale}"/>
              
              <xsl:if test="@lookupType='PMT'">
                <param name="ED" value="{substring-before(pms-f:get-milestone-date('ED', $p, (), (), ()), 'T')}"/>
                <param name="SID" value="{substring-before(pms-f:get-milestone-date('SID', $p, (), (), ()), 'T')}"/>
              </xsl:if>
            </xsl:variable>
            <xsl:value-of select="pms-f:fill-placeholders($descriptionOnError, $map)"/>
          </xsl:if>
        </xsl:element>
        <xsl:element name="Path">
          <xsl:value-of select="$path" />
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <!--
    Create ContentDetail for product assets.
    
    Arguments:
    $product  Intermediate PMS product.
    $is-complete  boolean that indicates if the current Node's alert status is complete.
    
    Output:
    For a Group in a configuration Node's DocTypes
    -A ContentDetail for each asset type in the group that is present in the product.
    -A ContentDetail for the first asset type of the group that is not present in the product.
  -->
  <xsl:template match="Node/DocTypes/Group" mode="content-detail">
    <xsl:param name="product" />
    <xsl:param name="is-complete" />
    
    <xsl:variable name="assets" select="$product/EvaluationData/Assets/Asset|$product/EvaluationData/ObjectAssets/Asset" />
    <xsl:variable name="main-assets" select="$assets[@ResourceType=current()/Main]" />
    <xsl:variable name="main-master-asset" select="$assets[@ResourceType=current()/Main][@Language=('',current()/Main/@LocaleID)]" />
    <!-- Existing Main asset -->
    <xsl:apply-templates select="$main-assets" mode="content-detail">
      <xsl:sort select="@id"/>
      <xsl:sort select="@Language"/>
      <xsl:with-param name="upload-type" select="../../@uploadType"/>
    </xsl:apply-templates>

    <xsl:variable name="milestone-config" select="../../Date[@type='t2']" />
    <xsl:variable name="milestone-date" select="pms-f:get-milestone-date($milestone-config/@milestone, $product, (), (), ())" />
    <xsl:variable name="due-date" select="if ($is-complete) then () else substring-before(pms-f:date-add($milestone-date, $milestone-config/@offset), 'T')" />
    
    <!-- Non-existing Main asset -->
    <xsl:if test="empty($main-master-asset)">
      <xsl:variable name="empty-asset">
        <Asset id="{$product/MasterData/CTN}"
               Description="{$doctypes-attr/doctype[@code=current()/Main/text()]/@description}"
               ResourceType="{Main/text()}"
               DueDate="{if ($is-complete) then () else $due-date}"
               Language="{Main/@LocaleID}"/>
      </xsl:variable>
      <xsl:apply-templates select="$empty-asset" mode="content-detail">
        <xsl:with-param name="upload-type" select="../../@uploadType"/>
        <xsl:with-param name="is-placeholder" select="true()"/>
      </xsl:apply-templates>
    </xsl:if>
    <!-- Existing Alternative assets -->
    <xsl:apply-templates select="$assets[@ResourceType=current()/Alt]" mode="content-detail">
      <xsl:with-param name="upload-type" select="../../@uploadType"/>
    </xsl:apply-templates>
    <xsl:if test="exists($main-master-asset)">
      <!-- First non-existing Alternative asset -->
      <xsl:variable name="alt-type" select="(for $alt in Alt
                                             return if (empty($assets[@ResourceType=$alt][string($alt/@LocaleID)='' or $alt/@LocaleID=@Language])) then
                                                      $alt
                                                    else
                                                      ()
                                             )[1]"/>
      <xsl:if test="exists($alt-type)">
        <xsl:variable name="empty-asset">
          <Asset id="{$product/MasterData/CTN}"
                 Description="{$doctypes-attr/doctype[@code=$alt-type/text()]/@description}"
                 ResourceType="{$alt-type/text()}"
                 DueDate="{if ($is-complete) then $due-date else ()}"
                 Language="{$alt-type/@LocaleID}"/>
        </xsl:variable>
        <xsl:apply-templates select="$empty-asset" mode="content-detail">
          <xsl:with-param name="upload-type" select="../../@uploadType"/>
          <xsl:with-param name="is-placeholder" select="true()"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:if>    
  </xsl:template>
  
  <!--
    Create ContentDetail for an asset
  -->
  <xsl:template match="Asset" mode="content-detail">
    <xsl:param name="upload-type"/>
    <xsl:param name="is-placeholder" select="false()"/>
    <xsl:param name="column-id"/>
    <xsl:param name="status-alert"/>
    
    <xsl:variable name="dt" select="@ResourceType"/>
    <xsl:variable name="thumbnail_doctype" select="@Thumbnail" />
    <xsl:variable name="medium_doctype" select="@Medium" />
    <xsl:variable name="preview_doctype" select="@Preview" />
    <xsl:variable name="thumbnailURL" select="../Asset[@ResourceType=$thumbnail_doctype][@id=current()/@id]/@Url" />
    <xsl:variable name="mediumURL" select="../Asset[@ResourceType=$medium_doctype][@id=current()/@id]/@Url" />
    <xsl:variable name="previewURL" select="../Asset[@ResourceType=$preview_doctype][@id=current()/@id]/@Url" />
    <xsl:variable name="edit-doctype" select="if ($upload-type = 'PMT') then
                                                'PMT_Raw'
                                              else
                                                $dt" />
    
    <xsl:element name="ContentDetail">
      <xsl:attribute name="placeholder" select="$is-placeholder" />
      <xsl:if test="$column-id != ''">
        <xsl:attribute name="columnID" select="$column-id" />
      </xsl:if>
      <xsl:if test="$status-alert">
        <xsl:copy-of select="$status-alert"/>
      </xsl:if>
      
      <xsl:element name="Description">
        <xsl:value-of select="@Description" />
      </xsl:element>
      <xsl:element name="Size">
        <xsl:value-of select="@Extent" />
      </xsl:element>
      <xsl:element name="ContentType">
        <xsl:attribute name="authorizationContentType" select="$edit-doctype" />
        <xsl:value-of select="$dt" />
      </xsl:element>
      <xsl:element name="Publisher">
        <xsl:attribute name="accountID" select="@Creator" />
      </xsl:element>
      <xsl:element name="Language">
        <xsl:value-of select="@Language" />
      </xsl:element>
      <xsl:element name="UploadURL">
        <xsl:value-of select="if ($edit-doctype = 'PMT_Raw') then
                                pms-f:build-pmt-edit-url($pmt-edit-url, if (ancestor::Product/MasterData/CTN) then ancestor::Product/MasterData/CTN else @id)
                              else
                                pms-f:build-asset-edit-url($asset-edit-url, @id, $dt, upper-case(@Language))"/>
      </xsl:element>
      <xsl:element name="PreviewURL">
        <xsl:value-of select="$previewURL"/>
      </xsl:element>
      <xsl:element name="DownloadURL">
        <xsl:value-of select="@Url"/>
      </xsl:element>
      <xsl:element name="ThumbnailURL">
        <xsl:value-of select="$thumbnailURL" />
      </xsl:element>
      <xsl:element name="MediumImageURL">
        <xsl:value-of select="$mediumURL" />
      </xsl:element>
      <xsl:if test="@DueDate!=''">
        <xsl:element name="DueDate">
          <xsl:value-of select="@DueDate" />
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="Content">
    <xsl:variable name="prd" select=".." />
    <xsl:variable name="productType" select="pms-f:marketing-classification($prd/MasterData/MarketingClass)" />

    <xsl:copy copy-namespaces="no">
      <xsl:for-each select="$doctypes-config/Node/Node[@refName='ProductContentUrgency']/Node[@type='ContentCategory'] ">
        <!-- LEVEL 1 -->
        <xsl:element name="ContentCategory">
          <xsl:apply-templates select="@columnID"/>
          <xsl:element name="ContentItems">
            <xsl:for-each select="Node">
              <!-- LEVEL 2 -->
              <xsl:element name="ContentItem">
                <xsl:apply-templates select="@columnID|@calcType"/>
                <xsl:choose>
                  <xsl:when test="@calcType='Aggregate'">
                    <xsl:element name="ContentDetails">
                      <xsl:for-each select="Node">
                        <!-- LEVEL 3 -->
                        <xsl:choose>
                          <xsl:when test="@columnID='SUP.DFU.[LocaleID]'">
                            <!-- Custom code for Support manuals -->
                            <xsl:call-template name="content-details-dfu">
                              <xsl:with-param name="prd" select="$prd"/>
                              <xsl:with-param name="productType" select="$productType"/>
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:element name="{@type}">
                              <xsl:apply-templates select="@columnID|@calcType"/>
                              <xsl:choose>
                                <xsl:when test="@calcType='Aggregate'">
                                  <!-- At this level only Internal PMT BusinessRules are supported -->
                                  <xsl:for-each select="Node[@type='Internal'][@calcType='BusinessRule'][@lookupType='PMT']">
                                    <!-- LEVEL 4 -->
                                    <xsl:element name="Internal">
                                      <xsl:apply-templates select="@columnID|@calcType|TextDescription"/>
                                      <xsl:variable name="requiredStr" select="Requirements/@*[local-name()=$productType]" />
                                      <xsl:variable name="status-alert">
                                        <xsl:choose>
                                          <xsl:when test="Query/@type='XPath'">
                                            <xsl:call-template name="statusAlert">
                                              <xsl:with-param name="p" select="$prd" />
                                              <xsl:with-param name="path" select="Query" />
                                              <xsl:with-param name="restrictionType" select="Requirements/@type" />
                                              <xsl:with-param name="requiredStr" select="$requiredStr" />
                                              <xsl:with-param name="baseUrgency" select="BaseUrgency" />
                                              <xsl:with-param name="descriptionOnError" select="DescriptionOnError" />
                                              <xsl:with-param namae="locale"/>
                                            </xsl:call-template>
                                          </xsl:when>
                                          <xsl:otherwise>
                                            <StatusAlert>
                                              <CompleteFlag>1</CompleteFlag>
                                            </StatusAlert>
                                          </xsl:otherwise>
                                        </xsl:choose>
                                      </xsl:variable>
                                      
                                      <xsl:apply-templates select="$status-alert"/>
                                    </xsl:element>
                                  </xsl:for-each>
                                  <!-- Any other child Node at this level are not allowed -->
                                  <xsl:if test="Node[@type!='Internal' or @calcType!='BusinessRule' or @lookupType!='PMT']">
                                    <xsl:sequence select="fn:error(fn:QName('http://pww.pikachu.philips.com/ct/PMS', 'err:ILLEGALNODE'), 'Illegal Node at this level')"/>
                                  </xsl:if>
    
                                  <!-- Create the ContentDetail elements -->
                                  <xsl:call-template name="content-details-PMT-sub">
                                    <xsl:with-param name="product" select="$prd"/>
                                  </xsl:call-template>
                                  
                                </xsl:when>
                                <xsl:when test="@calcType='BusinessRule'">
                                  <xsl:call-template name="eval-content-detail-busrule">
                                    <xsl:with-param name="prd" select="$prd"/>
                                    <xsl:with-param name="productType" select="$productType"/>
                                    <xsl:with-param name="create-wrapper" select="false()"/>
                                    <xsl:with-param name="create-status-alert" select="true()"/>
                                  </xsl:call-template>
                                </xsl:when>
                              </xsl:choose>
                            </xsl:element>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                    </xsl:element>
                  </xsl:when>

                  <xsl:when test="@calcType='BusinessRule'">
                    <xsl:call-template name="eval-content-detail-busrule">
                      <xsl:with-param name="prd" select="$prd"/>
                      <xsl:with-param name="productType" select="$productType"/>
                      <xsl:with-param name="create-wrapper" select="true()"/>
                      <xsl:with-param name="create-status-alert" select="true()"/>
                    </xsl:call-template>
                  </xsl:when>
                </xsl:choose>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <!-- 
    Evaluate a Node of calc type 'BusinessRule'.
    Context is the Node itself.
  -->
  <xsl:template name="eval-content-detail-busrule">
    <xsl:param name="prd"/>
    <xsl:param name="productType"/>
    <xsl:param name="create-wrapper"/>
    <xsl:param name="create-status-alert"/>

    <xsl:variable name="requiredStr" select="Requirements/@*[local-name()=$productType]" />
    <xsl:variable name="status-alert">
      <xsl:choose>
        <xsl:when test="Query/@type='XPath'">
          <xsl:call-template name="statusAlert">
            <xsl:with-param name="p" select="$prd" />
            <xsl:with-param name="path" select="Query/text()" />
            <xsl:with-param name="restrictionType" select="Requirements/@type" />
            <xsl:with-param name="requiredStr" select="$requiredStr" />
            <xsl:with-param name="baseUrgency" select="BaseUrgency" />
            <xsl:with-param name="descriptionOnError" select="DescriptionOnError" />
            <xsl:with-param namae="locale"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <StatusAlert>
            <CompleteFlag>1</CompleteFlag>
          </StatusAlert>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:if test="$create-status-alert">
      <xsl:apply-templates select="$status-alert"/>
    </xsl:if>
    
    <xsl:choose>
      <xsl:when test="$create-wrapper=true()">
        <xsl:element name="ContentDetails">
          <xsl:call-template name="eval-content-detail-busrule-sub">
            <xsl:with-param name="product" select="$prd"/>
            <xsl:with-param name="is-complete" select="$status-alert/StatusAlert/CompleteFlag = '1'"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="eval-content-detail-busrule-sub">
          <xsl:with-param name="product" select="$prd"/>
          <xsl:with-param name="is-complete" select="$status-alert/StatusAlert/CompleteFlag = '1'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- 
    Evaluate a Node of calc type 'BusinessRule' and lookup type 'asset'.
    Context is the Node itself. 
  -->
  <xsl:template name="eval-content-detail-busrule-sub">
    <xsl:param name="product"/>
    <xsl:param name="is-complete"/>
    <xsl:choose>
      <xsl:when test="@lookupType='Asset'">
        <!-- Create ContentDetail elements for separate doctypes -->
        <xsl:apply-templates select="DocTypes/Group" mode="content-detail">
          <xsl:with-param name="product" select="$product" />
          <xsl:with-param name="is-complete" select="$is-complete" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="@lookupType='PMT'">
        <xsl:call-template name="content-details-PMT">
          <xsl:with-param name="product" select="$product" />
          <xsl:with-param name="is-complete" select="$is-complete" />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!--
    Create ContentDetail for a PMT Node.
    Context is Node itself.
  -->
  <xsl:template name="content-details-PMT">
    <xsl:param name="product" />
    <xsl:param name="is-complete" />
    
    <xsl:choose>
      <xsl:when test="@type!='ContentDetail'">
        <xsl:element name="ContentDetail">
          <xsl:attribute name="placeholder" select="if ($is-complete) then 'false' else 'true'"/>
          <xsl:call-template name="content-details-PMT-sub">
            <xsl:with-param name="product" select="$product"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="content-details-PMT-sub">
          <xsl:with-param name="product" select="$product"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="content-details-PMT-sub">
    <xsl:param name="product"/>
    
    <xsl:element name="Description">
      <xsl:value-of select="TextDescription" />
    </xsl:element>
    <xsl:element name="Size"/>
    <xsl:element name="ContentType">
      <xsl:attribute name="authorizationContentType" select="'PMT_Raw'" />
      <xsl:value-of select="pms-f:get-contentType-for-columnId(@columnID)" />
    </xsl:element>
    <xsl:element name="Publisher">
      <xsl:attribute name="accountID"/>
    </xsl:element>
    <xsl:element name="PublicationDate">
      <xsl:value-of select="$product/MasterData/LastPMTPublishdate" />
    </xsl:element>
    <xsl:element name="Language" />
    <xsl:element name="UploadURL">
      <xsl:value-of select="pms-f:build-pmt-edit-url($pmt-edit-url, $product/MasterData/CTN)" />
    </xsl:element>
    <xsl:element name="PreviewURL">
      <xsl:value-of select="pms-f:build-pmt-preview-url($pmt-preview-url, $product/MasterData/CTN)" />
    </xsl:element>
    <xsl:element name="DownloadURL" />
    <xsl:element name="ThumbnailURL" />
    <xsl:element name="MediumImageURL" />
  </xsl:template>

  <!--
    Create ContentDetails for a SUP.DFU.
    Context is node itself.
  -->
  <xsl:template name="content-details-dfu">
    <xsl:param name="prd"/>
    <xsl:param name="productType"/>
    
    <xsl:variable name="node" select="."/>    

    <!-- ContentDetails for existing DFU assets -->
    <xsl:for-each select="$prd/EvaluationData/Assets/Asset[@ResourceType='DFU']">
      <xsl:apply-templates select="." mode="content-detail">
        <xsl:with-param name="column-id" select="concat($node/../@columnID,'.',@Language)" />
        <xsl:with-param name="status-alert">
          <StatusAlert>
            <CompleteFlag>
              <xsl:text>1</xsl:text>
            </CompleteFlag>
          </StatusAlert>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:for-each>
    
    <!-- ContentDetails for missing locales -->
    <xsl:variable name="requiredStr" select="Requirements/@*[local-name()=$productType]" />
    <xsl:for-each select="$prd/EvaluationData/Catalogs/Catalog/Locale">
      <xsl:variable name="locale-id" select="@id"/>
      <xsl:if test="empty($prd/EvaluationData/Assets/Asset[@ResourceType='DFU'][@Language=$locale-id])">
        <xsl:variable name="status-alert">
          <xsl:element name="StatusAlert">
            <xsl:element name="CompleteFlag">
              <xsl:text>0</xsl:text>
            </xsl:element>
            <xsl:element name="Label">
              <xsl:variable name="map">
                <param name="locale" value="{@name}"/>
              </xsl:variable>
              <xsl:value-of select="pms-f:fill-placeholders($node/DescriptionOnError, $map)"/>
            </xsl:element>
          </xsl:element>
        </xsl:variable>
        
        <xsl:variable name="milestone-config" select="$node/Date[@type='t2']" />
        <xsl:variable name="milestone-date" select="pms-f:get-milestone-date($milestone-config/@milestone, $prd, ../@country, $locale-id, ())" />
        <xsl:variable name="due-date" select="substring-before(pms-f:date-add($milestone-date, $milestone-config/@offset), 'T')" />
        
        <xsl:variable name="empty-asset">
          <Asset id="{$prd/MasterData/CTN}"
                 ResourceType="DFU"
                 Language="{$locale-id}"
                 DueDate="{$due-date}"
                 Description="{$doctypes-attr/doctype[@code='DFU']/@description}"
                >
          </Asset>
        </xsl:variable>
        <xsl:apply-templates select="$empty-asset" mode="content-detail">
          <xsl:with-param name="is-placeholder" select="true()"/>
          <xsl:with-param name="column-id" select="concat($node/../@columnID,'.',$locale-id)"/>
          <xsl:with-param name="status-alert" select="$status-alert"/>
        </xsl:apply-templates>
        
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
