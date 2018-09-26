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
				    select cle.ctn id
                , o.content_type 
							  , o.data 
							  , o2.data
							  , cle.locale localisation
							from customer_locale_export cle    
							inner join octl o
							     on o.object_id = cle.ctn
							    and o.localisation = cle.locale
								and o.content_type in ('PMT','PCT')
							    and ((o.content_type = 'PMT' and o.status = 'Final Published')
							          or
							         (o.content_type = 'PCT' and o.status = 'Loaded'))  
							left outer join octl o2
							     on o2.object_id = o.object_id
							    and o2.content_type = 'WebSiteFiltering'
							 where cle.CUSTOMER_ID= '<xsl:value-of select="$channel"/>'
							   and cle.locale = '<xsl:value-of select="$locale"/>'
							   and cle.flag=1       
							   order by o.content_type desc
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
                  , NVL(CO.RANK,0) RANK
              FROM CATALOG_OBJECTS CO
              INNER JOIN CHANNEL_CATALOGS CC
              ON CO.COUNTRY = '<xsl:value-of select="substring-after($locale,'_')"/>'
              AND ( CO.CUSTOMER_ID = CC.CATALOG_TYPE OR CC.CATALOG_TYPE = 'ALL')     
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
      </sql:execute-query>
    </Products>
  </xsl:template>
</xsl:stylesheet>
