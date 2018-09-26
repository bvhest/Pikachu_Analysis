<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" exclude-result-prefixes="sql">

	<xsl:param name="timestamp"/>
	<xsl:variable name="processTimestamp" select="concat(substring($timestamp,1,4),'-',substring($timestamp,5,2),'-',substring($timestamp,7,2),'T',substring($timestamp,9,2),':',substring($timestamp,11,2),':',substring($timestamp,13,2))"/>

  <xsl:template match="/">
  
      <ObjectKeys docTimestamp="{$processTimestamp}" sourceSystem="PikachuB2C">
      <xsl:variable name="Var_Functionality"  select="/ProductsMsg/sql:rowset/sql:row/sql:data/object/RichTexts/RichText[@type=('Functionality')]" />

          <xsl:if test = "$Var_Functionality != ''">               
		          <xsl:if test = "$Var_Functionality/Chapter != ''">
		          <xsl:for-each-group select="$Var_Functionality/Chapter" group-by="@code">		          
			           <ObjectKey Action="add">
			              <TreeCode>41</TreeCode>
			              <TreeName>Product Features</TreeName>
			              <ParentCode/>
			              <ParentName/>
			              <ObjectCode><xsl:value-of select="@code"/></ObjectCode>         
			              <ObjectName><xsl:value-of select="Name"/></ObjectName>	              
	               </ObjectKey>
	            </xsl:for-each-group>   
              </xsl:if>
              
              <xsl:variable name="ParentCode">
	              <xsl:for-each select="distinct-values($Var_Functionality/Chapter[1]/@code)">
	                <xsl:value-of select="."/>
	              </xsl:for-each>
              </xsl:variable>              
              <xsl:variable name="ParentName">
                <xsl:for-each select="distinct-values($Var_Functionality/Chapter[1]/Name)">
                  <xsl:value-of select="."/>
                </xsl:for-each>
              </xsl:variable>
      
              <xsl:for-each-group select="$Var_Functionality/Item" group-by="@code">
                <ObjectKey Action="add">
                   <TreeCode>41</TreeCode>
                   <TreeName>Product Features</TreeName>
                   <ParentCode><xsl:value-of select="$ParentCode"/></ParentCode>
                   <ParentName><xsl:value-of select="$ParentName"/></ParentName>
                   <ObjectCode><xsl:value-of select="@code"/></ObjectCode>         
                   <ObjectName><xsl:value-of select="Head"/></ObjectName>
                </ObjectKey>
              </xsl:for-each-group>
          </xsl:if>
      </ObjectKeys>
      
  </xsl:template>

	<!--  -->
</xsl:stylesheet>
