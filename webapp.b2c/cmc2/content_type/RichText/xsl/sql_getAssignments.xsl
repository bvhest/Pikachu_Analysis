<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="ct"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="@*|node()"/>
    </root>
  </xsl:template>  
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  
    <xsl:template match="entry">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    <currentcontent>
       <sql:execute-query>
        <sql:query>
        select o.DATA
          from octl o
         where o.CONTENT_TYPE = '<xsl:value-of select="$ct"/>' 
           and o.LOCALISATION = '<xsl:value-of select="@l"/>'
           and o.OBJECT_ID = '<xsl:value-of select="@o"/>'
           and NVL(o.status, 'XXX') != 'PLACEHOLDER'
        </sql:query>
      </sql:execute-query>                              
    </currentcontent>        
    <currentrelations output_content_type="PMT">
       <sql:execute-query>
        <sql:query>
  SELECT input_content_type, input_localisation, output_content_type, output_localisation, output_object_id, issecondary
    FROM octl_relations cr
   WHERE issecondary = 1 
     and output_object_id = '<xsl:value-of select="@o"/>'
     AND output_content_type = 'PMT'
     AND output_localisation = '<xsl:value-of select="@l"/>'
     and input_object_id = '<xsl:value-of select="@o"/>'
     AND input_content_type = 'RichText'
     AND input_localisation = '<xsl:value-of select="@l"/>'
     order by output_content_type, output_localisation          
        </sql:query>
      </sql:execute-query>                    
      </currentrelations>              
          <currentoctls>
       <sql:execute-query>
        <sql:query>
          SELECT object_id
            FROM octl
           WHERE content_type = 'PMT'
             and localisation = '<xsl:value-of select="@l"/>'      
             and object_id = '<xsl:value-of select="@o"/>'      
        order by 1
        </sql:query>
      </sql:execute-query>                    
      </currentoctls>   
    </xsl:copy>      
  </xsl:template>
</xsl:stylesheet>

