<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >

  <xsl:param name="customer_id" select="''"/>
  <!-- -->
  <xsl:template match="@*|node()" mode="#all">  
    <xsl:apply-templates select="@*|node()" mode="#current"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="/">
  <root>
      <xsl:apply-templates select="@*|node()"/>
	  
	  <xsl:for-each select="Catalogs/Catalog">
		  <xsl:variable name="CatalogType">
			<xsl:value-of select="@CatalogTypeName"/>
		  </xsl:variable>
		  <xsl:variable name="Country">
			<xsl:value-of select="@Country"/>
		  </xsl:variable>
			<xsl:for-each select="CatalogProduct">
				<xsl:variable name="conditioned_catalogs" select="'SHOPPUB,SHOPEMP'"/>
				<xsl:if test="contains($conditioned_catalogs, $CatalogType)">
					<xsl:if test="@ClearanceInd != '' and @VisibilityInd != ''">
					  <sql:execute-query>
						<sql:query>
							delete from VISIBILITY_CLEARANCE vc where vc.ctn = '<xsl:value-of select="@CTN"/>' and 
							vc.catalogtype = '<xsl:value-of select="$CatalogType"/>' and vc.country = '<xsl:value-of select="$Country"/>'
						</sql:query>
					  </sql:execute-query>
					  <sql:execute-query>
						<sql:query>
							INSERT INTO VISIBILITY_CLEARANCE (CTN, VISIBILITY, CLEARANCE, ACTION, COUNTRY, CATALOGTYPE) VALUES ('<xsl:value-of select="@CTN"/>', '<xsl:value-of select="@VisibilityInd"/>', '<xsl:value-of select="@ClearanceInd"/>', '<xsl:value-of select="@Action"/>', '<xsl:value-of select="$Country"/>', '<xsl:value-of select="$CatalogType"/>' )
						</sql:query>
					  </sql:execute-query>
				   </xsl:if>
				</xsl:if>
			</xsl:for-each>
		  
		</xsl:for-each>
      </root>
  </xsl:template>  
  <!-- -->  
  <xsl:template match="catalog-definition"> <!-- care master file -->
    <xsl:apply-templates select="object">  
      <xsl:with-param name="timestamp" select="@DocTimeStamp"/>
    </xsl:apply-templates>
  </xsl:template>  
  <!-- -->    
  <xsl:template match="catalogs"> <!-- lcb file -->
    <xsl:apply-templates select="catalog" mode="LCB">  
      <xsl:with-param name="timestamp" select="@timestamp"/>
    </xsl:apply-templates>
  </xsl:template>  
  <!-- -->    
  <xsl:template match="Catalogs"> <!-- ccb file -->
    <xsl:apply-templates select="Catalog" mode="CCB">  
      <xsl:with-param name="timestamp" select="@Timestamp"/>
    </xsl:apply-templates>
  </xsl:template>  
  <!-- -->      
  <xsl:template match="catalog" mode="LCB">
    <xsl:param name="timestamp"/>
    <xsl:apply-templates select="CatalogProduct" mode="LCB">
      <xsl:with-param name="timestamp"       select="$timestamp"/>
      <xsl:with-param name="catalogId"       select="concat(@catalogTypeName,'_',@countryCode,'_Catalog')"/>
      <xsl:with-param name="catalogTypeName" select="@catalogTypeName"/>
      <xsl:with-param name="countryCode"     select="@countryCode"/>
      <xsl:with-param name="productDivisionCode" select="if(@productDivisionCode='0200') then 'CLS' else if(@productDivisionCode='0100') then 'Lighting' else ''"/>
      <xsl:with-param name="currencyCode"    select="@currencyCode"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- -->      
  <xsl:template match="Catalog" mode="CCB">
    <xsl:param name="timestamp"/>
    <xsl:apply-templates select="CatalogProduct" mode="CCB">
      <xsl:with-param name="timestamp"       select="$timestamp"/>
      <xsl:with-param name="catalogId"       select="concat(@CatalogTypeName,'_',@Country,'_Catalog')"/>
      <xsl:with-param name="catalogTypeName" select="@CatalogTypeName"/>
      <xsl:with-param name="countryCode"     select="@Country"/>
      <xsl:with-param name="productDivisionCode" select="if(@ProductDivisionCode='0200') then 'CLS' else if(@ProductDivisionCode='0100') then 'Lighting' else ''"/>
      <xsl:with-param name="currencyCode"    select="@Currency"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- -->      
  <xsl:template match="CatalogProduct" mode="LCB">
    <xsl:param name="timestamp"/>
    <xsl:param name="catalogId"/> 
    <xsl:param name="catalogTypeName"/>
    <xsl:param name="countryCode"/>
    <xsl:param name="productDivisionCode"/>
    <xsl:param name="currencyCode"/>
    <!-- -->
    <xsl:variable name="sop"      select="if(@start-of-publication = '') then '1900-01-01' else @start-of-publication"/>
    <xsl:variable name="somp"     select="if(string(@start-of-marketing-publication) = '') then $sop else @start-of-marketing-publication"/>
    <xsl:variable name="eop"      select="if(@end-of-publication='' or @end-of-publication='9999-12-31') then '2300-01-01' else @end-of-publication"/>
    <!-- Nb. the feed does not contain a start-of-sales attribute -->
    <xsl:variable name="sos"      select="$sop"/>
    <xsl:variable name="eos"      select="if(@end-of-sales='' or @end-of-sales='9999-12-31') then '2300-01-01' else @end-of-sales"/>    
    <xsl:variable name="gtin"     select="if(@gtin != '')                then @gtin else ''"/>
    <xsl:variable name="bol"      select="if(@buy-on-line='Y')           then '1' else '0'"/>
    <xsl:variable name="deleted"  select="if(@action = 'delete')         then '1' else '0'"/>
    <xsl:variable name="priority" select="if(not(@priority= ''))         then @priority else '50'"/>    
    <xsl:variable name="dad"      select="if(@delete-after-date != '')   then @delete-after-date else ''"/>    
