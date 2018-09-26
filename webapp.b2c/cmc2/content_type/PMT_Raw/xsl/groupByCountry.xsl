<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<!-- -->
	<xsl:template match="/root">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>
	<xsl:template match="entries">
		<xsl:variable name="dts" select="concat(substring(@ts,1,4),'-',substring(@ts,5,2),'-',substring(@ts,7,2),'T',substring(@ts,9,2),':',substring(@ts,11,2))"/>
		<xsl:variable name="ts" select="@ts"/>
			<xsl:for-each-group select="entry/trigger" group-by="sql:rowset/sql:row/sql:country">
				<countryGroup name="{current-grouping-key()}" catalog-id="{current-group()[1]/sql:rowset/sql:row[1]/sql:catalog_id}" ts="{$ts}" DocTimeStamp="{$dts}">
					<xsl:for-each-group select="current-group()" group-by="sql:rowset/sql:row/sql:localisation">
						<locale>
							<xsl:value-of select="current-grouping-key()"/>
						</locale>
						<ctl ct="{current-group()[1]/sql:rowset/sql:row[1]/sql:content_type}" l="{current-grouping-key()}"/>
					</xsl:for-each-group>
					<xsl:for-each-group select="current-group()" group-by="sql:rowset/sql:row/sql:object_id">
						<object o="{current-grouping-key()}">
							<customer_id><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:customer_id"/></customer_id>
							<country><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:country"/></country>
							<division><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:division"/></division>
							<gtin><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:gtin"/></gtin>
							<sop><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:sop"/></sop>
							<eop><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:eop"/></eop>
							<sos><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:sos"/></sos>
							<eos><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:eos"/></eos>
							<buy_online><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:buy_online"/></buy_online>
							<local_going_price><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:local_going_price"/></local_going_price>
							<deleted><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:deleted"/></deleted>
							<delete_after_date><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:delete_after_date"/></delete_after_date>
							<priority><xsl:value-of select="current-group()[1]/sql:rowset/sql:row[1]/sql:priority"/></priority>
							<lastmodified><xsl:value-of select="$dts"/></lastmodified>
						</object>
					</xsl:for-each-group>
				</countryGroup>
			</xsl:for-each-group>
	</xsl:template>
</xsl:stylesheet>
