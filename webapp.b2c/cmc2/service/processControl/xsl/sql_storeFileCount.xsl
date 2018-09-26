<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>	

<xsl:param name="content_type"/>
<xsl:param name="file_count"/>
<xsl:param name="run_id"/>
<xsl:param name="schedule_id"/>

	<xsl:variable name="runmodus" select="if ($run_id != '') then 'BATCH' else 'MANUAL'" />

	<xsl:template match="/root">
    <root>
		<sql:execute-query>
			<sql:query isstoredprocedure="true" name="update PCU_PROCESS_LOGGING-table">
			DECLARE
				v_INTRO_STR  	 VARCHAR2(10)						:= 'MANUAL_';
				v_DATE_FORMATE   VARCHAR2(20)						:= 'YYYYMMDD_HH24MISS';
				v_SCHEDULE_ID    VARCHAR2(20)  						:= '<xsl:value-of select="$schedule_id"/>';
				v_content_type 	 VARCHAR2(10)						:= '<xsl:value-of select="$content_type"/>';
				v_COUNT_IN		 VARCHAR2(20) 						:= '<xsl:value-of select="$file_count"/>';
			BEGIN
				--
				-- Volumn in update query 
				--
				UPDATE PCU_PROCESS_LOGGING 
					SET OBJECT_COUNT_IN = v_COUNT_IN 
					WHERE MODUS         = '<xsl:value-of select="$runmodus"/>' 
					AND PROCESS_NAME    = v_content_type
					<xsl:choose>
						<xsl:when test="$run_id = ''">									
							AND RUN_SCHEDULE = 
								( 	SELECT  v_INTRO_STR || TO_CHAR(STARTEXEC, v_DATE_FORMATE)
									  FROM VW_CONTENT_TYPE_SCHEDULE
									  WHERE CONTENT_TYPE = v_content_type 
												  AND ID = v_SCHEDULE_ID
								)					
						</xsl:when>
						<xsl:otherwise>
							AND RUN_SCHEDULE = '<xsl:value-of select="$run_id"/>'
						</xsl:otherwise>
					</xsl:choose>
					;
				--	
				-- End of update query
				--
		    END;
			</sql:query>
        </sql:execute-query>
    </root>
	</xsl:template>
	
</xsl:stylesheet>