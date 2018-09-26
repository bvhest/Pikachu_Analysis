<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
    
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="dir"/>
  <xsl:param name="prefix" select="'batch.'"/>
  <xsl:param name="threads" default="2"/>

  <xsl:variable name="now" select="current-dateTime()"/>
  <xsl:variable name="snow" select="replace(replace(substring(xs:string(current-dateTime()),1,16),':',''),'-','')"/>
  <xsl:variable name="threads-num" select="number($threads)"/>

  <xsl:template match="/root">
    <root>
      <xsl:for-each-group select="cinclude:include" group-by="floor((position()-1) div $threads-num)">
        <xsl:variable name="batch-num" select="format-number(current-grouping-key(), '000')"/>
        <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
          <source:source>
            <xsl:value-of select="fn:concat($dir, '/', $prefix, $snow, '.', $batch-num, '.xml')"/>
          </source:source>
          <source:fragment>
            <root>
              <xsl:copy-of select="current-group()"/>
            </root>
          </source:fragment>
        </source:write>
      </xsl:for-each-group>
    </root>
  </xsl:template>

</xsl:stylesheet>