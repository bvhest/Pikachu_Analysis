<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  
  <xsl:variable name="publicationOffset"><xsl:value-of select="if ($channel='FlixMediaProducts') then '45' else '7'"/></xsl:variable>
  
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          update customer_locale_export
             set flag=0
           where customer_id='<xsl:value-of select="$channel"/>'
             and locale='MASTER'
             and flag != 0
        </sql:query>
      </sql:execute-query>
      
      <xsl:call-template name="select"/>
    </root>
  </xsl:template>
    
  <xsl:template name="select">
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        insert into customer_locale_export(customer_id, locale, ctn, flag, lasttransmit)
             select distinct
                      '<xsl:value-of select="$channel"/>'
                    , 'MASTER'
                    , o.object_id
                    , 1
                    , to_date('19000101','YYYYMMDD')
               from OCTL o           
         inner join CHANNELS ch
                 on ch.name =  '<xsl:value-of select="$channel"/>'
         inner join channel_catalogs cc
                 on ch.id = cc.customer_id
               -- and cc.locale = o.localisation
                and (cc.ENABLED = 1 or cc.masterlocaleenabled = 1)
                and o.localisation='master_global'
                and o.content_type in ('PMT_Master','PCT_Master')
                and (
                      (o.content_type = 'PMT_Master' and o.status = 'Final Published') 
                      or         
                      ( o.content_type = 'PCT_Master' and o.status = 'Loaded')
                )    

         inner join mv_cat_obj co
                 on co.object_id = o.object_id
                and co.deleted = 0
                and co.catalog=cc.catalog_type

inner join object_categorization oc
                on  oc.object_id=co.object_id
                and oc.deleted = 0
              inner join CATEGORIZATION ca
                on ca.subcategorycode=oc.subcategory
                and ca.groupcode='LIGHTING_GR'      



    left outer join CUSTOMER_LOCALE_EXPORT cle
                 on o.object_ID=cle.ctn
                and cle.locale='MASTER'
                and cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
              where cle.CUSTOMER_ID is NULL
      </sql:query>
    </sql:execute-query>
    <!--  -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
					declare
            cursor c1 is
						    (select distinct cle.ctn
                  from customer_Locale_export cle   
                  inner join channels ch
                     on ch.name =  '<xsl:value-of select="$channel"/>'
                  inner join channel_catalogs cc
                     on ch.id = cc.customer_id
                      --and cc.locale = cle.locale
                      and (cc.ENABLED = 1 or cc.masterlocaleenabled = 1)
                      INNER JOIN OCTL OCTL ON 
                    OCTL.OBJECT_ID = CLE.CTN
					AND OCTL.CONTENT_TYPE in ('PMT_Master','PCT_Master','WebSiteFiltering','ObjectCategorization')
          AND
                    (( OCTL.CONTENT_TYPE = 'PCT_Master' AND OCTL.STATUS = 'Loaded'  AND OCTL.LOCALISATION = 'master_global' )
                     OR 
                     ( OCTL.CONTENT_TYPE = 'PMT_Master' AND OCTL.STATUS = 'Final Published'  AND OCTL.LOCALISATION = 'master_global' )
                     OR
                     ( OCTL.CONTENT_TYPE = 'WebSiteFiltering' AND OCTL.STATUS = 'Final Published' AND OCTL.LOCALISATION = 'master_global')                      
                     OR
                     ( OCTL.CONTENT_TYPE = 'ObjectCategorization' AND OCTL.STATUS = 'Loaded' AND OCTL.LOCALISATION = 'none'))
                  inner join mv_cat_obj co 
                     on co.object_id = cle.ctn
                    and co.catalog = cc.catalog_type
	inner join object_categorization oc
                on  oc.object_id=co.object_id
                and oc.deleted = 0
              inner join CATEGORIZATION ca
                on ca.subcategorycode=oc.subcategory
                and ca.groupcode='LIGHTING_GR'
                    where cle.customer_id = '<xsl:value-of select="$channel"/>'
                    and cle.locale='MASTER'
                    and octl.lastmodified_ts &gt; cle.lasttransmit
								);
						begin  
						  for r in c1 
						  loop 
						    update customer_locale_export cle
						        set  cle.flag = 1
						    where cle.locale = 'MASTER'
						        and cle.customer_id = '<xsl:value-of select="$channel"/>'                 
						        and cle.ctn = r.ctn;
						  end loop;            
					end;         
      </sql:query>
    </sql:execute-query>
  </xsl:template>
</xsl:stylesheet>