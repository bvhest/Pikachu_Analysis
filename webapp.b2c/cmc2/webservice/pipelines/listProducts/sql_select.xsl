<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
                >

  <xsl:import href="../em-functions.xsl"/>

  <xsl:param name="userID" select="''"/>
  <xsl:param name="authorizationRestriction" select="''"/>
  <xsl:param name="productCatRestriction" select="''"/>
  <xsl:param name="requiringAttentionRestriction" select="'PUR,0,100'"/>
  <xsl:param name="ctnRestriction" select="''"/>
  <xsl:param name="query" select="''"/>
  <xsl:param name="sortBy" select="'CTN|true'"/>
  <xsl:param name="recordFrom" select='1'/>
  <xsl:param name="maxResults" select='20'/>

  <xsl:variable name="recordTo" select="number($recordFrom) + number($maxResults)"/>
  <xsl:variable name="column" select="substring-before($sortBy, '|')"/>
  <xsl:variable name="order" select="substring-after($sortBy, '|')"/>
  <xsl:variable name="field" select="substring-before($requiringAttentionRestriction, ',')"/>
  <xsl:variable name="range" select="substring-after($requiringAttentionRestriction, ',')"/>
  <xsl:variable name="fromInc" select="substring-before($range, ',')"/>
  <xsl:variable name="toInc" select="substring-after($range, ',')"/>

  <xsl:template match="/root">
    <root>
      <products>    
        <xsl:variable name="ctns" select="replace($ctnRestriction, 
                                                  ',', 
                                                  concat($apos, ',', $apos)
                                          )"/>
        <xsl:variable name="query-norm" select="em:normalize-search-string($query)"/>

        <xsl:choose>
          <xsl:when test="normalize-space($query) = '' or $query-norm != ''">
            <xsl:variable name="query-text" select="if ($query-norm != '') then em:queryText('p.searchtext', $query-norm) else ''"/>
              
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
              <xsl:choose>
                <xsl:when test="$productCatRestriction = ''">
                and c.gcs_level = 'SU'
                </xsl:when>
                <xsl:otherwise>
                and c.gcs_category_code = '<xsl:value-of select="$productCatRestriction"/>'
                </xsl:otherwise>
              </xsl:choose>

              where p.ctn in
              (
                select * from table (
                    cast(
                         pms_empowerme.pms_fun_get_ctn(
                         <xsl:choose>
                           <xsl:when test="$query != ''">
                             '<xsl:value-of select="$query"/>',  
                           </xsl:when>
                           <xsl:otherwise>NULL,</xsl:otherwise>
                         </xsl:choose>
                         
                         '<xsl:value-of select="em:determineColumnId($column)"/>',
                         
                         <xsl:choose>
			               <xsl:when test="$productCatRestriction != ''">
			                 '<xsl:value-of select="$productCatRestriction"/>',
			               </xsl:when>
			               <xsl:otherwise>NULL,</xsl:otherwise>
                         </xsl:choose>
                         
                         <xsl:choose>
                           <xsl:when test="$fromInc = '1'"> 
                             '1, 2, 3, 4',
                           </xsl:when>
                           <xsl:when test="$fromInc = '26'"> 
                             '2, 3, 4',
                           </xsl:when>
                           <xsl:when test="$fromInc = '51'"> 
                             '3, 4',
                           </xsl:when>
                           <xsl:otherwise>NULL,</xsl:otherwise>
                         </xsl:choose>
                         
                         <xsl:choose>
                           <xsl:when test="$authorizationRestriction = 'I own'">
                             '<xsl:value-of select="upper-case($userID)"/>',
                           </xsl:when>
                           <xsl:otherwise>NULL,</xsl:otherwise>
                         </xsl:choose>  
                         
                         <xsl:choose>
                           <xsl:when test="$ctnRestriction != ''">
                             '<xsl:value-of select="$ctnRestriction"/>',
                           </xsl:when>
                           <xsl:otherwise>NULL,</xsl:otherwise>
                         </xsl:choose>
                         
                         '<xsl:value-of select="em:determineSort($column, $order)"/>',
                         
                         <xsl:value-of select="$recordFrom"/>,
                         
                         <xsl:value-of select="$recordTo"/>
                         )                       
                    as pms_type_char_row_table)
                )
              )
              </sql:query>
            </sql:execute-query>        
            <count>
              <sql:execute-query>
                <sql:query>
                    select numval as count from table (
                    cast(
                         pms_empowerme.pms_fun_get_ctn_count(
                         <xsl:choose>
                           <xsl:when test="$query != ''">
                             '<xsl:value-of select="$query"/>',  
                           </xsl:when>
                           <xsl:otherwise>NULL,</xsl:otherwise>
                         </xsl:choose>
                         
                         '<xsl:value-of select="em:determineColumnId($column)"/>',
                         
                         <xsl:choose>
                           <xsl:when test="$productCatRestriction != ''">
                             '<xsl:value-of select="$productCatRestriction"/>',
                           </xsl:when>
                           <xsl:otherwise>NULL,</xsl:otherwise>
                         </xsl:choose>
                         
                         <xsl:choose>
                           <xsl:when test="$fromInc = '1'"> 
                             '1, 2, 3, 4',
                           </xsl:when>
                           <xsl:when test="$fromInc = '26'"> 
                             '2, 3, 4',
                           </xsl:when>
                           <xsl:when test="$fromInc = '51'"> 
                             '3, 4',
                           </xsl:when>
                           <xsl:otherwise>NULL,</xsl:otherwise>
                         </xsl:choose>
                         
                         <xsl:choose>
                           <xsl:when test="$authorizationRestriction = 'I own'">
                             '<xsl:value-of select="upper-case($userID)"/>',
                           </xsl:when>
                           <xsl:otherwise>NULL,</xsl:otherwise>
                         </xsl:choose>  
                         
                         <xsl:choose>
                           <xsl:when test="$ctnRestriction != ''">
                             '<xsl:value-of select="$ctnRestriction"/>'
                           </xsl:when>
                           <xsl:otherwise>NULL</xsl:otherwise>
                         </xsl:choose>
                         )                       
                    as pms_type_num_row_table)
                )
                </sql:query>
              </sql:execute-query>
            </count>  
          </xsl:when>
          <xsl:otherwise>
            <Results>
              <xsl:text>Invalid search query. Please do not use only wildcards.</xsl:text>
            </Results>
          </xsl:otherwise>
        </xsl:choose>
	  </products>
    </root>
  </xsl:template>
</xsl:stylesheet>
