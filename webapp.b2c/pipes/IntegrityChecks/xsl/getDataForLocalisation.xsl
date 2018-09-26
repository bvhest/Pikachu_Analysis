<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="runtimestamp"/>  
	<xsl:param name="channel"></xsl:param>
	<xsl:param name="locale"></xsl:param>	
	<xsl:param name="batchsize"/>
	<xsl:param name="dir"/>
	<!-- -->
	<xsl:template match="/root">
		<root>
						<sql:execute-query>
							<sql:query>
                select o.content_type
                     , o.localisation
                     , o.object_id
                     , o.data
                  from octl o 
                 where o.content_type = 'PMT_Translated'
                   and o.localisation = '<xsl:value-of select="$locale"/>' 
                   and NVL(o.status, 'XXX') != 'PLACEHOLDER'
               -- and os.object_id like 'FM01%'
              </sql:query>                            
						</sql:execute-query>
    </root>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
