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
  <xsl:param name="country"/>
  <xsl:param name="batchsize"/>
  <xsl:param name="contentType"/>
  <!-- -->
  <xsl:template match="/">
    <!-- update flagged CLE-records to set the batch number -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query isstoredprocedure="true">
         declare
            cursor c1( p_channel IN VARCHAR2
                     , p_ct      IN VARCHAR2
                     , p_locale  IN VARCHAR2
                     ) 
            is
               select cle.rowid AS cle_rowid
                 from customer_locale_export cle
                inner join octl o 
                   on o.content_type  = p_ct 
                  and o.localisation  = cle.locale 
                  and o.object_id     = cle.ctn
                where cle.customer_id = p_channel
                  and cle.locale      = p_locale
                  and cle.lasttransmit &lt; o.lastmodified_ts --NEW!! moved from selectbatches to createbatches to decrease the number of exported products (ToDo: check with Freek)
                order by o.masterlastmodified_ts desc
            ;
                
            cursor c2( p_channel IN VARCHAR2
                     , p_ct      IN VARCHAR2
                     , p_locale  IN VARCHAR2
                     ) 
            is
               select count(*)
                 from customer_locale_export cle
                inner join octl o 
                   on o.content_type  = p_ct
                  and o.localisation  = cle.locale 
                  and o.object_id     = cle.ctn
                where cle.customer_id = p_channel
                  and cle.locale      = p_locale
                  and cle.lasttransmit &lt; o.lastmodified_ts --NEW!! moved from selectbatches to createbatches to decrease the number of exported products (ToDo: check with Freek)
            ;
                
            i           PLS_INTEGER := 0;
            i_maxbatch  PLS_INTEGER := 0;                
            batch_size  PLS_INTEGER := <xsl:value-of select="$batchsize"/>;

            v_locale    customer_locale_export.locale%type := '<xsl:value-of select="$locale"/>';
            v_channel   customer_locale_export.customer_id%type := '<xsl:value-of select="$channel"/>';        
            v_ct        octl.content_type%type := '<xsl:value-of select="$contentType"/>';        
   
         begin

            open c2(v_channel, v_ct, v_locale);
            fetch c2 into i_maxbatch;
            close c2;

            for r in c1(v_channel, v_ct, v_locale)
            loop
               i := i+1;
               update customer_locale_export cle 
                  set cle.batch = (ceil(i_maxbatch/batch_size) - ceil(i/batch_size)) + 1 
                where cle.rowid = r.cle_rowid;
            end loop; 
         end;
      </sql:query>
    </sql:execute-query>
  <!-- -->
</xsl:template>
</xsl:stylesheet>