<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
	xmlns:dir="http://apache.org/cocoon/directory/2.0" 
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    extension-element-prefixes="cmc2-f">
  
  <xsl:import href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  
  <xsl:param name="locale"/>
  <xsl:variable name="doctypes" select="/root/doctypes"/>  
  
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="root/sql:rowset/sql:row"/>
    </root>
  </xsl:template>
  <!--  -->       
  <xsl:template match="/root/sql:rowset[@name='LOCALE']/sql:row">
    <xsl:variable name="id" select="cmc2-f:escape-scene7-id(id)"/>
    <!-- Only delete resources for localized resource types -->
    <xsl:for-each select="$doctypes/doctype[not(@language='global')]">
      <xsl:sort select="@code"/>
      <xsl:call-template name="createdelete">
        <xsl:with-param name="doctype" select="."/>
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>        
    </xsl:for-each>        
  </xsl:template>  
 <!--  -->     
  <xsl:template match="/root/sql:rowset[@name='MASTER']/sql:row">
    <xsl:variable name="id" select="cmc2-f:escape-scene7-id(id)"/>
    <!-- Only delete resources for global resource types -->
    <xsl:for-each select="$doctypes/doctype[@language='global']">
      <xsl:sort select="@code"/>
      <xsl:call-template name="createdelete">
        <xsl:with-param name="doctype" select="."/>
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>        
    </xsl:for-each>        
  </xsl:template>  
 <!--  -->     
  <xsl:template name="createdelete">
    <xsl:param name="id"/>
    <xsl:param name="doctype"/>
    <xsl:for-each select="tokenize($doctype/@suffix,',')">    
      <xsl:variable name="filename">
        <xsl:choose>
          <xsl:when test="starts-with($doctype,'PMT')">
            <!-- Assume CTN -->
            <xsl:value-of select="concat($id,'.xml')"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Assume 001 -->
            <xsl:value-of select="concat('001.',.)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <i:include xmlns:i="http://apache.org/cocoon/include/1.0"> 
        <xsl:attribute name="src">cocoon:/deleteResource.<xsl:value-of select="$doctype/@code"/>.<xsl:value-of select="if ($doctype/@language!='') then $doctype/@language else $locale"/>.<xsl:value-of select="$id"/>?filename=<xsl:value-of select="$filename"/></xsl:attribute>
     </i:include>
      
    </xsl:for-each>      
  </xsl:template>      
  <!--  -->         
</xsl:stylesheet>