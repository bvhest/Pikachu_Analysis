<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"></xsl:param>
  <xsl:param name="contentType"/>	
  <xsl:param name="locale"></xsl:param>

  <!-- -->
  <xsl:template match="/">
  <root>
  <!-- clear all-->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="clear cle-table">
         UPDATE CUSTOMER_LOCALE_EXPORT cle
            SET cle.flag         = 0
              , cle.batch        = 0
          WHERE cle.customer_id  = '<xsl:value-of select="$channel"/>'
            AND cle.locale       = '<xsl:value-of select="$locale"/>'
            AND (cle.flag != 0 OR cle.batch != 0) -- no need to do unnecessary updates
      </sql:query>
    </sql:execute-query>

   <!-- Insert new items-->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="add cle records">
         insert into customer_locale_export(customer_id, locale, ctn, lasttransmit, flag, batch)
         select distinct '<xsl:value-of select="$channel"/>'
              , o.localisation
              , o.object_id id
              , to_date('1900-01-01','yyyy-mm-dd')
              , 0
              , 0
           from octl o 
           left outer join customer_locale_export cle 
             on cle.customer_id  = '<xsl:value-of select="$channel"/>'
            and cle.ctn          = o.object_id 
            and cle.locale       = o.localisation
          inner join catalog_objects cc 
             on cc.object_id     = o.object_id
            and cc.country       = '<xsl:value-of select="substring-after($locale,'_') "/>'
            and cc.customer_id   = 'CARE'
          inner join vw_object_categorization oc 
             on oc.object_id     = cc.object_id 
            and oc.catalogcode   = cc.customer_id
          inner join categorization sc 
             on sc.subcategorycode = oc.subcategory 
            and sc.catalogcode   = cc.customer_id      
          where o.content_type   = '<xsl:value-of select="$contentType"/>'
            and o.localisation   = '<xsl:value-of select="$locale"/>'
            and o.status        in ('Final Published','Loaded') 
            and cle.customer_id is null
      </sql:query>
    </sql:execute-query>

  <!-- set flag to 1 if the export was before the last modified date.
     | Note: replaced the where exists as this query is executed row by row and is therefore inefficient with large numbers of records.
     |-->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="set cle flags">
        update customer_locale_export cle
           set cle.flag = 1
    	   where cle.customer_id = '<xsl:value-of select="$channel"/>' 
    	     and cle.locale      = '<xsl:value-of select="$locale"/>' 
           and exists   (select 1
                           from octl o
                          inner join catalog_objects cc 
                             on cc.object_id = o.object_id 
                            and cc.country   = '<xsl:value-of select="substring-after($locale,'_') "/>'
                            and cc.customer_id = 'CARE'
                          where o.content_type = '<xsl:value-of select="$contentType"/>'
                            and o.localisation = cle.locale
                            and o.object_id    = cle.ctn
                            and (o.lastmodified_ts > cle.lasttransmit
                              or cc.lastmodified   > cle.lasttransmit
                                )
                         )
      </sql:query>
    </sql:execute-query>
  <!-- -->
  </root>
</xsl:template>
</xsl:stylesheet>