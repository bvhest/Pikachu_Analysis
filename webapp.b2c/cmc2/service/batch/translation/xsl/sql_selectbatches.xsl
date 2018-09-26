<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>  
  <!-- $priority, $locale and $ctn will have a value only in the case of a Priority Translation request -->
  <xsl:param name="priority"/>      
  <xsl:param name="locale"/>    
  <xsl:param name="ctn"/>     
  <!-- $catalogfilename will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->
  <xsl:param name="runcatalogexport"/>
  <xsl:param name="phase2"/>      
  <xsl:param name="workflow"/>        
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <!-- to accomodate for the different types of processing, the needsprocessing flag can have different values:
     |  0 : no processing (the default value).
	  |  1 : triggered for processing by the previous proces step (normal Query run).
	  |  2 : triggered for processing by a catalog-(translation)export.
	  | -2 : triggered for processing by a catalog-(translation)export or packaging project with SEO translation requests.
	  |  3 : triggered for processing by the previous proces step (Phase2 run).
	  |  4 : triggered for processing by the previous proces step (Real translation request run).
	  |-->
  <xsl:variable name="v_needsprocessing" select="if ($ct = 'PText_Translated') then '(-2,1)' 
                                            else if ($runcatalogexport = 'yes') then '(-2,2)' 
                                            else if ($phase2 = 'yes') then '(3)' 
                                            else if ($workflow = 'CL_CMC' and $ct = 'PMT_Translated' and not($phase2 = 'yes')) then '(1,4)' 
                                            else '(1)'"/>     
  <!-- -->  
  <xsl:template match="/">
    <root xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:execute-query>
        <sql:query name="sql_selectbatches">
          <xsl:choose>
            <xsl:when test="$ct='PMT_Translated'">                   
              select distinct oc.content_type
                   , ll.languagecode as localisation
                   , c.categorycode
                   , oc.batch_number
               from octl_control oc
              inner join vw_object_categorization voc
                 on voc.object_id            = oc.object_id      
              inner join categorization c 
                 on c.subcategorycode        = voc.subcategory
                and c.catalogcode            = voc.catalogcode 
              inner join locale_language ll
                 on ll.locale                 = oc.localisation
              inner join (select * from language_translations 
                           where isdirect = 0
                             and enabled  = 1
                         ) lt
                 on lt.locale                = ll.locale
              where oc.modus                 = '<xsl:value-of select="$modus"/>'
                and oc.content_type          = '<xsl:value-of select="$ct"/>'
             <xsl:if test="$priority and $locale and $ctn">            
                and oc.localisation         IN (select locale from locale_language where country = substr('<xsl:value-of select="$locale"/>',4,2))
                and oc.object_id             = '<xsl:value-of select="$ctn"/>' 
             </xsl:if>                                                         
                and oc.intransaction_flag    = 1         
                and oc.batch_number         IS NOT NULL
                and oc.needsprocessing_flag IN <xsl:value-of select="$v_needsprocessing"/>
                and c.catalogcode            = 'MASTER' -- Look at internal categories only
              order by  oc.batch_number asc
            </xsl:when>
            <xsl:when test="$ct='Categorization_Translated'">                   
              select distinct o.content_type
                   , ll.languagecode as localisation
                   , o.object_id as categorycode
                   , '1' as batch_number
              from 
                (select o1.content_type
                      , o1.localisation
                      , o1.object_id
                   from octl o1
                  inner join octl_control oc
                     on oc.content_type    = o1.content_type
                    and oc.localisation    = o1.localisation
                    and oc.object_id       = o1.object_id
                  where oc.modus           = '<xsl:value-of select="$modus"/>'
                    and oc.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
                    and o1.content_type    = '<xsl:value-of select="$ct"/>'
                    and o1.endofprocessing > trunc(sysdate)
                    and o1.active_flag     = 1
                 ) o
              inner join locale_language ll
                on ll.locale    = o.localisation
              inner join (select locale 
                           from language_translations 
                          where isdirect = '0'
                            and enabled = 1
                          ) lt
                  on lt.locale  = ll.locale
              order by ll.languagecode
            </xsl:when>
			        <xsl:when test="$ct='PText_Translated'">
                     select distinct o.content_type   as content_type 
                          , ll.languagecode           as localisation
                          , 'DUMMY'                   as categorycode
                          , o.object_id               as batch_number
                          , o.seo_translation
                     from (select o1.content_type
                                , o1.localisation
                                , o1.object_id
                                , decode(oc.needsprocessing_flag, -2, 'true'
                                                                    , 'false'
                                        ) as seo_translation
                             from octl o1
                            inner join octl_control oc
                               on oc.content_type  = o1.content_type
                              and oc.localisation  = o1.localisation
                              and oc.object_id     = o1.object_id
                            where oc.modus               = '<xsl:value-of select="$modus"/>'
                              and oc.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
                              and o1.content_type        = '<xsl:value-of select="$ct"/>'
                              and o1.endofprocessing     > trunc(sysdate)
                              and o1.active_flag         = 1 
                           ) o 
                     inner join locale_language ll 
                        on  ll.locale  = o.localisation
                     order by ll.languagecode
            </xsl:when>
			        <xsl:when test="$ct='RangeText_Translated'">
                     select distinct o.content_type
                          , ll.languagecode AS localisation
                          , 'RANGETEXT' AS categorycode
                          , oc.batch_number
                       from octl o 
                      inner join octl_control oc
                         on oc.content_type        = o.content_type
                        and oc.localisation        = o.localisation
                        and oc.object_id           = o.object_id
                  inner join locale_language ll 
                         on ll.locale              = o.localisation
                  inner join language_translations lt 
                         on lt.isdirect            = '0'
                        and lt.enabled             = 1
                        and lt.locale              = ll.locale
                      where o.content_type         = '<xsl:value-of select="$ct"/>'
                        and o.endofprocessing      > trunc(sysdate)
                        and o.active_flag          = 1
                        and oc.modus               = '<xsl:value-of select="$modus"/>'
                        and oc.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
                        and oc.intransaction_flag  = 1         
                        and oc.batch_number   is not null                          
                   ORDER BY ll.languagecode              
            </xsl:when>      
          </xsl:choose>
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>  
  