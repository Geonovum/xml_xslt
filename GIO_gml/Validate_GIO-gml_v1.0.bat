-- Op basis van GIO v1.0 met GFS template GIO_gml_Locatie_RDNew.gfs (plaatsen in de folder met gml's)
-- maakt van alle gml's in een folder een SQLite db met als naam de bestandsnaam zonder .gml
SET GML_EXPOSE_GML_ID=No
FORFILES /m *.gml /C "cmd /c D:\Apps\QGIS\OSGeo4W64\bin\ogr2ogr.exe -f "SQLite" -dsco SPATIALITE=YES @fname @file -oo GFS_TEMPLATE=GIO_gml_Locatie_RDNew.gfs"
FORFILES /m *.gml /C "cmd /c D:\Apps\QGIS\OSGeo4W64\bin\ogrinfo.exe @fname -where IsValid(geometrie)=0 -al -geom=summary -fields=NO -noextent -wkt_format WKT1" >>Validate_result.txt"