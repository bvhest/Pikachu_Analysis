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
  <!--  -->
  <xsl:template match="/entries">
      <xsl:call-template name="CountProductWords">
        <xsl:with-param name="content" select="entry/content/Categorization"/>   <!-- !!!!!!!!!!!!!!!!!!!!!!!!!!! -->   
        <xsl:with-param name="runningcount" select="0" as="xs:integer"/>
        <xsl:with-param name="fromposition" select="1" as="xs:integer"/>
        <xsl:with-param name="toposition" select="1" as="xs:integer"/>        
        <xsl:with-param name="subbatch" select="1" as="xs:integer"/>        
      </xsl:call-template>       
  </xsl:template>
  <!--  -->
  <xsl:template name="CountProductWords">
    <xsl:param name="content"/>
    <xsl:param name="runningcount"/>
    <xsl:param name="fromposition"/>
    <xsl:param name="toposition"/>    
    <xsl:param name="subbatch"/>        
    <xsl:variable name="translatedelements" select="$content[position()=1]/descendant::*[@translate='yes']"/>
    <!--xsl:variable name="CTN" select="$content[position()=1]/CTN"/-->
    <xsl:variable name="translatedelementwords" as="xs:integer">
      <xsl:value-of select="sum(for $translatedelement in $translatedelements return count(tokenize(string($translatedelement),'\s')))"/>
    </xsl:variable>
    <xsl:variable name="newrunningcount" select="$runningcount + $translatedelementwords"/>
    <!--xsl:if test="false()">
      <CountProductWords>
        <products><xsl:copy-of select="$content"/></products>            
        <ctn><xsl:value-of select="$CTN"/></ctn>      
        <runningcount><xsl:value-of select="$runningcount"/></runningcount>
        <thisproductcount><xsl:value-of select="$translatedelementwords"/></thisproductcount>
        <newrunningcount><xsl:value-of select="$newrunningcount"/></newrunningcount>      
        <from><xsl:value-of select="$fromposition"/></from>
        <to><xsl:value-of select="$toposition"/></to>      
      </CountProductWords>      
    </xsl:if-->      
    <xsl:choose>
      <xsl:when test="$newrunningcount &lt; $maxcount">
        <!-- New running count is less than maxcount, but check for other products left in the file before calling template again -->
        <xsl:choose>
          <xsl:when test="$content[position()!=1]">
            <!-- More products, so call template again -->
            <xsl:call-template name="CountProductWords">
              <xsl:with-param name="content" select="$content[position()!=1]"/>      
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
          <xsl:when test="$content[position()!=1]">
            <!-- More products, so call template again -->            
            <xsl:call-template name="CountProductWords">
              <xsl:with-param name="content" select="$content[position()!=1]"/>      
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
          <xsl:copy-of select="@*[not(local-name() = 'batchnumber')]"/>
          <xsl:attribute name="batchnumber" select="concat(@batchnumber,'.',$subbatch)"/>
          <xsl:sequence select="/entries/entry[position() ge $fromposition and position() le $toposition]"></xsl:sequence> 
        </xsl:copy>
    <!-- Write the updateCLE file, which will be used to update the corresponding row in the CLE table     
    <s:write>
      <s:source><xsl:value-of select="$tempdir"/>updateCLE.tbatch.<xsl:value-of select="substring-before($filename,'.xml')"/>.<xsl:value-of select="$subbatch"/>.xml</s:source>
      <s:fragment>
        <root>
          <xsl:sequence select="/Products/Product[position() ge $fromposition and position() le $toposition]/CTN"></xsl:sequence> 
        </root>          
      </s:fragment>        
    </s:write>    -->
  </xsl:template>
</xsl:stylesheet>
