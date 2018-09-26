<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:me="http://apache.org/a">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>Process Report: last time that processes have imported/exported/processed data</h2>
            <p>Note that this date represents the last date that data was actually imported (content types), processed (content types) or exported (channels).
            This date can, but need not, differ from the last time the process has run (processes can run without processing any data...). 
            </p>
				<hr/>
				<table class="main" style="table-layout: fixed; width: 900px;">
					<tr>
						<td style="width:100px">Process type</td>
						<td style="width:300px">Name</td>
						<td style="width:300px">Date of last processing</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
   
	<xsl:template match="sql:row">
		<tr>
			<td>
				<xsl:value-of select="sql:process_type"/>
			</td>          
			<td>
				<xsl:value-of select="sql:process_name"/>
			</td>          
			<td>
				<xsl:value-of select="sql:last_transmit"/>
			</td>
   	</tr>
	</xsl:template>
	<!-- -->
	<xsl:function name="me:strip" as="xs:string">
		<xsl:param name="d"/>
		<xsl:value-of select="translate(translate(translate(translate(substring($d,1,19),'-',''),'T',''),':',''),' ','')"/>
	</xsl:function>
	<!-- -->
	<xsl:function name="me:compDate" as="xs:boolean">
		<xsl:param name="dt_a" as="xs:string"/>
		<xsl:param name="dt_b" as="xs:string"/>
		<xsl:choose>
			<xsl:when test="me:strip($dt_a) &gt; me:strip($dt_b)">
				<xsl:copy-of select="true()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
