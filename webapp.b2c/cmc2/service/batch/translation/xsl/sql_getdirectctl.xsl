<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="ct"/>  
  <xsl:param name="ts"/>  
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <!-- -->  
  <xsl:template match="/">
    <root xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:execute-query>
        <sql:query  name="getDirectCTL">
        <xsl:choose>
          <xsl:when test="$ct='RangeText_Translated'">
            select distinct o.content_type
                 , lt.locale as localisation
                 , 'CE' as division
                 , '<xsl:value-of select="$ts"/>' as runtimestamp
             from octl o 
            inner join language_translations lt
               on lt.locale = o.localisation
            where o.content_type = '<xsl:value-of select="$ct"/>' 
              and lt.enabled  = 1 
              and lt.isdirect = 1
              and exists (select 1 
                            from octl_control oc
                           where oc.modus        = '<xsl:value-of select="$modus"/>'
                             and oc.content_type = o.content_type
                             and oc.localisation = o.localisation
                             and oc.object_id    = o.object_id    
                             and oc.needsprocessing_flag = 1
                         )  
         </xsl:when>
         <xsl:otherwise>
            select '<xsl:value-of select="$ct"/>' as content_type
            ,locale as localisation
            ,division
            ,'<xsl:value-of select="$ts"/>' as runtimestamp
             from language_translations lt
            where lt.enabled  = 1 
              and lt.isdirect = 1
           <xsl:if test="$ct='Categorization_Translated'">
              and lt.division = 'CE'
           </xsl:if>
         </xsl:otherwise>         
         </xsl:choose>        
            order by lt.locale         
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>  
