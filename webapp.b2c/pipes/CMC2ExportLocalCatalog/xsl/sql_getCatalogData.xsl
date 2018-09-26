<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="customer"/>
  <xsl:param name="country"/>
  <xsl:param name="channel"/>
  <xsl:param name="exporttype"/>
  <xsl:param name="include-config"/>
  
  <xsl:template match="/">
    <root>
      <catalog-definitions>
        <sql:execute-query>
          <sql:query>
  select CUSTOMER_ID,
         COUNTRY,
         CTN,
         DIVISION,
         TO_CHAR(SOP,'YYYY-MM-DD"T"HH24:MI:SS') sop,
         TO_CHAR(EOP,'YYYY-MM-DD"T"HH24:MI:SS') eop,
         TO_CHAR(SOS,'YYYY-MM-DD"T"HH24:MI:SS') sos,
         TO_CHAR(EOS,'YYYY-MM-DD"T"HH24:MI:SS') eos,
         BUY_ONLINE,
         LOCAL_GOING_PRICE,
         DELETED, 
         TO_CHAR(DELETE_AFTER_DATE,'YYYY-MM-DD"T"HH24:MI:SS') DELETE_AFTER_DATE,
         PRIORITY,
         TO_CHAR(LASTMODIFIED,'YYYY-MM-DD"T"HH24:MI:SS') LASTMODIFIED 
  from customer_catalog cc
  where CUSTOMER_ID='<xsl:value-of select="if(ends-with($customer,'_MARKETING')) then $customer else replace($customer,'_',' ')"/>'
  and COUNTRY= '<xsl:value-of select="$country"/>'
  <xsl:if test="$exporttype = 'delta'">
            and lastmodified > nvl((select lasttransmit 
                                      from customer_locale_export 
                                     where customer_id = '<xsl:value-of select="$channel"/>' 
                                       and locale = 'none' 
                                       and ctn = <xsl:choose>
                                                   <xsl:when test="ends-with($customer,'_MARKETING')">
                                                     cc.customer_id || '_' || cc.country || '_Catalog')
                                                   </xsl:when>
                                                   <xsl:otherwise>
                                                     replace(cc.customer_id,' ','_') || '_' || cc.country || '_Catalog')
                                                   </xsl:otherwise>  
                                                 </xsl:choose>                                                 
                                   ,to_date('19000101','YYYYMMDD')
                                   ) - 1
  </xsl:if>                                   
              </sql:query>
        </sql:execute-query>
      </catalog-definitions>
      <xsl:if test="$include-config ne ''">
        <catalog-configurations>
          <sql:execute-query>
            <sql:query>
            select distinct locale
            from customer_catalog c
            inner join locale_language l on l.country=c.country
            where CUSTOMER_ID='<xsl:value-of select="if(ends-with($customer,'_MARKETING')) then $customer else replace($customer,'_',' ')"/>'
            and c.country='<xsl:value-of select="$country"/>'          
            </sql:query>
          </sql:execute-query>
        </catalog-configurations>
      </xsl:if>
    </root>
  </xsl:template>
</xsl:stylesheet>
