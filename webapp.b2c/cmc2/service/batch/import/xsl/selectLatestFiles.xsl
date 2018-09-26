<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="sql xsl source dir">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->
  <xsl:param name="dir"></xsl:param>
  <xsl:param name="prefix"></xsl:param>
  <xsl:param name="ct"></xsl:param>  
  <xsl:param name="usebasicsort"></xsl:param>  
  <!-- -->
  <xsl:template match="/dir:directory">
    <xsl:variable name="now" select="substring(xs:string(current-dateTime()),1,19)"/>
    <xsl:variable name="snow" select="translate($now,'-:T','')"/>
    <xsl:variable name="ct-dashed" select="replace($ct,'_','-')"/>
      <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
        <source:source>
          <xsl:value-of select="concat($dir,$prefix,'_',$snow,'_filelist.xml')"/>
        </source:source>
        <source:fragment>        
          <root DocTimeStamp="{$snow}">
            <xsl:choose>
              <xsl:when test="$usebasicsort = 'yes'">
                <!-- basic sort assumes each file has one object only and sorts the files on DocTimeStamp. E.g. Localization -->
                <group ct="{$ct}" l="{dir:file[1]/dir:xpath/node()[1]/@l}" o="{dir:file[1]/dir:xpath/node()[1]/@o}">
                  <xsl:for-each select="dir:file">
                    <xsl:sort select="dir:xpath/node()/@DocTimeStamp" as="xs:dateTime" order="descending"/>                
                    <file>
                      <xsl:attribute name="name" select="@name"/>
                      <xsl:attribute name="select" select="if (position() = 1) then 'yes' else 'no'"/>                  
                      <xsl:copy-of select="dir:xpath/node()/@*"/>                              
                    </file>
                  </xsl:for-each>
                </group>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each-group select="dir:file" group-by="concat(dir:xpath/node()[local-name()=$ct-dashed]/@ct,'_',dir:xpath/node()[local-name()=$ct-dashed]/@l,'_',dir:xpath/node()[local-name()=$ct-dashed]/@o)">
                  <group ct="{current-group()[1]/dir:xpath/node()[local-name()=$ct-dashed]/@ct}" l="{current-group()[1]/dir:xpath/node()[local-name()=$ct-dashed]/@l}" o="{current-group()[1]/dir:xpath/node()[local-name()=$ct-dashed]/@o}">
                    <xsl:for-each select="current-group()">
                      <xsl:sort select="dir:xpath/node()[local-name()=$ct-dashed]/@DocTimeStamp" as="xs:dateTime" order="descending"/>                                   
                      <file>
                        <xsl:attribute name="name" select="@name"/>
                        <xsl:attribute name="select" select="if (position() = 1) then 'yes' else 'no'"/>                  
                        <xsl:copy-of select="dir:xpath/node()[local-name()=$ct-dashed]/@*"/>                              
                      </file>
                    </xsl:for-each>  
                  </group>
                </xsl:for-each-group>
              </xsl:otherwise>          
            </xsl:choose>
          </root>        
        </source:fragment>
      </source:write>
  </xsl:template>
  <!-- -->    
</xsl:stylesheet>
