<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Convert a PFS Excel input file read by the HSSFGenerator
  to PP_Configuration file and PText_Raw file.
  
  See example input file at the bottom of this stylesheet.
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                xmlns:gmr="http://www.gnome.org/gnumeric/v7"
                xmlns:info="http://www.philips.com/pikachu/3.0/info"
                xmlns:my="http://www.philips.com/pika"
                >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <!-- file name of the uploaded file -->
  <xsl:param name="datafile"/>
  <xsl:param name="division" select="'CE'"/>
  <xsl:param name="store-dir"/>
  
  <xsl:function name="my:getmaxlength" as="integer">
    <xsl:param name="context"/>
    <xsl:param name="row"/>
    <xsl:param name="lengthcheckcolumn"/>    
    <xsl:value-of select="if($context/following-sibling::gmr:Cell[@Row=$row and @Col=$lengthcheckcolumn] != '') 
                          then number($context/following-sibling::gmr:Cell[@Row=$row and @Col=$lengthcheckcolumn])
                          else string-length($context/following-sibling::gmr:Cell[@Row=$row and @Col='2'])"/>
  </xsl:function>  
  
  
  <xsl:variable name="current-datetime" select="replace(string(current-dateTime()),'.*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}).*','$1')"/>
  <xsl:variable name="current-timestamp" select="replace($current-datetime,'[^0-9]','')"/>
  <xsl:variable name="docTimestamp" select="$current-datetime"/>
  <xsl:variable name="language-map" select="document('language-map.xml')/languages"/>
  <xsl:variable name="package-project-code">
    <xsl:choose>
      <xsl:when test="matches($datafile,'.*Packaging\s*Brief\s+[A-Z0-9]+\s+.*')">
        <xsl:value-of select="concat('PP_',replace($datafile,'.*Packaging\s*Brief\s+([A-Z0-9]+)\s+.*', '$1'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('PP_',$current-timestamp)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="lengthcheckcolumn" select="gmr:Workbook/gmr:Sheets/gmr:Sheet[lower-case(gmr:Name)='translated elements']/gmr:Cells/gmr:Cell[@Row='0' and replace(upper-case(.),' ','') = 'MAXIMUMLENGTH(MASTER)']/@Col"/>
  
  <xsl:template match="@*|node()">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="gmr:Workbook/gmr:Sheets">
    <xsl:variable name="language-sheet" select="gmr:Sheet[lower-case(gmr:Name)='select languages']"/>
    <xsl:variable name="v-code" select="concat('PP_',replace($language-sheet/gmr:Cells/gmr:Cell[.='CTN']/following-sibling::gmr:Cell[1]/text(),'/','_'),'_',$current-timestamp  )"/>
    <xsl:variable name="addressee" select="$language-sheet/gmr:Cells/gmr:Cell[upper-case(replace(.,' ',''))='EMAILADDRESS']/following-sibling::gmr:Cell[1]/text()"/>
    <xsl:variable name="remarks4engineer" select="$language-sheet/gmr:Cells/gmr:Cell[.='Remarks for Packaging Engineer']/following-sibling::gmr:Cell[1]/text()"/>    
    <xsl:variable name="remarks4translation" select="$language-sheet/gmr:Cells/gmr:Cell[.='Remarks for Translation Agency']/following-sibling::gmr:Cell[1]/text()"/>        
    <xsl:variable name="output">
      <PackagingProjectConfiguration info:source-file="{$datafile}">
        <!--xsl:attribute name="code" select="$package-project-code"/-->
        <xsl:attribute name="code" select="$v-code"/>
        <xsl:attribute name="division" select="$division"/>
        <xsl:attribute name="docStatus" select="'approved'"/>
        <xsl:attribute name="docTimeStamp" select="$docTimestamp"/>
        <xsl:attribute name="projectRemarks" select="''"/>
        <xsl:attribute name="referenceName" select="$language-sheet/gmr:Cells/gmr:Cell[lower-case(.)='project']/following-sibling::gmr:Cell[1]"/>        
        <xsl:attribute name="status" select="'active'"/>
        <xsl:attribute name="validate" select="'no'"/>
        <xsl:attribute name="remarks4engineer" select="$remarks4engineer"/>
        <xsl:attribute name="remarks4translation" select="$remarks4translation"/>        
        <xsl:attribute name="addressee" select="$addressee"/>
        <xsl:attribute name="categorizationcodepath" select="$language-sheet/gmr:Cells/gmr:Cell[lower-case(replace(.,' ',''))='group\category\subcategory(code)']/following-sibling::gmr:Cell[1]"/>        
        <xsl:attribute name="categorizationnamepath" select="$language-sheet/gmr:Cells/gmr:Cell[lower-case(replace(.,' ',''))='group\category\subcategory']/following-sibling::gmr:Cell[1]"/>        
        <xsl:attribute name="agmagcodepath" select="$language-sheet/gmr:Cells/gmr:Cell[lower-case(replace(.,' ',''))='sector\bg\lobcategory\mag\ag(code)']/following-sibling::gmr:Cell[1]"/>        
        <xsl:attribute name="agmagnamepath" select="$language-sheet/gmr:Cells/gmr:Cell[lower-case(replace(.,' ',''))='sector\bg\lobcategory\mag\ag']/following-sibling::gmr:Cell[1]"/>        
        
        <Localizations>
          <xsl:apply-templates select="$language-sheet"/>
        </Localizations>
        
        <xsl:variable name="ctn" select="$language-sheet/gmr:Cells/gmr:Cell[.='CTN']/following-sibling::gmr:Cell[1]/text()"/>
        
        <ProductReferences>
          <ProductReference code="{$ctn}" referenceName="{$ctn}"/>
        </ProductReferences>
        
        <PackagingText>
          <!--xsl:attribute name="code" select="$package-project-code"/-->
          <xsl:attribute name="code" select="$v-code"/>
          <xsl:attribute name="referenceName" select="$language-sheet/gmr:Cells/gmr:Cell[lower-case(.)='project']/following-sibling::gmr:Cell[1]"/>
          <xsl:attribute name="docStatus" select="$language-sheet/gmr:Cells/gmr:Cell[lower-case(.)='marketing status']/following-sibling::gmr:Cell[1]/text()"/>
          <xsl:attribute name="docTimeStamp" select="$docTimestamp"/>
          <xsl:attribute name="languageCode" select="'en_US'"/>
          <xsl:attribute name="remarks" select="''"/>
          
          <xsl:variable name="translation-sheet" select="gmr:Sheet[lower-case(gmr:Name)='translated elements']"/>
          <xsl:variable name="section-naming-string-header-row"
            select="$translation-sheet/gmr:Cells/gmr:Cell[@Col='0' and lower-case(.)='naming string']/@Row/string()"/>                    
          <xsl:variable name="section-kba-header-row"
            select="$translation-sheet/gmr:Cells/gmr:Cell[@Col='0' and lower-case(.)='key benefit areas and features']/@Row/string()"/>          
          <xsl:variable name="section-kba-start-row"
            select="$translation-sheet/gmr:Cells/gmr:Cell[@Col='0' and lower-case(.)='key benefit areas']/@Row/string()"/>
          <xsl:variable name="section-features-start-row"
            select="$translation-sheet/gmr:Cells/gmr:Cell[@Col='0' and lower-case(.)='features']/@Row/string()"/>
          <xsl:variable name="section-feature-name-start-row"
            select="$translation-sheet/gmr:Cells/gmr:Cell[@Col='2' and lower-case(.)='feature name']/@Row/string()"/>
          <xsl:variable name="section-feature-long-desc-start-row"
            select="$translation-sheet/gmr:Cells/gmr:Cell[@Col='2' and lower-case(.)='feature long description']/@Row/string()"/>
          <xsl:variable name="section-free-text-start-row"
            select="$translation-sheet/gmr:Cells/gmr:Cell[@Col='0' and lower-case(.)='free text']/@Row/string()"/>            
                    
          <!--CTN><xsl:value-of select="$ctn"/></CTN-->
          <ProductReferences>
            <ProductReference code="{$ctn}" referenceName="{$ctn}"/>
          </ProductReferences>          
          <!-- Process Marketing texts: Fixed number of text items -->
          <xsl:if test="$translation-sheet/gmr:Cells/gmr:Cell[@Col='0' and replace(lower-case(.),' ','')='marketingdata']">
            <xsl:apply-templates mode="marketing-data"
             select="$translation-sheet/gmr:Cells/gmr:Cell[number(@Row)&gt;3 and number(@Row)&lt;7]"/>
          </xsl:if>
          <!-- Process Free texts: Unbounded number of text items -->             
          <xsl:apply-templates mode="free-text"
             select="$translation-sheet/gmr:Cells/gmr:Cell[number(@Row)&gt;number($section-free-text-start-row)]"/>             
          <!-- Process Naming string texts: Fixed number of text items -->
          <xsl:apply-templates mode="naming-string"
            select="$translation-sheet/gmr:Cells/gmr:Cell[number(@Row)&gt;number($section-naming-string-header-row) and number(@Row)&lt;number($section-kba-header-row)]"/>
          <!-- Process KBA text items -->
          <xsl:apply-templates mode="kba"
            select="$translation-sheet/gmr:Cells/gmr:Cell[number(@Row)&gt;number($section-kba-start-row) and number(@Row)&lt;number($section-features-start-row)]"/>
          <!-- Process Feature names texts -->
          <xsl:apply-templates mode="fname"
            select="$translation-sheet/gmr:Cells/gmr:Cell[number(@Row)&gt;number($section-feature-name-start-row) and number(@Row)&lt;number($section-feature-long-desc-start-row)]"/>
          <!-- Process Feature long texts -->
          <xsl:apply-templates mode="flongdesc"
            select="$translation-sheet/gmr:Cells/gmr:Cell[number(@Row)&gt;number($section-feature-long-desc-start-row) and number(@Row)&lt;number($section-free-text-start-row)]"/>            
        </PackagingText>
      </PackagingProjectConfiguration>
    </xsl:variable>
    <root>
      <!--
         | Write the output variable to a file
         | AND put it in the resulting XML for creating the preview.
       -->
      <source:write>
        <source:source>
          <xsl:value-of select="concat($store-dir,'/',$v-code,'.xml')"/>
        </source:source>
        <source:fragment>
          <xsl:copy-of select="$output" copy-namespaces="no"/>
        </source:fragment>
      </source:write>
      <xsl:copy-of select="$output" copy-namespaces="no"/>
    </root>
  </xsl:template>
  
  <xsl:template match="gmr:Sheet[lower-case(gmr:Name)='select languages']">
    <xsl:for-each select="gmr:Cells/gmr:Cell[lower-case(.)='languages']/following-sibling::gmr:Cell[@Col='0']">
      <xsl:variable name="row" select="@Row"/>
      <xsl:variable name="l" select="text()"/>
		
      <xsl:if test="upper-case(following-sibling::gmr:Cell[@Row=$row][@Col='1'])=('YES','YES SEO')">
		  <xsl:variable name="seo" select="if (upper-case(following-sibling::gmr:Cell[@Row=$row][@Col='1'])='YES SEO') then 'true' else 'false'"/>
		  
        <xsl:choose>
          <xsl:when test="$language-map/language[@name=$l]">
            <xsl:for-each select="$language-map/language[@name=$l]">
               <Localization info:name="{$l}" languageCode="{replace(@locale,'_','-')}">
               <xsl:if test="$seo = 'true'">
                  <xsl:attribute name="seo" select="$seo"/>
               </xsl:if>
					</Localization>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <Localization info:valid="false" info:name="{$l}" languageCode=""/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="gmr:Cell[@Col='0']" mode='marketing-data'>
    <xsl:variable name="row" select="@Row"/>
    <xsl:if test=". ne '' and following-sibling::gmr:Cell[@Row=$row and @Col='2'] ne ''">
      <PackagingTextItem referenceName="{./text()}" translated="no">
        <xsl:choose>
          <xsl:when test="lower-case(.) eq 'wow'">
            <xsl:attribute name="code" select="'pt_wow'"/>
            <xsl:attribute name="itemDescription" select="'WOW'"/>
            <!--xsl:attribute name="maxLength" select="if(following-sibling::gmr:Cell[@Row=$row and @Col=$lengthcheckcolumn] != '') 
                                                    then number(following-sibling::gmr:Cell[@Row=$row and @Col=$lengthcheckcolumn])
                                                    else string-length(following-sibling::gmr:Cell[@Row=$row and @Col='2'])"/-->
            <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
          </xsl:when>
          <xsl:when test="lower-case(.) eq 'sub wow'">
            <xsl:attribute name="code" select="'pt_subwow'"/>
            <xsl:attribute name="itemDescription" select="'SubWOW'"/>
            <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>            
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="info:valid" select="'false'"/>
          </xsl:otherwise>
        </xsl:choose>
        <ItemText>
          <xsl:value-of select="following-sibling::gmr:Cell[@Row=$row and @Col='2']"/>
        </ItemText>
      </PackagingTextItem>
    </xsl:if>
  </xsl:template>
  <xsl:template match="gmr:Cell" mode="marketing-data"/>  
  
  <xsl:template match="gmr:Cell[@Col='0']" mode='free-text'>
    <xsl:variable name="row" select="@Row"/>
    <xsl:if test=". ne '' and following-sibling::gmr:Cell[@Row=$row and @Col='2'] ne ''">
      <PackagingTextItem referenceName="{concat('Freetext: ',./text())}" translated="no">
        <!-- Everything found here is treated as freetext -->
        <xsl:attribute name="code" select="concat('freetext_',replace(replace(.,' ',''),'freetext','','i'))"/>
        <xsl:attribute name="itemDescription" select="concat('Free text: ',.)"/>
        <!--xsl:attribute name="maxLength" select="string-length(following-sibling::gmr:Cell[@Row=$row and @Col='2'])" as="integer"/-->
        <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
        <ItemText>
          <xsl:value-of select="following-sibling::gmr:Cell[@Row=$row and @Col='2']"/>
        </ItemText>
      </PackagingTextItem>
    </xsl:if>
  </xsl:template>  
  <xsl:template match="gmr:Cell" mode="free-text"/>
  
  <!-- Naming string -->
  <xsl:template match="gmr:Cell[@Col='0']" mode="naming-string">
    <xsl:variable name="row" select="@Row"/>
    <xsl:if test=". ne '' and not(.=('Brand','Concept','Concept Name used','Family','Family Name used','Alphanumeric')) and following-sibling::gmr:Cell[@Row=$row and @Col='2'] ne ''">
      <PackagingTextItem referenceName="{./text()}" translated="no">
        <xsl:choose>
          <xsl:when test="lower-case(.) eq 'short naming string'">
            <xsl:attribute name="code" select="'pt_shortns'"/>
            <xsl:attribute name="itemDescription" select="'Short naming string'"/>
            <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
          </xsl:when>
          <xsl:when test="lower-case(.) eq 'descriptor'">
            <xsl:attribute name="code" select="'pt_descriptor'"/>
            <xsl:attribute name="itemDescription" select="'descriptor'"/>
            <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
          </xsl:when>
          <xsl:when test="lower-case(.) eq 'version string'">
            <xsl:attribute name="code" select="'pt_versionstring'"/>
            <xsl:attribute name="itemDescription" select="'Version string'"/>
            <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
          </xsl:when>
          <xsl:when test="lower-case(.) eq 'branded feature string'">
            <xsl:attribute name="code" select="'pt_brfeatstring'"/>
            <xsl:attribute name="itemDescription" select="'Branded feature string'"/>
            <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="info:valid" select="'false'"/>
          </xsl:otherwise>
        </xsl:choose>
        <ItemText>
          <xsl:value-of select="following-sibling::gmr:Cell[@Row=$row and @Col='2']"/>
        </ItemText>
      </PackagingTextItem>
    </xsl:if>
  </xsl:template>
  <xsl:template match="gmr:Cell" mode="naming-string"/>
  
  <!--  KBA -->
  <xsl:template match="gmr:Cell[@Col='0']" mode="kba">
    <xsl:variable name="row" select="@Row"/>
    <xsl:if test=". ne '' and . ne 'Code' and following-sibling::gmr:Cell[@Row=$row and @Col='2'] ne ''">
      <PackagingTextItem referenceName="{concat('KBA ', ./text())}" translated="no">
        <xsl:attribute name="code" select="concat('kba_',./text())"/>
        <xsl:attribute name="remarks" select="./text()"/>
        <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
        <xsl:choose>  
          <xsl:when test="matches(.,'^K\d+$') or matches(.,'^KBA')">
            <xsl:attribute name="itemDescription" select="'Key benefit area'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="itemDescription" select="'not classified'"/>
          </xsl:otherwise>
        </xsl:choose>
        <ItemText>
          <xsl:value-of select="following-sibling::gmr:Cell[@Row=$row and @Col='2']"/>
        </ItemText>
      </PackagingTextItem>
    </xsl:if>
  </xsl:template>
  <xsl:template match="gmr:Cell" mode="kba"/>
  
  <!-- Feature names -->
  <xsl:template match="gmr:Cell[@Col='0']" mode="fname">
    <xsl:variable name="row" select="@Row"/>
    <xsl:if test=". ne '' and . ne 'Code' and following-sibling::gmr:Cell[@Row=$row and @Col='2'] ne ''">
      <PackagingTextItem referenceName="{concat('Name for ', ./text())}" translated="no">
        <xsl:attribute name="code" select="concat('fname_', ./text())"/>
        <xsl:attribute name="remarks" select="./text()"/>
        <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
        <xsl:choose>  
          <xsl:when test="matches(.,'^F\d+$') or matches(.,'^FEA')">
            <xsl:attribute name="itemDescription" select="'Feature name'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="itemDescription" select="'not classified'"/>
          </xsl:otherwise>
        </xsl:choose>
        <ItemText>
          <xsl:value-of select="following-sibling::gmr:Cell[@Row=$row and @Col='2']"/>
        </ItemText>
      </PackagingTextItem>
    </xsl:if>
  </xsl:template>
  <xsl:template match="gmr:Cell" mode="fname"/>
  
  <!-- Feature short description -->
  <xsl:template match="gmr:Cell[@Col='0']" mode="fshortdesc">
    <xsl:variable name="row" select="@Row"/>
    <xsl:if test=". ne '' and . ne 'Code' and following-sibling::gmr:Cell[@Row=$row and @Col='2'] ne ''">
      <PackagingTextItem referenceName="{concat('Short desc for ', ./text())}" translated="no">
        <xsl:attribute name="code" select="concat('fdescs_', ./text())"/>
        <xsl:attribute name="remarks" select="./text()"/>
        <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
        <xsl:choose>  
          <xsl:when test="matches(.,'^F\d+$') or matches(.,'^FEA')">
            <xsl:attribute name="itemDescription" select="'Feature short description'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="itemDescription" select="'not classified'"/>
          </xsl:otherwise>
        </xsl:choose>
        <ItemText>
          <xsl:value-of select="following-sibling::gmr:Cell[@Row=$row and @Col='2']"/>
        </ItemText>
      </PackagingTextItem>
    </xsl:if>
  </xsl:template>
  <xsl:template match="gmr:Cell" mode="fshortdesc"/>
  
  <!-- Feature long description -->
  <xsl:template match="gmr:Cell[@Col='0']" mode="flongdesc">
    <xsl:variable name="row" select="@Row"/>
    <xsl:if test=". ne '' and . ne 'Code' and following-sibling::gmr:Cell[@Row=$row and @Col='2'] ne ''">
      <PackagingTextItem referenceName="{concat('Long desc for ', ./text())}" translated="no">
        <xsl:attribute name="code" select="concat('fdescl_', ./text())"/>
        <xsl:attribute name="remarks" select="./text()"/>
        <xsl:attribute name="maxLength" select="my:getmaxlength(.,$row,$lengthcheckcolumn)"/>
        <xsl:choose>  
          <xsl:when test="matches(.,'^F\d+$') or matches(.,'^FEA')">
            <xsl:attribute name="itemDescription" select="'Feature long description'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="itemDescription" select="'not classified'"/>
          </xsl:otherwise>
        </xsl:choose>
        <ItemText>
          <xsl:value-of select="following-sibling::gmr:Cell[@Row=$row and @Col='2']"/>
        </ItemText>
      </PackagingTextItem>
    </xsl:if>
  </xsl:template>
  <xsl:template match="gmr:Cell" mode="flongdesc"/>

