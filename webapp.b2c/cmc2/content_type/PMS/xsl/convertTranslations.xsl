<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:pms-f="http://www.philips.com/pika/pms/1.0"
                exclude-result-prefixes="sql"
                >
  <xsl:include href="pmsBase.xsl"/>
   
  <xsl:template match="sql:rowset" />
  <!--
    Create LastTranslation content 
  -->
  <xsl:template match="Countries[sql:rowset[@name='locales']/sql:row]/Country/Locales/Locale/LastTranslation">
    <xsl:variable name="locale-translation" select="../../../../sql:rowset[@name='locales']/sql:row[sql:locale_trans = current()/../@LocaleID]" />
    <xsl:if test="exists($locale-translation)">
      <xsl:copy copy-namespaces="no">
        <StatusAlert>
          <Description />
          <WorkflowUrgency>
            <xsl:text>Green</xsl:text>
          </WorkflowUrgency>
        </StatusAlert>
        <PMTVersion><!-- xsl:value-of select="replace($locale-translation/sql:mv_trans,'^(\d+\.\d+)\.\d+$','$1')"/ -->
          <xsl:value-of select="$locale-translation/sql:mv_live" />
        </PMTVersion>
        <LastModifiedDate>
          <xsl:value-of select="$locale-translation/sql:lmdate_live" />
        </LastModifiedDate>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <!--
    Create PendingTranslation content 
  -->
  <xsl:template match="Countries[sql:rowset[@name='pendingTranslations']/sql:row]/Country/Locales/Locale/PendingTranslations">
    <xsl:copy copy-namespaces="no">
      <xsl:for-each select="../../../../sql:rowset[@name='pendingTranslations']/sql:row[sql:localisation = current()/../@LocaleID]">
        <PendingTranslation>
          <xsl:attribute name="columnID"><xsl:value-of select="sql:locale_version" /></xsl:attribute>
          <StatusAlert>
            <Description />
            <WorkflowUrgency>
              <xsl:text>Red</xsl:text>
            </WorkflowUrgency>
          </StatusAlert>
          <PMTVersion><!-- xsl:value-of select="replace(sql:marketingversion,'^(\d+\.\d+)\.\d+$','$1')"/ -->
            <xsl:value-of select="sql:marketingversion" />
          </PMTVersion>
          <LastModifiedDate>
            <xsl:value-of select="sql:doctimestamp" />
          </LastModifiedDate>
        </PendingTranslation>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="Countries[empty(sql:rowset[@name='pendingTranslations']/sql:row)]/Country/Locales/Locale/PendingTranslations" />
</xsl:stylesheet>
