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
      <xsl:variable name="v_catalogs" select="string-join(for $cat in RESULT/ROW/catalog return concat($apos,replace($cat,'LP_([A-Z]+)_FAMILY', '$1'),$apos), ',')" />
      <xsl:variable name="v_locales" select="string-join(for $loc in RESULT/ROW/localisation return concat($apos,$loc,$apos), ',')" />

		<RESULTSET>
         <xsl:apply-templates select="@*|node()"/>
         <sql:execute-query>
            <sql:query name="prismaFamilyCount">  
SELECT 'LP_'+RTRIM(rt.channel_cd)+'_FAMILY'  AS catalog 
     , rclm.cmc_locale                       AS localisation
     , count (distinct rt.cmc_com_fam_cd)    AS prisma_count
  FROM rt_master_data rt
 INNER JOIN commercial_family cf
    ON  cf.com_fam_cd = rt.com_fam_cd 
 INNER JOIN rt_family_rich_text cfrt
    ON rt.publ_target_group_cd = cfrt.publ_target_group_cd 
   AND rt.locale = cfrt.locale 
   AND cf.com_fam_cd = cfrt.com_fam_cd 
   AND cf.brand_cd = cfrt.brand_cd
 INNER JOIN rt_cmc_locale_mapping rclm
    ON rclm.prisma_locale = rt.locale
 WHERE cf.cfa_stat  IN ('INTREL','EXTREL') 
   AND rt.channel_cd   in (<xsl:value-of select="$v_catalogs"/>)
   AND rclm.cmc_locale  in (<xsl:value-of select="$v_locales"/>)
 GROUP BY rclm.cmc_locale,rt.channel_cd
 ORDER BY rclm.cmc_locale,rt.channel_cd
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
