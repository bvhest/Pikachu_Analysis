<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:cinclude="http://apache.org/cocoon/include/1.0"
                xmlns:my="http://www.philips.com/pika" 
                extension-element-prefixes="my"        
                >

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="ct"/>  
  <xsl:param name="l"/>  
  <xsl:param name="category"/>  
  <xsl:param name="isdirect"/>    
  <xsl:param name="ts"/>    
  <xsl:param name="dir"/>      
  <xsl:param name="division"/>        
  <xsl:param name="priority"/>          
  <!-- $catalogfilename will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->
  <xsl:param name="runcatalogexport"/>
  <xsl:param name="phase2"/>      
  <xsl:param name="workflow"/>          
  <xsl:param name="runmode"/>
  <xsl:param name="seo"/>
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
  <xsl:variable name="v_needsprocessing" select="if ($runcatalogexport = 'yes') then '(-2,2)' 
                                            else if ($ct = 'PText_Translated') then '(-2,1)' 
                                            else if ($phase2 = 'yes') then '(3)' 
                                            else if ($workflow = 'CL_CMC' and $ct = 'PMT_Translated' and not($phase2 = 'yes')) then '(1,4)' 
                                            else '(1)'"/>     
  <!-- -->  
  <xsl:variable name="objecttype">
    <xsl:choose>
      <xsl:when test="$ct='PMT_Translated'">Product</xsl:when>
      <xsl:when test="$ct='Categorization_Translated'">Categorization</xsl:when>
      <xsl:when test="$ct='PP_Translated'">Packaging</xsl:when>
    </xsl:choose>   
  </xsl:variable>      
  <!-- -->  
  <xsl:function name="my:reformatDate">
  <!--+
      |  Reformat date string:
      |         20070919164110
      |       IN: yyyymmddHH24miss
      |      OUT: yyyy-mm-ddTHH:mm:ss
      +-->
    <xsl:param name="date"/>
    <xsl:choose>
      <xsl:when test="$date=''">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T',substring($date,9,2),':',substring($date,11,2),':',substring($date,13,2))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
  <!-- -->  
  <xsl:variable name="runts19" select="my:reformatDate($ts)"/>    
  <!-- -->    
  <xsl:template match="/">
    <entries 
      ct="{$ct}"
      l="{$l}"
      category="{$category}"
      ts="{$ts}"
      dir="{$dir}"
      batchnumber="{$batchnumber}"
      priority="{$priority}">
      <xsl:if test="$ct = 'PText_Translated' and $seo = 'true'">
         <xsl:attribute name="seo" select="'yes'" />
      </xsl:if>

      <process/>
      <globalDocs/>
      <xsl:choose>
        <xsl:when test="$isdirect='0'">
          <sql:execute-query name="notdirect">
            <sql:query name="notdirect">
              <xsl:choose>
                <xsl:when test="$ct='PMT_Translated'">            
                  select distinct ocl.content_type
                       , ocl.localisation
                       , ocl.object_id
                       , c.groupcode 
                       , c.categorycode as internal_category                            
                       , c.groupname
                       , c.categoryname
                       , ocl.batch_number
                       , '<xsl:value-of select="$runts19"/>' as lastmodified_ts
                       , omd.division
                       , decode(ocl.needsprocessing_flag, -2, 'yes'
                                                            , 'no'
                               ) AS seo_translation
                    from  locale_language ll 
                   inner join language_translations lt 
                      on lt.locale = ll.locale 
                   inner join octl_control ocl
                      on ocl.localisation = ll.locale
                   inner join mv_co_object_id mvco 
                      on mvco.object_id      = ocl.object_id
                     and mvco.deleted        = 0
                     and mvco.eop         &gt; trunc(sysdate)
                   inner join object_master_data omd 
                      on omd.division     = lt.division
                     and omd.object_id    = ocl.object_id
                   inner join vw_object_categorization oc 
                      on oc.object_id     = ocl.object_id
                     and oc.catalogcode   = 'MASTER'
                   inner join categorization c 
                      on c.subcategorycode = oc.subcategory 
                     and c.catalogcode     = oc.catalogcode
                  where ll.languagecode      = '<xsl:value-of select="$l"/>'
                    and lt.isdirect          = 0
                    and lt.enabled           = 1
                    and ocl.modus            = '<xsl:value-of select="$modus"/>'
                    and ocl.content_type     = '<xsl:value-of select="$ct"/>'
                    and ocl.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/> 
                    and ocl.batch_number     = <xsl:value-of select="if ($batchnumber != '') then $batchnumber else 1"/> 
                    and omd.object_type      = '<xsl:value-of select="$objecttype"/>'
                    and c.categorycode       = '<xsl:value-of select="$category"/>'                    
                </xsl:when>
                <xsl:when test="$ct='Categorization_Translated' ">
                  <!-- Categorization_Translated and Ptext_Translated are never localized, therefore we always need only the language family -->
                   select distinct
                          o.content_type
                        , ll.languagecode as localisation
                        , o.object_id
                        , o.object_id as internal_category
                        , 'null' as batch_number
                        , '<xsl:value-of select="$runts19"/>' as lastmodified_ts
                        , 'CE' as division
                   from (select o.content_type
                              , o.localisation
                              , o.object_id 
                          from octl o
                         inner join octl_control oc
                            on oc.content_type  = o.content_type
                           and oc.localisation  = o.localisation
                           and oc.object_id     = o.object_id
                         where o.content_type          = '<xsl:value-of select="$ct"/>'
                           and o.object_id             = '<xsl:value-of select="$category"/>'
                           and o.endofprocessing   &gt;= trunc(sysdate)
                           and o.active_flag           = 1
                           and oc.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
                           and oc.modus                = '<xsl:value-of select="$modus"/>'
                        ) o
                   inner join 
                        (select locale, languagecode
                         from locale_language 
                        where languagecode = '<xsl:value-of select="$l"/>') ll  
                     on o.localisation = ll.locale                   
                   inner join 
                      (select distinct locale --,min(division) as division
                         from language_translations
                        where isdirect = '0'
                          and enabled = 1) lt
                     on ll.locale = lt.locale                    
                </xsl:when> 
                 <xsl:when test="$ct='PText_Translated'">
                <!-- Categorization_Translated and Ptext_Translated are never localized, therefore we always need only the language family -->
                   select distinct
                          '<xsl:value-of select="$ct"/>' as content_type
                        , '<xsl:value-of select="$l"/>' as localisation
                        , '<xsl:value-of select="$batchnumber"/>' as object_id
                        , 'DUMMY' groupcode
                        , 'DUMMY' internal_category
                        , 'DUMMY' groupname
                        , 'DUMMY' categoryname
                        , '<xsl:value-of select="$batchnumber"/>'  as batch_number
                        , '<xsl:value-of select="$runts19"/>' as lastmodified_ts
                        , 'CE' as division 
                   from DUAL
                  </xsl:when>    
                 <xsl:when test="$ct='RangeText_Translated'">
                      select distinct o.content_type
                           , o.localisation
                           , o.object_id
                           , 'RANGETEXT' as groupcode
                           , 'RANGETEXT' as internal_category
                           , 'RANGETEXT' as groupname
                           , 'RANGETEXT' as categoryname
                           , oc.batch_number
                           , '<xsl:value-of select="$runts19"/>' as lastmodified_ts
                           , 'CE' as division 
                        from octl o 
                  inner join octl_control oc
                          on oc.content_type  		= o.content_type
                         and oc.localisation  		= o.localisation
                         and oc.object_id     		= o.object_id
                  inner join locale_language ll 
                          on ll.locale             = o.localisation
                  inner join language_translations lt 
                          on lt.locale             = ll.locale
                         and lt.division           = 'CE'
                       where ll.languagecode       = '<xsl:value-of select="$l"/>'
                         and lt.isdirect           = 0
                         and lt.enabled            = 1
                         and o.content_type        = '<xsl:value-of select="$ct"/>'
                         and o.endofprocessing &gt;= trunc(sysdate)
                         and o.active_flag         = 1 
                         and oc.modus              = '<xsl:value-of select="$modus"/>'
                         and oc.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/> 
                         and oc.batch_number       = ' <xsl:value-of select="$batchnumber"/>'                       
                  </xsl:when>                    
              </xsl:choose>
            </sql:query>
          </sql:execute-query>
        </xsl:when>
        <xsl:when test="$isdirect='1'">
          <sql:execute-query>
            <sql:query name="direct">   
              <xsl:choose>
                <xsl:when test="$ct='PMT_Translated'">    
                  select o.object_id
                       , o.localisation
                       , '<xsl:value-of select="$ct"/>' as content_type
                       , '<xsl:value-of select="$ts"/>' as runtimestamp
                    from (select locale, division
                            from language_translations
                           where isdirect = 1
                             and enabled  = 1
                             and locale   = '<xsl:value-of select="$l"/>'
                             and division = '<xsl:value-of select="$division"/>'
                         ) lt
                  inner join (select * 
                                from object_master_data 
                               where object_type = '<xsl:value-of select="$objecttype"/>'
                                 and division    = '<xsl:value-of select="$division"/>'
                             ) omd
                  on lt.division = omd.division
                  inner join (select oc.object_id
                                   , oc.localisation  
                                 from octl_control oc
                                inner join mv_co_object_id mvco 
                                   on mvco.object_id        = oc.object_id
                                  and mvco.deleted          = 0
                                  and mvco.eop           &gt; trunc(sysdate)
                                where oc.modus              = '<xsl:value-of select="$modus"/>'
                                  and oc.content_type       = '<xsl:value-of select="$ct"/>'
                                  and oc.localisation       = '<xsl:value-of select="$l"/>'
                                  and oc.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/> 
                              ) o
                     on o.object_id    = omd.object_id
                    and o.localisation = lt.locale
                  inner join (select object_id
                                   , localisation 
                               from octl
                              where content_type = 'PMT_Localised'
                                and status       = 'Final Published'
                                and localisation like 'master_%'
                             ) localized
                   on o.object_id = localized.object_id
                  and 'master_'||substr(o.localisation,4,2) = localized.localisation 
                </xsl:when>
                <xsl:when test="$ct='Categorization_Translated' or $ct='PText_Translated'">  
                    <!--called for Categrorization Direct Translation only -->
                     select distinct
                             o.content_type
                            ,o.localisation
                            ,o.object_id
                            ,1 as batch_number
                            ,'<xsl:value-of select="$runts19"/>' as runtimestamp
                            ,'CE' as division
                      from (select oc.content_type
                                 , oc.localisation
                                 , oc.object_id 
                             from octl_control oc
                       inner join octl o1
                               on o1.content_type           = oc.content_type
                              and o1.localisation           = oc.localisation
                              and o1.object_id              = oc.object_id
                            where oc.modus                  = '<xsl:value-of select="$modus"/>'
                              and oc.content_type           = '<xsl:value-of select="$ct"/>'
                              and oc.needsprocessing_flag  in <xsl:value-of select="$v_needsprocessing"/>
                              and o1.endofprocessing    &gt;= trunc(sysdate)
                              and o1.active_flag            = 1
                           ) o                       
                inner join (select locale
                              from language_translations
                             where isdirect = 1
                               and enabled  = 1
                               and locale   = '<xsl:value-of select="$l"/>'
                               and division = 'CE'
                               and '<xsl:value-of select="$division"/>' = 'CE'
                           ) lt <!-- All category trees are treated as belonging to CE, and we do not want to process it twice -->
                        on o.localisation = lt.locale    
                </xsl:when>
                <xsl:when test="$ct='RangeText_Translated'">  
                    <!--called for RangeText Direct Translation only -->
                     select distinct o.content_type
                          , o.localisation
                          , o.object_id
                          , 1 as batch_number
                          , '<xsl:value-of select="$runts19"/>' as runtimestamp
                          , 'CE' as division
                      from (select oc.content_type, oc.localisation, oc.object_id 
                             from octl_control oc
                            inner join octl o1
                               on o1.content_type  = oc.content_type
                              and o1.localisation  = oc.localisation
                              and o1.object_id     = oc.object_id
                            where oc.modus         = '<xsl:value-of select="$modus"/>'
                              and oc.content_type  = '<xsl:value-of select="$ct"/>'
                              and oc.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
                              and o1.endofprocessing &gt;= trunc(sysdate)
                              and o1.active_flag   = 1
                           ) o
                inner join (select locale
                              from language_translations
                             where isdirect        = 1
                               and enabled         = 1
                               and locale          = '<xsl:value-of select="$l"/>'
                            ) lt 
                        on o.localisation = lt.locale    
                </xsl:when>                
              </xsl:choose>                
            </sql:query>
          </sql:execute-query>
        </xsl:when>          
      </xsl:choose>
      <store-outputs/>
    </entries>
  </xsl:template>
</xsl:stylesheet>
