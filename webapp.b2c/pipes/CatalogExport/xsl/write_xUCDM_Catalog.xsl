<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:my="http://pww.pikachu.philips.com/functions/local">

  <xsl:param name="ts"/>
  <xsl:param name="dir"/>
  <xsl:param name="prefix"/>
  
  <xsl:variable name="formatted-ts" select="concat(substring($ts,1,4),'-',substring($ts,5,2),'-',substring($ts,7,2),
      'T',substring($ts,9,2),':',substring($ts,11,2),':',substring($ts,13,2))"/>
  
  <xsl:template match="/root">
    <xsl:copy>
      <xsl:apply-templates select="sql:rowset"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:rowset">
    <xsl:variable name="first-row" select="sql:row[1]"/>
    
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="concat($dir,'/',$prefix,$first-row/sql:catalog_id,'.',$ts)"/>
        <xsl:text>.xml</xsl:text>
      </source:source>
      <source:fragment>
        <Catalogs Timestamp="{$formatted-ts}">
          <Catalog CatalogTypeName="{$first-row/sql:customer_id}"
                   Country="{$first-row/sql:country}"
                   Currency="EUR"
                   ProductDivisionCode="{my:get-division-code($first-row/sql:division)}">
            <xsl:apply-templates select="sql:row"/>
          </Catalog>
        </Catalogs>
      </source:fragment>
    </source:write>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <!-- The action attribute is not entirely correct, because we do not make a distinction between add and update,
         but for CCR this doesn't matter -->
    <CatalogProduct Action="{if (sql:deleted != '0') then 'delete' else 'add'}" 
                    CTN="{sql:object_id}"
                    StartOfPublication="{sql:sop}"
                    EndOfPublication="{sql:eop}"
                    StartOfSales="{if (sql:sos &lt; sql:eos) then sql:sos else sql:sop}"
                    EndOfSales="{if (sql:sos &lt; sql:eos) then sql:eos else sql:eop}"
                    LastModified="{sql:lastmodified}"
                 />
  </xsl:template>
  
  <xsl:function name="my:get-division-code">
    <xsl:param name="division-name"/>
    <xsl:variable name="lc-name" select="lower-case($division-name)"/>
    <xsl:choose>
      <xsl:when test="$lc-name = 'lighting'">
        <xsl:text>0100</xsl:text>
      </xsl:when>
      <xsl:when test="$lc-name = 'cls'">
        <xsl:text>0200</xsl:text>
      </xsl:when>
      <xsl:when test="$lc-name = 'dap'">
        <xsl:text>0300</xsl:text>
      </xsl:when>
      <xsl:when test="$lc-name = 'ce'">
        <xsl:text>3400</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
