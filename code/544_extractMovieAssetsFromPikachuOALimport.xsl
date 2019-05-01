<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="text" indent="no"/>

  <xsl:template match="/">
    <xsl:apply-templates select="ObjectsMsg"/>
  </xsl:template>

  <xsl:template match="ObjectsMsg">
    <xsl:text>md5,type,locale,accessrights,extension,parent_id,url,sec_url,int_url</xsl:text>
    <xsl:apply-templates select="Object"/>
  </xsl:template>

  <xsl:template match="Object">
    <xsl:variable name="objectID" select="ObjectID"/>
    <xsl:apply-templates select="Asset[ResourceType = ['CVG', 'CVI', 'CVL', 'CVP', 'FML', 'FQL', 
                            'FV1', 'FV2', 'FV3', 'FV4', 'FV5', 
                            'HQ1', 'HQ2', 'HQ3', 'HQ4', 'HQ5', 'P3F',
                            'PM2', 'PM3', 'PM4', 'PM5', 'PRM', 'SDM',
                            'TV1', 'TV2','TV3','TV4','TV5']]">
      <xsl:with-param name="objectID" select="$objectID" />
    </xsl:apply-templates>
  </xsl:template>

  <!-- create lines with asset data: -->
  <xsl:template match="Asset">
    <xsl:param name = "objectID" />
"<xsl:value-of select="Md5" />","<xsl:value-of select="ResourceType" />","<xsl:value-of select="Language" />","<xsl:value-of select="AccessRights" />","<xsl:value-of select="Format" />","<xsl:value-of select="$objectID" />","<xsl:value-of select="PublicResourceIdentifier" />","<xsl:value-of select="SecureResourceIdentifier" />","<xsl:value-of select="InternalResourceIdentifier" />"<xsl:text>&#xD;</xsl:text>
  </xsl:template>

</xsl:stylesheet>