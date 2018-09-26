<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
				xmlns:cmc2-f="http://www.philips.com/cmc2-f"
				exclude-result-prefixes="sql xsl cmc2-f"
                >				
	<xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
	<xsl:variable name="ecopassportConfigFile" select="document('../../../xml/ecopassport_config.xml')"/>
	<xsl:variable name="energyLabelsLightingFile" select="document('../../../xml/energyLabels_lighting.xml')"/>
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
    </xsl:template> 
  <!-- -->
   <xsl:template match="content[../@valid='true']/Product">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>		  
		</xsl:copy>
   </xsl:template>
   
   <xsl:template match="GreenData/PhilipsGreenLogo">
	   <PhilipsGreenLogo>
			<!-- <xsl:attribute name="isGreenProduct" select="'true'"/> -->
			<xsl:apply-templates select="@*|node()"/>		
		</PhilipsGreenLogo>
   </xsl:template>
   
	<xsl:template match="content[../@valid='true']/Product/GreenData/GreenChapter">
		<xsl:copy>
			 <xsl:apply-templates select="@*|node()"/>      
			 <xsl:variable name="focalAreaName" select="GreenChapterName"/>		
			 <xsl:variable name="csChptr" select="../../CSChapter"></xsl:variable>				
			 <xsl:variable name="totalFocalAttributes" select="$ecopassportConfigFile/Ecopassport/GreenFocalAreas/GreenFocalArea[GreenFocalAreaName=$focalAreaName]/GreenFocalAreaAttributes/GreenFocalAreaAttributeSequence/GreenFocalAreaAttributeName"/>
			 <xsl:variable name="energyLabelCSChapterCode" select="$ecopassportConfigFile/Ecopassport/GreenAwards/GreenAwardSequence[GreenAwardSequenceName='EnergyLabel']/GreenAward/AwardCodeMapping"/>
			 <xsl:variable name="energyLabelValue" select="$csChptr/CSItem[CSItemCode= $energyLabelCSChapterCode]/CSValue/CSValueName"/> 
			 <xsl:variable name="energyLabelCode" select="$energyLabelsLightingFile/EnergyLabels/EnergyLabel[@energyValue = $energyLabelValue]"/>		
			<xsl:choose>
				<xsl:when test="$energyLabelValue !='' and $energyLabelCode ">  	
					<xsl:for-each select="$totalFocalAttributes"><!-- Start Iterate focal attributes-->
							<xsl:variable name="focalAttribute" select="."/>												
							<xsl:call-template name="displayAttributes">
								<xsl:with-param name="focalAreaName" select="$focalAreaName"/>
								<xsl:with-param name="focalAttribute" select="$focalAttribute"/>
								<xsl:with-param name="csChptr" select="$csChptr"/>
								<xsl:with-param name="priority" select="1"/>						
							</xsl:call-template>											
					</xsl:for-each><!-- End Iterate focal attributes-->	
				</xsl:when>
			</xsl:choose>
		</xsl:copy>
    </xsl:template>
   <xsl:template name="displayAttributes">
		<xsl:param name="focalAreaName"/>
		<xsl:param name="focalAttribute"/>
		<xsl:param name="csChptr"/>
		<xsl:param name="priority"/>	
		<xsl:variable name="ecoConfig" select="$ecopassportConfigFile/Ecopassport/GreenFocalAreas"/>	
		<xsl:variable name="characteristicCodes" select="$ecoConfig/GreenFocalArea[GreenFocalAreaName=$focalAreaName]/GreenFocalAreaAttributes/GreenFocalAreaAttributeSequence[GreenFocalAreaAttributeName=$focalAttribute]/GreenFocalAreaAttribute[GreenFocalAreaAttributePriority=$priority]/CSItemCodeMapping"/>								
		<xsl:if test="$characteristicCodes != ''">
			<xsl:variable name="count" select="cmc2-f:getArrayLen($characteristicCodes)"/>
			<xsl:variable name="attributeCodes" select="$characteristicCodes"/>							
			<xsl:if test="$count &gt; 1"> 
				<xsl:variable name="codes" select="string-join($characteristicCodes, ',')"/>								
				<xsl:variable name="attributeCodes" select="tokenize($codes,',')"/>	
			</xsl:if>						
			<xsl:choose>
				<xsl:when test="$csChptr/CSItem[CSItemCode = ($attributeCodes)]">      
					<xsl:for-each select="$csChptr/CSItem[CSItemCode = ($attributeCodes)][1]"><!--Start Iterate CSITEMCODES-->
						<xsl:variable name="value" select="CSValue/CSValueName"/>
						<xsl:variable name="prismaCode" select="CSItemCode"/>										 
							<xsl:if test="$value!=''"> 
								<xsl:choose>
									<xsl:when test="$ecoConfig/GreenFocalArea[GreenFocalAreaName=$focalAreaName]/GreenFocalAreaAttributes/GreenFocalAreaAttributeSequence[GreenFocalAreaAttributeName=$focalAttribute]/GreenFocalAreaAttribute[CSItemCodeMapping=$prismaCode]/UseCSItemLabel = 'true'">
										<GreenItem>
											<GreenItemName><xsl:value-of select="CSItemName"/></GreenItemName>
											<GreenItemRank><xsl:value-of select="position()"/></GreenItemRank>
											<GreenValue>
												<GreenValueName><xsl:value-of select="$value"/></GreenValueName>
												<GreenValueRank>1</GreenValueRank>
											</GreenValue>
											<UnitOfMeasure>												
												<UnitOfMeasureName><xsl:value-of select="UnitOfMeasure/UnitOfMeasureName"/></UnitOfMeasureName>
												<UnitOfMeasureSymbol><xsl:value-of select="UnitOfMeasure/UnitOfMeasureSymbol"/></UnitOfMeasureSymbol>
											</UnitOfMeasure>																																	
										</GreenItem>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>									
											<xsl:when test="$ecoConfig/GreenFocalArea[GreenFocalAreaName=$focalAreaName]/GreenFocalAreaAttributes/GreenFocalAreaAttributeSequence[GreenFocalAreaAttributeName=$focalAttribute]/GreenFocalAreaAttribute[CSItemCodeMapping=$prismaCode]/CustomValues != ''"> 
												<xsl:if test="$value = $ecoConfig/GreenFocalArea[GreenFocalAreaName=$focalAreaName]/GreenFocalAreaAttributes/GreenFocalAreaAttributeSequence[GreenFocalAreaAttributeName=$focalAttribute]/GreenFocalAreaAttribute[CSItemCodeMapping=$prismaCode]/CustomValues/CustomValue/CSValue"> 
													<GreenItem>
														<GreenItemName><xsl:value-of select="$ecoConfig/GreenFocalArea[GreenFocalAreaName=$focalAreaName]/GreenFocalAreaAttributes/GreenFocalAreaAttributeSequence[GreenFocalAreaAttributeName=$focalAttribute]/GreenFocalAreaAttribute[CSItemCodeMapping=$prismaCode]/CustomValues/CustomValue[CSValue=$value]/EcoPassportAttributeName"/></GreenItemName>
														<GreenItemRank><xsl:value-of select="position()"/></GreenItemRank>
														<GreenValue>
															<GreenValueName><xsl:value-of select="$ecoConfig/GreenFocalArea[GreenFocalAreaName=$focalAreaName]/GreenFocalAreaAttributes/GreenFocalAreaAttributeSequence[GreenFocalAreaAttributeName=$focalAttribute]/GreenFocalAreaAttribute[CSItemCodeMapping=$prismaCode]/CustomValues/CustomValue[CSValue=$value]/CustomAttributeValue"/></GreenValueName>											
															<GreenValueRank>1</GreenValueRank>
														</GreenValue>
														<UnitOfMeasure>															
															<UnitOfMeasureName><xsl:value-of select="UnitOfMeasure/UnitOfMeasureName"/></UnitOfMeasureName>
															<UnitOfMeasureSymbol><xsl:value-of select="UnitOfMeasure/UnitOfMeasureSymbol"/></UnitOfMeasureSymbol>
														</UnitOfMeasure>																								
													</GreenItem>
												</xsl:if>
											</xsl:when>  
											<xsl:otherwise>
												<GreenItem>
													<GreenItemName><xsl:value-of select="$ecoConfig/GreenFocalArea[GreenFocalAreaName=$focalAreaName]/GreenFocalAreaAttributes/GreenFocalAreaAttributeSequence[GreenFocalAreaAttributeName=$focalAttribute]/GreenFocalAreaAttribute[CSItemCodeMapping=$prismaCode]/EcoPassportAttributeName"/></GreenItemName>
													<GreenItemRank><xsl:value-of select="position()"/></GreenItemRank>
													<GreenValue>
														<GreenValueName><xsl:value-of select="$value"/></GreenValueName>
														<GreenValueRank>1</GreenValueRank>
													</GreenValue>
													<UnitOfMeasure>														
														<UnitOfMeasureName><xsl:value-of select="UnitOfMeasure/UnitOfMeasureName"/></UnitOfMeasureName>
														<UnitOfMeasureSymbol><xsl:value-of select="UnitOfMeasure/UnitOfMeasureSymbol"/></UnitOfMeasureSymbol>
													</UnitOfMeasure>																																	
												</GreenItem>
											</xsl:otherwise>
										</xsl:choose>									
									</xsl:otherwise>
								</xsl:choose>																						
							</xsl:if>						
					</xsl:for-each><!--End Iterate CSITEMCODES-->
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="displayAttributes">
							<xsl:with-param name="focalAreaName" select="$focalAreaName"/>
							<xsl:with-param name="focalAttribute" select="$focalAttribute"/>
							<xsl:with-param name="csChptr" select="$csChptr"/>
							<xsl:with-param name="priority" select="$priority+1"/>						
						</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>	  
	</xsl:template>
	
	<xsl:template match="GreenData/EnergyLabel/EnergyClasses">
		<xsl:variable name="energyLabelCSChapterCode" select="$ecopassportConfigFile/Ecopassport/GreenAwards/GreenAwardSequence[GreenAwardSequenceName='EnergyLabel']/GreenAward/AwardCodeMapping"/>
		<xsl:variable name="energyLabelValue" select="../../../CSChapter/CSItem[CSItemCode= $energyLabelCSChapterCode]/CSValue/CSValueName"/> 
		<xsl:variable name="energyLabelCode" select="$energyLabelsLightingFile/EnergyLabels/EnergyLabel[@energyValue = $energyLabelValue]"/>		
		<xsl:choose>
			<xsl:when test="$energyLabelValue !='' and $energyLabelCode">		
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
								  <country code="CH" name="Switzerland"/>
								  <country code="TR" name="Turkey"/>
								  <country code="GB" name="United Kingdom"/>
								</xsl:variable>
								<!-- Add ApplicableFor element for each european country -->
								<xsl:for-each select="$europeanCountries/country">
									<!-- <xsl:variable name="energyLabelCode" select="$energyLabelsLightingFile/EnergyLabels/EnergyLabel[@energyValue = $energyLabelValue]"/>	-->
										<xsl:element name="ApplicableFor">
											<xsl:attribute name="rank" >
												<xsl:value-of select="$energyLabelCode/@ranking"/>
											</xsl:attribute>
											<xsl:element name="Code">										
												<xsl:value-of select="$energyLabelCode/@code"/>
											</xsl:element>
											<xsl:element name="Countrycode">
												<xsl:value-of select="@code"/>
											</xsl:element>									
											<xsl:element name="Value">
												<xsl:value-of select="$energyLabelValue"/>
											</xsl:element>
											<xsl:element name="Description">
												<xsl:value-of select="@name"/>
											</xsl:element>
										</xsl:element>
								</xsl:for-each>	
					</xsl:when>
					<xsl:otherwise>
					   <xsl:copy>
							<xsl:apply-templates select="@*|node()"/>		  
						</xsl:copy>
					</xsl:otherwise>
			</xsl:choose>							
	</xsl:template>
	<xsl:function name="cmc2-f:getArrayLen">
		<xsl:param name="characteristicCodes"/>
		<xsl:for-each select="$characteristicCodes"><!--Start Iterate CSITEMCODES-->	
			<xsl:if test="position()=last()"> 	
				<xsl:value-of select="last()"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:function> 
  <!-- -->
</xsl:stylesheet>