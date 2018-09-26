<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:sql="http://apache.org/cocoon/SQL/2.0"
        xmlns:cmc2-f="http://www.philips.com/cmc2-f"
        >

  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="filename"/>
  <xsl:param name="batch"/>
  <xsl:param name="subbatch"/>
  <xsl:param name="seo" select="'no'"/>

  <xsl:include href="../../../../xsl/common/cmc2.function.xsl" />
  
  <xsl:variable name="runts" select="concat(substring($ts,1,4),'-',substring($ts,5,2),'-',substring($ts,7,2),'T',substring($ts,9,2),':',substring($ts,11,2),':',substring($ts,13,2))"/>

  <xsl:template match="Products">
    <entries  ct="{$ct}" l="{@l}" ts="{$ts}" dir="{$dir}" batchnumber="{$batch}" subbatchnumber="{$subbatch}" category="{@category}" division="{@division}" workflow="{@workflow}" seo="{$seo}">
      <xsl:copy-of select="originalentriesattributes"/>
      <xsl:apply-templates select="Product"/>
    </entries>
  </xsl:template>  

  <xsl:template match="Product">
    <xsl:variable name="objectId" select="CTN"/>
    <xsl:variable name="status" select="MarketingStatus"/>
	<xsl:variable name="MarketingVersion" select="MarketingVersion"/>
    <entry o="{$objectId}"  ct="{$ct}" l="{../@targetLocale}" valid="true" resetflagsonfailure="false">
      <result>OK</result>
      <content>
        <xsl:copy-of copy-namespaces="no" select="."/>
      </content>
      <currentlastmodified_ts>
        <sql:execute-query>
          <sql:query name="create_entry_records: 1">
              select to_char(lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts 
                from octl 
               where content_type = '<xsl:value-of select="$ct"/>' 
                 and localisation = '<xsl:value-of select="../@targetLocale"/>' 
                 and object_id    = '<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentlastmodified_ts>
      <currentmasterlastmodified_ts>
        <sql:execute-query>
          <sql:query name="create_entry_records: 2">
              select to_char(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts 
                from octl 
               where content_type = '<xsl:value-of select="$ct"/>' 
                 and localisation = '<xsl:value-of select="../@targetLocale"/>' 
                 and object_id    = '<xsl:value-of select="$objectId"/>'
          </sql:query>
        </sql:execute-query>
      </currentmasterlastmodified_ts>   
      <currentcontent>
        <!-- Take the energy class of the PMT_Localised content, since PMT_Translated exports only one locale per language -->
        <xsl:sequence select="cmc2-f:get-octl-sql($objectId, 'PMT_Localised', concat('master_', substring(../@targetLocale, 4)))" />
      </currentcontent>
      <newcontent/>
      <process/>
      <octl-attributes>
        <lastmodified_ts><xsl:value-of select="@lastModified"/></lastmodified_ts>
        <masterlastmodified_ts><xsl:value-of select="@masterLastModified"/></masterlastmodified_ts>
        <currentpmtlocalisedmasterlastmodified_ts>
          <sql:execute-query>
            <sql:query name="create_entry_records: 3">
                select to_char(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts 
                  from octl 
                 where content_type = 'PMT_Localised' 
                   and localisation = '<xsl:value-of select="concat('master_',substring-after(../@targetLocale,'_'))"/>' 
                   and object_id    = '<xsl:value-of select="$objectId"/>'
            </sql:query>
          </sql:execute-query>
        </currentpmtlocalisedmasterlastmodified_ts>
        <counterpartstatus>
          <sql:execute-query>
            <sql:query name="create_entry_records: 4">
                select workflow, valid, result
                  from octl_translations 
                 where content_type = '<xsl:value-of select="$ct"/>' 
                   and localisation = '<xsl:value-of select="../@targetLocale"/>' 
                   and object_id    = '<xsl:value-of select="$objectId"/>'
                   and masterlastmodified_ts = to_date('<xsl:value-of select="@masterLastModified"/>','yyyy-mm-dd"T"hh24:mi:ss')
                   and lastmodified_ts       = to_date('<xsl:value-of select="@lastModified"/>','yyyy-mm-dd"T"hh24:mi:ss')
            </sql:query>
          </sql:execute-query>
        </counterpartstatus>            
        <remark><xsl:value-of select="$filename"/></remark>
        <status><xsl:value-of select="$status"/></status>
        <marketingversion><xsl:value-of select="$MarketingVersion"/></marketingversion>
        <needsprocessing_flag><xsl:value-of select="'-1'"/></needsprocessing_flag>
      </octl-attributes>
    </entry>      
  </xsl:template>  

  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

</xsl:stylesheet>
