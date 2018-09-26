<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <!-- $runcatalogexport will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->
  <xsl:param name="runcatalogexport"/>
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:variable name="v_needsprocessing" select="if($runcatalogexport = 'yes') then 2 else 1"/>    
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="entry">
    <entry>
      <xsl:copy-of select="@*"/>
      <storelocales>
        <xsl:choose>
          <xsl:when test="not(content/Node/@IsLocalized='true')">  
            <sql:execute-query>
              <sql:query>
            select distinct o.localisation 
              from octl o
             inner join octl_control oc
                on oc.content_type  = o.content_type
               and oc.localisation  = o.localisation
               and oc.object_id     = o.object_id
               and oc.modus         = '<xsl:value-of select="$modus"/>'
             where o.content_type   = '<xsl:value-of select="@ct"/>'
               and o.object_id      = '<xsl:value-of select="@o"/>'
               and o.localisation in (select locale 
                                        from locale_language 
                                       where languagecode = (select languagecode 
                                                               from locale_language 
                                                              where locale = '<xsl:value-of select="@l"/>'
                                                            )
                                     ) 
               and nvl(o.islocalized,0)    = 0
               and oc.needsprocessing_flag = <xsl:value-of select="$v_needsprocessing"/>
      <!--  Use of SOP to determine export disabled until confirmation received that LCB is no longer sending SOPs way into the future for packaging products           
              and startofprocessing &lt;= trunc(sysdate)
       -->
               and o.endofprocessing   &gt;= trunc(sysdate)
               and o.active_flag           = 1
               <!-- select only those that were selected in initial selection (sql_createbatches.xsl, cursor c1) -->
               and oc.intransaction_flag   = 1                               </sql:query>
            </sql:execute-query>     
          </xsl:when>
          <xsl:otherwise>
            <storelocale><xsl:value-of select="@l"/></storelocale>
          </xsl:otherwise>
        </xsl:choose>
      </storelocales>
      <xsl:apply-templates />
    </entry>
  </xsl:template>  
  
</xsl:stylesheet>