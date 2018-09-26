<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">
    
  <xsl:template match="/">
    <root>
      <sql:execute-query>
        <sql:query name="reset catalog_objects np">
          update catalog_objects set needsprocessing_flag=0 where needsprocessing_flag != 0
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query name="reset catalog_ctl np">
          update catalog_ctl set needsprocessing_flag=0 where needsprocessing_flag != 0
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query name="reset octl_control">
          update octl_control set needsprocessing_flag=0, batch_number=0
          where needsprocessing_flag!=0
             or nvl(batch_number,0)!=0
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query name="reset running ct">
          update content_type_schedule set endexec=startexec
          where endexec&lt;startexec
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query name="reset running channel">
          update channels set endexec=startexec
          where endexec&lt;startexec
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query name="reset export history">
          update customer_locale_export set lasttransmit=sysdate
        </sql:query>
      </sql:execute-query>
      <!-- sql:execute-query>
        <sql:query name="refresh materialized views">
          begin
            BATCH_PRE_PROCESSING.refresh_mv(NULL);
          end;
        </sql:query>
      </sql:execute-query -->
    </root>
  </xsl:template>
</xsl:stylesheet>