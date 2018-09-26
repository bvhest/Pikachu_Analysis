<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >
  <!-- -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="ct"/>
  <xsl:param name="input_ct"/>
  <xsl:param name="country"/>  
  <xsl:param name="reload"/>  
  <xsl:param name="runmode" select="''"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <!-- -->
  <xsl:template match="/">
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
          select distinct oc.content_type,
                  '<xsl:value-of select="$input_ct"/>' input_content_type,                 
                  '<xsl:value-of select="$country"/>' country_code,
                  oc.batch_number
            from octl_control oc
           where oc.modus         = '<xsl:value-of select="$modus"/>'
             and oc.content_type  = '<xsl:value-of select="$ct"/>'
             and oc.localisation in (select locale from locale_language where country = '<xsl:value-of select="$country"/>')
             and oc.batch_number is not null
           order by batch_number
      </sql:query>
    </sql:execute-query>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>