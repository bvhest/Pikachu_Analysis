<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                exclude-result-prefixes="sql xsl cinclude"
                >
  <!--+
      | Comply with XML Schema: xUCDM_product_sustainability_marketing_1_0b7.xsd  
      +-->
  <xsl:template match="GreenProductData">
    <GreenData>
      <xsl:apply-templates select="node()|@*"/>
    </GreenData>
  </xsl:template>
  
  <xsl:variable name="GIM_NewGreenItemNames"> 
		  <GreenItemNames>  
				  <GreenItemName code="Onmode" name="On mode"/>
				  <GreenItemName code="Offmode" name="Off mode"/>
				  <GreenItemName code="Standby" name="Stand-by"/>
				  <GreenItemName code="ProductWeight" name="Product weight"/>
				  <GreenItemName code="AccessoryWeight" name="Accessory weight"/>
				  <GreenItemName code="RecycledMaterials" name="Recycled ferrous metals"/>
				  <GreenItemName code="RecycledNonFerroMetals" name="Recycled non-ferrous metals"/>
				  <GreenItemName code="HousingRecycledPlastics" name="Recycled plastics"/>
				  <GreenItemName code="PVCFree" name="PVC free"/>
				  <GreenItemName code="BFRFree" name="BFR free"/>
				  <GreenItemName code="MercuryFree" name="Mercury free"/>
				  <GreenItemName code="Cardboard" name="Cardboard"/>
				  <GreenItemName code="Plastics" name="Plastics"/>
				  <GreenItemName code="PercentageRecycledMaterials" name="Percentage recycled materials"/>
		  </GreenItemNames>
  </xsl:variable>
  <xsl:variable name="isFromLighting" select="'false'"/>
 
  <xsl:template match="@Rank">
    <xsl:attribute name="rank">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@PhilipsGreenLogoProduct">
    <xsl:attribute name="isGreenProduct">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="EnergyLabels">
    <EnergyLabel>
      <xsl:apply-templates select="node()|@*"/>
    </EnergyLabel>
  </xsl:template>

  <!-- Old Cemafoor data to new: remove the following two templates after CCR starts feeding new GIM files -->
  <!-- Old Cemafoor data to new, replace EnergyClass with ApplicableFor -->
  <xsl:template match="EnergyClass">
    <ApplicableFor>
      <xsl:apply-templates select="node()|@*"/>
    </ApplicableFor>
  </xsl:template>
  <!--+
      | Old Cemafoor data to new, transform EcoFlower to hold ApplicableFor tags
      | for all relevant countries.
      +-->
  <xsl:template match="EcoFlower">
    <xsl:element name="EcoFlower">
      <xsl:if test="@EcoFlowerProduct = true()">
        <!-- Add ApplicableFor element for each european country -->
        <xsl:variable name="europeanCountries">
          <country code="AT" name="Austria"/>
          <country code="BE" name="Belgium"/>
          <country code="BG" name="Bulgaria"/>
          <country code="CY" name="Cyprus"/>
          <country code="CZ" name="Czech Republic"/>
          <country code="DK" name="Denmark"/>
          <country code="EE" name="Estonia"/>
          <country code="FI" name="Finland"/>
          <country code="FR" name="France"/>
          <country code="DE" name="Germany"/>
          <country code="GR" name="Greece"/>
          <country code="HU" name="Hungary"/>
          <country code="IS" name="Iceland"/>
          <country code="IE" name="Ireland"/>
          <country code="IT" name="Italy"/>
          <country code="LV" name="Latvia"/>
          <country code="LI" name="Liechtenstein"/>
          <country code="LT" name="Lithuania"/>
          <country code="LU" name="Luxembourg"/>
          <country code="MT" name="Malta"/>
          <country code="NL" name="Netherlands"/>
          <country code="NO" name="Norway"/>
          <country code="PL" name="Poland"/>
          <country code="PT" name="Portugal"/>
          <country code="RO" name="Romania"/>
          <country code="SK" name="Slovakia"/>
          <country code="SI" name="Slovenia"/>
          <country code="ES" name="Spain"/>
          <country code="SE" name="Sweden"/>
          <country code="GB" name="United Kingdom"/>
        </xsl:variable>
        <xsl:for-each select="$europeanCountries/country">
          <xsl:element name="ApplicableFor">
            <xsl:element name="Code"/>
            <xsl:element name="Countrycode">
              <xsl:value-of select="@code"/>
            </xsl:element>
            <xsl:element name="Value"/>
            <xsl:element name="Description">
              <xsl:value-of select="@name"/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!--+
      | Remove the GreenAwards element level, ignoring any attributes.
      +-->
  <xsl:template match="GreenAwards">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <!--+
      | Eco Passport: Translate the spefic GIM data from Cemafoor into a generic
      | format.
      +-->
  <xsl:template match="EcoPassport">	 	
	<xsl:apply-templates select="FocalArea/*"/>
	<xsl:apply-templates select="FocalArea"/>    
  </xsl:template>

  <!--+
      | Translate the new name back to the old name, the old name is used for
      | compatibility with PFS.
      +-->
  <xsl:template match="EUEcoLabel">
    <EcoFlower>
      <xsl:apply-templates select="@*|node()"/>
    </EcoFlower>
  </xsl:template>

  <!--+
      | Convert to PFS-compatible name.
      +-->
  <xsl:template match="TheBlueAngel">
    <BlueAngel>
      <xsl:apply-templates select="@*|node()"/>
    </BlueAngel>
  </xsl:template>

  <!--+
      | Select every specific Eco Passport Area.
      +-->
  <xsl:template match="FocalArea/*">
  <xsl:variable name="ecofocalarea" select="name(.)"/>  
  <xsl:if test="$ecofocalarea != 'EcoFocalArea'"> 
		<GreenChapter>
		  <xsl:for-each select="@*">
			<xsl:attribute name="{name(.)}" select="."/>
		  </xsl:for-each>
		  <GreenChapterName>
			<xsl:value-of select="name(.)"/>
		  </GreenChapterName>
		  <xsl:for-each select="*">
			<GreenItem>
			  <GreenItemName>
				 <xsl:variable name="newGreenItemName" select="$GIM_NewGreenItemNames/GreenItemNames/GreenItemName[@code= current()/name()]/@name"/>             
				 <xsl:choose>
						 <xsl:when test="$newGreenItemName != '' ">
							<xsl:value-of select="$newGreenItemName"/>
						 </xsl:when>
						 <xsl:otherwise test="$newGreenItemName = '' ">
							<xsl:value-of select="name()"/>
						 </xsl:otherwise>             
				 </xsl:choose>
			  </GreenItemName>
			  <GreenItemRank>
				<xsl:value-of select="position()"/>
			  </GreenItemRank>
			  <GreenValue>
				<GreenValueName>
				  <xsl:choose>
					<xsl:when test="MinValue">
					  <xsl:value-of select="MinValue"/> - <xsl:value-of select="MaxValue"/>
					</xsl:when>
					<xsl:when test="Value">
					  <xsl:value-of select="Value"/>
					</xsl:when>
					<xsl:otherwise>
					  <xsl:value-of select="text()"/>
					</xsl:otherwise>
				  </xsl:choose>
				</GreenValueName>
				<GreenValueRank>1</GreenValueRank>
			  </GreenValue>
			  <xsl:call-template name="getUnitOfMeasure">
				<xsl:with-param name="itemName" select="name()"/>
			  </xsl:call-template>
			</GreenItem>
		  </xsl:for-each>
		</GreenChapter>
	</xsl:if>
  </xsl:template>

  <!--+
      | Get the specific units of measurement for each focal area item.
      +-->
  <xsl:template name="getUnitOfMeasure">
    <xsl:param name="itemName"/>
    <xsl:choose>
      <xsl:when test="$itemName=('Onmode', 'Offmode', 'Standby')">
        <UnitOfMeasure>
          <UnitOfMeasureName>Watt</UnitOfMeasureName>
          <UnitOfMeasureSymbol>W</UnitOfMeasureSymbol>
        </UnitOfMeasure>
      </xsl:when>
      <xsl:when test="$itemName=('ProductWeight', 'AccessoryWeight', 'Cardboard', 'Plastics')">
        <UnitOfMeasure>
          <UnitOfMeasureName>gram</UnitOfMeasureName>
          <UnitOfMeasureSymbol>g</UnitOfMeasureSymbol>
        </UnitOfMeasure>
      </xsl:when>
      <xsl:when test="$itemName=('RecycledMaterials', 'RecycledNonFerroMetals', 'HousingRecycledPlastics', 'PercentageRecycledMaterials')">
        <UnitOfMeasure>
          <UnitOfMeasureName>percent</UnitOfMeasureName>
          <UnitOfMeasureSymbol>%</UnitOfMeasureSymbol>
        </UnitOfMeasure>
      </xsl:when>
