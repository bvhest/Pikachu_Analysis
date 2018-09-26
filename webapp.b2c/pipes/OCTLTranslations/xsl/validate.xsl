<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"  xmlns:my="http://www.philips.com/nvrl" xmlns:xs="http://www.w3.org/2001/XMLSchema" extension-element-prefixes="my">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!-- -->      
  <xsl:template match="root">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- -->    
  <xsl:template match="entries">
    <entries>
      <xsl:copy-of copy-namespaces="no" select="@*"/>
      <xsl:apply-templates/>
    </entries>
  </xsl:template>
  <!-- -->    
  <xsl:template match="entry">
    <entry>
      <xsl:copy-of copy-namespaces="no" select="@*" />
      <xsl:choose>
        <xsl:when test="not (currentlastmodified_ts) or string-length(currentlastmodified_ts) = 0">
          <xsl:attribute name="valid">false</xsl:attribute>
          <result>No Placeholder</result>
        </xsl:when>
        <xsl:when test="currentlastmodified_ts eq octl-attributes/lastmodified_ts and currentmasterlastmodified_ts eq octl-attributes/masterlastmodified_ts">
          <xsl:attribute name="valid">true</xsl:attribute>
          <result>OK</result>
          <content>
            <xsl:copy-of select="my:validateContent(content)" />
          </content>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="result" select="my:validateContent(content)" />
          <xsl:choose>
            <xsl:when test="$result//error">
              <xsl:attribute name="valid">false</xsl:attribute>
              <result>
                <xsl:copy-of select="$result//error" />
              </result>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="valid">true</xsl:attribute>
              <xsl:choose>
                <xsl:when test=" octl-attributes/lastmodified_ts &lt; currentlastmodified_ts">
                  <result>out-of-date</result>
                </xsl:when>
                <xsl:otherwise>
                  <result>OK</result>
                </xsl:otherwise>
              </xsl:choose>
              <content>
                <xsl:copy-of select="$result" />
              </content>
              <xsl:copy-of copy-namespaces="no" select="octl-attributes" />
              <xsl:copy-of copy-namespaces="no" select="process" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </entry>
  </xsl:template>
  <!-- -->        
  <xsl:function name="my:validateContent">
    <xsl:param name="content"/>
    <xsl:apply-templates select="$content/node()|$content/@*"/>
  </xsl:function>        
  <!-- -->      
  <xsl:template match="@*|node()">
    <xsl:choose>
      <!-- Get rid of translation export specific attributes if applicable -->
      <xsl:when test="./@translate">
        <!-- Copy the element, but do not process the attributes -->
        <xsl:variable name="elementtext" select="normalize-space(.)"/>
        <xsl:variable name="maxLen" select="xs:integer(@maxlength)"/>
        <xsl:variable name="len" select="string-length($elementtext)"/>    
        <xsl:choose>
          <xsl:when test="$len gt $maxLen">
            <error maxLength="{$maxLen}" actualLength="{$len}">
              <xsl:copy copy-namespaces="no">
                  <xsl:apply-templates select="node()"/>
              </xsl:copy>
            </error>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy copy-namespaces="no">
              <xsl:apply-templates select="node()"/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- Copy the element and also process possible attributes -->
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
