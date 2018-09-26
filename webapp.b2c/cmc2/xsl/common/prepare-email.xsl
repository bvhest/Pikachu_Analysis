<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:email="http://apache.org/cocoon/transformation/sendmail">
  
  <xsl:param name="email-to"/>
  <xsl:param name="email-from"/>
  
  <xsl:preserve-space elements="email:body" />
  
  <xsl:param name="l-email-from" select="if ($email-from = '') then 'pikachu@pww.pikachu.philips.com' else $email-from"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="email:sendmail">
    <xsl:if test="email-to != '' or matches($email-to, '\w+@\w+\.\w+')">
      <xsl:copy copy-namespaces="no">
        <xsl:if test="empty(email-from) or email-from = ''">
          <email:from><xsl:value-of select="$l-email-from"/></email:from>
        </xsl:if>
        <xsl:if test="empty(email-to) or email-to = ''">
          <email:to><xsl:value-of select="$email-to"/></email:to>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <!-- Convert any email resulting elements to prevent an error in the sendmail transformer -->
  <xsl:template match="email:result|email:error|email:success">
    <xsl:element name="concat('email-', local-name(.))">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>