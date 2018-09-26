<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <xsl:param name="configfilepath"/>
  <xsl:param name="host"/>
  <!-- -->
  <xsl:variable name="currdatetime" select="substring(string(current-dateTime()),1,19)"/>
  <xsl:variable name="template-configfile" select="document($configfilepath)"/>
  <xsl:variable name="template-config-keys" select="$template-config/Templates/keys/key/keyname"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="octl|sql:rowset|sql:row|sql:data">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <xsl:template match="sql:*"/>
  <!-- -->
  <xsl:template match="octl[sql:rowset/@name='AssetList']"/>
  <!-- -->
  <xsl:template match="sql:rowset/@name"/>
  <!-- -->
  <xsl:template match="octl/sql:rowset[@name='KeyValuePairs']/sql:row/sql:data/KeyValuePairs">
    <!-- KVP is the driver, not AssetList, because there are fewer KVPs than AssetLists -->
    <xsl:apply-templates/>
  </xsl:template>
  <!--xsl:template match="KeyValuePair[Key=('AmbilightSystem','AspectRatio')]"/-->
  <xsl:template match="KeyValuePair[Key!=('ScreenFill')]"/>
  <!-- -->
  <xsl:template match="KeyValuePair[Key='ScreenFill']">
    <xsl:variable name="key" select="Key"/>
    <xsl:variable name="value" select="Value"/>
    <xsl:variable name="keys" select="../KeyValuePair[../@object_id=current()/../@object_id]"/>
    <xsl:variable name="ctn" select="../@object_id"/>
    <xsl:variable name="escctn" select="replace(replace($ctn,'/','_'),'-','_')"/>
    <xsl:variable name="row" select="."/>
    <Templates>
      <!-- for each doctype in the template config file which is associated with the current key ... -->
      <xsl:for-each select="$template-configfile/Templates/keys/key[keyname=$key]/templateassets/templateasset/doctype">
        <xsl:variable name="doctype" select="."/>
        <xsl:variable name="targetImage">
          <xsl:for-each select="../imageVariables/imageVariable[@name='targetImage']/part">
            <xsl:value-of select="if(@type = 'CTN') then $escctn else if(@type = 'valueForKey') then $keys[Key=current()]/Value else ."/>
            <xsl:if test="following-sibling::*">-</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="fillImage">
          <xsl:for-each select="../imageVariables/imageVariable[@name='fillImage']/part">
            <xsl:value-of select="if(@type = 'CTN') then $escctn else if(@type = 'valueForKey') then $keys[Key=current()]/Value else ."/>
            <xsl:if test="following-sibling::*">-</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="auraImage">
          <xsl:for-each select="../imageVariables/imageVariable[@name='auraImage']/part">
            <xsl:value-of select="if(@type = 'CTN') then $escctn else if(@type = 'valueForKey') then $keys[Key=current()]/Value else ."/>
            <xsl:if test="following-sibling::*">-</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="derivedImage">
          <xsl:for-each select="../imageVariables/imageVariable[@name='derivedImage']/part">
            <xsl:value-of select="if(@type = 'CTN') then $escctn else if(@type = 'valueForKey') then $keys[Key=current()]/Value else ."/>
            <xsl:if test="following-sibling::*">-</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="imageVariables">
          <targetImage>
            <xsl:value-of select="$targetImage"/>
          </targetImage>
          <fillImage>
            <xsl:value-of select="$fillImage"/>
          </fillImage>
          <auraImage>
            <xsl:value-of select="$auraImage"/>
          </auraImage>
          <derivedImage>
            <xsl:value-of select="$derivedImage"/>
          </derivedImage>
        </xsl:variable>
        <Template>
          <Name>
            <xsl:value-of select="$derivedImage"/>
          </Name>
          <xsl:copy-of select="$template-configfile/Templates/ProjectDetails/*"/>                  
          <Preconditions>
            <xsl:for-each select="../preconditions/precondition">
              <Test>
                <xsl:attribute name="{@type}"><xsl:value-of select="if(@testfor='imageVariable') then $imageVariables/*[local-name()=current()] else ''"/></xsl:attribute>
              </Test>
            </xsl:for-each>
          </Preconditions>
          <Check>
            <xsl:for-each select="../checks/check">
              <xsl:if test="@needskey='' or @needskey=$keys/Key">
                <Test>
                  <xsl:attribute name="{@type}"><xsl:value-of select="if(@testfor='imagepath') then concat($escctn,'-',doctype,'-global-001',append)
                                                               else if(@testfor='imageVariable') then $imageVariables/*[local-name()=current()]
                                                               else ''"/></xsl:attribute>
                </Test>
              </xsl:if>
            </xsl:for-each>
          </Check>
          <Variables>
            <xsl:for-each select="../variables/variable">
              <xsl:if test="@needskey='' or @needskey=$keys/Key">
                <xsl:element name="{@elementname}">
                  <xsl:for-each select="attributes/attribute">
                    <xsl:attribute name="{@name}" select="if(@value) then @value else if(@imageVariable) then $imageVariables/*[local-name()=current()/@imageVariable] else ''"/>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
          </Variables>
          <Url>
            <xsl:variable name="env-id" select="if(contains($host,'022')) then 'Production' else 'Staging'"/>
            <xsl:variable name="imageserver" select="../Url/environment[id=$env-id]/imageserver"/>
            <xsl:variable name="account" select="../Url/environment[id=$env-id]/account"/>
            <xsl:variable name="normal" select="../Url/environment[id=$env-id]/Normal"/>            
            <Normal>
              <xsl:for-each select="../Url/environment[id=$env-id]/Normal/segment">
                <xsl:if test="@needskey='' or @needskey=$keys/Key">
                  <xsl:value-of select="replace(replace(replace(replace(.,'\$_imageserver',$imageserver),'\$_account',$account),'\$_fillImage',$fillImage),'\$_targetImage',$targetImage)"/>
                </xsl:if>
              </xsl:for-each>
            </Normal>        
            <!--Normal2>
              <xsl:call-template name="doURL">
                <xsl:with-param name="url" select="replace(replace(../Url/environment[id=$env-id]/Normal,'\$imageserver',$imageserver),'\$account',$account)"/>
                <xsl:with-param name="imageVariables" select="$imageVariables"/>
              </xsl:call-template>
            </Normal2-->
            <Fail>
              <xsl:for-each select="../Url/environment[id=$env-id]/Fail/segment">
                <xsl:if test="@needskey='' or @needskey=$keys/Key">            
                  <xsl:value-of select="replace(replace(replace(replace(.,'\$_imageserver',$imageserver),'\$_account',$account),'\$_fillImage',$fillImage),'\$_targetImage',$targetImage)"/>
                </xsl:if>
              </xsl:for-each>
              <!--xsl:value-of select="concat($imageserver
                                        , '/'
                                        , $account
                                        , '/'
                                        , $targetImage)"/-->
            </Fail>
          </Url>
          <Result/>
        </Template>
      </xsl:for-each>
    </Templates>
  </xsl:template>
  
  <!--xsl:template name="doURL">
    <xsl:param name="url">
    <xsl:param name="imageVariables">
    <xsl:call-template name="doURL">
      <xsl:with-param name="url" select="replace($url,'\$imageserver',$imageserver)"/>
      <xsl:with-param name="imageVariables" select="$imageVariables"/>
     </xsl:call-template>      
    <xsl:call-template-->
  
  <!-- process octl attributes -->
  <xsl:template match="octl-attributes[../@valid='true']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()[not(local-name()='masterlastmodified_ts' or local-name()='status' or local-name()='marketingversion')]"/>
      <xsl:element name="masterlastmodified_ts">
        <xsl:value-of select="lastmodified_ts"/>
      </xsl:element>
      <xsl:element name="status">
        <xsl:value-of select="'Loaded'"/>
      </xsl:element>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
