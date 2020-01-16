<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Maakt van geometrieen in een GML GeoInformatieobjecten die in een GIO bestand thuishoren

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    >
    
    <xsl:output encoding="UTF-8"/>
    <xsl:variable name="bestand" select="'zeewaarts_gebied'"/>

    <xsl:template match="/">
        <xsl:variable name="GIO_Locaties">
            <xsl:element name="GeoInformatie" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                
                <xsl:for-each select="/geo:FeatureCollectionGeometrie/geo:featureMember">
                    <xsl:variable name="geoGuid" select="*//geo:id/text()"/>
                    <xsl:element name="featureMember" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                        <xsl:element name="Locatie" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                            <xsl:attribute name="gml:id" select="concat($bestand,'_',position())"></xsl:attribute>
                            <xsl:element name="wId" namespace="https://standaarden.overheid.nl/stop/imop/geo/"><xsl:value-of select="concat($bestand,'_',position())"/></xsl:element>
                            <xsl:element name="geometrie" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                                <xsl:attribute name="xlink:href" select="concat($bestand,'.gml#',$geoGuid)"></xsl:attribute>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:variable>
        <xsl:result-document href="GIOLocatie.xml">
            <xsl:copy-of select="$GIO_Locaties"/>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>