<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:param name="locale"/>
	<!-- -->
	<xsl:template match="/">
		<ancillary>
			<sql:execute-query>
				<sql:query>
    SELECT co.country
         , co.customer_id
         , co.object_id, ctgctl.localisation
         , CASE
              WHEN co.eop &lt; SYSDATE
               OR co.sop > (SYSDATE + 3)
               OR co.deleted = 1
               OR pmt_enriched.status = 'Deleted'
                 THEN 'inactive'
              ELSE 'active'
           END activity
         , ts.status translation_status
         , to_char (co.sop, 'dd-Mon-yy') sop
         , to_char (co.eop, 'dd-Mon-yy') eop
         , pmt_enriched.marketingversion mv_enriched
         , pmt_enriched.status status_enriched
         , pmt.marketingversion mv_pmt
         , pmt.status status_pmt
         , pmt.islocalized
         , to_char(pmt.lastmodified_ts, 'dd-Mon-yy') lastmodified
         , filter_keys.status status_fk
         , c.bgroupname bu
         , c.groupname bg
         , c.categoryname mag
         , c.subcategoryname ag
      FROM categorization c 
INNER JOIN vw_object_categorization oc 
        ON oc.subcategory            = c.subcategorycode
INNER JOIN catalog_objects co
        ON co.object_id              = oc.object_id   
INNER JOIN catalog_ctl ctgctl
        ON ctgctl.catalog_id         = co.catalog_id
INNER JOIN locale_language ll
        ON ll.country                = co.country
INNER JOIN octl pmt
        ON pmt.localisation          = ctgctl.localisation
       AND pmt.object_id             = co.object_id
INNER JOIN octl pmt_enriched
        ON pmt_enriched.object_id    = co.object_id
LEFT OUTER JOIN octl filter_keys
        ON filter_keys.object_id     = co.object_id
INNER JOIN translation_status ts
        ON ts.object_id              = co.object_id
       AND ts.locale                 = ctgctl.localisation
     WHERE c.catalogcode             = 'ProductTree'
       AND oc.catalogcode            = 'ProductTree'            
       AND co.customer_id            = 'CONSUMER'
       AND ctgctl.content_type       = 'PMT2SPOT'
       AND pmt.content_type          = 'PMT'
       AND pmt_enriched.content_type = 'PMT_Enriched'
       AND pmt_enriched.localisation = 'master_global'
       AND filter_keys.content_type  = 'WebSiteFiltering'
       AND filter_keys.localisation  = 'master_global'
       AND ll.locale                 = '<xsl:value-of select="$locale"/>'
  ORDER BY co.country, co.customer_id, co.object_id
        </sql:query>
			</sql:execute-query>
		</ancillary>
	</xsl:template>
</xsl:stylesheet>
