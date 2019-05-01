REM ##!/bin/bash
REM #
REM # extract Philips movie-assets from the Pikachu feeds.
REM #
REM # BvH, 2019-05-01
REM #

REM # product blue tree to category-nodes, including category links :
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuImports/AssetList/P4C_Full_xSPOT_Marketing_Asset_201904260400_0987.xml -xsl:542_extractMovieAssetsFromPikachuALimport.xsl -o:../data/csv/AL_MoviesList.csv
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuImports/ObjectAssetList/Full_pcu_object_asset_201811250300_0001.xml -xsl:544_extractMovieAssetsFromPikachuOALimport.xsl -o:../data/csv/OAL_MoviesList.csv
