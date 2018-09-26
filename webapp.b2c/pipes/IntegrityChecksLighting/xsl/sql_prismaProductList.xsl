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
	<xsl:template match="RESULTSET">
      <xsl:variable name="v_catalogs" select="string-join(for $cat in RESULT/ROW/catalog return concat($apos,replace($cat,'LP_([A-Z]+)_ATG', '$1'),$apos), ',')" />
      <xsl:variable name="v_locales" select="string-join(for $loc in RESULT/ROW/localisation return concat($apos,$loc,$apos), ',')" />

		<RESULTSET>
         <xsl:apply-templates select="@*|node()"/>
         <sql:execute-query>
            <sql:query name="prismaProductCount">  
SELECT 'LP_'+RTRIM(rt.channel_cd)+'_ATG'  AS catalog 
     , rcm.cmc_locale                     AS localisation
     , count(1)                           AS prisma_count
  FROM rt_pmt_feed rt       
 INNER JOIN eoc_product eop      
    ON rt.eop_full_eoc = eop.eop_full_eoc      
 INNER JOIN tech_prod_10nc tpd      
    ON tpd.tpd_nc10 = eop.tpd_nc10      
 INNER JOIN industrial_family ifa      
    ON ifa.fam_cd = tpd.fam_cd      
 INNER JOIN prod_cat pca      
    ON ifa.pca_id = pca.pca_id          
 INNER JOIN com_fam_x_eoc cfe      
    ON rt.eop_full_eoc = cfe.eop_full_eoc 
  LEFT JOIN rt_family_rich_text cfrt
    ON rt.publ_target_group_cd = cfrt.publ_target_group_cd 
   AND rt.locale = cfrt.locale 
   AND cfrt.com_fam_cd = cfe.com_fam_cd 
   AND cfrt.brand_cd = cfe.brand_cd
 INNER JOIN rt_cmc_locale_mapping rcm
   ON rt.locale=rcm.prisma_locale
 WHERE cfe.cxe_prim_ind = 'Y' 
   AND rt.channel_cd   in (<xsl:value-of select="$v_catalogs"/>)
   AND rcm.cmc_locale  in (<xsl:value-of select="$v_locales"/>)
 GROUP BY rt.channel_cd, rcm.cmc_locale
 ORDER BY rt.channel_cd, rcm.cmc_locale
            </sql:query>
         </sql:execute-query>
		</RESULTSET>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset">
		<RESULT>
         <xsl:attribute name="name" select="@name" />
			<xsl:apply-templates select="@*|node()"/>
		</RESULT>
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
	<xsl:template match="sql:atg_count">
		<atg_count>
			<xsl:value-of select="."/>
		</atg_count>
	</xsl:template>
</xsl:stylesheet>
