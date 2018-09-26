<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="channel"></xsl:param>
	
	<xsl:template match="/">
		<root>		
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query name="nullstatuscheck">
          select o.content_type
               , o.localisation
               , count(*) count
            from octl o
           where o.status is null
        group by o.content_type, o.localisation
        order by o.content_type, o.localisation
				</sql:query>
			</sql:execute-query>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <sql:query name="nonnullstatuscheck">
            select o.content_type, o.localisation, o.object_id 
             from OCTL o
            where o.status = 'Final Published' 
            --and o.object_id = 'SBCHS900/00'
            --o.content_type = 'PMT_Localised' 
              and os.data is null
         order by 1,2,3
				</sql:query>
			</sql:execute-query>      
		</root>
	</xsl:template>
</xsl:stylesheet>