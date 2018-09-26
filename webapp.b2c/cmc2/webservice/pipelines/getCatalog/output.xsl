<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                >
                
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:import href="../service-functions.xsl"/>
  <xsl:import href="../service-base.xsl"/>
  
  <!-- Override service-base -->
  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>
  
  <xsl:template match="sql:rowset">
    <tns:Catalogs Version="1.0" Timestamp="{fn:current-dateTime()}">
      <xsl:for-each-group select="sql:row" group-by="sql:division">
        <tns:Catalog Currency="___">
          <xsl:attribute name="CatalogTypeName">
            <xsl:value-of select="fn:current-group()[1]/sql:customer_id"/>
          </xsl:attribute>
          <xsl:attribute name="Country">
            <xsl:value-of select="fn:current-group()[1]/sql:country"/>
          </xsl:attribute>
          <xsl:attribute name="ProductDivisionCode">
            <xsl:value-of select="svc:division-for-name(fn:current-group()[1]/sql:division)/@code"/>
          </xsl:attribute>

          <xsl:apply-templates select="fn:current-group()"/>
        </tns:Catalog>      
      </xsl:for-each-group>
    </tns:Catalogs>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <xsl:if test="svc:catalog-allowed(sql:catalogcode)">
      <tns:CatalogProduct
        AvailableForOnline="{if(sql:buy_online = 1) then 'true' else 'false'}"
        CTN="{sql:object_id}"
        LastModified="{svc:fix-dateTime(sql:lastmodified)}"
        StartOfPublication="{svc:fix-date(sql:sop)}"
        EndOfPublication="{svc:fix-date(sql:eop)}"
        StartOfSales="{svc:fix-date(sql:sos)}"
        EndOfSales="{svc:fix-date(sql:eos)}"
        Action="add"
      />
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
