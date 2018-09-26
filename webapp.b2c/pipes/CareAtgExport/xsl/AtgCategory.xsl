<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:my="http://www.philips.com/pika" extension-element-prefixes="my">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:function name="my:atgNULL">
		<xsl:param name="id"/>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$id='x'">__NULL__</xsl:when>
				<xsl:when test="not($id)">__NULL__</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$id"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:sequence select="$result"/>
	</xsl:function>
	
	<xsl:function name="my:normalized-id" as="xs:string">
		<xsl:param name="id"/>
		<xsl:value-of select="translate($id,'/-. ','___')"/>
	</xsl:function>	
	
	<xsl:template name="translations">
		<xsl:param name="level"/>
		<xsl:param name="locale"/>
		<xsl:param name="country"/>
		<xsl:for-each select="sql:rowset[@name='translation']/sql:row">
			<xsl:if test="sql:level_=$level">	
				<xsl:variable name="catalogLocale" select="concat($locale  ,'_',sql:catalogcode)"/>
				<xsl:variable name="catalog" select="concat($country  ,'_',sql:catalogcode)"/>
				<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="category-translation" id="{concat(sql:code,'_',$catalogLocale)}">	
					<set-property name="marketingHeader">__NULL__</set-property>
					<set-property name="displayName">
						<xsl:value-of select="sql:displayname"/>
					</set-property>
					<set-property name="marketingBody">__NULL__</set-property>
				</add-item>
			</xsl:if>
		</xsl:for-each>	
	</xsl:template>
	
	<xsl:template name="categories">
		<xsl:param name="level"/>
		<xsl:param name="locale"/>
		<xsl:param name="country"/>		
		<xsl:for-each select="sql:rowset[@name='cat']/sql:row">
			<xsl:if test="sql:level_=$level">			
				<xsl:variable name="catalogLocale" select="concat($locale  ,'_',sql:catalogcode)"/>
				<xsl:variable name="catalog" select="concat($country  ,'_',sql:catalogcode)"/>
				<add-item repository="/atg/commerce/catalog/ProductCatalog" item-descriptor="category" id="{concat(sql:code,'_',$catalog)}">
					<set-property name="fixedChildCategories">
						<xsl:value-of select="sql:fixedchildcategories"/>
					</set-property>
					<set-property name="translations" add="true">
						<xsl:value-of select="concat($catalogLocale,'=',sql:code,'_',$catalogLocale)"/>
					</set-property>
					<set-property name="fixedChildProducts">
						<xsl:value-of select="my:normalized-id(sql:fixedchildproducts)"/>
					</set-property>
					<set-property name="code">
						<xsl:value-of select="sql:code"/>
					</set-property>
					<set-property name="displaySequenceNumber"><xsl:value-of select="sql:rank"/></set-property>
				</add-item>
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>
		
	
	<xsl:template match="/Categorisation">
		<xsl:variable name="locale" select="@Locale"/>
		<xsl:variable name="country" select="@Country"/>	
		<gsa-template>
			<import-items>
				<xsl:call-template name="translations">
					<xsl:with-param name="locale" select="$locale"/>
					<xsl:with-param name="country" select="$country"/>
					<xsl:with-param name="level"  select="3"/>
				</xsl:call-template>			
				<xsl:call-template name="categories">
					<xsl:with-param name="locale" select="$locale"/>
					<xsl:with-param name="country" select="$country"/>
					<xsl:with-param name="level"  select="3"/>
				</xsl:call-template>								
				<xsl:call-template name="translations">
					<xsl:with-param name="locale" select="$locale"/>
					<xsl:with-param name="country" select="$country"/>
					<xsl:with-param name="level"  select="2"/>
				</xsl:call-template>				
				<xsl:call-template name="categories">
					<xsl:with-param name="locale" select="$locale"/>
					<xsl:with-param name="country" select="$country"/>
					<xsl:with-param name="level"  select="2"/>
				</xsl:call-template>									
				<xsl:call-template name="translations">
					<xsl:with-param name="locale" select="$locale"/>
					<xsl:with-param name="country" select="$country"/>
					<xsl:with-param name="level"  select="1"/>
				</xsl:call-template>				
				<xsl:call-template name="categories">
					<xsl:with-param name="locale" select="$locale"/>
					<xsl:with-param name="country" select="$country"/>
					<xsl:with-param name="level"  select="1"/>
				</xsl:call-template>					
			</import-items>
		</gsa-template>
	</xsl:template>
</xsl:stylesheet>
