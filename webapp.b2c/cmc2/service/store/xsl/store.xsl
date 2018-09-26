<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0">
  <!-- -->
  <xsl:param name="reload"/>
  <xsl:param name="dir"/>
  <xsl:param name="runmode"/>
  
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry[@valid='true' and not(contains(result,'out-of-date'))]">
    <xsl:variable name="apos">'</xsl:variable>
    <xsl:choose>
      <xsl:when test="not($reload='true')">
        <xsl:variable name="filename" select="concat('/',@ct,'/',@l,'/',translate(@o,'/','_'),
                                                     '.',translate(octl-attributes/masterlastmodified_ts,'-/:T',''),
                                                     '.',translate(octl-attributes/lastmodified_ts,'-/:T','') )"/>
        <!-- Normal processing - insert into the store_v view, which has a trigger behind it -->
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()"/>
          <source:write>
            <source:source>
              <xsl:value-of select="concat($dir,$filename,'.xml')"/>
            </source:source>
            <source:fragment>
              <xsl:choose>
                <xsl:when test="content/*">
                  <xsl:copy-of copy-namespaces="no" select="content/*"/>
                </xsl:when>
                <xsl:otherwise>
                  <root/>
                </xsl:otherwise>
              </xsl:choose>
            </source:fragment>
          </source:write>
          <sql:execute-query name="store: insert store_v">
            <sql:query name="store: insert store_v">
                  insert into store_v(content_type,localisation,object_id,masterlastmodified_ts,lastmodified_ts, needsprocessing_flag,
                                      startofprocessing, endofprocessing, active_flag, status, marketingversion, remark, 
                                      islocalized, valid, result, updatedata, data)
                  values('<xsl:value-of select="@ct"/>',
                         '<xsl:value-of select="@l"/>',
                         '<xsl:value-of select="@o"/>',
                         to_date('<xsl:value-of select="substring(octl-attributes/masterlastmodified_ts,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss'),
                         to_date('<xsl:value-of select="substring(octl-attributes/lastmodified_ts,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss'),
                         '<xsl:value-of select="if(octl-attributes/needsprocessing_flag != '') then octl-attributes/needsprocessing_flag else 0"/>',
                         to_date('<xsl:value-of select="substring(octl-attributes/startofprocessing,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss'),
                         to_date('<xsl:value-of select="substring(octl-attributes/endofprocessing,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss'),
                         '<xsl:value-of select="octl-attributes/active_flag"/>',
                         '<xsl:value-of select="octl-attributes/status"/>',
                         '<xsl:value-of select="octl-attributes/marketingversion"/>',
                         '<xsl:value-of select="replace(octl-attributes/remark, $apos, concat($apos,$apos))"/>',
                         '<xsl:value-of select="octl-attributes/islocalized"/>',
                         '<xsl:value-of select="@valid"/>',
                         '<xsl:value-of select="result"/>',
                         '<xsl:value-of select="octl-attributes/updatedata"/>',
                         '<xsl:value-of select="concat('file:/',$filename)"/>')
              </sql:query>
          </sql:execute-query>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <!-- Reload processing - update the tables directly, avoiding the trigger which updates the next content typee in the chain -->
        <xsl:variable name="filename" select="concat('/',@ct,'/',@l,'/',translate(@o,'/','_'),
                                        '.',translate(currentmasterlastmodified_ts,'-/:T',''),
                                        '.',translate(currentlastmodified_ts,'-/:T','') )"/>
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()"/>
          <source:write>
            <source:source>
              <xsl:value-of select="concat($dir,$filename,'.xml')"/>
            </source:source>
            <source:fragment>
              <xsl:choose>
                <xsl:when test="content/*">
                  <xsl:copy-of copy-namespaces="no" select="content/*"/>
                </xsl:when>
                <xsl:otherwise>
                  <root/>
                </xsl:otherwise>
              </xsl:choose>
            </source:fragment>
          </source:write>
          <sql:execute-query name="store: update octl_control when valid = true">
            <sql:query name="store: update octl_control when valid = true">        
               update octl_control
                  set batch_number         = null
                    , needsprocessing_flag = 0 -- modified for the SEO-project: why not reset all falgs after a succesfull transaction
                    , intransaction_flag   = 0
                where modus        = '<xsl:value-of select="$modus"/>'
                  and content_type = '<xsl:value-of select="@ct"/>'
                  and localisation = '<xsl:value-of select="@l"/>'
                  and object_id    = '<xsl:value-of select="@o"/>'
                </sql:query>
          </sql:execute-query>
          <sql:execute-query name="store: update octl">
            <sql:query name="store: update octl">        
                  update octl
                  set remark = '<xsl:value-of select="replace(octl-attributes/remark, $apos, concat($apos,$apos))"/>'
                     ,status = '<xsl:value-of select="octl-attributes/status"/>'
                     ,marketingversion = '<xsl:value-of select="octl-attributes/marketingversion"/>'
                     ,batch_number = null
                     ,data = '<xsl:value-of select="concat('file:/',$filename)"/>'
                  where content_type = '<xsl:value-of select="@ct"/>'
                  and localisation = '<xsl:value-of select="@l"/>'
                  and object_id = '<xsl:value-of select="@o"/>'
                </sql:query>
          </sql:execute-query>
          <sql:execute-query name="store: update octl_store">
            <sql:query name="store: update octl_store">
                update octl_store os
                set marketingversion = '<xsl:value-of select="octl-attributes/marketingversion"/>'
                   ,status = '<xsl:value-of select="octl-attributes/status"/>'
                   ,data='<xsl:value-of select="concat('file:/',$filename)"/>'
                where content_type = '<xsl:value-of select="@ct"/>'
                  and localisation = '<xsl:value-of select="@l"/>'
                  and object_id = '<xsl:value-of select="@o"/>'
                  and masterlastmodified_ts = (
                      select masterlastmodified_ts from octl o 
                      where o.content_type = os.content_type
                        and o.localisation = os.localisation
                        and o.object_id = os.object_id
                      )
                  and lastmodified_ts = (
                      select lastmodified_ts from octl o 
                      where o.content_type = os.content_type
                        and o.localisation = os.localisation
                        and o.object_id = os.object_id
                      )
              </sql:query>
          </sql:execute-query>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry[@valid='true' and result='out-of-date'] ">
    <xsl:variable name="filename" select="concat('/',@ct,'/',@l,'/',translate(@o,'/','_'),
                                  '.',translate(octl-attributes/masterlastmodified_ts,'-/:T',''),
                                  '.',translate(octl-attributes/lastmodified_ts,'-/:T','') )"/>
    <xsl:if test="not($reload='true')">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
        <source:write>
          <source:source>
            <xsl:value-of select="concat($dir,$filename,'.xml')"/>
          </source:source>
          <source:fragment>
            <xsl:choose>
              <xsl:when test="content/*">
                <xsl:copy-of copy-namespaces="no" select="content/*"/>
              </xsl:when>
              <xsl:otherwise>
                <root/>
              </xsl:otherwise>
            </xsl:choose>
          </source:fragment>
        </source:write>
        <sql:execute-query name="store: insert octl_store">
          <sql:query isstoredprocedure="true" name="store: insert octl_store">
