<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0">

  <xsl:param name="system" />
  <xsl:param name="exportdate" />
  <xsl:param name="full" />

  <xsl:variable name="rundate" select="concat(substring($exportdate,1,4)
                                             ,'-'
                                             ,substring($exportdate,5,2)
                                             ,'-'
                                             ,substring($exportdate,7,2)
                                             ,'T'
                                             ,substring($exportdate,10,2)
                                             ,':'
                                             ,substring($exportdate,12,2)
                                             ,':00')" />

  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:rowset[@name='product-catg']"/>

  <xsl:template match="/root">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="exportTimestamp" select="$rundate" />
      <xsl:attribute name="isFullExport" select="$full" />
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="sql:rowset[@name='product']/sql:row/sql:data/Product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      <Categorizations>
        <xsl:apply-templates select="/root/sql:rowset[@name='product-catg']/sql:row[sql:object_id=current()/CTN]" mode="get-catg"/>
      </Categorizations>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sql:row" mode="get-catg">
    <Categorization catalogcode="{sql:catalogcode}">
      <Group code="{sql:groupcode}">
        <Name>
          <xsl:value-of select="sql:groupname" />
        </Name>
        <SEOName>
          <xsl:value-of select="lower-case(if (sql:islatin = '1') then sql:groupname else sql:mastergroupname)" />
        </SEOName>
      </Group>
      <Category code="{sql:categorycode}">
        <Name>
          <xsl:value-of select="sql:categoryname" />
        </Name>
        <SEOName>
          <xsl:value-of select="lower-case(if (sql:islatin = '1') then sql:categoryname else sql:mastercategoryname)" />
        </SEOName>
      </Category>
      <Subcategory code="{sql:subcategorycode}">
        <Name>
          <xsl:value-of select="sql:subcategoryname" />
        </Name>
        <SEOName>
          <xsl:value-of select="lower-case(if (sql:islatin = '1') then sql:subcategoryname else sql:mastersubcategoryname)" />
        </SEOName>
      </Subcategory>
    </Categorization>
  </xsl:template>
    
</xsl:stylesheet>
