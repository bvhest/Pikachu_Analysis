<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="gui_url">/cmc2gui/</xsl:param>
    <xsl:param name="publicSystemId"/>
    <xsl:param name="internalSystemId">UNKNOWN</xsl:param>
    
	<!-- -->
	<xsl:template match="page">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html" charset="UTF-8"/>
				<link type="text/css" rel="STYLESHEET" href="{$gui_url}themes/style_Philips.css"/>
                <link type="text/css" rel="STYLESHEET" href="{$gui_url}themes/style{$publicSystemId}.css"/>
                <link type="text/css" rel="STYLESHEET" href="{$gui_url}themes/style{$internalSystemId}.css"/>
				<title><xsl:value-of select="$internalSystemId"/> | a Philips CL e-Platform tool</title>
			</head>
			<body>
        <xsl:copy-of select="@*"/>
				<table width="100%" border="0" cellspacing="0" cellpadding="1">
					<tr>
					<table class="gui_main" width="950px" height="80px" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<table class="gui_main header" width="850px" height="80px" border="0" cellspacing="0" cellpadding="0">
									<!--Company Bar - logo -->
									<tr height="21">
										<td width="500">
											<img src="{$gui_url}themes/images/Brand_PhilipsLogo.jpg" alt="Philips"/>
										</td>
										<td width="150" align="right">
											<table class="gui_main" width="150px" height="20px" border="0" cellspacing="0" cellpadding="0">
												<tr height="10px"><td id="guiversion">GUI VERSION</td></tr>
												<tr height="10px"><td id="engineversion">ENGINE VERSION</td></tr>
											</table>
										</td>
										<td class="environment" width="150" align="right">
											<xsl:value-of select="$internalSystemId"/>
										</td>
									</tr>
									<tr height="3">
										<td colspan="3">
											<img src="{$gui_url}themes/images/line_graywithwhite.jpg" width="850px" height="3"/>
										</td>
									</tr>
									<!--Company Bar - department -->
									<tr height="37">
										<td colspan="3">
											<img src="{$gui_url}themes/images/Brand_PhilipsBar.jpg" alt="Consumer Electronics" width="500px"/>
										</td>
									</tr>
									<tr height="3">
										<td colspan="3">
											<img src="{$gui_url}themes/images/line_graywithwhite.jpg" width="750px" height="3" />
										</td>
									</tr>
								</table>
							</td>
							<td width="80px" align="left">
								<img src="{$gui_url}themes/images/pikachu.gif" alt="PikaChu" />
							</td>
						</tr>
					</table>
					</tr>
					<tr>
						<td>
							<table class="gui_main">
								<tr>
									<td height="100px" align="center">
									</td>
								</tr>
								<tr>
									<td width="800" align="center">
										<xsl:apply-templates/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="title">
		<h2 style="text-align: center">
			<xsl:apply-templates/>
		</h2>
	</xsl:template>
	<xsl:template match="para">
		<p align="center">
			<i>
				<xsl:apply-templates/>
			</i>
		</p>
	</xsl:template>
	<xsl:template match="form">
		<form action="{$gui_url}{@target}">
      <xsl:copy-of select="@*[local-name() != 'target']"/>
			<xsl:apply-templates/>
		</form>
	</xsl:template>
	<xsl:template match="input">
		<center>
			<xsl:value-of select="@title"/>
		</center>
		<center>
			<input style="width: 150px" size="20" type="{@type}" name="{@name}" value="{.}"/>
		</center>
		<br/>
	</xsl:template>
	<xsl:template match="linkbar">
		<center>
      [
      <a href="{$gui_url}login"> login </a>
      |
      <a href="{$gui_url}do-logout"> logout </a>
      ]
    </center>
	</xsl:template>
	<xsl:template match="source">
		<div style="background: #b9d3ee; border: thin; border-color: black; border-style: solid; padding-left: 0.8em; 
              padding-right: 0.8em; padding-top: 0px; padding-bottom: 0px; margin: 0.5ex 0px; clear: both;">
			<textarea name="context" cols="80" rows="20" readonly="true">
				<xsl:apply-templates/>
			</textarea>
		</div>
	</xsl:template>
	<xsl:template match="@*|node()" priority="-1" name="copy">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
<!-- vim: set et ts=2 sw=2: -->
