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

REM # asset & asset-reference meta-data :
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/STEP_assets/STEP_Dev_asset_definitions_20190529.xml -xsl:620_STEP_asset_xml2csv.xsl -o:../data/csv/620_STEP_assets_metadata.csv
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/STEP_assets/STEP_Dev_asset_definitions_20190529.xml -xsl:620_STEP_asset_specs_xml2csv.xsl -o:../data/csv/620_STEP_asset_specs_metadata.csv
