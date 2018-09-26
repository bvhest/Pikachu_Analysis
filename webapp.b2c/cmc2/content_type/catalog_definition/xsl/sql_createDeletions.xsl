<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:my="http://pww.pikachu.philips.com/functions/local">

  <xsl:import href="catalog-base.xsl"/>

  <xsl:param name="customer_id"/>
  <xsl:param name="country"/>
  <xsl:param name="destination" />
  <xsl:param name="timestamp" />
  
  <xsl:template match="/">
    <xsl:variable name="ext-cat-table" select="my:get-external-table-name($destination)"/>
        
    <root name="mark-catalog-deletions">
      <xsl:choose>
        <xsl:when test="$ext-cat-table != ''">
          <sql:execute-query>
            <sql:query name="sql_createDeletions">
             update catalog_objects co
                set co.deleted = 1
                  , co.delete_after_date = trunc(SYSDATE,'DD') + 90 
                  , co.lastModified      = to_date('<xsl:value-of select="$timestamp"/>', 'yyyy-MM-dd"T"hh24:mi:ss')
              where co.customer_id    = '<xsl:value-of select="$customer_id"/>'
                and co.country        = '<xsl:value-of select="$country"/>'
                and nvl(co.deleted,0) = 0
                and not exists (select 1 
                                  from <xsl:value-of select="$ext-cat-table"/> co_ext
                                 where co_ext.customer_id = '<xsl:value-of select="$customer_id"/>'
                                   and co_ext.object_id   = co.object_id
                                   and co_ext.catalog_id  = co.catalog_id
                               )
            </sql:query>
          </sql:execute-query>
        </xsl:when>
        <xsl:otherwise>
          <error>Invalid destination specified: <xsl:value-of select="$destination"/></error>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>