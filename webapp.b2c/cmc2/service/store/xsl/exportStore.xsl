<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                >
  <!-- this should build both sql queries for store to database and it target=filestore use write source to write output to file -->
  <xsl:param name="runmode"/>
	<!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>	
  <!-- -->
	<xsl:template match="entries">
		<xsl:copy>
				<filedata>
					<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
						<source:source>
							<xsl:value-of select="concat(@dir,'/',@ct,'.',@l,'.',@ts,'.',@batchnumber,'.xml')"/> 
						</source:source>
						<source:fragment>
							<root>
								<xsl:copy-of copy-namespaces="no" select="//content/*"/>
							</root>
						</source:fragment>
					</source:write>
				</filedata>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	<!-- -->
	<xsl:template match="content[../@valid='true'] ">
		<content>
			<sql:execute-query>
				<sql:in-xml-parameter nr="1">
          <!-- quick hack to enable store for octls without content -->
          <xsl:choose>
            <xsl:when test="./*">
              <xsl:copy-of copy-namespaces="no" select="./*"/>
            </xsl:when>
            <xsl:otherwise>.</xsl:otherwise>
          </xsl:choose>
        </sql:in-xml-parameter>
				<sql:query>
INSERT INTO STORE_V
   (content_type,localisation,object_id,masterlastmodified_ts,lastmodified_ts, needsprocessing_flag
   ,	startofprocessing, endofprocessing, active_flag, status, marketingversion, remark, islocalized, data
   )
VALUES
   ('<xsl:value-of select="../@ct"/>'
   ,'<xsl:value-of select="../@l"/>'
   ,'<xsl:value-of select="../@o"/>'
   ,to_date('<xsl:value-of select="../@masterlastmodified"/>','yyyy-mm-dd"T"hh24:mi:ss')
   ,to_date('<xsl:value-of select="../@ts"/>','yyyy-mm-dd"T"hh24:mi:ss')
   ,0   <!--Most PROCESSES ARE NOT setting this so leave as default '<xsl:value-of select="../octl-attributes/needsprocessing_flag"/>', -->
   ,to_date('<xsl:value-of select="../octl-attributes/startofprocessing"/>','yyyy-mm-dd"T"hh24:mi:ss')
   ,to_date('<xsl:value-of select="../octl-attributes/endofprocessing"/>','yyyy-mm-dd"T"hh24:mi:ss')
   ,'<xsl:value-of select="../octl-attributes/active_flag"/>'
   ,'<xsl:value-of select="../octl-attributes/status"/>'
   ,'<xsl:value-of select="../octl-attributes/marketingversion"/>'
   ,'<xsl:value-of select="../octl-attributes/remark"/>'
   ,'<xsl:value-of select="../octl-attributes/islocalized"/>'
   ,?
   )
					</sql:query>
			</sql:execute-query>
		</content>
	</xsl:template>
	<!-- -->
	<xsl:template match="content[../@valid='false'] ">
		<xsl:copy-of copy-namespaces="no" select="content"/>
		<sql:execute-query>
			<sql:query>
UPDATE octl_control
   SET needsprocessing_flag = 0
     , batch_number         = null
 WHERE modus                = '<xsl:value-of select="$modus"/>'
   AND content_type         = '<xsl:value-of select="@ct"/>'
   AND localisation         = '<xsl:value-of select="@l"/>'
   AND object_id            = '<xsl:value-of select="@o"/>'
   AND needsprocessing_flag = 1
			</sql:query>
		</sql:execute-query>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
