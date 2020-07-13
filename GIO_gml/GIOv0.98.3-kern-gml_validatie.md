GIO gml geografische validatie voor versie 1.0

==> De gml's moeten volgens de GIO v.0.98.3-kern schema's valide zijn en de extensie .gml hebben
==> GDAL tooling moet geïnstalleerd zijn. Deze komt mee met QGIS of kan van https://www.gisinternals.com/release.php gedownload en geïnstalleerd worden.

- plaats 'Validate_GIO-gml_v0.98.3-kern.bat' in de folder met de gml's
- wijzig in het 'Validate_GIO-gml_v1.0.bat' het pad naar de ogr2ogr.exe en de ogrinfo.exe (is afhankelijk van lokale installatie)
- dubbelklik 'Validate_GIO-gml_v1.0.bat' of run vanuit cmd shell

In het bestand 'Validate_result.txt' staan alle bestanden, .
"
file: "Bedrijf_categorie_2.gml"
INFO: Open of `Bedrijf_categorie_2'
      using driver `SQLite' successful.

Layer name: geometrie
Geometry: Multi Polygon
Feature Count: 0
Layer SRS WKT:
PROJCS["Amersfoort / RD New",
    GEOGCS["Amersfoort",
        DATUM["Amersfoort",
            SPHEROID["Bessel 1841",6377397.155,299.1528128,
                AUTHORITY["EPSG","7004"]],
            TOWGS84[565.4171,50.3319,465.5524,-0.398957388243,0.343987817378,-1.87740163998,4.0725],
            AUTHORITY["EPSG","6289"]],
        PRIMEM["Greenwich",0,
            AUTHORITY["EPSG","8901"]],
        UNIT["degree",0.0174532925199433,
            AUTHORITY["EPSG","9122"]],
        AUTHORITY["EPSG","4289"]],
    PROJECTION["Oblique_Stereographic"],
    PARAMETER["latitude_of_origin",52.1561605555556],
    PARAMETER["central_meridian",5.38763888888889],
    PARAMETER["scale_factor",0.9999079],
    PARAMETER["false_easting",155000],
    PARAMETER["false_northing",463000],
    UNIT["metre",1,
        AUTHORITY["EPSG","9001"]],
    AXIS["X",EAST],
    AXIS["Y",NORTH],
    AUTHORITY["EPSG","28992"]]
Data axis to CRS axis mapping: 1,2
FID Column = ogc_fid
Geometry Column = GEOMETRY
id: String (0.0)
"

Bij fouten worden GEOS meldingen gegeven:
Onder file:...
GEOS warning: Ring Self-intersection at or near point 116356.19488068701 456951.24181609601

Aan het eind van de lijst van de layer:
OGRFeature(Bedrijf_categorie_2):1
  POLYGON : 2298 points, 2 inner rings (37 points, 441 points)

Na de validatie blijven de SQLite bestanden in de folder achter, deze kunnen verwijderd worden.
Eventueel kunnen ze ook gebruikt worden voor verdere analyse met SQL statements.