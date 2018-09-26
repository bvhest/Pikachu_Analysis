<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:my="http://www.philips.com/pika" >
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:function name="my:ora" as="xs:string" >
		<xsl:param name="value"/>
		<xsl:variable name="q">'</xsl:variable>
		<xsl:variable name="o">'||chr(39)||'</xsl:variable>
	<xsl:sequence select="replace($value,$q,$o)"/>
	</xsl:function>

<xsl:template match="test">
	<xsl:copy copy-namespaces="no">
		<xsl:variable name="txt">hello john's world's</xsl:variable>
			'<xsl:value-of select="my:ora($txt)"/>'
	</xsl:copy>
</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- cleans content following call to get service -->
	<xsl:template match="octl|sql:rowset|sql:row|sql:data">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<xsl:template match="sql:*"/>
	
	<xsl:template match="@*|node()" mode="insertTree">
		<xsl:param name="lm"/>
		<xsl:apply-templates select="@*|node()" mode="insertTree">
			<xsl:with-param name="lm" select="$lm"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="SubCategory" mode="insertTree" >
		<xsl:param name="lm"/>
		<!-- insert group="{../../../../../../GroupCode}" category="{../../../../../CategoryCode}" subcategory="{SubCategoryCode}"/ -->
		<query>				
		insert into localized_subcat 
(locale, catalogcode,  catalogname, 
grouptype, groupshortcode, groupseoname,
groupcode, grouprefname, groupname, grouprank,
categorytype, categoryseoname,
categorycode, categoryrefname, categoryname, categoryrank,
l3code, l3refname, l3name, l3rank, 
l4code, l4refname, l4name, l4rank, 
l5code, l5refname, l5name, l5rank, 
l6code, l6refname, l6name, l6rank,
subcategorytype, subcategoryseoname, 
subcategorycode, subcategoryrefname, subcategoryname, subcategoryrank,  lastmodified ) values (
'<xsl:value-of select="ancestor::sql:row/sql:localisation"/>',
'<xsl:value-of select="ancestor::Catalog/CatalogCode"/>',
'<xsl:value-of select="ancestor::Catalog/CatalogName"/>',
'<xsl:value-of select="ancestor::Group/@type"/>',
'<xsl:value-of select="ancestor::Group/GroupShortCode"/>',
'<xsl:value-of select="ancestor::Group/GroupSeoName"/>',
'<xsl:value-of select="ancestor::Group/GroupCode"/>',
'<xsl:value-of select="my:ora(ancestor::Group/GroupReferenceName)"/>',
'<xsl:value-of select="my:ora(ancestor::Group/GroupName)"/>',
'<xsl:value-of select="ancestor::Group/GroupRank"/>',
'<xsl:value-of select="ancestor::Category/@type"/>',
'<xsl:value-of select="ancestor::Category/CategorySeoName"/>',
'<xsl:value-of select="ancestor::Category/CategoryCode"/>',
'<xsl:value-of select="my:ora(ancestor::Category/CategoryReferenceName)"/>',
'<xsl:value-of select="my:ora(ancestor::Category/CategoryName)"/>',
'<xsl:value-of select="ancestor::Category/CategoryRank"/>',
'<xsl:value-of select="ancestor::L3/L3Code"/>',
'<xsl:value-of select="my:ora(ancestor::L3/L3ReferenceName)"/>',
'<xsl:value-of select="my:ora(ancestor::L3/L3Name)"/>',
'<xsl:value-of select="ancestor::L3/L3Rank"/>',
'<xsl:value-of select="ancestor::L4/L4Code"/>',
'<xsl:value-of select="my:ora(ancestor::L4/L4ReferenceName)"/>',
'<xsl:value-of select="my:ora(ancestor::L4/L4Name)"/>',
'<xsl:value-of select="ancestor::L4/L4Rank"/>',
'<xsl:value-of select="ancestor::L5/L5Code"/>',
'<xsl:value-of select="my:ora(ancestor::L5/L5ReferenceName)"/>',
'<xsl:value-of select="my:ora(ancestor::L5/L5Name)"/>',
'<xsl:value-of select="ancestor::L5/L5Rank"/>',
'<xsl:value-of select="ancestor::L6/L6Code"/>',
'<xsl:value-of select="my:ora(ancestor::L6/L6ReferenceName)"/>',
'<xsl:value-of select="my:ora(ancestor::L6/L6Name)"/>',
'<xsl:value-of select="ancestor::L6/L6Rank"/>',
'<xsl:value-of select="@type"/>',
'<xsl:value-of select="SubCategorySeoName"/>',
'<xsl:value-of select="SubCategoryCode"/>',
'<xsl:value-of select="my:ora(SubCategoryReferenceName)"/>',
'<xsl:value-of select="my:ora(SubCategoryName)"/>',
'<xsl:value-of select="SubCategoryRank"/>',
 to_date('<xsl:value-of select="$lm"/>','YYYY-MM-DD"T"HH24:MI:SS') 
 )
		</query>
	</xsl:template>	
	
	<xsl:template match="ChildProducts|Products" mode="insertTree" />
	
	
	<xsl:template match="process[../@valid='true']">
		<process>
			<xsl:variable name="lm" select="../octl-attributes/lastmodified_ts"/>
			<!-- Delete existing -->
			<query>
          delete from localized_subcat
          where locale = '<xsl:value-of select="../content/octl/sql:rowset/sql:row/sql:localisation"/>'
          and catalogcode = '<xsl:value-of select="../content/octl/sql:rowset/sql:row/sql:object_id"/>'
			</query>
			
		<xsl:apply-templates select="../content/octl/sql:rowset/sql:row/sql:data" mode="insertTree">
			<xsl:with-param name="lm" select="$lm"/>
		</xsl:apply-templates>
		
  
		</process>
	</xsl:template>
	<!-- process octl attributes -->
	<xsl:template match="octl-attributes[../@valid='true']">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()[not(local-name()='masterlastmodified_ts' or local-name()='status')]"/>
			<xsl:element name="masterlastmodified_ts">
				<xsl:value-of select="../content/octl/sql:rowset/sql:row/sql:masterlastmodified_ts"/>
			</xsl:element>
			<xsl:element name="status">
				<xsl:value-of select="../content/octl/sql:rowset/sql:row/sql:status"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
