<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet   version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">
   <!-- -->
   <xsl:param name="ctn" select="''"/>
   <xsl:param name="locale" select="''"/>
   <xsl:param name="eop" select="''"/>
   <xsl:param name="sop" select="''"/>
   <xsl:param name="group" select="''"/>
   <xsl:param name="category" select="''"/>
   <xsl:param name="subcat" select="''"/>
   <!-- -->
   <xsl:template match="/root">
         <sql:execute-query name="getActiveProductPerLocale">
            <sql:query>
      select c.groupcode as "group"
           , c.categorycode as category
           , oc.subcategory
           , co.object_id as ctn
           , tr.localisation
           , to_char(co.sop, 'yyyymmdd') as sop
           , to_char(co.eop, 'yyyymmdd') as eop
           , tr.lastmodified_ts
        from mv_co_object_id_country co
  inner join octl tr
          on tr.object_id                 = co.object_id
         and substr(tr.localisation,4,2)  = co.country
  inner join vw_object_categorization oc
          on oc.catalogcode   = 'MASTER'
         and oc.object_id     = co.object_id
  inner join categorization c
          on c.catalogcode    = oc.catalogcode
         and c.subcategorycode= oc.subcategory
       where tr.content_type  = 'PMT_Translated'
         --and tr.status       in ('Final Published', 'CL_QUERY received: OK')
         and tr.data IS NOT NULL
         and co.country      in (select distinct ll.country_code 
                                   from locale_language ll
                             inner join language_translations lt
                                     on lt.locale  = ll.locale
                                  where lt.enabled = 1
                     <xsl:if test="$locale !='' ">
                                    and lt.locale  = '<xsl:value-of select="$locale"/>'
                     </xsl:if>
                                ) 
         and co.deleted = 0
   <xsl:choose>
     <xsl:when test="$eop !=''">
         <xsl:variable name="eopCondition" select="substring($eop,1,2)"/>
         <xsl:variable name="eopd" select="substring($eop,3)"/>
         <xsl:variable name="eopc" select="if($eopCondition='GE') then '&gt;=' else if($eopCondition='LE') then '&lt;=' else '='"/>
         and co.eop <xsl:value-of select="$eopc"/> to_date('<xsl:value-of select="$eopd"/>','yyyymmdd')
     </xsl:when>
     <xsl:otherwise>
         and co.eop >= sysdate
     </xsl:otherwise>
   </xsl:choose>
   <xsl:if test="$sop !='' ">
      <xsl:variable name="sopCondition" select="substring($sop,1,2)"/>
      <xsl:variable name="sopd" select="substring($sop,3)"/>
      <xsl:variable name="sopc" select="if($sopCondition='GE') then '&gt;=' else if($sopCondition='LE') then '&lt;=' else '='"/>
         and co.sop <xsl:value-of select="$sopc"/> to_date('<xsl:value-of select="$sopd"/>','yyyymmdd')
   </xsl:if>
         and oc.deleted       = 0
   <xsl:if test="$subcat !='' ">    
         and oc.subcategory   = '<xsl:value-of select="$subcat"/>' --'PROFESSIONAL_FLAT_TV_SU'
   </xsl:if>  
   <xsl:if test="$category !='' ">    
         and c.categorycode   = '<xsl:value-of select="$category"/>'
   </xsl:if>  
   <xsl:if test="$group !='' ">    
         and c.groupcode   = '<xsl:value-of select="$group"/>'
   </xsl:if>  
   <xsl:if test="$ctn !='' "> 
        and co.object_id like upper('<xsl:value-of select="concat($ctn,'%')"/>')
   </xsl:if>  
   <xsl:if test="$locale !='' "> 
         and tr.localisation = '<xsl:value-of select="$locale"/>'
   </xsl:if>
    order by 1,2,3,4,5
            </sql:query>
         </sql:execute-query>
   </xsl:template>
</xsl:stylesheet>
