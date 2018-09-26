<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="source sql">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="initialtableload">false</xsl:param>
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:variable name="now" select="if($initialtableload='false') then substring(xs:string(current-dateTime()),1,19) else '1900-01-01T00:00:00'"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="node()|@*"/>
        <sql>
          <xsl:apply-templates select="entries/entry[@ct='PMT_Translated']" mode="updateneedsprocessing"/>
        </sql>        
        <sql>
          <xsl:apply-templates select="entries/entry" mode="updateoctltranslations"/>
        </sql>
      </xsl:copy>
    </root>
  </xsl:template>
 
   <xsl:template match="entry" mode="updateoctltranslations">
      <!-- Merge (upsert) a row into OCTL_TRANSLATIONS for each OCTL in the the file -->
      <xsl:variable name="v_entries" select="../../entries"/>
      <xsl:variable name="v_entry" select="."/>
      <xsl:variable name="prefix">
        <xsl:choose>
          <xsl:when test="@ct='PMT_Translated'">pbatch</xsl:when>
          <xsl:when test="@ct='Categorization_Translated'">cbatch</xsl:when>
          <xsl:when test="@ct='PText_Translated'">bbatch</xsl:when>
        </xsl:choose>     
      </xsl:variable>      
      <xsl:variable name="v_category">
        <xsl:choose>
          <xsl:when test="@ct='PMT_Translated'"><xsl:value-of select="ancestor::entries/originalentriesattributes/category"/></xsl:when>
          <xsl:when test="@ct='Categorization_Translated'">Default</xsl:when>
          <xsl:when test="@ct='PText_Translated'">Default</xsl:when>
          <xsl:otherwise><xsl:value-of select="$v_entries/@category"/></xsl:otherwise>          
        </xsl:choose>     
      </xsl:variable>        
      <xsl:variable name="v_routingCode">
        <xsl:choose>
          <xsl:when test="@ct='PMT_Translated'"><xsl:value-of select="ancestor::entries/originalentriesattributes/routingCode"/></xsl:when>
          <xsl:when test="@ct='Categorization_Translated'">Default</xsl:when>
          <xsl:when test="@ct='PText_Translated'">Default</xsl:when>
          <xsl:otherwise><xsl:value-of select="$v_entries/@routingCode"/></xsl:otherwise>
        </xsl:choose>     
      </xsl:variable>         
      <xsl:if test="not(result='Identical modification dates')">      
        <sql:execute-query>
          <sql:query name="importTranslationStore: merge into octl_translations">
            <xsl:variable name="v_storelocales" select="for $i in //entries/entry[@o=current()/@o]/@l return concat($i,',')"/>
            
            <!-- only update if not identical; otherwise we leave the row looking like there was not a valid import -->
            merge into octl_translations ot
            using (select '<xsl:value-of select="ancestor::entries/@ct"/>' content_type
                        , '<xsl:value-of select="@l"/>'                    localisation
                        , '<xsl:value-of select="@o"/>'                    object_id
                        , to_date('<xsl:value-of select="content/node()/@masterLastModified"/>','YYYY-MM-DD"T"HH24:MI:SS')   masterlastmodified_ts
                        , to_date('<xsl:value-of select="content/node()/@lastModified"/>','YYYY-MM-DD"T"HH24:MI:SS')         lastmodified_ts
                        , '<xsl:value-of select="ancestor::entries/originalentriesattributes/filename"/>' filename                                        
                        , to_date('<xsl:value-of select="ancestor::entries/originalentriesattributes/docTimeStamp"/>','YYYYMMDD"T"HH24MISS') doctimestamp
                        , '<xsl:value-of select="ancestor::entries/originalentriesattributes/targetLocale"/>'                                targetlocale
                        , 'UNKNOWN'                storelocales
                        , '<xsl:value-of select="$v_category"/>'                                    category
                        , '<xsl:value-of select="$v_routingCode"/>'                                 routing_code                  
                        , '<xsl:value-of select="ancestor::entries/originalentriesattributes/workflow"/>'                                    workflow
                        , '<xsl:value-of select="ancestor::entries/originalentriesattributes/priority"/>'                                    priority
                        , '<xsl:value-of select="ancestor::entries/originalentriesattributes/fileobjectcount"/>'                                 fileobjectcount
                        , to_date('<xsl:value-of select="$now"/>','YYYY-MM-DD"T"HH24:MI:SS')                            import_ts
                        , '<xsl:value-of select="@valid"/>'                                                         valid
                        , '<xsl:value-of select="result"/>'                                                         result
                        , '<xsl:value-of select="$v_entry/content/Product/MarketingVersion"/>' marketingversion
                   from dual          
                  ) x
              on (ot.content_type          = x.content_type
              and ot.localisation          = x.localisation
              and ot.object_id             = x.object_id
              and ot.masterlastmodified_ts = x.masterlastmodified_ts
              and ot.lastmodified_ts       = x.lastmodified_ts
              and ot.workflow              = x.workflow
                 )
            when matched then update 
               set import_ts = x.import_ts
                 , valid = x.valid
                 , result = x.result                  
            when not matched then insert 
                  (content_type, localisation, object_id, masterlastmodified_ts, lastmodified_ts, filename, doctimestamp, targetlocale, storelocales, category, routing_code, workflow, priority, fileobjectcount, import_ts, valid, result,marketingversion)
               values 
                  (x.content_type, x.localisation, x.object_id, x.masterlastmodified_ts, x.lastmodified_ts, x.filename, x.doctimestamp, x.targetlocale, x.storelocales, x.category, x.routing_code, x.workflow, x.priority, x.fileobjectcount, x.import_ts, x.valid, x.result,x.marketingversion)
            </sql:query>
        </sql:execute-query>      
      </xsl:if>      
  </xsl:template>
  <!-- -->  
  <!--xsl:template match="content|originalentriesattributes"/-->
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->    
  <xsl:template match="entry[@ct='PMT_Translated'][not(octl-attributes/needsprocessing_flag) or octl-attributes/needsprocessing_flag = '-1']" mode="updateneedsprocessing"/>
  <!-- -->    
  <xsl:template match="entry[@ct='PMT_Translated'][octl-attributes/needsprocessing_flag != '-1']" mode="updateneedsprocessing">
      <xsl:if test="octl-attributes/querystatus != ''">
         <sql:execute-query>
            <sql:query name="importTranslationStore: update octl">
            update octl o
               set o.status = '<xsl:value-of select="octl-attributes/querystatus"/>'
             where o.content_type = '<xsl:value-of select="@ct"/>'
               and o.localisation = '<xsl:value-of select="@l"/>'
               and o.object_id    = '<xsl:value-of select="@o"/>'
               and exists (select 1 
                             from octl_control oc
                            where oc.modus        = '<xsl:value-of select="$modus"/>'
                              and oc.content_type = o.content_type
                              and oc.localisation = o.localisation
                              and oc.object_id    = o.object_id    
                              and oc.needsprocessing_flag != 0
                          )  
            </sql:query>
         </sql:execute-query>    
      </xsl:if>
      <sql:execute-query>
         <sql:query name="importTranslationStore: update octl_control">
         update octl_control
         set needsprocessing_flag = <xsl:value-of select="octl-attributes/needsprocessing_flag"/>
           , intransaction_flag   = 0
           , batch_number         = null
         where modus        = '<xsl:value-of select="$modus"/>'
           and content_type = '<xsl:value-of select="@ct"/>'
           and localisation = '<xsl:value-of select="@l"/>'
           and object_id    = '<xsl:value-of select="@o"/>'
           and needsprocessing_flag != 0
         </sql:query>
      </sql:execute-query>
  </xsl:template>
  <!-- -->    
</xsl:stylesheet>