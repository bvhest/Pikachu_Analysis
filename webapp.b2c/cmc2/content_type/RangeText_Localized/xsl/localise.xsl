<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:saxon="http://saxon.sf.net/" xmlns:my="http://www.philips.com/pika" xmlns:xs="http://www.w3.org/2001/XMLSchema" extension-element-prefixes="my">

  <xsl:param name="l"/>
  <xsl:param name="xmlDir"/>

  <xsl:variable name="config" select="document(concat($xmlDir,'translated_attributes.xml'))"/>  
  
  <xsl:variable name="range" select="/entry/content/Node"/>
  
  <!-- +
       |
       |  LET'S LOCALIZE !!!
       |
       + -->

  <!-- -->
  <xsl:function name="my:localizetext">
    <xsl:param name="path2node"/>
    <xsl:param name="applicablelocalizations"/>
    <xsl:param name="usinglocalization"/>
    <xsl:param name="instring" as="xs:string"/>
    <xsl:param name="parentnode"/>
    <xsl:variable name="stringtoreplace" select="$applicablelocalizations/Localization[$usinglocalization]/MasterString"/>
    <xsl:variable name="replacement"     select="$applicablelocalizations/Localization[$usinglocalization]/LocalizedString"/>
    <xsl:variable name="node2localize-unique-id"><xsl:value-of select="if($applicablelocalizations/Localization[$usinglocalization][Action = 'REPLACE'][RangeNode2Replace != '']) then generate-id($range/saxon:evaluate($applicablelocalizations/Localization[$usinglocalization]/RangeNode2Replace)) else ''"/></xsl:variable>
    <xsl:variable name="parentnode-uniqueid"><xsl:value-of select="generate-id($parentnode)"/></xsl:variable>
    <!-- -->
    <xsl:choose>
      <xsl:when test="($node2localize-unique-id != $parentnode-uniqueid) or ($applicablelocalizations/Localization[$usinglocalization]/RangeNode2Replace = '')">
        <!-- Not to be localized -->
         <xsl:choose>
          <xsl:when test="$applicablelocalizations/Localization[$usinglocalization+1]">
            <xsl:value-of select="my:localizetext($path2node,$applicablelocalizations,$usinglocalization+1,$instring,$parentnode)"/>
          </xsl:when>
          <xsl:otherwise>
        <xsl:value-of select="$instring"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!--xsl:when test="true()"><xsl:value-of select="concat($instring,'|',$x,'|',$y)"/></xsl:when-->
      <xsl:otherwise>
        <xsl:variable name="result" select="if($replacement!='') then replace($instring,$stringtoreplace,$replacement) else $instring"/>
        <xsl:choose>
          <xsl:when test="$applicablelocalizations/Localization[$usinglocalization+1]"><xsl:value-of select="my:localizetext($path2node,$applicablelocalizations,$usinglocalization+1,$result,$parentnode)"/></xsl:when>
          <!-- Done localizing: check string length -->
          <xsl:otherwise>
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
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
 <xsl:template match="entry">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name()='valid')]"/>
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
              <xsl:copy-of select="$content"/>
              <xsl:apply-templates select="node()[not(local-name()=('result','content'))]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry/content/Node[@nodeType='range']">
    <xsl:variable name="ctns" select="ProductReferences/ProductReference/CTN
                                    | ProductRefs/ProductReference/CTN
                                    | ProductRefs/ProductReference/Product/@ctn"/>
    <!-- Is this OCTL to be localised or not? -->
    <!-- First, check secondary content - Localizations -->
    <xsl:variable name="localizations" select="../sql:rowset[@name='secondarycontent']/sql:row[sql:content_type='Localization']/sql:data/Localization[Active='YES'][Country=substring-after($l,'master_')]"/>
    <!-- Next, check the CTNMask -->
    <xsl:variable name="applicablelocalizations">
      <xsl:for-each select="$localizations">
        <xsl:if test="CTNMask='' or exists($ctns[matches(.,current()/CTNMask)])">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <!-- All Localizations that apply to this product are now in $applicablelocalizations -->
    <xsl:variable name="isLocalized" select="if($applicablelocalizations[1]!='') then true() else false()"/>
    <!-- Put all nodes to remove in a variable -->
    <xsl:variable name="nodes2remove-unique-ids">
      <xsl:for-each select="$applicablelocalizations/Localization[Action = 'REMOVE'][RangeNode2Remove!='']">
        <xsl:variable name="xpath" select="."/>
        <gid><xsl:value-of select="generate-id($range/saxon:evaluate($xpath/RangeNode2Remove))"/></gid>
      </xsl:for-each>
    </xsl:variable>
    <!-- Go -->    
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="IsLocalized" select="$isLocalized"/>
      <xsl:choose>
        <xsl:when test="$isLocalized">
          <!--nodes2remove-unique-ids><xsl:copy-of select="$nodes2remove-unique-ids"/></nodes2remove-unique-ids-->
          <xsl:apply-templates select="node()" mode="localize">
            <xsl:with-param name="applicablelocalizations" select="$applicablelocalizations"/>
            <xsl:with-param name="nodes2remove-unique-ids" select="$nodes2remove-unique-ids"/>
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
    <xsl:variable name="thisnode-uniqueid"><xsl:value-of select="generate-id(.)"/></xsl:variable>
    <!-- -->
    <xsl:choose>
      <xsl:when test="$thisnode-uniqueid = $nodes2remove-unique-ids/gid"/>
        <!-- Remove -->    
      <xsl:otherwise>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" mode="localize">
        <xsl:with-param name="applicablelocalizations" select="$applicablelocalizations"/>
            <xsl:with-param name="nodes2remove-unique-ids" select="$nodes2remove-unique-ids"/>
      </xsl:apply-templates>
    </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="text()" mode="localize">
    <xsl:param name="applicablelocalizations"/>
    <!-- Establish the path to the node starting from but not including the Node element.  I.e. at least 4 parent-levels -->
    <xsl:variable name="path2node" select="string-join(ancestor-or-self::*[../../../..]/name(.), '/')"/>
    <xsl:variable name="parentnode" select=".."/>
    <xsl:value-of select="if(normalize-space(.)!='') then my:localizetext($path2node,$applicablelocalizations,1,.,$parentnode) else ''"/>
  </xsl:template>
  <!-- -->

</xsl:stylesheet>