<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:sql="http://apache.org/cocoon/SQL/2.0"
        xmlns:cinclude="http://apache.org/cocoon/include/1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ctURL"/>
  <xsl:param name="ts"/>
  <xsl:param name="ct"/>
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <!-- -->
  <xsl:template match="/root">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->
  <xsl:template match="entries[sql:rowset/sql:row]">
    <entries>
    <xsl:copy-of select="@*|node()[not(local-name() = 'rowset')]"/>
    <xsl:choose>
      <xsl:when test="$ct='PMT'">      
        <octl ct="PMT_Translated">
          <sql:execute-query>
            <sql:query>
              select o.active_flag
                    ,oc.batch_number
                    ,o.content_type
                    ,to_char(o.endofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') endofprocessing
                    ,oc.intransaction_flag
                    ,to_char(os.lastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') lastmodified_ts
                    ,o.localisation
                    ,to_char(os.masterlastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') masterlastmodified_ts
                    ,oc.needsprocessing_flag
                    ,to_char(oc.needsprocessing_ts,'yyyy-mm-dd"t"hh24:mi:ss') needsprocessing_ts
                    ,o.object_id
                    ,to_char(o.startofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') startofprocessing
                    ,os.status
                    ,os.marketingversion
                    ,o.remark
                    ,o.islocalized
                    ,os.data
                from octl o
               inner join octl_control oc
                  on oc.content_type          = o.content_type
                 and oc.localisation          = o.localisation 
                 and oc.object_id             = o.object_id 
                 and oc.modus                 = '<xsl:value-of select="$modus"/>'
               inner join octl_store os
                  on o.content_type = os.content_type
                 and o.localisation = os.localisation
                 and o.object_id    = os.object_id
               where o.content_type = '<xsl:value-of select="$ct"/>'
                 and o.localisation = '<xsl:value-of select="sql:rowset/sql:row[1]/sql:localisation"/>'
                 and (os.object_id, os.masterlastmodified_ts, os.lastmodified_ts) in  (select object_id
                                                                                            , to_date(mlm,'YYYYMMDDHH24MISS') MLM
                                                                                            , to_date(substr(max(version),16),'YYYYMMDDHH24MISS') lm
                                                                                        from  (select object_id
                                                                                                     ,to_char(masterlastmodified_ts,'YYYYMMDDHH24MISS') mlm
                                                                                                     ,to_char(masterlastmodified_ts,'YYYYMMDDHH24MISS') || '-' || to_char(lastmodified_ts,'YYYYMMDDHH24MISS') version
                                                                                                 from octl_store
                                                                                                where content_type = '<xsl:value-of select="$ct"/>'
                                                                                                  and localisation = '<xsl:value-of select="sql:rowset/sql:row[1]/sql:localisation"/>'
                                                                                                  and (object_id , to_char(masterlastmodified_ts,'YYYYMMDD"T"HH24MISS'))
                                                                                                   in (<xsl:for-each select="sql:rowset/sql:row">
                                                                                                        select '<xsl:value-of select="sql:object_id"/>','<xsl:value-of select="sql:masterlastmodified_ts"/>' from dual <xsl:if test="following-sibling::*"> union
                                                               </xsl:if>
                                                                                                       </xsl:for-each>)
                                                                                                )
                                                                                       group by object_id, mlm
                                                                                      )
            </sql:query>
          </sql:execute-query>
        </octl>
        <octl ct="PMT_Master"><sql:execute-query>
              <sql:query>      
              select o.active_flag
                    ,oc.batch_number
                    ,o.content_type
                    ,to_char(o.endofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') endofprocessing
                    ,oc.intransaction_flag
                    ,to_char(os.lastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') lastmodified_ts
                    ,o.localisation
                    ,to_char(os.masterlastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') masterlastmodified_ts
                    ,oc.needsprocessing_flag
                    ,to_char(oc.needsprocessing_ts,'yyyy-mm-dd"t"hh24:mi:ss') needsprocessing_ts
                    ,o.object_id
                    ,to_char(o.startofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') startofprocessing
                    ,os.status
                    ,os.marketingversion
                    ,o.remark
                    ,o.islocalized
                    ,os.data
                from octl o
               inner join octl_control oc
                  on oc.content_type          = o.content_type
                 and oc.localisation          = o.localisation 
                 and oc.object_id             = o.object_id 
                 and oc.modus                 = '<xsl:value-of select="$modus"/>'
               inner join octl_store os 
                  on os.CONTENT_TYPE = o.CONTENT_TYPE 
                 and os.LOCALISATION = o.LOCALISATION 
                 and os.OBJECT_ID    = o.OBJECT_ID 
                 and os.MASTERLASTMODIFIED_TS = o.MASTERLASTMODIFIED_TS 
                 and  os.LASTMODIFIED_TS = o.LASTMODIFIED_TS
               where o.CONTENT_TYPE = 'PMT_Master' 
                 and o.LOCALISATION = 'master_global' 
                 and o.OBJECT_ID in (<xsl:for-each select="sql:rowset/sql:row">
                                      select '<xsl:value-of select="sql:object_id"/>' from dual <xsl:if test="following-sibling::*"> union
        </xsl:if>
                                    </xsl:for-each>)
                </sql:query>
              </sql:execute-query>
        </octl>
        <octl ct="AssetList">
          <sql:execute-query>
            <sql:query>      
              select o.active_flag
                    ,oc.batch_number
                    ,o.content_type
                    ,to_char(o.endofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') endofprocessing
                    ,oc.intransaction_flag
                    ,to_char(os.lastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') lastmodified_ts
                    ,o.localisation
                    ,to_char(os.masterlastmodified_ts,'yyyy-mm-dd"t"hh24:mi:ss') masterlastmodified_ts
                    ,oc.needsprocessing_flag
                    ,to_char(oc.needsprocessing_ts,'yyyy-mm-dd"t"hh24:mi:ss') needsprocessing_ts
                    ,o.object_id
                    ,to_char(o.startofprocessing,'yyyy-mm-dd"t"hh24:mi:ss') startofprocessing
                    ,os.status
                    ,os.marketingversion
                    ,o.remark
                    ,o.islocalized
                    ,os.data
               from octl o
               inner join octl_control oc
                  on oc.content_type          = o.content_type
                 and oc.localisation          = o.localisation 
                 and oc.object_id             = o.object_id 
                 and oc.modus                 = '<xsl:value-of select="$modus"/>'
              inner join octl_store os 
                 on os.CONTENT_TYPE = o.CONTENT_TYPE 
                and os.LOCALISATION = o.LOCALISATION 
                and os.OBJECT_ID = o.OBJECT_ID 
                and os.MASTERLASTMODIFIED_TS = o.MASTERLASTMODIFIED_TS 
                and  os.LASTMODIFIED_TS = o.LASTMODIFIED_TS
              where o.CONTENT_TYPE = 'AssetList' 
               and o.LOCALISATION = '<xsl:value-of select="sql:rowset/sql:row[1]/sql:localisation"/>' 
               and o.OBJECT_ID in (<xsl:for-each select="sql:rowset/sql:row">
                                    select '<xsl:value-of select="sql:object_id"/>' from dual <xsl:if test="following-sibling::*"> union
</xsl:if>
                                  </xsl:for-each>)
              </sql:query>
            </sql:execute-query>
        </octl>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="sql:rowset/sql:row"/>
      </xsl:otherwise>
    </xsl:choose>
    </entries>
  </xsl:template>  

  <xsl:template match="sql:rowset/sql:row">
    <cinclude:include src="{$ctURL}{$ct}/process/{sql:localisation}/{$ts}/{sql:masterlastmodified_ts}/{sql:object_id}" />
  </xsl:template>

</xsl:stylesheet>