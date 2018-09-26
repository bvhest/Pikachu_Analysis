<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:param name="param1"/>
    <xsl:param name="section"/>
    <xsl:variable name="sectionurl">
	  <xsl:if test="$section">
		<xsl:value-of select="concat('section/', $section, '/')"/>
	  </xsl:if>
    </xsl:variable>	
	<xsl:variable name="channel" select="/root/sql:rowset/sql:row/sql:id"/>
	<!-- -->
	<xsl:template match="/root">
		<xsl:if test="$param1 = ''">
			<html>
				<body contentID="content">
					<h2>Select a channel first!!</h2>
				</body>
			</html>
		</xsl:if>
		<xsl:apply-templates select="sql:rowset/sql:row"/>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:rowset/sql:row">
		<html>
			<body contentID="content">
				<h2><xsl:value-of select="sql:name"/> - Edit channel</h2><hr/>
				<form method="POST" enctype="multipart/form-data">
					<xsl:attribute name="action"><xsl:value-of select="concat($gui_url, $sectionurl, 'pikachu_channel_add_post/', $param1, '?channel=', $channel)"/></xsl:attribute>
					<table>
						<tr>
							<td style="width: 140px">ID</td>
							<td style="width: 205px">
								<xsl:value-of select="sql:id"/>
							</td>
						</tr>
						<tr>
							<td style="width: 140px">Name</td>
							<td style="width: 205px">
								<input name="Name" size="60" type="text">
									<xsl:attribute name="value"><xsl:value-of select="sql:name"/></xsl:attribute>
								</input>
							</td>
						</tr>
						<tr>
							<td style="width: 140px">
				            </td>
							<td style="width: 400px">
								This is the unique name of the channel. Its value must be identical to the LCB CatalogType name. 
								</td>
						</tr>
						<tr>
							<td style="width: 140px">Locale</td>
							<td style="width: 205px">
								<input name="Locale" size="60" type="text">
									<xsl:attribute name="value"><xsl:value-of select="sql:locale"/></xsl:attribute>
								</input>
							</td>
						</tr>
						<tr>
							<td style="width: 140px">
				            </td>
							<td style="width: 400px">
								Some channels use this field to select one or more locales to export. 
								</td>
						</tr>
						<tr>
							<td style="width: 140px">Catalog</td>
							<td style="width: 205px">
								<input name="Catalog" size="60" type="text">
									<xsl:attribute name="value"><xsl:value-of select="sql:catalog"/></xsl:attribute>
								</input>
							</td>
						</tr>
						<tr>
							<td style="width: 140px">
				            </td>
							<td style="width: 400px">
								This is the name of the catalog, the channel should use. Default names are 'CONSUMER', 'PROFESSIONAL', 'WALITA' or 'NORELCO'.
								</td>
						</tr>
						<tr>
							<td style="width: 140px">Location</td>
							<td style="width: 205px">
								<input name="Location" size="60" type="text">
									<xsl:attribute name="value"><xsl:value-of select="sql:location"/></xsl:attribute>
								</input>
							</td>
						</tr>
						<tr>
							<td style="width: 140px">
				            </td>
							<td style="width: 400px">
								The directory where the channel stores its data, logfiles, etc. This value cannot contain spaces. 
								</td>
						</tr>
						<tr>
							<td style="width: 140px">Type</td>
							<td style="width: 205px">
								<select id="Type" style="width: 392px" name="Type">
									<xsl:attribute name="value"><xsl:value-of select="sql:type"/></xsl:attribute>
									<option value="import">
										<xsl:if test="sql:type='import'">
											<xsl:attribute name="selected"><xsl:value-of select="True"/></xsl:attribute>
										</xsl:if>import</option>
									<option value="export">
										<xsl:if test="sql:type='export'">
											<xsl:attribute name="selected"><xsl:value-of select="True"/></xsl:attribute>
										</xsl:if>export</option>
									<option value="maintenance">
										<xsl:if test="sql:type='maintenance'">
											<xsl:attribute name="selected"><xsl:value-of select="True"/></xsl:attribute>
										</xsl:if>maintenance</option>
								</select>
							</td>
						</tr>
						<tr>
							<td style="width: 140px">
				            </td>
							<td style="width: 400px">
								The channel type. Possible values are import, export. Maintenance is used for cleanup or report channels and is normally not needed. Import channels show up under the 'Import' menu, export channels under the 'Export' menu.
								</td>
						</tr>
						<tr>
							<td style="width: 140px">Pipeline</td>
							<td style="width: 205px">
								<input name="Pipeline" size="60" type="text">
									<xsl:attribute name="value"><xsl:value-of select="sql:pipeline"/></xsl:attribute>
								</input>
							</td>
						</tr>
						<tr>
							<td style="width: 140px">
				            </td>
							<td style="width: 400px">
								This can be something like '<b>pipes/NewPipe</b>'. This requires however that a developer creates the new channel.
								Another option is the use of '<b>pipes/Zip.NewPipe</b>' or <b>pipes/Xml.NewPipe</b>'. This makes it possible to use the 
								standard ZIP or XML export channel. In this case no programming is needed.
								</td>
						</tr>
						<tr>
							<td style="width: 140px">MachineAffinity</td>
							<td style="width: 205px">
								<input name="MachineAffinity" size="60" type="text">
									<xsl:attribute name="value"><xsl:value-of select="sql:machineaffinity"/></xsl:attribute>
								</input>
							</td>
						</tr>
						<tr>
							<td style="width: 140px">
				            </td>
							<td style="width: 400px">
								<p>This parameter is used by the Main pipeline (pipes/Main/runPipeline) to determine which 
								pipeline must be executed. Possible values are:<br/>
								- <b>all</b>: Execute always<br/>
								- <b>COMPUTERNAME</b>: Execute only when COMPUTERNAME equals the left part of 
								the fully qualified system name. Thus a value of 'nlvu045' makes sure that it runs on
								'nlvu045.gdc1.ce.philips.com'<br/> 
								- <b>all(XX)</b>: Execute when pipes/Main/runPipeline_XX is used. XX can be something like 
								daily, weekly, hourly, etc.<br/>
								- <b>COMPUTERNAME(XX)</b>: Execute only when COMPUTERNAME equals the left part of 
								the fully qualified system name and pipes/Main/runPipeline_XX is used. XX can be something like 
								daily, weekly, hourly, etc.<br/>
								</p>
							</td>
						</tr>
						<tr>
							<td style="width: 140px; height: 13px"/>
							<td style="width: 205px; height: 13px"/>
						</tr>
						<tr>
							<td style="width: 140px">
								<input id="SendChannelData" style="width: 137px" type="submit" value="submit"/>
							</td>
							<td style="width: 205px"/>
						</tr>
					</table>
				</form>
			</body>
		</html>
	</xsl:template>
	<!-- -->
	<xsl:template match="sql:node()">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
