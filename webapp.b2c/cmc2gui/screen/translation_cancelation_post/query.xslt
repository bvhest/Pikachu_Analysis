<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:h="http://apache.org/cocoon/request/2.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
                
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="ct" select="/h:request/h:requestParameters/h:parameter[@name='ct']/h:value" />
  <xsl:param name="file_name" select="/h:request/h:requestParameters/h:parameter[@name='file_name']/h:value" />
  <xsl:param name="reason" select="/h:request/h:requestParameters/h:parameter[@name='reason']/h:value" />
  <!-- -->
  <xsl:template match="/">
    <root>
      <!-- -->
      <sql:execute-query>
        <sql:query name="PCK_TRANSLATIONS.cancel_translation_request" isstoredprocedure="true">
            begin
               PCK_TRANSLATIONS.cancel_translation_request(p_ct => '<xsl:value-of select="$ct"/>'
                                                          ,p_filename => '<xsl:value-of select="$file_name"/>'
                                                          ,p_reason => '<xsl:value-of select="$reason"/>'
                                                          );
            end;
		  </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
  
</xsl:stylesheet>
