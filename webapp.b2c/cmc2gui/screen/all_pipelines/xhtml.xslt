<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:me="http://apache.org/a">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="gui_url"/>
	<xsl:template match="/root">
		<html>
			<body contentID="content">
				<h2>All Pipelines [Schedule Order]</h2>
				<hr/>
				<table class="main" style="table-layout: fixed;">
					<tr>
						<td style="width:70px">ID</td>
						<td>Type</td>
						<td style="width:130px">Description</td>
						<td>Pipeline / Schedule</td>
						<td style="width:160px">StartExec</td>
						<td style="width:160px">EndExec</td>
						<td style="width:100px">Duration</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="sql:row">
		<tr>
			<td>
				<xsl:value-of select="sql:id"/>
			</td>          
			<td>
				<a>
				<xsl:attribute name="href"><xsl:value-of select="concat($gui_url,'section/',sql:section,'/',sql:screen, '/',sql:content_type,'/jobs/',sql:idreal)"/></xsl:attribute>
				<xsl:value-of select="sql:content_type"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="sql:description"/>
			</td>
			<td>
                <xsl:variable name="tokens" select="tokenize(sql:pipeline,'\?|&amp;')"/>
                <xsl:choose>
                  <xsl:when test="count($tokens) gt 1">
                    <xsl:for-each select="$tokens">
                      <xsl:value-of select="."/>
                      <br/>
                      <xsl:text>&#160;&#160;</xsl:text>
                      <!--
                      <xsl:choose>
                        <xsl:when test="position()=last()"/>
                        <xsl:when test="position()=1">
                          <xsl:text>&#160;&#160;?</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>&#160;&#160;&amp;</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                      -->
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="sql:pipeline"/>
                  </xsl:otherwise>
                </xsl:choose>

				<br/>
                <xsl:value-of select="sql:machineaffinity"/>        
			</td>      
			<td>
				<xsl:choose>
					<xsl:when test="me:compDate(sql:startexec2, sql:endexec2)">
						<xsl:attribute name="bgcolor">#FF0000</xsl:attribute>
					</xsl:when>
					<xsl:otherwise test="me:compDate(sql:startexec2, sql:endexec2)">
						<xsl:attribute name="bgcolor">#00FF00</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="sql:startexec"/>
			</td>
			<td>
				<xsl:value-of select="sql:endexec"/>
			</td>
			<td>
		        <xsl:variable name="duration-in-min" select="number(sql:duration_in_min)"/>
		        <xsl:variable name="duration-in-hours" select="number(sql:duration_in_hours)"/>
		        <xsl:value-of select="if (round($duration-in-min) > 0) then 
		        	(
			        	concat(
			        		format-number(floor($duration-in-hours), '00'), 
			        		':', 
			        		format-number(floor($duration-in-min mod 60), '00')
			        	)
		        	) else ()"/>
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
