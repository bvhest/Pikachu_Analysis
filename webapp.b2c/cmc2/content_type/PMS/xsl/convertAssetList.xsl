<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:pms-f="http://www.philips.com/pika/pms/1.0">
  
  <xsl:import href="pms.functions.xsl" />
  <xsl:include href="pmsBase.xsl"/>
  
  <xsl:param name="pmt-preview-url"/>
  <xsl:param name="pmt-edit-url"/>
  <xsl:param name="asset-edit-url"/>

  <xsl:variable name="doctypes" select="document('../../../xml/doctype_attributes.xml')/doctypes"/>
  
  <!-- Index for fast lookups of code attribute -->
  <xsl:key name="doctypes-code-idx" match="doctype" use="@code" />
  
  <xsl:template match="sql:rowset"/>
  
  <xsl:template match="EvaluationData/Assets">
    <xsl:copy copy-namespaces="no">
      <!-- Global assets + Localized assets -->
      <!--
      <xsl:for-each-group select="Asset|ancestor::content/sql:rowset[@name='ProductAssets']/sql:row/sql:data/object/Asset"
                          group-by="concat(ResourceType,Language)">
        <xsl:apply-templates select="current-group()[1]"/>
      </xsl:for-each-group>
      -->
      <xsl:apply-templates select="Asset|ancestor::content/sql:rowset[@name='ProductAssets']/sql:row/sql:data/object/Asset">
        <xsl:sort select="Language"/>
        <xsl:with-param name="ctn" select="ancestor::Product/MasterData/CTN"/>
      </xsl:apply-templates>
    </xsl:copy>
    
  </xsl:template>

  <xsl:template match="EvaluationData/ObjectAssets">
    <xsl:copy copy-namespaces="no">
      <!-- Global assets + Localized assets -->
      <!--
      <xsl:for-each-group select="Asset|ancestor::content/sql:rowset[@name='FeatureAssets']/sql:row/sql:data/object/Asset"
                          group-by="concat(ResourceType,Language)">
        <xsl:apply-templates select="current-group()[1]"/>
      </xsl:for-each-group>
      -->
      <xsl:apply-templates select="Asset|ancestor::content/sql:rowset[@name='FeatureAssets']/sql:row/sql:data/object/Asset">
        <xsl:sort select="Language"/>
        <xsl:with-param name="ctn" select="ancestor::Product/MasterData/CTN"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Asset">
    <xsl:param name="ctn"/>
    
    <xsl:copy copy-namespaces="no">
      <xsl:variable name="id" select="if (Id != '') then Id else ../id"/>
      <xsl:attribute name="id" select="$id"/>
      <xsl:apply-templates select="ResourceType|Language|Extent|Creator" mode="element-to-attribute"/>
      <xsl:variable name="doctype-desc" select="key('doctypes-code-idx', ResourceType, $doctypes)/@description"/>
      <xsl:choose>
        <xsl:when test="$id=$ctn">
          <!-- Product related asset -->
          <xsl:attribute name="Description" select="$doctype-desc"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Feature related asset -->
          <xsl:variable name="feature" select="ancestor::content/Product/EvaluationData/Text/KeyBenefitArea/Feature[FeatureCode=$id]" />
          <xsl:attribute name="Description" select="if ($feature) then concat($doctype-desc, ' | ', $feature/FeatureReferenceName) else $doctype-desc" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:attribute name="Master" select="key('doctypes-code-idx', ResourceType, $doctypes)/@master"/>
      <xsl:attribute name="Thumbnail" select="key('doctypes-code-idx', ResourceType, $doctypes)/@Thumbnail" />
      <xsl:attribute name="Preview" select="key('doctypes-code-idx', ResourceType, $doctypes)/@Preview" />
      <xsl:attribute name="Medium" select="key('doctypes-code-idx', ResourceType, $doctypes)/@Medium" />
      <xsl:attribute name="Url" select="InternalResourceIdentifier/text()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="element()" mode="element-to-attribute">
    <xsl:attribute name="{local-name()}" select="text()" />
  </xsl:template>  
</xsl:stylesheet>
