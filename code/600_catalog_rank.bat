REM ##!/bin/bash
REM #
REM # Extract rank-values in STEP_cross_country_catalog
REM #
REM # BvH, 2019-05-17
REM #

@echo on

REM # product blue tree to category-nodes, including category links :

set mydir="%~1"
if not defined mydir set mydir=".."

set src="%mydir%/data/STEP/cross_country_catalog/catalog_entries_cross_contexts_PROD_exported.xml"
set trg="%mydir%/data/csv/600_catalog_rank.csv"
set xslt="%mydir%/code/600_catalog_rank.xsl"

java -cp C:\Java\Saxon/saxon9he.jar net.sf.saxon.Transform -t -s:%src% -xsl:%xslt% -o:%trg%
