<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <!-- -->
  <xsl:variable name="debug" select="false()"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry[@valid='true' or (@valid = 'false' and result='No Placeholder')]">
    <!-- compare content on valid entries (means there is existing content) -->
    <xsl:variable name="o" select="@o"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*[not(local-name()='valid')] "/>
      <!-- now do the compare -->
      <xsl:variable name="currentContent">
        <xsl:apply-templates select="ancestor::entries/globalDocs/currentcontent/octl[object_id = $o]/data/object"/>
      </xsl:variable>
      <xsl:variable name="newContent">
        <xsl:apply-templates select="content/object"/>
      </xsl:variable>
       <xsl:choose>
        <xsl:when test="deep-equal($currentContent,$newContent)">
          <xsl:attribute name="valid">false</xsl:attribute>
          <xsl:element name="result">Identical octl exists</xsl:element>
          </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@valid|result"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()[not(local-name()='result')] "/>
      <xsl:if test="$debug">
       <xsl:variable name="isidentical" select="deep-equal($currentContent,$newContent)"/>
        <compare isidentical="{$isidentical}">
          <currentContent><xsl:copy-of select="$currentContent"/></currentContent>
          <newContent><xsl:copy-of select="$newContent"/></newContent>
        </compare>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="currentmasterlastmodified_ts[sql:rowset]">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="sql:rowset/sql:row/sql:masterlastmodified_ts"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="Awards">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="Award">
        <xsl:sort select="AwardCode"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  <!-- Ignore whitespace-only nodes -->
  <xsl:template match="text()[normalize-space() = '']"/>
</xsl:stylesheet>
