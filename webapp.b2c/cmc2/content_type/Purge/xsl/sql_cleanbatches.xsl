<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:sql="http://apache.org/cocoon/SQL/1.0">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/> 
	<xsl:param name="batchnumber"/>  
	<xsl:template match="/">
		<xsl:call-template name="countTotalNumberofFilesDeleted"/>
	</xsl:template>
	<xsl:template name="countTotalNumberofFilesDeleted">
		<xsl:copy>
			<root xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<xsl:text> Total Files Deleted :</xsl:text>
				<sql:execute-query>
					<sql:query name="delete_purge_data">
					delete from
						purge_data
					where 
						batch_number > 0
					</sql:query>
				</sql:execute-query>
			</root>
		</xsl:copy>
	</xsl:template> 
</xsl:stylesheet>  
  