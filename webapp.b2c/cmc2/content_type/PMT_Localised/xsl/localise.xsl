<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:saxon="http://saxon.sf.net/" xmlns:my="http://www.philips.com/pika"  xmlns:xs="http://www.w3.org/2001/XMLSchema" extension-element-prefixes="my">
  <!-- -->
  <xsl:param name="l"/>
  <xsl:param name="xmlDir"/>
  <!-- -->
  <xsl:variable name="country" select="substring-after($l, 'master_')"/>
  <xsl:variable name="bdebug" select="false()"/>
  <xsl:variable name="config" select="document(concat($xmlDir,'translated_attributes.xml'))"/>
  <xsl:variable name="product" select="/entry/content/Product"/>

  <!--+
      |
      |  LET'S LOCALIZE !!!
      |
      +-->

  <!-- -->
  <xsl:function name="my:replace">
    <xsl:param name="localizations-for-this-node"/>
    <xsl:param name="usinglocalization"/>
    <xsl:param name="instring"/>
    <xsl:variable name="result" select="if($instring = '') then ''
                                        else replace($instring,$localizations-for-this-node/replace[$usinglocalization]/masterstring,$localizations-for-this-node/replace[$usinglocalization]/localizedstring)"/>
    <xsl:choose>
      <xsl:when test="$localizations-for-this-node/replace[$usinglocalization+1]"><xsl:value-of select="my:replace($localizations-for-this-node,$usinglocalization+1,$result)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$result"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <!-- -->
  <xsl:function name="my:localizetext">
    <xsl:param name="path2node"/>
    <xsl:param name="applicablelocalizations"/>
    <xsl:param name="usinglocalization"/>
    <xsl:param name="instring" as="xs:string"/>
    <xsl:param name="parentnode"/>
    <xsl:param name="nodes2replace-unique-ids"/>
    <xsl:variable name="parentnode-uniqueid"><xsl:value-of select="generate-id($parentnode)"/></xsl:variable>
    <xsl:variable name="final-result">
      <xsl:choose>
        <xsl:when test="not($parentnode-uniqueid = $nodes2replace-unique-ids/replace/gid)">
           <!-- this node is not to be localized -->
          <xsl:value-of select="$instring"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="stringtoreplace" select="$applicablelocalizations/Localization[$usinglocalization]/MasterString"/>
          <xsl:variable name="replacement"     select="$applicablelocalizations/Localization[$usinglocalization]/LocalizedString"/>
          <xsl:variable name="result" select="if($replacement!='') then replace($instring,$stringtoreplace,$replacement) else $instring"/>
          <xsl:variable name="localizations-for-this-node">
            <xsl:for-each select="$nodes2replace-unique-ids/replace[gid = $parentnode-uniqueid]">
              <replace><xsl:copy-of select="node()"/></replace>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="result" select="if($instring = '') then '' else my:replace($localizations-for-this-node,1,$instring)"/>
          <xsl:choose>
            <!-- Is there a maxlength in translated_attributes.xml for this element? -->
            <xsl:when test="not(exists($config/root/translatedAttribute[@path=$path2node]))">
              <!-- No -->
              <xsl:value-of select="$result"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- Yes.  Check it. -->
              <xsl:variable name="maxlen" select="number($config/root/translatedAttribute[@path=$path2node][1]/metaAttributes/@maxlength) idiv 1.3"/>
              <xsl:value-of select="if(string-length($result) le $maxlen or $instring = $result) then $result else concat('**ERROR**',$maxlen,'**',string-length($result),'**',$instring,'**',$result)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$final-result"/>
  </xsl:function>
  
  <!--+
      | Wether or not the product has any country-specific green awards.
      +-->
  <xsl:function name="my:hasGreenAward">
    <xsl:param name="greenAward"/>
    <xsl:value-of select="$greenAward/ApplicableFor/Countrycode=$country"/>
  </xsl:function>
  
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()" mode="copyunlocalized">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="copyunlocalized"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="attribute::IsLocalized" mode="copyunlocalized"/>
  <!-- -->
  <xsl:template match="node()/text()[starts-with(.,'**UNCHANGED**')]" mode="copyunlocalized">
    <xsl:value-of select="substring-after(.,'**UNCHANGED**')"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="element()[@localized='1' and starts-with(text(),'**UNCHANGED**')]/@localized"  mode="copyunlocalized"/>
  <!-- -->
  <xsl:template match="@*|node()" mode="copylocalized">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="copylocalized"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="node()[@delete=1]" mode="copylocalized"/>
  <!-- -->
  <xsl:template match="node()/text()[starts-with(.,'**UNCHANGED**')]" mode="copylocalized">
    <xsl:value-of select="substring-after(.,'**UNCHANGED**')"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="attribute::localized[starts-with(../text(),'**UNCHANGED**')]" mode="copylocalized"/>
  <!-- -->
  <xsl:template match="entry">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()='valid')]"/>
      <xsl:attribute name="ctn" select="$product/CTN"/>
      <xsl:variable name="content">
        <xsl:apply-templates select="content"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$content/Product/@IsLocalized!='true'">
          <xsl:copy-of select="@valid"/>
          <xsl:copy-of select="result"/>
          <xsl:copy-of select="$content"/>
          <xsl:apply-templates select="node()[not(local-name()=('result','content'))]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$content//text()[starts-with(.,'**ERROR**')]">
              <xsl:attribute name="valid" select="'false'"/>
              <result>
                <xsl:for-each select="$content//node()[starts-with(.,'**ERROR**')]">
                  <error>
                    <xsl:copy-of select="."/>
                  </error>
                </xsl:for-each>
              </result>
              <xsl:apply-templates select="node()[not(local-name()=('result','content'))]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="@valid"/>
              <xsl:copy-of select="result"/>
              <xsl:variable name="hasGreenAward" select="my:hasGreenAward($content/content/Product/GreenData/*[name()=('EnergyLabel','BlueAngel','EcoFlower')])=true()"/>
              <xsl:choose>
                <xsl:when test="not($hasGreenAward or $content//element()[(@delete='1') or (element()[@localized='1' and not(starts-with(text(),'**UNCHANGED**'))])])">
                  <!-- No changes made.  Copy the 'localized' content but skip the IsLocalized attribute -->
                  <xsl:apply-templates select="$content" mode="copyunlocalized"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- Has been localized. Copy the localized content but skip deleted nodes -->
                  <xsl:apply-templates select="$content" mode="copylocalized"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:apply-templates select="node()[not(local-name()=('result','content'))]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Product">
    <xsl:variable name="ctn" select="CTN"/>
    <!-- Is this OCTL to be localized or not? -->
    <!-- First, check secondary content - Localizations -->
    <xsl:variable name="localizations" select="../sql:rowset[@name='secondarycontent']/sql:row[sql:content_type='Localization']/sql:data/Localization[Active='YES'][contains(SubCategory,current()/../sql:rowset[@name='subcat']/sql:row/sql:subcategory)][Country=substring-after($l,'master_')]"/>
    <!-- Next, check the CTNMask -->
    <xsl:variable name="applicablelocalizations">
      <xsl:for-each select="$localizations">
        <xsl:if test="CTNMask='' or matches($ctn,replace(replace(CTNMask,'\*','.*'),'\?','.'))">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <!-- All Localizations that apply to this product are now in $applicablelocalizations -->
    <xsl:variable name="hasGreenAward" select="my:hasGreenAward(./GreenData/*[name()=('EnergyLabel','BlueAngel','EcoFlower')])=true()"/>
    <xsl:variable name="isLocalized" select="$hasGreenAward or $applicablelocalizations[1]!=''"/>
    <!-- Put all nodes to remove in a variable -->
    <xsl:variable name="nodes2remove-unique-ids">
      <xsl:for-each select="$applicablelocalizations/Localization[Action = 'REMOVE'][ProductNode2Remove!='']">
        <xsl:variable name="xpath" select="."/>
        <xsl:for-each select="$product/saxon:evaluate($xpath/ProductNode2Remove)">
          <gid><xsl:value-of select="generate-id(.)"/></gid>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <!-- Put all nodes to string-replace in a variable -->
    <xsl:variable name="nodes2replace-unique-ids">
      <xsl:for-each select="$applicablelocalizations/Localization[Action = 'REPLACE'][ProductNode2Replace!='']">
        <xsl:variable name="xpath" select="."/>
        <xsl:for-each select="$product/saxon:evaluate($xpath/ProductNode2Replace)"> 
          <xsl:if test="normalize-space(text()[1])!=''">
            <replace>
              <gid><xsl:value-of select="generate-id(.)"/></gid>
              <masterstring><xsl:value-of select="$xpath/MasterString"/></masterstring>
              <localizedstring><xsl:value-of select="$xpath/LocalizedString"/></localizedstring>
            </replace>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <!-- Go -->
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="IsLocalized" select="$isLocalized"/>
      <xsl:choose>
        <xsl:when test="$isLocalized">
          <xsl:if test="$bdebug">
            <nodes2remove-unique-ids><xsl:copy-of select="$nodes2remove-unique-ids"/></nodes2remove-unique-ids>
            <nodes2remove><xsl:copy-of select="$applicablelocalizations/Localization[Action = 'REMOVE']"/></nodes2remove>
            <nodes2replace-unique-ids><xsl:copy-of select="$nodes2replace-unique-ids"/></nodes2replace-unique-ids>
            <nodes2replace><xsl:copy-of select="$applicablelocalizations/Localization[Action = 'REPLACE']"/></nodes2replace>
          </xsl:if>
          <xsl:apply-templates select="node()" mode="localize">
            <xsl:with-param name="applicablelocalizations" select="$applicablelocalizations"/>
            <xsl:with-param name="nodes2remove-unique-ids" select="$nodes2remove-unique-ids"/>
            <xsl:with-param name="nodes2replace-unique-ids" select="$nodes2replace-unique-ids"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:rowset"/>
  <!-- -->
  <xsl:template match="element()|@*" mode="localize">
    <xsl:param name="applicablelocalizations"/>
    <xsl:param name="nodes2remove-unique-ids"/>
    <xsl:param name="nodes2replace-unique-ids"/>
    <xsl:variable name="thisnode-uniqueid"><xsl:value-of select="generate-id(.)"/></xsl:variable>
    <!-- -->
    <xsl:choose>
      <xsl:when test="$thisnode-uniqueid = $nodes2remove-unique-ids/gid">
        <!-- Flag for removal -->
        <xsl:copy>
          <xsl:attribute name="delete" select="1"/>
          <xsl:copy-of select="."/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy copy-namespaces="no">
          <xsl:if test="$thisnode-uniqueid = $nodes2replace-unique-ids/replace/gid">
            <!-- Add attribute -->
            <xsl:attribute name="localized" select="1"/>
          </xsl:if>
          <xsl:if test="$bdebug"><xsl:attribute name="gid" select="$thisnode-uniqueid"/></xsl:if>
          <xsl:apply-templates select="node()|@*" mode="localize">
            <xsl:with-param name="applicablelocalizations" select="$applicablelocalizations"/>
            <xsl:with-param name="nodes2remove-unique-ids" select="$nodes2remove-unique-ids"/>
            <xsl:with-param name="nodes2replace-unique-ids" select="$nodes2replace-unique-ids"/>
          </xsl:apply-templates>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="text()" mode="localize">
    <xsl:param name="applicablelocalizations"/>
    <xsl:param name="nodes2replace-unique-ids"/>
    <!-- Establish the path to the node starting from but not including the Product element.  I.e. at least 4 parent-levels -->
    <xsl:variable name="path2node" select="string-join(ancestor-or-self::*[../../../..]/name(.), '/')"/>
    <xsl:variable name="parentnode" select=".."/>
    <xsl:variable name="result"><xsl:value-of select="if(normalize-space(.)!='') then my:localizetext($path2node,$applicablelocalizations,1,.,$parentnode,$nodes2replace-unique-ids) else ."/></xsl:variable>
    <xsl:value-of select="if(normalize-space(.)='') then . else if($result != .) then $result else concat('**UNCHANGED**',.)"/>
  </xsl:template>
  <!-- -->
  <!-- only include RichTexts for selected countries -->
  <xsl:template match="RichTexts">
      <xsl:choose>
        <xsl:when test="$l=( 'master_AR'
                            ,'master_AT'
                            ,'master_AU'
                            ,'master_BE'
                            ,'master_BR'
                            ,'master_CA'
                            ,'master_CH'
                            ,'master_CN'
                            ,'master_CZ'
                            ,'master_DE'
                            ,'master_DK'
                            ,'master_ES'
                            ,'master_EE'
                            ,'master_FI'
                            ,'master_FR'
                            ,'master_GB'
                            ,'master_GR'
                            ,'master_HK'
                            ,'master_HU'
                            ,'master_IE'
                            ,'master_IN'
                            ,'master_IT'
                            ,'master_KR'
                            ,'master_LV'
                            ,'master_LT'
                            ,'master_MX'
                            ,'master_MY'
                            ,'master_NL'
                            ,'master_NO'
                            ,'master_NZ'
                            ,'master_PH'
                            ,'master_PL'
                            ,'master_PT'
                            ,'master_RU'
                            ,'master_SA'
                            ,'master_SE'
                            ,'master_SG'
                            ,'master_TH'
                            ,'master_TR'
                            ,'master_TW'
                            ,'master_UA'
                            ,'master_US'
                            ,'master_VN'
                            ,'master_ZA')">
          <xsl:copy>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
          <RichTexts/>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!--
      | GreenAwards: only include the EcoFlower/BlueAngel-element which is to be
      | published, and set the isEnabled attribute and filter ApplicableFor
      | elements depending on wether the product is applicable for the current
      | country.
      +-->
  <xsl:template match="EnergyLabel|EcoFlower|BlueAngel" name="localizeGreenAward">
    <xsl:variable name="hasGreenAward" select="my:hasGreenAward(.)=true()"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="name()='BlueAngel'">
          <xsl:attribute name="isBlueAngelProduct" select="$hasGreenAward" />
        </xsl:when>
        <xsl:when test="name()='EcoFlower'">
          <xsl:attribute name="isEcoFlowerProduct" select="$hasGreenAward" />
        </xsl:when>
      </xsl:choose>
      <xsl:if test="$hasGreenAward">
        <xsl:apply-templates select="node()"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <!-- Perform the same for the localized mode -->
  <xsl:template match="EnergyLabel|EcoFlower|BlueAngel" mode="localize">
    <xsl:call-template name="localizeGreenAward"/>
  </xsl:template>
  
  <!-- Copy the local ApplicableFor -->
  <xsl:template match="ApplicableFor" name="copyMatchingApplicableFor">
    <xsl:variable name="hasGreenAward" select="Countrycode=$country"/>
    <!--+
        | Strip the content of those elements which are not applicable for
        | this country.
        +-->
    <xsl:if test="$hasGreenAward">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  
  <!-- Perform the same for the localized mode -->
  <xsl:template match="ApplicableFor" mode="localize">
    <xsl:call-template name="copyMatchingApplicableFor"/>
  </xsl:template>
</xsl:stylesheet>