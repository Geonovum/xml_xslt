#!/bin/bash
set -x

echo aangeroepen met $1

echo 'digraph besluit {' > $1.dot
echo '    node [shape=box];' >> $1.dot
echo "/* Makefile gio2graph */" >> $1.dot
xsltproc  gio2graph.xsl $1/IO*/JuridischeBorgingVan.xml >> $1.dot
echo "/* Makefile ow2graph */" >> $1.dot
#xsltproc  ow2graph.xsl $1/OW-bestanden/*.xml >> $1.dot
echo "/* Makefile gio2graph pakbon */" >> $1.dot
xsltproc  gio2graph.xsl $1/pakbon.xml >> $1.dot 
echo "/* Makefile klaar pakbon */" >> $1.dot
echo '}' >> $1.dot

dot -O -Tsvg $1.dot
