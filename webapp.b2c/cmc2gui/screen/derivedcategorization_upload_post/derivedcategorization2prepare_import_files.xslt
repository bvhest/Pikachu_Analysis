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
  <xsl:variable name="main-sheet"          select="gmr:Workbook/gmr:Sheets/gmr:Sheet[contains(upper-case(gmr:Name),'MAPPING')]"/>
  <xsl:variable name="ctg-column"          select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and contains(upper-case(replace(.,' ','')),'MAPPINGSFORCHANNEL')]/@Col +1"/>
  <xsl:variable name="dest-column"         select="$main-sheet/gmr:Cells/gmr:Cell[@Row='1' and starts-with(upper-case(replace(.,' ','')),'DESTINATION')]/@Col"/>
  <xsl:variable name="sourcetree-column"   select="$main-sheet/gmr:Cells/gmr:Cell[@Row='1' and starts-with(upper-case(replace(.,' ','')),'SOURCECATTREE')]/@Col"/>  
  <xsl:variable name="source-column"       select="$main-sheet/gmr:Cells/gmr:Cell[@Row='1' and starts-with(upper-case(replace(.,' ','')),'SOURCECODE')]/@Col"/>
  <xsl:variable name="level-column"        select="$main-sheet/gmr:Cells/gmr:Cell[@Row='1' and starts-with(upper-case(replace(.,' ','')),'SOURCELEVEL')]/@Col"/>    
  <xsl:variable name="startrow"            select="number($main-sheet/gmr:Cells/gmr:Cell[@Col=$dest-column][text() != ''][@Row&gt;1][1]/@Row)"/>
  <xsl:variable name="maxrow"              select="number($main-sheet/gmr:MaxRow) + 1"/>
  <!-- -->
  <xsl:function name="my:format" as="xs:string">
    <xsl:param name="in"/>
    <xsl:value-of select="if(number($in) = number($in)) then number($in) else $in"/>
  </xsl:function>
  <!-- -->
  <xsl:function name="my:stripspace" as="xs:string">
    <xsl:param name="in"/>
    <xsl:value-of select="replace($in,' ','')"/>
  </xsl:function>  
  <!-- -->
  <xsl:template match="node()|@*">
    <xsl:apply-templates select="node()|@*"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Workbook/gmr:Sheets">
    <xsl:variable name="main-sheet" select="gmr:Sheet[contains(upper-case(gmr:Name),'MAPPING')][1]"/>
    <xsl:variable name="output">
      <DerivedCategorizations info:source-file="{$datafile}">
        <xsl:attribute name="DocTimeStamp" select="$docTimestamp"/>
        <xsl:attribute name="lastModified" select="$docTimestamp"/>
        <xsl:attribute name="masterLastModified" select="$docTimestamp"/>        
        <xsl:attribute name="DocStatus" select="'approved'"/>
        <xsl:attribute name="ct" select="'DerivedCategorization'"/>
        <xsl:attribute name="l"  select="'none'"/>
        <xsl:attribute name="o"  select="$main-sheet/gmr:Cells/gmr:Cell[number(@Row) = 0 and number(@Col)=number($ctg-column)]"/>
        <!-- Process each DerivedCategorization -->
        <xsl:apply-templates mode="derivedcategorization" select="$main-sheet/gmr:Cells/gmr:Cell[number(@Row) ge $startrow and number(@Col)=number($dest-column) and text() != '']"/>
      </DerivedCategorizations>
    </xsl:variable>
    <root>
      <!--
         | Write the output variable to a file
         | AND put it in the resulting XML for creating the preview.
       -->
      <source:write>
        <source:source>
          <xsl:value-of select="concat($store-dir,'/','DerivedCategorization_step1_',$current-timestamp,'.xml')"/>
        </source:source>
        <source:fragment>
          <xsl:copy-of select="$output" copy-namespaces="no"/>
        </source:fragment>
      </source:write>
      <xsl:copy-of select="$output" copy-namespaces="no"/>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="gmr:Cell" mode='derivedcategorization'>
    <DerivedCategorization>
      <Destination><xsl:value-of select="."/></Destination>      
      <SourceTree><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) 
                                                                                and number(@Col)=$sourcetree-column])"/></SourceTree>
      <Source><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) 
                                                                            and number(@Col)=$source-column])"/></Source>
      <SourceLevel><xsl:value-of select="my:stripspace(xs:string(number(following-sibling::node()[number(@Row)=number(current()/@Row) 
                                                                                                  and number(@Col)=$level-column])))"/></SourceLevel>
    </DerivedCategorization>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>