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
    <xsl:param name="locale"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()">
       <xsl:with-param name="locale" select="$locale"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <!-- Lose the info: attributes -->
  <xsl:template match="@*[starts-with(name(.),'info:')]"/>
    
  <xsl:template match="RichText_Raw[@DocTimeStamp]">
    <root>
      <!--
         | Write the RichText_Raw input file to the ct inbox
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
  
  <xsl:template match="RichText[@DocTimeStamp]">
    <root>
      <!--
         | Write the RichText input file to the ct inbox
         -->
        <source:write>
          <source:source>
            <xsl:value-of select="concat($inbox_dir,'/',$filename,'.xml')"/>
          </source:source>
          <source:fragment>
            <xsl:copy copy-namespaces="no">
              <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="locale" select="."/>
              </xsl:apply-templates>
            </xsl:copy>
          </source:fragment>
        </source:write>
    </root>
  </xsl:template>

  <xsl:template match="RichText[@DocTimeStamp]/object">  
    <xsl:variable name="object" select="."/>
    <xsl:for-each select="tokenize(@locales,',')">
      <object>      
        <xsl:apply-templates select="$object/@object_id"/>
        <xsl:attribute name="l" select="."/>    
        <xsl:apply-templates select="$object/node()"/>
      </object>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
