<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="destination"/>
  <xsl:param name="customer_id"/>
  <xsl:param name="country"/>`
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <!-- -->
  <xsl:template match="/">
    <root name="merge-catalog" destination="{$destination}">
      <xsl:if test="$customer_id != ''">
        <xsl:attribute name="customer-id" select="$customer_id"/>
      </xsl:if>
      <xsl:if test="$country != ''">
        <xsl:attribute name="country" select="$country"/>
      </xsl:if>
      
      <sql:execute-query>
        <sql:query>
          <xsl:choose>
            <xsl:when test="$destination = 'catalog_objects_productmasterdata.dat'">
              merge into catalog_objects co
              using (select catalog_id
                          , object_id
                          , customer_id
                          , lastmodified
              <xsl:choose>
                <xsl:when test="$modus = 'BATCH'">
                      from catalog_objects_pmd_ext
                </xsl:when>
                <xsl:otherwise>
                      from catalog_objects_pmd_fl_ext
                </xsl:otherwise>
              </xsl:choose>
                     where catalog_id is not null
                     ) co_ext
                 on (co.catalog_id   = co_ext.catalog_id
                    and co.object_id = co_ext.object_id
                    )
              when not matched then
                 insert ( co.catalog_id                
                         ,co.object_id
                         ,co.customer_id
                         ,co.lastmodified                            
                         ,co.needsprocessing_flag)
                 values ( co_ext.catalog_id
                         ,co_ext.object_id
                         ,co_ext.customer_id                            
                         ,co_ext.lastmodified                                
                         ,1)
              log errors into err$_catalog_objects
                  ('Key:cat='||co_ext.catalog_id||',obj='||co_ext.object_id||',cust='||co_ext.customer_id||',ts='||co_ext.lastmodified)
                  reject limit unlimited
            </xsl:when>
            <xsl:when test="$destination = 'catalog_objects_care_master.dat'">
        merge into catalog_objects co
        using ( select  catalog_id
                       ,object_id
                       ,customer_id
                       ,country
                       ,lastmodified
                from catalog_objects_care_mstr_ext
                where catalog_id is not null) co_ext
          on (    co.catalog_id=co_ext.catalog_id
              and co.object_id=co_ext.object_id)
                when not matched then
                    insert ( co.catalog_id
                            ,co.object_id
                            ,co.customer_id
                            ,co.country
                            ,co.lastmodified
                            ,co.needsprocessing_flag)
                    values ( co_ext.catalog_id
                            ,co_ext.object_id
                            ,co_ext.customer_id
                            ,co_ext.country
                            ,co_ext.lastmodified
                            ,1)
            </xsl:when>            
            <xsl:when test="$destination = 'catalog_objects_ccb.dat'">
        merge into catalog_objects co
        using ( select  catalog_id
                       ,object_id
                       ,customer_id
                       ,country
                       ,division
                       ,sop
                       ,somp
                       ,eop
                       ,sos
                       ,eos
                       ,buy_online
                       ,local_going_price
                       ,deleted
                       ,delete_after_date
                       ,priority
                       ,lastmodified
                from catalog_objects_ccb_ext
                where catalog_id is not null
              <xsl:if test="$customer_id != ''">
                  and customer_id='<xsl:value-of select="$customer_id"/>'
              </xsl:if>
              <xsl:if test="$country != ''">
                  and country='<xsl:value-of select="$country"/>'
              </xsl:if>
              ) co_ext
              
          on (    co.catalog_id=co_ext.catalog_id
              and co.object_id=co_ext.object_id)
          when matched then
            update set 
                       co.division = co_ext.division
                      ,co.sop = co_ext.sop
                      ,co.somp = co_ext.somp
                      ,co.eop = co_ext.eop
                      ,co.sos = co_ext.sos
                      ,co.eos = co_ext.eos
                      ,co.buy_online = co_ext.buy_online
                      ,co.local_going_price = co_ext.local_going_price
                      ,co.deleted = co_ext.deleted
                      ,co.delete_after_date = co_ext.delete_after_date
                      ,co.priority = co_ext.priority
                      ,co.lastmodified = co_ext.lastmodified
                      ,co.needsprocessing_flag = 1
              where co.lastmodified &lt; co_ext.lastmodified
                and (   co.sop != co_ext.sop 
                     or co.somp != co_ext.somp 
                     or co.eop != co_ext.eop 
                     or co.sos != co_ext.sos
                     or co.eos != co_ext.eos
                     or co.buy_online != co_ext.buy_online 
                     or nvl(co.local_going_price,'0') != nvl(co_ext.local_going_price,'0') 
                     or co.deleted != co_ext.deleted 
                     or nvl(co.delete_after_date,to_date('1900-01-01','YYYY-MM-DD')) != nvl(co_ext.delete_after_date,to_date('1900-01-01','YYYY-MM-DD'))
                     or co.priority != co_ext.priority 
                     or co.division != co_ext.division
                    )
                when not matched then
                    insert ( co.catalog_id                
                            ,co.object_id
                            ,co.customer_id
                            ,co.country
                            ,co.division                        
                            ,co.sop
                            ,co.somp
                            ,co.eop
                            ,co.sos
                            ,co.eos
                            ,co.buy_online
                            ,co.local_going_price
                            ,co.deleted
                            ,co.delete_after_date
                            ,co.priority
                            ,co.lastmodified
                            ,co.needsprocessing_flag)
                    values ( co_ext.catalog_id
                            ,co_ext.object_id
                            ,co_ext.customer_id
                            ,co_ext.country
                            ,co_ext.division
                            ,co_ext.sop
                            ,co_ext.somp
                            ,co_ext.eop
                            ,co_ext.sos
                            ,co_ext.eos
                            ,co_ext.buy_online
                            ,co_ext.local_going_price
                            ,co_ext.deleted
                            ,co_ext.delete_after_date
                            ,co_ext.priority
                            ,co_ext.lastmodified                                
                            ,1)          
            </xsl:when>            
            <xsl:otherwise>
        merge into catalog_objects co
        using ( select  catalog_id
                       ,object_id
                       ,customer_id
                       ,country
                       ,division
                       ,gtin
                       ,sop
                       ,somp
                       ,eop
                       ,sos
                       ,eos
                       ,buy_online
                       ,local_going_price
                       ,deleted
                       ,delete_after_date
                       ,priority
                       ,lastmodified
                from catalog_objects_lcb_ext
                where catalog_id is not null) co_ext
          on (    co.catalog_id=co_ext.catalog_id
              and co.object_id=co_ext.object_id)
          when matched then
            update set co.division = co_ext.division
                      ,co.gtin = co_ext.gtin
                      ,co.sop = co_ext.sop
                      ,co.somp = co_ext.somp
                      ,co.eop = co_ext.eop
                      ,co.sos = co_ext.sos
                      ,co.eos = co_ext.eos
                      ,co.buy_online = co_ext.buy_online
                      ,co.local_going_price = co_ext.local_going_price
                      ,co.deleted = co_ext.deleted
                      ,co.delete_after_date = co_ext.delete_after_date
                      ,co.priority = co_ext.priority
                      ,co.lastmodified = co_ext.lastmodified
                      ,co.needsprocessing_flag = 1
              where co.lastmodified &lt; co_ext.lastmodified
                and (   co.division != co_ext.division
                     or nvl(co.gtin,'0') != nvl(co_ext.gtin,'0') 
                     or co.sop != co_ext.sop 
                     or co.somp != co_ext.somp 
                     or co.eop != co_ext.eop 
                     or co.sos != co_ext.sos
                     or co.eos != co_ext.eos
                     or co.buy_online != co_ext.buy_online 
                     or nvl(co.local_going_price,'0') != nvl(co_ext.local_going_price,'0')
                     or co.deleted != co_ext.deleted 
                     or nvl(co.delete_after_date,to_date('1900-01-01','YYYY-MM-DD')) != nvl(co_ext.delete_after_date,to_date('1900-01-01','YYYY-MM-DD'))
                     or co.priority != co_ext.priority 
                    )
                when not matched then
                    insert ( co.catalog_id                
                            ,co.object_id
                            ,co.customer_id
                            ,co.country
                            ,co.division 
                            ,co.gtin                       
                            ,co.sop
                            ,co.somp
                            ,co.eop
                            ,co.sos
                            ,co.eos
                            ,co.buy_online
                            ,co.local_going_price
                            ,co.deleted
                            ,co.delete_after_date
                            ,co.priority
                            ,co.lastmodified
                            ,co.needsprocessing_flag)
                    values ( co_ext.catalog_id
                            ,co_ext.object_id
                            ,co_ext.customer_id
                            ,co_ext.country
                            ,co_ext.division
                            ,co_ext.gtin
                            ,co_ext.sop
                            ,co_ext.somp
                            ,co_ext.eop
                            ,co_ext.sos
                            ,co_ext.eos
                            ,co_ext.buy_online
                            ,co_ext.local_going_price
                            ,co_ext.deleted
                            ,co_ext.delete_after_date
                            ,co_ext.priority
                            ,co_ext.lastmodified                                
                            ,1)          
            </xsl:otherwise>
          </xsl:choose>
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
