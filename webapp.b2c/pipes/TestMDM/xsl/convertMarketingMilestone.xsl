<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml ..\..\..\..\..\..\data\TestMDM\inbox\lcb_full_0300_20071018120000.xml?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--  -->
	<xsl:template match="/catalogs">
		<ProductsMsg version="1.0" docTimestamp="{@timestamp}">
			<xsl:for-each-group select="catalog/CatalogProduct" group-by="@CTN">
				<Product>
					<CTN>
						<xsl:value-of select="current-grouping-key()"/>
					</CTN>
					<xsl:for-each select="current-group()">
						<Milestone>
							<MilestoneCode>VPB</MilestoneCode>
							<MilestoneType>initial</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>VPB</MilestoneCode>
							<MilestoneType>current</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>VPB</MilestoneCode>
							<MilestoneType>actual</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>PRS</MilestoneCode>
							<MilestoneType>initial</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>PRS</MilestoneCode>
							<MilestoneType>current</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>PRS</MilestoneCode>
							<MilestoneType>actual</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>CR</MilestoneCode>
							<MilestoneType>initial</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>CR</MilestoneCode>
							<MilestoneType>current</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>CR</MilestoneCode>
							<MilestoneType>actual</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>FMS</MilestoneCode>
							<MilestoneType>initial</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>FMS</MilestoneCode>
							<MilestoneType>current</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>FMS</MilestoneCode>
							<MilestoneType>actual</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@start-of-publication"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>EOPR</MilestoneCode>
							<MilestoneType>initial</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@end-of-sales"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>EOPR</MilestoneCode>
							<MilestoneType>current</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@end-of-sales"/>
							</MilestoneDate>
						</Milestone>
						<Milestone>
							<MilestoneCode>EOPR</MilestoneCode>
							<MilestoneType>actual</MilestoneType>
							<MilestoneDestination>
								<xsl:value-of select="../@countryCode"/>
							</MilestoneDestination>
							<Publisher>LCB</Publisher>
							<MilestoneDate>
								<xsl:value-of select="@end-of-sales"/>
							</MilestoneDate>
						</Milestone>
					</xsl:for-each>
				</Product>
			</xsl:for-each-group>
		</ProductsMsg>
	</xsl:template>
	<!--  -->
</xsl:stylesheet>
