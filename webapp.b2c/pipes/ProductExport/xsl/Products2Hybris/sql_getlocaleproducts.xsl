<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>

  <!-- -->
  <xsl:template match="/">
    <!-- default = PMT, otherwise select from sourceCT variabele.
     +-->
    <xsl:variable name="source" select="if ($sourceCT != '') then $sourceCT else 'PMT'" />

    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
         select o.object_id id
              , o.localisation
              , o.content_type
              , ll.language
              , omd.division
              , o.data
         from octl o 
         inner join object_master_data omd
            on omd.object_id=o.object_id
         inner join CUSTOMER_LOCALE_EXPORT cle
            on cle.ctn=o.object_id
           and cle.locale=o.localisation
         inner join locale_language ll
            on ll.locale=o.localisation
         where cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
           and cle.locale = '<xsl:value-of select="$locale"/>'
           and cle.flag=1
           and o.content_type='<xsl:value-of select="$source"/>'

        </sql:query>
        
        <sql:execute-query>
          <sql:query name="Refs">
             select data 
             from octl
             where object_id = '<sql:ancestor-value name="id" level="1"/>'
               and content_type = 'PMT_Refs'
          </sql:query>
        </sql:execute-query>
      </sql:execute-query>
       
       <!-- Query to read Mother product : START-->
       <!--  <sql:execute-query>
          <sql:query name="compatibleMotherProducts">
                  select   
                  distinct rel.object_id_src motherProducts_id, rel.object_id_tgt
                  from customer_locale_export cle
                      inner join object_relations rel
                         on rel.object_id_tgt=cle.ctn 
                        and rel.rel_type='PRD_ACC' 
                        and rel.deleted=0
                      inner join object_master_data omd 
                         on omd.object_id = rel.object_id_src
                      inner join catalog_objects co
                         on co.object_id=rel.object_id_src
                        and co.country='<xsl:value-of select="substring-after($locale,'_')"/>'
                        and co.deleted=0
                        and co.sop&lt;=sysdate
                        and co.eop&gt;trunc(sysdate)
                      inner join octl o
                         on o.object_id=rel.object_id_src
                        and o.localisation='<xsl:value-of select="$locale"/>'
                        and o.content_type='PMT'
                        and o.status != 'PLACEHOLDER'
                      inner join vw_object_categorization oc
                         on oc.object_id=rel.object_id_src
                        and oc.catalogcode=co.customer_id
                      inner join channels ch
                         on ch.name='<xsl:value-of select="$channel"/>'
                      inner join channel_catalogs cc
                         on cc.customer_id=ch.id
                        and cc.locale ='<xsl:value-of select="$locale"/>'
                        and cc.catalog_type=co.customer_id
                      where cle.customer_id='<xsl:value-of select="$channel"/>'
                        and cle.locale='<xsl:value-of select="$locale"/>'                     
          </sql:query>    
        </sql:execute-query> -->
      <!-- Query to read Mother product : END-->  
      
    </Products>
  </xsl:template>
</xsl:stylesheet>
