java -cp saxon9he.jar net.sf.saxon.Transform -t -s:Untitled.sch -xsl:iso_svrl_for_xslt2.xsl -o:Untitled.xsl

for /r %%i in (*.xml) do java -cp saxon9he.jar net.sf.saxon.Transform -t -s:"%%~nxi" -xsl:Untitled.xsl -o:"%%~nxi.txt"

