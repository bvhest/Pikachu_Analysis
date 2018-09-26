<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:source="http://apache.org/cocoon/source/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0">
   
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:param name="batchsize"/>
  <xsl:param name="filestem"/>
  <xsl:param name="dir"/>
  <xsl:param name="ts"/>

  <xsl:template match="/ObjectsMsg">
    <root>
      <xsl:call-template name="RecursiveGrouping">
        <xsl:with-param name="list" select="Object"/>
        <xsl:with-param name="group" select="1"/>     
      </xsl:call-template>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template name="RecursiveGrouping">
    <xsl:param name="list"/>
    <xsl:param name="group"/>
    <xsl:if test="count($list)>0">
      <xsl:call-template name="DoIt">
        <xsl:with-param name="list" select="$list[position() &lt;= number($batchsize)]"/>
        <xsl:with-param name="group" select="$group"/>     
      </xsl:call-template>  
      <!-- If there are other groups left, call itself -->
      <xsl:call-template name="RecursiveGrouping">
        <xsl:with-param name="list" select="$list[position() > number($batchsize)]"/>
        <xsl:with-param name="group" select="$group+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
	<!-- -->
  <xsl:template name="DoIt">
    <xsl:param name="list"/>
    <xsl:param name="group"/>
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source><xsl:value-of select="$dir"/>/<xsl:value-of select="$filestem"/>.batch_<xsl:value-of select="$group"/>.xml</source:source>      
        <source:fragment>
          <xsl:copy>
            <xsl:copy-of select="/ObjectsMsg/@*"/>
            <xsl:copy-of select="$list"/>
          </xsl:copy>
        </source:fragment>
      </source:write>
    </xsl:template>  	
    
</xsl:stylesheet>
