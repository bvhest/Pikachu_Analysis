<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:source="http://apache.org/cocoon/source/1.0"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:a="http://feed.alatest.com"
  xmlns:fn="http://www.w3.org/2005/xpath-functions">

  <!-- 
    Converts alaTest feed XML to ObjectAssetList import file
  -->
  <xsl:param name="dir"/>
  <xsl:param name="filestem"/>
  <xsl:param name="ext">.xml</xsl:param>
  <xsl:variable name="version"/>
  <xsl:variable name="docTimestamp"/>

  <xsl:template match="/a:reviewsfeed">
    <xsl:variable name="docTimestamp" select="concat(@generated-at,'T00:00:00')"/>
    <root>
      <source:write xmlns:source="http://apache.org/cocoon/source/1.0">
        <source:source>
          <xsl:value-of select="concat($dir,'/')"/>
          <xsl:value-of select="$filestem"/>
          <xsl:value-of select="$ext"/>
        </source:source>
        <source:fragment>
          <ObjectsMsg>              
            <xsl:attribute name="docTimestamp" select="$docTimestamp"/>
            <xsl:for-each-group select="a:alid/a:review[a:url|a:awardpic|a:ratingpic|a:thumbnail]" group-by="@id">
              <xsl:sort select="@id"/>
              <Object>
                <ObjectID><xsl:value-of select="concat('ALA_', upper-case(current-grouping-key()) )"/></ObjectID>
					  <xsl:for-each select="current-group()">				       
							 <xsl:apply-templates select="."/>
						</xsl:for-each>
              </Object>
            </xsl:for-each-group>
            
            <xsl:for-each-group select="a:alid/a:review/a:source[a:url|a:logo]" group-by="@id">
              <xsl:sort select="@id"/>
              <Object>
                <ObjectID><xsl:value-of select="concat('ALS_', current-grouping-key())"/></ObjectID>
                <xsl:for-each-group select="current-group()" group-by="../a:locale | ../a:locales/a:locale">
                  <xsl:apply-templates select="(current-group())[1]">
                    <xsl:with-param name="locale" select="current-grouping-key()"/>
                  </xsl:apply-templates>
                </xsl:for-each-group>               
                
              </Object>
            </xsl:for-each-group>
          </ObjectsMsg>        
        </source:fragment>      
      </source:write>        
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="a:review[a:url|a:awardpic|a:ratingpic|a:thumbnail]">
    <xsl:variable name="id" select="concat('ALA_',upper-case(@id))"/>       
    <xsl:variable name="locales">       
          <xsl:choose>
            <xsl:when test="a:source/@global='true' and (@type != 'user')"><a:locale>global</a:locale></xsl:when>                       
            <xsl:otherwise><xsl:sequence select="a:locale | a:locales/a:locale"/></xsl:otherwise>
          </xsl:choose>            
    </xsl:variable>
    <xsl:variable name="logo" select="a:logo"/> 
    <xsl:variable name="url" select="a:url"/>    
    <xsl:variable name="awardpic" select="a:awardpic"/>
    <xsl:variable name="rating" select="a:rating"/>
    <xsl:variable name="ratingpic" select="a:ratingpic"/>
    <xsl:variable name="thumbnail" select="a:thumbnail"/>
        
    <xsl:variable name="result">
      <xsl:for-each select="$locales/a:locale">
        <xsl:variable name="locale" select="if (. = 'global') then '' else . " /> 
        
            
              <xsl:if test="$awardpic != ''">                
                <xsl:variable name="doctype" select="'AWP'"/>
                <xsl:call-template name="doReviewAsset">
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="locale" select="$locale"/>
                  <xsl:with-param name="doctype" select="$doctype"/>
                  <xsl:with-param name="lm" select="''"/>                  
                  <xsl:with-param name="intURL" select="$awardpic"/>
                  <xsl:with-param name="extURL" select="concat('http://images.philips.com/is/image/PhilipsConsumer/',$id,'-',$doctype,'-',if ($locale!='') then $locale else 'global','-001')"/>
                </xsl:call-template >
              </xsl:if>
              <xsl:if test="$ratingpic != '' and $rating != ''">
                <xsl:variable name="doctype" select="'AWR'"/>
                <xsl:variable name="scene7-id">
                  <xsl:text>ALR</xsl:text>
                  <xsl:number value="fn:abs($rating)" format="001"/>
                </xsl:variable>
                <!--
                  Rating pictures are stored at Scene7 with a ID that is not equal to the AwardCode,
                  but is based on the rating. This prevents storing redundant images. (There are only 100 rating
                  pictures for each locale.)
                -->
                <xsl:call-template name="doReviewAsset">
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="locale" select="$locale"/>
                  <xsl:with-param name="doctype" select="$doctype"/>
                  <xsl:with-param name="lm" select="''"/>                                    
                  <xsl:with-param name="intURL" select="$ratingpic"/>
                  <xsl:with-param name="extURL" select="concat('http://images.philips.com/is/image/PhilipsConsumer/',$scene7-id,'-',$doctype,'-',if ($locale != '') then $locale else 'global','-001')"/>
                </xsl:call-template >
              </xsl:if>
              <xsl:if test="$thumbnail != ''">
                <xsl:variable name="doctype" select="'AWT'"/>
                <xsl:call-template name="doReviewAsset">
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="locale" select="$locale"/>
                  <xsl:with-param name="doctype" select="$doctype"/>
                  <xsl:with-param name="lm" select="''"/>                                    
                  <xsl:with-param name="intURL" select="$thumbnail"/>
                  <xsl:with-param name="extURL" select="concat('http://images.philips.com/is/image/PhilipsConsumer/',$id,'-',$doctype,'-',if ($locale != '') then $locale else 'global','-001')"/>
                </xsl:call-template >
              </xsl:if>
              <xsl:if test="$url != ''">
                <xsl:variable name="doctype" select="'AWU'"/>
                <xsl:call-template name="doReviewAsset">
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="locale" select="$locale"/>
                  <xsl:with-param name="doctype" select="$doctype"/>
                  <xsl:with-param name="lm" select="''"/>                                    
                  <xsl:with-param name="intURL" select="$url"/>
                  <xsl:with-param name="extURL" select="$url"/>
                </xsl:call-template >
              </xsl:if>            
                 
      </xsl:for-each>    
    </xsl:variable>    
    
    <xsl:for-each select="$result/Asset">
      <xsl:sort select="ResourceType"/>
      <xsl:sort select="Language"/>
      <xsl:copy-of select="."/>
    </xsl:for-each>
 
  </xsl:template>
  <!-- -->
  <xsl:template match="a:review/a:source[a:url|a:logo]">
    <xsl:param name="locale"/>       
    <xsl:variable name="id" select="concat('ALS_',upper-case(@id))"/>   
     
     <xsl:variable name="logo" select="a:logo"/> 
     <xsl:variable name="url" select="a:url"/>
      
        <xsl:variable name="l-locale" select="if ($locale = 'global') then '' else $locale " />             
	      
		        <xsl:if test="$logo != ''">
		          <xsl:variable name="doctype" select="'AWL'"/>
		          <xsl:call-template name="doReviewAsset">
		            <xsl:with-param name="id" select="$id"/>
		            <xsl:with-param name="locale" select="$l-locale"/>
		            <xsl:with-param name="doctype" select="$doctype"/>
		            <xsl:with-param name="lm" select="''"/>                                    
		            <xsl:with-param name="intURL" select="$logo"/>
		            <xsl:with-param name="extURL" select="concat('http://images.philips.com/is/image/PhilipsConsumer/',$id,'-',$doctype,'-',if ($l-locale != '') then $l-locale else 'global','-001')"/>
		          </xsl:call-template >
	          </xsl:if>
	          <xsl:if test="$url != ''">
		          <xsl:variable name="doctype" select="'AWW'"/>
		          <xsl:call-template name="doReviewAsset">
		            <xsl:with-param name="id" select="$id"/>
		            <xsl:with-param name="locale" select="$l-locale"/>
		            <xsl:with-param name="doctype" select="$doctype"/>
		            <xsl:with-param name="lm" select="''"/>                                    
		            <xsl:with-param name="intURL" select="$url"/>
		            <xsl:with-param name="extURL" select="$url"/>
		          </xsl:call-template >
	          </xsl:if>
	      
  </xsl:template>
  <!-- -->
  <xsl:template name="doReviewAsset">
    <xsl:param name="id"/>
    <xsl:param name="locale"/>
    <xsl:param name="doctype"/>
    <xsl:param name="lm"/>    
    <xsl:param name="intURL"/>
    <xsl:param name="extURL"/>
    <xsl:variable name="ext" select="(tokenize($intURL, '\.'))[last()]"/>
    <Asset>
      <ResourceType><xsl:value-of select="$doctype"/></ResourceType>
      <Language><xsl:value-of select="$locale"/></Language>
      <License>Final</License>
      <AccessRights/>
      <Modified><xsl:value-of select="$lm"/></Modified>
      <Publisher>alaTest</Publisher>
      <InternalResourceIdentifier><xsl:value-of select="$intURL"/></InternalResourceIdentifier>
      <SecureResourceIdentifier/>
      <PublicResourceIdentifier><xsl:value-of select="$extURL"/></PublicResourceIdentifier>
      <Format>
        <xsl:call-template name="mime-type-from-extension">
          <xsl:with-param name="extension" select="$ext"/>
        </xsl:call-template>
      </Format>
      <Extent><xsl:value-of select="0"/></Extent>
    </Asset>
  </xsl:template>
  
  <xsl:template name="mime-type-from-extension">
    <xsl:param name="extension"/>
    <xsl:choose>
      <xsl:when test="$extension=('jpg','jpeg','jpe')">
        <xsl:text>image/jpeg</xsl:text>
      </xsl:when>
      <xsl:when test="$extension='png'">
        <xsl:text>image/png</xsl:text>
      </xsl:when>
      <xsl:when test="$extension='gif'">
        <xsl:text>image/gif</xsl:text>
      </xsl:when>
      <xsl:when test="$extension=('tif','tiff')">
        <xsl:text>image/tiff</xsl:text>
      </xsl:when>
      <xsl:when test="$extension='flv'">
        <xsl:text>video/x-flv</xsl:text>
      </xsl:when>
      <xsl:when test="$extension='pdf'">
        <xsl:text>application/pdf</xsl:text>
      </xsl:when>
      <xsl:when test="$extension='swf'">
        <xsl:text>application/x-shockwave-flash</xsl:text>
      </xsl:when>
      <xsl:when test="$extension=('htm','html')">
        <xsl:text>text/html</xsl:text>
      </xsl:when>
      <xsl:when test="$extension=('txt','text')">
        <xsl:text>text/plain</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>text/html</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>