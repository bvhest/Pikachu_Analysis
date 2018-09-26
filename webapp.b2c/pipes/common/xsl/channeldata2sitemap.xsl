<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:map="http://apache.org/cocoon/sitemap/1.0">
  
  <xsl:param name="channel"/>
  
  <xsl:template match="/root">
    <map:sitemap>
      <map:pipelines>

        <xsl:apply-templates/>

        <map:pipeline type="noncaching">
          <map:match pattern="*.*/**">
            <map:mount check-reload="yes">
              <xsl:attribute name="src"><xsl:text>{1}/</xsl:text></xsl:attribute>
              <xsl:attribute name="uri-prefix"><xsl:text>{1}.{2}</xsl:text></xsl:attribute>
            </map:mount>
            <!--map:generate label="step1">
              <xsl:attribute name="src"><xsl:text>{1}/sitemap.xmap</xsl:text></xsl:attribute>
            </map:generate>
            <map:serialize/-->
          </map:match>
        </map:pipeline>
      </map:pipelines>
    </map:sitemap>
  </xsl:template>

  <xsl:template match="sql:rowset">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sql:row">
    <map:component-configurations>
      <global-variables>
        <ldir>
          <xsl:value-of select="if(contains(sql:location,'/')) then substring-before(sql:location,'/') else sql:location"/>
          <xsl:text>/</xsl:text>
        </ldir>
        <channel>
          <xsl:value-of select="if ($channel != '') then
                                  $channel
                                else
                                  if (contains(sql:name,'/')) then 
                                    substring-before(sql:name,'/')
                                  else
                                    sql:name"/>
        </channel>
      </global-variables>
    </map:component-configurations>
  </xsl:template>

</xsl:stylesheet>
