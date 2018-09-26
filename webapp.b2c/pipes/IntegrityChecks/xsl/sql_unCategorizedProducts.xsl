<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="catalog"></xsl:param>
	<!-- -->
	<xsl:template match="/">
		<root catalog="{$catalog}">		
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query>
          <xsl:choose>
            <xsl:when test="$catalog = 'MASTER'">
        select distinct o.object_id 
          from octl o 
          left outer join vw_object_categorization oc
            on oc.object_id   = o.object_id 
           and oc.catalogcode = '<xsl:value-of select="$catalog"/>'
         where o.content_type = 'PMT_Raw'
           and o.status      != 'PLACEHOLDER'
           and oc.object_id  is null
         order by o.object_id
            </xsl:when>
            <xsl:otherwise>
        select distinct co.object_id 
          from catalog_objects co 
           left outer join vw_object_categorization oc
            on oc.object_id   = co.object_id 
           and oc.catalogcode = '<xsl:value-of select="$catalog"/>'
         where co.customer_id = '<xsl:value-of select="$catalog"/>'
           and oc.object_id is null
           and co.sop &lt; sysdate
           and co.eop &gt; sysdate
           and co.deleted = 0
         order by co.object_id
            </xsl:otherwise>                  
          </xsl:choose>
				</sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>