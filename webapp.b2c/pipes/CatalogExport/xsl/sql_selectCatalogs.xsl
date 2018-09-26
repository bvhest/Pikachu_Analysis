<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"/>
  <xsl:param name="full"/>

  <xsl:variable name="full-export" select="if ($full = 'true') then true() else false()"/>
  
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="reset-flags">
          <!-- Reset flag and force resending if full is requested -->
          update customer_locale_export
             set flag=0
           <xsl:if test="$full-export">
           , lasttransmit = null
           </xsl:if>
           where customer_id='<xsl:value-of select="$channel"/>'
           <xsl:if test="not($full-export)">
             and flag != 0
           </xsl:if>
        </sql:query>
      </sql:execute-query>
      <xsl:call-template name="select"/>
    </root>
  </xsl:template>

  <xsl:template name="select">        
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="flag-new-catalogs">
        insert into customer_locale_export(customer_id, locale, ctn, flag)
          select distinct
                   '<xsl:value-of select="$channel"/>'
                 , 'none'
                 , co.catalog_id
                 , 1
          from catalog_objects co
          
          inner join channels ch
            on ch.name = '<xsl:value-of select="$channel"/>'
            
          left outer join channel_catalogs cc
            on cc.customer_id = ch.id
           and cc.catalog_type = co.customer_id
            
          left outer join customer_locale_export cle
            on co.catalog_id = cle.ctn
           and cle.customer_id='<xsl:value-of select="$channel"/>'

          where cle.customer_id is null
            and (
                (cc.customer_id is null and ch.catalog = co.customer_id)
              or cc.customer_id is not null
            )
      </sql:query>
    </sql:execute-query>

    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="flag-existing-catalogs">
        <!-- Flag catalogs that have at least one product modified after the last export -->
        update customer_locale_export cle
        set flag=1
        where customer_id = '<xsl:value-of select="$channel"/>'
        and ctn in (
           select distinct co.catalog_id
           
           from catalog_objects co
           
           inner join channels ch
              on ch.name = '<xsl:value-of select="$channel"/>'
                         
           left outer join channel_catalogs cc
             on cc.customer_id = ch.id
            and cc.catalog_type = co.customer_id

           where (cle.lasttransmit is null or co.lastmodified &gt; cle.lasttransmit)
             and (
                (cc.customer_id is null and ch.catalog = co.customer_id)
              or cc.customer_id is not null
             )
             and cle.flag = 0
        )
      </sql:query>
    </sql:execute-query>

    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="select-flagged-catalogs">
        select ctn as catalog_id
        from customer_locale_export
        where flag > 0
        and customer_id = '<xsl:value-of select="$channel"/>'
        order by 1
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>