<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:lvbb_intern="http://www.overheid.nl/2020/lvbb/intern"  xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:foo="http://whatever">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <xsl:param name="newId"/>
    <xsl:param name="consolidatie"/>
    <xsl:param name="alreadyRetrievedDateTime"/>

    <!-- Datum voor template datum-bekendmaking -->
    <xsl:variable name="date" select="format-dateTime(current-dateTime() + xs:dayTimeDuration('P1D'), '[Y0001]-[M01]-[D01]')"/>

    <!-- ********   LET OP EN LEES DIT !!!!! ********** -->
    <!-- HAAL (indien nodig/gewenst) DE comment-tekens BIJ DE *CODE* WEG -->
    <!-- VUL DAN HIER UW ID's IN, LET OP DE QUOTES (EEN MAAL DUBBEL, EEN MAAL ENKEL, bijv: "'XXX'") -->
    <!-- Als u dit niet goed doet worden de strings gezien als een nummer en worden de voorloop-nullen weggehaald! -->
    <!-- ********   *CODE* (hieronder) ********** -->
    <!--
    <xsl:variable name="idBevoegdGezag" select="'00000001003214345000'"/>
    <xsl:variable name="idAanleveraar" select="'00000001003214345000'"/>
    
    <xsl:template match="lvbb:idAanleveraar">
        <xsl:element name="lvbb:idAanleveraar">
            <xsl:value-of select="$idAanleveraar"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="lvbb:idBevoegdGezag">
        <xsl:element name="lvbb:idBevoegdGezag">
            <xsl:value-of select="$idBevoegdGezag"/>
        </xsl:element>
    </xsl:template>
    -->


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="sl:leveringsId">
        <xsl:choose>
            <xsl:when test="$consolidatie = '0'">
                <xsl:element name="sl:leveringsId">
                    <xsl:value-of select="$newId"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="sl:leveringsId">
                    <xsl:value-of select="concat(text(), '-', $alreadyRetrievedDateTime)"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="lvbb:datumBekendmaking">
        <xsl:element name="datumBekendmaking" namespace="{namespace-uri()}">
            <xsl:value-of select="$date"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="lvbb:idLevering">
        <xsl:element name="idLevering" namespace="{namespace-uri()}">
            <xsl:value-of select="$newId"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="lvbb_intern:idLevering">
        <xsl:element name="idLevering" namespace="{namespace-uri()}">
            <xsl:value-of select="$newId"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
