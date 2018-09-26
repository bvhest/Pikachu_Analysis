<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="generic.xsl"/>

	<xsl:template match="/Products|/Nodes" mode="range-index">
		<xsl:if test="count(Node) &gt; 1">
			<div id="icp_index" class="icp_index icp_transparent">
				<div class="icp_title">Index</div>
				<ul>
					<xsl:apply-templates mode="range-index" select="Node[position &lt;= $max-items]"/>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Node" mode="range-index">
		<li>
			<a id="{@code}" href="javascript:void(0)"><xsl:value-of select="@code"/></a>
		</li>
	</xsl:template>
	
</xsl:stylesheet>
