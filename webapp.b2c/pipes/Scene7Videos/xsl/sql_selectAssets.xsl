<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
  <xsl:param name="channel"/>
  <xsl:param name="batchNumber"/>
      
  <xsl:template match="/">
    <root>
      <!-- clear all-->
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
         <sql:query name="select-assets">
           select distinct al.asset_resource_ref as asset_ref
                         , al.doctype
                         , al.internalresourceidentifier as srcurl
                         , al.format as mimetype
                         , al.md5
           from customer_locale_export cle
           
           inner join asset_lists al
              on al.asset_resource_ref=cle.ctn
              
           where cle.customer_id='<xsl:value-of select="$channel"/>'
             and cle.batch=<xsl:value-of select="$batchNumber"/>
         </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>