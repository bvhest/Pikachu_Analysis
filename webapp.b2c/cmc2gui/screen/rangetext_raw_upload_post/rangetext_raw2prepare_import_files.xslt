<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Convert an Excel input file read by the HSSFGenerator
  to RichText_Raw xml content
  
  See example input file at the bottom of this stylesheet.
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:source="http://apache.org/cocoon/source/1.0"
                xmlns:gmr="http://www.gnome.org/gnumeric/v7"
                xmlns:info="http://www.philips.com/pikachu/3.0/info"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:my="http://www.philips.com/pika"
                extension-element-prefixes="my"
                >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <!-- file name of the uploaded file -->
  <xsl:param name="datafile"/>
  <xsl:param name="division" select="'CE'"/>
  <xsl:param name="store-dir"/>  
  <xsl:variable name="current-datetime"    select="replace(string(current-dateTime()),'.*(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}).*','$1')"/>
  <xsl:variable name="current-timestamp"   select="replace($current-datetime,'[^0-9]','')"/>
  <xsl:variable name="docTimestamp"        select="$current-datetime"/>
  <xsl:variable name="main-sheet"          select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[upper-case(replace(gmr:Name,' ',''))='RANGETEXT']"/>
  <xsl:variable name="rangeid-column"      select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGEID']/@Col"/>    
  <xsl:variable name="rangecode-column"    select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGECODE']/@Col"/>  
  <xsl:variable name="rangename-column"    select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGENAME']/@Col"/>
  <xsl:variable name="rangerefname-column"    select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGEREFERENCENAME']/@Col"/> 
  <xsl:variable name="rangetype-column"    select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGETYPE']/@Col"/>                
  <xsl:variable name="rangerouting-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGEROUTINGCODE']/@Col"/>                
  <xsl:variable name="rangewow-column"     select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGEWOW']/@Col"/>              
  <xsl:variable name="rangesubwow-column"      select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGESUBWOW']/@Col"/>              
  <xsl:variable name="rangemktgtexthdr-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGEMARKETINGTEXTHEADER']/@Col"/>            
  <xsl:variable name="richtexttype-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RICHTEXTTYPE']/@Col"/>          
  <xsl:variable name="itemcode-column"     select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='ITEMCODE']/@Col"/>                              
  <xsl:variable name="itemrefname-column"  select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='ITEMREFERENCENAME']/@Col"/>                    
  <xsl:variable name="itemrank-column"     select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='ITEMRANK']/@Col"/>                    
  <xsl:variable name="head-column"         select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='ITEMHEAD']/@Col"/>                    
  <xsl:variable name="body-column"         select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='ITEMBODY']/@Col"/>                              
  <xsl:variable name="bitext-column"       select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='BULLETITEMTEXT']/@Col"/>                              
  <xsl:variable name="birank-column"       select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='BULLETITEMRANK']/@Col"/>
  <xsl:variable name="basefs-column"       select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='BASEFEATURE/SPECCODE']/@Col"/>                              
  <xsl:variable name="stepupfs-column"     select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='STEP-UPFEATURE/SPECCODE']/@Col"/>      
  <xsl:variable name="maxrow"              select="number($main-sheet/gmr:MaxRow) + 1"/>
  <xsl:variable name="ctn-column"          select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(.)='CTN']/@Col"/>  
  
  <xsl:function name="my:format" as="xs:string">
    <xsl:param name="in"/>
    <xsl:value-of select="if(number($in) = number($in)) then number($in) else $in"/>
  </xsl:function>
  
  <xsl:template match="node()|@*">
    <xsl:apply-templates select="node()|@*"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Workbook/gmr:Sheets">
    <xsl:variable name="main-sheet" select="gmr:Sheet[upper-case(replace(gmr:Name,' ',''))='RANGETEXT']"/>
    <xsl:variable name="output">
      <RangeText_Raw info:source-file="{$datafile}">
        <xsl:attribute name="DocTimeStamp" select="$docTimestamp"/>
        <Nodes>
          <xsl:attribute name="DocTimeStamp" select="$docTimestamp"/>            
          <xsl:attribute name="DocStatus" select="'approved'"/>           
          <!-- Process each Range -->
          <xsl:apply-templates mode="rangecode" select="$main-sheet/gmr:Cells/gmr:Cell[number(@Row) &gt; 0 and number(@Col)=number($rangecode-column) and text() != '']"/>      
        </Nodes>
      </RangeText_Raw>
    </xsl:variable>
    <root>
      <!--
         | Write the output variable to a file
         | AND put it in the resulting XML for creating the preview.
       -->
      <source:write>
        <source:source>
          <xsl:value-of select="concat($store-dir,'/','RangeText_Raw_',$current-timestamp,'.xml')"/>
        </source:source>
        <source:fragment>
          <xsl:copy-of select="$output" copy-namespaces="no"/>
        </source:fragment>
      </source:write>
      <xsl:copy-of select="$output" copy-namespaces="no"/>
    </root>
  </xsl:template>
  
  <xsl:template match="gmr:Cell" mode='rangecode'>
    <xsl:variable name="nextrangecoderow" select="if (following-sibling::node()[number(@Col)=$rangecode-column and text() != ''])
                                              then number(following-sibling::node()[number(@Col)=$rangecode-column and text() != ''][1]/@Row)
                                              else $maxrow"/>                                                
    <Node>
      <xsl:attribute name="nodeType" select="lower-case(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$rangetype-column])"/>    
      <xsl:attribute name="code" select="upper-case(.)"/>      
      <xsl:attribute name="referenceName" select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$rangerefname-column]"/>
      <xsl:attribute name="routingCode"   select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$rangerouting-column]"/>      
      <xsl:attribute name="IsMaster" select="'true'"/>      
      <xsl:attribute name="lastModified" select="$docTimestamp"/>            
      <xsl:attribute name="masterLastModified" select="$docTimestamp"/>                  
      <MarketingVersion/>
      <MarketingStatus>Final Published</MarketingStatus>
      <Owner>Spreadsheet Load</Owner>
      <xsl:variable name="v_name" select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$rangename-column]"/>
      <Name><xsl:value-of select="my:format($v_name)"/></Name>
      <WOW><xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$rangewow-column]"/></WOW>
      <SubWOW><xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$rangesubwow-column]"/></SubWOW>
      <MarketingTextHeader><xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$rangemktgtexthdr-column]"/></MarketingTextHeader>
      <Filters>
        <Purpose>
          <xsl:attribute name="type" select="'Base'"/>
            <Features>
              <xsl:apply-templates select="following-sibling::node()[    number(@Row)&gt;=number(current()/@Row) 
                                                                     and number(@Row)&lt;$nextrangecoderow
                                                                     and number(@Col)=number($basefs-column) and text() != '' and string-length(text()) &lt;= 15]" mode="basefeature"/>
            </Features>                                                               
            <CSItems>
              <xsl:apply-templates select="following-sibling::node()[    number(@Row)&gt;=number(current()/@Row) 
                                                                     and number(@Row)&lt;$nextrangecoderow
                                                                     and number(@Col)=number($basefs-column) and text() != '' and string-length(text()) &lt;= 15]" mode="basecsi"/>
            </CSItems>                                                                           
        </Purpose>                                                             
        <Purpose>
          <xsl:attribute name="type" select="'Differentiating'"/>
            <Features>
              <xsl:apply-templates select="following-sibling::node()[    number(@Row)&gt;=number(current()/@Row) 
                                                                     and number(@Row)&lt;$nextrangecoderow
                                                                     and number(@Col)=number($stepupfs-column) and text() != '' and string-length(text()) &lt;= 15]" mode="stepupfeature"/>
            </Features>                                                               
            <CSItems>
              <xsl:apply-templates select="following-sibling::node()[    number(@Row)&gt;=number(current()/@Row) 
                                                                     and number(@Row)&lt;$nextrangecoderow
                                                                     and number(@Col)=number($stepupfs-column) and text() != '' and string-length(text()) &lt;= 15]" mode="stepupcsi"/>
            </CSItems>                                                                           
        </Purpose>                                                                     
      </Filters>
      <RichTexts>
        <xsl:apply-templates select="following-sibling::node()[    number(@Row)&gt;=number(current()/@Row) 
                                                               and number(@Row)&lt;$nextrangecoderow
                                                               and number(@Col)=number($richtexttype-column) and text() != '' and string-length(text()) &lt;= 15]" mode="richtexttype"/>
      </RichTexts>                                                
      <ProductRefs>
        <ProductReference @ProductReferenceType="assigned">
          <xsl:apply-templates select="following-sibling::node()[    number(@Row)&gt;=number(current()/@Row) 
                                                                 and number(@Row)&lt;$nextrangecoderow
                                                                 and number(@Col)=number($ctn-column) and text() != '' and string-length(text()) &lt;= 15]" mode="ctn"/>
        </ProductReference>
      </ProductRefs>
    </Node>  
  </xsl:template>  
  <!-- -->
  <xsl:template match="gmr:Cell" mode='richtexttype'>
    <xsl:variable name="nextrichtextrow" select="if (following-sibling::node()[number(@Col)=$richtexttype-column and text() != ''])
                                                    then number(following-sibling::node()[number(@Col)=$richtexttype-column and text() != ''][1]/@Row)
                                                    else $maxrow"/>                                                    
    <RichText>
      <xsl:attribute name="type" select="."/>
      <xsl:apply-templates select="following-sibling::node()[    number(@Row)&gt;=number(current()/@Row) 
                                                             and number(@Row)&lt;$nextrichtextrow
                                                             and number(@Col)=number($itemcode-column) 
                                                             and text() != '']" mode="itemcode"/>
    </RichText>
  </xsl:template>  
  <!-- -->
  <xsl:template match="gmr:Cell" mode='itemcode'>
    <xsl:variable name="nextitemcoderow" select="if (following-sibling::node()[number(@Col)=$itemcode-column and text() != ''])
                                                    then number(following-sibling::node()[number(@Col)=$itemcode-column and text() != ''][1]/@Row)
                                                    else $maxrow"/>
    <xsl:choose>
      <xsl:when test="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$itemrefname-column]/text()
                  and following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$itemrank-column]/text()">
        <Item>
          <xsl:attribute name="code" select="."/>
          <xsl:attribute name="referenceName" select="my:format(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$itemrefname-column])"/>
          <xsl:attribute name="rank" select="xs:integer(number(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$itemrank-column]))"/>
          <Head><xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$head-column]"/></Head>
          <Body><xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$body-column]"/></Body>
          <BulletList>
            <xsl:apply-templates select="following-sibling::node()[    number(@Row)&gt;=number(current()/@Row) 
                                                                   and number(@Row)&lt;$nextitemcoderow
                                                                   and number(@Col)=number($bitext-column) 
                                                                   and text() != '']" mode="bulletitem"/>
          </BulletList>
        </Item>  
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Cell" mode='bulletitem'>
    <BulletItem>
      <xsl:attribute name="rank" select="xs:integer(number(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$birank-column and text() != '']))"/>
      <Text><xsl:value-of select="."/></Text>
    </BulletItem>  
  </xsl:template>
  <!-- -->  
  <xsl:template match="gmr:Cell" mode='basefeature'>
    <xsl:choose>
      <xsl:when test="starts-with(.,'F__')">
        <Feature>
          <xsl:attribute name="code" select="substring-after(.,'F__')"/>
          <xsl:attribute name="rank" select="position()"/>
        </Feature>  
      </xsl:when>
    </xsl:choose>     
  </xsl:template>  
  <!-- -->
  <xsl:template match="gmr:Cell" mode='basecsi'>
    <xsl:choose>
      <xsl:when test="starts-with(.,'S__')">
        <CSItem>
          <xsl:attribute name="code" select="substring-after(.,'S__')"/>
          <xsl:attribute name="rank" select="position()"/>
        </CSItem>  
      </xsl:when>
    </xsl:choose>    
  </xsl:template>      
  <!-- -->
  <xsl:template match="gmr:Cell" mode='stepupfeature'>
    <xsl:choose>
      <xsl:when test="starts-with(.,'F__')">
        <Feature>
          <xsl:attribute name="code" select="substring-after(.,'F__')"/>
          <xsl:attribute name="rank" select="position()"/>
        </Feature>  
      </xsl:when>
    </xsl:choose>     
  </xsl:template>  
  <!-- -->
  <xsl:template match="gmr:Cell" mode='stepupcsi'>
    <xsl:choose>
      <xsl:when test="starts-with(.,'S__')">
        <CSItem>
          <xsl:attribute name="code" select="substring-after(.,'S__')"/>
          <xsl:attribute name="rank" select="position()"/>
        </CSItem>  
      </xsl:when>
    </xsl:choose>    
  </xsl:template>          
  <!-- -->
  <xsl:template match="gmr:Cell" mode='ctn'>
    <CTN rank="{position()}">
      <xsl:value-of select="." />
    </CTN>
  </xsl:template>  
</xsl:stylesheet>