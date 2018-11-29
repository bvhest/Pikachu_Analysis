REM ##!/bin/bash
REM #
REM # extract Philips Award-assets from the Pikachu (Object-)AssetList import.
REM #
REM # BvH, 2018-11-27
REM #

REM java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuImports/ObjectAssetList/Full_pcu_object_asset_201811250300_0001.xml -xsl:230_extractAwardAssetsFromPikachuOALimport.xsl -o:../data/xml/ObjectAssetList.xml

java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuImports/AssetList/P4C_xSPOT_Marketing_Asset_201811261900_0001.xml -xsl:232_extractAwardAssetsFromPikachuALimport.xsl -o:../data/xml/AssetList.xml
