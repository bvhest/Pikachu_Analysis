<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:email="http://apache.org/cocoon/transformation/sendmail"
                >
  <!-- -->
  <xsl:param name="sender"/>
  <xsl:param name="recipient"/>
  <xsl:param name="recipient2"/>
  <xsl:param name="path2file"/>
  <!-- -->
  <xsl:template match="root">   
      <email:sendmail>
         <email:from><xsl:value-of select="$sender"/></email:from>
         <email:to><xsl:value-of select="$recipient"/></email:to>
         <email:to><xsl:value-of select="$recipient2"/></email:to>
         <email:subject>B2B Product Report sent by PikaChu </email:subject>                        
         <email:body src="cocoon:/getBody"/>
         <email:attachment name="report">
            <xsl:attribute name="url" select="$path2file"/>
         </email:attachment>
      </email:sendmail>    
  </xsl:template>
  <!--  -->    
</xsl:stylesheet>
