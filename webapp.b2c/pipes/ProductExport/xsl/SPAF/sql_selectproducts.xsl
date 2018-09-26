<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql xsl">
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="country"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="selectall">no</xsl:param>  
  <xsl:param name="selectsubcat">no</xsl:param>  
  <xsl:param name="kvpdocpath"/>
  <!-- new content type parameter needed for ATG PCT export -->
  <xsl:param name="sourceCT"/>
  <!-- -->
  <!-- xsl:variable name="DoctypesDoc" select="document(../../../cmc2/xml/doctypeAttributes)"/ -->  
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  
   <xsl:variable name="doctype-channel" select="$channel"/>
  <!-- -->
  <!-- -->
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="reset flags">
          update customer_locale_export
             set flag=0
           where customer_id='<xsl:value-of select="$channel"/>'
             and locale='<xsl:value-of select="$locale"/>'
             and flag != 0
        </sql:query>
      </sql:execute-query>
  <!-- insert for cat tree -->
  <!-- Insert for all products  -->
      <sql:execute-query>
        <sql:query name="new categorizations">
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
                  and cc.enabled = 1
                  and cc.catalog_type = o.object_id
           left outer join CUSTOMER_LOCALE_EXPORT cle
                   on cle.ctn = o.object_ID
                  and cle.locale = cc.locale
                  and cle.customer_id= ch.name
           WHERE cle.customer_id is NULL
             AND o.localisation='<xsl:value-of select="$locale"/>'                 
             AND o.content_type = 'Categorization'
        </sql:query>
      </sql:execute-query>
        
      
  <!-- Insert for all products  -->
    <sql:execute-query>
      <sql:query name="new products">
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
                and cc.enabled = 1
         inner join object_master_data omd
                 on omd.object_id = o.object_id
                and (   omd.brand = cc.brand
                     or cc.brand = 'ALL'
                    )
                and (   omd.division = cc.division
                     or cc.division = 'ALL'
                    )
         left outer join CUSTOMER_LOCALE_EXPORT cle
                 on cle.ctn = o.object_ID
                and cle.locale = cc.locale
                and cle.customer_id = ch.name
        <xsl:choose>
      <xsl:when test="$locale = 'master_global'">
        WHERE cle.CUSTOMER_ID is NULL
          AND o.localisation='<xsl:value-of select="$locale"/>'
          AND o.content_type = 'PMT_Master'
          AND o.status in ('Preliminary Published','Final Published')
      </xsl:when>
      <xsl:otherwise>
        INNER JOIN mv_cat_obj_country co
           ON co.object_id = o.object_id
          AND co.catalog = cc.catalog_type
       
        WHERE cle.customer_id is NULL
          AND o.localisation='<xsl:value-of select="$locale"/>'                 
          AND o.content_type = 'PMT'
          AND o.status = 'Final Published'  
          AND co.country = '<xsl:value-of select="substring-after($locale,'_')"/>'
          AND co.deleted = 0
          AND co.eop &gt; sysdate
          <!-- and o.object_id =  'SWA2416W/27'  -->
      </xsl:otherwise>
    </xsl:choose>              
      </sql:query>
    </sql:execute-query>

    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query name="set flags">
       update CUSTOMER_LOCALE_EXPORT
       set flag=1
         where locale = '<xsl:value-of select="$locale"/>'
         and customer_id = '<xsl:value-of select="$channel"/>'
         and ctn in 
        (  
          SELECT DISTINCT cle.ctn
          FROM octl o
          
          INNER JOIN channels c 
             ON c.name = '<xsl:value-of select="$channel"/>'
          
          INNER JOIN channel_catalogs cc
             ON cc.customer_id  = c.ID
            AND cc.locale = o.localisation
            AND cc.enabled = 1
          
          INNER JOIN customer_locale_export cle
             ON cle.locale =  cc.locale
            AND cle.customer_id = c.name
            AND cle.ctn = o.object_id
          <xsl:if test="$selectall != 'yes'">                      
            AND nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) &lt; o.lastmodified_ts
          </xsl:if>  
          INNER JOIN vw_object_categorization oc 
             ON oc.object_id = o.object_id
            AND oc.catalogcode = cc.catalog_type        
          
          INNER JOIN categorization c
             ON oc.subcategory = c.subcategorycode
            AND c.catalogcode = oc.catalogcode

          inner join object_master_data omd
                  on omd.object_id = o.object_id
                 and (   omd.brand = cc.brand
                      or cc.brand = 'ALL'
                     )
                 and (   omd.division = cc.division
                      or cc.division = 'ALL'
                     )
        <xsl:choose>
         <xsl:when test="$locale = 'master_global'">
         INNER JOIN mv_co_object_id co
            ON co.object_id = o.object_id
        
         WHERE o.localisation='<xsl:value-of select="$locale"/>'
           AND o.content_type = 'PMT_Master'
           AND o.status in ('Preliminary Published','Final Published')
           AND co.deleted = 0
           AND co.eop &gt; sysdate
         </xsl:when>
         <xsl:otherwise>
         INNER JOIN mv_cat_obj_country co
            ON co.object_id = o.object_id
           AND co.catalog = cc.catalog_type
           
         WHERE o.localisation='<xsl:value-of select="$locale"/>'                 
           AND o.content_type = 'PMT'
           AND o.status = 'Final Published'  
           AND co.country = '<xsl:value-of select="substring-after($locale,'_')"/>'
           <!-- Keep sending deleted products until deleteAfterDate to send deleted status to BV -->
           AND (co.deleted = 0 or nvl(co.delete_after_date, to_date('2300-01-01','yyyy-mm-dd')) >= sysdate)
           <!-- Keep sending until 30 days after eop to send deleted status to BV -->
           AND co.eop &gt; sysdate - 30
          <!-- and o.object_id = 'SWA2416W/27'   -->      
         </xsl:otherwise>
        </xsl:choose>  
        UNION
        SELECT distinct cc.catalog_type 
        FROM channel_catalogs cc
        INNER JOIN channels c
           ON c.id=cc.customer_id
        WHERE c.name = '<xsl:value-of select="$channel"/>'
          AND cc.enabled=1
          AND cc.locale='<xsl:value-of select="$locale"/>'
      )
      </sql:query>
    </sql:execute-query>   
    </root>             
  </xsl:template>

</xsl:stylesheet>