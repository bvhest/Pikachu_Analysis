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
  <xsl:variable name="main-sheet"          select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[starts-with(upper-case(gmr:Name),'KEYVALUEPAIRS')]"/>
  <!-- The spreadsheet columns -->
  <xsl:variable name="ctn-column"                 select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='CTN']/@Col"/>
  <xsl:variable name="key-column"                 select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='KEY']/@Col"/>  
  <xsl:variable name="value-column"               select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='VALUE']/@Col"/>
  <xsl:variable name="type-column"                select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='TYPE']/@Col"/>  
  <xsl:variable name="unitofmeasure-column"       select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='UNITOFMEASURE']/@Col"/>    
  <xsl:variable name="action-column"              select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='ACTION']/@Col"/>
  <xsl:variable name="startrow"                   select="number($main-sheet/gmr:Cells/gmr:Cell[@Col=$ctn-column][text() != ''][@Row&gt;2][1]/@Row)"/>
  <xsl:variable name="maxrow"                     select="number($main-sheet/gmr:MaxRow) + 1"/>

  <xsl:function name="my:format" as="xs:string">
    <xsl:param name="in"/>
    <xsl:value-of select="if(number($in) = number($in)) then number($in) else $in"/>
  </xsl:function>

  <xsl:function name="my:stripspace" as="xs:string">
    <xsl:param name="in"/>
    <xsl:value-of select="replace($in,' ','')"/>
  </xsl:function>  
  
  <xsl:template match="node()|@*">
    <xsl:apply-templates select="node()|@*"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Workbook/gmr:Sheets">
    <xsl:variable name="main-sheet" select="gmr:Sheet[starts-with(upper-case(gmr:Name),'KEYVALUEPAIRS')]"/>
    <xsl:variable name="output">
      <KeyValuePairs info:source-file="{$datafile}">
        <xsl:attribute name="DocTimeStamp" select="$docTimestamp"/>
        <xsl:attribute name="DocStatus" select="'approved'"/>
        <xsl:attribute name="ct" select="'KeyValuePairs'"/>
        <xsl:attribute name="l"  select="'none'"/>
        <!-- Process each KeyValuePair -->
        <xsl:apply-templates mode="ctn" select="$main-sheet/gmr:Cells/gmr:Cell[    number(@Row) ge $startrow 
                                                                               and number(@Col) =  number($ctn-column) 
                                                                               and text() != ''
                                                                               and not(text() = preceding-sibling::node()[number(@Col)=$ctn-column and  number(@Row) ge $startrow ]/text())]"/>
      </KeyValuePairs>
    </xsl:variable>
    <root>
      <!--
         | Write the output variable to a file
         | AND put it in the resulting XML for creating the preview.
       -->
      <source:write>
        <source:source>
          <xsl:value-of select="concat($store-dir,'/','KeyValuePairs_',$current-timestamp,'.xml')"/>
        </source:source>
        <source:fragment>
          <xsl:copy-of select="$output" copy-namespaces="no"/>
        </source:fragment>
      </source:write>
      <xsl:copy-of select="$output" copy-namespaces="no"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Cell" mode='ctn'>
    <xsl:variable name="nextctnrow"   select="if (following-sibling::node()[number(@Col)=$ctn-column and text() != '' and text() != current()/text()])
                                              then number(following-sibling::node()[number(@Col)=$ctn-column and text() != '' and text() != current()/text()][1]/@Row)
                                              else $maxrow"/>
      <object>                                              
        <xsl:attribute name="code" select="my:format(.)"/>
        <xsl:attribute name="object_id" select="my:format(.)"/>
        <xsl:attribute name="IsMaster" select="'true'"/>
        <xsl:attribute name="lastModified" select="$docTimestamp"/>
        <xsl:attribute name="masterLastModified" select="$docTimestamp"/>       
        <!--MarketingVersion/>
        <MarketingStatus>Final Published</MarketingStatus>
        <Owner>Spreadsheet Load</Owner-->
        <xsl:apply-templates mode="keyvaluepairs" select=". | following-sibling::node()[       number(@Row) gt number(current()/@Row)
                                                                                           and number(@Col) =  number($ctn-column) 
                                                                                           and number(@Row) lt number($nextctnrow)
                                                                                           and text() != '']"/>    
      </object>     
  </xsl:template>
  <!-- -->  
  <xsl:template match="gmr:Cell" mode='keyvaluepairs'>
    <xsl:variable name="nextkeyvaluepairsrow" select="if (following-sibling::node()[number(@Col)=$ctn-column and text() != ''])
                                              then number(following-sibling::node()[number(@Col)=$ctn-column and text() != ''][1]/@Row)
                                              else $maxrow"/>
    <xsl:if test="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$action-column] != ''">                                              
    <KeyValuePair>
      <xsl:attribute name="action" select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$action-column])"/>
      <!--CTN><xsl:value-of select="my:format(.)"/></CTN-->    
      <Key><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$key-column])"/></Key>
      <Value><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$value-column])"/></Value>      
      <Type><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$type-column])"/></Type>
      <UnitOfMeasure><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$unitofmeasure-column])"/></UnitOfMeasure>      
    </KeyValuePair>
    </xsl:if>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>