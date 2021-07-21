<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:foo="http://whatever">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <xsl:param name="alreadyRetrievedDateTime"/>


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Kaart -->
    <xsl:template match="k:identificatie">
        <xsl:element name="k:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>
    <!-- Regel -->
    <xsl:template match="r:identificatie">
        <xsl:element name="r:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>
    <!-- VrijeTekst -->
    <xsl:template match="vt:identificatie">
        <xsl:element name="vt:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>
    <!-- RegelsOpLocatie -->
    <xsl:template match="rol:identificatie">
        <xsl:element name="rol:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>
    <!-- Gebiedsaanwijzing -->
    <xsl:template match="ga:identificatie">
        <xsl:element name="ga:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>
    <!-- Locatie -->
    <xsl:template match="l:Ambtsgebied/l:identificatie">
        <xsl:element name="l:identificatie">
            <xsl:value-of select="text()"/>
        </xsl:element>
    </xsl:template>
    <!-- Locatie -->
    <xsl:template match="l:identificatie">
        <xsl:element name="l:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>
    <!-- pons -->
    <xsl:template match="p:identificatie">
        <xsl:element name="p:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>
    <!-- Regelingsgebied -->
    <xsl:template match="rg:identificatie">
        <xsl:element name="rg:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>
    <!-- References -->
    <xsl:template match="@xlink:href">
        <xsl:attribute name="xlink:href">
            <xsl:choose>
                <xsl:when test="contains(., '.')">
                    <xsl:value-of select="foo:generateOWId(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <!-- Activiteitrefs niet aanraken, worden in aparte routine afgehandeld -->
    <xsl:template match="rol:bovenliggendeActiviteit/rol:ActiviteitRef/@xlink:href">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="rol:gerelateerdeActiviteit/rol:ActiviteitRef/@xlink:href">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>


    <xsl:function name="foo:generateOWId">
        <xsl:param name="owId" as="xs:string"/>
        <!-- max length 4th part of Id has a max-length of 32-->
        <xsl:variable name="tokenLength" as="xs:integer" select="string-length(tokenize($owId, '\.')[4])"/>
        <xsl:variable name="dateLength" as="xs:integer" select="string-length($alreadyRetrievedDateTime)"/>
        <xsl:variable name="startingloc" as="xs:integer" select="$dateLength - (32 - $tokenLength) + 1"/>
        <xsl:variable name="lastPart">
            <xsl:if test="not($startingloc > $dateLength)">
                <xsl:value-of select="concat(tokenize($owId, '\.')[4], substring($alreadyRetrievedDateTime, $startingloc))"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$startingloc > $dateLength">
                <xsl:value-of select="'Oorspronkelijke string te lang, niet mogelijk om nieuwe ID-string te berekenen'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', $lastPart)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
