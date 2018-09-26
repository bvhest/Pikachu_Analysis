<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql xsl">

  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="type"/>
  <!-- -->
  <xsl:variable name="doctype-channel">
    <xsl:choose>
      <!-- For the purposes of this particular xsl FSSAssets = FSSAssets -->
      <xsl:when test="$channel = 'FSSAssets'">FSSAssets</xsl:when>      
      <xsl:when test="$channel = 'WebcollageAssets'">WebcollageAssets</xsl:when>    
      <xsl:when test="$channel = 'AtgAssets' ">ATGAssets</xsl:when>  
      <xsl:otherwise><xsl:value-of select="$channel"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- -->  
  <xsl:template match="/">
  <root>
  <!-- Select the doctypes that ought to be sent to this channel -->
  <doctypes><xsl:copy-of select="doctypes/doctype[attribute::*[local-name()=$doctype-channel]='yes']"/></doctypes>
  <sql:execute-query>
    <sql:query>
      select o.content_type
           , o.localisation
           , o.object_id
           , o.masterlastmodified_ts
           , o.lastmodified_ts
           , o.status
           , o.marketingversion
           , o.data
        from octl o
  inner join customer_locale_export cle
          on cle.ctn        = o.object_id
         and cle.locale     = o.localisation
       where o.content_type = '<xsl:value-of select="if($type='ObjectAssets') then 'ObjectAssetList' else 'AssetList'"/>'      
         and cle.locale     = '<xsl:value-of select="$locale"/>'
         and cle.customer_id= '<xsl:value-of select="$channel"/>'
         and cle.flag       = 1
         and NVL(o.status, 'XXX') != 'PLACEHOLDER'
    order by o.object_id
    </sql:query>
  </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>