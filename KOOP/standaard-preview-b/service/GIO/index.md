# Service scripts voor GIO's

- In de keten word de losse geometrie soms in een eigen bestand gezet volgens het
  [basisgeometrie schema](https://docs.geostandaarden.nl/nen3610/basisgeometrie/).
  Het [GIO2BasisGeometrie.xsl](GIO2BasisGeometrie.xsl) haalt op de juiste wijze de
  geometrieën uit een GIO. 
- Een GIO GML bestand is niet rechtstreeks te openen in QGis. Het
  conversiescript [GIO2Qgis.xsl](GIO2Qgis.xsl) converteert de GIO naar een
  bestand dat wel te openen is in QGIS.
- Transformatie [ SymbologyEncoding2StyledLayerDescriptor.xsl](
  SymbologyEncoding2StyledLayerDescriptor.xsl) In de STOP standaard worden bij een GML bestand de gebruikte symbolisatie
  vastgelegd in een bestand dat voldoet aan de OGC standaard voor
  Symbology Encoding. Deze transformatie converteert de encoding in een sld dat
  rechtstreeks bruikbaar is in QGIS.
- In GML versie 3.2.2 is gml:id op elk gml element optioneel geworden (waren in GML 3.2.1 verplicht). De basisgeometrie standaard is nu ook aangepast waardoor gml:id ook voor STOP optioneel geworden is. Met [gml-id-verwijderen.xlst](gml-id-verwijderen.xlst) worden de gml:id's verwijdert uit een .gml bestand.
