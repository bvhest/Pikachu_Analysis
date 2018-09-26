<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:sql="http://apache.org/cocoon/SQL/1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/> 
<xsl:param name="batchnumber"/>  
  <xsl:template match="/">
    <root xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:execute-query>
        <sql:query name="sql_selectbatches">
          select
			 OBJECT_ID
			,substr(FILELOCATION,8) FILELOCATION
			from
			purge_data
			where 
				batch_number = <xsl:value-of select="$batchnumber"/>
        </sql:query>
      </sql:execute-query>
    </root>
  </xsl:template>
</xsl:stylesheet>  
  