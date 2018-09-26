<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                xmlns:info="http://www.philips.com/pikachu/3.0/info"
                exclude-result-prefixes="info">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="pconfig_inbox_dir"/>
  <xsl:param name="ptext_inbox_dir"/>
  <xsl:param name="project_file"/>
  
  <xsl:template match="@*[not(starts-with(name(.),'info:'))]|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Lose the info: attributes -->
  <xsl:template match="@*[starts-with(name(.),'info:')]"/>
    
  <xsl:template match="PackagingProjectConfiguration">
    <root>
      <!--
         | Write the PP_Configuration input file
         -->
      <source:write>
        <source:source>
          <xsl:value-of select="concat($pconfig_inbox_dir,'/',$project_file,'.xml')"/>
        </source:source>
        <source:fragment>
          <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|Localizations|ProductReferences"/>
          </xsl:copy>
        </source:fragment>
      </source:write>
      <!--
         | Write the PText_Raw input file
         -->
      <source:write>
        <source:source>
          <xsl:value-of select="concat($ptext_inbox_dir,'/',$project_file,'.xml')"/>
        </source:source>
        <source:fragment>
          <xsl:apply-templates select="PackagingText"/>
        </source:fragment>
      </source:write>
    </root>
  </xsl:template>
  
</xsl:stylesheet>
