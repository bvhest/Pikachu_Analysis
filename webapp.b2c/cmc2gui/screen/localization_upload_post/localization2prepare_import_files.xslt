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
  <xsl:variable name="main-sheet"          select="/gmr:Workbook/gmr:Sheets/gmr:Sheet[starts-with(upper-case(gmr:Name),'LOCALIZ')]"/>

  <!-- No.	MasterString	LocalizedString 	Country	Subcategory	CTN Mask	ProductXPath	RangeXPath	Column name -->


  <xsl:variable name="localizationid-column"      select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='NO.']/@Col"/>
  <xsl:variable name="name-column"                select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='NAME']/@Col"/>
  <xsl:variable name="active-column"              select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='ACTIVE']/@Col"/>
  <xsl:variable name="action-column"              select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='ACTION']/@Col"/>  
  <xsl:variable name="productnode2remove-column"  select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='PRODUCTNODETOREMOVE']/@Col"/>
  <xsl:variable name="productnode2replace-column" select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='PRODUCTNODETOREPLACE']/@Col"/>  
  <xsl:variable name="rangenode2remove-column"    select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGENODETOREMOVE']/@Col"/>    
  <xsl:variable name="rangenode2replace-column"   select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='RANGENODETOREPLACE']/@Col"/>
  <xsl:variable name="masterstring-column"        select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='MASTERSTRING']/@Col"/>
  <xsl:variable name="localizedstring-column"     select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='LOCALIZEDSTRING']/@Col"/>
  <xsl:variable name="country-column"             select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='COUNTRY']/@Col"/>
  <xsl:variable name="subcategory-column"         select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='SUBCATEGORY']/@Col"/>
  <xsl:variable name="ctnmask-column"             select="$main-sheet/gmr:Cells/gmr:Cell[@Row='0' and upper-case(replace(.,' ',''))='CTNMASK']/@Col"/>
  <xsl:variable name="startrow"                   select="number($main-sheet/gmr:Cells/gmr:Cell[@Col=$localizationid-column][text() != ''][@Row&gt;3][1]/@Row)"/>
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
    <xsl:variable name="main-sheet" select="gmr:Sheet[starts-with(upper-case(gmr:Name),'LOCALIZ')]"/>
    <xsl:variable name="output">
      <Localizations info:source-file="{$datafile}">
        <xsl:attribute name="DocTimeStamp" select="$docTimestamp"/>
        <xsl:attribute name="DocStatus" select="'approved'"/>
        <xsl:attribute name="ct" select="'Localization'"/>
        <xsl:attribute name="l"  select="'none'"/>
        <!-- Process each Localization -->
        <xsl:apply-templates mode="localization" select="$main-sheet/gmr:Cells/gmr:Cell[number(@Row) ge $startrow and number(@Col)=number($localizationid-column) and text() != '']
                                                                                       [following-sibling::node()[number(@Col)=$action-column] != '']"/>
      </Localizations>
    </xsl:variable>
    <root>
      <!--
         | Write the output variable to a file
         | AND put it in the resulting XML for creating the preview.
       -->
      <source:write>
        <source:source>
          <xsl:value-of select="concat($store-dir,'/','Localization_',$current-timestamp,'.xml')"/>
        </source:source>
        <source:fragment>
          <xsl:copy-of select="$output" copy-namespaces="no"/>
        </source:fragment>
      </source:write>
      <xsl:copy-of select="$output" copy-namespaces="no"/>
    </root>
  </xsl:template>

  <xsl:template match="gmr:Cell" mode='localization'>
    <xsl:variable name="nextlocalizationrow" select="if (following-sibling::node()[number(@Col)=$localizationid-column and text() != ''])
                                              then number(following-sibling::node()[number(@Col)=$localizationid-column and text() != ''][1]/@Row)
                                              else $maxrow"/>
    <Localization>
      <xsl:attribute name="code" select="my:format(.)"/>
      <xsl:attribute name="object_id" select="my:format(.)"/>
      <xsl:attribute name="IsMaster" select="'true'"/>
      <xsl:attribute name="lastModified" select="$docTimestamp"/>
      <xsl:attribute name="masterLastModified" select="$docTimestamp"/>
      <MarketingVersion/>
      <MarketingStatus>Final Published</MarketingStatus>
      <Owner>Spreadsheet Load</Owner>
      <Name><xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$name-column]"/></Name>      
      <Active><xsl:value-of select="my:stripspace(upper-case(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$active-column]))"/></Active>
      <Action><xsl:value-of select="my:stripspace(upper-case(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$action-column]))"/></Action>      
      <ProductNode2Remove><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$productnode2remove-column])"/></ProductNode2Remove>
      <ProductNode2Replace><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$productnode2replace-column])"/></ProductNode2Replace>      
      <RangeNode2Remove><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$rangenode2remove-column])"/></RangeNode2Remove>                  
      <RangeNode2Replace><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$rangenode2replace-column])"/></RangeNode2Replace>      
      <MasterString><xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$masterstring-column]"/></MasterString>
      <LocalizedString><xsl:value-of select="following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$localizedstring-column]"/></LocalizedString>
      <Country><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$country-column])"/></Country>
      <SubCategory><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$subcategory-column])"/></SubCategory>
      <CTNMask><xsl:value-of select="my:stripspace(following-sibling::node()[number(@Row)=number(current()/@Row) and number(@Col)=$ctnmask-column])"/></CTNMask>
    </Localization>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>