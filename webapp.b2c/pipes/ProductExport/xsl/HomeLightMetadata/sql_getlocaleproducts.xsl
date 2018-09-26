<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>

  <!-- -->
  <xsl:template match="/">
    <!-- default = PMT, otherwise select from sourceCT variabele.
     +-->
    <xsl:variable name="source" select="if ($sourceCT != '') then $sourceCT else 'PMT'" />

    <Products>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="product">
    select sub1.object_id id
         , sub1.language
         , sub1.sop
         , sub1.somp
         , sub1.eop
         , sub1.sos
         , sub1.eos
         , sub1.LASTMODIFIED
         , sub1.priority
         , decode(sub1.deleteafterdate,'1900-01-01T00:00:00','',sub1.deleteafterdate) deleteafterdate
         , sub1.deleted
         , sub1.content_type
         , sub1.localisation
         , sub1.catalogtype
         , sub1.local_going_price
         , sub1.catalogtype categorization_catalogtype
         , o.data from (select distinct o.object_id
                             , ll.LANGUAGE
                             , TO_CHAR(min(co.sop),'yyyy-mm-dd') as sop
                             , TO_CHAR(min(co.somp),'yyyy-mm-dd') as somp
                             , TO_CHAR(max(co.eop),'yyyy-mm-dd') as eop
                             , TO_CHAR(min(co.sos),'yyyy-mm-dd') as sos
                             , TO_CHAR(max(co.eos),'yyyy-mm-dd') as eos
                             , TO_CHAR(max(co.LASTMODIFIED),'yyyy-mm-dd"T"hh24:mi:ss') as LASTMODIFIED 
                             , case when min(nvl(co.deleted,0)) = 0 
                                         then null
                                    else TO_CHAR(max(nvl(co.delete_after_date,to_date('19000101','YYYYMMDD'))),'yyyy-mm-dd') 
                                    end as deleteafterdate          
                             , min(nvl(co.deleted,0)) as deleted    
                             , max(co.priority) as priority
                             , max(co.customer_id) as catalogtype
                             , max(co.local_going_price) as local_going_price
                             , o.localisation
                             , '<xsl:value-of select="$source"/>' content_type
                        from CUSTOMER_LOCALE_EXPORT cle
                        inner join octl o on o.content_type='<xsl:value-of select="$source"/>'
                            and o.localisation=cle.locale
                            and o.object_id = cle.ctn
                        inner join LOCALE_LANGUAGE ll on ll.LOCALE = cle.locale
                        inner join channels ch on
                            ch.name = cle.CUSTOMER_ID  
                        inner join channel_catalogs cc
                             on cc.customer_id = ch.id
                             and cc.locale = cle.locale
                             and cc.enabled = 1
                        inner join catalog_objects co
                             on co.object_id=cle.ctn
                            and co.COUNTRY=ll.country
                            and co.CUSTOMER_ID = cc.catalog_type 
                        where  cle.CUSTOMER_ID='<xsl:value-of select="$channel"/>'
                            and cle.locale = '<xsl:value-of select="$locale"/>'
                            and cle.flag=1
                        group by o.object_id, ll.language, o.status, o.localisation
                      ) sub1
             inner join octl o
                   on o.object_id = sub1.object_id
                   and o.localisation = sub1.localisation
                   and o.content_type = sub1.content_type
             order by sub1.object_ID
        </sql:query>
        <sql:execute-query>
	        <sql:query name="catalogs">
			          SELECT distinct
				            CO.OBJECT_ID CTN
				          , UPPER(CO.CUSTOMER_ID) CATALOG
				          , TO_CHAR(CO.SOP,'yyyy-mm-dd') SOP
				          , TO_CHAR(CO.SOMP,'yyyy-mm-dd') SOMP
	                , TO_CHAR(CO.EOP,'yyyy-mm-dd') EOP
				          , CO.DELETED 
				          , CO.LOCAL_GOING_PRICE
				          , TO_CHAR(CO.LASTMODIFIED,'yyyy-mm-dd"T"hh24:mi:ss') LASTMODIFIED
				          , TO_CHAR(CO.DELETE_AFTER_DATE,'yyyy-mm-dd') DELETE_AFTER_DATE 
				          , CO.PRIORITY
              FROM CATALOG_OBJECTS CO
							INNER JOIN CHANNEL_CATALOGS CC
							ON CO.COUNTRY = '<xsl:value-of select="substring-after($locale,'_')"/>'
							--AND ( CO.CUSTOMER_ID = CC.CATALOG_TYPE OR CC.CATALOG_TYPE = 'ALL')     
							AND CO.CUSTOMER_ID = CC.CATALOG_TYPE           
							INNER JOIN CHANNELS C
							ON CC.CUSTOMER_ID = C.ID
							AND C.NAME = '<xsl:value-of select="$channel"/>'
							WHERE CO.OBJECT_ID = '<sql:ancestor-value name="id" level="1"/>'
	        </sql:query>
        </sql:execute-query>
        <sql:execute-query>
          <sql:query name="cat">
                  select c.groupcode, c.groupname, c.categorycode, c.categoryname, c.subcategorycode, c.subcategoryname, oc.catalogcode
                    from categorization c
              inner join vw_object_categorization oc 
                      on oc.subcategory = c.subcategorycode  
                     and oc.catalogcode = c.catalogcode        
                   where oc.object_id   = '<sql:ancestor-value name="id" level="1"/>'
                     and oc.catalogcode in (  SELECT DISTINCT CATALOG_TYPE 
																							  FROM CHANNEL_CATALOGS CC
																			  	INNER JOIN CHANNELS C 
																						ON C.ID = CC.CUSTOMER_ID
																						WHERE C.NAME = '<xsl:value-of select="$channel"/>' 
																						AND CC.LOCALE = '<xsl:value-of select="$locale"/>'
																						)
          </sql:query>
        </sql:execute-query>
        <sql:execute-query>
          <sql:query name="WebSiteFilter">          
                  SELECT data FROM OCTL 
									WHERE OBJECT_ID = '<sql:ancestor-value name="id" level="1"/>'
									AND content_type = 'WebSiteFiltering'                     
          </sql:query>
        </sql:execute-query>
      </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
