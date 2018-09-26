<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:include href="pmsBase.xsl"/>
  
  <xsl:template match="Countries[ancestor::entry/@valid='true']">
    <xsl:variable name="object" select="ancestor::entry/@o"/>
    <xsl:copy>
      <sql:execute-query>
        <sql:query name="catalogs">
          select distinct co.customer_id catalogcode
               , to_char(co.sop, 'yyyy-mm-dd') startofpublication
               , to_char(co.eop, 'yyyy-mm-dd') endofpublication
               , case
                   when nvl(co.deleted,0) != 0 or co.eop &lt; co.sop then
                     'true'
                   else
                     'false'
                   end as deleted
               , co.country
               , ll.locale
          from catalog_objects co
          
          --inner join object_master_data omd 
          --   on omd.object_id = co.object_id
          
          inner join locale_language ll
             on ll.country = co.country
          
          inner join language_translations lt
             on lt.locale = ll.locale
            and lt.enabled=1
            
          where co.object_id = '<xsl:value-of select="$object" />'
            and co.customer_id in ('CARE','CONSUMER','FLAGSHIPSHOP')
          
          order by co.country, ll.locale
        </sql:query>
      </sql:execute-query>
      
      <sql:execute-query>
        <sql:query name="country-catalogs">
          select distinct co.country, ll.locale, ll.pms_display_name localename
               , to_char(min(co.sop) over(partition by co.country), 'YYYY-MM-DD') as startofpublication
               , to_char(max(co.eop) over(partition by co.country), 'YYYY-MM-DD') as endofpublication
          from catalog_objects co
          
          --inner join object_master_data omd 
          --   on omd.object_id = co.object_id
          
          inner join locale_language ll
             on ll.country = co.country
            
          inner join language_translations lt
             on lt.locale = ll.locale
            and lt.enabled = 1
             
          where co.object_id = '<xsl:value-of select="$object" />'
            and co.customer_id in ('CONSUMER','FLAGSHIPSHOP')
            and nvl(co.deleted, 0) = 0
            and co.eop > co.sop
          
          order by co.country, ll.locale
        </sql:query>
      </sql:execute-query>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
