<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
  <!-- -->
  <xsl:variable name="CemafoorGreenData" select="/entry/content/GreenData"/>
  <xsl:variable name="PfsGreenData" select="/entry/content/Product/GreenData"/>
  <!-- Merge the GreenData from PFS (in the Product/GreenData-element)
     | with the GreenData from Cemafoor (in the /entry/content/GreenData-element)  
     |-->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- 
     | only match GreenData-elements that are a child of the Product-element.
     -->
  <xsl:template match="Product/GreenData">    
    <xsl:if test="$CemafoorGreenData | $PfsGreenData">
      <GreenData>
        <xsl:apply-templates select="node()"/>
      </GreenData>
    </xsl:if>   
  </xsl:template>
  
  <!-- -->
  <xsl:template match="PhilipsGreenLogo">
     <PhilipsGreenLogo>
      <xsl:choose>
		<xsl:when test="@publish='true' and $CemafoorGreenData[node()]">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="$CemafoorGreenData/PhilipsGreenLogo/@*"/>
            <xsl:if test="$CemafoorGreenData/PhilipsGreenLogo/@isGreenProduct='true'">
            <!-- TODO: make more generic !!!
               <xsl:apply-templates select="$CemafoorGreenData/*[name()=current(name())]/@*"/>
               -->
               <xsl:apply-templates select="*[ends-with(name(.), 'Description') or name(.)=('Name', 'Text', 'Code')]"/>
               <xsl:apply-templates select="$CemafoorGreenData/PhilipsGreenLogo/node()"/>
            </xsl:if>
        </xsl:when>
        <xsl:when test="@publish='true' and $PfsGreenData/PhilipsGreenLogo/@isGreenProduct='true'">            
            <xsl:apply-templates select="$PfsGreenData/PhilipsGreenLogo/@*"/>             
            <!-- TODO: make more generic !!!
               <xsl:apply-templates select="$PfsGreenData/*[name()=current(name())]/@*"/>
               -->
            <xsl:apply-templates select="*[ends-with(name(.), 'Description') or name(.)=('Name', 'Text', 'Code')]"/>            
        </xsl:when>
        <xsl:otherwise> 
           <xsl:attribute name="publish" select="'false'"/>
        </xsl:otherwise>   
      </xsl:choose>
     </PhilipsGreenLogo>
  </xsl:template>
  
  <!--+
      | Copy the EnergyLabel/EcoFlower/BlueAngel and the
      | ApplicableFor elements as well.
      | For EnergyLabel strip the PFS-supplied EnergyClasses element, they are
      | not used.
      +-->
  <xsl:template match="EnergyLabel">
    <xsl:call-template name="mergeGreenAward">
      <xsl:with-param name="greenElementName">EnergyLabel</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="EcoFlower">
    <xsl:call-template name="mergeGreenAward">
      <xsl:with-param name="greenElementName">EcoFlower</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="BlueAngel">
    <xsl:call-template name="mergeGreenAward">
      <xsl:with-param name="greenElementName">BlueAngel</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <!--+
      | Replace the Cemafoor Code element with the value coming from PFS because
      | Cemafoor does not have ownership over the asset name in de Code element.
      +-->
  <xsl:template name="mergeCemafoorApplicableFor">
    <xsl:param name="pfsCode"/>
    <xsl:element name="ApplicableFor">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="exists($pfsCode)">
          <xsl:copy-of select="$pfsCode"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="Code"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[not(name(.)='Code')]"/>
    </xsl:element>
  </xsl:template>
  
  <!--+
      | The generic template for merging GreenAward-type elements from Cemafoor
      | (GreenData) and PFS. Take over all attributes, but leave the elements
      | unless we will publish.
      +-->
    
    <xsl:template name="mergeGreenAward">
    <xsl:param name="greenElementName"/>
    <xsl:variable name="cemafoorAward" select="$CemafoorGreenData/*[name(.)=$greenElementName]"/>
	<xsl:variable name="PfsGreenDataAward" select="$PfsGreenData/*[name(.)=$greenElementName]"/>
	
    <xsl:variable name="pfsCode" select="Code"/>
    <xsl:element name="{$greenElementName}">
      <xsl:choose>
        <!-- Only copy the award content if it applies in at least one country -->
        <xsl:when test="@publish='true' and exists($cemafoorAward/ApplicableFor[1])">
          <xsl:apply-templates select="@*"/>
          <xsl:apply-templates select="$cemafoorAward/@*"/>
          <xsl:apply-templates select="*[ends-with(name(.), 'Description')]|Name|Text|Code"/>
          <!--+
              | Merge ApplicableFor if it is available and provide any Code
              | element of the PFS data.
              +-->
          <xsl:for-each select="$cemafoorAward/ApplicableFor">
            <xsl:call-template name="mergeCemafoorApplicableFor">
              <xsl:with-param name="pfsCode" select="$pfsCode"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
		<xsl:when test="@publish='true' and exists($PfsGreenDataAward/ApplicableFor[1])">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="$PfsGreenDataAward/@*"/>
			<xsl:apply-templates select="*[ends-with(name(.), 'Description')]|Name|Text|Code"/>
			<!--+
              | Merge ApplicableFor if it is available and provide any Code
              | element of the PFS data.
              +-->		  
          <xsl:for-each select="$PfsGreenDataAward/ApplicableFor">
            <xsl:call-template name="mergeCemafoorApplicableFor">
              <xsl:with-param name="pfsCode" select="$pfsCode"/>
            </xsl:call-template>
          </xsl:for-each>
		</xsl:when>
        <xsl:otherwise>
           <xsl:attribute name="publish" select="'false'"/>
        </xsl:otherwise>
      </xsl:choose>
     </xsl:element>
  </xsl:template>

  <!--+
      | Merge the Eco Passport Areas of PFS and Cemafoor's GreenData.
      | Ignore GreenChapters if GreenData/@showEcoPassport='false'
      +-->
  <xsl:template match="GreenChapter[../@showEcoPassport='false']"/>
  <xsl:template match="GreenChapter">
    <xsl:variable name="cemafoorCounterPart" select="$CemafoorGreenData/GreenChapter[GreenChapterName=current()/GreenChapterName]"/>
    <!-- Skip any item-less chapters -->
    <xsl:if test="count(GreenItem) + count($cemafoorCounterPart/GreenItem) &gt; 0">
      <GreenChapter>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="$cemafoorCounterPart/@*"/>
        <xsl:apply-templates select="node()[name() != 'GreenItem']"/>
        <xsl:apply-templates select="$cemafoorCounterPart/node()[not(name() = ('GreenChapterName', 'GreenItem'))]"/>
        <!-- Copy the GreenItems starting with PFS, then GIM. Give all items a rank attribute -->
        <xsl:for-each select="GreenItem|$cemafoorCounterPart/GreenItem">
          <xsl:element name="{./name()}">
            <xsl:apply-templates select="@*"/>
            <!-- Filter out GreenItemCode - it will not be used. -->
            <xsl:apply-templates select="GreenItemName"/>
            <xsl:element name="GreenItemRank">
              <xsl:value-of select="position()"/>
            </xsl:element>
            <xsl:apply-templates select="GreenValue"/>
            <xsl:apply-templates select="UnitOfMeasure"/>
          </xsl:element>
        </xsl:for-each>
      </GreenChapter>
    </xsl:if>
  </xsl:template>
  <xsl:template match="/entry/content/GreenData"/>
</xsl:stylesheet>
