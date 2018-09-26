<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql xsl">

  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="selectall">no</xsl:param>

  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="reset-flags">
          update customer_locale_export
             set flag=0
           where customer_id='<xsl:value-of select="$channel"/>'
             and locale='<xsl:value-of select="$locale"/>'
             and flag != 0
        </sql:query>
      </sql:execute-query>

      <sql:execute-query>
        <sql:query name="insert-catg-tree">
          insert into customer_locale_export(customer_id, locale, ctn, flag)
               select distinct
                        '<xsl:value-of select="$channel"/>'
                      , o.localisation
                      , o.object_id
                      , 0
                 from OCTL o       
                 
                 inner join CHANNELS ch
                    on ch.name =  '<xsl:value-of select="$channel"/>'
           
                 inner join channel_catalogs cc
                    on ch.id = cc.customer_id
                   and cc.locale = o.localisation
                   and cc.ENABLED = 1
            
                 left outer join CUSTOMER_LOCALE_EXPORT cle
                   on cle.ctn = o.object_ID
                  and cle.locale = cc.locale
                  and cle.CUSTOMER_ID= ch.name
  			 
                 where cle.CUSTOMER_ID is NULL
                   and o.localisation='<xsl:value-of select="$locale"/>'                 
                   and o.content_type = 'Categorization'
                   and o.object_id = 'CONSUMER'
        </sql:query>
      </sql:execute-query>
      
      <sql:execute-query>
        <sql:query name="insert-products">
          insert into customer_locale_export(customer_id, locale, ctn, flag)
               select distinct
                        '<xsl:value-of select="$channel"/>'
                      , o.localisation
                      , o.object_id
                      , 0
                 from OCTL o       
                 
                 inner join CHANNELS ch
                    on ch.name =  '<xsl:value-of select="$channel"/>'
                 
                 inner join channel_catalogs cc
                    on ch.id = cc.customer_id
                   and cc.locale = o.localisation
                   and cc.ENABLED = 1
                 
                 left outer join CUSTOMER_LOCALE_EXPORT cle
                   on cle.ctn = o.object_ID
                  and cle.locale = cc.locale
                  and cle.customer_id = ch.name
            <xsl:choose>
              <xsl:when test="$locale = 'master_global'">
  			    where cle.CUSTOMER_ID is NULL
                    and o.localisation='<xsl:value-of select="$locale"/>'
                    and o.content_type = 'PMT_Master'
                    and o.status in ('Preliminary Published','Final Published')
              </xsl:when>
              <xsl:otherwise>
                  inner join mv_cat_obj_country co
                     on co.object_id = o.object_id
                    and co.country = '<xsl:value-of select="substring-after($locale,'_')"/>'
                    --and co.deleted = 0
                    and co.eop &gt; sysdate
                    and co.catalog = cc.catalog_type
              
                  where cle.CUSTOMER_ID is NULL
                    and o.localisation='<xsl:value-of select="$locale"/>'
                    and o.content_type = 'PMT'
                    and o.status = 'Final Published'	
  				<!-- and o.object_id =  'SWA2416W/27'	-->
              </xsl:otherwise>
            </xsl:choose>              
        </sql:query>
      </sql:execute-query>

      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="set-flags">
              update CUSTOMER_LOCALE_EXPORT
              set flag=1
              where locale = '<xsl:value-of select="$locale"/>'
              and customer_id = '<xsl:value-of select="$channel"/>'
              and ctn in 
              (  
                select distinct cle.ctn
                from octl o
                
                inner join channels c 
                   on c.name = '<xsl:value-of select="$channel"/>'
                
                inner join channel_catalogs cc
                   on cc.customer_id  = c.ID
                  and cc.locale = o.localisation
                  and cc.enabled = 1
                
                inner join customer_locale_export cle
                   on cle.locale =  cc.locale
                  and cle.customer_id = c.name
                  and cle.ctn = o.object_id
                <xsl:if test="$selectall != 'yes'">                      
                  and nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) &lt; o.lastmodified_ts
                </xsl:if>  
                
                inner join vw_object_categorization oc 
                   on oc.object_id = o.object_id
                  and oc.catalogcode = cc.catalog_type        
                
                inner join categorization c
                   on oc.subcategory = c.subcategorycode
                  and c.catalogcode = oc.catalogcode
            <xsl:choose>
  		    <xsl:when test="$locale = 'master_global'">
  	          where o.localisation='<xsl:value-of select="$locale"/>'
  		        and o.content_type = 'PMT_Master'
  		        and o.status in ('Preliminary Published','Final Published')
  			</xsl:when>
  			<xsl:otherwise>
                inner join mv_co_object_id_country  co
                   on co.object_id = o.object_id
                  and co.country = '<xsl:value-of select="substring-after($locale,'_')"/>'
                  --and co.deleted = 0
                  and co.eop &gt; sysdate
  			 
                where o.localisation='<xsl:value-of select="$locale"/>'                 
  				and o.content_type = 'PMT'
  				and o.status = 'Final Published'	
  				<!-- and o.object_id = 'SWA2416W/27'	 -->			
  			</xsl:otherwise>
  	      </xsl:choose>  
                union
                select 'CONSUMER' from Dual
              )
        </sql:query>
      </sql:execute-query>   
    </root>             
  </xsl:template>

</xsl:stylesheet>