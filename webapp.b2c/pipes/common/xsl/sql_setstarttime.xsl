<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- Parameters:
      |  1) channel     : identification of the content_type/channel that is running
      |  2) run_id      : unique identification of the content_type/channel that is running
      |  3) runMode     : process modus; batch, fastlane or manual
      |-->
	<xsl:param name="channel">test</xsl:param>
	<xsl:param name="run_id"/>
   <xsl:param name="run_mode"/>
	<!-- -->
   <xsl:variable name="runID" select="if ($run_id   != '') then $run_id   else 'MANUAL'" />
   <xsl:variable name="modus" select="if ($run_mode != '') then $run_mode else 'BATCH'" />
	<!-- -->
	<xsl:template match="/">
	<root>
      <!-- update execute flag in Channel table -->
		<sql:execute-query>
			<sql:query>
UPDATE vw_channels c
   SET c.run_id     = '<xsl:value-of select="$runID"/>'
     , c.modus      = '<xsl:value-of select="$modus"/>'
     , c.startexec  = SYSDATE
 WHERE c.name = '<xsl:value-of select="$channel"/>'
			</sql:query>
		</sql:execute-query>
	</root>
</xsl:template>
</xsl:stylesheet>