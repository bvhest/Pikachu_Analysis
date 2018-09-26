<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >
  <!-- -->
  <xsl:param name="ct" />
  <xsl:param name="locale" />
  <xsl:param name="ts" />
  <!--  
     | select the octl-records that have been updated by the current run and 
     | merge this data into the CLE-table (which in this case is used to trace 
     | the date of import instead of the date of export).
     -->
  <xsl:template match="/">
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
merge into customer_locale_export t
using (select *
         from octl
        where content_type    = '<xsl:value-of select="$ct"/>'
          and localisation    = '<xsl:value-of select="$locale"/>'
          and lastmodified_ts = TO_DATE('<xsl:value-of select="$ts"/>','yyyymmddhh24miss')
      ) s
  on (t.customer_id     = s.content_type
  and t.locale          = s.localisation
  and t.ctn             = s.object_id
     )
when matched then update 
   set t.lasttransmit = to_date('<xsl:value-of select="$ts"/>','yyyymmddhh24miss')
when not matched then insert 
      (customer_id, locale, ctn, lasttransmit, flag, batch, remark)
   values 
      (s.content_type, s.localisation, s.object_id, to_date('<xsl:value-of select="$ts"/>','yyyymmddhh24miss'), 0, NULL, NULL)
        </sql:query>
     </sql:execute-query>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>