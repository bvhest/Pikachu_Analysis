<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="exportdate"/>
  <xsl:param name="batchsize"/>
  <xsl:param name="batchtype"/>    
  <xsl:variable name="fulldate"><xsl:value-of select="substring($exportdate,1,4)"/>-<xsl:value-of select="substring($exportdate,5,2)"/>-<xsl:value-of select="substring($exportdate,7,2)"/>T<xsl:value-of select="substring($exportdate,10,2)"/>:<xsl:value-of select="substring($exportdate,12,2)"/>:00</xsl:variable>
  <!-- -->
  <xsl:template match="/">
    <!-- Reset flag on all products for this channel/locale combination -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query isstoredprocedure="true">
        DECLARE
            <!-- c_products_to_export: identify modified or new products -->
           CURSOR c_products_to_export
              ( p_channel        IN VARCHAR2
              , p_channel_name   IN VARCHAR2
              , p_country        IN VARCHAR2
              , p_locale         IN VARCHAR2
              ) 
           IS
              SELECT DISTINCT cle.ctn, cle.rowid cle_rowid, o.masterlastmodified_ts
                FROM octl o 
               INNER JOIN channels chn 
                  ON chn.name        = p_channel_name
               INNER JOIN channel_catalogs cc
                  ON cc.customer_id  = chn.id
                 AND cc.locale       =  p_locale
                 AND cc.enabled      = 1
               INNER JOIN customer_locale_export cle
                  ON cle.locale      =  p_locale
                 AND cle.customer_id = p_channel
                 AND cle.ctn         = o.object_id
<xsl:if test="$batchtype = 'delta'">                    
                 AND nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) &lt; o.lastmodified_ts
</xsl:if>  
               INNER JOIN vw_object_categorization oc 
                  ON oc.object_id    = o.object_id
                 AND oc.catalogcode  = cc.catalog_type        
               INNER JOIN categorization cat
                  ON cat.subcategorycode = oc.subcategory
                 AND cat.catalogcode = oc.catalogcode
<xsl:choose>
   <xsl:when test="$locale = 'master_global'">
               WHERE o.content_type  = 'PMT_Master'
                 AND o.status       in ('Preliminary Published','Final Published')
   </xsl:when>
   <xsl:otherwise>
               INNER JOIN mv_co_object_id_country  co
                  ON co.object_id    = o.object_id
                 AND co.country      = p_country
                 AND co.deleted      = 0
                 AND co.eop        &gt; sysdate                 
               INNER JOIN object_master_data omd
                  ON omd.object_id = o.object_id    
               WHERE o.content_type  = 'PMT'
                 AND o.status in ('Final Published', 'PLACEHOLDER')
                 AND (omd.division = 'Lighting' OR o.status = 'Final Published')                        
   </xsl:otherwise>
</xsl:choose>
                 AND o.localisation  =  p_locale
            ORDER BY o.masterlastmodified_ts desc
          ;   
            <!-- c_product_count: identify total number of products -->
           CURSOR c_product_count
              ( p_channel        IN VARCHAR2
              , p_channel_name   IN VARCHAR2
              , p_country        IN VARCHAR2
              , p_locale         IN VARCHAR2
              ) 
           IS
                SELECT COUNT (DISTINCT o.object_id)
                  FROM octl o 
                 INNER JOIN channels chn
                    ON chn.name         = p_channel_name
                 INNER JOIN channel_catalogs cc
                    ON cc.customer_id   = chn.id
                   AND cc.locale        =  p_locale
                   AND cc.enabled       = 1
                 INNER JOIN customer_locale_export cle
                    ON cle.locale       = p_locale
                   AND cle.customer_id  = p_channel
                   AND cle.ctn          = o.object_id               
<xsl:if test="$batchtype = 'delta'">                    
                   AND nvl(cle.lasttransmit,to_date('1900-01-01','YYYY-MM-DD')) &lt; o.lastmodified_ts
</xsl:if>
                 INNER JOIN vw_object_categorization oc 
                    ON oc.object_id     = o.object_id
                   AND oc.catalogcode   = cc.catalog_type        
                 INNER JOIN categorization cat
                    ON oc.subcategory   = cat.subcategorycode
                   AND cat.catalogcode  = oc.catalogcode
