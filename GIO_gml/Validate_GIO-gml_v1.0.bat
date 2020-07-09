@ECHO OFF
ECHO Op basis van GIO v1.0 met GFS template GIO_gml_Locatie_RDNew.gfs (plaatsen in de folder met gml's)
ECHO maakt van alle gml's in een folder een SQLite db met als naam de bestandsnaam van de gml met .db als extensie

SET GML_EXPOSE_GML_ID=No
FORFILES /m *.gml /C "cmd /c D:\Apps\QGIS\OSGeo4W64\bin\ogr2ogr.exe -f "SQLite" -dsco SPATIALITE=YES @fname @file -oo GFS_TEMPLATE=GIO_gml_Locatie_RDNew.gfs"
FORFILES /m *.gml /C "cmd /c ECHO ====== >>validate_results.txt & ECHO file: @file >>validate_results.txt & D:\Apps\QGIS\OSGeo4W64\bin\ogrinfo.exe @fname -al -geom=summary -where IsValid(geometry)=0 -fields=NO -wkt_format WKT1 >>validate_results.txt 2>&1"