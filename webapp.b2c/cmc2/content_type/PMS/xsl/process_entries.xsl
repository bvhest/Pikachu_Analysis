<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:cmc2-f="http://www.philips.com/cmc2-f"
                extension-element-prefixes="cmc2-f"
                >

  <xsl:import href="../../../xsl/common/cmc2.function.xsl"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- process octl attributes -->
  <xsl:template match="octl-attributes[../@valid='true']">
    <xsl:copy>
      <xsl:apply-templates
        select="@*|node()[not(local-name()='masterlastmodified_ts' or local-name()='status' or local-name()='marketingversion')]" />
      <xsl:element name="masterlastmodified_ts">
        <xsl:value-of select="lastmodified_ts" />
      </xsl:element>
      <xsl:element name="status">
        <xsl:value-of select="if (../content/Product/@is-deleted='true') then 'Deleted' else 'Loaded'" />
      </xsl:element>
      <xsl:element name="marketingversion">
        <xsl:value-of select="'1.0'" />
      </xsl:element>
    </xsl:copy>
  </xsl:template>
  
  <!-- create DB queries -->
  <xsl:template match="process[../@valid='true'][../content/Product/@is-deleted='false']">
    <xsl:copy>
      <xsl:variable name="eval-data" select="../content/Product/EvaluationData"/>
      <xsl:variable name="ctn" select="$eval-data/MasterData/CTN"/>
      <xsl:variable name="SearchText" select="cmc2-f:escape-sql(string-join( ($eval-data/MasterData/CTN
                                                                            , $eval-data/MasterData/NamingStringShort
                                                                            , $eval-data/Text/WOW
                                                                            , $eval-data/Text/SubWOW
                                                                            , $eval-data/Text/MarketingTextHeader)
                                                                           , '|')
                                                               , false())"/>
      <xsl:variable name="completedAlertsItems"   select="../content/Product/Content//ContentItem[StatusAlert/CompleteFlag=1]/@columnID" />
      <xsl:variable name="completedAlertsDetails" select="../content/Product/Content//ContentDetail[StatusAlert/CompleteFlag=1]/@columnID" />
      <xsl:variable name="completedAlertsInternal" select="../content/Product/Content//Internal[StatusAlert/CompleteFlag=1]/@columnID" />
      <xsl:variable name="completedAlerts"        select="string-join(($completedAlertsItems, $completedAlertsInternal, $completedAlertsDetails), ',')" />
      <xsl:variable name="totalIncomplete"    select="count(../content/Product/Content/ContentCategory//*[StatusAlert/CompleteFlag=0])"/>
      <xsl:variable name="pendingTranslations"        select="string-join(../content/Product/Countries/Country/Locales/Locale/PendingTranslations/PendingTranslation/@columnID, ',')" />
      <xsl:variable name="SAPDate"            select="$eval-data/MasterData/SAPPublishDate" />
      <xsl:variable name="CRDate"             select="$eval-data/MasterData/CRDate" />
      <xsl:variable name="LastPMTPublishdate" select="$eval-data/MasterData/LastPMTPublishdate" />
      <xsl:variable name="edCopyDate"         select="$eval-data/MasterData/PMTEditCopy/CreateDate" />
      <xsl:variable name="signingDate"        select="$eval-data/MasterData/PMTEditCopy/InSigningDate" />
  
      <query isstoredprocedure="true">
DECLARE
   t_incompleteAlerts    pms_descrOnError_tab_type := pms_descrOnError_tab_type();