<xsl:choose>
   <xsl:when test="$locale = 'master_global'">
                  WHERE  o.content_type = 'PMT_Master'
                    AND o.status       in ('Preliminary Published','Final Published')
   </xsl:when>
   <xsl:otherwise>
                  INNER JOIN mv_co_object_id_country  co
                     ON co.object_id    = o.object_id
                    AND co.country      = p_country
                    AND co.deleted      = 0
                    AND co.eop         &gt; sysdate
                  INNER JOIN object_master_data omd
                     ON omd.object_id = o.object_id                 
                  WHERE o.content_type = 'PMT'                    
                    AND o.status in ('Final Published', 'PLACEHOLDER')
                    AND (omd.division = 'Lighting' OR o.status = 'Final Published')
                             
   </xsl:otherwise>
</xsl:choose>
                   AND o.localisation   =  p_locale
          ;

           <!-- variables -->
           i                  PLS_INTEGER :=0 ;
           i_total_products   PLS_INTEGER := 0;
           batch_size         PLS_INTEGER := <xsl:value-of select="$batchsize"/>;
           p_locale           customer_locale_export.locale%type := '<xsl:value-of select="$locale"/>';
           p_channel          customer_locale_export.customer_id%type := '<xsl:value-of select="$channel"/>';
           p_channel_name     channels.name%type := '<xsl:value-of select="$channel"/>/delta';
           p_country          catalog_objects.country%type := '<xsl:value-of select="substring-after($locale,'_')"/>';

         BEGIN
          <!-- insert rows into CLE for new products -->
            INSERT INTO CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
            SELECT distinct '<xsl:value-of select="$channel"/>'
                  , o.localisation
                  , o.object_id
                  , 0
              FROM octl o 
             INNER JOIN channels chn 
                ON chn.NAME = '<xsl:value-of select="$channel"/>/delta' 
             INNER JOIN channel_catalogs cc
                ON cc.customer_id  = chn.ID
                AND cc.locale =  '<xsl:value-of select="$locale"/>' 
               AND cc.enabled = 1
        LEFT OUTER JOIN customer_locale_export cle
                ON cle.locale = '<xsl:value-of select="$locale"/>' 
               AND cle.customer_id = '<xsl:value-of select="$channel"/>' 
               AND cle.ctn = o.object_id
             INNER JOIN vw_object_categorization oc 
                ON oc.object_id = o.object_id
               AND oc.catalogcode = cc.catalog_type        
             INNER JOIN categorization cat
                ON oc.subcategory = cat.subcategorycode
               AND cat.catalogcode = oc.catalogcode
       <xsl:choose>
         <xsl:when test="$locale = 'master_global'">
             WHERE o.content_type = 'PMT_Master'
               AND o.status in ('Preliminary Published','Final Published') 
         </xsl:when>
         <xsl:otherwise>
             INNER JOIN mv_co_object_id_country  co
                ON co.object_id = o.object_id
               AND co.country =  '<xsl:value-of select="substring-after($locale,'_')"/>'
               AND co.deleted = 0
               AND co.eop &gt; sysdate 
             INNER JOIN object_master_data omd
                ON omd.object_id = o.object_id                               
             WHERE o.content_type = 'PMT'
               AND o.status in ('Final Published', 'PLACEHOLDER')
               AND (omd.division = 'Lighting' OR o.status = 'Final Published')
         </xsl:otherwise>
      </xsl:choose> 
               AND o.localisation =  '<xsl:value-of select="$locale"/>'     
               AND CLE.ctn is NULL
            ;

            OPEN c_product_count(p_channel, p_channel_name, p_country, p_locale);
            FETCH c_product_count INTO i_total_products;
            CLOSE c_product_count;
            <!-- flag products for export -->
            FOR r IN c_products_to_export(p_channel, p_channel_name, p_country, p_locale)
            LOOP
               i := i+1;
               UPDATE customer_locale_export cle 
                  SET cle.flag = 1
                    , cle.batch = (ceil(i_total_products/batch_size) - ceil(i/batch_size)) + 1 
                WHERE cle.rowid = r.cle_rowid;
            END LOOP;
         END;
      </sql:query>
    </sql:execute-query>
  <!-- -->
</xsl:template>
</xsl:stylesheet>