<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    extension-element-prefixes="cmc2-f">
  
  <xsl:param name="ct" />
  <xsl:param name="l" />
  <xsl:param name="ts" />
  <xsl:param name="dir" />
  <xsl:param name="batchnumber" />
  <xsl:include href="../../../xsl/common/cmc2.function.xsl" />
  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />


  <!-- ObjectAssetList   C O N T E N T  T Y P E    master_global -->
  <xsl:template match="Object">
    <xsl:variable name="docTimestamp" select="../@docTimestamp" />
    <xsl:variable name="masterLastmodifiedTimestamp">
      <xsl:analyze-string select="$docTimestamp" regex="^(..)/(..)/(..)T(........).*$">
        <xsl:matching-substring>
          <value>
            <xsl:value-of select="concat( '20',regex-group(3),'-',regex-group(1),'-',regex-group(2),'T',regex-group(4) )" />
          </value>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <!-- assume alternative date format -->
          <value>
            <xsl:value-of select="$docTimestamp" />
          </value>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <!-- the content type will not be known in the file so is passed in-->
    <xsl:variable name="objectId" select="ObjectID" />
    <xsl:variable name="contentType" select=" 'ObjectAssetList' " />
    <xsl:variable name="localisation" select=" 'master_global' " />
    <xsl:if test="Asset[Language = ''
                        or Language='en_Philips'
                        or (Language = 'en_US' and ResourceType=('GLL', 'MSD', 'WRN', 'DOC', 'INI', 'SMA', 'L3D',  'CER') )
                        or (Language = 'en_US' and ResourceType='PSS')][Publisher!='ProCoon']">
      <entry o="{$objectId}" ct="{$contentType}" l="{$localisation}" valid="true">
        <result>OK</result>
        <content>
          <object>
            <id>
              <xsl:value-of select="$objectId" />
            </id>
            <!--
              xsl:copy-of select="Asset[Language = '' or Language='en_Philips' or (Language = 'en_US' and
              ResourceType='GLL') or (Language = 'en_US' and ResourceType='PSS')][Publisher!='ProCoon'] "/
            -->
            <xsl:for-each select="Asset[License!='Obsolete'][Language = ''
                                                             or Language='en_Philips'
                                                             or (Language = 'en_US' and ResourceType=('GLL', 'MSD', 'WRN', 'DOC', 'INI', 'SMA', 'L3D', 'CER'))
                                                             or (Language = 'en_US' and ResourceType='PSS')][Publisher!='ProCoon']">
              <xsl:sort select="ResourceType" order="ascending" />
              <xsl:sort select="Language" order="ascending" />
              <xsl:copy-of copy-namespaces="no" select="." />
            </xsl:for-each>
          </object>
        </content>
        <currentmasterlastmodified_ts>
          <sql:execute-query>
            <sql:query>
              select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
              from octl where content_type='<xsl:value-of select="$contentType" />'
              and localisation='<xsl:value-of select="$localisation" />'
              and object_id='<xsl:value-of select="$objectId" />'
            </sql:query>
          </sql:execute-query>
        </currentmasterlastmodified_ts>
        <currentlastmodified_ts />
        <process />
        <!-- This will only be ran when this entry is valid. Therefore, using importExecDelta-->
        <octl-attributes>
          <lastmodified_ts>
            <xsl:value-of select="$processTimestamp" />
          </lastmodified_ts>
          <masterlastmodified_ts>
            <xsl:value-of select="$masterLastmodifiedTimestamp/value" />
          </masterlastmodified_ts>
          <status>Loaded</status>
        </octl-attributes>
      </entry>
    </xsl:if>

    <!-- ObjectAssetList  C O N T E N T  T Y P E  localised  -->
    <xsl:for-each-group select="Asset[string-length(Language) = 5 and not(ResourceType=('GLL', 'MSD', 'WRN', 'DOC', 'INI', 'SMA', 'L3D' , 'CER') ) ][Publisher!='ProCoon'] "
        group-by="Language">
      <xsl:variable name="contentType" select=" 'ObjectAssetList' " />
      <xsl:variable name="localisation" select="current-grouping-key()" />
      <entry o="{$objectId}" ct="{$contentType}" l="{$localisation}" valid="true">
        <result>OK</result>
        <content>
          <object>
            <id>
              <xsl:value-of select="$objectId" />
            </id>
            <xsl:for-each select="current-group()[License!='Obsolete']">
              <xsl:sort select="ResourceType" order="ascending" />
              <xsl:copy-of copy-namespaces="no" select="." />
            </xsl:for-each>
          </object>
        </content>
        <currentmasterlastmodified_ts>
          <sql:execute-query>
            <sql:query>
              select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
              from octl where content_type='<xsl:value-of select="$contentType" />'
              and localisation='<xsl:value-of select="$localisation" />'
              and object_id='<xsl:value-of select="$objectId" />'
            </sql:query>
          </sql:execute-query>
        </currentmasterlastmodified_ts>
        <currentlastmodified_ts />
        <process />
        <!-- This will only be ran when this entry is valid. Therefore, using importExecDelta-->
        <octl-attributes>
          <lastmodified_ts>
            <xsl:value-of select="$processTimestamp" />
          </lastmodified_ts>
          <masterlastmodified_ts>
            <xsl:value-of select="$masterLastmodifiedTimestamp/value" />
          </masterlastmodified_ts>
          <status>Loaded</status>
        </octl-attributes>
      </entry>
    </xsl:for-each-group>
  </xsl:template>

</xsl:stylesheet>
