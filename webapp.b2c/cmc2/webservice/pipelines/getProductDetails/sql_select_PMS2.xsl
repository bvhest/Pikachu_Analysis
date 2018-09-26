<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
  
  <xsl:param name="localeFilter"/>
  <xsl:variable name="locales" select="replace($localeFilter, 
                                               ',', 
                                               concat($apos, ',', $apos)
                                       )"/>
                
  <xsl:import href="sql_select.xsl"/>
  
  <xsl:template match="octl">
    <xsl:next-match/>
    
    <xsl:copy copy-namespaces="no">
      <sql:execute-query>
        <sql:query>
           select * from octl
            where object_id in ('<xsl:value-of select="$ctns"/>')
            and content_type='PMT_Master'
            and localisation = 'master_global'           
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query>
           select * from octl
            where object_id in ('<xsl:value-of select="$ctns"/>')
            and content_type='PMA'           
            <xsl:if test="$locales != ''">
            and localisation in ('<xsl:value-of select="$locales"/>')
            </xsl:if>
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
