<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cinclude="http://apache.org/cocoon/include/1.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!--
     | this step will:
     |  1) create CLE records for new objects that must be exported,
     |  2) reset the export-flag for objects that have not been exported in a previous run,
     |  3) set the export-flag for objects that must be exported in the current run.
     |-->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="selectall">no</xsl:param>  
  <xsl:param name="selectsubcat">no</xsl:param>  
  <xsl:param name="kvpdocpath"/>
  <xsl:param name="sourceCT"/><!-- content type parameter needed for ATG PCT export -->
  <!-- -->
  <xsl:variable name="kvpDoc" select="if(doc-available(concat('../',$kvpdocpath))) then doc(concat('../',$kvpdocpath)) else ()"/>  
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:choose>
        <xsl:when test="$selectsubcat = 'yes'">
          <xsl:call-template name="selectsubcats"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="select">
            <xsl:with-param name="subcat" select="''"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template name="selectsubcats">        
    <xsl:for-each select="//subcat">
      <xsl:call-template name="select">
        <xsl:with-param name="subcat" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>   
  <!-- -->
  <xsl:template name="select">        
    <!-- default = PMT, otherwise select from sourceCT variabele.
       +-->
    <xsl:param name="subcat"/>
    <!-- prepare CLE-records -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0" name="prepare CLE">
      <sql:query>
merge into customer_locale_export cle
   using (   select distinct '<xsl:value-of select="$channel"/>' as customer_id
                  , o.localisation
                  , o.object_id
               from octl o
<xsl:if test="$subcat != '' and string-length($subcat) gt 0">               
         inner join vw_object_categorization oc 
                 on oc.object_id    = o.object_id
                and oc.subcategory  = '<xsl:value-of select="."/>'     
                and oc.source      != 'ProductTree'
                and oc.catalogcode  = 'MASTER'                            
</xsl:if>               
         inner join channels ch
                 on ch.name         = '<xsl:value-of select="$channel"/>'
         inner join channel_catalogs cc
                 on cc.customer_id  = ch.id
                and cc.locale       = o.localisation
                and (cc.enabled = 1 or cc.masterlocaleenabled = 1)
         inner join catalog_objects co
                 on co.customer_id  = cc.catalog_type
                and co.country      = '<xsl:value-of select="substring-after($locale,'_')"/>'
                and co.object_id    = o.object_id
              where o.content_type  = 'PMT'
                and o.localisation  = '<xsl:value-of select="$locale"/>'
                and o.status        = 'Final Published'
                and co.sop       &gt; to_date('20120101','yyyymmdd')
                and co.eop       &gt; (sysdate - 7)
                and co.deleted      = 0
      ) src
   on (cle.customer_id = src.customer_id
   and cle.locale      = src.localisation
   and cle.ctn         = src.object_id
      )
   when matched then update      -- reset flag if set in a previous run 
      set cle.flag = 0 where cle.flag != 0
   when not matched then insert  -- create records to enable flagging the record in the next query
         (cle.customer_id, cle.locale, cle.ctn, cle.lasttransmit, cle.flag)
      values
         (src.customer_id, src.localisation, src.object_id, to_date('19000101', 'yyyymmdd'), 0)
      </sql:query>
    </sql:execute-query>
    <!--| flag CLE-records based on either 
        | a modification of the Logistic Data, or 
        | a modification of the PMT content types.
        |-->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0" name="flag CLE for export">
      <sql:query>
update customer_locale_export cle
   set cle.flag         = 1
 where cle.customer_id  = '<xsl:value-of select="$channel"/>'
   and cle.locale       = '<xsl:value-of select="$locale"/>'
   and cle.ctn in (select o.object_id
                     from octl o    -- PMT
          left outer join octl o2   -- Logistic Data
                       on o2.content_type  = 'LogisticData'
                      and o2.localisation  = 'master_'||'<xsl:value-of select="substring-after($locale,'_')"/>'
                      and o2.object_id     = o.object_id
<xsl:if test="$subcat != '' and string-length($subcat) gt 0">               
               inner join vw_object_categorization oc 
                       on oc.object_id    = o.object_id
                      and oc.subcategory  = '<xsl:value-of select="."/>'     
                      and oc.source      != 'ProductTree'                
                      and oc.catalogcode  = 'MASTER'            
</xsl:if>                                      
               inner join channels ch
                       on ch.name =  '<xsl:value-of select="$channel"/>'
               inner join channel_catalogs cc
                       on cc.customer_id  = ch.id
                      and cc.locale       = o.localisation
                      and (cc.enabled     = 1 
                        or cc.masterlocaleenabled = 1
                          )
<xsl:if test="$kvpDoc/keyvaluepairs">
               inner join keyvaluepairs kvp
                       on kvp.ctn         = o.object_id
               inner join (
<xsl:for-each select="$kvpDoc/keyvaluepairs/keyvaluepair">
select '<xsl:value-of select="key"/>' key<xsl:if test="value != ''">,'<xsl:value-of select="value"/>' value</xsl:if> from dual <xsl:if test="following-sibling::*"> union
</xsl:if></xsl:for-each>) keyvalues
                       on upper(kvp.key)  = upper(keyvalues.key)
<xsl:if test="$kvpDoc/keyvaluepairs/keyvaluepair/value[text()!='']">                         
                      and upper(kvp.value)= upper(keyvalues.value)
</xsl:if>                        
</xsl:if>                          
               inner join catalog_objects co
                       on co.customer_id  = cc.catalog_type
                      and co.country      = '<xsl:value-of select="substring-after($locale,'_')"/>'
                      and co.object_id    = o.object_id
                    where o.content_type  = 'PMT'
                      and o.localisation  = '<xsl:value-of select="$locale"/>'
                      and o.status        = 'Final Published'
                      and (o2.status      = 'Final Published' 
                        or o2.status     is null
                          )
                      and co.sop       &gt; to_date('20120101','yyyymmdd')
                      and co.eop       &gt; (sysdate - 7)
                      and co.deleted      = 0
                      and (cle.lasttransmit is null or o.lastmodified_ts &gt; cle.lasttransmit or o2.lastmodified_ts &gt; cle.lasttransmit)
                 )
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>