<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:param name="country"/>

  <xsl:template match="/">
  <root>
  

   	  <sql:execute-query>
		<sql:query>
			select object_id, to_char(sop,'yyyy-mm-dd"T"hh24:mi:ss') sop,to_char(eop,'yyyy-mm-dd"T"hh24:mi:ss') eop  from catalog_objects where country= '<xsl:value-of select="$country"/>' and customer_id = 'CARE' 
		</sql:query>	  
      </sql:execute-query>

	  
  </root>
  </xsl:template>
</xsl:stylesheet>