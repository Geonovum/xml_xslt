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
    
    <xsl:param name="oldOWId"/>
    <xsl:param name="newOWId"/>
    
    <xsl:variable name="dateTime" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][h01][m01][s01]')"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="r:identificatie">
        <xsl:element name="r:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="vt:identificatie">
        <xsl:element name="vt:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="rol:identificatie">
        <xsl:element name="rol:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="ga:identificatie">
        <xsl:element name="ga:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:identificatie">
        <xsl:element name="l:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p:identificatie">
        <xsl:element name="p:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="k:identificatie">
        <xsl:element name="k:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="rg:identificatie">
        <xsl:element name="rg:identificatie">
            <xsl:value-of select="foo:generateOWId(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@xlink:href">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="foo:generateOWId(.)"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:function name="foo:generateOWId">
        <xsl:param name="owId" as="xs:string"/>
        <xsl:message select="'--------------------------'"></xsl:message>
        <xsl:message select="$owId"></xsl:message>
        <!-- max length 4th part of Id has a max-length of 32-->
        <xsl:variable name="maxLength" select="32 - string-length(tokenize($owId, '\.')[4])"/>
        <xsl:message select="$maxLength"></xsl:message>
        <xsl:choose>
            <xsl:when test="$maxLength > 13">
                <xsl:variable name="dateString" select="$dateTime"/>
                <xsl:message select="concat('a:',string-length(concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4], $dateString))-string-length($owId))"></xsl:message>
                <xsl:message select="string-length(concat(tokenize($owId, '\.')[4], $dateString))"/>
                <xsl:message select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4], $dateString)"/>
                <xsl:value-of select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4], $dateString)"/>
            </xsl:when>
            <xsl:when test="$maxLength > 0 and $maxLength &lt; 14">
                <xsl:variable name="dateString" select="substring($dateTime, 14 - $maxLength+1)"/>
                <xsl:message select="concat('b:',string-length(concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4], $dateString))-string-length($owId))"/>
                <xsl:message select="string-length(concat(tokenize($owId, '\.')[4], $dateString))"/>
                <xsl:message select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4], $dateString)"/>
                <xsl:value-of select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4], $dateString)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message select="concat('c:',string-length(concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4]))-string-length($owId))"/>
                <xsl:message select="string-length(tokenize($owId, '\.')[4])"/>
                <xsl:message select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4])"/>
                <xsl:value-of select="concat(tokenize($owId, '\.')[1], '.', tokenize($owId, '\.')[2], '.', tokenize($owId, '\.')[3], '.', tokenize($owId, '\.')[4])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>