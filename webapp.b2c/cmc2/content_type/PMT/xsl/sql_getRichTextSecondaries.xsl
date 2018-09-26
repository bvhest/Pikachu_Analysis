<xsl:stylesheet version="2.0" 
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:sql="http://apache.org/cocoon/SQL/2.0">
 
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->  
  <xsl:template match="entry">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <secondary>
        <currentrelations output_content_type="PMT">
          <sql:execute-query>
            <sql:query>
            <!-- select RichText secondary relations to PMT where RichText content exists -->
               SELECT input_content_type, input_localisation, output_content_type, output_localisation, output_object_id, issecondary, o.data
               FROM octl_relations cr 
               inner join octl o 
                 on cr.input_content_type = o.content_type
                 and cr.input_object_id = o.object_id
                 and cr.input_localisation = o.localisation
               where cr.issecondary = 1
                 and cr.output_object_id = '<xsl:value-of select="@o"/>'
                 AND cr.output_content_type = 'PMT'
                 AND cr.output_localisation = '<xsl:value-of select="@l"/>'
                 and cr.input_object_id = '<xsl:value-of select="@o"/>'
                 AND cr.input_content_type = 'RichText'
                 AND cr.input_localisation = '<xsl:value-of select="@l"/>'
                 AND o.status != 'PLACEHOLDER'
               order by output_content_type, output_localisation
            </sql:query>
          </sql:execute-query>                    
        </currentrelations>              
      </secondary>
    </xsl:copy>      
  </xsl:template>
</xsl:stylesheet>

