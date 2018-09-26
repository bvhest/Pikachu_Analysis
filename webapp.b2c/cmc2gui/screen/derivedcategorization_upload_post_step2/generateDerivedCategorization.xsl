<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
  xmlns:source="http://apache.org/cocoon/source/1.0"> 
  <!-- -->
  <xsl:param name="store-dir"/>  
  <!-- -->
  <xsl:variable name="mappings"><DerivedCategorizations><xsl:copy-of select="/DerivedCategorizations/DerivedCategorization"/></DerivedCategorizations></xsl:variable>
  <!-- -->
  <xsl:key name="k_destinationnodes" match="$mappings/DerivedCategorizations/DerivedCategorization" use="Destination"/>
  <!-- -->
  <xsl:template match="/DerivedCategorizations">
    <xsl:variable name="doctimestamp" select="replace(@DocTimeStamp,'[^0-9]','')"/>
    <xsl:variable name="result">
      <xsl:apply-templates select="sourcecategorization"/>
    </xsl:variable>
    <root>
      <!--
         | Write the output variable to a file
         | AND put it in the resulting XML for creating the preview.
       -->
      <source:write>
        <source:source>
          <xsl:value-of select="concat($store-dir,'/','DerivedCategorization_step2_',$doctimestamp,'.xml')"/>
        </source:source>
        <source:fragment>
          <xsl:copy-of select="$result" copy-namespaces="no"/>
        </source:fragment>
      </source:write>    
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="scheduleid"/>
        <xsl:copy-of select="$result" copy-namespaces="no"/>
      </xsl:copy>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="sourcecategorization">  
    <!-- Process nodes of destination tree -->
    <xsl:apply-templates select="sql:rowset/sql:row/sql:data/Categorization" mode="generate"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="Categorization/@DocTimeStamp" mode="generate">    
    <!-- update the timestamp on the dest cattree -->
    <xsl:attribute name="DocTimeStamp" select="ancestor::DerivedCategorizations/@DocTimeStamp"/>
  </xsl:template>  
  <!-- -->  
  <!-- Filter unused nodes of destination tree -->
  <xsl:template match="ATGCatalog|Group/@*|GroupReferenceName|GroupName|GroupRank|Category/@*|CategoryName|CategoryReferenceName|CategoryRank|SubCategory/@*|SubCategoryName|SubCategoryReferenceName|SubCategoryRank" mode="generate"/>
  <!-- -->
  <xsl:template match="GroupCode|CategoryCode|SubCategoryCode" mode="generate">
    <!-- Process a node on the destination tree -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="generate"/>
    </xsl:copy>
    <!-- Check if there is a mapping for this destination node to a node on the source tree -->
    <xsl:if test="key('k_destinationnodes',.)">
      <!-- There is a mapping for this node. Process each mapping.. -->
      <xsl:variable name="destinationcode" select="."/>
      <xsl:for-each select="key('k_destinationnodes',$destinationcode)">
        <!-- Create a CatRef mapping -->
        <xsl:variable name="sourcecode" select="Source"/>
        <xsl:variable name="sourcelevel" select="SourceLevel"/>
        <xsl:variable name="sourcetree" select="SourceTree"/>
        <CatRef level="{$sourcelevel}" sourcetree="{$sourcetree}"><xsl:value-of select="$sourcecode"/></CatRef>
      </xsl:for-each>
    </xsl:if>    
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()" mode="generate">
    <!-- Process a node on the destination tree -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="generate"/>
    </xsl:copy>
  </xsl:template>  
</xsl:stylesheet>