</xsl:stylesheet>

<!--
Example input file

<?xml version="1.0" encoding="UTF-8"?>
<gmr:Workbook xmlns:gmr="http://www.gnome.org/gnumeric/v7">
  <gmr:SheetNameIndex>
    <gmr:SheetName>Explanation</gmr:SheetName>
    <gmr:SheetName>Select languages</gmr:SheetName>
    <gmr:SheetName>Translated elements</gmr:SheetName>
    <gmr:SheetName>Ranking Info</gmr:SheetName>
  </gmr:SheetNameIndex>
  <gmr:Sheets>
    <gmr:Sheet>
      <gmr:Name>Explanation</gmr:Name>
      <gmr:MaxCol>1</gmr:MaxCol>
      <gmr:MaxRow>15</gmr:MaxRow>
      <gmr:Cells>
        <gmr:Cell Row="0" Col="0" ValueType="60">Packaging Brief</gmr:Cell>
        <gmr:Cell Row="1" Col="0" ValueType="60">The Packaging Brief can be used to request translations on demand in a relatively early stage of the product creation process. With the Packaging Brief you can request translations for texts that should be used on the packaging of a product.</gmr:Cell>
        <gmr:Cell Row="2" Col="0" ValueType="10"/>
        <gmr:Cell Row="3" Col="0" ValueType="60">This generated Excel file contains four sheets:</gmr:Cell>
        <gmr:Cell Row="4" Col="0" ValueType="10"/>
        <gmr:Cell Row="5" Col="0" ValueType="60">The first sheet "Explanation" is the sheet which you are currently reading.</gmr:Cell>
        <gmr:Cell Row="6" Col="0" ValueType="60">On the "Select languages" sheet you choose the languages for which the packaging data needs to be translated. Our translation provider directly supports all languages in the overview.</gmr:Cell>
        <gmr:Cell Row="7" Col="0" ValueType="10"/>
        <gmr:Cell Row="8" Col="0" ValueType="60">The third "Translated elements" sheet contains the text elements that will be translated. In column D of this sheet the translation agency will insert the translations. For every language request a seperate Excel file will be sent back to you. To secure full alignment with source text and the translation, the source text is protected and can not be altered. If you want to change the source text, than you need to change this text in PFS3.</gmr:Cell>
        <gmr:Cell Row="9" Col="0" ValueType="10"/>
        <gmr:Cell Row="10" Col="0" ValueType="60">The last "Ranking Info" sheet contains the ranking combination of features and KBA &amp; Features combinations.</gmr:Cell>
        <gmr:Cell Row="11" Col="0" ValueType="10"/>
        <gmr:Cell Row="12" Col="0" ValueType="60">If you have selected the languages for which you want to start up a translation, please send the file to philipspackaging@sdl.com. The translation service provider ensures that you receive the file with the requested translations back within 3 weeks. The cost for these translations will be handled by our central translation budget. </gmr:Cell>
        <gmr:Cell Row="13" Col="0" ValueType="10"/>
        <gmr:Cell Row="14" Col="0" ValueType="60">For more information contact </gmr:Cell>
        <gmr:Cell Row="15" Col="0" ValueType="60">Central.Marketing.Support</gmr:Cell>
      </gmr:Cells>
    </gmr:Sheet>
    <gmr:Sheet>
      <gmr:Name>Select languages</gmr:Name>
      <gmr:MaxCol>3</gmr:MaxCol>
      <gmr:MaxRow>40</gmr:MaxRow>
      <gmr:Cells>
        <gmr:Cell Row="0" Col="0" ValueType="60">Packaging brief</gmr:Cell>
        <gmr:Cell Row="0" Col="1" ValueType="10"/>
        <gmr:Cell Row="1" Col="0" ValueType="10"/>
        <gmr:Cell Row="1" Col="1" ValueType="10"/>
        <gmr:Cell Row="2" Col="0" ValueType="60">CTN</gmr:Cell>
        <gmr:Cell Row="2" Col="1" ValueType="60">7FF1MS/05</gmr:Cell>
        <gmr:Cell Row="3" Col="0" ValueType="60">Basic Type</gmr:Cell>
        <gmr:Cell Row="3" Col="1" ValueType="60">7FF1MS</gmr:Cell>
        <gmr:Cell Row="4" Col="0" ValueType="60">Project</gmr:Cell>
        <gmr:Cell Row="4" Col="1" ValueType="10"/>
        <gmr:Cell Row="5" Col="0" ValueType="60">Marketing Status</gmr:Cell>
        <gmr:Cell Row="5" Col="1" ValueType="60">Final Published</gmr:Cell>
        <gmr:Cell Row="6" Col="0" ValueType="60">Marketing Version</gmr:Cell>
        <gmr:Cell Row="6" Col="1" ValueType="60">1.0</gmr:Cell>
        <gmr:Cell Row="7" Col="0" ValueType="60">Report Date</gmr:Cell>
        <gmr:Cell Row="7" Col="1" ValueType="40">39465.49625</gmr:Cell>
        <gmr:Cell Row="8" Col="0" ValueType="10"/>
        <gmr:Cell Row="8" Col="1" ValueType="10"/>
        <gmr:Cell Row="9" Col="0" ValueType="60">Languages</gmr:Cell>
        <gmr:Cell Row="9" Col="1" ValueType="60">Translation requested</gmr:Cell>
        <gmr:Cell Row="10" Col="0" ValueType="60">Bulgarian</gmr:Cell>
        
        For some reason the HSSFGenerator (or Excel) creates extra columns for languages
        that are set to 'Yes'
        <gmr:Cell Row="10" Col="1" ValueType="60">Yes</gmr:Cell>
        <gmr:Cell Row="10" Col="2" ValueType="60"> </gmr:Cell>
        <gmr:Cell Row="11" Col="0" ValueType="60">Chinese (simplified Chinese)</gmr:Cell>
        <gmr:Cell Row="11" Col="1" ValueType="60">Yes</gmr:Cell>
        <gmr:Cell Row="11" Col="2" ValueType="60">Yes</gmr:Cell>
        <gmr:Cell Row="12" Col="0" ValueType="60">Taiwanese (traditional Chinese)</gmr:Cell>
        <gmr:Cell Row="12" Col="1" ValueType="60">Yes</gmr:Cell>
        <gmr:Cell Row="13" Col="0" ValueType="60">Croatian</gmr:Cell>
        <gmr:Cell Row="13" Col="1" ValueType="10"/>
        <gmr:Cell Row="14" Col="0" ValueType="60">Czech</gmr:Cell>
        <gmr:Cell Row="14" Col="1" ValueType="10"/>
        <gmr:Cell Row="15" Col="0" ValueType="60">Dutch (Netherlands)</gmr:Cell>
        <gmr:Cell Row="15" Col="1" ValueType="10"/>
        <gmr:Cell Row="16" Col="0" ValueType="60">English (UK)</gmr:Cell>
        <gmr:Cell Row="16" Col="1" ValueType="10"/>
        <gmr:Cell Row="17" Col="0" ValueType="60">Finnish</gmr:Cell>
        <gmr:Cell Row="17" Col="1" ValueType="10"/>
        <gmr:Cell Row="18" Col="0" ValueType="60">French (France)</gmr:Cell>
        <gmr:Cell Row="18" Col="1" ValueType="10">Yes</gmr:Cell>
        <gmr:Cell Row="19" Col="0" ValueType="60">Canadian French (Canada)</gmr:Cell>
        <gmr:Cell Row="19" Col="1" ValueType="10"/>
        <gmr:Cell Row="20" Col="0" ValueType="60">German (Germany)</gmr:Cell>
        <gmr:Cell Row="20" Col="1" ValueType="10"/>
        <gmr:Cell Row="21" Col="0" ValueType="60">Greek (Greece)</gmr:Cell>
        <gmr:Cell Row="21" Col="1" ValueType="10"/>
        <gmr:Cell Row="22" Col="0" ValueType="60">Hungarian (Hungary)</gmr:Cell>
        <gmr:Cell Row="22" Col="1" ValueType="10"/>
        <gmr:Cell Row="23" Col="0" ValueType="60">Italian (Italy)</gmr:Cell>
        <gmr:Cell Row="23" Col="1" ValueType="10"/>
        <gmr:Cell Row="24" Col="0" ValueType="60">Korean (Korea)</gmr:Cell>
        <gmr:Cell Row="24" Col="1" ValueType="10"/>
        <gmr:Cell Row="25" Col="0" ValueType="60">Norwegian (Norway)</gmr:Cell>
        <gmr:Cell Row="25" Col="1" ValueType="10"/>
        <gmr:Cell Row="26" Col="0" ValueType="60">Polish (Poland)</gmr:Cell>
        <gmr:Cell Row="26" Col="1" ValueType="10"/>
        <gmr:Cell Row="27" Col="0" ValueType="60">Portuguese (Portugal)</gmr:Cell>
        <gmr:Cell Row="27" Col="1" ValueType="10"/>
        <gmr:Cell Row="28" Col="0" ValueType="60">Portuguese (Brazil)</gmr:Cell>
        <gmr:Cell Row="28" Col="1" ValueType="10"/>
        <gmr:Cell Row="29" Col="0" ValueType="60">Romanian (Romania)</gmr:Cell>
        <gmr:Cell Row="29" Col="1" ValueType="10"/>
        <gmr:Cell Row="30" Col="0" ValueType="60">Russian (Russia)</gmr:Cell>
        <gmr:Cell Row="30" Col="1" ValueType="10"/>
        <gmr:Cell Row="31" Col="0" ValueType="60">Russian (Ukraine)</gmr:Cell>
        <gmr:Cell Row="31" Col="1" ValueType="10"/>
        <gmr:Cell Row="32" Col="0" ValueType="60">Serbian (Serbia Montenegro)</gmr:Cell>
        <gmr:Cell Row="32" Col="1" ValueType="10"/>
        <gmr:Cell Row="33" Col="0" ValueType="60">Slovakian (Slovakia)</gmr:Cell>
        <gmr:Cell Row="33" Col="1" ValueType="10"/>
        <gmr:Cell Row="34" Col="0" ValueType="60">Slovenian (Slovania)</gmr:Cell>
        <gmr:Cell Row="34" Col="1" ValueType="10"/>
        <gmr:Cell Row="35" Col="0" ValueType="60">Spanish (Spain)</gmr:Cell>
        <gmr:Cell Row="35" Col="1" ValueType="10"/>
        <gmr:Cell Row="36" Col="0" ValueType="60">AR Spanish  (Argentina, Uruguay)</gmr:Cell>
        <gmr:Cell Row="36" Col="1" ValueType="10"/>
        <gmr:Cell Row="37" Col="0" ValueType="60">Latam Spanish (Mexico, Columbia, Chile, Peru, Venezuela)</gmr:Cell>
        <gmr:Cell Row="37" Col="1" ValueType="10"/>
        <gmr:Cell Row="38" Col="0" ValueType="60">Swedish (Sweden)</gmr:Cell>
        <gmr:Cell Row="38" Col="1" ValueType="10"/>
        <gmr:Cell Row="39" Col="0" ValueType="60">Thai (Thailand)</gmr:Cell>
        <gmr:Cell Row="39" Col="1" ValueType="10"/>
        <gmr:Cell Row="40" Col="0" ValueType="60">Turkish (Turkey)</gmr:Cell>
        <gmr:Cell Row="40" Col="1" ValueType="10"/>
      </gmr:Cells>
    </gmr:Sheet>
    <gmr:Sheet>
      <gmr:Name>Translated elements</gmr:Name>
      <gmr:MaxCol>5</gmr:MaxCol>
      <gmr:MaxRow>76</gmr:MaxRow>
      <gmr:Cells>
        <gmr:Cell Row="0" Col="0" ValueType="60">Attribute</gmr:Cell>
        <gmr:Cell Row="0" Col="1" ValueType="60">Maximum length (Master)</gmr:Cell>
        <gmr:Cell Row="0" Col="2" ValueType="60">Master</gmr:Cell>
        <gmr:Cell Row="0" Col="3" ValueType="60">Translated</gmr:Cell>
        <gmr:Cell Row="0" Col="4" ValueType="60">Length check (incl. +30%)</gmr:Cell>
        <gmr:Cell Row="1" Col="0" ValueType="10"/>
        <gmr:Cell Row="1" Col="1" ValueType="10"/>
        <gmr:Cell Row="1" Col="2" ValueType="10"/>
        <gmr:Cell Row="1" Col="3" ValueType="60">Language</gmr:Cell>
        <gmr:Cell Row="3" Col="0" ValueType="60">Marketing Data</gmr:Cell>
        <gmr:Cell Row="3" Col="1" ValueType="10"/>
        <gmr:Cell Row="3" Col="2" ValueType="10"/>
        <gmr:Cell Row="3" Col="3" ValueType="10"/>
        <gmr:Cell Row="3" Col="4" ValueType="10"/>
        <gmr:Cell Row="5" Col="0" ValueType="60">WOW</gmr:Cell>
        <gmr:Cell Row="5" Col="1" ValueType="40">50.0</gmr:Cell>
        <gmr:Cell Row="5" Col="2" ValueType="60">The perfect gift for your loved ones</gmr:Cell>
        <gmr:Cell Row="5" Col="3" ValueType="10"/>
        <gmr:Cell Row="5" Col="4" ValueType="60">0 chars (max=65)</gmr:Cell>
        <gmr:Cell Row="6" Col="0" ValueType="60">Sub WOW</gmr:Cell>
        <gmr:Cell Row="6" Col="1" ValueType="40">50.0</gmr:Cell>
        <gmr:Cell Row="6" Col="2" ValueType="10"/>
        <gmr:Cell Row="6" Col="3" ValueType="10"/>
        <gmr:Cell Row="6" Col="4" ValueType="60">0 chars (max=65)</gmr:Cell>
        <gmr:Cell Row="7" Col="0" ValueType="10"/>
        <gmr:Cell Row="7" Col="1" ValueType="10"/>
        <gmr:Cell Row="7" Col="2" ValueType="10"/>
        <gmr:Cell Row="7" Col="3" ValueType="10"/>
        <gmr:Cell Row="8" Col="0" ValueType="60">Naming string</gmr:Cell>
        <gmr:Cell Row="8" Col="1" ValueType="10"/>
        <gmr:Cell Row="8" Col="2" ValueType="10"/>
        <gmr:Cell Row="8" Col="3" ValueType="10"/>
        <gmr:Cell Row="8" Col="4" ValueType="10"/>
        <gmr:Cell Row="10" Col="0" ValueType="60">Short Naming string</gmr:Cell>
        <gmr:Cell Row="10" Col="1" ValueType="40">50.0</gmr:Cell>
        <gmr:Cell Row="10" Col="2" ValueType="60">7" PhotoFrame</gmr:Cell>
        <gmr:Cell Row="10" Col="3" ValueType="10"/>
        <gmr:Cell Row="10" Col="4" ValueType="60">0 chars (max=65)</gmr:Cell>
        <gmr:Cell Row="11" Col="0" ValueType="60">Brand</gmr:Cell>
        <gmr:Cell Row="11" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="11" Col="2" ValueType="60">PHILIPS</gmr:Cell>
        <gmr:Cell Row="11" Col="3" ValueType="10"/>
        <gmr:Cell Row="11" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="12" Col="0" ValueType="60">Concept</gmr:Cell>
        <gmr:Cell Row="12" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="12" Col="2" ValueType="60">&lt;not applicable&gt;</gmr:Cell>
        <gmr:Cell Row="12" Col="3" ValueType="10"/>
        <gmr:Cell Row="12" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="13" Col="0" ValueType="60">Concept Name used</gmr:Cell>
        <gmr:Cell Row="13" Col="1" ValueType="40">1.0</gmr:Cell>
        <gmr:Cell Row="13" Col="2" ValueType="60">N</gmr:Cell>
        <gmr:Cell Row="13" Col="3" ValueType="10"/>
        <gmr:Cell Row="13" Col="4" ValueType="10"/>
        <gmr:Cell Row="14" Col="0" ValueType="60">Family</gmr:Cell>
        <gmr:Cell Row="14" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="14" Col="2" ValueType="60">&lt;not applicable&gt;</gmr:Cell>
        <gmr:Cell Row="14" Col="3" ValueType="10"/>
        <gmr:Cell Row="14" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="15" Col="0" ValueType="60">Family Name used</gmr:Cell>
        <gmr:Cell Row="15" Col="1" ValueType="40">1.0</gmr:Cell>
        <gmr:Cell Row="15" Col="2" ValueType="60">N</gmr:Cell>
        <gmr:Cell Row="15" Col="3" ValueType="10"/>
        <gmr:Cell Row="15" Col="4" ValueType="10"/>
        <gmr:Cell Row="16" Col="0" ValueType="60">Alphanumeric</gmr:Cell>
        <gmr:Cell Row="16" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="16" Col="2" ValueType="60">7FF1MS</gmr:Cell>
        <gmr:Cell Row="16" Col="3" ValueType="10"/>
        <gmr:Cell Row="16" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="17" Col="0" ValueType="60">Descriptor</gmr:Cell>
        <gmr:Cell Row="17" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="17" Col="2" ValueType="60">PhotoFrame</gmr:Cell>
        <gmr:Cell Row="17" Col="3" ValueType="10"/>
        <gmr:Cell Row="17" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="18" Col="0" ValueType="60">Version string</gmr:Cell>
        <gmr:Cell Row="18" Col="1" ValueType="40">50.0</gmr:Cell>
        <gmr:Cell Row="18" Col="2" ValueType="60">7"</gmr:Cell>
        <gmr:Cell Row="18" Col="3" ValueType="10"/>
        <gmr:Cell Row="18" Col="4" ValueType="60">0 chars (max=65)</gmr:Cell>
        <gmr:Cell Row="19" Col="0" ValueType="60">Branded Feature string</gmr:Cell>
        <gmr:Cell Row="19" Col="1" ValueType="40">50.0</gmr:Cell>
        <gmr:Cell Row="19" Col="2" ValueType="10"/>
        <gmr:Cell Row="19" Col="3" ValueType="10"/>
        <gmr:Cell Row="19" Col="4" ValueType="60">0 chars (max=65)</gmr:Cell>
        <gmr:Cell Row="20" Col="0" ValueType="10"/>
        <gmr:Cell Row="20" Col="1" ValueType="10"/>
        <gmr:Cell Row="20" Col="2" ValueType="10"/>
        <gmr:Cell Row="20" Col="3" ValueType="10"/>
        <gmr:Cell Row="21" Col="0" ValueType="60">Key Benefit Areas and Features</gmr:Cell>
        <gmr:Cell Row="21" Col="1" ValueType="10"/>
        <gmr:Cell Row="21" Col="2" ValueType="10"/>
        <gmr:Cell Row="21" Col="3" ValueType="10"/>
        <gmr:Cell Row="21" Col="4" ValueType="10"/>
        <gmr:Cell Row="22" Col="0" ValueType="10"/>
        <gmr:Cell Row="22" Col="1" ValueType="10"/>
        <gmr:Cell Row="22" Col="2" ValueType="10"/>
        <gmr:Cell Row="22" Col="3" ValueType="10"/>
        <gmr:Cell Row="23" Col="0" ValueType="60">Key Benefit Areas</gmr:Cell>
        <gmr:Cell Row="23" Col="1" ValueType="10"/>
        <gmr:Cell Row="23" Col="2" ValueType="10"/>
        <gmr:Cell Row="23" Col="3" ValueType="10"/>
        <gmr:Cell Row="23" Col="4" ValueType="10"/>
        <gmr:Cell Row="24" Col="0" ValueType="60">Code</gmr:Cell>
        <gmr:Cell Row="24" Col="1" ValueType="10"/>
        <gmr:Cell Row="24" Col="2" ValueType="10"/>
        <gmr:Cell Row="24" Col="3" ValueType="10"/>
        <gmr:Cell Row="24" Col="4" ValueType="10"/>
        <gmr:Cell Row="25" Col="0" ValueType="10"/>
        <gmr:Cell Row="25" Col="1" ValueType="10"/>
        <gmr:Cell Row="25" Col="2" ValueType="10"/>
        <gmr:Cell Row="25" Col="3" ValueType="10"/>
        <gmr:Cell Row="26" Col="0" ValueType="60">K4000421  </gmr:Cell>
        <gmr:Cell Row="26" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="26" Col="2" ValueType="60">Top quality display for print-like pictures</gmr:Cell>
        <gmr:Cell Row="26" Col="3" ValueType="10"/>
        <gmr:Cell Row="26" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="27" Col="0" ValueType="60">K4000422  </gmr:Cell>
        <gmr:Cell Row="27" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="27" Col="2" ValueType="60">Luxurious design to complement your photos</gmr:Cell>
        <gmr:Cell Row="27" Col="3" ValueType="10"/>
        <gmr:Cell Row="27" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="28" Col="0" ValueType="60">K300004202</gmr:Cell>
        <gmr:Cell Row="28" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="28" Col="2" ValueType="60">Easily display your digital photos</gmr:Cell>
        <gmr:Cell Row="28" Col="3" ValueType="10"/>
        <gmr:Cell Row="28" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="29" Col="0" ValueType="60">K300000265</gmr:Cell>
        <gmr:Cell Row="29" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="29" Col="2" ValueType="60">Great convenience</gmr:Cell>
        <gmr:Cell Row="29" Col="3" ValueType="10"/>
        <gmr:Cell Row="29" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="30" Col="0" ValueType="10"/>
        <gmr:Cell Row="30" Col="1" ValueType="10"/>
        <gmr:Cell Row="30" Col="2" ValueType="10"/>
        <gmr:Cell Row="30" Col="3" ValueType="10"/>
        <gmr:Cell Row="31" Col="0" ValueType="10"/>
        <gmr:Cell Row="31" Col="1" ValueType="10"/>
        <gmr:Cell Row="31" Col="2" ValueType="10"/>
        <gmr:Cell Row="31" Col="3" ValueType="10"/>
        <gmr:Cell Row="32" Col="0" ValueType="60">Features</gmr:Cell>
        <gmr:Cell Row="32" Col="1" ValueType="10"/>
        <gmr:Cell Row="32" Col="2" ValueType="10"/>
        <gmr:Cell Row="32" Col="3" ValueType="10"/>
        <gmr:Cell Row="32" Col="4" ValueType="10"/>
        <gmr:Cell Row="33" Col="0" ValueType="60">Code</gmr:Cell>
        <gmr:Cell Row="33" Col="1" ValueType="10"/>
        <gmr:Cell Row="33" Col="2" ValueType="60">Feature Name</gmr:Cell>
        <gmr:Cell Row="33" Col="3" ValueType="10"/>
        <gmr:Cell Row="33" Col="4" ValueType="10"/>
        <gmr:Cell Row="34" Col="0" ValueType="10"/>
        <gmr:Cell Row="34" Col="1" ValueType="10"/>
        <gmr:Cell Row="34" Col="2" ValueType="10"/>
        <gmr:Cell Row="34" Col="3" ValueType="10"/>
        <gmr:Cell Row="35" Col="0" ValueType="10"/>
        <gmr:Cell Row="35" Col="1" ValueType="10"/>
        <gmr:Cell Row="35" Col="2" ValueType="10"/>
        <gmr:Cell Row="35" Col="3" ValueType="10"/>
        <gmr:Cell Row="36" Col="0" ValueType="60">F300011747</gmr:Cell>
        <gmr:Cell Row="36" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="36" Col="2" ValueType="60">High pixel density display</gmr:Cell>
        <gmr:Cell Row="36" Col="3" ValueType="10"/>
        <gmr:Cell Row="36" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="37" Col="0" ValueType="60">F400000252</gmr:Cell>
        <gmr:Cell Row="37" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="37" Col="2" ValueType="60">Rich, vibrant colors</gmr:Cell>
        <gmr:Cell Row="37" Col="3" ValueType="10"/>
        <gmr:Cell Row="37" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="38" Col="0" ValueType="60">F400000265</gmr:Cell>
        <gmr:Cell Row="38" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="38" Col="2" ValueType="60">Quality design and materials</gmr:Cell>
        <gmr:Cell Row="38" Col="3" ValueType="10"/>
        <gmr:Cell Row="38" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="39" Col="0" ValueType="60">F300004323</gmr:Cell>
        <gmr:Cell Row="39" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="39" Col="2" ValueType="60">Award-winning design</gmr:Cell>
        <gmr:Cell Row="39" Col="3" ValueType="10"/>
        <gmr:Cell Row="39" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="40" Col="0" ValueType="60">F400000266</gmr:Cell>
        <gmr:Cell Row="40" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="40" Col="2" ValueType="60">Interchangeable frames</gmr:Cell>
        <gmr:Cell Row="40" Col="3" ValueType="10"/>
        <gmr:Cell Row="40" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="41" Col="0" ValueType="60">F300011744</gmr:Cell>
        <gmr:Cell Row="41" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="41" Col="2" ValueType="60">Memory card slots</gmr:Cell>
        <gmr:Cell Row="41" Col="3" ValueType="10"/>
        <gmr:Cell Row="41" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="42" Col="0" ValueType="60">F400000248</gmr:Cell>
        <gmr:Cell Row="42" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="42" Col="2" ValueType="60">Easy USB connectivity</gmr:Cell>
        <gmr:Cell Row="42" Col="3" ValueType="10"/>
        <gmr:Cell Row="42" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="43" Col="0" ValueType="60">F300012285</gmr:Cell>
        <gmr:Cell Row="43" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="43" Col="2" ValueType="60">Create slideshows</gmr:Cell>
        <gmr:Cell Row="43" Col="3" ValueType="10"/>
        <gmr:Cell Row="43" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="44" Col="0" ValueType="60">F300011745</gmr:Cell>
        <gmr:Cell Row="44" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="44" Col="2" ValueType="60">Multiple viewing modes</gmr:Cell>
        <gmr:Cell Row="44" Col="3" ValueType="10"/>
        <gmr:Cell Row="44" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="45" Col="0" ValueType="60">F300011764</gmr:Cell>
        <gmr:Cell Row="45" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="45" Col="2" ValueType="60">Run on built-in battery or AC</gmr:Cell>
        <gmr:Cell Row="45" Col="3" ValueType="10"/>
        <gmr:Cell Row="45" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="46" Col="0" ValueType="60">F300011750</gmr:Cell>
        <gmr:Cell Row="46" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="46" Col="2" ValueType="60">On-off timer</gmr:Cell>
        <gmr:Cell Row="46" Col="3" ValueType="10"/>
        <gmr:Cell Row="46" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="47" Col="0" ValueType="10"/>
        <gmr:Cell Row="47" Col="1" ValueType="10"/>
        <gmr:Cell Row="47" Col="2" ValueType="10"/>
        <gmr:Cell Row="47" Col="3" ValueType="10"/>
        <gmr:Cell Row="48" Col="0" ValueType="60">Code</gmr:Cell>
        <gmr:Cell Row="48" Col="1" ValueType="10"/>
        <gmr:Cell Row="48" Col="2" ValueType="60">Feature Short description</gmr:Cell>
        <gmr:Cell Row="48" Col="3" ValueType="10"/>
        <gmr:Cell Row="48" Col="4" ValueType="10"/>
        <gmr:Cell Row="49" Col="0" ValueType="10"/>
        <gmr:Cell Row="49" Col="1" ValueType="10"/>
        <gmr:Cell Row="49" Col="2" ValueType="10"/>
        <gmr:Cell Row="49" Col="3" ValueType="10"/>
        <gmr:Cell Row="50" Col="0" ValueType="60">F300011747</gmr:Cell>
        <gmr:Cell Row="50" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="50" Col="2" ValueType="60">High pixel density display</gmr:Cell>
        <gmr:Cell Row="50" Col="3" ValueType="10"/>
        <gmr:Cell Row="50" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="51" Col="0" ValueType="60">F400000252</gmr:Cell>
        <gmr:Cell Row="51" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="51" Col="2" ValueType="60">Rich, vibrant colors</gmr:Cell>
        <gmr:Cell Row="51" Col="3" ValueType="10"/>
        <gmr:Cell Row="51" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="52" Col="0" ValueType="60">F400000265</gmr:Cell>
        <gmr:Cell Row="52" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="52" Col="2" ValueType="60">Quality design and materials</gmr:Cell>
        <gmr:Cell Row="52" Col="3" ValueType="10"/>
        <gmr:Cell Row="52" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="53" Col="0" ValueType="60">F300004323</gmr:Cell>
        <gmr:Cell Row="53" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="53" Col="2" ValueType="60">Award-winning design</gmr:Cell>
        <gmr:Cell Row="53" Col="3" ValueType="10"/>
        <gmr:Cell Row="53" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="54" Col="0" ValueType="60">F400000266</gmr:Cell>
        <gmr:Cell Row="54" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="54" Col="2" ValueType="60">Interchangeable frames</gmr:Cell>
        <gmr:Cell Row="54" Col="3" ValueType="10"/>
        <gmr:Cell Row="54" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="55" Col="0" ValueType="60">F300011744</gmr:Cell>
        <gmr:Cell Row="55" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="55" Col="2" ValueType="60">Memory card slots</gmr:Cell>
        <gmr:Cell Row="55" Col="3" ValueType="10"/>
        <gmr:Cell Row="55" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="56" Col="0" ValueType="60">F400000248</gmr:Cell>
        <gmr:Cell Row="56" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="56" Col="2" ValueType="60">Easy USB connectivity</gmr:Cell>
        <gmr:Cell Row="56" Col="3" ValueType="10"/>
        <gmr:Cell Row="56" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="57" Col="0" ValueType="60">F300012285</gmr:Cell>
        <gmr:Cell Row="57" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="57" Col="2" ValueType="60">Create slideshows</gmr:Cell>
        <gmr:Cell Row="57" Col="3" ValueType="10"/>
        <gmr:Cell Row="57" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="58" Col="0" ValueType="60">F300011745</gmr:Cell>
        <gmr:Cell Row="58" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="58" Col="2" ValueType="60">Multiple viewing modes</gmr:Cell>
        <gmr:Cell Row="58" Col="3" ValueType="10"/>
        <gmr:Cell Row="58" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="59" Col="0" ValueType="60">F300011764</gmr:Cell>
        <gmr:Cell Row="59" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="59" Col="2" ValueType="60">Run on built-in battery or AC</gmr:Cell>
        <gmr:Cell Row="59" Col="3" ValueType="10"/>
        <gmr:Cell Row="59" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="60" Col="0" ValueType="60">F300011750</gmr:Cell>
        <gmr:Cell Row="60" Col="1" ValueType="40">30.0</gmr:Cell>
        <gmr:Cell Row="60" Col="2" ValueType="60">On-off timer</gmr:Cell>
        <gmr:Cell Row="60" Col="3" ValueType="10"/>
        <gmr:Cell Row="60" Col="4" ValueType="60">0 chars (max=39)</gmr:Cell>
        <gmr:Cell Row="61" Col="0" ValueType="10"/>
        <gmr:Cell Row="61" Col="1" ValueType="10"/>
        <gmr:Cell Row="61" Col="2" ValueType="10"/>
        <gmr:Cell Row="61" Col="3" ValueType="10"/>
        <gmr:Cell Row="62" Col="0" ValueType="10"/>
        <gmr:Cell Row="62" Col="1" ValueType="10"/>
        <gmr:Cell Row="62" Col="2" ValueType="10"/>
        <gmr:Cell Row="62" Col="3" ValueType="10"/>
        <gmr:Cell Row="63" Col="0" ValueType="60">Code</gmr:Cell>
        <gmr:Cell Row="63" Col="1" ValueType="10"/>
        <gmr:Cell Row="63" Col="2" ValueType="60">Feature Long description </gmr:Cell>
        <gmr:Cell Row="63" Col="3" ValueType="10"/>
        <gmr:Cell Row="63" Col="4" ValueType="10"/>
        <gmr:Cell Row="65" Col="0" ValueType="60">F300011747</gmr:Cell>
        <gmr:Cell Row="65" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="65" Col="2" ValueType="60">High pixel density for sharp and detailed photo display</gmr:Cell>
        <gmr:Cell Row="65" Col="3" ValueType="10"/>
        <gmr:Cell Row="65" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="66" Col="0" ValueType="60">F400000252</gmr:Cell>
        <gmr:Cell Row="66" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="66" Col="2" ValueType="60">Display all the crisp colors of professional printed photos</gmr:Cell>
        <gmr:Cell Row="66" Col="3" ValueType="10"/>
        <gmr:Cell Row="66" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="67" Col="0" ValueType="60">F400000265</gmr:Cell>
        <gmr:Cell Row="67" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="67" Col="2" ValueType="60">Exquisite materials and finishing add value to your photos</gmr:Cell>
        <gmr:Cell Row="67" Col="3" ValueType="10"/>
        <gmr:Cell Row="67" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="68" Col="0" ValueType="60">F300004323</gmr:Cell>
        <gmr:Cell Row="68" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="68" Col="2" ValueType="60">International award winning design to enrich your home decor</gmr:Cell>
        <gmr:Cell Row="68" Col="3" ValueType="10"/>
        <gmr:Cell Row="68" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="69" Col="0" ValueType="60">F400000266</gmr:Cell>
        <gmr:Cell Row="69" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="69" Col="2" ValueType="60">Four swappable frames to fit your decor and personal taste</gmr:Cell>
        <gmr:Cell Row="69" Col="3" ValueType="10"/>
        <gmr:Cell Row="69" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="70" Col="0" ValueType="60">F300011744</gmr:Cell>
        <gmr:Cell Row="70" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="70" Col="2" ValueType="60">View photos directly from memory cards - no PC required</gmr:Cell>
        <gmr:Cell Row="70" Col="3" ValueType="10"/>
        <gmr:Cell Row="70" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="71" Col="0" ValueType="60">F400000248</gmr:Cell>
        <gmr:Cell Row="71" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="71" Col="2" ValueType="60">USB connector for easy photo downloading from your PC</gmr:Cell>
        <gmr:Cell Row="71" Col="3" ValueType="10"/>
        <gmr:Cell Row="71" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="72" Col="0" ValueType="60">F300012285</gmr:Cell>
        <gmr:Cell Row="72" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="72" Col="2" ValueType="60">Create a slideshow for all stored photos</gmr:Cell>
        <gmr:Cell Row="72" Col="3" ValueType="10"/>
        <gmr:Cell Row="72" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="73" Col="0" ValueType="60">F300011745</gmr:Cell>
        <gmr:Cell Row="73" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="73" Col="2" ValueType="60">Play slideshows, single photo, thumbnails or show clock</gmr:Cell>
        <gmr:Cell Row="73" Col="3" ValueType="10"/>
        <gmr:Cell Row="73" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="74" Col="0" ValueType="60">F300011764</gmr:Cell>
        <gmr:Cell Row="74" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="74" Col="2" ValueType="60">Operate on AC power or cordlessly with rechargeable battery</gmr:Cell>
        <gmr:Cell Row="74" Col="3" ValueType="10"/>
        <gmr:Cell Row="74" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="75" Col="0" ValueType="60">F300011750</gmr:Cell>
        <gmr:Cell Row="75" Col="1" ValueType="40">60.0</gmr:Cell>
        <gmr:Cell Row="75" Col="2" ValueType="60">Automatically turn on and off display at preset times daily</gmr:Cell>
        <gmr:Cell Row="75" Col="3" ValueType="10"/>
        <gmr:Cell Row="75" Col="4" ValueType="60">0 chars (max=78)</gmr:Cell>
        <gmr:Cell Row="76" Col="3" ValueType="10"/>
      </gmr:Cells>
    </gmr:Sheet>
    <gmr:Sheet>
      <gmr:Name>Ranking Info</gmr:Name>
      <gmr:MaxCol>2</gmr:MaxCol>
      <gmr:MaxRow>34</gmr:MaxRow>
      <gmr:Cells>
        <gmr:Cell Row="0" Col="0" ValueType="60">Ranking Info</gmr:Cell>
        <gmr:Cell Row="0" Col="1" ValueType="60">Code</gmr:Cell>
        <gmr:Cell Row="2" Col="0" ValueType="60">Key Benefit Areas and Features</gmr:Cell>
        <gmr:Cell Row="2" Col="1" ValueType="10"/>
        <gmr:Cell Row="4" Col="0" ValueType="60">Top quality display for print-like pictures</gmr:Cell>
        <gmr:Cell Row="4" Col="1" ValueType="60">K4000421  </gmr:Cell>
        <gmr:Cell Row="5" Col="0" ValueType="60">High pixel density display</gmr:Cell>
        <gmr:Cell Row="5" Col="1" ValueType="60">F300011747</gmr:Cell>
        <gmr:Cell Row="6" Col="0" ValueType="60">Rich, vibrant colors</gmr:Cell>
        <gmr:Cell Row="6" Col="1" ValueType="60">F400000252</gmr:Cell>
        <gmr:Cell Row="7" Col="0" ValueType="60">Luxurious design to complement your photos</gmr:Cell>
        <gmr:Cell Row="7" Col="1" ValueType="60">K4000422  </gmr:Cell>
        <gmr:Cell Row="8" Col="0" ValueType="60">Quality design and materials</gmr:Cell>
        <gmr:Cell Row="8" Col="1" ValueType="60">F400000265</gmr:Cell>
        <gmr:Cell Row="9" Col="0" ValueType="60">Award-winning design</gmr:Cell>
        <gmr:Cell Row="9" Col="1" ValueType="60">F300004323</gmr:Cell>
        <gmr:Cell Row="10" Col="0" ValueType="60">Interchangeable frames</gmr:Cell>
        <gmr:Cell Row="10" Col="1" ValueType="60">F400000266</gmr:Cell>
        <gmr:Cell Row="11" Col="0" ValueType="60">Easily display your digital photos</gmr:Cell>
        <gmr:Cell Row="11" Col="1" ValueType="60">K300004202</gmr:Cell>
        <gmr:Cell Row="12" Col="0" ValueType="60">Memory card slots</gmr:Cell>
        <gmr:Cell Row="12" Col="1" ValueType="60">F300011744</gmr:Cell>
        <gmr:Cell Row="13" Col="0" ValueType="60">Easy USB connectivity</gmr:Cell>
        <gmr:Cell Row="13" Col="1" ValueType="60">F400000248</gmr:Cell>
        <gmr:Cell Row="14" Col="0" ValueType="60">Create slideshows</gmr:Cell>
        <gmr:Cell Row="14" Col="1" ValueType="60">F300012285</gmr:Cell>
        <gmr:Cell Row="15" Col="0" ValueType="60">Multiple viewing modes</gmr:Cell>
        <gmr:Cell Row="15" Col="1" ValueType="60">F300011745</gmr:Cell>
        <gmr:Cell Row="16" Col="0" ValueType="60">Great convenience</gmr:Cell>
        <gmr:Cell Row="16" Col="1" ValueType="60">K300000265</gmr:Cell>
        <gmr:Cell Row="17" Col="0" ValueType="60">Run on built-in battery or AC</gmr:Cell>
        <gmr:Cell Row="17" Col="1" ValueType="60">F300011764</gmr:Cell>
        <gmr:Cell Row="18" Col="0" ValueType="60">On-off timer</gmr:Cell>
        <gmr:Cell Row="18" Col="1" ValueType="60">F300011750</gmr:Cell>
        <gmr:Cell Row="20" Col="0" ValueType="60">Top Feature ranking</gmr:Cell>
        <gmr:Cell Row="20" Col="1" ValueType="10"/>
        <gmr:Cell Row="22" Col="0" ValueType="60">High pixel density display</gmr:Cell>
        <gmr:Cell Row="22" Col="1" ValueType="60">F300011747</gmr:Cell>
        <gmr:Cell Row="23" Col="0" ValueType="60">Rich, vibrant colors</gmr:Cell>
        <gmr:Cell Row="23" Col="1" ValueType="60">F400000252</gmr:Cell>
        <gmr:Cell Row="24" Col="0" ValueType="60">Quality design and materials</gmr:Cell>
        <gmr:Cell Row="24" Col="1" ValueType="60">F400000265</gmr:Cell>
        <gmr:Cell Row="25" Col="0" ValueType="60">Award-winning design</gmr:Cell>
        <gmr:Cell Row="25" Col="1" ValueType="60">F300004323</gmr:Cell>
        <gmr:Cell Row="26" Col="0" ValueType="60">Interchangeable frames</gmr:Cell>
        <gmr:Cell Row="26" Col="1" ValueType="60">F400000266</gmr:Cell>
        <gmr:Cell Row="27" Col="0" ValueType="60">Memory card slots</gmr:Cell>
        <gmr:Cell Row="27" Col="1" ValueType="60">F300011744</gmr:Cell>
        <gmr:Cell Row="28" Col="0" ValueType="60">Easy USB connectivity</gmr:Cell>
        <gmr:Cell Row="28" Col="1" ValueType="60">F400000248</gmr:Cell>
        <gmr:Cell Row="29" Col="0" ValueType="60">Create slideshows</gmr:Cell>
        <gmr:Cell Row="29" Col="1" ValueType="60">F300012285</gmr:Cell>
        <gmr:Cell Row="30" Col="0" ValueType="60">Multiple viewing modes</gmr:Cell>
        <gmr:Cell Row="30" Col="1" ValueType="60">F300011745</gmr:Cell>
        <gmr:Cell Row="31" Col="0" ValueType="60">Run on built-in battery or AC</gmr:Cell>
        <gmr:Cell Row="31" Col="1" ValueType="60">F300011764</gmr:Cell>
        <gmr:Cell Row="32" Col="0" ValueType="60">On-off timer</gmr:Cell>
        <gmr:Cell Row="32" Col="1" ValueType="60">F300011750</gmr:Cell>
        <gmr:Cell Row="34" Col="0" ValueType="60">Selling-up feature</gmr:Cell>
        <gmr:Cell Row="34" Col="1" ValueType="10"/>
      </gmr:Cells>
    </gmr:Sheet>
  </gmr:Sheets>
</gmr:Workbook>

-->
