<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

<xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="store-outputs">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="activate"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->  
  <xsl:template match="placeholder" mode="activate">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <sql:execute-query>
        <sql:query name="createPlaceholders">  
            insert into octl  (content_type
                              ,localisation
                              ,object_id
                              ,needsprocessing_flag
                              ,needsprocessing_ts
                              ,intransaction_flag
                              ,masterlastmodified_ts
                              ,lastmodified_ts
                              ,startofprocessing
                              ,endofprocessing
                              ,active_flag
                              ,status
                              ,batch_number
                              ,remark
                              ,islocalized)
                       select  '<xsl:value-of select="@ct"/>'
                              ,'<xsl:value-of select="@l"/>'
                              ,'<xsl:value-of select="@o"/>'
                              ,0
                              ,to_date('01/01/1900','dd/mm/yyyy')
                              ,0
                              ,to_date('01/01/1900','dd/mm/yyyy')
                              ,TRUNC(SYSDATE)
                              ,to_date('01/01/1900','dd/mm/yyyy')
                              ,to_date('31/12/4712','dd/mm/yyyy')
                              ,1
                              ,'PLACEHOLDER'
                              ,NULL
                              ,NULL
                              ,0
                     from dual
                     where not exists (select 1 
                                         from octl oc
                                        where oc.content_type = '<xsl:value-of select="@ct"/>'
                                          and oc.localisation = '<xsl:value-of select="@l"/>'
                                          and oc.object_id    = '<xsl:value-of select="@o"/>'
                                      ) 
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>
  <!-- -->  
  <xsl:template match="relation" mode="activate">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <sql:execute-query>
        <sql:query name="createPlaceholdersRelations">  
          insert into octl_relations (output_content_type
                                     ,output_localisation
                                     ,output_object_id
                                     ,input_content_type
                                     ,input_localisation
                                     ,input_object_id
                                     ,issecondary
                                     ,isderived) 
                             select  '<xsl:value-of select="@ct-out"/>'
                                    ,'<xsl:value-of select="@l-out"/>'
                                    ,'<xsl:value-of select="@o-out"/>'
                                    ,'<xsl:value-of select="@ct-in"/>'
                                    ,'<xsl:value-of select="@l-in"/>'
                                    ,'<xsl:value-of select="@o-in"/>'
                                    ,'<xsl:value-of select="@secondary"/>'
                                    ,1
                           from dual
                           where not exists (select 1 
                                               from octl_relations
                                              where output_content_type = '<xsl:value-of select="@ct-out"/>'
                                                and output_localisation = '<xsl:value-of select="@l-out"/>'
                                                and output_object_id    = '<xsl:value-of select="@o-out"/>'
                                                and input_content_type  = '<xsl:value-of select="@ct-in"/>'
                                                and input_localisation  = '<xsl:value-of select="@l-in"/>'
                                                and input_object_id     = '<xsl:value-of select="@o-in"/>'
                                             )
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()" mode="activate">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="activate"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
