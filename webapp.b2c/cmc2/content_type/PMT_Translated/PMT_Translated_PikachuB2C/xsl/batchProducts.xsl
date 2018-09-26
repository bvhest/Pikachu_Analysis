<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:s="http://apache.org/cocoon/source/1.0"                
                exclude-result-prefixes="sql xsl cinclude xs s"
 >
  <xsl:output method="xml" 
              version="1.0"
              encoding="UTF-8" 
              indent="yes"
  />
  <xsl:param name="dir"/>  
  <xsl:param name="tempdir"/>    
  <xsl:param name="maxcount" as="xs:integer"/>  
  <!-- $runcatalogexport will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->
  <xsl:param name="runcatalogexport"/>
  <!--  -->  
  <xsl:variable name="v_file_priority" select="if($runcatalogexport = 'yes') then 1 else 0" as="xs:integer"/>
  <!--  -->
  <xsl:template match="/entries">
    <root>
      <xsl:call-template name="CountProductWords">
        <xsl:with-param name="products" select="entry/content/Product"/>      
        <xsl:with-param name="runningcount" select="0" as="xs:integer"/>
        <xsl:with-param name="fromposition" select="1" as="xs:integer"/>
        <xsl:with-param name="toposition" select="1" as="xs:integer"/>        
        <xsl:with-param name="subbatch" select="1" as="xs:integer"/>        
      </xsl:call-template>       
    </root>
  </xsl:template>
  <!--  -->
  <xsl:template name="CountProductWords">
    <xsl:param name="products"/>
    <xsl:param name="runningcount"/>
    <xsl:param name="fromposition"/>
    <xsl:param name="toposition"/>    
    <xsl:param name="subbatch"/>        
    <xsl:variable name="translatedelements" select="$products[position()=1]/descendant::*[@translate='yes']"/>
    <xsl:variable name="CTN" select="$products[position()=1]/CTN"/>
    <xsl:variable name="translatedelementwords" as="xs:integer">
      <xsl:value-of select="sum(for $translatedelement in $translatedelements return count(tokenize(string($translatedelement),'\s')))"/>
    </xsl:variable>
    <xsl:variable name="newrunningcount" select="$runningcount + $translatedelementwords"/>
    <xsl:if test="false()">
      <CountProductWords>
        <products><xsl:copy-of select="$products"/></products>            
        <ctn><xsl:value-of select="$CTN"/></ctn>      
        <runningcount><xsl:value-of select="$runningcount"/></runningcount>
        <thisproductcount><xsl:value-of select="$translatedelementwords"/></thisproductcount>
        <newrunningcount><xsl:value-of select="$newrunningcount"/></newrunningcount>      
        <from><xsl:value-of select="$fromposition"/></from>
        <to><xsl:value-of select="$toposition"/></to>      
      </CountProductWords>      
    </xsl:if>      
    <xsl:choose>
      <xsl:when test="$newrunningcount &lt; $maxcount">
        <!-- New running count is less than maxcount, but check for other products left in the file before calling template again -->
        <xsl:choose>
          <xsl:when test="$products[position()!=1]">
            <!-- More products, so call template again -->
            <xsl:call-template name="CountProductWords">
              <xsl:with-param name="products" select="$products[position()!=1]"/>      
              <xsl:with-param name="runningcount" select="$newrunningcount" as="xs:integer"/>
              <xsl:with-param name="fromposition" select="$fromposition"/>
              <xsl:with-param name="toposition" select="$toposition + 1"/>
              <xsl:with-param name="subbatch" select="$subbatch"/>
            </xsl:call-template>            
          </xsl:when>
          <xsl:otherwise>
            <!-- No more products in this file, so create subbatch file -->            
            <xsl:call-template name="writeFile">
              <xsl:with-param name="fromposition" select="$fromposition" as="xs:integer"/>
              <xsl:with-param name="toposition" select="$toposition" as="xs:integer"/>
              <xsl:with-param name="subbatch" select="$subbatch" as="xs:integer"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- Maxcount has been exceeded, create subbatch file -->
        <xsl:call-template name="writeFile">
          <xsl:with-param name="fromposition" select="$fromposition" as="xs:integer"/>
          <xsl:with-param name="toposition" select="$toposition" as="xs:integer"/>
          <xsl:with-param name="subbatch" select="$subbatch" as="xs:integer"/>            
        </xsl:call-template>           
        <!-- Check for other products left in the file -->
        <xsl:choose>          
          <xsl:when test="$products[position()!=1]">
            <!-- More products, so call template again -->            
            <xsl:call-template name="CountProductWords">
              <xsl:with-param name="products" select="$products[position()!=1]"/>      
              <xsl:with-param name="runningcount" select="1" as="xs:integer"/>
              <xsl:with-param name="fromposition" select="$toposition + 1"/>
              <xsl:with-param name="toposition" select="$toposition + 1"/>
              <xsl:with-param name="subbatch" select="$subbatch + 1" as="xs:integer"/>
            </xsl:call-template>           
          </xsl:when>
          <xsl:otherwise>
            <!-- No more products in this file, so nothing to do -->            
          </xsl:otherwise>
        </xsl:choose>                
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
	<!--  -->  
  <xsl:template name="writeFile">
    <xsl:param name="fromposition"/>
    <xsl:param name="toposition"/>
    <xsl:param name="subbatch"/>
    <!-- Write the translation file -->
        <xsl:copy select="/entries">
          <xsl:copy-of select="@*[not(local-name() = 'batchnumber' or local-name() = 'priority')]"/>
          <xsl:attribute name="batchnumber" select="concat(@batchnumber,'.',$subbatch)"/>
          <!-- If there is a non-zero priority in the catalog.xml file, set the priority attribute to its value, otherwise use the one already present -->
          <xsl:attribute name="priority" select="if($v_file_priority gt 0) then $v_file_priority else @priority"/>
          <xsl:sequence select="/entries/entry[position() ge $fromposition and position() le $toposition]"></xsl:sequence> 
        </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
