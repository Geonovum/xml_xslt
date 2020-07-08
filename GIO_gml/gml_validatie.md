GIO gml geografische validatie voor versie 1.0

==> De gml's moeten de GIO v.10 schema's valide zijn en de extensie .gml hebben
==> GDAL tooling moet geïnstalleerd zijn. Deze komt mee met QGIS of kan van https://www.gisinternals.com/release.php gedownload en geïnstalleerd worden.

- plaats 'Validate_GIO-gml_v1.0.bat' en 'GIO_gml_Locatie_RDNew.gfs' in de folder met de gml's
- wijzig in het 'Validate_GIO-gml_v1.0.bat' het pad naar de ogr2ogr.exe en de ogrinfo.exe (is afhankelijk van lokale installatie)
- dubbelklik 'Validate_GIO-gml_v1.0.bat' of run vanuit cmd shell

In het bestand 'Validate_result.txt' staan alle bestanden die gevalideerd zijn met eventuele geconstateerde fouten.
"
INFO: Open of `Bedrijf_categorie_2'
      using driver `SQLite' successful.

Layer name: SELECT
Geometry: None
Feature Count: 0
Layer SRS WKT:
(unknown)
IsValid(geometrie): String (0.0)
"