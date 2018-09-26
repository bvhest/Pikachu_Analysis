<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="reload"/>
  <xsl:param name="channel"/>          
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="Products/entry/Product"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="Product">
    <entry reload="{$reload}">
      <xsl:attribute name="id"><xsl:value-of select="CTN"/></xsl:attribute>
      <xsl:attribute name="locale"><xsl:text>Master</xsl:text></xsl:attribute>
      <sql:execute-query>
        <sql:query>
               update   master_products
               set      status = '<xsl:value-of select="MarketingStatus"/>'
                       ,division = '<xsl:value-of select="@Division"/>'
                       ,brand = '<xsl:value-of select="@Brand"/>'
                       ,lastmodified = to_date('<xsl:value-of select="substring(@lastModified,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss')
               where    id = '<xsl:value-of select="CTN"/>'
       </sql:query>
      </sql:execute-query>
      <!-- -->
      <sql:execute-query>
        <sql:query>
                insert   into master_products (id, division, brand, status, lastmodified)
                select   '<xsl:value-of select="CTN"/>'
                        ,'<xsl:value-of select="@Division"/>'
                        ,'<xsl:value-of select="@Brand"/>'
                        ,'<xsl:value-of select="MarketingStatus"/>'
                        ,to_date('<xsl:value-of select="substring(@lastModified,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss')
                from     dual
                where not exists
                         (select 1
                          from master_products
                          where id  = '<xsl:value-of select="CTN"/>')
        </sql:query>
      </sql:execute-query>
      <!-- -->
      <sql:execute-query>
              <sql:in-xml-parameter nr="1">
                      <xsl:copy-of copy-namespaces="no" select="."/>
              </sql:in-xml-parameter>
              <sql:query>
                      update master_products mp
                      set    mp.data = ?
                      where (mp.id = '<xsl:value-of select="CTN"/>')
              </sql:query>
      </sql:execute-query>
      <!-- -->      
      <xsl:if test="$reload = '0'">
	      <sql:execute-query>
	        <sql:query>
	                MERGE INTO customer_locale_export cle
	                using (
	                  select 
	                    '<xsl:value-of select="CTN"/>' as ctn,
	                    '<xsl:value-of select="$channel"/>' as customer_id,
	                    'Product' as locale,
	                    to_date('<xsl:value-of select="substring(../rmp-p-lm,1,19)"/>','yyyy-mm-dd hh24:mi:ss') as lasttransmit,
	                    sysdate as remark
	                  from dual) s
	                  on (cle.ctn = s.ctn and cle.customer_id = s.customer_id and cle.locale = s.locale)
	                  when matched then
	                    update set 
	                      cle.lasttransmit= s.lasttransmit,
	                      cle.remark = s.remark 
	                  when not matched then
	                    insert (cle.ctn, cle.locale, cle.customer_id, cle.lasttransmit, cle.remark)
	                    values (  s.ctn,   s.locale,   s.customer_id,   s.lasttransmit,   s.remark)
	        </sql:query>
	      </sql:execute-query>                        
	      <!-- -->      
	      <xsl:if test="string-length(../rmp-d-lm) > 0">
	        <sql:execute-query>
	          <sql:query>
	                  MERGE INTO customer_locale_export cle
	                  using (
	                    select 
	                      '<xsl:value-of select="CTN"/>' as ctn,
	                      '<xsl:value-of select="$channel"/>' as customer_id,
	                      'Disclaimer' as locale,
	                      to_date('<xsl:value-of select="substring(../rmp-d-lm,1,19)"/>','yyyy-mm-dd hh24:mi:ss') as lasttransmit,
	                      sysdate as remark
	                    from dual) s
	                    on (cle.ctn = s.ctn and cle.customer_id = s.customer_id and cle.locale = s.locale)
	                    when matched then
	                      update set 
	                        cle.lasttransmit= s.lasttransmit,
	                        cle.remark = s.remark 
	                    when not matched then
	                      insert (cle.ctn, cle.locale, cle.customer_id, cle.lasttransmit, cle.remark)
	                      values (  s.ctn,   s.locale,   s.customer_id,   s.lasttransmit,   s.remark)
	          </sql:query>
	        </sql:execute-query>  
	      </xsl:if>
      </xsl:if>
    </entry>
  </xsl:template>
</xsl:stylesheet>