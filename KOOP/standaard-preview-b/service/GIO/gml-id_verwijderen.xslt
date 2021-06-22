<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0"
  xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
  xmlns:lvbbu="https://standaarden.overheid.nl/lvbb/stop/uitlevering/"
  xmlns:se="http://www.opengis.net/se"
  xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" 
  xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Verwijderen van gml:id in GIO's
    Niet meer nodig ivm. overgang naar GML3.2.2 en basisgeometrie 1-10-2020
  
  Arjan.Dorrepaal@koop.overheid.nl
  -->

  <xsl:output encoding="UTF-8" indent="yes" />

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no" exclude-result-prefixes="#all">
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template> 
   
  <xsl:template match="basisgeo:Geometrie|gml:Polygon|gml:LineString|gml:Surface|gml:LinearRing|gml:Point|gml:MultiPoint|gml:MultiSurface">
    <xsl:copy>
       <xsl:copy select="@* except @gml:id"/>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template> 
  
</xsl:stylesheet> 