ECHO OFF
ECHO Op basis van GIO v1.0 met GFS template GIO_gml_Locatie_RDNew.gfs (plaatsen in de folder met gml's)
ECHO maakt van alle gml's in een folder een SQLite db met als naam de bestandsnaam zonder .gml

FORFILES /m *.gml /C "cmd /c D:\Apps\QGIS\OSGeo4W64\bin\ogr2ogr.exe -f "SQLite" -dsco SPATIALITE=YES @fname @file"
FORFILES /m *.gml /C "cmd /c D:\Apps\QGIS\OSGeo4W64\bin\ogrinfo.exe @fname -where IsValid(geometry)=0 -al -geom=summary -fields=NO -noextent -wkt_format WKT1" >>Validate_result.txt"