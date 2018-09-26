<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- Parameters:
      |  1) schedule_id : unique identification of the content_type/channel that is running.
      |  2) run_id      : unique identification of the currently running process/batch-run.
      |  3) runMode     : process modus; batch, fastlane or manual.
      |-->
	<xsl:param name="schedule_id"/>
	<xsl:param name="run_id"/>
   <xsl:param name="run_mode"/>
	<!-- -->
   <xsl:variable name="runID" select="if ($run_id   != '') then $run_id else 'MANUAL'" />
   <xsl:variable name="modus" select="if ($run_mode != '') then $run_mode else 'BATCH'" />
	<!-- -->
	<xsl:template match="/">
      <root>
         <!-- update execute flag in Channel table -->
         <sql:execute-query>
            <sql:query>
               UPDATE vw_content_type_schedule
                  SET run_id     = '<xsl:value-of select="$runID"/>'
                    , modus      = '<xsl:value-of select="$modus"/>'
                    , startExec  = SYSDATE
                WHERE id = '<xsl:value-of select="$schedule_id"/>'
         </sql:query>
         </sql:execute-query>
      </root>
   </xsl:template>
   
</xsl:stylesheet>