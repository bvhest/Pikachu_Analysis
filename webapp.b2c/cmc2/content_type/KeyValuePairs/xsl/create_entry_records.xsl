<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batchnumber"/>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  <!-- -->
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <!-- -->
  <xsl:template match="/KeyValuePairs[object]">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$batchnumber}" valid="true">
      <process/>
      <globalDocs/>
      <xsl:apply-templates/>
    </entries>
  </xsl:template>
  <!-- -->    
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="object">
    <xsl:variable name="contentType" select="$ct"/>
    <xsl:variable name="localisation" select="'master_global'"/>
    <xsl:variable name="masterLastmodifiedTimestamp" select="@masterLastModified"/>
    <xsl:variable name="objectId" select="@object_id"/>
    <entry o="{$objectId}" ct="{$contentType}" l="{$localisation}" valid="true">
      <result>OK</result>
      <content>
        <KeyValuePairs>
          <xsl:apply-templates select="node()|@*[not(local-name()='code')]"/>
        </KeyValuePairs>
      </content>
      <store-outputs/>
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
      <process>
		<query>
			 delete from KEYVALUEPAIRS K  where ctn  = '<xsl:value-of select="$objectId"/>'
        </query>
        <xsl:for-each select="KeyValuePair">
			<query>
				  Insert into KEYVALUEPAIRS K (CTN, KEY, VALUE, TYPE, UOM, LASTMODIFIED )
				  values (
					  '<xsl:value-of select="$objectId"/>',
					  '<xsl:value-of select="Key"/>',
					  '<xsl:value-of select="Value"/>',					  
					  '<xsl:value-of select="Type"/>',					  
					  '<xsl:value-of select="UnitOfMeasure"/>',					  
					  to_date('<xsl:value-of select="$masterLastmodifiedTimestamp"/>','yyyy-mm-dd"T"hh24:mi:ss')
				  )
			</query>
		</xsl:for-each>
			 <query>
              insert into octl_relations (OUTPUT_CONTENT_TYPE
                                         ,OUTPUT_LOCALISATION
                                         ,OUTPUT_OBJECT_ID
                                         ,INPUT_CONTENT_TYPE
                                         ,INPUT_LOCALISATION
                                         ,INPUT_OBJECT_ID
                                         ,ISSECONDARY
                                         ,ISDERIVED)
                                  select  'PMT_Master'
                                        ,'master_global'
                                        , '<xsl:value-of select="$objectId"/>'
                                        ,'KeyValuePairs'
                                        ,'master_global'
                                        , '<xsl:value-of select="$objectId"/>'
                                        ,'1'
                                        ,1
                                        from dual
                                        where not exists (select 1
                                            from octl_relations 
                                            where INPUT_CONTENT_TYPE = 'KeyValuePairs' 
                                            and INPUT_LOCALISATION = 'master_global' 
                                            and INPUT_OBJECT_ID =  '<xsl:value-of select="$objectId"/>'
                                            and OUTPUT_CONTENT_TYPE = 'PMT_Master'
                                            and OUTPUT_LOCALISATION = 'master_global'
                                            and OUTPUT_OBJECT_ID = '<xsl:value-of select="$objectId"/>')
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
