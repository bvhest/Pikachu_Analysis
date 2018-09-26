<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:em="http://pww.cmc.philips.com/CMCService2/functions/1.0"
    xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
    >

  <xsl:variable name="apos">'</xsl:variable>
  <xsl:variable name="quot">"</xsl:variable>
  <xsl:param name="MCI">Best</xsl:param>
  <xsl:param name="Key">Better</xsl:param>  
  <xsl:param name="Regular">Good</xsl:param> 
  <xsl:param name="Accessory">Accessory</xsl:param> 
  <xsl:variable name="configfile" select="document('./xml/xUCDM_EMP_config v3.6.xml')"/>

  <xsl:variable name="none-description" select="'No content is required for this asset category'"/>

  <!-- formats CRDate values: YYYY-MM-DD, default = 1900-01-01 -->
  <xsl:function name="em:formatCRDate" as="xs:date">
    <xsl:param name="crdate"/>
    
    <xsl:value-of select="if ($crdate and (string-length($crdate) >= 10))
                          then (substring($crdate, 1, 10))
                          else ('1900-01-01')"/>
  </xsl:function>

  <!-- formats dateTime values : YYYY-MM-DDThh:mm:ss-->
  <xsl:function name="em:formatDate" as="xs:string">
    <xsl:param name="dateTime"/>
    
    <xsl:choose>
      <xsl:when test="string-length(string($dateTime))">
        <xsl:value-of select="substring(string(replace(string($dateTime), ' ','T')), 1, 19)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'1900-01-01T00:00:00'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="em:formatPMTVersion" as="xs:string">
    <xsl:param name="version"/>
    <xsl:param name="date"/>
    
    <xsl:value-of select="concat($version, ' (', em:getMonth(substring($date, 6, 2)), ' ', substring($date, 9, 2), ')')"/>
  </xsl:function>

  <xsl:function name="em:getMonth" as="xs:string">
    <xsl:param name="month"/>
  
    <xsl:choose>
      <xsl:when test="$month = '01'"> 
        <xsl:value-of select="'Jan'"/>
      </xsl:when>
      <xsl:when test="$month = '02'"> 
        <xsl:value-of select="'Feb'"/>
      </xsl:when>
      <xsl:when test="$month = '03'"> 
        <xsl:value-of select="'Mar'"/>
      </xsl:when>
      <xsl:when test="$month = '04'"> 
        <xsl:value-of select="'Apr'"/>
      </xsl:when>
      <xsl:when test="$month = '05'"> 
        <xsl:value-of select="'May'"/>
      </xsl:when>
      <xsl:when test="$month = '06'"> 
        <xsl:value-of select="'Jun'"/>
      </xsl:when>
      <xsl:when test="$month = '07'"> 
        <xsl:value-of select="'Jul'"/>
      </xsl:when>
      <xsl:when test="$month = '08'"> 
        <xsl:value-of select="'Aug'"/>
      </xsl:when>
      <xsl:when test="$month = '09'"> 
        <xsl:value-of select="'Sep'"/>
      </xsl:when>
      <xsl:when test="$month = '10'"> 
        <xsl:value-of select="'Oct'"/>
      </xsl:when>
      <xsl:when test="$month = '11'"> 
        <xsl:value-of select="'Nov'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'Dec'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- determines whether a product is live based on provided sop and eop -->
  <xsl:function name="em:isLive" as="xs:boolean">
    <xsl:param name="sop"/>
    <xsl:param name="eop"/>
    
    <xsl:variable name="formatted-sop" select="em:formatDate($sop)"/>
    <xsl:variable name="formatted-eop" select="em:formatDate($eop)"/>
    <xsl:variable name="formatted-now" select="em:formatDate(current-dateTime())"/>
    
    <xsl:value-of select="(($formatted-now >= $formatted-sop) and ($formatted-now &lt;= $formatted-eop))"/>   
  </xsl:function>
  

  <!-- Calculate Urgency value based on rank:
              -1 = None
               0 = Green
         1 -  25 = Grey
        26 -  50 = Orange
        51 - 100 = Red
   -->
  <xsl:function name="em:determineUrgency" as="xs:string">
    <xsl:param name="rank"/>
    
    <xsl:choose>
      <xsl:when test="$rank > 50">
        <xsl:value-of select="'Red'"/>
      </xsl:when>
      <xsl:when test="$rank > 25">
        <xsl:value-of select="'Orange'"/>
      </xsl:when>
      <xsl:when test="$rank > 0">
        <xsl:value-of select="'Grey'"/>
      </xsl:when>
      <xsl:when test="$rank = 0">
        <xsl:value-of select="'Green'"/>
      </xsl:when>
      <xsl:when test="$rank = -1">
        <xsl:value-of select="'None'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'Red'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- formats Urgency values: first char uppercase, remainder all lowercase -->
  <xsl:function name="em:formatUrgency" as="xs:string">
    <xsl:param name="urgency"/>
    
    <xsl:value-of select="concat(upper-case(substring($urgency, 1, 1)), lower-case(substring($urgency, 2)))"/>
  </xsl:function>
  
  <!-- formats MarketingClass values: first char uppercase, remainder all lowercase -->
  <xsl:function name="em:formatMarketingClass" as="xs:string">
    <xsl:param name="marketingclass"/>
    
    <xsl:choose>
      <xsl:when test="$marketingclass = 'MCI'">
        <xsl:text><xsl:value-of select="$MCI"/></xsl:text>
      </xsl:when>
      <xsl:when test="$marketingclass = 'Key'">        
        <xsl:text><xsl:value-of select="$Key"/></xsl:text>
      </xsl:when>
      <xsl:when test="$marketingclass = 'Regular'">
        <xsl:text><xsl:value-of select="$Regular"/></xsl:text>
      </xsl:when>
      <xsl:when test="$marketingclass = 'Accessory'">
        <xsl:text><xsl:value-of select="$Accessory"/></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(upper-case(substring($marketingclass, 1, 1)), lower-case(substring($marketingclass, 2)))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- determines the pms_alerts.columnid value to use in the query -->
  <xsl:function name="em:determineColumnId" as="xs:string">
    <xsl:param name="columnid"/>
    
    <xsl:choose>
      <xsl:when test="$configfile/Config/Views/Content/Column[@type = 'master'][@id = $columnid]">
        <xsl:value-of select="'PUR'"/>
      </xsl:when>
      <xsl:when test="$columnid = ''">
        <xsl:value-of select="'PUR'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$columnid"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
  <!-- determines the order clause to use in the query -->
  <xsl:function name="em:determineSortColumn" as="xs:string">
    <xsl:param name="columnid"/>
    
    <!-- translate columnid into column -->
    <xsl:choose>
      <xsl:when test="$configfile/Config/Views/Content/Column[@type = 'master'][@id = $columnid]">
        <xsl:choose>
          <xsl:when test="$columnid = 'CRD'">
            <xsl:value-of select="concat('p.', em:determineColumn($columnid))"/>
          </xsl:when>
          <xsl:when test="$columnid = 'MCL'">
            <xsl:value-of select="concat('p.', em:determineColumn($columnid), 
            ', decode(p.marketingclass,', $apos, 'MCI', $apos, ',0,', $apos, 'Key', $apos, ',1,', $apos, 'Other', $apos, ',2,', $apos, 'Accessory', $apos, ',4, 5)', ' sortmcl')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('upper(p.', em:determineColumn($columnid), ') ')"/>
          </xsl:otherwise>
        </xsl:choose>  
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'a.rank'"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:function>

  <!-- -->
  <xsl:function name="em:determineSort" as="xs:string">
    <xsl:param name="columnid"/>
    <xsl:param name="order"/>
    
    <xsl:variable name="sort-order" select="if ($order = 'true') then ('asc nulls first') else ('desc nulls last')"/>
    <xsl:variable name="second-sort-order" select="if ($order = 'true') then ('asc') else ('desc')"/>
    
    <!-- translate columnid into column -->
    <xsl:choose>
      <xsl:when test="$configfile/Config/Views/Content/Column[@type = 'master'][@id = $columnid]">
        <xsl:choose>
          <xsl:when test="$columnid = 'CTN'">
            <xsl:value-of select="concat('p.ctn ', $sort-order)"/>
          </xsl:when>
          <xsl:when test="$columnid = 'CRD'">
            <xsl:value-of select="concat('p.', em:determineColumn($columnid), ' ', $sort-order, ', p.ctn ', $second-sort-order)"/>
          </xsl:when>
          <xsl:when test="$columnid = 'MCL'">
            <xsl:value-of select="concat('sortmcl ', $sort-order, ', p.ctn ', $second-sort-order)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('upper(p.', em:determineColumn($columnid), ') ', $sort-order, ', p.ctn ', $second-sort-order)"/>
          </xsl:otherwise>
        </xsl:choose>  
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('a.rank', ' ', $sort-order, ', a.ctn ', $second-sort-order)"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  <!-- -->
  <xsl:function name="em:determineColumn" as="xs:string">
    <xsl:param name="columnid"/>

    <xsl:choose>
      <xsl:when test="$columnid = 'CTN'">
        <xsl:value-of select="'ctn'"/>
      </xsl:when>
      <xsl:when test="$columnid = 'SNS'">
        <xsl:value-of select="'namingstringshort'"/>
      </xsl:when>
      <xsl:when test="$columnid = 'CRD'">
        <xsl:value-of select="'cr_date'"/>
      </xsl:when>
      <xsl:when test="$columnid = 'THN'">
        <xsl:value-of select="'thumbnailurl'"/>
      </xsl:when>
      <xsl:when test="$columnid = 'MCL'">
        <xsl:value-of select="'marketingclass'"/>
      </xsl:when>
      <xsl:when test="$columnid = 'POW'">
        <xsl:value-of select="'owner'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'rank'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--
    Normalize a search string.
    
    Remove leading/trailing spaces.
    Convert multiple spaces into one space.
    If there is only one search term without wild cards an asterisk is appended to it.
    If the search terms consist of only wildcards it is converted to an empty string.
  -->
  <xsl:function name="em:normalize-search-string">
    <xsl:param name="query"/>
    <xsl:variable name="clean-query" select="translate(normalize-space($query),'*?','%_')"/>
    <xsl:variable name="result-string">
      <xsl:choose>
        <!-- Single search term without wildcards or supported operators -->
        <xsl:when test="$clean-query != '' and not(matches($clean-query,' (AND|OR|NOT|NEAR|MINUS) |([%_|&amp;~;-])'))">
          <xsl:value-of select="concat('%', $clean-query, '%')"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Check for useless search terms that use wildcards only -->
          <xsl:variable name="search-terms" select="tokenize($clean-query,' (AND|OR|NOT|NEAR|MINUS) ')"/>
          <xsl:variable name="valid-terms" select="for $t in $search-terms return
                                                    if (not($t='%' or $t='_')) then
                                                      1
                                                    else
                                                      0
                                                    "/>
          <xsl:if test="not($valid-terms = 0)">
            <xsl:value-of select="$clean-query"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:value-of select="replace($result-string, '&quot;', '')" />
  </xsl:function>
  
  <!--
    Convert a searh string to an Oracle text search clause.
        
    Example output: CONTAINS(searchtext, 'Pixel Plus', 1) > 0
  -->
  <xsl:function name="em:queryText" as="xs:string">
    <xsl:param name="column"/>
    <xsl:param name="query"/>    
    <xsl:value-of select="concat('CONTAINS('
                                , $column
                                , ',' 
                                , $apos
                                , replace($query,$apos,concat($apos,$apos))
                                , $apos
                                , ', 1) > 0')"/>
  </xsl:function>
  
  <xsl:function name="em:getVersion" as="xs:string">
    <xsl:param name="schema"/>
    
    <xsl:choose>
      <xsl:when test="$schema = 'PMS2'"> 
        <xsl:text>v2.1</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>v9.1</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="em:getSchema" as="xs:string">
    <xsl:param name="schema"/>
    
    <xsl:choose>
      <xsl:when test="$schema = 'PMS2'"> 
        <xsl:text>xUCDM_EMP_iPad v2.1 WIP.xsd</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>xUCDM_product_marketing_status_EMP v9.1.xsd</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- determines the short version description for aggregated items (PHO, VID, TXT, SUP and PCY) -->
  <xsl:function name="em:determineDescription" as="xs:string">
    <xsl:param name="category"/>
    <xsl:param name="rank"/>
    <xsl:param name="publication-status"/>
    
    <xsl:choose>
      <xsl:when test="$category = 'PHO'"> 
        <xsl:choose>
          <xsl:when test="$rank > 50">
	        <xsl:value-of select="'Photos missing, late'"/>
	      </xsl:when>
	      <xsl:when test="$rank > 25">
	        <xsl:value-of select="'Photos missing, almost late'"/>
	      </xsl:when>
	      <xsl:when test="$rank > 0">
	        <xsl:value-of select="'Photos missing'"/>
	      </xsl:when>
	      <xsl:when test="$rank = 0">
	        <xsl:value-of select="'Photos complete'"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="$none-description"/>
	      </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$category = 'VID'"> 
        <xsl:choose>
          <xsl:when test="$rank > 50">
            <xsl:value-of select="'Videos missing, late'"/>
          </xsl:when>
          <xsl:when test="$rank > 25">
            <xsl:value-of select="'Videos missing, almost late'"/>
          </xsl:when>
          <xsl:when test="$rank > 0">
            <xsl:value-of select="'Videos missing'"/>
          </xsl:when>
          <xsl:when test="$rank = 0">
            <xsl:value-of select="'Videos complete'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$none-description"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$category = 'TXT'"> 
        <xsl:choose>
          <xsl:when test="$rank > 50">
            <xsl:value-of select="'Text missing, late'"/>
          </xsl:when>
          <xsl:when test="$rank > 25">
            <xsl:value-of select="'Text missing, almost late'"/>
          </xsl:when>
          <xsl:when test="$rank > 0">
            <xsl:value-of select="'Text missing'"/>
          </xsl:when>
          <xsl:when test="$rank = 0">
            <xsl:value-of select="'Text complete'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$none-description"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$category = 'SUP'"> 
        <xsl:choose>
          <xsl:when test="$rank > 50">
            <xsl:value-of select="'Manuals missing, late'"/>
          </xsl:when>
          <xsl:when test="$rank > 25">
            <xsl:value-of select="'Manuals missing, almost late'"/>
          </xsl:when>
          <xsl:when test="$rank > 0">
            <xsl:value-of select="'Manuals missing'"/>
          </xsl:when>
          <xsl:when test="$rank = 0">
            <xsl:value-of select="'Manuals complete'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$none-description"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$category = 'PCY'"> 
        <xsl:choose>
          <xsl:when test="$rank > 50">
            <!-- PublicationStatus
               51 and Planned -> Planned to go live in the future, late
             -->
            <xsl:choose>
              <xsl:when test="$publication-status = 'Planned'">
                <xsl:value-of select="'Planned to go live in the future, late'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'Not live in all countries, late'"/>
              </xsl:otherwise>
            </xsl:choose>  
          </xsl:when>
          <xsl:when test="$rank > 25">
            <!-- PublicationStatus
               26 and Planned -> Planned to go live in the future, almost late
             -->
            <xsl:choose>
              <xsl:when test="$publication-status = 'Planned'">
                <xsl:value-of select="'Planned to go live in the future, almost late'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'Not live in all countries, almost late'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$rank > 0">
            <xsl:value-of select="'Not live in all countries'"/>
          </xsl:when>
          <xsl:when test="$rank = 0">
            <!-- PublicationStatus
               0 and Deleted -> Deleted in all countries
               0 and History -> Products published in the past in all countries (not live anymore)
               0 and Live    -> Live in all countries
               0 and Planned -> Planned to go live in the future
               0 and None    -> No text, icon disappears
             -->
             <xsl:choose>
               <xsl:when test="$publication-status = 'Deleted'">
                 <xsl:value-of select="'Deleted in all countries'"/> 
               </xsl:when>
               <xsl:when test="$publication-status = 'History'">
                 <xsl:value-of select="'Products published in the past in all countries (not live anymore)'"/> 
               </xsl:when>
               <xsl:when test="$publication-status = 'Live'">
                 <xsl:value-of select="'Live in all countries'"/> 
               </xsl:when>
               <xsl:when test="$publication-status = 'Planned'">
                 <xsl:value-of select="'Planned to go live in the future'"/> 
               </xsl:when>
               <xsl:otherwise>
                 <xsl:value-of select="''"/>
               </xsl:otherwise>
             </xsl:choose>            
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  <xsl:function name="em:determineProductDescription" as="xs:string">
    <xsl:param name="rank"/>

    <xsl:choose>
      <xsl:when test="$rank > 50">
        <xsl:value-of select="'Content missing, late'"/>
      </xsl:when>
      <xsl:when test="$rank > 25">
        <xsl:value-of select="'Content missing, almost late'"/>
      </xsl:when>
      <xsl:when test="$rank > 0">
        <xsl:value-of select="'Content missing'"/>
      </xsl:when>
      <xsl:when test="$rank = 0">
        <xsl:value-of select="'Content complete'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$none-description"/>
      </xsl:otherwise>
   </xsl:choose>    
  </xsl:function>

  <xsl:function name="em:getRelativeImageURL" as="xs:string">
    <xsl:param name="url"/>
    <xsl:param name="prefix"/>
    
    <xsl:value-of select="if ($url != '') then (concat($prefix, '/mprdata', substring-after($url, '/mprdata'))) else ('')"/>
  </xsl:function>
</xsl:stylesheet>
