<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="content">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <octl>
        <sql:execute-query>
          <sql:query>
            select o.* 
              from octl o 
             where o.content_type = 'PMT_Master' 
               and o.localisation = 'master_global' 
               and o.object_id    = '<xsl:value-of select="../@o"/>'
          </sql:query>            
        </sql:execute-query>            
      </octl>
      <octl>
        <sql:execute-query>
          <sql:query name="categorization">
            select c.*
              from categorization c
        inner join vw_object_categorization oc
                on oc.subcategory = c.subcategorycode
               and oc.catalogcode = c.catalogcode 
             where oc.object_id   = '<xsl:value-of select="../@o"/>'
               and oc.isautogen   = 0
               and oc.catalogcode = 'MASTER'
          </sql:query>            
        </sql:execute-query>                    
      </octl>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>