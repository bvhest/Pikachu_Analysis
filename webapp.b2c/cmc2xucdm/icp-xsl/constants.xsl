<?xml version="1.0" encoding="UTF-8"?>
<!-- ICP constants for Pikachu -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:param name="icp-host">/icp-resources/</xsl:param>

	<xsl:param name="scene7-host">http://images.philips.com/</xsl:param>
	<xsl:param name="scene7-url" select="concat($scene7-host, 'is/image/PhilipsConsumer')"/>
	<xsl:param name="scene7-types" select="'_FP A1P A2P A3P A4P A5P ABP APP BRP CLL COP D1P D2P D3P D4P D5P DPP E1P E2P E3P E4P FDB FIL FLP FMB FTP GAP L1P L2P L3P L4P MCP MI1 P3D PA1 PAH PDB PID PLP PMB PP2 PS2 PVP PWL RCP RTP SLP TLP TRP TSL U1P U2P U3P U4P U5P UPL UWL '"/>
	
	<xsl:param name="ccr-host">http://pww.pcc.philips.com/</xsl:param>
	<xsl:param name="ccr-url" select="concat($ccr-host,'cgi-bin/newmpr/get.pl')"/>
	<xsl:param name="ccr-is-secure" select="false()"/>
	<xsl:param name="ccr-is-disabled" select="false()"/>

	<xsl:param name="max-items" select="75"/>
	<xsl:param name="show-log" select="false()"/>
	
	<xsl:param name="system" select="'pikachu'"/>
</xsl:stylesheet>
