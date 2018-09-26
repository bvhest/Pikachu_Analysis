<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    Creates an XSLT transformation file from an ObjectKeys configuration file
    that will extract ObjectKeys from a PMT or FMT document.  
  -->
  <xsl:param name="target-file"/>
  
  <xsl:template match="/ObjectKeysConfig">
    <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
      <source:source>
        <xsl:value-of select="$target-file"/>
      </source:source>
      <source:fragment>
        <xsl:element name="xsl:stylesheet">
          <xsl:namespace name="sql" select="'http://apache.org/cocoon/SQL/2.0'"/>
          <xsl:attribute name="version">2.0</xsl:attribute>
          <xsl:attribute name="exclude-result-prefixes" select="'sql dir'"/>
          <!--
            Create:
            <xsl:template match="@*|node()">
              <xsl:apply-templates select="element()"/>
            </xsl:template> 
          -->
          <xsl:element name="xsl:template">
            <xsl:attribute name="match" select="'@*|node()'"/>
            <xsl:element name="xsl:apply-templates">
              <xsl:attribute name="select" select="'element()'"/>
            </xsl:element>
          </xsl:element>
          
          <!--
            Create:
            <xsl:template match="/">
              <ObjectKeys>
                <xsl:apply-templates/>
              </ObjectKeys>
            </xsl:template> 
          -->
          <xsl:element name="xsl:template">
            <xsl:attribute name="match" select="'/'"/>
            <ObjectKeys>
              <xsl:element name="xsl:apply-templates"/>
            </ObjectKeys>
          </xsl:element>

          <!-- Convert each TreeMapping to a XSLT template -->
          <xsl:apply-templates select="TreeMapping/Map"/>
        </xsl:element>
      </source:fragment>
    </source:write>
  </xsl:template>

  <xsl:template match="Map">
    <!--
      Create:
      <xsl:template match="object-xpath">
        <ObjectKey code="{object-code-xpath}" name="{object-name-xpath}" treeNode="{tree-node-from-config}"/>
      </xsl:template>
    -->
    <xsl:element name="xsl:template">
      <xsl:attribute name="match" select="Source/XPath[@type='object']"/>
      <ObjectKey>
        <xsl:attribute name="code">
          <xsl:text>{</xsl:text>
          <xsl:value-of select="Source/XPath[@type='object-code']"/>
          <xsl:text>}</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="name">
          <xsl:text>{</xsl:text>
          <xsl:value-of select="Source/XPath[@type='object-name']"/>
          <xsl:text>}</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="treeNode">
          <xsl:value-of select="Target/@treeNode"/>
        </xsl:attribute>
        
        <!-- Create:
          <xsl:attribute name="sop" select="{ancestor::sql:row/sql:sop}"/>
          <xsl:attribute name="eop" select="{ancestor::sql:row/sql:eop}"/>
        -->
        <xsl:element name="xsl:attribute">
          <xsl:attribute name="name">
            <xsl:text>sop</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="select">
            <xsl:text>ancestor::sql:row/sql:sop</xsl:text>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="xsl:attribute">
          <xsl:attribute name="name">
            <xsl:text>eop</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="select">
            <xsl:text>ancestor::sql:row/sql:eop</xsl:text>
          </xsl:attribute>
        </xsl:element>
        
        <xsl:if test="@save-relation = 'true'">
          <!--
            Create:
            <ObjectRef id="{ancestor::sql:row/sql:object_id}"
                        locale="{ancestor::sql:row/sql:localisation}"
                        sop="{ancestor::sql:row/sql:sop}"
                        eop="{ancestor::sql:row/sql:eop}"/>
          -->
          <xsl:element name="ObjectRef">
            <xsl:attribute name="id">
              <xsl:text>{ancestor::sql:row/sql:object_id}</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="locale">
              <xsl:text>{ancestor::sql:row/sql:localisation}</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="sop">
              <xsl:text>{ancestor::sql:row/sql:sop}</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="eop">
              <xsl:text>{ancestor::sql:row/sql:eop}</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
      </ObjectKey>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>