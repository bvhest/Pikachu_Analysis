<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f" >
	<xsl:param name="ct"/>
	<xsl:param name="l"/>
	<xsl:param name="ts"/>
	<xsl:param name="dir"/>
	<xsl:param name="batchnumber"/>
	<xsl:include href="../../../xsl/common/cmc2.function.xsl"/>

	<xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />

	<xsl:template match="/">
			<xsl:apply-templates select="Products/Product"/>
	</xsl:template>

	<xsl:template match="Product">
		<!-- the content type will not be known in the file so is passed in-->
		<xsl:variable name="contentType" select="$ct"/>
		<!-- the localisation may be detwermined by the item being processed - for eg translation inport or is hard coded. In this case it is aways master_global -->
		<xsl:variable name="localisation" select="'none'"/>
		<xsl:variable name="masterLastmodifiedTimestamp" select="substring(@lastModified,1,19)"/>
		<xsl:variable name="objectId" select="CTN"/>
		<xsl:variable name="status" select="MarketingStatus"/>
    <xsl:variable name="productType" select="if(ProductType!='') then upper-case(ProductType) else 'NORMAL'"/>
  <!--
		<xsl:variable name="division">
			<xsl:choose>
				<xsl:when test="ProductDivision/ProductDivisionCode = '3400'">CE</xsl:when>
				<xsl:when test="ProductDivision/ProductDivisionCode = '0300'">DAP</xsl:when>
        <xsl:when test="ProductDivision/ProductDivisionCode = '0200'">CLS</xsl:when>
        <xsl:otherwise>CLS</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
  -->
    <!--
      Hot fix for merging products into one division CLS in source systems.
      Extra FormerPDCode contains the legacy division code.
      If a product is sent without FormerPDCOde it will not be imported.
    -->
    <xsl:variable name="division">
      <xsl:choose>
        <xsl:when test="ProductDivision/FormerPDCode = '3400'">CE</xsl:when>
        <xsl:when test="ProductDivision/FormerPDCode = '0300'">DAP</xsl:when>
        <xsl:when test="ProductDivision/FormerPDCode = '0100'">Lighting</xsl:when>        
      </xsl:choose>
    </xsl:variable>

		<xsl:variable name="brand" select="BrandCode"/>
		<entry o="{$objectId}" ct="{$contentType}" l="{$localisation}">
      <xsl:attribute name="valid">
        <xsl:choose>
          <xsl:when test="$division ne ''">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$division ne ''">
    			<result>OK</result>
        </xsl:when>
        <xsl:otherwise>
          <result>Missing ProductDivision/FormerPDCode in product data</result>
        </xsl:otherwise>
      </xsl:choose>
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
			<currentlastmodified_ts/>
			<process>
				<query>
					<!-- only update if not identical; otherwise we leave the row looking like there was not a valid import -->
					MERGE INTO object_master_data omd
					USING (SELECT '<xsl:value-of select="$objectId"/>' object_id,
					'<xsl:value-of select="$division"/>' division,
					'<xsl:value-of select="$brand"/>' brand,
					'Product' object_type,
					'<xsl:value-of select="$productType"/>' product_type,
					'<xsl:value-of select="$objectId"/>' display_name,
					'<xsl:value-of select="$objectId"/>' reference_name
					FROM dual) x
					ON (omd.object_id = x.object_id)
					WHEN MATCHED THEN
					  UPDATE SET omd.division = x.division, omd.brand = x.brand, omd.object_type = x.object_type, omd.display_name = x.display_name, omd.reference_name = x.reference_name, omd.product_type = x.product_type

					WHEN NOT MATCHED THEN
					  INSERT (omd.object_id, omd.division, omd.brand, omd.object_type, omd.display_name, omd.reference_name, omd.product_type)
					  VALUES  (x.object_id, x.division, x.brand, x.object_type, x.display_name, x.reference_name, x.product_type)
				</query>				
			</process>
			<octl-attributes>
				<lastmodified_ts><xsl:value-of select="$processTimestamp"/></lastmodified_ts>
				<masterlastmodified_ts><xsl:value-of select="$masterLastmodifiedTimestamp"/></masterlastmodified_ts>
				<status><xsl:value-of select="$status"/></status>
			</octl-attributes>
		</entry>
	</xsl:template>

</xsl:stylesheet>
