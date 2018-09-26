<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:param name="dir"></xsl:param>
	<xsl:param name="prefix"></xsl:param>
	<xsl:param name="customer"></xsl:param>
	<xsl:param name="country"></xsl:param>
	<xsl:param name="timestamp"></xsl:param>
		<!-- -->
	<xsl:template match="/root">
			<xsl:variable name="docDate" select="concat(substring($timestamp,1,4),'-',substring($timestamp,5,2),'-', substring($timestamp,7,2),'T',substring($timestamp,9,2),':',substring($timestamp,11,2),':00' ) "/>
			<!--xsl:variable name="docDate" select="$timestamp"/-->
			<source:write xmlns:source="http://apache.org/cocoon/source/1.0">
			  <source:source>
			    <xsl:value-of select="concat($dir,$customer,'_',$country,'_def_',$timestamp,'.xml')" />
			  </source:source>
			  <source:fragment>
			    <catalog-definition o="{concat($customer,'_',$country,'_Catalog')}" ct="catalog_definition" l="none"
			      DocTimeStamp="{$docDate}">
			      <xsl:apply-templates select="catalog-definitions/sql:rowset/sql:row" />
			    </catalog-definition>
			  </source:fragment>
			</source:write>
      <xsl:if test="catalog-configurations/sql:rowset/sql:row">
        <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
          <source:source>
            <xsl:value-of select="concat($dir,$customer,'_',$country,'_conf_',$timestamp,'.xml')" />
          </source:source>
          <source:fragment>
            <catalog-configuration DocTimeStamp="{$docDate}" ct="catalog_configuration" l="none" o="{concat($customer,'_',$country,'_Catalog')}">
              <xsl:apply-templates select="catalog-configurations/sql:rowset/sql:row"/>
            </catalog-configuration>
          </source:fragment>
        </source:write>
      </xsl:if>
	</xsl:template>

	<xsl:template match="catalog-definitions/sql:rowset/sql:row">
			<object o="{sql:ctn}">
			<customer_id><xsl:value-of select="sql:customer_id"/></customer_id>
			<country><xsl:value-of select="sql:country"/></country>
			<division><xsl:value-of select="sql:division"/></division>
			<sop><xsl:value-of select="sql:sop"/></sop>
			<eop><xsl:value-of select="sql:eop"/></eop>
			<sos><xsl:value-of select="sql:sos"/></sos>
			<eos><xsl:value-of select="sql:eos"/></eos>
			<buy_online><xsl:value-of select="sql:buy_online"/></buy_online>
			<local_going_price><xsl:value-of select="sql:local_going_price"/></local_going_price>
			<deleted><xsl:value-of select="sql:deleted"/></deleted>
			<delete_after_date><xsl:value-of select="sql:delete_after_date"/></delete_after_date>
			<priority><xsl:value-of select="sql:priority"/></priority>
			<lastmodified><xsl:value-of select="sql:lastmodified"/></lastmodified>
		</object>
	</xsl:template>
  
  <xsl:template match="catalog-configurations/sql:rowset/sql:row">
    <ctl ct="PMT2SPOT" l="{sql:locale}"/>
  </xsl:template>
	<!-- -->
</xsl:stylesheet>
