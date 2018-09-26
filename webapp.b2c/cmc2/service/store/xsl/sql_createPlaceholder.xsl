<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  
<xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->  
   <xsl:template match="entry[@valid='false' and result='No Placeholder']">
      <xsl:copy copy-namespaces="no">
         <xsl:apply-templates select="@*[local-name() != 'valid']  "/>
         <xsl:attribute name="valid">true</xsl:attribute>
         <sql:execute-query>
            <sql:query name="createPlaceholder">
            INSERT INTO octl
               ( content_type
               , localisation
               , object_id
               , needsprocessing_flag
               , derivesecondary_flag
               , needsprocessing_ts
               , intransaction_flag
               , masterlastmodified_ts
               , lastmodified_ts
               , startofprocessing
               , endofprocessing
               , active_flag
               , status
               , batch_number
               , remark
               , islocalized) 
            values
               ( '<xsl:value-of select="@ct"/>'
               , '<xsl:value-of select="@l"/>'
               , '<xsl:value-of select="@o"/>'
               , 0
               , 0
               , TO_DATE ('01/01/1900', 'dd/mm/yyyy')
               , 0
               , TO_DATE ('01/01/1900', 'dd/mm/yyyy')
               , TRUNC(SYSDATE)
               , TO_DATE ('01/01/1900', 'dd/mm/yyyy')
               , TO_DATE ('31/12/4712', 'dd/mm/yyyy')
               , 1
               , 'PLACEHOLDER'
               , NULL
               , NULL
               , 0)

            </sql:query>
         </sql:execute-query>
         <xsl:apply-templates select="node()"/>
      </xsl:copy>
   </xsl:template> 

   <xsl:template match="result[.='No Placeholder']">
      <xsl:copy copy-namespaces="no">OK</xsl:copy>
   </xsl:template>
  
</xsl:stylesheet>
