<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                xmlns:info="http://www.philips.com/pikachu/3.0/info"
                exclude-result-prefixes="info">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="inbox_dir"/>
  <xsl:param name="filename"/>
  
  <xsl:template match="@*[not(starts-with(name(.),'info:'))]|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Lose the info: attributes -->
  <xsl:template match="@*[starts-with(name(.),'info:')]"/>
    
  <xsl:template match="KeyValuePairs">
    <root>
      <!--
         | Write the Localization input file to the ct inbox
         -->
      <source:write>
        <source:source>
          <xsl:value-of select="concat($inbox_dir,'/',$filename,'.xml')"/>
        </source:source>
        <source:fragment>
          <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
        </source:fragment>
      </source:write>

    </root>
  </xsl:template>
  
</xsl:stylesheet>
