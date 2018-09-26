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
				<sql:query name="alllocales">

					<!--+
					    |
					    |   Retrieve all localisaations
					    |
					    +-->

            select distinct localisation
					  from octl
            where content_type = 'PMT_Translated'
            
            --and localisation in ('en_GB','fr_FR')
            
           	order by localisation
            

				</sql:query>
			</sql:execute-query>

		</root>
	</xsl:template>
</xsl:stylesheet>