<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:template match="/">
    <root>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="channels">
          SELECT c.name
                ,cc.CUSTOMER_ID
                ,cc.LOCALE
                ,cc.CATALOG_TYPE
                ,cc.DIVISION
                ,cc.BRAND
                ,cc.PRODUCT_TYPE
                ,decode(cc.ENABLED,0,'No',1,'Yes') ENABLED
                ,decode(cc.LOCALEENABLED,0,'No',1,'Yes') LOCALEENABLED
                ,decode(cc.MASTERLOCALEENABLED,0,'No',1,'Yes') MASTERLOCALEENABLED
          from channels c  
          left outer join channel_catalogs cc
          on cc.customer_id = c.id 
          where c.name = '<xsl:value-of select="if($param1='RenderingExport') then 'RenderingExport/delta' else $param1"/>'
          order by cc.locale, cc.catalog_type, cc.division, cc.brand
      </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>