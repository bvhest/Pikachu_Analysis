<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:my="http://pww.pikachu.philips.com/functions/local">

  <xsl:import href="catalog-base.xsl" />

  <xsl:param name="destination" />

  <xsl:template match="/">
    <xsl:variable name="ext-cat-table" select="my:get-external-table-name($destination)" />

    <root destination="{$destination}">
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="catalogs">
          select distinct catalog_id, customer_id, country from <xsl:value-of select="$ext-cat-table" />
        </sql:query>
        <sql:execute-query>
          <sql:query name="actual-totals">
            select count(*) actual_total
              from catalog_objects co
             where co.catalog_id = '<sql:ancestor-value name="catalog_id" level="1" />'
               and nvl(co.deleted,0) = 0
          </sql:query>
        </sql:execute-query>
      </sql:execute-query>

      <sql:execute-query>
        <sql:query name="deletions">
          select distinct co.catalog_id, co.customer_id, co.country
               ,  count(*) over(partition by co.catalog_id) catalog_deleted
               ,  count(*) over(partition by co.country) country_deleted
               ,  count(*) over() total_deleted
            from catalog_objects co
            left outer join <xsl:value-of select="$ext-cat-table" /> ext
              on ext.catalog_id  = co.catalog_id
             and ext.object_id   = co.object_id
           where ext.object_id  is null
             and co.customer_id in (select distinct customer_id from <xsl:value-of select="$ext-cat-table" />)
             and co.deleted      = 0
             and co.country     != 'GLOBAL'
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>