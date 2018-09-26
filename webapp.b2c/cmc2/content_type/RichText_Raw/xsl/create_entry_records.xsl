<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f">
	<xsl:param name="ct"/>
	<xsl:param name="l"/>
	<xsl:param name="ts"/>
	<xsl:param name="dir"/>
	<xsl:param name="batchnumber"/>
	<xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
	<xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)"/>
	<xsl:variable name="DocTimeStamp" select="/RichText_Raw/@DocTimeStamp"/>
	
	<xsl:template match="/RichText_Raw">
		<entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}" valid="true">
			<xsl:variable name="contentType" select="$ct"/>
			<!-- the localisation may be detwermined by the item being processed - for eg translation inport or is hard coded. In this case it is aways master_global -->
			<xsl:variable name="localisation" select="'none'"/>
			<xsl:variable name="masterLastmodifiedTimestamp" select="substring($DocTimeStamp,1,19)"/>
			<process/>
			<globalDocs/>
			
			<xsl:for-each-group select="object" group-by="@object_id">
				<xsl:variable name="objectId" select="current-grouping-key()"/>
				<entry o="{$objectId}" ct="{$contentType}" l="{$localisation}" valid="true">
					<result>OK</result>
					<content>
						<object>
							<id><xsl:value-of select="$objectId"/></id>
							<RichTexts>
								<xsl:for-each select="current-group()">
									<xsl:copy-of select="RichTexts/RichText"/>
								</xsl:for-each>
							</RichTexts>
						</object>
					</content>
					<currentmasterlastmodified_ts>
						<sql:execute-query>
							<sql:query>
		            select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
		            from octl where content_type='<xsl:value-of select="$contentType"/>'
		            and localisation='<xsl:value-of select="$localisation"/>'
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
						<status>Loaded</status>
					</octl-attributes>
				</entry>
			</xsl:for-each-group>
			
		</entries>
	</xsl:template>
		
</xsl:stylesheet>
