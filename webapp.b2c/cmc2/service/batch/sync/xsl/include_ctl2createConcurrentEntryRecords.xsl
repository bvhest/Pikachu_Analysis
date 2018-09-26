<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i="http://apache.org/cocoon/include/1.0" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="timestamp"/>
  <xsl:param name="ct"/>
  <xsl:param name="concurrency"/>

  <xsl:template match="/">
    <root>
      <xsl:for-each-group select="//sql:rowset/sql:row" group-by="sql:country_code">      
        <xsl:for-each select="current-group()">
          <xsl:if test="(position() -1) mod number($concurrency) = 0">
            <i:include src="cocoon:/createConcurrentEntryRecords/{sql:content_type}/{sql:input_content_type}/{sql:country_code}/{$timestamp}?start_batch_number={position()}&amp;end_batch_number={position()+number($concurrency)-1}"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each-group>        
    </root>
  </xsl:template>
</xsl:stylesheet>
