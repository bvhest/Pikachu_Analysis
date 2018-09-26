<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">
    
  <xsl:param name="channel"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="locale"/>
  <xsl:param name="delta"/>
  
  <xsl:template match="/">
    <Products>
      <xsl:variable name="country" select="substring($locale, 4)"/>
      
      <sql:execute-query>
        <sql:query name="product">
          select 
                o.object_id ID
              , ll.LOCALE
              , ll.LANGUAGE
              , decode(omd.division, 'CE', 'PCE', 'DAP', 'DAP','Lighting','PCE') as division
              , nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) as lastexportdate
              , channel.masterlocaleenabled
              , o.data as data
              , oloc.data masterdata
          from customer_locale_export cle
          inner join octl o 
             on o.content_type='PMT' 
            and o.localisation=cle.locale 
            and o.object_id=cle.ctn
          inner join object_master_data omd 
             on omd.object_id = o.object_id
          inner join locale_language ll 
             on ll.locale = cle.locale
          
          <!-- Get masterlocaleenabled property for the channel/locale -->
          inner join (   
                select ch.name, cc.locale, max(nvl(cc.masterlocaleenabled,0)) masterlocaleenabled from channels ch
                inner join channel_catalogs cc
                   on cc.customer_id=ch.id
                group by ch.name, cc.locale
            ) channel
            on channel.name=cle.customer_id
           and channel.locale=cle.locale
         <!-- Fetch PMT_Localised content is masterlocaleenabled == 1 -->
         left outer join octl oloc
           on oloc.object_id=o.object_id
          and oloc.localisation='master_'||ll.country
          and oloc.content_type='PMT_Localised'
          and channel.masterlocaleenabled=1

         where cle.customer_id='<xsl:value-of select="$channel"/>'
           and cle.locale='<xsl:value-of select="$locale"/>'    
            <xsl:choose>
              <xsl:when test="$delta='y'">and cle.flag=1</xsl:when>
              <xsl:otherwise>and cle.batch = <xsl:value-of select="$batchnumber"/> </xsl:otherwise>
            </xsl:choose>
        </sql:query>		
			
      </sql:execute-query>
      
      <!-- Query to read Mother product : START-->
        <sql:execute-query>
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
                  and co.country='<xsl:value-of select="$country"/>'
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
                  and substr(cc.locale, 4)='<xsl:value-of select="$country"/>'
                  and cc.catalog_type=co.customer_id
                where cle.customer_id='<xsl:value-of select="$channel"/>'
                  and cle.locale='<xsl:value-of select="$locale"/>'                     
          </sql:query>    
        </sql:execute-query>
      <!-- Query to read Mother product : END-->  
    
      
      <!-- For the products that are exported get product accessories that are sold in the current country 
           and for which we have product content available
      -->
      <sql:execute-query>
        <sql:query name="product-accessories">
         select   
            distinct rel.object_id_tgt accessory_id
            from customer_locale_export cle
            inner join object_relations rel
               on rel.object_id_src=cle.ctn 
              and rel.rel_type='PRD_ACC' 
			  and rel.deleted=0
            inner join object_master_data omd 
               on omd.object_id = rel.object_id_tgt
            inner join catalog_objects co
               on co.object_id=rel.object_id_tgt
              and co.country='<xsl:value-of select="$country"/>'
              and co.deleted=0
              and co.sop&lt;=sysdate
              and co.eop&gt;trunc(sysdate)
            inner join octl o
               on o.object_id=rel.object_id_tgt
              and o.localisation='<xsl:value-of select="$locale"/>'
              and o.content_type='PMT'
              and o.status != 'PLACEHOLDER'
            inner join vw_object_categorization oc
               on oc.object_id=rel.object_id_tgt
              and oc.catalogcode=co.customer_id
            inner join channels ch
               on ch.name='<xsl:value-of select="$channel"/>'
            inner join channel_catalogs cc
               on cc.customer_id=ch.id
              and substr(cc.locale, 4)='<xsl:value-of select="$country"/>'
              and cc.catalog_type=co.customer_id
            where cle.customer_id='<xsl:value-of select="$channel"/>'
              and cle.locale='<xsl:value-of select="$locale"/>'
            <xsl:choose>
              <xsl:when test="$delta='y'">and cle.flag=1</xsl:when>
              <xsl:otherwise>and cle.batch = <xsl:value-of select="$batchnumber"/></xsl:otherwise>
            </xsl:choose>
          </sql:query>
        </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
