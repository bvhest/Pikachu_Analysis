<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:cinclude="http://apache.org/cocoon/include/1.0" exclude-result-prefixes="sql xsl cinclude">

  <!--  -->
   <xsl:template match="@*|node()">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
  </xsl:template>
  <!-- -->  
  <xsl:template match="@*|node()" mode="product">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"  mode="product"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->
  <xsl:template match="octl|sql-rowset|sql-row|sql-data" mode="product">
    <xsl:apply-templates select="@*|node()" mode="product"/>
  </xsl:template>    
  <!--  -->
  <xsl:template match="sql:*" mode="product"/>
  <!--  -->    
  <xsl:template match="entry/content/octl/sql-rowset/sql-row[sql-content_type='PMT_Translated']/sql-data/Product">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="product"/>
    </xsl:copy>
  </xsl:template>   
  <!-- -->
  <xsl:template match="ObjectAssetList"  mode="product">      
    <xsl:variable name="objectassets">
      <!-- Merge assets from primary data and secondary data -->
      <xsl:for-each-group select="octl/sql-rowset/sql-row|Object" group-by="concat(sql-object_id,id)">
        <Object>       
          <id><xsl:value-of select="current-grouping-key()"/></id>
          <xsl:for-each select="current-group()/sql-data/object/Asset[ResourceType!='BLR']|current-group()/Asset[ResourceType!='BLR']">
            <xsl:sort select="ResourceType"/>
            <xsl:apply-templates select="." mode="product"/>
          </xsl:for-each>
        </Object>
      </xsl:for-each-group>
   </xsl:variable>
   <xsl:copy>
     <xsl:apply-templates select="$objectassets/Object">
       <xsl:sort select="id"/>
     </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>       
  <!-- -->  
  <xsl:template match="Award[octl/sql-rowset]" mode="product">      
    <xsl:for-each select="octl/sql-rowset/sql-row/sql-data/object/Awards/Award">
      <xsl:apply-templates select="." mode="product"/>
    </xsl:for-each>
  </xsl:template>        
  <!-- -->    
  <xsl:template match="Product/NamingString/Range"  mode="product">      
    <xsl:copy>
     <xsl:copy-of select="RangeCode" copy-namespaces="no"/>     
     <xsl:choose>
       <xsl:when test="octl/sql-rowset/sql-row/sql-data/Node">
         <RangeName><xsl:value-of select="octl/sql-rowset/sql-row/sql-data/Node/Name"/></RangeName>
       </xsl:when>
       <xsl:otherwise>
         <xsl:copy-of select="RangeName" copy-namespaces="no"/>
       </xsl:otherwise>
     </xsl:choose>
    </xsl:copy>
  </xsl:template>          
  <!-- -->
  <xsl:template match="Product/RichTexts" mode="product"> 
	 <xsl:variable name="rt_product" select="."/>
       
    <RichTexts>
      <!-- Copy secondary RichText elements with Items but no Chapter -->    
      <xsl:for-each select="octl/sql-rowset/sql-row/sql-data/object/RichTexts/RichText[Item][not(Chapter)]">
        <xsl:copy-of select="." copy-namespaces="no"/>    
      </xsl:for-each>
      <xsl:variable name="itemcodes">
        <itemcodes>
          <xsl:for-each select="octl/sql-rowset/sql-row/sql-data/object/RichTexts/RichText/Item/@code">
            <itemcode><xsl:value-of select="."/></itemcode>
          </xsl:for-each>
        </itemcodes>
      </xsl:variable>
      <!-- Copy original RichText elements that are not available as secondary -->
      <xsl:for-each select="RichText[not(Chapter)]">
        <xsl:if test="Item[not(@code = $itemcodes/itemcodes/itemcode)]">
          <xsl:copy>
            <xsl:copy-of select="@*" copy-namespaces="no"/>
            <xsl:copy-of select="Item[not(@code = $itemcodes/itemcodes/itemcode)]" copy-namespaces="no"/>
          </xsl:copy>
        </xsl:if>
      </xsl:for-each>
      
      <!--
        Merge RichTexts with Chapters.
        Each RichText has one and only one Chapter.
        Multiple RichTexts of the same type may exist, e.g. "Gifting"
        Secondary RichText Items have precedence over RichTexts that are in the product.
        The merge is performed by taking RichText Items from the secondaries and adding
        the Items from the product RichTexts that are not in the secondaries. 
      -->
      <xsl:for-each-group select="octl/sql-rowset/sql-row/sql-data/object/RichTexts/RichText[Chapter] | RichText[Chapter]" group-by="concat(@type,Chapter/@code)">
        <RichText type="{current-group()[1]/@type}">
          <xsl:copy-of select="current-group()[1]/Chapter"/>
          <!-- Copy all Items that come from the secondary -->
          <xsl:variable name="sec-items" select="current-group()[../../../object]/Item"/>
          <xsl:copy-of select="$sec-items"/>
          <!-- Copy Items from the product that are not in the secondary -->
          <xsl:copy-of select="current-group()[not(../../../object)]/Item[not(@code = $sec-items/@code)]"/>
        </RichText>
      </xsl:for-each-group>
    </RichTexts>
  </xsl:template>          
</xsl:stylesheet>
