<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="fullexport"/>
  <xsl:param name="deltaTree"/>

  <xsl:variable name="full-export" select="$fullexport = 'yes'"/>
  <!-- $true-delta=true() means a delta is performed on the exported data -->
  <xsl:variable name="true-delta" select="$deltaTree = 'y'"/>
  
  <xsl:template match="/">
    <root>
    <!-- Reset existing -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        update customer_locale_export
           set FLAG=0
         where CUSTOMER_ID='<xsl:value-of select="$channel"/>'
           and LOCALE='<xsl:value-of select="$locale"/>'
           and FLAG!=0
      </sql:query>
    </sql:execute-query>
    <!-- Add new -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
            insert into customer_locale_export (customer_id, locale, ctn, flag)
            select distinct '<xsl:value-of select="$channel"/>',
                            '<xsl:value-of select="$locale"/>',
                            c.catalogcode,
                            0
              from categorization c
        inner join channel_catalogs cc
                on cc.catalog_type = c.catalogcode
               and cc.enabled = 1
               and cc.localeenabled = 1
               and cc.product_type = 'CATEGORYTREE'
               and cc.locale='<xsl:value-of select="$locale"/>'
        inner join channels ch
                on cc.customer_id = ch.id
               and ch.name = '<xsl:value-of select="$channel"/>'
        left outer join customer_locale_export cle
                on cle.customer_id = '<xsl:value-of select="$channel"/>'
               and cle.locale='<xsl:value-of select="$locale"/>'
               and cle.ctn = c.catalogcode
               where cle.ctn is null
      </sql:query>
    </sql:execute-query>
    <!--
      Set flag to 1 for updated cats, or if fullexport=yes.
      CLE.ctn is a catalogcode that pomts to a catg tree.
    -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        update customer_locale_export cle
           set flag=1
         where cle.locale = '<xsl:value-of select="$locale"/>'
           and cle.customer_id = '<xsl:value-of select="$channel"/>'
           and exists (select 1
                         from <xsl:value-of select="if ($locale='MASTER') then 'categorization' else 'localized_subcat'" /> cat

                   inner join channels ch
                          on ch.name = '<xsl:value-of select="$channel"/>'

                   inner join channel_catalogs cc
                           on cc.customer_id = ch.id
                          and cc.enabled = 1
                          and cc.localeenabled = 1
                          and cc.product_type = 'CATEGORYTREE'
                          and cc.catalog_type = cat.catalogcode
                        <xsl:if test="$locale != 'MASTER'">
                          and cc.locale = cat.locale
                        </xsl:if>
                        where cle.ctn = cat.catalogcode
                          and cc.locale = '<xsl:value-of select="$locale"/>'
                        <!--
                          For a full export flag all trees for the specified locale.
                          If a true delta is performed we also need to export all trees to be able to detect
                          deleted nodes.
                        -->
                        <xsl:if test="$full-export = false() and $true-delta = false()">
                          and (
	                          <xsl:if test="$locale !='MASTER'">
	                             cat.lastmodified > cle.lasttransmit or 
	                          </xsl:if> cle.lasttransmit is null
                          )
                        </xsl:if>)
       </sql:query>
    </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>