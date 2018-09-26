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
  <xsl:param name="customer"/>
  <xsl:param name="country"/>  
  <xsl:param name="timestamp"/>
  
  <!-- -->
  <xsl:template match="/">
  <root>
  <!-- set flag to 1 if the export was before the last modified date -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
          merge into CUSTOMER_LOCALE_EXPORT cle
          using ( select   '<xsl:value-of select="$channel"/>' as customer_id
                          ,'none' as locale
                          ,'<xsl:value-of select="concat($customer,'_',$country,'_Catalog')"/>' as ctn
                          ,to_date('<xsl:value-of select="$timestamp"/>','yyyymmddhh24miss') as lasttransmit                            
                          ,null as flag
                          ,null as batch
                          ,null as remark                            
                    from dual) s
             on (cle.customer_id = s.customer_id and cle.ctn=s.ctn and cle.locale = s.locale)
           when matched then
                    update set 
                        cle.lasttransmit = s.lasttransmit
          when not matched then
                    insert (cle.customer_id,cle.locale,cle.ctn,cle.lasttransmit,cle.flag,cle.batch,cle.remark)
                    values(s.customer_id,s.locale,s.ctn,s.lasttransmit,s.flag,s.batch,s.remark)  
      </sql:query>
    </sql:execute-query>
  </root>    
</xsl:template>
</xsl:stylesheet>