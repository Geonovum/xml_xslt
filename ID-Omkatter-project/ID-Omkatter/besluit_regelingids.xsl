<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
    xmlns:manifest-ow="http://www.geostandaarden.nl/bestanden-ow/manifest-ow" xmlns:consolidatie="https://standaarden.overheid.nl/stop/imop/consolidatie/"
    xmlns:lvbbu="https://standaarden.overheid.nl/lvbb/stop/uitlevering/" xmlns:foo="http://whatever">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <xsl:param name="alreadyRetrievedDateTime"/>
    <xsl:param name="origineleregelingFRBRWork"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@wordt">
        <xsl:attribute name="wordt">
            <xsl:value-of select="foo:generateAKNFRBRExpression(.)"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@was">
        <xsl:attribute name="was">
            <xsl:value-of select="foo:generateAKNFRBRExpression(.)"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="consolidatie:FRBRWork">
        <xsl:message select="'consolidatie:FRBRWork'"/>
        <xsl:element name="consolidatie:FRBRWork">
            <xsl:value-of select="foo:generateAKNFRBRWork(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="consolidatie:FRBRExpression">
        <xsl:element name="consolidatie:FRBRExpression">
            <xsl:value-of select="foo:generateAKNFRBRExpression(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="consolidatie:instrumentVersie">
        <xsl:element name="consolidatie:instrumentVersie">
            <xsl:value-of select="foo:generateAKNFRBRExpression(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="lvbb:breekPublicatieAfOpdracht/lvbb:identificatie">
        <xsl:element name="identificatie" namespace="{namespace-uri()}">
            <xsl:value-of select="foo:generateAKNFRBRWork(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="data:BeoogdeRegelgeving/data:BeoogdeRegeling/data:instrumentVersie">
        <xsl:element name="data:instrumentVersie">
            <xsl:value-of select="foo:generateAKNFRBRExpression(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="data:heeftGeboorteregeling">
        <xsl:element name="data:heeftGeboorteregeling">
            <xsl:value-of select="foo:generateAKNFRBRWork(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="manifest-ow:WorkIDRegeling">
        <xsl:element name="manifest-ow:WorkIDRegeling">
            <xsl:value-of select="foo:generateAKNFRBRWork(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="data:ExpressionIdentificatie/data:FRBRWork">
        <xsl:message select="text()"></xsl:message>
        <xsl:message select="foo:generateAKNFRBRWork(text())"></xsl:message>
        <xsl:element name="data:FRBRWork">
            <xsl:value-of select="foo:generateAKNFRBRWork(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="data:ExpressionIdentificatie/data:FRBRExpression">
        <xsl:element name="data:FRBRExpression">
            <xsl:value-of select="foo:generateAKNFRBRExpression(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:function name="foo:generateAKNFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], '-', $alreadyRetrievedDateTime))"
        />
    </xsl:function>

    <xsl:function name="foo:generateAKNFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], '-', $alreadyRetrievedDateTime), '/', tokenize($oldId, '/')[8])"
        />
    </xsl:function>

</xsl:stylesheet>
