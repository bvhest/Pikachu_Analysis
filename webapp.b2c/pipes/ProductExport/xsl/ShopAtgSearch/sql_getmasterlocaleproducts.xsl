<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>

  <!-- -->
  <xsl:template match="/">
    <xsl:variable name="source" select="'PMT'" />

    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
    select
        sub1.object_id id,
        sub1.content_type,
        'en_' || substr(sub1.localisation, 4) localisation,
        sub1.country,
        sub1.catalogtypes,
        o.data,
        o_mstr.data as master_data
        
        from (
            select distinct
                o.object_id,
                <!-- Concatenate all catalog types -->
                wm_concat(distinct co.customer_id) as catalogtypes,
                o.localisation,
                substr('<xsl:value-of select="$locale"/>',4) country,
                '<xsl:value-of select="$source"/>' content_type
            from octl o
            
            inner join LOCALE_LANGUAGE ll 
               on ll.locale = o.localisation
            
            inner join catalog_objects co
               on co.object_id=o.object_id
              and co.COUNTRY=ll.country
              and co.deleted=0
                
            inner join CUSTOMER_LOCALE_EXPORT cle
               on cle.ctn=o.object_id
              and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
              and cle.locale=o.localisation
              and cle.flag=1
            
            inner join channels ch
               on ch.name = cle.CUSTOMER_ID  
            
            inner join channel_catalogs cc
               on cc.customer_id = ch.id
            
            where (ch.catalog='ALL' or co.CUSTOMER_ID = cc.catalog_type)
              and o.content_type='<xsl:value-of select="$source"/>'
              and o.localisation='<xsl:value-of select="$locale"/>'
              and o.status != 'PLACEHOLDER'
              
            group by o.object_id, o.status, o.localisation
          ) sub1
          inner join octl o
             on o.object_id = sub1.object_id
            and o.localisation = 'master_' || substr(sub1.localisation, 4)
            and o.content_type = 'PMT_Localised'
          -- We need PMT_Master to get the SEO product name
          inner join octl o_mstr
             on o_mstr.object_id = sub1.object_id
            and o_mstr.localisation = 'master_global'
            and o_mstr.content_type = 'PMT_Master'
          --order by sub1.object_ID
          </sql:query>
          
          <!-- Get performer CTNs from the OBJECT_RELATIONS table-->
          <sql:execute-query>
            <sql:query name="performers">
              select distinct rel.object_id_src as ctn
              from object_relations rel
              inner join mv_co_object_id_country co
                 on co.object_id=rel.object_id_src
                and co.country='<sql:ancestor-value name="country" level="1"/>'
                and (co.sop - 7) &lt; sysdate
                and (co.eop + 7) &gt; sysdate
                and co.deleted=0
              where rel.object_id_tgt='<sql:ancestor-value name="id" level="1"/>'
              and rel.rel_type='PRD_ACC'
              and rel.deleted=0
            </sql:query>
          </sql:execute-query>
       </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
