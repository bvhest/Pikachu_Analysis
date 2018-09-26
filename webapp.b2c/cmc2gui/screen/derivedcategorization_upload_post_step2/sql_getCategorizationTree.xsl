<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="ct"/>
  <!-- -->
  <xsl:template match="/">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->
  <xsl:template match="DerivedCategorizations">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <scheduleid>
        <sql:execute-query>
          <sql:query>      
            select id from content_type_schedule where content_type = '<xsl:value-of select="$ct"/>'
          </sql:query>
        </sql:execute-query>
      </scheduleid>      
      <sourcecategorization>
            <sql:execute-query>
              <sql:query>      
                select o.data
                  from octl o        
                 where o.CONTENT_TYPE = 'Categorization_Raw' 
                   and o.LOCALISATION = 'none' 
                   and o.OBJECT_ID = '<xsl:value-of select="@o"/>'
                   and NVL(o.status, 'XXX') != 'PLACEHOLDER'
              </sql:query>
            </sql:execute-query>
      </sourcecategorization>      
      <!--
      <sourcecategorization>
        <sql:execute-query>
          <sql:query>      
           select distinct groupcode, categorycode, subcategorycode
             from categorization -->
            <!-- Look at internal categories only -->
            <!--
            where catalogcode in ('CONSUMER','PROFESSIONAL','NORELCO','WALITA')                     
         order by 1,2,3
          </sql:query>
        </sql:execute-query>
      </sourcecategorization>            
      -->
    </xsl:copy>      
  </xsl:template>
</xsl:stylesheet>