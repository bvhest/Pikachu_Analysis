<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"></xsl:param>
  <xsl:param name="locale"></xsl:param>
  <xsl:param name="contentType"/>
  <!-- -->
  <xsl:template match="/">
  
  <root>
  <!-- clear all-->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="clear cle-table">
        update customer_locale_export
           set flag        = 0
         where customer_id = '<xsl:value-of select="$channel"/>'
           and locale      = '<xsl:value-of select="$locale"/>'
           and flag       != 0 
      </sql:query>
    </sql:execute-query>

      <!-- Insert a record into CLE if there is a new product for this channel and locale -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="insert cle-table">
        insert into customer_locale_export(customer_id, locale, ctn, flag)
        select distinct '<xsl:value-of select="$channel"/>'
             , o.localisation
             , o.object_id id
             , 0
        from octl o 
        
        inner join channel_catalogs cc 
           on cc.locale          = o.localisation 
        inner join channels c 
           on c.id               = cc.customer_id
        
        <xsl:choose>
          <xsl:when test="$locale='master_global'">
            inner join mv_cat_obj co
               on co.object_id   = o.object_id 
              and co.catalog     = cc.catalog_type
          </xsl:when>
          <xsl:otherwise>
            inner join mv_cat_obj_country co
               on co.object_id   = o.object_id 
              and co.country     = '<xsl:value-of select="substring-after($locale,'_')" />'
              and co.catalog     = cc.catalog_type
         </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$channel!='CareAtgMerchandise'">
          inner join object_master_data omd
             on omd.object_id      = o.object_id
            and (omd.division      = cc.division 
              or cc.division       = 'ALL'
                )
            and (omd.brand         = cc.brand 
              or cc.brand          = 'ALL'
                )
        </xsl:if>
        inner join vw_object_categorization oc
           on oc.object_id       = co.object_id
	       and oc.catalogcode     = cc.catalog_type
        
        inner join categorization sc
           on sc.subcategorycode = oc.subcategory
          and sc.catalogcode     = oc.catalogcode
        
        left outer join customer_locale_export cle
          on cle.customer_id     = c.name
         and cle.ctn             = o.object_id
         and cle.locale          = o.localisation
        
        where o.content_type     = '<xsl:value-of select="$contentType"/>'
          and o.localisation     = '<xsl:value-of select="$locale"/>'
          and o.status          in ('Final Published','Loaded')
          and co.deleted         = 0
          and c.name             = '<xsl:value-of select="$channel" />'
          and cc.enabled         = 1
          and (cc.localeenabled  = 1 
            or cc.masterlocaleenabled = 1
              )
          and cle.customer_id   is null
      </sql:query>
    </sql:execute-query>
    
    <!-- 
      Set flag to 1 if the row is new, or if the product's categorization or navigation has changed since last export.
      Flag only products that should be exported according to the channel's catalog configuration. (Matching brand, division, catalog type.)
    -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="update cle-table">
update customer_locale_export cle
   set flag        = 1
 where customer_id = '<xsl:value-of select="$channel"/>'
   and locale      = '<xsl:value-of select="$locale"/>'
   and flag        = 0
        <!-- For non CARE exports be a bit more selective on what is exported -->
		<xsl:choose>
        <xsl:when test="$channel!='CareAtgMerchandise'">
	and ctn in ( select omd.object_id
                  from object_master_data omd
                 inner join channels c
                    on c.name          = '<xsl:value-of select="$channel"/>'
                 inner join channel_catalogs cc
                    on cc.customer_id  = c.id
                   and (cc.division='ALL' or cc.division=omd.division)
                   and (cc.brand='ALL'    or cc.brand=omd.brand)

              <xsl:choose>
                <xsl:when test="$locale='master_global' ">
                 inner join mv_cat_obj co
                    on co.catalog   = cc.catalog_type
                   and co.object_id = omd.object_id 
                </xsl:when>
                <xsl:otherwise>
                 inner join mv_cat_obj_country co
                    on co.catalog      = cc.catalog_type 
                   and co.country      = '<xsl:value-of select="substring-after($locale,'_')" />'
                   and co.object_id    = omd.object_id
               </xsl:otherwise>
              </xsl:choose>
                 inner join vw_object_categorization oc
                    on oc.object_id    = co.object_id
                   and oc.catalogcode  = cc.catalog_type
                 where cc.enabled      = 1
                   and cc.locale       = cle.locale
                   and (cc.localeenabled=1 or cc.masterlocaleenabled=1)
                   -- Stop sending deleted products after the deleteAfterDate has passed.
                   and (co.deleted=0       or trunc(sysdate) &lt; nvl(co.delete_after_date,to_date('21000101','yyyymmdd')))
              )
	and ( lasttransmit is null 
		   or  exists (select lastmodified_ts
							   from octl o
							  where o.content_type in ('WebSiteFiltering_Translated', 'WebSiteFiltering')
								and (o.localisation = cle.locale 
								  or o.localisation = 'master_global'
									)
								and o.object_id     = cle.ctn
								and  lasttransmit &lt;lastmodified_ts
							)    
		   or exists (select obt.lastmodified
							   from object_categorization obt
							  inner join channels ch
								 on ch.name = '<xsl:value-of select="$channel"/>'
							  inner join channel_catalogs cc
								 on cc.customer_id  = ch.id
								and cc.catalog_type = obt.catalogcode
							  where obt.object_id   = cle.ctn
							  and lasttransmit &lt; obt.lastmodified
								and (cc.locale      = cle.locale 
								  or cc.locale = 'master_global'
									)
							)
		   )	  
        </xsl:when>
		<xsl:otherwise>
		and 
				
					cle.ctn in ( 
							select 
								obt.object_id
							from object_categorization obt
							inner join channels ch
								on ch.name = '<xsl:value-of select="$channel"/>'
							inner join channel_catalogs cc
								on cc.customer_id  = ch.id
								and cc.catalog_type = obt.catalogcode
							inner join customer_locale_export cle1  
								on obt.object_id   = cle1.ctn
								and cle1.customer_id = '<xsl:value-of select="$channel"/>'
								and cle1.locale='<xsl:value-of select="$locale"/>'
								and  (cc.locale      = cle1.locale 
										or cc.locale = 'master_global'
									  )									  
								and (
										cle1.lasttransmit &lt; obt.lastmodified
									or
										cle1.lasttransmit is null
									)
								union
							select 
								object_id
							from octl o
								inner join customer_locale_export cle
									on cle.ctn=o.object_id
									and cle.customer_id='<xsl:value-of select="$channel"/>'
									and cle.locale='<xsl:value-of select="$locale"/>'
									and ( 
											cle.lasttransmit &lt; o.lastmodified_ts
										or
											cle.lasttransmit is null
										)
								where o.content_type in ('WebSiteFiltering_Translated', 'WebSiteFiltering')
									and (
											o.localisation = cle.locale 
										or
											o.localisation = 'master_global'
										)                
							)  
		</xsl:otherwise>
		</xsl:choose>
  
      </sql:query>
    </sql:execute-query>
  <!-- -->
  </root>
</xsl:template>
</xsl:stylesheet>
