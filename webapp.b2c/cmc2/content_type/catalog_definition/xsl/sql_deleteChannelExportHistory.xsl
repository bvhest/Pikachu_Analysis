<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"  >
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="content">
    <content/>
  </xsl:template>
  <!-- -->
  <xsl:template match="process">
    <process>
      <xsl:for-each select="query">    
        <xsl:copy>
          <xsl:apply-templates select="."/>
          <xsl:if test="sql-status='success' and sql-returncode='1'">
            <deleteCLE>
              <xsl:attribute name="catalog" select="@catalog"/>
              <xsl:attribute name="o" select="@o"/>
              <xsl:attribute name="country" select="@country"/>            
              <sql:execute-query>					
                <sql:query name="sql_deleteChannelExportHistory">
                  <xsl:if test="not(contains(@catalog,'MARKETING')) and not(contains(@catalog,'CARE'))">
                    update customer_locale_export cle
                       set cle.lasttransmit = to_date('01011900', 'ddmmyyyy')
                     where ctn = '<xsl:value-of select="@o"/>'
                       and substr(locale,4,2) = '<xsl:value-of select="@country"/>'
                       and (   customer_id in ('AtgExport')
                            or customer_id in (select name
                                                 from channels
                                                where (pipeline like 'pipes/Xml.%'
                                                    or pipeline like 'pipes/Zip.%'
                                                    or pipeline like 'pipes/ProductExport.%'
                                                    or pipeline like 'pipes/RangeExport.%'
                                                    or pipeline like 'pipes/FilterKeysExport.%'
                                                       )
                                               )
                            )
                  </xsl:if>
                </sql:query>
              </sql:execute-query>					                          
            </deleteCLE>
          </xsl:if>
        </xsl:copy>
      </xsl:for-each>
    </process>
  </xsl:template>
</xsl:stylesheet>
