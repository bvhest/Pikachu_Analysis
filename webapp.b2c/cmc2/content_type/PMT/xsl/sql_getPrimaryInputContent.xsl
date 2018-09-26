<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:sql="http://apache.org/cocoon/SQL/2.0"
        xmlns:cinclude="http://apache.org/cocoon/include/1.0">

  <xsl:import href="base.xsl"/>
  
  <xsl:param name="ctURL"/>
  <xsl:param name="ts"/>
  <xsl:param name="ct"/>
  <xsl:param name="runmode"/>
  <xsl:param name="reload"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:variable name="apos"><xsl:text>'</xsl:text></xsl:variable>
  
  <!-- -->
  <xsl:template match="/root">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- -->
  <xsl:template match="entries[sql:rowset/sql:row]">

    <entries>
       <xsl:attribute name="islatin"><xsl:value-of select="sql:rowset/sql:row[1]/sql:islatin" /></xsl:attribute>
       <xsl:copy-of select="@*|node()[not(local-name() = 'rowset')]"/>

    <octl ct="PMT_Translated">
      <sql:execute-query>
        <sql:query>
          <xsl:variable name="rowset" select="sql:rowset"/>
          <xsl:for-each select="distinct-values(sql:rowset/sql:row/sql:localisation)">
            <xsl:variable name="v-locale" select="."/>
            <xsl:if test="position() != 1">union</xsl:if>
              select o.active_flag
                   , oc.batch_number
                   , o.content_type
                   , to_char(o.endofprocessing,'yyyy-mm-dd"T"hh24:mi:ss') endofprocessing
                   , oc.intransaction_flag
                   , to_char(os.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
                   , o.localisation
                   , to_char(os.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                   , oc.needsprocessing_flag
                   , to_char(oc.needsprocessing_ts,'yyyy-mm-dd"T"hh24:mi:ss') needsprocessing_ts
                   , o.object_id
                   , to_char(o.startofprocessing,'yyyy-mm-dd"T"hh24:mi:ss') startofprocessing
                   , os.status
                   , os.marketingversion
                   , o.remark
                   , o.islocalized
                   , os.data
                   , (select gtin
                        from mv_co_object_id_country mcoc
                       where mcoc.object_id = o.object_id
                         and mcoc.country = substr(o.localisation, 4, 2)
                         and rownum = 1
                     ) as gtin
                from octl o
     left outer join octl_control oc
                  on oc.content_type = o.content_type
                 and oc.localisation = o.localisation 
                 and oc.object_id    = o.object_id 
          inner join octl_store os
                  on os.content_type = o.content_type
                 and os.localisation = o.localisation
                 and os.object_id    = o.object_id
               where o.content_type = '<xsl:value-of select="$ct"/>'
                 and o.localisation = '<xsl:value-of select="$v-locale"/>'
                 and oc.modus       = '<xsl:value-of select="$modus"/>'
                 and (os.object_id, os.masterlastmodified_ts, os.lastmodified_ts)
                  in  (select object_id
                            , to_date(mlm,'YYYYMMDDHH24MISS') as mlm
                            , to_date(substr(max(version),16),'YYYYMMDDHH24MISS') as lm
                         from  (select object_id
                                     , to_char(masterlastmodified_ts,'YYYYMMDDHH24MISS') as mlm
                                     , to_char(masterlastmodified_ts,'YYYYMMDDHH24MISS') || '-' || to_char(lastmodified_ts,'YYYYMMDDHH24MISS') as version
                                  from octl_store
                                 where content_type = '<xsl:value-of select="$ct"/>'
                                   and localisation = '<xsl:value-of select="$v-locale"/>'
                                   and (object_id , to_char(masterlastmodified_ts,'yyyymmdd"T"hh24miss'))
                                    in (<xsl:for-each select="$rowset/sql:row[sql:localisation=$v-locale]">
                                         select '<xsl:value-of select="sql:object_id"/>','<xsl:value-of select="sql:masterlastmodified_ts"/>' from dual <xsl:if test="following-sibling::*[sql:localisation=$v-locale]"> union
</xsl:if>
                                        </xsl:for-each>)
                               )
                       group by object_id, mlm
                      )
          </xsl:for-each>
        </sql:query>
      </sql:execute-query>
    </octl>
    
    <xsl:variable name="localisationsENLOC">
      <xsl:for-each select="distinct-values(sql:rowset/sql:row/sql:localisation)">'<xsl:value-of select="."/>',</xsl:for-each>      
    </xsl:variable>
    <xsl:variable name="localisations-string-ENLOC">
      <xsl:value-of select="concat('(',substring($localisationsENLOC,1,string-length($localisationsENLOC)-1),')')"/>
    </xsl:variable>
    
    <octl ct="PMT_LocContent">
      <sql:execute-query>
        <sql:query>      
          select   o.active_flag
                  ,oc.batch_number
                  ,o.content_type
                  ,to_char(o.endofprocessing,'yyyy-mm-dd"T"hh24:mi:ss') endofprocessing
                  ,oc.intransaction_flag
                  ,to_char(o.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
                  ,o.localisation
                  ,to_char(o.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                  ,oc.needsprocessing_flag
                  ,to_char(oc.needsprocessing_ts,'yyyy-mm-dd"T"hh24:mi:ss') needsprocessing_ts
                  ,o.object_id
                  ,to_char(o.startofprocessing,'yyyy-mm-dd"T"hh24:mi:ss') startofprocessing
                  ,o.status
                  ,o.marketingversion
                  ,o.remark
                  ,o.islocalized
                  ,o.data
          from octl o
          left outer join octl_control oc
            on oc.content_type         = o.content_type
           and oc.localisation         = o.localisation 
           and oc.object_id            = o.object_id 
           and oc.modus                = '<xsl:value-of select="$modus"/>'
          where o.content_type         = 'PMT_LocContent' 
            and o.status               = 'Loaded'
            and o.localisation in <xsl:value-of select="$localisations-string-ENLOC"/>
            and o.object_id in (<xsl:for-each select="sql:rowset/sql:row">
                                select '<xsl:value-of select="sql:object_id"/>' from dual <xsl:if test="following-sibling::*"> union </xsl:if>
                              </xsl:for-each>)
          </sql:query>
        </sql:execute-query>
      </octl>
    
    <octl ct="PMT_Master">
      <sql:execute-query>
          <sql:query>      
            select   o.active_flag
                    ,oc.batch_number
                    ,o.content_type
                    ,to_char(o.endofprocessing,'yyyy-mm-dd"T"hh24:mi:ss') endofprocessing
                    ,oc.intransaction_flag
                    ,to_char(o.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
                    ,o.localisation
                    ,to_char(o.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                    ,oc.needsprocessing_flag
                    ,to_char(oc.needsprocessing_ts,'yyyy-mm-dd"T"hh24:mi:ss') needsprocessing_ts
                    ,o.object_id
                    ,to_char(o.startofprocessing,'yyyy-mm-dd"T"hh24:mi:ss') startofprocessing
                    ,o.status
                    ,o.marketingversion
                    ,o.remark
                    ,o.islocalized
                    ,o.data
            from octl o
 left outer join octl_control oc
              on oc.content_type          = o.content_type
             and oc.localisation          = o.localisation 
             and oc.object_id             = o.object_id 
             and oc.modus                 = '<xsl:value-of select="$modus"/>'
           where o.content_type           = 'PMT_Master' 
             and o.localisation           = 'master_global' 
             and o.object_id in (<xsl:for-each select="sql:rowset/sql:row">
                                 select '<xsl:value-of select="sql:object_id"/>' from dual <xsl:if test="following-sibling::*"> union
</xsl:if>
                                </xsl:for-each>
                                )
            </sql:query>
          </sql:execute-query>
        </octl>                
                    
    <xsl:if test="$reload='true'">
      <octl ct="PMT">
        <sql:execute-query>
          <sql:query>
            select o.object_id
                 , o.localisation
                 , TO_CHAR(o.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                 , TO_CHAR(o.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
            from octl o
            where o.content_type='PMT'
            and o.localisation in ('<xsl:value-of select="string-join((distinct-values(sql:rowset/sql:row/sql:localisation), 'master_global'), concat($apos,',',$apos))"/>')
            and o.object_id in (<xsl:for-each select="sql:rowset/sql:row">
                                select '<xsl:value-of select="sql:object_id"/>' from dual <xsl:if test="following-sibling::*"> union
</xsl:if>
                              </xsl:for-each>)
          </sql:query>
        </sql:execute-query>
      </octl>
    </xsl:if>

    <xsl:variable name="localisations">
      <xsl:for-each select="distinct-values(sql:rowset/sql:row/sql:localisation)">'<xsl:value-of select="."/>',</xsl:for-each>
      <xsl:if test="$l-master-assets-from = 'assetlist'">
        <xsl:text>'master_global',</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="localisations-string">
      <xsl:value-of select="concat('(',substring($localisations,1,string-length($localisations)-1),')')"/>
    </xsl:variable>
    <octl ct="AssetList">
      <sql:execute-query>
        <sql:query>      
          select   o.active_flag
                  ,oc.batch_number
                  ,o.content_type
                  ,to_char(o.endofprocessing,'yyyy-mm-dd"T"hh24:mi:ss') endofprocessing
                  ,oc.intransaction_flag
                  ,to_char(o.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
                  ,o.localisation
                  ,to_char(o.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                  ,oc.needsprocessing_flag
                  ,to_char(oc.needsprocessing_ts,'yyyy-mm-dd"T"hh24:mi:ss') needsprocessing_ts
                  ,o.object_id
                  ,to_char(o.startofprocessing,'yyyy-mm-dd"T"hh24:mi:ss') startofprocessing
                  ,o.status
                  ,o.marketingversion
                  ,o.remark
                  ,o.islocalized
                  ,o.data
          from octl o
          left outer join octl_control oc
            on oc.content_type         = o.content_type
           and oc.localisation         = o.localisation 
           and oc.object_id            = o.object_id 
           and oc.modus                = '<xsl:value-of select="$modus"/>'
          where o.content_type         = 'AssetList' 
            and o.localisation in <xsl:value-of select="$localisations-string"/>
            and o.object_id in (<xsl:for-each select="sql:rowset/sql:row">
                                select '<xsl:value-of select="sql:object_id"/>' from dual <xsl:if test="following-sibling::*"> union
</xsl:if>
                              </xsl:for-each>)
          </sql:query>
        </sql:execute-query>
      </octl>
    </entries>
  </xsl:template>  

</xsl:stylesheet>