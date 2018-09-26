<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <!-- -->
  <xsl:variable name="doctype-channel">
    <xsl:choose>
      <!-- For the purposes of this particular xsl FSSAssets = FSS -->
      <xsl:when test="$channel = 'FSSAssets'">FSSAssets</xsl:when>
      <xsl:when test="$channel = 'FlixMediaAssets'">SyndicationL5Assets</xsl:when>
      <xsl:when test="$channel = 'WebcollageAssets'">SyndicationL5Assets</xsl:when>
      <xsl:when test="$channel = 'AtgAssets' ">ATGAssets</xsl:when>
      <xsl:otherwise><xsl:value-of select="$channel"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- -->
  <xsl:template match="/">
  <root>
    <!-- Select the doctypes that ought to be sent to this channel -->
    <doctypes><xsl:copy-of select="doctypes/doctype[attribute::*[local-name()=$doctype-channel]='yes']"/></doctypes>
    <xsl:choose>
      <xsl:when test="$locale = 'master_global'">
        <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
          <sql:query name="MASTER">
          select distinct x.ctn
            from
<!-- 1. MAX EOP across all countries is greater than the last time the channel ran and less than the current date or... -->
         (select cle.ctn, max(co.eop) maxeop, min(deleted) mindeleted
            from customer_locale_export cle
           inner join locale_language ll
              on cle.locale = ll.locale
             and cle.customer_id = '<xsl:value-of select="$channel"/>'
           inner join channels c
              on cle.customer_id = c.name
           inner join channel_catalogs cc
              on c.id = cc.customer_id
             and cc.enabled = 1
             and cc.locale = cle.locale
           inner join catalog_objects co
              on cc.catalog_type = co.customer_id
             and ll.country = co.country
             and co.object_id = cle.ctn
           where cle.lasttransmit is not null
           group by cle.ctn) x
           where x.maxeop &gt; (select endexec from channels where name = '<xsl:value-of select="$channel"/>')
             and x.maxeop &lt; sysdate
           UNION
<!-- 2. deleted = true for all assignments to all countries and lastmodified for at least one country is greater than the last time the channel ran -->
          select distinct x.ctn ctn
            from
         (select cle.ctn, min(deleted) mindeleted, max(lastmodified) maxlastmod
            from customer_locale_export cle
           inner join locale_language ll
              on cle.locale = ll.locale
             and cle.customer_id = '<xsl:value-of select="$channel"/>'
           inner join channels c
              on cle.customer_id = c.name
           inner join channel_catalogs cc
              on c.id = cc.customer_id
             and cc.enabled = 1
             and cc.locale = cle.locale
           inner join catalog_objects co
              on cc.catalog_type = co.customer_id
             and ll.country = co.country
             and co.object_id = cle.ctn
           where cle.lasttransmit is not null
           group by cle.ctn) x
           inner join catalog_objects co
           on x.ctn = co.object_id
           and co.customer_id is not null
           where x.mindeleted = 1
             and co.deleted = 1
             and co.lastmodified &gt; (select endexec from channels where name = '<xsl:value-of select="$channel"/>')
          </sql:query>
        </sql:execute-query>
      </xsl:when>
      <xsl:otherwise>
        <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
          <sql:query name="LOCALE">
          select distinct x.ctn
            from
<!-- 1. MAX EOP for locale's country is greater than the last time the channel ran and less than the current date or... -->
         (select cle.ctn, max(co.eop) maxeop, min(deleted) mindeleted
            from customer_locale_export cle
           inner join locale_language ll
              on cle.locale = ll.locale
             and cle.customer_id = '<xsl:value-of select="$channel"/>'
             and cle.locale = '<xsl:value-of select="$locale"/>'
           inner join channels c
              on cle.customer_id = c.name
           inner join channel_catalogs cc
              on c.id = cc.customer_id
             and cc.enabled = 1
             and cc.locale = cle.locale
           inner join catalog_objects co
              on cc.catalog_type = co.customer_id
             and ll.country = co.country
             and co.object_id = cle.ctn
           where cle.lasttransmit is not null
           group by cle.ctn) x
           where x.maxeop &gt; (select endexec from channels where name = '<xsl:value-of select="$channel"/>')
             and x.maxeop &lt; sysdate
           UNION
<!-- 2. deleted = true for all assignments to this locale's country and lastmodified is greater than the last time the channel ran -->
          select distinct x.ctn ctn
            from
         (select cle.ctn, min(deleted) mindeleted, max(lastmodified) maxlastmod
            from customer_locale_export cle
           inner join locale_language ll
              on cle.locale = ll.locale
             and cle.customer_id = '<xsl:value-of select="$channel"/>'
             and cle.locale = '<xsl:value-of select="$locale"/>'
           inner join channels c
              on cle.customer_id = c.name
           inner join channel_catalogs cc
              on c.id = cc.customer_id
             and cc.enabled = 1
             and cc.locale = cle.locale
           inner join catalog_objects co
              on cc.catalog_type = co.customer_id
             and ll.country = co.country
             and co.object_id = cle.ctn
           where cle.lasttransmit is not null
           group by cle.ctn) x
           inner join catalog_objects co
           on x.ctn = co.object_id
           and co.customer_id is not null
           where x.mindeleted = 1
             and co.deleted = 1
             and co.lastmodified &gt; (select endexec from channels where name = '<xsl:value-of select="$channel"/>')
          </sql:query>
        </sql:execute-query>
      </xsl:otherwise>
    </xsl:choose>

  <!-- -->
  </root>
</xsl:template>
</xsl:stylesheet>