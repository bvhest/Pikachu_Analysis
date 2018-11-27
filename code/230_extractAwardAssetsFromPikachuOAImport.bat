REM ##!/bin/bash
REM #
REM # extract Philips Award-assets from the Pikachu (Object-)AssetList import.
REM #
REM # BvH, 2018-11-27
REM #

REM # product blue tree to category-nodes, including category links :
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuImports/ObjectAssetList/Full_pcu_object_asset_201811250300_0001.xml -xsl:230_extractAwardAssetsFromPikachuOAImport.xsl -o:../data/csv/ObjectAssetList.xml
