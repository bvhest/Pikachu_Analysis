REM ##!/bin/bash
REM #
REM # Extract asset meta-data from STEP Advanced XML-export.
REM # 
REM # template:
REM # <?xml version='1.0'?>
REM # <STEP-ProductInformation ResolveInlineRefs="true">
REM # <UserTypes ExportSize="All"/>
REM # <CrossReferenceTypes ExportSize="All"/>
REM # </STEP-ProductInformation> 
REM #
REM # BvH, 2019-29-05
REM #
@echo off

set src="%~1/data/STEP/assets/%~2/STEP_asset_definition_export_20190612.xml"
set trg1="%~1/data/csv/%~2/STEP_assets_metadata.csv"
set trg2="%~1/data/csv/%~2/STEP_asset_specs_metadata.csv"

set xslt1="%~1/code/610_STEP_asset_xml2csv.xsl"
set xslt2="%~1/code/610_STEP_asset_specs_xml2csv.xsl"

java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:%src% -xsl:%xslt1% -o:%trg1%
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:%src% -xsl:%xslt2% -o:%trg2%

REM # asset & asset-reference meta-data :
REM java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/STEP/assets/dev/STEP_asset_definitions_20190612.xml -xsl:620_STEP_asset_xml2csv.xsl -o:../data/csv/dev/620_STEP_assets_metadata.csv
REM java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/STEP/assets/dev/STEP_asset_definitions_20190612.xml -xsl:620_STEP_asset_specs_xml2csv.xsl -o:../data/csv/dev/620_STEP_asset_specs_metadata.csv

REM java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/STEP/assets/tst/STEP_asset_definitions_20190612.xml -xsl:620_STEP_asset_xml2csv.xsl -o:../data/csv/tst/620_STEP_assets_metadata.csv
REM java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/STEP/assets/tst/STEP_asset_definitions_20190612.xml -xsl:620_STEP_asset_specs_xml2csv.xsl -o:../data/csv/tst/620_STEP_asset_specs_metadata.csv
