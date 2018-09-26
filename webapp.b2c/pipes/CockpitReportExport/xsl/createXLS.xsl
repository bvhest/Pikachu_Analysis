<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
exclude-result-prefixes="sql">

 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <LastAuthor>x</LastAuthor>
  <Created>2009-04-06T12:35:58Z</Created>
  <LastSaved>2009-04-06T12:35:45Z</LastSaved>
  <Version>11.5606</Version>
 </DocumentProperties>
  
  <xsl:template match="/">
    <xsl:apply-templates select="Workbook"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="Workbook">
  <Workbook>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>9150</WindowHeight>
  <WindowWidth>14940</WindowWidth>
  <WindowTopX>360</WindowTopX>
  <WindowTopY>270</WindowTopY>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s21" ss:Name="Hyperlink">
   <Font ss:Color="#0000FF" ss:Underline="Single"/>
  </Style>
 
  <Style ss:ID="s22">
   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
   <Borders>
		<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
		<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
		<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
   </Borders>
   <Font ss:FontName="Sans" ss:Size="9" ss:Color="#0000FF" ss:Bold="1"/>
   <Protection/>
  </Style>
  
 <Style ss:ID="s24">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Sans" ss:Size="9" ss:Color="#0000FF" ss:Bold="1"/>
   <Protection/>
  </Style>  
  <Style ss:ID="s24-R">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
    <Borders>
		<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
    </Borders>
   <Font ss:FontName="Sans" ss:Size="9" ss:Color="#0000FF" ss:Bold="1"/>
   <Protection/>
  </Style>
  
  <Style ss:ID="s25">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>
   <Font ss:FontName="Sans" ss:Size="9" ss:Color="#000000"/>
   <Protection/>
  </Style>
  <Style ss:ID="s25-R">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>
   <Borders>
		<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
    </Borders>
   <Font ss:FontName="Sans" ss:Size="9" ss:Color="#000000"/>
   <Protection/>
  </Style>
  <Style ss:ID="s29">
   <Alignment ss:Vertical="Top"/>
   <Borders/>
   <Font ss:FontName="Sans" ss:Size="9" ss:Color="#0000FF" ss:Bold="1"/>
   <Protection/>
  </Style>
 </Styles>
 <Worksheet ss:Name="{concat(country,'-',customer_id)}">
 <xsl:variable name="apos">'</xsl:variable>
 		<Names>
			<NamedRange ss:Name="_FilterDatabase" ss:RefersTo="{concat('=',$apos,country,'-',customer_id,$apos,'!R2C1:R2C21' )}" ss:Hidden="1"/>
		</Names>


  <Table ss:ExpandedColumnCount="256" ss:ExpandedRowCount="{count(ROW)+10}" x:FullColumns="1"
   x:FullRows="1">
   <Column ss:AutoFitWidth="0" ss:Width="69.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="36.75" ss:Span="1"/>
   <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="45"/>
   <Column ss:AutoFitWidth="0" ss:Width="52.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="52.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="66"/>
   <Column ss:AutoFitWidth="0" ss:Width="48.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="38.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="39"/>
   <Column ss:AutoFitWidth="0" ss:Width="42" ss:Span="1"/>
   <Column ss:Index="13" ss:AutoFitWidth="0" ss:Width="36.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="38.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="34.5"/>
   <Column ss:AutoFitWidth="0" ss:Width="39"/>
   <Column ss:AutoFitWidth="0" ss:Width="69"/>
   <Column ss:AutoFitWidth="0" ss:Width="71.25"/>
   <Column ss:AutoFitWidth="0" ss:Width="72.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="90.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="66" ss:Span="1"/>
   <Column ss:Index="23" ss:AutoFitWidth="0" ss:Width="72" ss:Span="233"/>
			
   <Row ss:Height="20">
    <Cell ss:MergeAcross="1" ss:StyleID="s22"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:MergeAcross="3" ss:StyleID="s22"><Data ss:Type="String">ORGANISATION</Data></Cell>
	<Cell ss:MergeAcross="7" ss:StyleID="s22"><Data ss:Type="String">PRODUCT CONTENT</Data></Cell>    
	<Cell ss:MergeAcross="7" ss:StyleID="s22"><Data ss:Type="String">STATUS</Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">SUBCAT</Data></Cell>
    <Cell ss:MergeAcross="2" ss:StyleID="s22"><Data ss:Type="String">MORE INFO</Data></Cell>
   </Row>
   <Row ss:Height="38">
    <Cell ss:StyleID="s24"><Data ss:Type="String">CTN</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24-R"><Data ss:Type="String">Locale</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">BU</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">BG</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">MAG</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24-R"><Data ss:Type="String">AG</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Marketing Classification</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Compliant</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Product Photos</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Product 360</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Product Videos</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Feature Glossary</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Feature Images</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24-R"><Data ss:Type="String">Feature Videos</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Live Y/N</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Master Status</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Active Inactive</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Translation status</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Localized</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">SOP</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">EOP</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24-R"><Data ss:Type="String">Last Modified</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24-R"><Data ss:Type="String">Subcat</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">FYPLink</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String">Consumer Site</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s24-R"><Data ss:Type="String">Leaflet</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>
   

   </Row>
   <xsl:apply-templates select="ROW"/>
  </Table>
 <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Print>
    <ValidPrinterInfo/>
    <HorizontalResolution>300</HorizontalResolution>
    <VerticalResolution>300</VerticalResolution>
   </Print>
   <Selected/>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>2</SplitHorizontal>
   <TopRowBottomPane>2</TopRowBottomPane>
   <SplitVertical>2</SplitVertical>
   <LeftColumnRightPane>2</LeftColumnRightPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>1</Number>
     <ActiveCol>0</ActiveCol>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveCol>2</ActiveCol>
    </Pane>
    <Pane>
     <Number>0</Number>
     <ActiveCol>0</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
    <AutoFilter x:Range="R2C1:R2C23"
   xmlns="urn:schemas-microsoft-com:office:excel">
  </AutoFilter>
 </Worksheet>
