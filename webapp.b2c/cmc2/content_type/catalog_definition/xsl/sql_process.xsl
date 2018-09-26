<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="content">
    <content/>
  </xsl:template>
  <!-- -->
  <xsl:template match="process">
    <process>
      <xsl:for-each select="../content/catalog-definition/object">
        <!--  in case of a PackagingCatalog, provide a value for the value of the lastmodified-column: --> 
        <xsl:variable name="lastmodified" select="if (../../../@o='PackagingCatalog') then ../@DocTimeStamp else lastmodified"/>
        <!-- -->
        <query name="sql_process">
          <xsl:attribute name="catalog" select="customer_id"/>
          <xsl:attribute name="o" select="@o"/>
          <xsl:attribute name="country" select="country"/>
            MERGE INTO catalog_objects ctg
                  using (
                    select   '<xsl:value-of select="../../../@o"/>' as catalog_id
                            ,'<xsl:value-of select="customer_id"/>' as customer_id
                            ,'<xsl:value-of select="country"/>' as country
                            ,'<xsl:value-of select="@o"/>' as object_id
                            ,'<xsl:value-of select="division"/>' as division
                            ,'<xsl:value-of select="gtin"/>' as gtin
                            ,to_date('<xsl:value-of select="sop"/>','yyyy-mm-dd"T"hh24:mi:ss') as sop
                            ,to_date('<xsl:value-of select="if (somp != '') then somp else sop"/>','yyyy-mm-dd"T"hh24:mi:ss') as somp
                            ,to_date('<xsl:value-of select="eop"/>','yyyy-mm-dd"T"hh24:mi:ss') as eop
                            ,to_date('<xsl:value-of select="sos"/>','yyyy-mm-dd"T"hh24:mi:ss') as sos
                            ,to_date('<xsl:value-of select="eos"/>','yyyy-mm-dd"T"hh24:mi:ss') as eos
                            ,to_date('<xsl:value-of select="$lastmodified"/>','yyyy-mm-dd"T"hh24:mi:ss') as lastmodified
                            ,'<xsl:value-of select="buy_online"/>' as buy_online
                            ,'<xsl:value-of select="local_going_price"/>' as local_going_price
                            ,'<xsl:value-of select="deleted"/>' as deleted
                            ,to_date('<xsl:value-of select="delete_after_date"/>','yyyy-mm-dd"T"hh24:mi:ss') as delete_after_date
                            ,'<xsl:value-of select="priority"/>' as priority
                    from dual) s
                    on (ctg.catalog_id = s.catalog_id and ctg.object_id=s.object_id)
                    when matched then
                      update set
                        ctg.customer_id = s.customer_id,
                        ctg.country = s.country,
                        ctg.gtin = s.gtin,
                        ctg.sop = s.sop,
                        ctg.somp = s.somp,
                        ctg.eop = s.eop,
                        ctg.sos = s.sos,
                        ctg.eos = s.eos,
                        ctg.buy_online = s.buy_online,
                        ctg.local_going_price = s.local_going_price,
                        ctg.deleted = s.deleted,
                        ctg.delete_after_date = s.delete_after_date,
                        ctg.priority = s.priority,
                        ctg.lastmodified = s.lastmodified,
                        ctg.division = s.division,
                        ctg.needsprocessing_flag = 1
                      where   ctg.lastmodified &lt; s.lastmodified and (
                          ctg.customer_id != s.customer_id or
                          ctg.country != s.country or
                          ctg.gtin != s.gtin or
                          ctg.sop != s.sop or
                          ctg.somp != s.somp or
                          ctg.eop != s.eop or
                          ctg.sos != s.sos or
                          ctg.eos != s.eos or
                          ctg.buy_online != s.buy_online or
                          nvl(ctg.local_going_price,'0') != nvl(s.local_going_price,'0') or
                          ctg.deleted != s.deleted or
                          nvl(ctg.delete_after_date,to_date('1900-01-01','YYYY-MM-DD')) != nvl(s.delete_after_date,to_date('1900-01-01','YYYY-MM-DD')) or
                          ctg.priority != s.priority or
                          ctg.division != s.division
                        )
                      when not matched then
                                   insert (
                                           ctg.catalog_id
                                          ,ctg.customer_id
                                          ,ctg.country
                                          ,ctg.lastmodified
                                          ,ctg.object_id
                                          ,ctg.gtin
                                          ,ctg.sop
                                          ,ctg.somp
                                          ,ctg.eop
                                          ,ctg.sos
                                          ,ctg.eos
                                          ,ctg.buy_online
                                          ,ctg.local_going_price
                                          ,ctg.deleted
                                          ,ctg.delete_after_date
                                          ,ctg.priority
                                          ,ctg.division
                                          ,ctg.needsprocessing_flag
                                          )
                                   values (
                                           s.catalog_id
                                          ,s.customer_id
                                          ,s.country
                                          ,s.lastmodified
                                          ,s.object_id
                                          ,s.gtin
                                          ,s.sop
                                          ,s.somp
                                          ,s.eop
                                          ,s.sos
                                          ,s.eos
                                          ,s.buy_online
                                          ,s.local_going_price
                                          ,s.deleted
                                          ,s.delete_after_date
                                          ,s.priority
                                          ,s.division
                                          ,1
                                          )
          </query>
        </xsl:for-each>
      </process>
    </xsl:template>
</xsl:stylesheet>
