<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="ct">test</xsl:param>
	<xsl:template match="/">
		<root>
			<sql:execute-query>
				<sql:query name="locales">
               select c.content_type
                    , c.localisation
                 from ctl c
                where exists (select 1 
                                from octl o 
                               where o.content_type = c.content_type 
                                 and o.localisation = c.localisation
                                 and NVL(o.status, 'XXX') != 'PLACEHOLDER'
                             ) 
               <xsl:if test="$ct != 'all'">
                  and c.content_type =  '<xsl:value-of select="$ct"/>'
               </xsl:if>
               order by content_type, localisation
				 </sql:query>
			</sql:execute-query>
		</root>
	</xsl:template>
</xsl:stylesheet>
