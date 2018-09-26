<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:autn="http://schemas.autonomy.com/aci/" xmlns:xslt2="urn:xslt2Functions" exclude-result-prefixes="xs xslt2 autn">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="yes" />
  <xsl:param name="id" />
  <xsl:param name="searchtext" />

  <xsl:template match="/">
    <Documents id="{$id}">
        <!-- Handle all documents that actually have a DREFULLFILENAME, other entries are no files (e.g. reference to the library) -->
      <xsl:apply-templates select="/autnresponse/responsedata/autn:hit" />
    </Documents>
  </xsl:template>

  <xsl:template match="autn:hit">
    <Document
      id="{autn:id}"
      label="{autn:title}"
      type="{autn:content/DOCUMENT/PHILIPS.FILETYPE}"
      url="{autn:reference}"
      author=""
      target="{autn:content/DOCUMENT/SP_TARGET}"
      topics="{autn:content/DOCUMENT/SP_MARKETING_X0020_TOPICS}"
      sector="{autn:content/DOCUMENT/PARAM.SECTOR}"
      lib="{substring-after(autn:content/DOCUMENT/OPENFOLDER, '/B2C/')}"
      pubDate="{autn:content/DOCUMENT/SP_PUBLICATION_X0020_DATE}"
      imageUrl=""
      fileRef="{autn:content/DOCUMENT/SP_FILELEAFREF}">
      <xsl:value-of select="encode-for-uri(autn:summary)"/>
    </Document>
  </xsl:template>

</xsl:stylesheet>