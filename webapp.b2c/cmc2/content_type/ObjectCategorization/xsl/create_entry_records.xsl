<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batchnumber"/>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>

  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <xsl:variable name="sourcefile" select="$batchnumber"/>
  
  <!-- SPLIT Internal CatTree -->
  <xsl:template match="/object[categorizations/internal-categorization]">
    <xsl:variable name="l" select="'none'"/>
    <xsl:variable name="masterLastmodifiedTimestamp" select="substring(@DocTimeStamp,1,19)"/>
    <xsl:variable name="objectId" select="id"/>    
    <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$sourcefile}" valid="true">
      <process/>
      <globalDocs/>      
      <entry o="{$objectId}" ct="{$ct}" l="{$l}" valid="true">
        <result>OK</result>
        <content>
          <object>
            <id><xsl:value-of select="$objectId"/></id>
            <xsl:copy-of select="categorizations"/>
          </object>
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
        <process>
          <query>
            update CUSTOMER_LOCALE_EXPORT CLE
               set lasttransmit = to_date('19000101','YYYYMMDD')
                  ,remark =  'LASTTRANSMIT set to 19000101 by OBJECTCATEGORIZATION on ' 
                           || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') 
                           || '. PREVIOUS LASTTRANSMIT ' 
                           || lasttransmit
             where ctn = '<xsl:value-of select="$objectId"/>'
               and customer_id = 'AtgMerchandise'        
          </query>
        </process>
        <octl-attributes>
          <lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
          <masterlastmodified_ts><xsl:value-of select="$masterLastmodifiedTimestamp"/></masterlastmodified_ts>
          <status>Loaded</status>
        </octl-attributes>
      </entry>
    </entries>
  </xsl:template>  
  
  <!-- Internal CatTree -->
  <xsl:template match="/Categorization[not(Catalog/CatalogCode = 'CARE')]">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$sourcefile}" valid="true">
      <process/>
      <globalDocs/>
      <xsl:apply-templates mode="InternalCategorization"/>
    </entries>
  </xsl:template>
  <!-- ProductTree -->
  <xsl:template match="/ProductTree">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$sourcefile}" valid="true">
      <process/>
      <globalDocs/>
      <xsl:apply-templates mode="ProductTree"/>
    </entries>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()" mode="ProductTree">
    <xsl:apply-templates mode="ProductTree"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="Product" mode="ProductTree">
    <xsl:variable name="contentType" select="$ct"/>
    <xsl:variable name="localisation" select="'none'"/>
    <xsl:variable name="masterLastmodifiedTimestamp" select="substring(../../../../../../../@DocTimeStamp,1,19)"/>
    <xsl:variable name="objectId" select="."/>
    <xsl:variable name="groupcodeelement" select="'BusinessUnitCode'"/>
    <xsl:variable name="categorycodeelement" select="'MainArticleGroupCode'"/>
    <xsl:variable name="subcategorycodeelement" select="'ArticleGroupCode'"/>
    <entry o="{$objectId}" ct="{$contentType}" l="{$localisation}" valid="true">
      <result>OK</result>
      <!-- No content will be stored in the CLOB for ProductTree entries -->
      <content/>
      <!-- Force execProcessSQL to run the SQL regardless of the entry status -->
      <process/>
      <!-- No octl attributes required -->
      <octl-attributes/>
    </entry>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()" mode="InternalCategorization">
    <xsl:apply-templates mode="InternalCategorization"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="Product" mode="InternalCategorization">
    <!-- the content type will not be known in the file so is passed in-->
    <xsl:variable name="contentType" select="$ct"/>
    <!-- the localisation may be detwermined by the item being processed - for eg translation inport or is hard coded. In this case it is aways master_global -->
    <xsl:variable name="localisation" select="'none'"/>
    <xsl:variable name="masterLastmodifiedTimestamp" select="substring(../../../../../../@DocTimeStamp,1,19)"/>
    <xsl:variable name="objectId" select="."/>
    <entry o="{$objectId}" ct="{$contentType}" l="{$localisation}" valid="true">
      <result>OK</result>
      <content>
        <object>
          <id><xsl:value-of select="$objectId"/></id>
          <categorizations>
            <internal-categorization>
              <GroupCode><xsl:value-of select="../../../GroupCode"/></GroupCode>
              <CategoryCode><xsl:value-of select="../../CategoryCode"/></CategoryCode>
              <SubCategoryCode><xsl:value-of select="../SubCategoryCode"/></SubCategoryCode>
            </internal-categorization>
          </categorizations>
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
      <process><!-- This will only be ran when this entry is valid. Therefore, using importExecDelta-->
        <!-- For now, also delete any corresponding ATGMerchandise records in the CLE table for this object_id, in case this is a delete rather than a move -->
        <query>
          update CUSTOMER_LOCALE_EXPORT CLE
             set lasttransmit = to_date('19000101','YYYYMMDD')
                ,remark =  'LASTTRANSMIT set to 19000101 by OBJECTCATEGORIZATION on ' 
                         || to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') 
                         || '. PREVIOUS LASTTRANSMIT ' 
                         || lasttransmit
           where ctn = '<xsl:value-of select="$objectId"/>'
             and customer_id = 'AtgMerchandise'        
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
