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
        <xsl:value-of select="concat($dir,'/',$prefix,$first-row/sql:catalog_id,'.',$ts,'.xml')"/>
      </source:source>
      <source:fragment>
        <catalog-definition DocTimeStamp="{$formatted-ts}"
                            ct="catalog_definition"
                            l="none"
                            o="{$first-row/sql:catalog_id}">
          <xsl:apply-templates select="sql:row"/>
        </catalog-definition>
      </source:fragment>
    </source:write>
  </xsl:template>
  
  <xsl:template match="sql:row">
    <!-- The action attribute is not entirely correct, because we do not make a distinction between add and update,
         but for CCR this doesn't matter -->
    <object o="{sql:object_id}">
      <deleted><xsl:value-of select="sql:deleted"/></deleted>
      <sop><xsl:value-of select="sql:sop"/></sop>
      <eop><xsl:value-of select="sql:eop"/></eop>
      <sos><xsl:value-of select="sql:sos"/></sos>
      <eos><xsl:value-of select="sql:eos"/></eos>
      <lastmodified><xsl:value-of select="sql:lastmodified"/></lastmodified>
      <customer_id><xsl:value-of select="sql:customer_id"/></customer_id>
      <division><xsl:value-of select="sql:division"/></division>
      <country><xsl:value-of select="sql:country"/></country>
    </object>
  </xsl:template>
</xsl:stylesheet>
