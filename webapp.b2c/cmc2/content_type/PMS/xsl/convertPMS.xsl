<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql">

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sql:rowset" />

  <xsl:template match="content[../@valid='true']">
    <xsl:copy copy-namespaces="no">

      <xsl:choose>
        <xsl:when test="sql:rowset/sql:row/sql:pms_data/Product">
          <xsl:copy-of copy-namespaces="no" select="sql:rowset/sql:row/sql:pms_data/Product" />
        </xsl:when>
        <xsl:otherwise>
          <!-- create empty document -->
          <Product id="{../@o}">
            <MasterData />
            <Categorization />
            <ThumbnailURL />
            <MediumImageURL />
            <PreviewURL />
            <Content />
            <Countries/>
            <OpenInPFS_URL />
            <OpenInCCRUW_URL />
            <EvaluationData>
              <MasterData />
              <Catalogs/>
              <Text />
              <Assets />
              <ObjectAssets />
            </EvaluationData>
          </Product>

        </xsl:otherwise>
      </xsl:choose>

    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
