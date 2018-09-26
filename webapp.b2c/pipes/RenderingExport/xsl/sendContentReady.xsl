<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:email="http://apache.org/cocoon/transformation/sendmail" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:status="http://apache.org/cocoon/status/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="host"/>
  <xsl:param name="sender"/>
  <xsl:param name="recipient"/>
  <xsl:param name="localetype"/>
  <!-- -->
  <xsl:template match="//dir:file">
    <document>
      <email:sendmail>
        <email:from><xsl:value-of select="$sender"/></email:from>
        <!-- Only send email to $recipient if request has been generated on Production i.e. nlyehvgdc1ux022 -->
        <xsl:if test="contains($host,'nlyehvgdc1ux022')">
          <email:to><xsl:value-of select="$recipient"/></email:to>
        </xsl:if>
        <email:subject>RenderingExport - <xsl:value-of select="$localetype"/> Content Ready file (generated on host <xsl:value-of select="$host"/>)</email:subject>
        <email:body>Please see attached file for details.</email:body>
        <email:attachment name="{@name}" mime-type="text/plain" url="{concat('cocoon:/file_',@name)}"/>
      </email:sendmail>
    </document>
  </xsl:template>
</xsl:stylesheet>
