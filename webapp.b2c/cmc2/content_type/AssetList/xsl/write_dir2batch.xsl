<xsl:stylesheet version="2.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:source="http://apache.org/cocoon/source/1.0"
 xmlns:dir="http://apache.org/cocoon/directory/2.0">
   
  <xsl:param name="batchsize">10</xsl:param>
  <xsl:param name="dir">temp/</xsl:param>
  <xsl:param name="ts">test</xsl:param>
  <xsl:param name="prefix"/>
  
 <xsl:template match="/dir:directory">
    <root name="create-batches">
   <xsl:call-template name="RecursiveGrouping">
        <xsl:with-param name="list" select="//dir:file" />
        <xsl:with-param name="group" select="1" />
   </xsl:call-template>
  </root>
   </xsl:template>

 <xsl:template name="RecursiveGrouping">
    <xsl:param name="list" />
    <xsl:param name="group" />
 
  <xsl:if test="count($list)>0">
   <xsl:call-template name="DoIt">
        <xsl:with-param name="list" select="$list[position() &lt;= number($batchsize)]" />
        <xsl:with-param name="group" select="$group" />
   </xsl:call-template>
  
  <!-- If there are other groups left, calls itself -->
  <xsl:call-template name="RecursiveGrouping">
        <xsl:with-param name="list" select="$list[position() > number($batchsize)]" />
        <xsl:with-param name="group" select="$group+1" />
       </xsl:call-template>
  </xsl:if>
 </xsl:template>
	
  <xsl:template name="DoIt">
    <xsl:param name="list" />
    <xsl:param name="group" />
 
     <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="$dir" />
        <xsl:value-of select="$prefix"/>
        <xsl:text>cachebatch_</xsl:text>
        <xsl:value-of select="$ts" />
        <xsl:text>.</xsl:text>
        <xsl:value-of select="$group" />
        <xsl:text>.xml</xsl:text>
      </source:source>
      <source:fragment>
        <root>
		<xsl:for-each select="$list">
			<file>
              <xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
			</file>
		</xsl:for-each>
        </root>
      </source:fragment>
    </source:write>
  </xsl:template>  	

</xsl:stylesheet>
