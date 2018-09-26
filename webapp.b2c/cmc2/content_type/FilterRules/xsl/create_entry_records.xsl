<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:sql="http://apache.org/cocoon/SQL/2.0"
      xmlns:cmc2-f="http://www.philips.com/cmc2-f"
      extension-element-prefixes="cmc2-f"
      exclude-result-prefixes="sql">
      
	<xsl:param name="ct"/>
	<xsl:param name="l"/>
	<xsl:param name="ts"/>
	<xsl:param name="dir"/>
	<xsl:param name="batchnumber"/>
	<xsl:include href="../../../xsl/common/cmc2.function.xsl"/>

	<xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
	
	<xsl:template match="/Filters">
    <xsl:variable name="localisation" select="'none'"/>
    <xsl:variable name="masterLastmodifiedTimestamp" select="@masterLastModified"/>
    <xsl:variable name="objectId" select="'filterrules'"/>
		<entries ct="{$ct}" l="{$localisation}" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}">
			<process/>
			<globalDocs/>
  		<entry o="{$objectId}" ct="{$ct}" l="{$localisation}"  valid="true">
  			<result>OK</result>
  			<content>
  				<xsl:copy-of copy-namespaces="no" select="."/>
  			</content>
  			<currentmasterlastmodified_ts>
  				<sql:execute-query>
  					<sql:query>
							select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts 
							from octl where content_type='<xsl:value-of select="$ct"/>' 
							and localisation='<xsl:value-of select="$localisation"/>' 
							and object_id='<xsl:value-of select="$objectId"/>'
  					</sql:query>
  				</sql:execute-query>
  			</currentmasterlastmodified_ts>
  			<currentlastmodified_ts/>
  			<process/>
  			<octl-attributes>
  				<lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
  				<masterlastmodified_ts><xsl:value-of select="$masterLastmodifiedTimestamp"/></masterlastmodified_ts>
          <status>Loaded</status>
  			</octl-attributes>
  		</entry>
		</entries>
	</xsl:template>
</xsl:stylesheet>
