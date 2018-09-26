<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0">
  
  <xsl:import href="../service-base.xsl"/>
  <xsl:import href="../em-product-templates.xsl"/>

  <!-- Deeplink URLs, specific to the environment (DEV, QA/UAT, PROD) -->
  <xsl:param name="asset-edit-url" select="substring-before(., '?')"/>
  <xsl:param name="pmt-edit-url" select="substring-before(., '?')"/>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
 
  <xsl:template match="ContentDetail[@placeholder = 'false']">
    <xsl:element name="ContentDetail">
      <xsl:attribute name="placeholder" select="@placeholder"/>
      <xsl:if test="@calcType">
        <xsl:attribute name="calcType" select="@calcType"/>
      </xsl:if>
      <xsl:if test="@columnID">
        <xsl:attribute name="columnID" select="@columnID"/>
      </xsl:if>  
      <xsl:apply-templates/>      
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="ContentDetail[@placeholder = 'true']">
    <xsl:variable name="columnID" select="../../@columnID"/>
    <xsl:variable name="completeFlag" select="//sql:row[sql:columnid = $columnID]/sql:complete_flag"/>
    
    <xsl:if test="(svc:contenttype-allowed($uap, ContentType/@authorizationContentType) 
                   and 
                   (($completeFlag = '1') or (empty($completeFlag))))
                   or 
                   ($completeFlag = '0')
                 ">
      <xsl:element name="ContentDetail">
        <xsl:attribute name="placeholder" select="@placeholder"/>
        <xsl:if test="@calcType">
          <xsl:attribute name="calcType" select="@calcType"/>
        </xsl:if>
        <xsl:if test="@columnID">
          <xsl:attribute name="columnID" select="@columnID"/>
        </xsl:if>
        
        <xsl:apply-templates/>      
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="UploadURL">
    <xsl:element name="UploadURL">
      <xsl:variable name="content-type" select="../ContentType/@authorizationContentType"/>
    
      <xsl:choose>
        <!-- PFS accesss rights are based on subcategories, CCR access rights on doctypes -->
        <xsl:when test="../ContentType/@authorizationContentType = 'PMT_Raw'">
          <xsl:if test="svc:pfs-deeplink-allowed($uap, //Categorization/SubCategory/@code)">
            <xsl:value-of select="concat(substring-before($pmt-edit-url, '?'), '?', substring-after(., '?'))"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="svc:contenttype-allowed($uap, $content-type)"> 
            <xsl:value-of select="concat(substring-before($asset-edit-url, '?'), '?', substring-after(., '?'))"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ContentType">
    <xsl:element name="ContentType">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="OpenInPFS_URL">
    <xsl:if test="svc:subcat-allowed($uap, //Categorization/SubCategory/@code)">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="OpenInCCRUW_URL">
    <xsl:if test="svc:authorizations-allowed($uap, 'CCR')">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