`    </xsl:choose>
  </xsl:template>
  
 <xsl:template match="FocalArea">
	<xsl:variable name="focalArea" select="EcoFocalArea/FocalAreaName"/>
	<xsl:for-each select="$focalArea">
		<xsl:variable name="focalAreaname" select="."/>
		<xsl:variable name="focalAreaattribute" select="../../EcoFocalArea[FocalAreaName=$focalAreaname]/FAAttributes/FAAttribute"/>		
		<xsl:if test="../../EcoFocalArea[FocalAreaName=$focalAreaname]/FAAttributes/FAAttribute">
			<GreenChapter>      
			  <GreenChapterName>
			  <xsl:choose>
			    <xsl:when test="$focalAreaname = 'Recyclability'">
			      <xsl:value-of select="'Recycling'"/>
			    </xsl:when>
			    <xsl:when test="$focalAreaname = 'Lifetime'">
			      <xsl:value-of select="'Reliability'"/>
			    </xsl:when>			   
			    <xsl:otherwise>
			      <xsl:value-of select="$focalAreaname"/>
			    </xsl:otherwise>
			  </xsl:choose>			    
			  </GreenChapterName>
			  <xsl:for-each select="$focalAreaattribute">
				<GreenItem>
				  <GreenItemName>
						<xsl:value-of select="FAAttributeName"/>
				  </GreenItemName>
				  <GreenItemRank>
					<xsl:value-of select="position()"/>
				  </GreenItemRank>
				  <GreenValue>
					<GreenValueName>
						<xsl:value-of select="FAAttributeValue"/>
					</GreenValueName>
					<GreenValueRank>1</GreenValueRank>
				  </GreenValue>
				  <UnitOfMeasure>
					  <UnitOfMeasureName><xsl:value-of select="UnitOfMeasure/UnitOfMeasureName"/></UnitOfMeasureName>
					  <UnitOfMeasureSymbol><xsl:value-of select="UnitOfMeasure/UnitOfMeasureSymbol"/></UnitOfMeasureSymbol>
				  </UnitOfMeasure>
				</GreenItem>
			  </xsl:for-each>
			</GreenChapter>
		</xsl:if>
	</xsl:for-each>
  </xsl:template>
  <!--+
      | Select all Eco Passport Area items, so grand-children of the FocalArea
      | tag.
      +-->
  <xsl:template match="FocalArea/*/*">
  </xsl:template>

  <!--  identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
