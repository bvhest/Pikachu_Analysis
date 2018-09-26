<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" xmlns:my="http://www.philips.com/pika">
	<xsl:param name="ct"/>
	<xsl:param name="l"/>
	<xsl:param name="ts"/>
	<xsl:param name="dir"/>
	<xsl:param name="batchnumber"/>
	<xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
	<!-- -->
	<xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)"/>
	<!-- -->
	<xsl:function name="my:ora" as="xs:string" >
		<xsl:param name="value"/>
		<xsl:variable name="q">'</xsl:variable>
		<xsl:variable name="o">'||chr(39)||'</xsl:variable>
	<xsl:sequence select="replace($value,$q,$o)"/>
	</xsl:function>
	<!-- -->
	<xsl:template match="@*|node()" mode="copyTree">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="copyTree"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Skip empty nodes -->
	<xsl:template match="Product|ChildProducts" mode="copyTree"/>
	
	
	<xsl:template match="@*|node()" mode="insertTree">	
		<xsl:apply-templates select="@*|node()" mode="insertTree"/>
	</xsl:template>

	<xsl:template match="SubCategory" mode="insertTree" >
		<query key="{concat(../../../../../../GroupCode,'_', ../../../../../CategoryCode,'_',../../../../L3Code, '_',SubCategoryCode)}" >				
		insert into categorization 
(catalogcode, catalogname, 
pdcode, pdname, pdrank,
bgroupcode, bgroupname, bgrouprank,
grouptype, groupcode, groupshortcode, groupseoname, grouprefname, groupname, grouprank,
categorytype, categorycode, categoryseoname, categoryrefname, categoryname, categoryrank,
l3code, l3refname, l3name, l3rank, 
l4code, l4refname, l4name, l4rank, 
l5code, l5refname, l5name, l5rank, 
l6code, l6refname, l6name, l6rank, 
subcategorytype, subcategorycode, subcategoryseoname, subcategoryrefname, subcategoryname, subcategoryrank, subcategory_status,
relatedsubcat ) values (
'<xsl:value-of select="../../../../../../../../../../CatalogCode"/>',
'<xsl:value-of select="../../../../../../../../../../CatalogName"/>',
'<xsl:value-of select="../../../../../../../../ProductDivisionCode"/>',
'<xsl:value-of select="../../../../../../../../ProductDivisionName"/>',
'<xsl:value-of select="../../../../../../../../ProductDivisionRank"/>',
'<xsl:value-of select="../../../../../../../BusinessGroupCode"/>',
'<xsl:value-of select="../../../../../../../BusinessGroupName"/>',
'<xsl:value-of select="../../../../../../../BusinessGroupRank"/>',
'<xsl:value-of select="../../../../../../@type"/>',
'<xsl:value-of select="../../../../../../GroupCode"/>',
'<xsl:value-of select="../../../../../../GroupShortCode"/>',
'<xsl:value-of select="../../../../../../GroupSeoName"/>',
'<xsl:value-of select="my:ora(../../../../../../GroupReferenceName)"/>',
'<xsl:value-of select="my:ora(../../../../../../GroupName)"/>',
'<xsl:value-of select="../../../../../../GroupRank"/>',
'<xsl:value-of select="../../../../../@type"/>',
'<xsl:value-of select="../../../../../CategoryCode"/>',
'<xsl:value-of select="../../../../../CategorySeoName"/>',
'<xsl:value-of select="my:ora(../../../../../CategoryReferenceName)"/>',
'<xsl:value-of select="my:ora(../../../../../CategoryName)"/>',
'<xsl:value-of select="../../../../../CategoryRank"/>',
'<xsl:value-of select="../../../../L3Code"/>',
'<xsl:value-of select="my:ora(../../../../L3ReferenceName)"/>',
'<xsl:value-of select="my:ora(../../../../L3Name)"/>',
'<xsl:value-of select="../../../../L3Rank"/>',
'<xsl:value-of select="../../../L4Code"/>',
'<xsl:value-of select="my:ora(../../../L4ReferenceName)"/>',
'<xsl:value-of select="my:ora(../../../L4Name)"/>',
'<xsl:value-of select="../../../L4Rank"/>',
'<xsl:value-of select="../../L5Code"/>',
'<xsl:value-of select="my:ora(../../L5ReferenceName)"/>',
'<xsl:value-of select="my:ora(../../L5Name)"/>',
'<xsl:value-of select="../../L5Rank"/>',
'<xsl:value-of select="../L6Code"/>',
'<xsl:value-of select="my:ora(../L6ReferenceName)"/>',
'<xsl:value-of select="my:ora(../L6Name)"/>',
'<xsl:value-of select="../L6Rank"/>',
'<xsl:value-of select="@type"/>',
'<xsl:value-of select="SubCategoryCode"/>',
'<xsl:value-of select="SubCategorySeoName"/>',
'<xsl:value-of select="my:ora(SubCategoryReferenceName)"/>',
'<xsl:value-of select="my:ora(SubCategoryName)"/>',
'<xsl:value-of select="SubCategoryRank"/>',
'<xsl:value-of select="@status"/>',
null)
		</query>
	</xsl:template>
	
	
	<xsl:template match="ChildProducts|Products" mode="insertTree" />
	
	<xsl:template match="/Categorization">
		<entries ct="{$ct}" l="none" ts="{$ts}" dir="{$dir}" batchnumber="{replace($batchnumber,' ','')}">
			<process/>
			<globalDocs/>
			<xsl:apply-templates select="Catalog"/>
		</entries>
	</xsl:template>
	<!-- -->
	<xsl:template match="Catalog">
		<xsl:if test="CatalogCode != '' and ./FixedCategorization/ProductDivision">
		<xsl:variable name="objectId" select="CatalogCode"/>
		<xsl:variable name="masterLastmodifiedTimestamp" select="../@DocTimeStamp"/>
		<entry o="{$objectId}" ct="{$ct}" l="none" valid="true">
			<result>OK</result>
			<content>
				<Categorization DocTimestamp="{../@DocTimeStamp}">
					<Catalog>
						<xsl:apply-templates select="@*" mode="copyTree"/>
						<xsl:apply-templates select="node()" mode="copyTree"/>
					</Catalog>
				</Categorization>
			</content>
			<currentmasterlastmodified_ts>
				<sql:execute-query>
					<sql:query>
                select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                  from octl
                 where content_type='<xsl:value-of select="$ct"/>'
                   and localisation='none'
                   and object_id='<xsl:value-of select="$objectId"/>'
              </sql:query>
				</sql:execute-query>
			</currentmasterlastmodified_ts>
			<process>
				<query>
DELETE FROM CATEGORIZATION WHERE catalogcode = '<xsl:value-of select="$objectId"/>'
                </query>
					<xsl:apply-templates select="@*|node()" mode="insertTree"/>
			</process>
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
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
