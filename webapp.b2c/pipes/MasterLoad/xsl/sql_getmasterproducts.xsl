<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql xsl">
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="reload"/>
  <!-- -->
  <xsl:template match="/">
    <batch exportdate="12">
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          select p.ctn, p.division, p.brand, p.result, p.lastmodified, p.remark,p.locale,p.mplm,sysdate as runts
          from
            (
          <xsl:if test="$reload='0'">
            <!-- If this is not a reload run, select raw products for which there is currently no corresponding master product -->              
              select rmp.CTN, rmp.division, rmp.brand, 'new '||rmp.DATA_TYPE result, rmp.LASTMODIFIED, 'last modified on '||to_char(rmp.LASTMODIFIED,'dd/mm/yyyy hh24:mi:ss') remark, 'Master' locale, null as mplm
              from  RAW_MASTER_PRODUCTS rmp left outer join (select ctn id, lasttransmit as lastmodified from CUSTOMER_LOCALE_EXPORT where customer_id = 'MasterLoad' and locale = 'Product') mp
                on rmp.CTN = mp.ID
              where rmp.DATA_TYPE = 'Product'
                and mp.id is NULL
              union
          </xsl:if>
              select rmp.CTN, rmp.division, rmp.brand, 'modified '||rmp.DATA_TYPE result, rmp.LASTMODIFIED, 'last modified on '||to_char(rmp.LASTMODIFIED,'dd/mm/yyyy hh24:mi:ss') remark, 'Master' locale, mp.lastmodified as mplm
              from       (select ctn, brand, division, data_type, lastmodified from RAW_MASTER_PRODUCTS where DATA_TYPE = 'Product') rmp 
              inner join (select id, lastmodified from master_products) mp
                on rmp.ctn = mp.id
              inner join (select ctn, lasttransmit as lastmodified from CUSTOMER_LOCALE_EXPORT where customer_id = 'MasterLoad' and locale = 'Product') curr
                on rmp.CTN = curr.ctn
          <xsl:if test="$reload='0'">                
              where rmp.LASTMODIFIED > curr.LASTMODIFIED <!-- curr.LASTMODIFIED is the lastmodified of the most recent RMP Product constituent of the current master product -->
          </xsl:if>              
              union
              select rmp.CTN, rmp.division, rmp.brand, 'modified '||disclaimer.DATA_TYPE result, disclaimer.LASTMODIFIED,'last modified on '||to_char(disclaimer.LASTMODIFIED,'dd/mm/yyyy hh24:mi:ss') remark, 'Master' locale, mp.lastmodified as mplm
              from       (select ctn, division, brand from RAW_MASTER_PRODUCTS where DATA_TYPE = 'Product') rmp 
              inner join (select id, lastmodified from master_products) mp
                on rmp.ctn = mp.id
              inner join (select ctn, data_type, lastmodified from RAW_MASTER_PRODUCTS where DATA_TYPE = 'Disclaimer') disclaimer
                on rmp.ctn = disclaimer.ctn
              inner join (select ctn, lasttransmit as lastmodified from CUSTOMER_LOCALE_EXPORT where customer_id = 'MasterLoad' and locale = 'Disclaimer') curr <!-- curr.LASTMODIFIED is the lastmodified of the  most recent RMP disclaimer constituent of the current master product -->
                on disclaimer.CTN = curr.CTN
          <xsl:if test="$reload='0'">                                
              where disclaimer.LASTMODIFIED > curr.LASTMODIFIED
          </xsl:if>                            
            ) p
          
          <!-- where p.ctn = '14MT2131/78' -->
          
          
          order by p.ctn,p.lastmodified desc            
        </sql:query>
      </sql:execute-query>
    </batch>
  </xsl:template>
<!-- -->
</xsl:stylesheet>