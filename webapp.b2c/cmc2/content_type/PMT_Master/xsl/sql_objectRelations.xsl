<xsl:stylesheet version="2.0" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="ts"/>
  <xsl:param name="o"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="content">
     <content>
         <xsl:apply-templates select="@*|node()" />
         <octl ct="PMT_Refs"> <!-- accessories -->
            <sql:execute-query>
               <sql:query name="PMT_Refs">
               select unique 'PMT_Refs'      as content_type
                    , orel.object_id_src     as object_id
                    , orel.object_id_tgt     as accesory
                    , 'Accessory'            as ProductReferenceType
                 from object_relations orel
                inner join catalog_objects co
                   on co.object_id       = orel.object_id_tgt
                  and co.deleted         = 0
                  and co.eop             > TO_DATE('<xsl:value-of select="$ts"/>','YYYYMMDDHH24MISS')
                  and co.customer_id    != 'CARE'
                where orel.rel_type      = 'PRD_ACC'
                  and orel.deleted       = 0
                  and orel.object_id_src = '<xsl:value-of select="$o" />'
               </sql:query>
            </sql:execute-query>
         </octl>                
     </content>
  </xsl:template>
  
</xsl:stylesheet>