</Workbook>
  </xsl:template>

   
   <xsl:template match="ROW">
   <xsl:variable name="ProductTypeLevel" as="xs:number">
	   <xsl:choose>
			<xsl:when test="ProductType='MCI'">4</xsl:when>
			<xsl:when test="ProductType='Key'">3</xsl:when>
			<xsl:when test="ProductType='Normal'">2</xsl:when>
			<xsl:when test="ProductType='CRP'">1</xsl:when>
			<xsl:otherwise>2</xsl:otherwise>
		</xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="ActualLevel" as="xs:number">
		<xsl:choose>
			<xsl:when test="Product-Enhancement-Content='3-MCI'">4</xsl:when>
			<xsl:when test="Product-Enhancement-Content='2-Key product'">3</xsl:when>
			<xsl:when test="Product-Enhancement-Content='1-Other product'">2</xsl:when>
			<xsl:when test="Product-Enhancement-Content='0-Accessory' ">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
    </xsl:variable>
    <xsl:variable name="Compliant" select="if ($ActualLevel &lt; $ProductTypeLevel) then 'N' else 'Y' "/>
   <Row>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="Commercial-ID"/></Data></Cell>
    <Cell ss:StyleID="s25-R"><Data ss:Type="String"><xsl:value-of select="Locale"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="BU"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="BG"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="MAG"/></Data></Cell>
    <Cell ss:StyleID="s25-R"><Data ss:Type="String"><xsl:value-of select="AG"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="ProductType"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="$Compliant"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="Number"><xsl:value-of select="Product-Images"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="Number"><xsl:value-of select="Product-360"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="Number"><xsl:value-of select="Product-Videos"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="Number"><xsl:value-of select="Feature-Glossary"/></Data></Cell>
     <Cell ss:StyleID="s25"><Data ss:Type="Number"><xsl:value-of select="Feature-Images"/></Data></Cell>
    <Cell ss:StyleID="s25-R"><Data ss:Type="Number"><xsl:value-of select="Feature-Videos"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="if (Mrkt-Rel.='Y' and Active-Inactive = 'active' and starts-with(Localized-content,'Approved') ) then 'yes' else 'no' "/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="Mrkt-Rel."/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="Active-Inactive"/></Data></Cell>
    
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="Localized-content"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="Localized"/></Data></Cell>
	<Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="SOP"/></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:value-of select="EOP"/></Data></Cell>
    <Cell ss:StyleID="s25-R"><Data ss:Type="String"><xsl:value-of select="Lastmodified"/></Data></Cell>
    <Cell ss:StyleID="s25-R"><Data ss:Type="String"> <xsl:value-of select="Range"/></Data></Cell>
    <Cell ss:StyleID="s21"  ss:HRef="{FYPLink}" ><Data ss:Type="String"><xsl:value-of select="FYPLink"/></Data></Cell>
    <xsl:variable name="cslink" select="if (Mrkt-Rel.='Y' and Active-Inactive = 'active' and starts-with(Localized-content,'Approved') ) then CSLink else '' "/>
	<Cell ss:StyleID="s21" ss:HRef="{$cslink}"><Data ss:Type="String"><xsl:value-of select="$cslink"/></Data></Cell>   
	<Cell ss:StyleID="s21" ss:HRef="{LeafletLink}"><Data ss:Type="String"><xsl:value-of select="LeafletLink"/></Data></Cell>   
     </Row>
   </xsl:template>
</xsl:stylesheet>