BEGIN
   insert into octl_store 
         (content_type,localisation,object_id,masterlastmodified_ts,lastmodified_ts,status,marketingversion,data)
   values( '<xsl:value-of select="@ct"/>'
         , '<xsl:value-of select="@l"/>'
         , '<xsl:value-of select="@o"/>'
         , to_date('<xsl:value-of select="substring(octl-attributes/masterlastmodified_ts,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss')
         , to_date('<xsl:value-of select="substring(octl-attributes/lastmodified_ts,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss')
         , '<xsl:value-of select="octl-attributes/status"/>'
         , '<xsl:value-of select="octl-attributes/marketingversion"/>'
         , '<xsl:value-of select="concat('file:/',$filename)"/>'
         );
EXCEPTION
 WHEN OTHERS THEN NULL;          
END;     
              </sql:query>
        </sql:execute-query>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry[@valid='false' and not(@resetflagsonfailure='false')]">
    <xsl:if test="not($reload='true')">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
        <sql:execute-query name="store: update octl_control when valid = false">
          <sql:query name="store: update octl_control when valid = false">
            update octl_control
               set needsprocessing_flag = 0
                 , intransaction_flag   = 0
                 , batch_number         = null
             where modus        = '<xsl:value-of select="$modus"/>'
               and content_type = '<xsl:value-of select="@ct"/>'
               and localisation = '<xsl:value-of select="@l"/>'
               and object_id    = '<xsl:value-of select="@o"/>'
               and needsprocessing_flag != 0 -- modified for the SEO-project: flag may be negative= -2.
          </sql:query>
        </sql:execute-query>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template match="content"/>
  <!-- -->
</xsl:stylesheet>
