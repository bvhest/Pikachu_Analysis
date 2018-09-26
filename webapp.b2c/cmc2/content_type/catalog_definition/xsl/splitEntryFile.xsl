<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="batchsize"/>
	<xsl:param name="filestem"/>
	<xsl:param name="dir"/>
		
	<xsl:template match="node()|@*">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="catalog-definition">
		<root>
			<xsl:call-template name="RecursiveGrouping">
				<xsl:with-param name="list" select="object"/>
				<xsl:with-param name="group" select="1"/>
			</xsl:call-template>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:template name="RecursiveGrouping">
		<xsl:param name="list"/>
		<xsl:param name="group"/>
		<xsl:if test="count($list)>0">
			<xsl:call-template name="DoIt">
				<xsl:with-param name="list" select="$list[position() &lt;= number($batchsize)]"/>
				<xsl:with-param name="group" select="$group"/>
			</xsl:call-template>
			<!-- If there are other groups left, call itself -->
			<xsl:call-template name="RecursiveGrouping">
				<xsl:with-param name="list" select="$list[position() > number($batchsize)]"/>
				<xsl:with-param name="group" select="$group+1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- -->
	<xsl:template name="DoIt">
		<xsl:param name="list"/>
		<xsl:param name="group"/>
		<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			<source:source><xsl:value-of select="concat($dir,'/',$filestem,../../../@ts,'.',../../../@l,'.',../../../@batchnumber,'.batch_',$group,'.xml')"/></source:source>
			<source:fragment>
				<entries>
				<xsl:attribute name="batchnumber"><xsl:value-of select="concat(../../../@batchnumber,'.batch_',$group)"/></xsl:attribute>
					<xsl:copy-of select="../../../@*[not(local-name()='batchnumber')]"/>
					<xsl:copy-of   copy-namespaces="no" select="../../../process"/>
					<xsl:copy-of   copy-namespaces="no" select="../../../globalDocs"/>
					<entry>
						<xsl:copy-of select="../../@*"/>
						<xsl:copy-of   copy-namespaces="no" select="../../result"/>
						<xsl:copy-of   copy-namespaces="no" select="../../currentmasterlastmodified_ts"/>
						<xsl:copy-of   copy-namespaces="no" select="../../currentlastmodified_ts"/>
						<xsl:copy-of   copy-namespaces="no" select="../../process"/>
						<xsl:copy-of   copy-namespaces="no" select="../../octl-attributes"/>
						<content>
							<xsl:copy-of select="../@*"/>
							<xsl:copy>
								<xsl:copy-of select="@*"/>
								<xsl:copy-of select="$list"/>
							</xsl:copy>
						</content>
					</entry>
				</entries>
			</source:fragment>
		</source:write>
	</xsl:template>
</xsl:stylesheet>
