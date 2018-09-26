<xsl:stylesheet
      version="2.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
      xmlns:fn="http://www.w3.org/2005/xpath-functions"
      xmlns:cmc2-f="http://www.philips.com/cmc2-f"
      extension-element-prefixes="cmc2-f">
	<xsl:param name="ct"/>
	<xsl:param name="l"/>
	<xsl:param name="ts"/>
	<xsl:param name="dir"/>
	<xsl:param name="batchnumber"/>
	<xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
	
  <xsl:variable name="apos">&apos;</xsl:variable>
	<xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
		
	<xsl:template match="/">
		<entries ct="{$ct}" l="{catalog-configuration[1]/@l}" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}">
			<process/>
			<globalDocs/>
			<xsl:apply-templates select="catalog-configuration"/>
		</entries>
	</xsl:template>
	
	<xsl:template match="catalog-configuration">
		<!-- the content type will not be known in the file so is passed in-->
		<xsl:variable name="contentType" select="@ct"/>
		<!-- the localisation may be detwermined by the item being processed - for eg translation inport or is hard coded. In this case it is aways master_global -->
		<xsl:variable name="localisation" select="@l"/>
		<xsl:variable name="masterLastmodifiedTimestamp" select="substring(@DocTimeStamp,1,19)"/>
		<xsl:variable name="objectId" select="@o"/>
		<entry o="{$objectId}" ct="{$contentType}" l="{$localisation}" valid="true">
			<result>OK</result>
			<content>
				<xsl:copy-of copy-namespaces="no" select="."/>
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
			<currentcontent/>
			<newcontent/>
			<process>
				<xsl:for-each select="ctl">
					<query>
						MERGE INTO catalog_ctl ctg 
              using (
                select '<xsl:value-of select="$objectId"/>' as catalog_id
                      ,'<xsl:value-of select="@ct"/>' as content_type
                      ,'<xsl:value-of select="@l"/>' as localisation
                from dual) s
                on (ctg.catalog_id=s.catalog_id and ctg.content_type=s.content_type and ctg.localisation=s.localisation)
             -- when matched then
             --   update set needsprocessing_flag = 1
                when not matched then
                  insert (catalog_id, content_type, localisation, needsprocessing_flag)
                  values ('<xsl:value-of select="$objectId"/>','<xsl:value-of select="@ct"/>','<xsl:value-of select="@l"/>',1)
				  </query>
				</xsl:for-each>

        <!-- delete catalog_ctl records that are not in the catalog config file -->
        <xsl:variable name="ctl_list" select="fn:string-join(for $ctl in ctl return fn:concat($apos,$ctl/@ct,'!',$ctl/@l,$apos),',')"/>
        <query>
          delete from catalog_ctl
          where catalog_id = '<xsl:value-of select="$objectId"/>'
          and rowid in (
            select rowid from catalog_ctl
            where catalog_id = '<xsl:value-of select="$objectId"/>'
            and not (content_type||'!'||localisation in (<xsl:value-of select="$ctl_list"/>))
          )
        </query>
			</process>
			<octl-attributes>
				<lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
				<masterlastmodified_ts><xsl:value-of select="$masterLastmodifiedTimestamp"/></masterlastmodified_ts>
				<status>Loaded</status>
			</octl-attributes>
		</entry>
	</xsl:template>
	
</xsl:stylesheet>
