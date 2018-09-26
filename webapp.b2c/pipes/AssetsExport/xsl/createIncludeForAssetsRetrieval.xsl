<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml testProduct.xml?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:pikaf="http://www.philips.com/functions/pikachu/1.0"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    exclude-result-prefixes="xsl cinclude pikaf"
    extension-element-prefixes="cmc2-f">
    
  <xsl:import href="../../../cmc2/xsl/common/cmc2.function.xsl"/>
  
  <xsl:param name="locale"/>
  <xsl:param name="type"/>  
  <xsl:param name="ccr-asset-store"/>
  
  <xsl:variable name="doctypes" select="/root/doctypes"/>
  <!--  -->
  <xsl:template match="/">
    <root>
      <xsl:apply-templates select="@*|node()"/>      
    </root>
  </xsl:template>
  <!--  -->
  <xsl:template match="doctypes"/>
  <!--  -->   
  <xsl:template match="sql:rowset|sql:row|sql:data">
    <xsl:apply-templates/>
  </xsl:template>
  <!--  -->   
  <xsl:template match="sql:content_type|sql:localisation|sql:object_id|sql:masterlastmodified_ts|sql:lastmodified_ts|sql:status|sql:marketingversion"/> 
  <!--  -->       
  <xsl:template match="object">
    <object>
      <xsl:variable name="escid" select="cmc2-f:escape-scene7-id(id)"/>
      <xsl:variable name="CTN" select="id"/>      
      <xsl:variable name="assets"><Assets><xsl:copy-of select="Asset"/></Assets></xsl:variable>
      <xsl:for-each-group select="Asset[ResourceType=$doctypes/doctype/@code and not(License='Deleted')]" group-by="ResourceType">
        <xsl:sort select="current-grouping-key()"/> 
        <xsl:call-template name="createinclude">
          <xsl:with-param name="Assets" select="current-group()"/>
          <xsl:with-param name="escid" select="$escid"/>
          <xsl:with-param name="CTN" select="$CTN"/>
        </xsl:call-template>        
      </xsl:for-each-group>
      <xsl:if test="$type = 'ProductAssets'">
        <!-- Delete exported asset types where not in the list of assets for this product -->
        <xsl:for-each select="$doctypes/doctype[not(@code = $assets/Assets/Asset/ResourceType)]">
          <xsl:sort select="@code"/>
          <xsl:if test="not($locale != 'master_global' and (@language = '' or @language = 'global'))">
            <!-- don't create a deletion for a global asset unless the locale is global -->
            <xsl:call-template name="createdelete">
              <xsl:with-param name="doctype" select="."/>
              <xsl:with-param name="escid" select="$escid"/>
            </xsl:call-template>        
          </xsl:if>
        </xsl:for-each>
        <!-- Delete exportable asset types where asset license='Deleted' -->
        <xsl:for-each select="$doctypes/doctype[@code = $assets/Assets/Asset/ResourceType[../License='Deleted']]">
          <xsl:sort select="@code"/>
          <xsl:call-template name="createdelete">
            <xsl:with-param name="doctype" select="."/>
            <xsl:with-param name="escid" select="$escid"/>
          </xsl:call-template>        
        </xsl:for-each>       
      </xsl:if>
    </object>
  </xsl:template>
  <!--  -->     
  <xsl:template name="createdelete">
    <xsl:param name="escid"/>
    <xsl:param name="doctype"/>
    <xsl:for-each select="tokenize($doctype/@suffix,',')">        
      <xsl:variable name="filename">
        <xsl:choose>
          <xsl:when test="starts-with($doctype,'PMT')">
            <!-- Assume CTN -->
            <xsl:value-of select="concat($escid,'.xml')"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Assume 001 -->
            <xsl:value-of select="concat('001.',.)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
       <i:include xmlns:i="http://apache.org/cocoon/include/1.0">        
        <xsl:attribute name="src">cocoon:/deleteResource.<xsl:value-of select="$doctype/@code"/>.<xsl:value-of select="if ($doctype/@language!='') then $doctype/@language else $locale"/>.<xsl:value-of select="$escid"/>?filename=<xsl:value-of select="$filename"/></xsl:attribute>
      </i:include>
    </xsl:for-each>
  </xsl:template>      
  <!--  -->
  <xsl:template name="createinclude">
    <xsl:param name="escid" />
    <xsl:param name="Assets" />
    <xsl:param name="CTN" />
    <xsl:for-each select="$Assets">
      <xsl:variable name="position" select="position()" />
      
      <xsl:variable name="base-name">
        <xsl:value-of select="$escid"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="ResourceType"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="if (Language!='') then Language else 'global'"/>
        <xsl:text>-</xsl:text>
      </xsl:variable>
      
      <xsl:variable name="file-extension">
        <xsl:choose>
          <xsl:when test="starts-with(ResourceType,'PMT')">
            <xsl:value-of select="$base-name"/>
            <!-- Check for two trailing slashes -->
            <xsl:analyze-string select="InternalResourceIdentifier" regex="^(.*)/(..*)/(..*)$">
              <xsl:matching-substring>
                <xsl:value-of select="concat(regex-group(2),'_',regex-group(3),'.xml')" />
              </xsl:matching-substring>
              <xsl:non-matching-substring>
                <xsl:value-of select="'ERROR'" />
              </xsl:non-matching-substring>
            </xsl:analyze-string>
          </xsl:when>
          <xsl:otherwise>
            <xsl:analyze-string select="InternalResourceIdentifier" regex="^(.*)\.(..*)$">
              <xsl:matching-substring>
                <xsl:value-of select="concat('.',regex-group(2))" />
              </xsl:matching-substring>
              <xsl:non-matching-substring>
                <xsl:value-of select="'ERROR'" />
              </xsl:non-matching-substring>
            </xsl:analyze-string>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:variable>
      
      <xsl:variable name="filename">
        <xsl:choose>
          <xsl:when test="starts-with(ResourceType,'PMT')">
            <xsl:value-of select="concat($base-name,$file-extension)"/>
          </xsl:when>
          <xsl:when test="ResourceType = 'AWR'">
            <!-- Award ranking picture is sent using a different naming convention based on the rating -->
            <xsl:value-of select="concat((tokenize(PublicResourceIdentifier,'/'))[last()],$file-extension)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$base-name"/>
            <xsl:number value="fn:abs($position)" format="001"/>
            <xsl:value-of select="$file-extension"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="not(contains($filename,'ERROR'))">
          <xsl:variable name="request">
            <xsl:text>cocoon:/readResource.</xsl:text>
            <xsl:value-of select="ResourceType" />
            <xsl:text>.</xsl:text>
            <xsl:value-of select="if (Language!='') then Language else 'global'" />
            <xsl:text>.</xsl:text>
            <xsl:value-of select="$escid" />
            <xsl:text>?mime-type=</xsl:text>
            <xsl:value-of select="Format" />
            <xsl:text>&amp;filename=</xsl:text>
              <xsl:value-of select="$filename"/>
              <xsl:text>&amp;url=</xsl:text>
              <xsl:choose>
                <xsl:when test="Publisher = 'CCR'">
                  <!-- Retrieve directly from the CCR store on disk -->
                  <xsl:value-of select="concat($ccr-asset-store,'/',substring-after(InternalResourceIdentifier,'mprdata/'))"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- Retrieve from asset URL -->
                  <xsl:value-of select="InternalResourceIdentifier"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <read>
              <xsl:attribute name="CTN"><xsl:value-of select="$CTN"/></xsl:attribute>
              <xsl:attribute name="request"><xsl:value-of select="$request"/></xsl:attribute>                   
      	      <i:include xmlns:i="http://apache.org/cocoon/include/1.0" src="{$request}"/>        
            </read>
          </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>    
  <!--  -->
  <xsl:template match="Asset[not(ResourceType=$doctypes/doctype/@code)]"/>  
  <!--  -->     
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!--  -->
</xsl:stylesheet>
