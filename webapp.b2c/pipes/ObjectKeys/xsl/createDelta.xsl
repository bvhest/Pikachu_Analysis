<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:source="http://apache.org/cocoon/source/1.0"
    xmlns:local="http://pww.pikachu.philips.com/functions/local"
    exclude-result-prefixes="source dir sql"
    extension-element-prefixes="local">

  <xsl:strip-space elements="*"/>
  
  <xsl:param name="delta-path"/>
  <xsl:param name="cache-path"/>
  <xsl:param name="config-path"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="system"/>
    
  <xsl:variable name="tree-config" select="document($config-path)/ObjectKeysConfig/TreeConfig" />

  <!--
    Create a delta from modified and cached data.
    Input is an aggregation of two ObjectKeys files:
    
    <root>
      <ObjectKeys>
        .. object keys from modified objects..
      </ObjectKeys>
      <ObjectKeys>
        .. object keys from cache ..
      </ObjectKeys>
    </root>
    
    Or, if the cache is empty or ignored, just the modified ObjectKeys:
    
    <ObjectKeys>
      .. modified object keys ..
    </ObjectKeys>
    or
    <root>
      <ObjectKeys>
        .. object keys from modified objects..
      </ObjectKeys>
      <ObjectKeys/>
    </root>
    
    For the delta the following changes are important:
    1. The attributes of an ObjectKey were modified.
    2. A new ObjectKey was created.
    3. An ObjectRef inside the ObjectKey was added or modified.
    
    The result is:
    1. A write source, storing in $delta-path, with only the *new or modified* ObjectKeys in export format.
    2. A write source, storing in $cache-path, with an updated cache.    
  -->
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!--
    Cache is present.
    First ObjectKeys element contains the modified ObjectKey elements (from the modified products.)
    Second ObjectKeys element contains the cached object keys.
  -->
  <xsl:template match="/root[exists(ObjectKeys[2]/ObjectKey)]">
    <root>
      <!-- Write the delta feed -->
      <source:write>
        <source:source>
          <xsl:value-of select="$delta-path"/>
        </source:source>
        <source:fragment>
          <xsl:call-template name="export">
            <xsl:with-param name="object-keys">
              <xsl:apply-templates select="ObjectKeys[2]/ObjectKey" mode="merge">
                <xsl:with-param name="modified-keys" select="ObjectKeys[1]/ObjectKey"/>
                <xsl:with-param name="action" select="'delta'"/>
              </xsl:apply-templates>
            </xsl:with-param>
          </xsl:call-template>
        </source:fragment>
      </source:write>
      
      <!-- Write the updated cache -->
      <source:write>
        <source:source>
          <xsl:value-of select="$cache-path"/>
        </source:source>
        <source:fragment>
          <ObjectKeys>
            <xsl:apply-templates select="ObjectKeys[2]/ObjectKey" mode="merge">
              <xsl:with-param name="modified-keys" select="ObjectKeys[1]/ObjectKey"/>
              <xsl:with-param name="action" select="'merge'"/>
            </xsl:apply-templates>
          </ObjectKeys>
        </source:fragment>
      </source:write>
      
    </root>
  </xsl:template>
  
  <!--
    Merge the cache and modified keys.
    Matching ObjectKey is a key from the cache.
    
    $modified-keys contains ObjectKeys that were extracted from modified products.
  -->
  <xsl:template match="ObjectKey" mode="merge">
    <xsl:param name="modified-keys"/>
    <xsl:param name="action"/>
    <xsl:variable name="mod-key" select="$modified-keys[@code=current()/@code]"/>
      <xsl:choose>
        <xsl:when test="exists($mod-key)">
          <!--
            Key is also in the modified keys: merge the sop/eop info.
            If we are not merging than the modified key is only output if the sop/eop window
            is larger than before.
          -->
          <xsl:variable name="sop" select="min((@sop, $mod-key/@sop))"/>
          <xsl:variable name="eop" select="max((@eop, $mod-key/@eop))"/>
          
          <xsl:if test="$action = 'merge' or $sop lt number(@sop) or $eop gt number(@eop)">
            <xsl:copy copy-namespaces="no">
              <xsl:apply-templates select="@*[not(local-name() = ('sop','eop'))]"/>
            
              <xsl:attribute name="sop" select="format-number($sop,'00000000')"/>
              <xsl:attribute name="eop" select="format-number($eop,'00000000')"/>
            </xsl:copy>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$action='merge'">
          <!-- We are merging: output the cached key -->
          <xsl:apply-templates select="."/>          
        </xsl:when>
      </xsl:choose>
  </xsl:template>

  <!--
    Output modified ObjectKeys that are not in the cache.
    Matching ObjectKey is the last key from the cache.
  -->
  <xsl:template match="ObjectKey[last()]" mode="merge">
    <xsl:param name="modified-keys"/>
    
    <xsl:next-match>
      <xsl:with-param name="modified-keys" select="$modified-keys"/>
    </xsl:next-match>
    
    <xsl:apply-templates select="for $k in $modified-keys return
                                  if (empty(preceding-sibling::ObjectKey[@code=$k/@code])) then
                                    $k
                                  else
                                    ()"/>
  </xsl:template>
  
  <!-- Cache is empty -->
  <xsl:template match="/ObjectKeys|/root[empty(ObjectKeys[2]/ObjectKey)]/ObjectKeys[1]">
    <root>
      <source:write>
        <source:source>
          <xsl:value-of select="$delta-path"/>
        </source:source>
        <source:fragment>
          <xsl:call-template name="export">
            <xsl:with-param name="object-keys">
              <xsl:apply-templates select="ObjectKey" />
            </xsl:with-param>
          </xsl:call-template>
        </source:fragment>
      </source:write>

      <source:write>
        <source:source>
          <xsl:value-of select="$cache-path"/>
        </source:source>
        <source:fragment>
          <ObjectKeys>
            <xsl:apply-templates select="ObjectKey" />
          </ObjectKeys>
        </source:fragment>
      </source:write>
    </root>
  </xsl:template>
      
  <xsl:template name="export">
    <xsl:param name="object-keys"/>
    <ObjectKeys sourceSystem="{$system}">
      <xsl:attribute name="docTimestamp">
        <xsl:value-of select="substring($timestamp,1,4)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring($timestamp,5,2)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring($timestamp,7,2)"/>
        <xsl:text>T</xsl:text>
        <xsl:value-of select="substring($timestamp,9,2)"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="substring($timestamp,11,2)"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="substring($timestamp,13,2)"/>
      </xsl:attribute>
      
      <!-- Export the tree child nodes -->
      <xsl:apply-templates select="$tree-config/Node/Node" mode="export"/>
      
      <xsl:apply-templates select="$object-keys" mode="export"/>
    </ObjectKeys>
  </xsl:template>
  
  <xsl:template match="ObjectKey" mode="export">
    <ObjectKey Action="add">
      <xsl:call-template name="objectkey-tree-nodes"/>
      <ObjectCode>
        <xsl:value-of select="@code"/>
      </ObjectCode>
      <ObjectName>
        <xsl:value-of select="@name"/>
      </ObjectName>
      <xsl:if test="@sop != '' and @eop != ''">
        <SOP>
          <xsl:value-of select="local:format-date(@sop)"/>
        </SOP>
        <EOP>
          <xsl:value-of select="local:format-date(@eop)"/>
        </EOP>
      </xsl:if>
    </ObjectKey>
  </xsl:template>
  
  <xsl:template match="Node/Node" mode="export">
    <ObjectKey Action="add">
      <TreeCode>
        <xsl:value-of select="../@code"/>
      </TreeCode>
      <TreeName>
        <xsl:value-of select="../@name"/>
      </TreeName>
      <ParentCode/>
      <ParentName/>
      <ObjectCode>
        <xsl:value-of select="@code"/>
      </ObjectCode>
      <ObjectName>
        <xsl:value-of select="@name"/>
      </ObjectName>
    </ObjectKey>
  </xsl:template>
  
  <!-- Create the tree structure nodes for an object key in context using the configuration -->
  <xsl:template name="objectkey-tree-nodes">
    <xsl:variable name="target-node" select="$tree-config//Node[@code=current()/@treeNode]"/>
    <xsl:variable name="parent" select="if ($target-node/ancestor::Node) then $target-node else ()"/>
    <xsl:variable name="tree" select="if ($parent) then $parent/ancestor::Node else $target-node"/>

    <TreeCode>
      <xsl:value-of select="$tree/@code"/>
    </TreeCode>
    <TreeName>
      <xsl:value-of select="$tree/@name"/>
    </TreeName>
    <ParentCode>
      <xsl:value-of select="$parent/@code"/>
    </ParentCode>
    <ParentName>
      <xsl:value-of select="$parent/@name"/>
    </ParentName>
  </xsl:template>
    
  <xsl:function name="local:format-date">
    <xsl:param name="date"/>
    <xsl:value-of select="string-join((substring($date, 1, 4), substring($date, 5, 2), substring($date, 7)), '-')"/>
  </xsl:function>
</xsl:stylesheet>
