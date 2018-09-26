<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:email="http://apache.org/cocoon/transformation/sendmail">

  <xsl:param name="timestamp"/>
  <xsl:param name="sender"/>
  <xsl:param name="server"/>
  <xsl:param name="recipient"/>
  <xsl:param name="ct"/>

  <xsl:template match="node()|@*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="source">
    <xsl:copy>
      <warning>
        <xsl:text>Too many deletions in </xsl:text>
        <xsl:value-of select="$ct" />
        <xsl:text> xml feed</xsl:text>
      </warning>
      <email:sendmail>
        <email:from>
          <xsl:value-of select="$sender" />
        </email:from>
        <email:to>
          <xsl:value-of select="$recipient" />
        </email:to>
        <email:subject>
          <xsl:value-of select="concat('Warning: Too many deletions in ',$ct,' xml feed  (instance:',substring-before(substring-after($server,'http://'),':'),'). Autogenerated email sent at ',$timestamp,' by Pika Chu')" />
        </email:subject>
        <email:body mime-type="text/plain">
<xsl:text>
Too many deleted products
=========================

See attached logfile.
</xsl:text>
        </email:body>
        <xsl:variable name="logfilename" select="tokenize(.,'/')[last()]" />
        <email:attachment name="{$logfilename}" mime-type="text/xml" url="{concat('cocoon:/file__',.)}" />
      </email:sendmail>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