<!--| EXAMPLE 2012/nov/30:
    | CONSUMER_DE_Catalog|100WT10P/00|CONSUMER|DE|CLS||2004-05-01|2005-05-28|2004-05-01|2006-11-30|0||0||50|2012-11-30T14:41:29
    | CONSUMER_DE_Catalog|100WT10P/00|CONSUMER|DE|CLS||2004-05-01|2005-05-28|2004-05-01|2006-11-30|0||0||50|2012-11-30T14:41:29
    |-->
    <xsl:value-of select="string-join(($catalogId
                                      ,@CTN
                                      ,$catalogTypeName
                                      ,$countryCode
                                      ,$productDivisionCode
                                      ,$gtin
                                      ,$sop
                                      ,$somp
                                      ,$eop
                                      ,$sos
                                      ,$eos
                                      ,$bol
                                      ,@local-going-price
                                      ,$deleted
                                      ,$dad
                                      ,$priority
                                      ,$timestamp)
                                     ,'|')"/><xsl:text>
</xsl:text></xsl:template>
  <!-- -->
  <xsl:template match="CatalogProduct" mode="CCB">
    <xsl:param name="timestamp"/>
    <xsl:param name="catalogId"/> 
    <xsl:param name="catalogTypeName"/>
    <xsl:param name="countryCode"/>
    <xsl:param name="productDivisionCode"/>
    <xsl:param name="currencyCode"/>
    <!-- -->
    <xsl:variable name="sop"      select="if(@StartOfPublication != '') then @StartOfPublication else '1900-01-01'"/>
    <xsl:variable name="somp"     select="if(string(@StartOfMarketingPublication) = '') then $sop else @StartOfMarketingPublication"/>
    <xsl:variable name="eop"      select="if(@EndOfPublication != '')   then @EndOfPublication else '2300-01-01'"/>
    <xsl:variable name="sos"      select="if(@StartOfSales != '')       then @StartOfSales else '1900-01-01'"/>
    <xsl:variable name="eos"      select="if(@EndOfSales != '')         then @EndOfSales else '2300-01-01'"/>    
    <!-- *****?????******* -->
    <xsl:variable name="bol"      select="if(@SellOnline='Y')           then '1' else '0'"/>
    <!-- *****?????******* -->
    <xsl:variable name="deleted"  select="if(@Action = 'delete')        then '1' else '0'"/>
    <xsl:variable name="priority" select="if(@priority != '')           then @priority else '50'"/>    
    <xsl:variable name="dad"      select="''"/>    
    <xsl:value-of select="string-join(($catalogId
                                      ,@CTN
                                      ,$catalogTypeName
                                      ,$countryCode
                                      ,$productDivisionCode
                                      ,$sop
                                      ,$somp
                                      ,$eop
                                      ,$sos
                                      ,$eos
                                      ,$bol
                                      ,''
                                      ,$deleted
                                      ,$dad
                                      ,$priority
                                      ,$timestamp)
                                     ,'|')"/><xsl:text>
</xsl:text></xsl:template>
  <!-- -->
  <xsl:template match="object">
    <xsl:param name="timestamp"/>
    <xsl:variable name="country" select="if (country) then country else ''"/>    
    <!-- -->
    <xsl:value-of select="string-join((../@o
                                      ,@o
                                      ,$customer_id
                                      ,$country
                                      ,''
                                      ,''
                                      ,''
                                      ,''
                                      ,''
                                      ,''
                                      ,''
                                      ,''
                                      ,''
                                      ,''
                                      ,$timestamp),'|')"/><xsl:text>
</xsl:text></xsl:template>
</xsl:stylesheet>
