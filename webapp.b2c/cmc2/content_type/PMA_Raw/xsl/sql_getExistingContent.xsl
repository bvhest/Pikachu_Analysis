<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:variable name="output_ct" select="'PMT_Enriched'"/>
  <xsl:variable name="output_l" select="'master_global'"/>  
  <!-- -->
  <xsl:template match="globalDocs">
    <xsl:copy copy-namespaces="no">
      <currentcontent>
        <sql:execute-query>
          <sql:query>
            SELECT o.content_type
                 , o.localisation
                 , o.object_id
                 , o.masterlastmodified_ts
                 , o.lastmodified_ts
                 , o.status
                 , o.marketingversion
                 , o.data
			  from octl o
             where o.content_type = '<xsl:value-of select="$ct"/>'
               and o.localisation = '<xsl:value-of select="$l"/>'
               and NVL(o.status, 'XXX') != 'PLACEHOLDER'       
             order by o.object_id
          </sql:query>
        </sql:execute-query>              
      </currentcontent>
      <currentoctls content_type="{$ct}">
        <sql:execute-query>
          <sql:query>
            select object_id 
              from octl 
             where content_type = '<xsl:value-of select="$ct"/>'
               and localisation = '<xsl:value-of select="$l"/>'
             order by 1
          </sql:query>
        </sql:execute-query>         
      </currentoctls>      
      <currentoctls content_type="{$output_ct}">
        <sql:execute-query>
          <sql:query>
            select object_id 
              from octl 
             where content_type = '<xsl:value-of select="$output_ct"/>'
               and localisation = '<xsl:value-of select="$output_l"/>'
             order by 1
          </sql:query>
        </sql:execute-query>         
      </currentoctls>
      <currentrelations output_content_type="{$output_ct}">
        <sql:execute-query>
          <sql:query>
            select input_content_type, input_localisation, output_content_type, output_localisation, output_object_id, issecondary
            from octl_relations
            where issecondary = 1 
              and input_content_type = '<xsl:value-of select="$ct"/>'
              and input_localisation = '<xsl:value-of select="$l"/>'              
              and output_content_type = '<xsl:value-of select="$output_ct"/>'
              and output_localisation = '<xsl:value-of select="$output_l"/>'
            order by 1,2,3,4,5
          </sql:query>
        </sql:execute-query>
      </currentrelations>
    </xsl:copy>    
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
</xsl:stylesheet>