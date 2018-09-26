<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f">
	<xsl:param name="ct"/>
	<xsl:param name="l"/>
	<xsl:param name="ts"/>
	<xsl:param name="batchnumber"/>
	<xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
	<xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)"/>
	<!-- -->
	<xsl:template match="Users">
		<xsl:variable name="masterLastmodifiedTimestamp" select="$processTimestamp"/>
		<xsl:variable name="objectId" select="User/@accountID"/>
		<xsl:variable name="remark" select="User/Name"/>
		<xsl:variable name="status" select="User/@status"/>
		<entry o="{$objectId}" ct="{$ct}" l="{$l}" valid="true">
			<result>OK</result>
			<content>
				<xsl:copy-of select="."/>
			</content>
			<currentmasterlastmodified_ts>
				<sql:execute-query>
					<sql:query>
				select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
				from octl where content_type='<xsl:value-of select="$ct"/>'
				 and localisation='<xsl:value-of select="$l"/>'
				 and object_id='<xsl:value-of select="$objectId"/>'
			  </sql:query>
				</sql:execute-query>
			</currentmasterlastmodified_ts>
			<currentlastmodified_ts/>
			<process/>
			<!-- This will only be ran when this entry is valid. Therefore, using importExecDelta-->
			<octl-attributes>
				<lastmodified_ts>
					<xsl:value-of select="$processTimestamp"/>
				</lastmodified_ts>
				<masterlastmodified_ts>
					<xsl:value-of select="$masterLastmodifiedTimestamp"/>
				</masterlastmodified_ts>
				<remark>
					<xsl:value-of select="$remark"/>
				</remark>
				<status>
					<xsl:value-of select="$status"/>
				</status>
			</octl-attributes>
		</entry>
	</xsl:template>
</xsl:stylesheet>
