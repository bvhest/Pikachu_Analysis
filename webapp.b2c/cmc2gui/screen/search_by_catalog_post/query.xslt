<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="id"/>
  <xsl:variable name="id2" select="upper-case(/h:request/h:requestParameters/h:parameter[@name='Search']/h:value)"/>
  <xsl:variable name="idreal">
    <xsl:choose>
      <xsl:when test="not ($id2 = '')">
        <xsl:value-of select="$id2"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="upper-case($id)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- -->
  <xsl:template match="/h:request/h:requestParameters">
    <root id="{$idreal}">
      <!-- -->
      <xsl:variable name="id" select="replace(h:parameter[@name='id']/h:value,'\*','%')"/>
      <xsl:variable name="v_sql" select='if($id != "") then concat(" and object_id like &apos;%",$id,"%&apos;") else ""'/>
      <xsl:variable name="v_radiofilesfilter" select="h:parameter[@name='radiofilesfilter']/h:value"/>
      <xsl:variable name="v_radiofilesfilter_sql" select='if($v_radiofilesfilter = "all") then "" 
                                                     else if($v_radiofilesfilter = "active") then " and sop &lt; sysdate  and eop &gt; sysdate" 
                                                     else if($v_radiofilesfilter = "inactive") then " and not (sop &lt; sysdate  and eop &gt; sysdate)"
                                                     else ""'/>
      <xsl:variable name="v_catalog" select="h:parameter[@name='catalog']/h:value"/>
      <xsl:variable name="v_country" select="h:parameter[@name='country']/h:value"/>
      <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="catalogs">
          <!-- Build the SQL -->
      select distinct co.object_id ctn
            , co.country
            , co.customer_id as catalog_type
            , to_char(co.sop, 'YYYY-MM-DD') as SOP
            , to_char(co.eop, 'YYYY-MM-DD') as EOP
            , co.priority
            , co.local_going_price
            , co.division
            , co.lastmodified
            , co.deleted
            , ll.locale
            , ll.language
            ,  to_char(co.delete_after_date, 'YYYY-MM-DD') dad
        from catalog_objects co
  inner join locale_language ll 
          on ll.country=co.country
        <xsl:if test="$id != ''">
            <xsl:value-of select="$v_sql"/>
          </xsl:if>
          <xsl:if test="$v_catalog != ''">
          and co.customer_id = '<xsl:value-of select="$v_catalog"/>'
        </xsl:if>
          <xsl:if test="$v_country != ''">          
          and co.country = '<xsl:value-of select="$v_country"/>'
        </xsl:if>
          <xsl:value-of select="$v_radiofilesfilter_sql"/>
        
  order by co.object_id, co.country, co.customer_id

        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="h:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
