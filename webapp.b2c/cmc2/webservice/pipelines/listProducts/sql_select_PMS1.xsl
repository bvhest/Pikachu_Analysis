<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                >

  <xsl:import href="../em-functions.xsl"/>

  <xsl:param name="userID" select="''"/>
  <xsl:param name="ctnRestriction" select="''"/>

  <xsl:template match="/root">
    <root>
      <products>    
        <xsl:variable name="ctns" select="replace($ctnRestriction, 
                                                  ',', 
                                                  concat($apos, ',', $apos)
                                          )"/>
        <sql:execute-query>
          <sql:query>
            select   
                 p.ctn, p.marketingclass, decode(p.marketingclass,'MCI',0,'Key',1,'Other',2,'Accessory',4, 5) sortmcl, p.namingstringshort, p.owner, p.pmtversion, p.lastmodified_ts,
                 p.thumbnailurl, p.previewurl, p.sap_date, p.edcopy_date, p.signing_date, p.cr_date, p.master_date, p.launch_date, p.mediumimageurl,
                 a.columnid, a.description_on_error, a.rank, a.publication_status, a.sort_order,
                 c.gcs_category_code, c.gcs_category_name, c.gcs_level

          from pms_products p
                
          inner join mv_pms_alerts_iot a
          on p.ctn = a.ctn
                
          left join pms_categories c 
          on p.ctn = c.ctn
          and c.gcs_level = 'SU'

          where p.ctn in
          (
            select * from table (
                cast(
                     pms_empowerme.pms_fun_get_ctn(
                     NULL,
                     'PUR',
                     NULL,
                     NULL,
                     NULL,
                     <xsl:choose>
                       <xsl:when test="$ctnRestriction != ''">
                         '<xsl:value-of select="$ctnRestriction"/>',
                       </xsl:when>
                       <xsl:otherwise>NULL,</xsl:otherwise>
                     </xsl:choose>
                     
                     'p.ctn asc',
                     1,
                     61
                     )                       
                as pms_type_char_row_table)
            )
          )
          </sql:query>
        </sql:execute-query>        
	  </products>
    </root>
  </xsl:template>
</xsl:stylesheet>
