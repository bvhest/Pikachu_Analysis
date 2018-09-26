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
			<xsl:if test="string-length($idreal) &gt; 3">
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query name="category">
             SELECT DISTINCT oc.object_id ID, c.*, raw_.*, enriched.*
               FROM object_categorization oc 
         INNER JOIN categorization c 
                 ON c.subcategorycode = oc.subcategory
    LEFT OUTER JOIN (SELECT object_id, status rawstatus, masterlastmodified_ts rawmlm, lastmodified_ts rawlm
                       FROM octl
                      WHERE content_type = 'PMT_Raw'
                        AND localisation = 'none') raw_ 
                 ON raw_.object_id = oc.object_id
    LEFT OUTER JOIN (SELECT object_id, status enrichedstatus, masterlastmodified_ts enrichedmlm, lastmodified_ts enrichedlm
                       FROM octl
                      WHERE content_type = 'PMT_Enriched'
                        AND localisation = 'master_global') enriched 
                 ON enriched.object_id = oc.object_id
              WHERE oc.object_id = '<xsl:value-of select="$idreal"/>'
                AND oc.deleted   = 0
           ORDER BY c.subcategoryname
          </sql:query>
				</sql:execute-query>
				<!-- -->
				<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
					<sql:query name="catalogs">
select distinct cc.ctn, cc.country, cc.customer_id as catalog_type, to_char(cc.sop, 'YYYY-MM-DD') as SOP, to_char(cc.eop, 'YYYY-MM-DD') as EOP, cc.priority, cc.local_going_price, cc.division, cc.lastmodified, cc.deleted, ll.locale, ll.language,  to_char(cc.delete_after_date, 'YYYY-MM-DD') dad
from customer_catalog cc
left join locale_language ll on ll.country=cc.country
where
	cc.ctn = '<xsl:value-of select="$idreal"/>'
order by cc.ctn, cc.country, cc.customer_id
		</sql:query>
				</sql:execute-query>
			</xsl:if>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template match="h:node()">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
