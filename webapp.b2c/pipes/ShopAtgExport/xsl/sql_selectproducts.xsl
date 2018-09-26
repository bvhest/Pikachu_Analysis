<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="channel"></xsl:param>
  <xsl:param name="locale"></xsl:param>
  <xsl:param name="batchnumber"></xsl:param>
  <xsl:param name="delta"/>       

  <xsl:template match="/">
  <root>
  <!-- clear all-->
  <!--
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        update CUSTOMER_LOCALE_EXPORT
           set FLAG=0
         where CUSTOMER_ID = '<xsl:value-of select="$channel"/>'
           and LOCALE      = '<xsl:value-of select="$locale"/>'
           and FLAG       != 0 
      </sql:query>
    </sql:execute-query>
-->

  <!-- set flag to 1 if the export was before the last modified date -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        UPDATE customer_locale_export cle
        set 
          flag=1   
	where cle.CUSTOMER_ID = '<xsl:value-of select="$channel"/>' 
	and cle.locale = '<xsl:value-of select="$locale"/>' 
	<xsl:if test="$delta!='y' and $batchnumber != '' and  $batchnumber != 0">
		and cle.batch = <xsl:value-of select="$batchnumber"/>       
	</xsl:if>
        and exists (
             select  1
                from   octl o
             inner join object_master_data omd 
                on omd.object_id = o.object_id
             inner join locale_language ll 
                on  o.localisation = ll.locale
             inner join channels c 
                on c.name = '<xsl:value-of select="$channel"/>' 
				 inner join channel_catalogs cc 
               on cc.customer_id = c.id
               and cc.locale     = o.localisation
               and (cc.division  = omd.division or cc.division='ALL')
               and (cc.brand     = omd.brand or cc.brand='ALL')
               and cc.enabled    = 1
             inner join catalog_objects co 
                on co.object_id = o.object_id 
               and co.country = ll.country 
               and co.customer_id = cc.catalog_type 
               and (co.eop > sysdate - 100)
               and co.deleted = 0
             inner join vw_object_categorization oc 
                on oc.object_id   = co.object_id
               and oc.catalogcode = co.customer_id
				 inner join categorization cat 
                on cat.subcategorycode = oc.subcategory
               and cat.catalogcode     = oc.catalogcode                                                      
              where o.content_type = 'PMT'
                and o.object_id = cle.ctn 
                and o.localisation = cle.locale
                and o.lastmodified_ts > nvl(cle.lasttransmit, to_date('1900-01-01','yyyy-mm-dd'))
         )
      </sql:query>
    </sql:execute-query>
  <!-- -->
  </root>
</xsl:template>
</xsl:stylesheet>