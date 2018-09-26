<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="fullexport"/>
  <!-- -->
  <xsl:template match="/">
  <root>
  <!-- clear all-->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        update CUSTOMER_LOCALE_EXPORT
        set FLAG=0
        where
          CUSTOMER_ID='<xsl:value-of select="$channel"/>'
          and LOCALE='<xsl:value-of select="$locale"/>'
      </sql:query>
    </sql:execute-query>

  <!-- Insert a record into CLE if there is a new product for this channel and locale -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
        insert into CUSTOMER_LOCALE_EXPORT(CUSTOMER_ID, LOCALE, CTN, FLAG)
        select distinct '<xsl:value-of select="$channel"/>',
                        '<xsl:value-of select="$locale"/>',
                        MP.ID,
                        0
        from MASTER_PRODUCTS MP
        left outer join (select * from CUSTOMER_LOCALE_EXPORT where CUSTOMER_ID='<xsl:value-of select="$channel"/>' and locale = '<xsl:value-of select="$locale"/>') CLE
            on MP.ID=CLE.CTN
        inner join CUSTOMER_CATALOG CUST_CAT
            on MP.ID = CUST_CAT.CTN
        inner join (select COUNTRY from LOCALE_LANGUAGE where LOCALE = '<xsl:value-of select="$locale"/>') LL
            on CUST_CAT.COUNTRY = LL.COUNTRY
        inner join (select CH_C.CATALOG_TYPE, CH_C.DIVISION
                      from CHANNEL_CATALOGS CH_C
                     inner join CHANNELS C
                        on CH_C.CUSTOMER_ID = C.ID
                     where C.NAME = '<xsl:value-of select="$channel"/>' and CH_C.LOCALE = '<xsl:value-of select="$locale"/>' and ENABLED = 1) CH_CTGS
            on  CUST_CAT.CUSTOMER_ID = CH_CTGS.CATALOG_TYPE
           and CUST_CAT.DIVISION = CH_CTGS.DIVISION
           and CUST_CAT.COUNTRY = '<xsl:value-of select="substring-after($locale,'_')"/>'
           and CUST_CAT.DELETED != 1
           and CUST_CAT.EOP &gt; SYSDATE
         where CLE.CUSTOMER_ID is NULL
           and   MP.STATUS in ('Final Published','MasterBlaster')
      </sql:query>
    </sql:execute-query>

    <!-- Set flag to 1 if the row is new, or if the product's categorization or navigation has changed since last export -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
          update CUSTOMER_LOCALE_EXPORT CLE
          set flag = 1
          where customer_id  = '<xsl:value-of select="$channel"/>'
          and   locale       = '<xsl:value-of select="$locale"/>'
          and   flag = 0
          and exists (select 1 from MASTER_PRODUCTS MP where MP.ID = CLE.CTN and MP.STATUS in ('Final Published','MasterBlaster'))          
          <xsl:if test="not($fullexport = 'yes')">
          and     (lasttransmit is null
                                 or
                  lasttransmit &lt; (select nvl(lastmodified,to_date('1970-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS'))
                                     from raw_master_products r where r.ctn = cle.ctn and r.data_type = 'WebSiteFiltering')
                                 or
                  lasttransmit &lt; (select nvl(max(lastmodified),to_date('1970-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS'))
                                     from subcat_products s where s.id = cle.ctn group by s.id))
          </xsl:if>                                     
         <!-- and rownum &lt; 10 -->
      </sql:query>
    </sql:execute-query>
  </root>
</xsl:template>
</xsl:stylesheet>
