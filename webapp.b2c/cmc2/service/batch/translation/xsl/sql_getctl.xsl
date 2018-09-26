<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="ct"/>
	<xsl:param name="isdirect"/>
	<!-- $runcatalogexport will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->  
	<xsl:param name="runcatalogexport"/>
	<xsl:param name="phase2"/>      
	<xsl:param name="workflow"/>        
	<xsl:param name="runmode"/>
	<!-- -->
	<xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
	<xsl:variable name="v_needsprocessing" select="if($runcatalogexport = 'yes') then '(2)' 
                                                 else if($phase2 = 'yes') then '(3)' 
                                                 else if($workflow = 'CL_CMC') then '(1,4)' 
                                                 else '(1)'"/>

	<!-- -->
	<xsl:template match="/">
		<root>
			<!-- if the seo-attribute is true, this info must be passed along to be included in the translation request to SDL. -->
			<xsl:if test="/root/root/@seo='yes'">
				<xsl:attribute name="seo">yes</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="'yes'!=$runcatalogexport ">
					<!-- only perform a reset when not executing a catalogexport -->
					<sql:execute-query>
						<sql:query name="reset octl_control">
               -- reset intransaction_flag, batch_number!
               -- after this, the query in sql_selectbatches can be simple.
               update octl_control
                  set intransaction_flag = 0
                    , batch_number       = null
                where modus             = '<xsl:value-of select="$modus"/>'
                  and content_type      = '<xsl:value-of select="$ct"/>'
                  --and batch_number is not null
						</sql:query>
					</sql:execute-query>
				</xsl:when> 
			</xsl:choose>	
			<sql:execute-query name="sql_getctl">
				<sql:query name="sql_getctl">
					<xsl:choose>
						<xsl:when test="$ct = 'PMT_Translated'">
           SELECT DISTINCT '<xsl:value-of select="$ct"/>' as content_type
                , languagecode   as locale
                , c.categorycode as internal_category
             FROM language_translations lt 
            INNER JOIN locale_language ll 
               ON ll.locale         = lt.locale
            INNER JOIN octl_control ocl
               on ocl.localisation  = ll.locale
            INNER JOIN mv_co_object_id mvco 
               on mvco.object_id    = ocl.object_id
              and mvco.deleted      = 0
              and mvco.eop       &gt; trunc(sysdate)
            INNER JOIN vw_object_categorization oc 
               ON oc.object_id      = ocl.object_id 
              AND oc.catalogcode    = 'MASTER'
            INNER JOIN categorization c 
               ON c.subcategorycode = oc.subcategory
              AND c.catalogcode     = oc.catalogcode
            WHERE ocl.modus         = '<xsl:value-of select="$modus"/>'
              AND ocl.content_type  = '<xsl:value-of select="$ct"/>'                                
              AND ocl.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
							<!-- Look at internal categories only -->
              AND c.categorycode   IS NOT NULL
              AND lt.enabled        = 1                
              AND lt.isdirect       = '<xsl:value-of select="$isdirect"/>'          
						</xsl:when>
						<xsl:when test="$ct = 'RangeText_Translated'">
           SELECT DISTINCT '<xsl:value-of select="$ct"/>' as content_type
                , languagecode AS locale
                , 'RANGETEXT' AS internal_category
             FROM language_translations lt 
            INNER JOIN locale_language ll 
               ON lt.locale = ll.locale
            INNER JOIN octl o 
               ON ll.locale = o.localisation
            inner join octl_control oc
               on oc.content_type  = o.content_type
              and oc.localisation  = o.localisation
              and oc.object_id     = o.object_id
              and oc.modus         = '<xsl:value-of select="$modus"/>'
           WHERE o.content_type    = '<xsl:value-of select="$ct"/>'                                
             AND oc.needsprocessing_flag = 1
							<!--  Use of SOP to determine export disabled until confirmation received that LCB is no longer sending SOPs way into the future for packaging products
                       and startofprocessing &lt;= trunc(sysdate)
           -->
             AND o.endofprocessing &gt;= trunc(sysdate)
             AND o.active_flag     = 1
             AND lt.enabled        = 1                
             AND lt.isdirect       = '<xsl:value-of select="$isdirect"/>'          
							<!--  RangeText Translations may not be exported for ko_KR. Because no one can tell me 
                 if this is configurable or not, this hard coded solution was implemented...
                 (BHE, 23/3/2010, based on SD0075218/IM0050017)
           -->
             <!--AND lt.locale        != 'ko_KR'  adding ko_KR to the RangeText export based on SD6243570.  310085328 - 29/09/2014 -->
						</xsl:when>
					</xsl:choose>
				</sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
