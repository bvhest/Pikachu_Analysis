<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >

  <xsl:param name="userID" />
  <xsl:param name="ctn" />

  <xsl:variable name="apos">'</xsl:variable>

  <xsl:variable name="ctns" select="replace($ctn, 
                                               ',', 
                                               concat($apos, ',', $apos)
                                       )"/>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="products">
    <xsl:copy copy-namespaces="no">
      <sql:execute-query>
            <sql:query>
              select p.ctn, p.marketingclass, p.namingstringshort, p.owner, p.pmtversion, p.lastmodified_ts,
                     p.thumbnailurl, p.previewurl, p.sap_date, p.edcopy_date, p.signing_date, p.cr_date, p.master_date, p.launch_date, p.mediumimageurl,
                     a.columnid, a.description_on_error, a.rank, a.complete_flag, a.deleted_flag, a.publication_status,
                     c.gcs_category_code, c.gcs_category_name, c.gcs_level
                from pms_products p
                left join pms_categories c
                on p.ctn = c.ctn
                and c.gcs_level = 'SU'
                inner join pms_alerts a
                on p.ctn = a.ctn
                where p.ctn in ('<xsl:value-of select="$ctns"/>')
            </sql:query>
          </sql:execute-query>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="octl">
    <xsl:copy copy-namespaces="no">
      <sql:execute-query>
            <sql:query>
               select * from octl
                where object_id in ('<xsl:value-of select="$ctns"/>')
                and content_type='PMS'
                and localisation = 'none'           </sql:query>
          </sql:execute-query>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
