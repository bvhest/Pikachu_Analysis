#!/bin/bash
for i in `find . -name *.xmap -print`
do
echo $i
ex $i <<EOF
g/oracleDb/s/oracleDb/oracleDbCMC/
w
q
EOF
done

