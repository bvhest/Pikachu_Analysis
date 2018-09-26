<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:assets="http://www.w3.org/1999/XSL/Transform/assets">
  
  <!-- Merges the assets from multiple ObjectMsg and includes the cache contents for the ObjectID.
  
       - ObjectMsg attributes are set to the most recent found in the input
       - Assets are grouped by ResourceType and Language, and subsequently sorted by ascending Modified tag. The last Asset
         in a group is therefore the most recent, and is to be copied to the output stream
  -->   
  
  <xsl:template match="node()|@*" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="root">
    <root>
      <delta>
	    <ObjectsMsg>
	      <xsl:variable name="ObjectID" select="delta/ObjectsMsg[1]/Object/ObjectID"/>
	      
	      <xsl:attribute name="docTimestamp" select="delta/ObjectsMsg[1]/@docTimestamp"/>
          <xsl:attribute name="version" select="delta/ObjectsMsg[1]/@version"/>
	      
	      <Object>
	        <ObjectID><xsl:value-of select="$ObjectID"/></ObjectID>
	        <!-- Merge all assets from inbox files + cache and copy the most recent version for every type/locale -->
	        <xsl:for-each-group select="*/ObjectsMsg/Object/Asset" group-by="concat(ResourceType, '-', Language)">
	          <xsl:sort select="ResourceType" order="ascending"/>
              <xsl:sort select="Language" order="ascending"/>
              <xsl:for-each select="current-group()">
                <xsl:sort select="Modified" order="descending"/>
                <xsl:if test="position() = 1">
                  <xsl:apply-templates select="."/>
                </xsl:if>
              </xsl:for-each>
	        </xsl:for-each-group>
	      </Object>  
	    </ObjectsMsg>
      </delta>
      <xsl:apply-templates select="cache"/>
    </root>
  </xsl:template>
    
  <xsl:template match="cache/ObjectsMsg/Object">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="ObjectID"/>
      <xsl:apply-templates select="Asset">
        <xsl:sort select="ResourceType" order="ascending"/>
        <xsl:sort select="Language" order="ascending"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>