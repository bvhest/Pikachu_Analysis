REM ##!/bin/bash
REM #
REM # Extract rank-values in STEP_cross_country_catalog
REM #
REM # BvH, 2019-17-05
REM #

REM # product blue tree to category-nodes, including category links :
java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:../data/STEP_cross_country_catalog/catalog_entries_cross_contexts_PROD_exported.xml -xsl:600_catalog_rank.xsl -o:../data/csv/600_catalog_rank.csv
