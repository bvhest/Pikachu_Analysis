<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0"
  exclude-result-prefixes="sql xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="masterlocale"/>
  <xsl:param name="master"/>
  
  <xsl:variable name="publicationOffset">
    <xsl:choose>
      <xsl:when test="$channel='AtgRange'">45</xsl:when> 
      <xsl:otherwise>7</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:choose>
        <xsl:when test="$masterlocale = 'yes'">
          <!-- Retrieve master content for locale -->
          <Nodes>
            <sql:execute-query>
              <sql:query name="RangeText">
                select o.*
                from octl o
                inner join customer_locale_export cle
                   on o.object_id = cle.ctn
                where o.content_type = 'RangeText_Raw'
                  and o.localisation = 'none'
                  and cle.locale = '<xsl:value-of select="$locale"/>'
                  and cle.customer_id = '<xsl:value-of select="$channel"/>'
                  and cle.flag = 1
                order by o.object_id
              </sql:query>
            </sql:execute-query>
          </Nodes>
          <Assignments>
            <sql:execute-query>
              <sql:query name="Assignments">
                select co.object_id, co.customer_id, co.country
                  from catalog_objects co
                 inner join channel_catalogs cc
                    on co.CUSTOMER_ID = cc.CATALOG_TYPE
                   and substr(cc.locale,4,2) = co.COUNTRY
                   and cc.locale = '<xsl:value-of select="$locale"/>'
                   and cc.masterlocaleenabled = 1
                 inner join channels c
                    on c.id = cc.customer_id
                   and c.name = '<xsl:value-of select="$channel"/>'
                 where (co.sop - to_number('<xsl:value-of select="$publicationOffset"/>') ) &lt; sysdate
                   and sysdate &lt; co.eop
                   and co.deleted != 1
              order by co.object_id, co.customer_id
              </sql:query>
            </sql:execute-query>
          </Assignments>
          <Catalogs>
            <sql:execute-query>
              <sql:query name="Catalogs">
                select DISTINCT cc.catalog_type
                  from channels c
                 inner join channel_catalogs cc
                    on c.id = cc.customer_id
                 where c.name = '<xsl:value-of select="$channel"/>'
                   and cc.masterlocaleenabled = 1
                   and cc.locale = '<xsl:value-of select="$locale"/>'
              order by cc.catalog_type
              </sql:query>
            </sql:execute-query>
          </Catalogs>
        </xsl:when>
       <xsl:when test="$locale = 'MASTER'">
          <!-- Retrieve master content -->
          <Nodes>
            <sql:execute-query>
              <sql:query name="RangeText">
                select o.*
                from octl o
                inner join customer_locale_export cle
                   on o.object_id = cle.ctn
                where o.content_type = 'RangeText_Raw'
                  and o.localisation = 'none'
                  and cle.locale = '<xsl:value-of select="$locale"/>'
                  and cle.customer_id = '<xsl:value-of select="$channel"/>'
                  and cle.flag = 1
                order by o.object_id
              </sql:query>
            </sql:execute-query>
          </Nodes>
          <Assignments>
            <sql:execute-query>
              <sql:query name="Assignments">
                select co.object_id, co.customer_id, co.country
                  from catalog_objects co
                 inner join channel_catalogs cc
                    on co.CUSTOMER_ID = cc.CATALOG_TYPE
                   and substr(cc.locale,4,2) = co.COUNTRY
                   and (cc.enabled = 1 or cc.masterlocaleenabled = 1)
                 inner join channels c
                    on c.id = cc.customer_id
                   and c.name = '<xsl:value-of select="$channel"/>'
                 where (co.sop - to_number('<xsl:value-of select="$publicationOffset"/>')) &lt; sysdate
                   and sysdate &lt; co.eop
                   and co.deleted != 1
              order by co.object_id, co.customer_id
              </sql:query>
            </sql:execute-query>
          </Assignments>
          <Catalogs>
            <sql:execute-query>
              <sql:query name="Catalogs">
                select DISTINCT cc.catalog_type
                  from channels c
                 inner join channel_catalogs cc
                    on c.id = cc.customer_id
                 where c.name = '<xsl:value-of select="$channel"/>'
                   and (cc.enabled = 1 or cc.masterlocaleenabled = 1)
              order by cc.catalog_type
              </sql:query>
            </sql:execute-query>
          </Catalogs>
        </xsl:when>
        <xsl:otherwise>
          <!-- Retrieve localized content -->
          <Nodes>
            <sql:execute-query>
              <sql:query name="RangeText">
                select o.*
                from octl o
                inner join customer_locale_export cle
                   on o.object_id = cle.ctn
                  and o.localisation = cle.locale
                where o.content_type = 'RangeText'
                  and cle.locale = '<xsl:value-of select="$locale"/>'
                  and cle.customer_id = '<xsl:value-of select="$channel"/>'
                  and cle.flag = 1
                order by o.object_id
              </sql:query>
            </sql:execute-query>
          </Nodes>
          <Assignments>
            <sql:execute-query>
              <sql:query name="Assignments">
                select co.object_id, co.customer_id, co.country
                  from catalog_objects co
                 inner join channel_catalogs cc
                    on co.CUSTOMER_ID = cc.CATALOG_TYPE
                   and substr(cc.locale,4,2) = co.COUNTRY
                   and cc.locale = '<xsl:value-of select="$locale"/>'
                   and cc.enabled = 1
                 inner join channels c
                    on c.id = cc.customer_id
                   and c.name = '<xsl:value-of select="$channel"/>'
                 where (co.sop - to_number('<xsl:value-of select="$publicationOffset"/>')) &lt; sysdate
                   and sysdate &lt; co.eop
                   and co.deleted != 1
              order by co.object_id, co.customer_id
              </sql:query>
            </sql:execute-query>
          </Assignments>
          <Catalogs>
            <sql:execute-query>
              <sql:query name="Catalogs">
                select DISTINCT cc.catalog_type
                  from channels c
                 inner join channel_catalogs cc
                    on c.id = cc.customer_id
                 where c.name = '<xsl:value-of select="$channel"/>'
                   and cc.enabled = 1
                   and cc.locale = '<xsl:value-of select="$locale"/>'
              order by cc.catalog_type
              </sql:query>
            </sql:execute-query>
          </Catalogs>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>