<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" >

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
   <xsl:template match="entry[sql:rowset/sql:row/sql:returncode=1][currentmarketingversion != octl-attributes/marketingversion]">
    <entry>
      <xsl:apply-templates select="@*|node()"/>
      <trigger>
 				<sql:execute-query>
					<sql:query>
          select 'TXTRIGGER_'||co1.country||'_Catalog' catalog_id
               , vco.OBJECT_ID object_id
               , 'TXTRIGGER' customer_id
               , co1.country country
               , co1.division division
               , co1.gtin
               , to_char(vco.sop,'YYYY-MM-DD"T"HH24:MI:SS') sop
               , to_char(add_months(SYSDATE,2),'YYYY-MM-DD"T"HH24:MI:SS') eop
               , to_char(co1.sos,'YYYY-MM-DD"T"HH24:MI:SS') sos
               , to_char(co1.eos,'YYYY-MM-DD"T"HH24:MI:SS') eos
               , c.content_type
               , c.localisation
               , co1.BUY_ONLINE
               , co1.LOCAL_GOING_PRICE
               , co1.DELETED
               , to_char(co1.DELETE_AFTER_DATE,'YYYY-MM-DD"T"HH24:MI:SS') DELETE_AFTER_DATE
               , co1.PRIORITY
               , to_char(co1.LASTMODIFIED,'YYYY-MM-DD"T"HH24:MI:SS') LASTMODIFIED
          from (
          select co.object_id
               , MIN(catalog_id) catalog_id
               , MIN(sop) sop
               , MAX(eop) eop
            from catalog_objects co
           where co.eop IS NOT NULL
             and co.sop IS NOT NULL
        group by co.object_id
               ) vco 
      inner join catalog_ctl c 
              on c.catalog_id = vco.catalog_id
      inner join catalog_objects co1 
              on co1.catalog_id = vco.catalog_id 
             and co1.object_id = vco.object_id
           where vco.object_id = '<xsl:value-of select="@o"/>' 
             and vco.eop &lt; SYSDATE
					</sql:query>
				</sql:execute-query>
      </trigger>
    </entry>
  </xsl:template>
</xsl:stylesheet>