BEGIN
   -- initialise and fill collection with incomplete alerts:
   <xsl:if test="$totalIncomplete > 0">
   t_incompleteAlerts.extend(<xsl:value-of select="$totalIncomplete"/>);
   </xsl:if>
   <xsl:for-each select="../content/Product/Content/ContentCategory//*[StatusAlert/CompleteFlag=0]">
   t_incompleteAlerts(<xsl:value-of select="position()" />) := pms_alert_descr_type('<xsl:value-of select="@columnID"/>','<xsl:value-of select="cmc2-f:escape-sql(StatusAlert/Label, false())"/>');
   </xsl:for-each>

   -- purpose: create/update product and alert data (including calculating the alert-rank).
   -- nb. pass named (instead of positional) parameters!
   PMS.create_alerts(p_ctn                 => '<xsl:value-of select="$ctn"/>'
                   , p_marketingclass      => '<xsl:value-of select="$eval-data/MasterData/MarketingClass"/>'
                   , p_brand               => '<xsl:value-of select="$eval-data/MasterData/MasterBrand"/>'
                   , p_sap_date            => <xsl:choose><xsl:when test="$SAPDate!=''">to_date('<xsl:value-of select="$SAPDate"/>','yyyy-mm-dd')</xsl:when><xsl:otherwise><xsl:text>NULL</xsl:text></xsl:otherwise></xsl:choose>
                   , p_cr_date             => <xsl:choose><xsl:when test="$CRDate!=''">to_date('<xsl:value-of select="$CRDate"/>','yyyy-mm-dd')</xsl:when><xsl:otherwise><xsl:text>NULL</xsl:text></xsl:otherwise></xsl:choose>
                   , p_master_date         => <xsl:choose><xsl:when test="$LastPMTPublishdate!=''">to_date('<xsl:value-of select="$LastPMTPublishdate"/>','yyyy-mm-dd')</xsl:when><xsl:otherwise><xsl:text>NULL</xsl:text></xsl:otherwise></xsl:choose>
                   , p_edcopy_date         => <xsl:choose><xsl:when test="$edCopyDate!=''">to_date('<xsl:value-of select="$edCopyDate"/>','yyyy-mm-dd')</xsl:when><xsl:otherwise><xsl:text>NULL</xsl:text></xsl:otherwise></xsl:choose>
                   , p_signing_date        => <xsl:choose><xsl:when test="$signingDate!=''">to_date('<xsl:value-of select="$signingDate"/>','yyyy-mm-dd')</xsl:when><xsl:otherwise><xsl:text>NULL</xsl:text></xsl:otherwise></xsl:choose>
                   , p_lastmodified_date   => to_date('<xsl:value-of select="../octl-attributes/lastmodified_ts"/>','yyyy-mm-dd"T"hh24:mi:ss')
                   , p_searchtext          => '<xsl:value-of select="$SearchText"/>' 
                   , p_namingstringshort   => '<xsl:value-of select="$eval-data/MasterData/NamingStringShort"/>'
                   , p_owner               => '<xsl:value-of select="$eval-data/MasterData/ProductOwner/@accountID"/>'
                   , p_pmtversion          => '<xsl:value-of select="$eval-data/MasterData/PMTVersion"/>'
                   , p_thumbnail_url       => '<xsl:value-of select="../content/Product/ThumbnailURL"/>'
                   , p_mediumimage_url       => '<xsl:value-of select="../content/Product/MediumImageURL"/>'
                   , p_preview_url         => '<xsl:value-of select="../content/Product/PreviewURL"/>'
                   , p_complete_alerts     => <xsl:choose><xsl:when test="$completedAlerts!=''">'<xsl:value-of select="$completedAlerts"/>'</xsl:when><xsl:otherwise><xsl:text>NULL</xsl:text></xsl:otherwise></xsl:choose>
                   , p_pendingTranslations => <xsl:choose><xsl:when test="$pendingTranslations!=''">'<xsl:value-of select="$pendingTranslations"/>'</xsl:when><xsl:otherwise><xsl:text>NULL</xsl:text></xsl:otherwise></xsl:choose>
                   , p_alert_descriptions  => t_incompleteAlerts
                   );
EXCEPTION
   WHEN SUBSCRIPT_BEYOND_COUNT THEN
      RAISE_APPLICATION_ERROR(-20010, 'Collection t_incompleteAlerts initialised with wrong size: check $totalIncomplete');      
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20011, 'Call to PMS.create_alerts failed with '||SUBSTR(sqlerrm,1,2016));      
END;
      </query>
      <!-- Copy any other queries -->
      <xsl:apply-templates select="query"/>
    </xsl:copy>
  </xsl:template>  

  <!-- Deleted PMS_Raw product -->
  <xsl:template match="process[../@valid='true'][../content/Product/@is-deleted='true']">
    <xsl:copy>
      <xsl:variable name="ctn" select="../@o"/>
      <query isstoredprocedure="true">
BEGIN
   UPDATE pms_alerts
      SET deleted_flag = 1
    WHERE ctn = '<xsl:value-of select="$ctn"/>' 
      AND EXISTS (
        SELECT 1 FROM PMS_PRODUCTS WHERE ctn='<xsl:value-of select="$ctn"/>'
        AND lastmodified_ts &lt; to_date('<xsl:value-of select="../octl-attributes/lastmodified_ts"/>', 'YYYY-MM-DD"T"HH24:MI:SS')
      );
   
   UPDATE pms_categories 
      SET deleted_flag = 1 
        , lastmodified_ts = to_date('<xsl:value-of select="../octl-attributes/lastmodified_ts"/>', 'YYYY-MM-DD"T"HH24:MI:SS')
    WHERE ctn = '<xsl:value-of select="$ctn"/>' 
      AND lastmodified_ts &lt; to_date('<xsl:value-of select="../octl-attributes/lastmodified_ts"/>', 'YYYY-MM-DD"T"HH24:MI:SS');
   
   UPDATE pms_products 
      SET deleted_flag = 1 
        , lastmodified_ts = to_date('<xsl:value-of select="../octl-attributes/lastmodified_ts"/>', 'YYYY-MM-DD"T"HH24:MI:SS')
    WHERE ctn = '<xsl:value-of select="$ctn"/>' 
      AND lastmodified_ts &lt; to_date('<xsl:value-of select="../octl-attributes/lastmodified_ts"/>', 'YYYY-MM-DD"T"HH24:MI:SS');
      
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20011, 'Logical deletion in the database of deleted product failed with '||SUBSTR(sqlerrm,1,2000));      
END;
      </query>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
