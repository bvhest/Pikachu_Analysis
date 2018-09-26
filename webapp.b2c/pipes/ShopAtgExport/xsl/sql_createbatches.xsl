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
  <xsl:param name="batchsize"/>
  
  <!-- -->
  <xsl:template match="/">
    <!-- Create CLE entries for NEW products  then  update to set the batch number -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query isstoredprocedure="true">
       declare
            <!-- c_products_to_export: identify modified or new products -->
            cursor c_products_to_export(p_locale IN VARCHAR2, p_channel IN VARCHAR2, p_country IN VARCHAR2) is
            SELECT DISTINCT cle.ctn, cle.rowid cle_rowid, o.masterlastmodified_ts
              FROM octl o 
        INNER JOIN object_master_data obj
                ON o.object_id = obj.object_id
        INNER JOIN channel_catalogs cc
                ON cc.locale = o.localisation
               AND (obj.division = cc.division or cc.division='ALL')
               AND (obj.brand = cc.brand or cc.brand='ALL')
               AND cc.enabled = 1
        INNER JOIN channels c 
                ON c.ID = cc.customer_id 
               AND c.NAME = p_channel
        INNER JOIN catalog_objects co 
                on co.object_id = o.object_id 
               and co.country = p_country 
               and co.customer_id = cc.catalog_type 
               and (co.eop > sysdate - 100)
               AND co.deleted = 0
        INNER JOIN customer_locale_export cle
                ON cle.locale = o.localisation
               AND cle.customer_id = c.name
               AND cle.ctn = o.object_id
         WHERE  o.content_type = 'PMT'
               AND o.localisation = p_locale 
               AND o.status = 'Final Published'                                      
           
           order by o.masterlastmodified_ts desc;

            <!-- c_product_count: identify total number of products -->
     cursor c_product_count(p_locale IN VARCHAR2, p_channel IN VARCHAR2, p_country IN VARCHAR2) is
           SELECT count(DISTINCT o.object_id)
              FROM octl o 
        INNER JOIN object_master_data obj
                ON o.object_id = obj.object_id
        INNER JOIN channel_catalogs cc
                ON cc.locale = o.localisation
               AND (obj.division = cc.division or cc.division='ALL')
               AND (obj.brand = cc.brand or cc.brand='ALL')
               AND cc.enabled = 1
        INNER JOIN channels c 
                ON c.ID = cc.customer_id 
               AND c.NAME = p_channel
        INNER JOIN catalog_objects co 
                on co.object_id = o.object_id 
               and co.country = p_country 
               and co.customer_id = cc.catalog_type 
               and (co.eop > sysdate - 100)       
               AND co.deleted = 0
        INNER JOIN customer_locale_export cle
                ON cle.locale = o.localisation
               AND cle.customer_id = c.name
               AND cle.ctn = o.object_id
         WHERE  o.content_type = 'PMT'
               AND o.localisation = p_locale 
               AND o.status = 'Final Published'
               ;

        <!-- variables -->
        i PLS_INTEGER :=0 ;
        i_total_products PLS_INTEGER := 0;
        batch_size PLS_INTEGER := <xsl:value-of select="$batchsize"/>;
        p_locale customer_locale_export.locale%type := '<xsl:value-of select="$locale"/>';
        p_channel customer_locale_export.customer_id%type := '<xsl:value-of select="$channel"/>';
        p_country catalog_objects.country%type := '<xsl:value-of select="substring-after($locale,'_')"/>';
  
   
        begin
        <!-- insert rows into CLE for new products -->
          insert into CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
            select distinct '<xsl:value-of select="$channel"/>'
                  , o.localisation
                  , o.object_id
                  , 0
              from octl o 
        INNER JOIN object_master_data obj
                ON o.object_id = obj.object_id
               AND o.content_type = 'PMT'
               AND o.status = 'Final Published'
               AND o.localisation = '<xsl:value-of select="$locale"/>' 
        INNER JOIN channel_catalogs cc
                ON cc.locale = o.localisation
               AND (obj.division = cc.division or cc.division='ALL')
               AND (obj.brand = cc.brand or cc.brand='ALL')
               AND cc.enabled = 1
        INNER JOIN channels c 
                ON c.ID = cc.customer_id 
               AND c.NAME = '<xsl:value-of select="$channel"/>' 
        left outer JOIN customer_locale_export cle
                ON cle.locale = o.localisation
               AND cle.customer_id = '<xsl:value-of select="$channel"/>' 
               AND cle.ctn = o.object_id
        INNER JOIN catalog_objects co
                ON co.object_id = o.object_id
               AND co.country = '<xsl:value-of select="substring-after($locale,'_')"/>'
               AND co.customer_id = cc.catalog_type  
               and (co.eop > sysdate - 100)
               and co.deleted = 0
             where CLE.ctn is NULL ;
            <!-- populate i_total_products -->
            open c_product_count(p_locale,p_channel,p_country);
            fetch c_product_count into i_total_products;
            close c_product_count;
            <!-- flag products for export -->
            for r in c_products_to_export(p_locale,p_channel,p_country)
              loop
                  i := i+1;
                  update customer_locale_export cle 
                     set batch = (ceil(i_total_products/batch_size) - ceil(i/batch_size)) + 1 
                   where cle.rowid = r.cle_rowid;
              end loop;
        end;

      </sql:query>
    </sql:execute-query>
  <!-- -->
</xsl:template>
</xsl:stylesheet>