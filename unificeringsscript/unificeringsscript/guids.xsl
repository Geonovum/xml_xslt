<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" 
    xmlns:ow="http://www.geostandaarden.nl/imow/owobject" 
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" 
    xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" 
    xmlns:k="http://www.geostandaarden.nl/imow/kaart" 
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" 
    xmlns:p="http://www.geostandaarden.nl/imow/pons" 
    xmlns:r="http://www.geostandaarden.nl/imow/regels" 
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" 
    xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" 
    xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" 
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
    xmlns:lvbb="http://www.overheid.nl/2017/lvbb"
    xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    
    xmlns:foo="http://whatever"
    >
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
    
    <xsl:param name="oldGUID"/>
    <xsl:param name="newGUID"/>


    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="basisgeo:id[text()=$oldGUID]">
        <xsl:element name="basisgeo:id">
            <xsl:value-of select="translate(.,$oldGUID,$newGUID)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@gml:id[contains(.,$oldGUID)]">
        <xsl:attribute name="gml:id">
            <xsl:value-of select="translate(.,$oldGUID,$newGUID)"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@xlink:href[contains(.,$oldGUID)]">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="translate(.,$oldGUID,$newGUID)"/>
        </xsl:attribute>
    </xsl:template>

</xsl:stylesheet>