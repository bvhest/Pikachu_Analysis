<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<!-- -->
	<xsl:param name="ct"/>
	<xsl:param name="ts"/>
	<xsl:param name="catalogType"/>  
  
	<!-- -->
	<xsl:template match="/">
	<root>
		
	<!-- update execute flag in Channel table -->
		<sql:execute-query>
			<sql:query>
            update octl_control o 
               set needsprocessing_flag = 1
				 where content_type = '<xsl:value-of select="$ct"/>'
				   and o.timestamp &lt; (select max(obt.lastmodified_ts) 
                                       from vw_object_categorization obt
                                      where obt.object_id   = o.object_id
                                        and obt.catalogcode = '<xsl:value-of select="$catalogType"/>'
                                    )
      </sql:query>
		</sql:execute-query>
	</root>
</xsl:template>
</xsl:stylesheet>