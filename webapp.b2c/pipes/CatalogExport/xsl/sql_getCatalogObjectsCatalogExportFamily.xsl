<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="catalog-id"/>
  <xsl:param name="channel"/>

  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="catalog-objects">
        <!--+
            | Select catalog objects from specified catalog.
            +-->
        select regexp_replace('<xsl:value-of select="$catalog-id"/>','LP_(.+)_ATG','LP_\1_FAMILY') catalog_id
           ,regexp_replace(oc.subcategory,'_FA$','') object_id
           ,regexp_replace('<xsl:value-of select="$catalog-id"/>','LP_(.+)_ATG_.*','LP_\1_FAMILY') customer_id
           ,co.country
           ,co.division
           ,to_char(greatest(max(co.lastmodified), max(oc.lastmodified)), 'YYYY-MM-DD"T"HH24:MI:SS') lastmodified
           ,to_char(min(co.sop), 'YYYY-MM-DD') sop
           ,to_char(max(co.eop), 'YYYY-MM-DD') eop
           ,to_char(min(co.sos), 'YYYY-MM-DD') sos
           ,to_char(max(co.eos), 'YYYY-MM-DD') eos
           ,0 buy_online
           ,min(oc.deleted) deleted
           
        from catalog_objects co
        
        inner join vw_object_categorization oc
           on oc.catalogcode = co.customer_id
          and oc.object_id = co.object_id

        inner join localized_subcat lc
           on lc.catalogcode=oc.catalogcode
          and lc.subcategorycode=oc.subcategory
          and substr(lc.locale,4)=co.country
                
        where co.catalog_id = '<xsl:value-of select="$catalog-id"/>'
        
        group by co.country, co.customer_id, co.division, oc.subcategory
        
        union
 select 
           c.catalog_id
           ,c.object_id object_id
           ,c.customer_id
           ,c.country
           ,c.division
           ,to_char(sysdate, 'YYYY-MM-DD"T"HH24:MI:SS') lastmodified
           ,to_char(c.sop, 'YYYY-MM-DD') sop
           ,to_char(c.eop, 'YYYY-MM-DD') eop
           ,to_char(c.sos, 'YYYY-MM-DD') sos
           ,to_char(c.eos, 'YYYY-MM-DD') eos
           ,0 buy_online
           ,1 deleted
 from catalog_objects c 
      left outer join
       (
        select regexp_replace (oc.subcategory, '_FA$', '') object_id
            from catalog_objects co 
            inner join vw_object_categorization oc
               on oc.catalogcode = co.customer_id
              and oc.object_id = co.object_id
            inner join localized_subcat lc
               on lc.catalogcode = oc.catalogcode
               and lc.subcategorycode = oc.subcategory
               and substr (lc.locale, 4) = co.country
               where co.catalog_id = '<xsl:value-of select="$catalog-id"/>'
        group by co.country, co.customer_id, co.division, oc.subcategory) v
       on v.object_id = c.object_id
 where c.catalog_id = regexp_replace('<xsl:value-of select="$catalog-id"/>','LP_(.+)_ATG','LP_\1_FAMILY')
   and c.deleted = 0
   and v.object_id is null           
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
