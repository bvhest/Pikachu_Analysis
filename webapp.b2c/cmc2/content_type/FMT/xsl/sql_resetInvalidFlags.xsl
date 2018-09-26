<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ts"/>
  <xsl:template match="/">
    <entries ct="FMT" ts="{$ts}">
      <entry includeinreport='yes'>
        <sql:execute-query>
          <sql:query name="select">
                select   pmt.localisation
                        ,pmt.object_id
                        ,pmt.needsprocessing_ts
                  from  (select * from octl where content_type = 'FMT' and needsprocessing_flag = 1 and status = 'PLACEHOLDER') pmt
            inner join  (select * from octl where content_type = 'FMT_Translated' and lastmodified_ts = to_date('1900-01-01','YYYY-MM-DD')) t
                    on pmt.localisation = t.localisation
                   and pmt.object_id = t.object_id
               --  and pmt.localisation = 'de_DE' and rownum &lt; 10
          </sql:query>
        </sql:execute-query>
        <!-- -->
        <sql:execute-query>
          <sql:query name="update">
                UPDATE OCTL pmt
                   SET NEEDSPROCESSING_FLAG = 0
                 WHERE CONTENT_TYPE = 'FMT'
                   and needsprocessing_flag = 1
                   and status = 'PLACEHOLDER'
                 --and pmt.localisation = 'de_DE' and rownum &lt; 10
                   AND EXISTS (select 1
                                 from octl t
                                where content_type = 'FMT_Translated'
                                  and localisation = pmt.localisation
                                  and object_id = pmt.object_id
                                  and lastmodified_ts = to_date('1900-01-01','YYYY-MM-DD')
                               )
          </sql:query>
        </sql:execute-query>
      </entry>
    </entries>
  </xsl:template>
</xsl:stylesheet>