# GIO gml openen in QGIS (OGR tooling)

De gml's die voor versie 1.0 van de standaard worden gemaakt zijn vaak niet makkelijk te openen in een programma zoals QGIS.

Met het 'GIO_gml_Locatie_RDNew.gfs' moet dat wel lukken voor gml's in RD_New stelsel.
Het is voor polygonen en het kan zijn dat het bij hele complexe gml's niet werkt.


## Werkwijze per bestand
Voordat je een gml in QGIS (of een ander programma dat de OGR tooling gebruikt) gaat openen, kan je dat bestand in de directory bij de gml kopieren en het dezelfde naam geven als het gml bestand.
Dus als je Gebied.gml wilt openen, moet je het gekopieerde GIO_gml_Locatie_RDNew.gfs bestand hernoemen naar Gebied.gfs



## Voor elke GIO via gml_registry.xml
Het is mogelijk om er voor zorgen dat elke GIO vanzelf goed geopend word.
In de folder {installatie folder OSGeo4W64}\share\gdal staat het bestand 'gml_registry.xml'.
Hierin kunnen verwijzingen naar gfs bestanden opgenomen worden op basis van de namespace van de toepassing.

Voor de DSO GIO's:
Wijzig het 'gml_registry.xml' bestand (vermoedelijk administrator rechten nodig) en voeg het volgende stuk xml toe: 

    <namespace prefix="geo" uri="https://standaarden.overheid.nl/stop/imop/geo/" useGlobalSRSName="true">
        <featureType elementName="Locatie" gfsSchemaLocation="GIO_gml_Locatie_RDNew.gfs"/>
    </namespace>
    
Plaats de 'GIO_gml_Locatie_RDNew.gfs' in dezelfde folder.
