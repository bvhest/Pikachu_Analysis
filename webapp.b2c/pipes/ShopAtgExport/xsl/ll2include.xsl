<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:my="http://pww.pikachu.philips.com/functions/local">

  <xsl:param name="timestamp"></xsl:param>
  <xsl:param name="channel"></xsl:param>
  <xsl:param name="country"></xsl:param>
  <xsl:param name="locale"></xsl:param>
  <xsl:param name="delta" />
  
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()" />
  </xsl:template>
  
  <xsl:template match="sql:rowset">
    <xsl:variable name="count" select="sum(sql:row/sql:number_ctns)" />
    <xsl:choose>
      <xsl:when test="$delta='y'">
        <xsl:choose>
          <xsl:when test="number($count) > 0">
            <xsl:sequence select="my:create-includes($timestamp,$country,$locale,sql:row[1]/sql:maxbatch,sql:row[1]/sql:maxbatch)" />
          </xsl:when>
          <xsl:otherwise>
            <batch exportdate="{$timestamp}" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@*|node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sql:row">
    <xsl:variable name="batch" select="sql:batch" as="xs:integer" />
    <xsl:variable name="maxbatch" select="sql:maxbatch" as="xs:integer" />
    <xsl:variable name="timestampint" select="xs:integer($timestamp)" />
    <xsl:variable name="runtimestamp" select="$timestampint + ($batch - 1)" />
    <xsl:sequence select="my:create-includes($runtimestamp,$country,$locale,$batch,$maxbatch)" />
  </xsl:template>

  <xsl:function name="my:create-includes">
    <xsl:param name="timestamp"/>
    <xsl:param name="country"/>
    <xsl:param name="locale"/>
    <xsl:param name="batch"/>
    <xsl:param name="maxbatch"/>
    
    <cinclude:include src="{concat('cocoon:/exportSub.',$timestamp,'.',$country,'.',$locale,'.',$batch,'.',$maxbatch)}" />
    
    <xsl:if test="$batch = $maxbatch">
      <cinclude:include src="{concat('cocoon:/aggregateProductAccessories.',$timestamp,'.',$country,'.',$locale,'.',$maxbatch)}" />
      <cinclude:include src="{concat('cocoon:/archiveFiles.',$timestamp,'.',$locale)}" />
    </xsl:if>
  </xsl:function>
</xsl:stylesheet>