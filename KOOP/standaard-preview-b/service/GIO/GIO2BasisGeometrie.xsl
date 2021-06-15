<?xml version="1.0"?>
<!--
     XSLT die uit een GIO alle Locaties selecteert
     en in een FeatureCollection stopt die in QGIS kan worden ingelezen.

     Wilko Quak (wilko.quak@koop.overheid.nl)
-->
<xsl:stylesheet version="2.0"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/"
    exclude-result-prefixes="gio">

    <xsl:output method="xml" version="1.0"
        encoding="UTF-8" indent="yes"/>
 
    <xsl:template match="/">
	<basisgeo:FeatureCollectionGeometrie>
        <!-- Kopieer alle geometrieen -->  
        <xsl:apply-templates select="//basisgeo:Geometrie" />
	</basisgeo:FeatureCollectionGeometrie>     
    </xsl:template>
            
    <xsl:template match="basisgeo:Geometrie">
        <basisgeo:featureMember>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </basisgeo:featureMember>  
    </xsl:template>
 </xsl:stylesheet>
