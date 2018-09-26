<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportassignments">no</xsl:param>
  <xsl:param name="deltaTree"/>

  <xsl:variable name="true-delta" select="$deltaTree = 'y'"/>
  
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="localizedcats">

       <!-- but let's use the flat table cos it's probably quicker -->
          <xsl:choose>
            <xsl:when test="$locale = 'MASTER'">
              select distinct 'MASTER' locale
                    ,cat.catalogcode
                    ,cat.catalogname
                    ,cat.pdcode 
                    ,cat.pdname 
                    ,cat.bgroupcode 
                    ,cat.bgroupname
                    ,cat.groupcode
                    ,cat.grouprefname
                    ,cat.groupname
                    ,cat.categorycode
                    ,cat.categoryrefname
                    ,cat.categoryname
                    ,cat.subcategorycode
                    ,cat.subcategoryrefname
                    ,cat.subcategoryname
                    ,cat.l3code
                    ,cat.l3refname
                    ,cat.l3name
                    ,cat.l4code
                    ,cat.l4refname
                    ,cat.l4name
                    ,o.lastmodified_ts lastmodified
                    ,cat.grouprank
                    ,cat.categoryrank
                    ,cat.subcategoryrank
                    ,cat.l3rank
                    ,cat.l4rank
                    ,cat.subcategory_status
                    ,cat.grouptype
                    ,cat.groupshortcode
                    ,cat.groupseoname
                    ,cat.categorytype
                    ,cat.categoryseoname
                    ,cat.subcategorytype
                    ,cat.subcategoryseoname
                    ,cat.groupname m_groupname,  cat.categoryname m_categoryname, cat.subcategoryname m_subcategoryname, cat.l3name m_l3name, cat.l4name m_l4name
                    ,1 islatin
<xsl:if test="$exportassignments = 'yes'">
					, oc.object_id
</xsl:if>
                from channels c
                 inner join channel_catalogs cc
                      on cc.customer_id = c.id
                     and cc.enabled = 1
                     and cc.localeenabled = 1
                     and cc.product_type = 'CATEGORYTREE'
                     and cc.locale='<xsl:value-of select="$locale"/>'
          inner join customer_locale_export cle
                  on c.name = cle.customer_id
                 and c.name = '<xsl:value-of select="$channel"/>'
                 and cle.locale = '<xsl:value-of select="$locale"/>'
                 and cle.flag=1
          inner join categorization cat
                  on cat.catalogcode = cc.catalog_type
                  and (upper(cat.subcategory_status) in ('ACTIVE','PHASEDOUT') or cc.catalog_type='MARKETING')
          inner join octl o
                  on o.object_id = cat.catalogcode
                 and o.content_type = 'Categorization_Raw'
                 and o.localisation = 'none'
<xsl:if test="$exportassignments = 'yes'">                 
          left outer join vw_object_categorization oc
                  on oc.subcategory = cat.subcategorycode
                 and oc.catalogcode = cat.catalogcode
</xsl:if>
            order by cat.catalogcode, cat.groupcode, cat.categorycode, cat.subcategorycode
<xsl:if test="$exportassignments = 'yes'">
					, oc.object_id
</xsl:if>
            </xsl:when>
            <xsl:otherwise>
               select distinct ls.catalogcode
                      ,ls.catalogname
                      ,cat.pdcode 
                      ,cat.pdname 
                      ,cat.bgroupcode 
                      ,cat.bgroupname
                      ,ls.groupcode
                      ,ls.grouprefname
                      ,ls.groupname
                      ,ls.grouprank
                      ,ls.categorycode
                      ,ls.categoryrefname
                      ,ls.categoryname
                      ,ls.categoryrank
                      ,ls.subcategorycode
                      ,ls.subcategoryrefname
                      ,ls.subcategoryname
                      ,ls.subcategoryrank
                      ,ls.l3code
                      ,ls.l3refname
                      ,ls.l3name
                      ,ls.l3rank
                      ,ls.l4code
                      ,ls.l4refname
                      ,ls.l4name
                      ,ls.l4rank
                      ,TO_CHAR(ls.lastmodified,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified
                      ,cat.subcategory_status
                      ,ls.grouptype
                      ,ls.groupshortcode
                      ,ls.groupseoname
                      ,cat.groupseoname m_groupseoname 
                      ,ls.categorytype
                      ,ls.categoryseoname
                      ,cat.categoryseoname m_categoryseoname 
                      ,ls.subcategorytype
                      ,ls.subcategoryseoname
                      ,cat.subcategoryseoname m_subcategoryseoname 
                      ,cat.groupname m_groupname,  cat.categoryname m_categoryname, cat.subcategoryname m_subcategoryname, cat.l3name m_l3name, cat.l4name m_l4name
                      ,ll.islatin
                    from channels c
              inner join channel_catalogs cc
                      on cc.customer_id = c.id
                     and cc.enabled = 1
                     and cc.localeenabled = 1
                     and cc.product_type = 'CATEGORYTREE'
                     and cc.locale='<xsl:value-of select="$locale"/>'
              inner join locale_language ll 
                      on  ll.locale =  '<xsl:value-of select="$locale"/>'                     
              inner join localized_subcat ls
                      on cc.catalog_type = ls.catalogcode
                     and ls.locale = ll.locale
              inner join categorization cat
                      on ls.catalogcode = cat.catalogcode
                     and ls.groupcode = cat.groupcode
                     and ls.categorycode = cat.categorycode
                     and ls.subcategorycode = cat.subcategorycode
                     and nvl(ls.l3code,'x') = nvl(cat.l3code,'x')
                     and nvl(ls.l4code,'x') = nvl(cat.l4code,'x')
                     and upper(cat.subcategory_status) in ('ACTIVE','PHASEDOUT') 
              inner join customer_locale_export cle
                      on cle.locale = ls.locale
                     and cle.customer_id = c.name
                     and cle.flag = 1
                     
                     <!--
                      To support the true delta export we export all trees for a single locale
                      if one tree in that locale was modified.
                      So no join on catalogcode is we are doing a true delta export.
                     -->
                     <xsl:if test="$true-delta = false()">
                     and cle.ctn = ls.catalogcode
                     </xsl:if> 
               where c.name = '<xsl:value-of select="$channel"/>'
                order by ls.catalogcode, ls.groupcode, ls.categorycode, ls.l3code, ls.l4code, ls.subcategorycode
            </xsl:otherwise>
          </xsl:choose>
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>