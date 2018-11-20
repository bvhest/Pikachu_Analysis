##!/bin/bash
#
# Signify STEP product database
#
# script om datamodel op te zetten en data te laden in de Neo4j database
# create neo4j database with Signify Product tree and mandatory attributes from csv-data:
#
# BvH, 2018-11-15
#

# product blue tree to category-nodes, including category links :
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuExports/WebcollageProducts/WebcollageProducts_ProductExport_20181022T0746_NL_master.xml -xsl:210_extractAwardAssets.xsl -o:../data/csv/awardAssets_global.csv

java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/PikachuExports/WebcollageProducts/WebcollageProducts_ProductExport_20181022T0746_nl_NL.xml -xsl:210_extractAwardAssets.xsl -o:../data/csv/awardAssets_nl_NL.csv
