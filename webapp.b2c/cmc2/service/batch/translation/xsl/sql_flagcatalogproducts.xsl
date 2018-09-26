<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:sql="http://apache.org/cocoon/SQL/2.0"
        xmlns:cinclude="http://apache.org/cocoon/include/1.0">
        
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->  
  <xsl:param name="ct"/>
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:variable name="v_needsprocessing" select="if (catalog/@seo='yes') then '-2' else '2'"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="catalog/product"/>
    </root>
  </xsl:template>
  <!-- -->  
  <xsl:template match="product">
   <sql:execute-query name="sql_flagcatalogproducts">
     <sql:query name="sql_flagcatalogproducts">
            update octl_control o 
               set o.needsprocessing_flag = to_number(<xsl:value-of select="$v_needsprocessing"/>)
                 , o.intransaction_flag   = 1
                 , o.batch_number         = 1
             where o.modus        = '<xsl:value-of select="$modus"/>'
               and o.content_type = '<xsl:value-of select="$ct"/>'
               and o.object_id    = '<xsl:value-of select="@ctn"/>'
               and o.localisation in (select ll.locale 
                                        from locale_language ll 
                                       inner join language_translations lt 
                                          on lt.locale = ll.locale 
                                       where ll.country in (select country 
                                                              from locale_language 
                                                            <!-- added an option to select a ctn from every locale -->
                                                            <xsl:if test="@locale != 'all'">
                                                             where languagecode = '<xsl:value-of select="@locale"/>'
                                                            </xsl:if>
                                                           )
                                         <xsl:if test="$ct != 'PText_Translated'">
                                         and lt.enabled  = 1
                                         </xsl:if>
                                         and lt.isdirect = 0
                                     )
               and exists (select 1 
                             from octl localized
                            inner join vw_object_categorization oc
                               on oc.object_id           = localized.object_id
                            inner join categorization c
                               on c.subcategorycode      = oc.subcategory
                              and c.catalogcode          = oc.catalogcode
                            where localized.content_type = 'PMT_Localised'
                              and localized.localisation = 'master_'||substr(o.localisation,4,2)
                              and localized.object_id    = o.object_id
                              and localized.status       = 'Final Published'
                              and oc.catalogcode         = 'MASTER'
                          )
               and sysdate &lt; (select max(EOP) 
                                   from catalog_objects cobj 
                                  where cobj.customer_id   != 'CARE'
                                    and cobj.object_id      = o.object_id
                                    and nvl(cobj.deleted,0) = 0
                                )
               and exists (select 1 
                             from catalog_objects cobj 
                            where cobj.customer_id   != 'CARE'
                              and cobj.object_id      = o.object_id
                              and cobj.country        = substr(o.localisation,4,2)
                              and nvl(cobj.deleted,0) = 0
                          ) 
      </sql:query>
    </sql:execute-query>
  </xsl:template>
  <!-- -->  
</xsl:stylesheet>