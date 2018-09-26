<?xml version="1.0" encoding="UTF-8" ?> 
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                exclude-result-prefixes="sql source">
  <xsl:param name="dir" /> 
<!--
  For Marketing Master:
  <Product>
		<NC>863900016102</NC>  				Code12NC
		<CTN>100WT10P/27</CTN>  			CTN
    <Sector>Consumer Life Style</Sector>   Fixed
    <FormerPD>CE</FormerPD>         Fixed
    <Description></Description>   empty
		<ArticleGroupCode>0000</ArticleGroupCode>			Unknown (stored in ProductTree)
		<SubCategoryCode>THIN_CLIENT_SU</SubCategoryCode>       From Object Categorization
    <ObjectDeleted></ObjectDeleted>
  </Product>

  For Logistics Master:
  <Product>
    <CTN>100WT10P/27</CTN>        CTN
    <NC>863900016102</NC>         Code12NC
    <Sector>Consumer Life Style</Sector>   Fixed
    <FormerPD>CE</FormerPD>         Fixed
    <Description></Description>   empty
    <ArticleGroupCode>0000</ArticleGroupCode>     Unknown (stored in ProductTree)
    <SubCategoryCode>THIN_CLIENT_SU</SubCategoryCode>       From Object Categorization
    <ObjectDeleted></ObjectDeleted>
  </Product>
--> 
  <xsl:template match="entries">
    <!-- Marketing master export -->
    <source:write>
      <source:source>
        <xsl:value-of
          select="concat($dir,'/',@ct,'/outbox/','xSPOT_Marketing_Master_010','.',substring-before(@ct,'2'),'.',@ts,'.',@l,'.',@batchnumber,'.xml')" />
      </source:source>
      <source:fragment>
        <ProductsMsg version="2.0" docTimestamp="{entry[1]/octl-attributes/lastmodified_ts}" docSource="ProCoon">
          <xsl:apply-templates select="entry[@valid='true']/content/Product[@pmd='true' and CTN]" mode="MarketingMaster"/>
        </ProductsMsg>
      </source:fragment>
    </source:write>
    <!-- Logistics master export -->
    <source:write>
      <source:source>
        <xsl:value-of
          select="concat($dir,'/',@ct,'/outbox/','xSPOT_Logistics_Master_010','.',substring-before(@ct,'2'),'.',@ts,'.',@l,'.',@batchnumber,'.xml')" />
      </source:source>
      <source:fragment>
        <ProductsMsg version="2.0" docTimestamp="{entry[1]/octl-attributes/lastmodified_ts}">
          <xsl:apply-templates select="entry[@valid='true']/content/Product[@pmd='true' and NC]" mode="LogisticsMaster"/>
        </ProductsMsg>
      </source:fragment>
    </source:write>
  </xsl:template>
  <!--  
  -->
  <xsl:template match="Product" mode="MarketingMaster">
    <Product>
      <xsl:copy-of copy-namespaces="no" select="CTN" />
      <xsl:copy-of copy-namespaces="no" select="NC" />
      <xsl:copy-of copy-namespaces="no" select="Sector" />
      <xsl:copy-of copy-namespaces="no" select="FormerPD" />
      <xsl:copy-of copy-namespaces="no" select="Description" />
      <ArticleGroupCode>0000</ArticleGroupCode>
      <!-- xsl:copy-of copy-namespaces="no" select="ObjectDeleted" / -->
    </Product>
  </xsl:template>
  <!--  
  --> 
  <xsl:template match="Product" mode="LogisticsMaster">
    <Product>
      <xsl:copy-of copy-namespaces="no" select="NC" />
      <xsl:copy-of copy-namespaces="no" select="CTN" />
      <xsl:copy-of copy-namespaces="no" select="Sector" />
      <xsl:copy-of copy-namespaces="no" select="FormerPD" />
      <xsl:copy-of copy-namespaces="no" select="Description" />
      <ArticleGroupCode>0000</ArticleGroupCode>
      <!-- xsl:copy-of copy-namespaces="no" select="ObjectDeleted" / -->
    </Product>
  </xsl:template>

  <xsl:template match="entry" /> 
 <!--  erase everything else 
  --> 
  </xsl:stylesheet>