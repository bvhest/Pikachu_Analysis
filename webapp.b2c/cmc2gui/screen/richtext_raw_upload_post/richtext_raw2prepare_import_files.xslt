<?xml version="1.0" encoding="UTF-8"?>
  <!--
    Convert an Excel input file read by the HSSFGenerator to RichText_Raw xml content See example input file at the
    bottom of this stylesheet.
  -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:source="http://apache.org/cocoon/source/1.0"
  xmlns:gmr="http://www.gnome.org/gnumeric/v7" xmlns:info="http://www.philips.com/pikachu/3.0/info" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <!-- file name of the uploaded file -->
  <xsl:param name="datafile" />
  <xsl:param name="division" select="'CE'" />
  <xsl:param name="store-dir" />
  <xsl:variable name="current-datetime" select="replace(string(current-dateTime()),'.*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}).*','$1')" />
  <xsl:variable name="current-timestamp" select="replace($current-datetime,'[^0-9]','')" />
  <xsl:variable name="docTimestamp" select="$current-datetime" />
  <xsl:variable name="main-sheet" select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[upper-case(gmr:Name)='RICHTEXT']" />
  <xsl:variable name="product-sheet" select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[upper-case(gmr:Name)='PRODUCTS']" />
  <!-- new paths -->
  <xsl:variable name="product-column" select="$product-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='CTN']/@Col" />
  <xsl:variable name="product-locales-column" select="$product-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='LOCALES']/@Col" />
  <xsl:variable name="product-itemcode-column" select="$product-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='ITEMCODE']/@Col" />
  <xsl:variable name="product-richtexttype-column" select="$product-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='RICHTEXTTYPE']/@Col" />
  <xsl:variable name="chaptercode-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='CHAPTERCODE']/@Col" />
  <xsl:variable name="chapterrefname-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='CHAPTERNAME']/@Col" />
  <xsl:variable name="chapterrank-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='CHAPTERRANK']/@Col" />
  <!-- -->
  <xsl:variable name="ctn-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='CTN']/@Col" />
  <xsl:variable name="translationrequired-column"
    select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='TRANSLATION_REQUIRED']/@Col" />
  <!-- for gifting a single locale is used to link product-locales to rich text -->
  <xsl:variable name="locales-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='LOCALES']/@Col" />
  <xsl:variable name="richtexttype-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='RICHTEXTTYPE']/@Col" />
  <xsl:variable name="itemcode-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='ITEMCODE']/@Col" />
  <xsl:variable name="itemrefname-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='ITEMREFERENCENAME']/@Col" />
  <xsl:variable name="itemrank-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='ITEMRANK']/@Col" />
  <xsl:variable name="head-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='HEAD']/@Col" />
  <xsl:variable name="body-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='BODY']/@Col" />
  <xsl:variable name="bitext-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='BULLETITEMTEXT']/@Col" />
  <xsl:variable name="birank-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='BULLETITEMRANK']/@Col" />
  <xsl:variable name="maxrow" select="number($main-sheet/gmr:MaxRow) + 1" />
  <xsl:variable name="ct"
    select="if($main-sheet/gmr:Cells/gmr:Cell[number(@Row) &gt; 0 and number(@Col)=number($translationrequired-column)][upper-case(.) = 'NO']) then 'RichText' else 'RichText_Raw'" />

  <xsl:template match="node()|@*">
    <xsl:apply-templates select="node()|@*" />
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Workbook/gmr:Sheets">
    <xsl:variable name="main-sheet" select="gmr:Sheet[upper-case(gmr:Name)='RICHTEXT']" />
    <xsl:variable name="product-sheet" select="gmr:Sheet[upper-case(gmr:Name)='PRODUCTS']" />
    <xsl:variable name="output">
      <xsl:element name="{$ct}" info:source-file="{$datafile}">
        <xsl:attribute name="DocTimeStamp" select="$docTimestamp" />
        <xsl:choose>
          <xsl:when test="$product-sheet and $ct='RichText_Raw' ">
            <xsl:call-template name="Products_Raw" />
          </xsl:when>
          <xsl:when test="$product-sheet and $ct='RichText' ">
            <xsl:call-template name="Locales" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="ctn"
              select="$main-sheet/gmr:Cells/gmr:Cell[number(@Row) &gt; 0 and number(@Col)=number($ctn-column) and text() != '']" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:variable>
    <root>
      <!--
        | Write the output variable to a file | AND put it in the resulting XML for creating the preview.
      -->
      <source:write>
        <source:source>
          <xsl:value-of
            select="if($ct='RichText_Raw') then concat($store-dir,'/',$ct,'_',$current-timestamp,'.xml')
                                else concat(replace($store-dir,'RichText_Raw','RichText'),'/',$ct,'_',$current-timestamp,'.xml')" />
        </source:source>
        <source:fragment>
          <xsl:copy-of select="$output" copy-namespaces="no" />
        </source:fragment>
      </source:write>
      <xsl:copy-of select="$output" copy-namespaces="no" />
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Cell" mode='ctn'>
    <xsl:variable name="nextctnrow"
      select="if (following-sibling::node()[number(@Col)=$ctn-column and text() != ''])
                                              then number(following-sibling::node()[number(@Col)=$ctn-column and text() != ''][1]/@Row)
                                              else $maxrow" />
    <object>
      <xsl:attribute name="object_id" select="." />
      <xsl:attribute name="locales"><xsl:for-each
        select="following-sibling::node()[number(@Row)&gt;=number(current()/@Row) 
                                                           and number(@Row)&lt;$nextctnrow
                                                           and number(@Col)=number($locales-column)]"><xsl:value-of select="replace(.,' ','')" /></xsl:for-each></xsl:attribute>
      <RichTexts>
        <xsl:apply-templates
          select="following-sibling::node()[number(@Row)&gt;=number(current()/@Row) 
                                                           and number(@Row)&lt;$nextctnrow
                                                           and number(@Col)=number($richtexttype-column) 
                                                           and text() != '' 
                                                           and replace(text(),' ','') = ('LearnMore','Q&amp;A','Testimonial','ProofPoint','ProductDescription')]"
          mode="richtexttype" />
      </RichTexts>
    </object>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Cell" mode='richtexttype'>
    <xsl:variable name="nextrichtextrow"
      select="if (following-sibling::node()[number(@Col)=$richtexttype-column and text() != ''])
                                                    then number(following-sibling::node()[number(@Col)=$richtexttype-column and text() != ''][1]/@Row)
                                                    else $maxrow" />
    <RichText>
      <xsl:attribute name="type" select="." />
      <xsl:apply-templates
        select="following-sibling::node()[number(@Row)&gt;=number(current()/@Row) 
                                                           and number(@Row)&lt;$nextrichtextrow
                                                           and number(@Col)=number($itemcode-column) 
                                                           and text() != '']"
        mode="itemcode" />
    </RichText>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Cell" mode='itemcode'>
    <xsl:variable name="nextitemcoderow"
      select="if (following-sibling::node()[number(@Col)=$itemcode-column and text() != ''])
                                                    then number(following-sibling::node()[number(@Col)=$itemcode-column and text() != ''][1]/@Row)
                                                    else $maxrow" />
    <xsl:choose>
      <xsl:when
        test="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$itemrefname-column]/text()
                and following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$itemrank-column]/text()">
        <Item>
          <xsl:attribute name="code" select="." />
          <xsl:attribute name="referenceName"
            select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$itemrefname-column]" />
          <xsl:attribute name="rank"
            select="xs:integer(number(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$itemrank-column]))" />
          <Head>
            <xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$head-column]" />
          </Head>
          <Body>
            <xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$body-column]" />
          </Body>
          <BulletList>
            <xsl:apply-templates
              select="following-sibling::node()[number(@Row)&gt;=number(current()/@Row) 
                                                           and number(@Row)&lt;$nextitemcoderow
                                                           and number(@Col)=number($bitext-column) 
                                                           and text() != '']"
              mode="bulletitem" />
          </BulletList>
        </Item>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Cell" mode='bulletitem'>
    <BulletItem>
      <xsl:attribute name="rank"
        select="xs:integer(number(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$birank-column and text() != '']))" />
      <Text>
        <xsl:value-of select="." />
      </Text>
    </BulletItem>
  </xsl:template>


  <!-- new named templates Gifting -->
  <xsl:template name="Locales">
    <xsl:for-each
      select="distinct-values($product-sheet/gmr:Cells/gmr:Cell[@Col=$product-locales-column][@Row &gt; 0][text() != ''])">
      <xsl:variable name="locale" select="." />
      <xsl:call-template name="Products">
        <xsl:with-param name="locale" select="$locale" />
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <!-- -->
  <xsl:template name="Products_Raw">
    <xsl:for-each
      select="distinct-values($product-sheet/gmr:Cells/gmr:Cell[@Col=$product-column][number(@Row) &gt; 0 ] [text() != ''])">
      <xsl:variable name="ctn" select="." />
      <object>
        <xsl:attribute name="object_id" select="$ctn" />
        <RichTexts>
          <xsl:call-template name="RichTexts_Raw">
            <xsl:with-param name="ctn" select="$ctn" />
          </xsl:call-template>
        </RichTexts>
      </object>
    </xsl:for-each>
  </xsl:template>
  <!-- -->
  <xsl:template name="Products">
    <xsl:param name="locale" />
    <!-- products per locale -->
    <xsl:variable name="locale-cells" select="$product-sheet/gmr:Cells/gmr:Cell[@Col=$product-locales-column] [text()=$locale]" />
    <xsl:for-each select="distinct-values($product-sheet/gmr:Cells/gmr:Cell[@Col=$product-column][@Row=$locale-cells/@Row])">
      <xsl:variable name="ctn" select="." />
      <object>
        <xsl:attribute name="object_id" select="$ctn" />
        <xsl:attribute name="locales" select="$locale" />
        <RichTexts>
          <xsl:call-template name="RichTexts">
            <xsl:with-param name="locale" select="$locale" />
            <xsl:with-param name="ctn" select="$ctn" />
          </xsl:call-template>
        </RichTexts>
      </object>
    </xsl:for-each>
  </xsl:template>
  <!-- -->
  <xsl:template name="RichTexts_Raw">
    <xsl:param name="ctn" />
    <xsl:variable name="mproduct-cells" select="$product-sheet/gmr:Cells/gmr:Cell[@Col=$product-column][text()=$ctn]" />
    <xsl:variable name="mtype-cells"
      select="$product-sheet/gmr:Cells/gmr:Cell[@Col=$product-richtexttype-column] [ @Row = $mproduct-cells/@Row ]" />

    <xsl:for-each-group select="$mtype-cells" group-by=".">
      <xsl:variable name="type" select="current-grouping-key()" />
      <xsl:variable name="mitemcode-cells"
        select="$product-sheet/gmr:Cells/gmr:Cell[@Col=$product-itemcode-column][@Row=$mproduct-cells/@Row][@Row=current-group()/@Row]" />
      <xsl:variable name="type-cells" select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$richtexttype-column] [text()=$type]" />
      <xsl:variable name="itemcode-cells"
        select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$itemcode-column] [@Row=$type-cells/@Row] [ text()= $mitemcode-cells/text() ]" />
      <xsl:call-template name="Chapters">
       <xsl:with-param name="richtext-type" select="$type" />
        <xsl:with-param name="itemcode-cells" select="$itemcode-cells" />
      </xsl:call-template>
    </xsl:for-each-group>
  </xsl:template>
  <!-- -->
  <xsl:template name="RichTexts">
    <xsl:param name="locale" />
    <xsl:param name="ctn" />
    <xsl:variable name="mlocale-cells" select="$product-sheet/gmr:Cells/gmr:Cell[@Col=$product-locales-column][text()=$locale]" />
    <xsl:variable name="mproduct-cells"
      select="$product-sheet/gmr:Cells/gmr:Cell[@Col=$product-column][text()=$ctn][@Row=$mlocale-cells/@Row]" />
    <xsl:variable name="mtype-cells"
      select="$product-sheet/gmr:Cells/gmr:Cell[@Col=$product-richtexttype-column][@Row=$mproduct-cells/@Row] " />

    <xsl:variable name="product-itemcode-cells"
      select="$product-sheet/gmr:Cells/gmr:Cell[@Col=$product-itemcode-column] [@Row=$mproduct-cells/@Row]" />
    <xsl:variable name="locale-cells" select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$locales-column][text()=$locale]" />
    <xsl:variable name="itemcode-cells"
      select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$itemcode-column] [@Row=$locale-cells/@Row] [ text()= $product-itemcode-cells/text() ]" />

    <xsl:for-each-group select="$mtype-cells" group-by=".">
      <xsl:variable name="type" select="current-grouping-key()" />
      <xsl:variable name="mitemcode-cells"
        select="$product-sheet/gmr:Cells/gmr:Cell[@Col=$product-itemcode-column][@Row=$mproduct-cells/@Row][@Row=current-group()/@Row]" />
      <xsl:variable name="locale-cells" select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$locales-column][text()=$locale]" />
      <xsl:variable name="type-cells" select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$richtexttype-column] [text()=$type]" />
      <xsl:variable name="itemcode-cells"
        select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$itemcode-column] [@Row=$type-cells/@Row][@Row=$locale-cells/@Row] [ text()= $mitemcode-cells/text() ]" />
      <xsl:call-template name="Chapters">
        <xsl:with-param name="richtext-type" select="$type" />
        <xsl:with-param name="itemcode-cells" select="$itemcode-cells" />
      </xsl:call-template>
    </xsl:for-each-group>
  </xsl:template>
  <!-- -->
  <xsl:template name="Chapters">
    <xsl:param name="richtext-type" />
    <xsl:param name="itemcode-cells" />
    <xsl:variable name="chapter-cells"
      select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$chaptercode-column][@Row = $itemcode-cells/@Row]" />
    <xsl:for-each-group select="$chapter-cells" group-by=".">
      <RichText>
        <xsl:attribute name="type" select="$richtext-type" />
        <xsl:variable name="chapter" select="current-grouping-key()" />
        <xsl:variable name="chapter-name" select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$chapterrefname-column][@Row=current()/@Row]"/>
        <Chapter>
          <xsl:attribute name="code" select="$chapter" />
          <xsl:attribute name="referenceName" select="$chapter-name" />
          <xsl:attribute name="rank"
            select="xs:integer(number($main-sheet/gmr:Cells/gmr:Cell[@Col=$chapterrank-column][@Row=current()/@Row]))" />
          <Name>
            <xsl:value-of select="$chapter-name"/>
          </Name>
        </Chapter>
        <xsl:call-template name="items">
          <xsl:with-param name="chapter-cells" select="current-group()" />
        </xsl:call-template>
      </RichText>
    </xsl:for-each-group>
  </xsl:template>
  <!-- -->
  <xsl:template name="items">
    <xsl:param name="chapter-cells" />
    <xsl:variable name="item-cells" select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$itemcode-column] [@Row=$chapter-cells/@Row]" />
    <xsl:for-each select="$item-cells">
      <xsl:variable name="item" select="." />
      <xsl:variable name="nextitemcoderow"
        select="if (following-sibling::node()[number(@Col)=$itemcode-column and text() != ''])
											then number(following-sibling::node()[number(@Col)=$itemcode-column and text() != ''][1]/@Row)
											else $maxrow" />
      <xsl:variable name="item-rank-string" select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$itemrank-column][@Row=$item/@Row]"/>
      <Item>
        <xsl:attribute name="code" select="$item" />
        <xsl:attribute name="referenceName" select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$itemrefname-column][@Row=$item/@Row]" />
        <xsl:attribute name="rank" select="xs:integer(floor(number(normalize-space($item-rank-string))))"/>
        
        <xsl:variable name="item-head" select="normalize-space($main-sheet/gmr:Cells/gmr:Cell[@Col=$head-column][@Row=$item/@Row])" />
        <xsl:if test="$item-head != ''">
          <Head>
            <xsl:value-of select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$head-column][@Row=$item/@Row]" />
          </Head>
        </xsl:if>

        <xsl:variable name="item-body" select="normalize-space($main-sheet/gmr:Cells/gmr:Cell[@Col=$body-column][@Row=$item/@Row])" />
        <xsl:if test="$item-body != ''">
          <Body>
            <xsl:value-of select="$main-sheet/gmr:Cells/gmr:Cell[@Col=$body-column][@Row=$item/@Row]" />
          </Body>
        </xsl:if>
        
        <xsl:variable name="bullet-items" select="following-sibling::node()[number(@Row)&gt;=number(current()/@Row) 
                                                           and number(@Row)&lt;$nextitemcoderow
                                                           and number(@Col)=number($bitext-column) 
                                                           and text() != '']"/>
        <xsl:if test="count($bullet-items) &gt; 0">
          <BulletList>
            <xsl:apply-templates
              select="$bullet-items"
              mode="bulletitem" />
          </BulletList>
        </xsl:if>
      </Item>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>