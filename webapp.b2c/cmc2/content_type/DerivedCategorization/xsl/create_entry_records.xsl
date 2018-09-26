<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >
  <xsl:param name="ct"/>
  <xsl:param name="l"/>
  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="batchnumber"/>
  <xsl:param name="categorization_catalog">ONECAT</xsl:param>
  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>

  <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
  <xsl:variable name="sourcefile" select="$batchnumber"/>
  <!-- Care Assignments -->
  <xsl:template match="/Categorization[Catalog]">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$sourcefile}" sourcefile="{$sourcefile}" valid="true">
      <process/>
      <globalDocs/>
      <xsl:apply-templates/>
    </entries>
  </xsl:template>
  <!-- -->
  <xsl:template match="/Categorization[mappingrule]">
    <entries ct="{$ct}" l="{$l}" ts="{$ts}" dir="{$dir}" batchnumber="{$sourcefile}" sourcefile="{$sourcefile}" valid="true">
       <xsl:variable name="contentType" select="$ct"/>
    <xsl:variable name="localisation" select="'none'"/>
    <xsl:variable name="masterLastmodifiedTimestamp" select="substring(@DocTimeStamp,1,19)"/>
    <xsl:variable name="objectId" select="CatalogCode"/>
    <entry o="{$objectId}" ct="{$contentType}" l="{$localisation}" valid="true">
      <result>OK</result>
      <content>
      <Catalog>
		<CatalogCode><xsl:value-of select="$objectId"/></CatalogCode>
		<CatalogName><xsl:value-of select="CatalogName"/></CatalogName>
		<CatalogType/>
		<FixedCategorization>
		  <xsl:for-each-group select="mappingrule" group-by="group">
			<Group>
				<GroupCode><xsl:value-of select="current-grouping-key()"/></GroupCode>
				<xsl:for-each-group select="current-group()" group-by="category">
				<Category>
					<CategoryCode><xsl:value-of select="current-grouping-key()"/></CategoryCode>
						<xsl:for-each-group select="current-group()" group-by="subcategory">
							<SubCategory>
								<SubCategoryCode><xsl:value-of select="current-grouping-key()"/></SubCategoryCode>
								<xsl:for-each select="current-group()">
									<CatRef>
										<xsl:copy-of select="catref/@productCatalog"/>
										<xsl:value-of select="catref"/>
									</CatRef>
								</xsl:for-each>
							</SubCategory>
						</xsl:for-each-group>					
				</Category>
				</xsl:for-each-group>
			</Group>					  
		  </xsl:for-each-group>
		  </FixedCategorization>
		  </Catalog>
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
      <process/><!-- This will only be ran when this entry is valid. Therefore, using importExecDelta-->
      <octl-attributes>
        <lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
        <masterlastmodified_ts><xsl:value-of select="$masterLastmodifiedTimestamp"/></masterlastmodified_ts>
        <status>Loaded</status>
      </octl-attributes>	      
	</entry>
    </entries>
  </xsl:template>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->

  <!-- -->
  <xsl:template match="Catalog">
    <xsl:variable name="contentType" select="$ct"/>
    <xsl:variable name="localisation" select="'none'"/>
    <xsl:variable name="masterLastmodifiedTimestamp" select="substring(../@DocTimeStamp,1,19)"/>
    <xsl:variable name="objectId" select="CatalogCode"/>
    <entry o="{$objectId}" ct="{$contentType}" l="{$localisation}" valid="true">
      <result>OK</result>
      <content>
        <xsl:copy copy-namespaces="no">      
          <xsl:apply-templates mode="filtercontent"/>
        </xsl:copy>
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
      <process/><!-- This will only be ran when this entry is valid. Therefore, using importExecDelta-->
      <octl-attributes>
        <lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
        <masterlastmodified_ts><xsl:value-of select="$masterLastmodifiedTimestamp"/></masterlastmodified_ts>
        <status>Loaded</status>
      </octl-attributes>
    </entry>
  </xsl:template>

  <xsl:template match="comment()|ATGCatalog|Group/@*|GroupReferenceName|GroupName|GroupRank|Category/@*|CategoryName|CategoryReferenceName|CategoryRank|SubCategory/@*|SubCategoryName|SubCategoryReferenceName|SubCategoryRank" mode="filtercontent"/>
  
  <xsl:template match="@*|element()" mode="filtercontent">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="filtercontent"/>
    </xsl:copy>
  </xsl:template>  
</xsl:stylesheet>
