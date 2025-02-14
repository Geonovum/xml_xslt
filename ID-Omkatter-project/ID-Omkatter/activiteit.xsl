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
    <xsl:param name="lokaleActiviteitRelatie"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="rol:bovenliggendeActiviteit/rol:ActiviteitRef/@xlink:href">
        <xsl:attribute name="xlink:href">
            <xsl:choose>
                <xsl:when test=". = $lokaleActiviteitRelatie">
                    <xsl:value-of select="foo:generateOWId(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="rol:gerelateerdeActiviteit/rol:ActiviteitRef/@xlink:href">
        <xsl:attribute name="xlink:href">
            <xsl:choose>
                <xsl:when test=". = $lokaleActiviteitRelatie">
                    <xsl:value-of select="foo:generateOWId(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:function name="foo:generateOWId">
        <xsl:param name="owId" as="xs:string"/>
        <!-- max length 4th part of Id has a max-length of 32-->
        <xsl:variable name="maxLength" select="32 - string-length(tokenize($owId, '\.')[4])"/>
        <xsl:choose>
            <xsl:when test="$maxLength > 13">
                <xsl:variable name="dateString" select="$alreadyRetrievedDateTime"/>
                <xsl:value-of select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4], $dateString)"/>
            </xsl:when>
            <xsl:when test="$maxLength > 0 and $maxLength &lt; 14">
                <xsl:variable name="dateString" select="substring($alreadyRetrievedDateTime, 14 - $maxLength + 1)"/>
                <xsl:value-of select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4], $dateString)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
