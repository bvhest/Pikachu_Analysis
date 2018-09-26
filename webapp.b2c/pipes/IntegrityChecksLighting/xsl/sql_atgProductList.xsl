<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
	<!-- -->
   <xsl:variable name="apos">&apos;</xsl:variable>
	<!-- -->
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset">
      <xsl:variable name="v_catalogs" select="string-join(for $cat in sql:row/sql:catalog return concat($apos,$cat,$apos), ',')" />
      <xsl:variable name="v_locales" select="string-join(for $loc in sql:row/sql:localisation return concat($apos,$loc,$apos), ',')" />
		<RESULTSET>
         <RESULT name="pikachu">
            <xsl:apply-templates select="@*|node()"/>
         </RESULT>
            <sql:execute-query>
               <sql:query name="atgProductCount">  
SELECT cat.catalog_type as catalog
     , pcl.locale_id as localisation
     , count(*) atg_count
  FROM ph_catalog_locale pcl
     , ph_product_trs pptrs
     , ph_product_tr pptr
     , ph_product pp
     , mv_pmtprof_documents mpd
     , dcs_product dp
     , ph_catalog cat
 WHERE pcl.catalog_locale_id = pptrs.catalog_locale_id
   AND pptrs.product_translation_id = pptr.product_translation_id
   AND pptrs.product_id = pp.product_id
   AND pp.ctn = mpd.ctn
   AND pcl.locale_id = mpd.locale_id
   AND pp.product_id = dp.product_id
   and cat.catalog_id = pcl.catalog_ID
   AND pp.deleted = 0
   AND cat.catalog_type IN (<xsl:value-of select="$v_catalogs"/>)
   AND pcl.locale_id    IN (<xsl:value-of select="$v_locales"/>)
 GROUP BY cat.catalog_type, pcl.locale_id
 ORDER BY cat.catalog_type, pcl.locale_id
               </sql:query>
            </sql:execute-query>
		</RESULTSET>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:row">
		<ROW>
			<xsl:apply-templates select="@*|node()"/>
		</ROW>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:catalog">
		<catalog>
			<xsl:value-of select="."/>
		</catalog>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:localisation">
		<localisation>
			<xsl:value-of select="."/>
		</localisation>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:pmt_count">
		<pmt_count>
			<xsl:value-of select="."/>
		</pmt_count>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:catalog_count">
		<catalog_count>
			<xsl:value-of select="."/>
		</catalog_count>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
