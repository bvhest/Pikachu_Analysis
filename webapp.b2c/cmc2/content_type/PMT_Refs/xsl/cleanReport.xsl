<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
    xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
    exclude-result-prefixes="sql xsl cinclude">

  <xsl:param name="ts"/>    

  <!-- remove record to prevent error in the store layer -->
  <xsl:template match="/" >
    <report>
     <xsl:apply-templates select="@*|node()"/>
    </report>
  </xsl:template>
 
  <xsl:template match="reports/root" >
    <entries>
       <xsl:variable name="pos" select="position()" />
       <xsl:variable name="processStep" select="if ($pos = 1) then 'clearDeletedAccessories'
                                           else if ($pos = 2) then 'clearUnchangedAccessories'
                                           else 'processChangedAccessories'" />
       <xsl:choose>
         <xsl:when test="position() = 1">
           <xsl:call-template name="deleted">
               <xsl:with-param name="processStep" select="$processStep"/>
           </xsl:call-template>
         </xsl:when>
         <xsl:when test="position() = 2">
           <xsl:call-template name="unchanged">
               <xsl:with-param name="processStep" select="$processStep"/>
           </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
           <xsl:call-template name="process">
               <xsl:with-param name="processStep" select="$processStep"/>
           </xsl:call-template>
         </xsl:otherwise>
       </xsl:choose>
          
    </entries>
  </xsl:template>

  <xsl:template name="deleted">
    <xsl:param name="processStep" />
       <entry includeinreport="yes" runts="{$ts}">
          <page>
             <xsl:attribute name="processStep" select="$processStep" />
             <result>Triggered objects: <xsl:value-of select="count(shellResult)"/></result>
             <result>Processed objects: <xsl:value-of select="count(shellResult[execution='success'])"/></result>
          </page>
       </entry>
  </xsl:template>

  <xsl:template name="unchanged">
    <xsl:param name="processStep" />
       <entry includeinreport="yes" runts="{$ts}">
          <page>
             <xsl:attribute name="processStep" select="$processStep" />
             <result>Triggered objects: <xsl:value-of select="count(identical/shellResult)"/></result>
             <result>Processed objects: <xsl:value-of select="count(identical/shellResult[execution='success'])"/></result>
          </page>
       </entry>
  </xsl:template>

  <xsl:template name="process">
    <xsl:param name="processStep" />
       <entry includeinreport="yes" runts="{$ts}">
          <page>
             <xsl:attribute name="processStep" select="$processStep" />
             <result>Triggered objects: <xsl:value-of select="count(root/sourceResult/entries/entry)"/></result>
             <result>Processed objects: <xsl:value-of select="count(root/sourceResult/entries/entry[result='OK'])"/></result>
          </page>
       </entry>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root|shellResult|sourceResult" />

</xsl:stylesheet>
