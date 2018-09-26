<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="content-type" />
  <xsl:param name="locale" />

  <xsl:template match="/">
    <root>
      <sql:execute-query>
        <!-- substr(data,8) removes the file:// prefix and prevents the SQLTransformer from fetching the XML data -->
        <sql:query>
          select CONTENT_TYPE
               , LOCALISATION
               , OBJECT_ID
               , NEEDSPROCESSING_FLAG
               , DERIVESECONDARY_FLAG
               , NEEDSPROCESSING_TS
               , INTRANSACTION_FLAG
               , MASTERLASTMODIFIED_TS
               , LASTMODIFIED_TS
               , STARTOFPROCESSING
               , ENDOFPROCESSING
               , ACTIVE_FLAG
               , STATUS
               , BATCH_NUMBER
               , REMARK
               , ISLOCALIZED
               , MARKETINGVERSION
               , substr(DATA, 8) DATA
          from OCTL
          where content_type='<xsl:value-of select="$content-type" />'
            and localisation='<xsl:value-of select="$locale" />'
            and (object_id like 'FC%'
                 or
                 object_id like '%PFL%')
          union
          select CONTENT_TYPE
               , LOCALISATION
               , OBJECT_ID
               , NEEDSPROCESSING_FLAG
               , DERIVESECONDARY_FLAG
               , NEEDSPROCESSING_TS
               , INTRANSACTION_FLAG
               , MASTERLASTMODIFIED_TS
               , LASTMODIFIED_TS
               , STARTOFPROCESSING
               , ENDOFPROCESSING
               , ACTIVE_FLAG
               , STATUS
               , BATCH_NUMBER
               , REMARK
               , ISLOCALIZED
               , MARKETINGVERSION
               , substr(DATA, 8) DATA 
          from octl 
          where 
            content_type='Categorization_Raw'
            and
            localisation='none'
            and object_id = 'MASTER'
          union
          select CONTENT_TYPE
               , LOCALISATION
               , OBJECT_ID
               , NEEDSPROCESSING_FLAG
               , DERIVESECONDARY_FLAG
               , NEEDSPROCESSING_TS
               , INTRANSACTION_FLAG
               , MASTERLASTMODIFIED_TS
               , LASTMODIFIED_TS
               , STARTOFPROCESSING
               , ENDOFPROCESSING
               , ACTIVE_FLAG
               , STATUS
               , BATCH_NUMBER
               , REMARK
               , ISLOCALIZED
               , MARKETINGVERSION
               , substr(DATA, 8) DATA 
          from octl 
          where
            content_type='UAP'
            and
            localisation='none'
            and
            object_id in (
               select distinct owner
               from pms_products
               where
                 (ctn like 'FC%' or
                  ctn like '%PFL%' or
                  ctn='1090X/20')
            )
          union
          select CONTENT_TYPE
               , LOCALISATION
               , OBJECT_ID
               , NEEDSPROCESSING_FLAG
               , DERIVESECONDARY_FLAG
               , NEEDSPROCESSING_TS
               , INTRANSACTION_FLAG
               , MASTERLASTMODIFIED_TS
               , LASTMODIFIED_TS
               , STARTOFPROCESSING
               , ENDOFPROCESSING
               , ACTIVE_FLAG
               , STATUS
               , BATCH_NUMBER
               , REMARK
               , ISLOCALIZED
               , MARKETINGVERSION
               , substr(DATA, 8) DATA 
          from octl 
          where
            content_type='PMA'
            and (object_id like 'FC%'
                 or
                 object_id like '%PFL%')  
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>
