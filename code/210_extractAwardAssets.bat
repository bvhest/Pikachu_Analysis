REM ##!/bin/bash
REM #
REM # extract Philips Award-assets from the Pikachu feeds.
REM #
REM # BvH, 2018-11-20
REM #

REM # product blue tree to category-nodes, including category links :
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuExports/WebcollageProducts/WebcollageProducts_ProductExport_20181022T0746_NL_master.xml -xsl:210_extractAwardAssets.xsl -o:../data/csv/awardAssets_NL_global.csv
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuExports/WebcollageProducts/WebcollageProducts_ProductExport_20181022T0746_nl_NL.xml -xsl:210_extractAwardAssets.xsl -o:../data/csv/awardAssets_nl_NL.csv
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuExports/WebcollageProducts/WebcollageProducts_ProductExport_20181022T0746_CN_master.xml -xsl:210_extractAwardAssets.xsl -o:../data/csv/awardAssets_CN_global.csv
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuExports/WebcollageProducts/WebcollageProducts_ProductExport_20181022T0746_zh_CN.xml -xsl:210_extractAwardAssets.xsl -o:../data/csv/awardAssets_zh_CN.csv
