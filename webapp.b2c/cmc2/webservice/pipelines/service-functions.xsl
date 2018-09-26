<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
    xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
    >

  <xsl:param name="cmc-svc-url"/>

  <xsl:variable name="svcdata" select="document('service-data.xml')/tns:service-data"/>
  
  <xsl:function name="svc:catalog-allowed" as="xs:boolean">
    <xsl:param name="catalog-code"/>
    <xsl:sequence select="fn:empty($svcdata/tns:excluded-catalogs/tns:catalog[.=$catalog-code])"/>
  </xsl:function>

  <xsl:function name="svc:pfs-deeplink-allowed" as="xs:boolean">
    <xsl:param name="user-profile"/>
    <xsl:param name="subcat-code"/>
    <xsl:sequence select="fn:exists($user-profile//ContentType[@code = 'PMT_Raw']/Restriction/SubCategory[SubcategoryCode=$subcat-code][Roles/Role[(text() = 'Update') or (text() = 'Sign')]])"/>
  </xsl:function>

  <xsl:function name="svc:subcat-allowed" as="xs:boolean">
    <xsl:param name="user-profile"/>
    <xsl:param name="subcat-code"/>
    <xsl:sequence select="fn:exists($user-profile//SubCategory[SubcategoryCode=$subcat-code][Roles/Role[text() = 'Read']])"/>
  </xsl:function>

  <xsl:function name="svc:contenttype-allowed" as="xs:boolean">
    <xsl:param name="user-profile"/>
    <xsl:param name="content-type"/>
    <xsl:sequence select="fn:exists($user-profile//ContentType[@code = $content-type])"/>
  </xsl:function>

  <xsl:function name="svc:authorizations-allowed" as="xs:boolean">
    <xsl:param name="user-profile"/>
    <xsl:param name="content-type"/>
    <xsl:sequence select="fn:exists($user-profile//User[@status='Active']/Authorizations[@source = $content-type])"/>
  </xsl:function>

  <xsl:function name="svc:allowed-subcats-for-profile" as="xs:node()*">
    <xsl:param name="user-profile"/>
    <xsl:param name="role"/>
    <xsl:sequence select="$user-profile/Authorisations/Subcategories/Subcategory[Roles/Role[text() = $role]]"/>
  </xsl:function>
  
  <!-- JWE, 2010-04-01 -->
  <xsl:function name="svc:allowed-products-for-profile" as="xs:node()*">
    <xsl:param name="user-profile"/>
    <xsl:sequence select="$user-profile/Portfolio"/>
  </xsl:function>
  
  <!-- JWE, 2010-05-05 -->
  <xsl:function name="svc:final-published-in-pmt-raw" as="xs:boolean">
    <xsl:param name="id"/>
    <xsl:variable name="doc" select="svc:get-octl-doc($id,'PMT_Raw','none')"/>
    <xsl:sequence select="if ($doc[//sql:status = 'Final Published']) then true() else false()"/>
  </xsl:function>

  <xsl:function name="svc:division-for-name" as="xs:element">
    <xsl:param name="division-name"/>
    <xsl:sequence select="$svcdata/tns:product-divisions/tns:division[@name=$division-name]"/>
  </xsl:function>

  <xsl:function name="svc:division-for-code" as="xs:element">
    <xsl:param name="division-code"/>
    <xsl:sequence select="$svcdata/tns:product-divisions/tns:division[@code=$division-code]"/>
  </xsl:function>
  
  <xsl:function name="svc:get-error" as="xs:element">
    <xsl:param name="error-code"/>
    <xsl:sequence select="$svcdata/tns:errors/tns:error[@code=$error-code]"/>
  </xsl:function>
  
  <xsl:function name="svc:get-octl-url" as="xs:string">
    <xsl:param name="o"/>
    <xsl:param name="ct"/>
    <xsl:param name="l"/>
    <xsl:value-of select="concat($cmc-svc-url,'/common/get-octl/',$ct,'/',$l,'/',$o)"/>
  </xsl:function>

  <xsl:function name="svc:get-octl-doc" as="xs:element">
    <xsl:param name="id"/>
    <xsl:param name="ct"/>
    <xsl:param name="l"/>
    <xsl:variable name="url" select="svc:get-octl-url($id,$ct,$l)"/>
    <xsl:sequence select="document($url)/descendant::sql:data/*[1]"/>
  </xsl:function>
  
  <xsl:function name="svc:get-user-profile" as="xs:element">
    <xsl:param name="username"/>
    <xsl:sequence select="svc:get-octl-doc($username, 'UAP', 'none')"/>
  </xsl:function>
  
  <!-- JWE, 2010-04-09 
    Return the active user profile if it is available, else try to return
    the anonymous profile to allow anonymous viewing 
  -->
  <xsl:function name="svc:get-active-user-profile" as="xs:element">
    <xsl:param name="username"/>
    <xsl:variable name="uap" select="svc:get-octl-doc($username, 'UAP', 'none')"/>
    <xsl:variable name="anonymous" select="'uap-anonymous.xml'"/>
    <xsl:sequence select="if ($uap[//sql:status = 'Active']) 
                          then $uap 
                          else (
                            if (fn:doc-available($anonymous)) 
                            then document($anonymous)/descendant::sql:data/*[1] 
                            else svc:get-error(401)
                          )"/>
  </xsl:function>

  <xsl:function name="svc:objectcat-code-for-catalog-code">
    <xsl:param name="catalog-code"/>
    <xsl:choose>
      <xsl:when test="$catalog-code = 'CARE' or $catalog-code = 'ProductTree'">
        <xsl:value-of select="$catalog-code"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>MASTER</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!--
     | Fix a date from the database to a valid XML Schema dateTime 
     -->
  <xsl:function name="svc:fix-dateTime" as="xs:string">
    <xsl:param name="d"/>
    <xsl:value-of select="fn:replace($d,' ','T')"/>
  </xsl:function>

  <!--
     | Fix a date from the database to a valid XML Schema date 
     -->
  <xsl:function name="svc:fix-date" as="xs:string">
    <xsl:param name="d"/>
    <xsl:value-of select="fn:substring-before($d,' ')"/>
  </xsl:function>
</xsl:stylesheet>

