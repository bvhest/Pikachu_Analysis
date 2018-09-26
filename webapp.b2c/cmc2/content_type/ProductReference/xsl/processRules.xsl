<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="node()[@type='Subcat']">
		<xsl:copy>
		<xsl:apply-templates select="@*"/>
					<sql:execute-query>
						<sql:query>
select distinct oc.object_id
  from categorization c
 inner join vw_object_categorization oc 
    on oc.subcategory    = c.subcategorycode 
   and oc.catalogcode    = 'MASTER'
 inner join octl o 
    on o.content_type    = 'PMT_Enriched' 
   and o.localisation    = 'master_global' 
   and o.object_id       =  oc.object_id
 inner join mv_co_object_id co 
    on co.object_id      = oc.object_id
 where c.subcategoryname = '<xsl:value-of select="id"/>'
   and co.eop        &gt;= trunc(sysdate)
   and co.deleted        = 0
							</sql:query>
					</sql:execute-query>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="node()[@type='Alphanumeric']">
		<xsl:copy>
		<xsl:apply-templates select="@*"/>
			<xsl:variable name="object_id">
				<xsl:choose>
					<xsl:when test="contains(id,'/')"><xsl:value-of select="replace(id,'\?','_')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="replace(id,'\?','_')"/>/%</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
         <sql:execute-query>
            <sql:query>
select o.object_id 
  from OCTL o 
 inner join mv_co_object_id co 
    on co.object_id      = o.object_id
 where o.content_type   = 'PMT_Enriched' 
   and o.localisation   = 'master_global' 
   and o.object_id   like '<xsl:value-of select="$object_id"/>'
   and co.eop        &gt;= trunc(sysdate)
   and co.deleted        = 0
            </sql:query>
         </sql:execute-query>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node()[@type='AG']">
		<xsl:copy>
		<xsl:apply-templates select="@*"/>
					<sql:execute-query>
						<sql:query>
select distinct oc.object_id
  from categorization c
 inner join vw_Object_Categorization oc 
    on oc.subcategory    = c.subcategorycode 
   and oc.catalogcode    = 'MASTER'
 inner join octl o 
    on o.content_type    = 'PMT_Enriched' 
   and o.localisation    = 'master_global' 
   and o.object_id       =  oc.object_id
 inner join mv_co_object_id co 
    on co.object_id      = oc.object_id
 where c.subcategoryname = '<xsl:value-of select="id"/>'
   and co.eop        &gt;= trunc(sysdate)
   and co.deleted        = 0
							</sql:query>
					</sql:execute-query>
		</xsl:copy>
	</xsl:template>	
	
</xsl:stylesheet>
