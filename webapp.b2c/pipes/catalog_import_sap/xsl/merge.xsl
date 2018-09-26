<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:source="http://apache.org/cocoon/source/1.0">

  <xsl:param name="target-dir"/>
    
  <xsl:template match="node()|@*" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/root">
    <xsl:variable name="ts" select="translate(Catalogs[1]/@Timestamp,'-T:','')"/>
    
    <xsl:copy copy-namespaces="no">
      <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
        <source:source><xsl:value-of select="concat($target-dir,'/pikachu_full_SHOP_',$ts,'.xml')"/></source:source>
        <source:fragment>
          <Catalogs>
            <xsl:apply-templates select="Catalogs[1]/@*"/>
            <xsl:for-each-group select="Catalogs/Catalog" group-by="concat(@CatalogTypeName,'|',@Country,'|',@ProductDivisionCode)">
              <Catalog>
                <xsl:apply-templates select="current-group()[1]/@*" mode="SHOP"/>
                
                <!-- 
                  SAP can send products more than once.
                  This happens when in SAP a CTN is 'moved' to a new 12NC.
                  SAP will then send a delete Action for the old 12NC and an add Action for the new one.
                  To fix this we deduplicate the CTNs and give precedence to add Actions.
                -->
                <xsl:for-each-group select="current-group()/CatalogProduct" group-by="@CTN">
                  <xsl:choose>
                    <xsl:when test="current-group()[@Action='add']">
                      <xsl:apply-templates select="(current-group()[@Action='add'])[1]" mode="SHOP" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="(current-group()[@Action='delete'])[1]" mode="SHOP" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each-group>
              </Catalog>
            </xsl:for-each-group>
          </Catalogs>
        </source:fragment>
      </source:write>
      
      <!-- FLAGSHIPSHOP catalog generation disabled. Still sent by LCB/CCB.
      <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
        <source:source><xsl:value-of select="concat($target-dir,'/pikachu_full_FSS_',$ts,'.xml')"/></source:source>
        <source:fragment>
          <Catalogs target="FSS">
            <xsl:apply-templates select="Catalogs[1]/@*"/>
            <xsl:for-each-group select="Catalogs/Catalog" group-by="@Country">
              <Catalog>
                <xsl:attribute name="CatalogTypeName" select="'FLAGSHIPSHOP'"/>
                <xsl:apply-templates select="@Country|@ProductDivisionCode|@Currency"/>
                
                <xsl:for-each-group select="current-group()/CatalogProduct" group-by="@CTN">
                  <CatalogProduct>
                    <xsl:attribute name="CTN" select="@CTN"/>
                    <xsl:attribute name="StartOfPublication" select="min(current-group()/@StartOfPublication/string())"/>
                    <xsl:attribute name="EndOfPublication" select="max(current-group()/@EndOfPublication/string())"/>
                    <xsl:attribute name="StartOfSales" select="min(current-group()/@StartOfSales/string())"/>
                    <xsl:attribute name="EndOfSales" select="max(current-group()/@EndOfSales/string())"/>
                    <xsl:attribute name="Action" select="if (current-group()[@Action != 'delete']) then (current-group()/@Action[string() != 'delete'])[1] else 'delete'"/>
                    <xsl:attribute name="LastModified" select="max(current-group()/@LastModified/string())"/>
                    <xsl:attribute name="SellOnline" select="if (current-group()[@SellOnline != 'N']) then (current-group()/@SellOnline[string() != 'N'])[1] else 'N'"/>
                    <xsl:attribute name="priority" select="@priority"/>
                  </CatalogProduct>
                </xsl:for-each-group>
              </Catalog>
            </xsl:for-each-group>
          </Catalogs>
        </source:fragment>
      </source:write>
      -->
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@CatalogTypeName" mode="SHOP">
    <xsl:attribute name="CatalogTypeName" select="concat('SHOP',substring(substring-after(.,'FLAGSHIPSHOP_'),1,3))"/>
  </xsl:template>
  
</xsl:stylesheet>