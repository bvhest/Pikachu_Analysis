<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="channel"/>
  <xsl:param name="timestamp"/>
  
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
         <sql:query name="update-cle">
           update customer_locale_export cle
           set (flag, batch, lasttransmit, remark)=(
              select 0, 0
                   , to_date('<xsl:value-of select="$timestamp"/>','yyyymmddhh24miss')
                   , max(al.md5) from asset_lists al where al.asset_resource_ref=cle.ctn group by al.asset_resource_ref
              )
           where customer_id='<xsl:value-of select="$channel"/>'
             and flag=1
         </sql:query>
      </sql:execute-query>

      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
         <sql:query name="update-deletes-cle">
           update customer_locale_export cle
           set flag = 0
             , batch = 0
             , lasttransmit = to_date('<xsl:value-of select="$timestamp"/>','yyyymmddhh24miss')
             , remark = 'DELETED'
           where customer_id='<xsl:value-of select="$channel"/>'
             and flag=2
         </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>